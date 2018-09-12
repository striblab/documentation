const React = require('react');
const ReactBarChart = require('react-chartjs-2').Bar;

class BarChart extends React.Component {
  render() {
    const { idyll, hasError, updateProps, ...props } = this.props;
    return <ReactBarChart {...props} />;
  }
}

module.exports = BarChart;
