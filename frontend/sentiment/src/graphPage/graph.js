import React, { useEffect, useState, useRef } from 'react';
import Chart from 'chart.js/auto';

const BarChart = ({ data }) => {
    const chartRef = useRef(null);
    const [chart, setChart] = useState(null);

    useEffect(() => {
        if (!chartRef.current || !data) return;
    
        // Destroy the previous chart if it exists
        if (chart) {
            chart.destroy();
        }
    
        const stackedData = data.map(entry => ({
            date: entry.date,
            positive: entry.percentages.POSITIVE,
            negative: entry.percentages.NEGATIVE,
            neutral: entry.percentages.NEUTRAL,
            total: entry.percentages.POSITIVE + entry.percentages.NEUTRAL, // Sum of Positive and Neutral
        }));
    
        const ctx = chartRef.current.getContext('2d');
        const newChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: stackedData.map(entry => entry.date),
                datasets: [{
                    label: 'Positive',
                    data: stackedData.map(entry => entry.positive),
                    backgroundColor: 'rgba(75, 192, 192, 0.5)', // Light blue color for Positive
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                }, {
                    label: 'Neutral',
                    data: stackedData.map(entry => entry.neutral),
                    backgroundColor: 'rgba(255, 206, 86, 0.5)', // Light yellow color for Neutral
                    borderColor: 'rgba(255, 206, 86, 1)',
                    borderWidth: 1
                }, {
                    label: 'Negative',
                    data: stackedData.map(entry => entry.negative),
                    backgroundColor: 'rgba(255, 99, 132, 0.5)', // Light red color for Negative
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        stacked: true
                    }
                }
            }
        });
    
        setChart(newChart);
    
        return () => {
            newChart.destroy();
        };
    }, [data]);


    return <canvas ref={chartRef} />;
};

export default BarChart;