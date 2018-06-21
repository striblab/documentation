const React = require('react');
const ReactLineChart = require('react-chartjs-2').Line;

class LineChart extends React.Component {
  render() {
    const { idyll, hasError, updateProps, ...props } = this.props;
    return <ReactLineChart {...props} />;
  }
}

module.exports = LineChart;
