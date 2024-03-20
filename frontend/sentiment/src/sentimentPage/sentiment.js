import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { format } from 'date-fns';
import BarChart from '../graphPage/graph';
import loader from '../loadingPage/loader.gif'; // Import the loader GIF

const SentimentsPage = () => {
    const { productId } = useParams();
    const [sentiments, setSentiment] = useState([]);
    const [isLoading, setIsLoading] = useState(true); // State to control loading state

    useEffect(() => {
        const fetchSentiments = async () => {
            try {
                const response = await fetch(`http://${process.env.REACT_APP_AWS_EC2_EIP}:5000/sentiments/${productId}`);
                const data = await response.json();
                const sortedSentiments = data.sort((a, b) => {
                    return new Date(a.reviewDate) - new Date(b.reviewDate);
                });
                const groupSentiment = groupSentimentByDate(sortedSentiments);
                const formatedData = sentimentCalculator(groupSentiment);
                setSentiment(formatedData); 
                setIsLoading(false); // Set loading state to false after fetching data
            } catch (error) {
                console.error('Error fetching sentiments:', error);
                setIsLoading(false); // Set loading state to false in case of error
            }
        };

        fetchSentiments();
    }, [productId]);

    const groupSentimentByDate = (sentiments) => {
        return sentiments.reduce((acc, sentiment) => {
            const date = format(new Date(sentiment.reviewDate), 'MMM yyyy');
            acc[date] = acc[date] || [];
            acc[date].push(sentiment);
            return acc;
        }, {});
    };

    const sentimentCalculator = (groupSentiments) => {
        const calculatedData = []
        for (const date in groupSentiments) {
            const sentiments = groupSentiments[date];
            const sentimentCounts = {
                POSITIVE: 0,
                NEGATIVE: 0,
                MIXED: 0,
                NEUTRAL: 0
            };
            sentiments.forEach( sentiment => {
                sentimentCounts[sentiment.sentiment]++;
            });
            const percentages = {
                POSITIVE: (sentimentCounts.POSITIVE / sentiments.length) *100,
                NEGATIVE: (sentimentCounts.NEGATIVE / sentiments.length) *-100,
                // MIXED: (sentimentCounts.MIXED / sentiments.length) *100,
                NEUTRAL: ((sentimentCounts.NEUTRAL + sentimentCounts.MIXED) / sentiments.length) *100,
            };
            const sentimentVal = calculateSentimentValue(sentiments); // Calculate sentiment value
            calculatedData.push({
                date,
                percentages,
                sentimentVal // Include sentimentVal in the formatted data
            });
        }
        return calculatedData;
    };

    const calculateSentimentValue = (sentiments) => {
        let sentimentSum = 0;
        let totalSentiments = 0;
        
        sentiments.forEach(sentiment => {
            if (sentiment.sentiment === 'POSITIVE') {
                sentimentSum += 1;
                totalSentiments++;
            } else if (sentiment.sentiment === 'NEGATIVE') {
                sentimentSum -= 1;
                totalSentiments++;
            }else if (sentiment.sentiment === 'MIXED' || sentiment.sentiment === 'NEUTRAL') {
                totalSentiments++;
            }
        });
        
        return sentimentSum / totalSentiments;
    };

    return (
        <div>
            <h1> Sentiment </h1>

            {isLoading ? (
                <img src={loader} alt="Loading..." /> // Display loader GIF while loading
            ) : (
                <>
                    <BarChart data={sentiments} />
                </>
            )}
             
        </div>
        
    );
};

export default SentimentsPage;