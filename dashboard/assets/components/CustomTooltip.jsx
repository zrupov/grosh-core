// @flow

// Copyright 2018 The go-grosh Authors
// This file is part of the go-grosh library.
//
// The go-grosh library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-grosh library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-grosh library. If not, see <http://www.gnu.org/licenses/>.

import React, {Component} from 'react';

import Typography from '@material-ui/core/Typography';
import {styles, simplifyBytes} from '../common';

// multiplier multiplies a number by another.
export const multiplier = <T>(by: number = 1) => (x: number) => x * by;

// percentPlotter renders a tooltip, which displays the value of the payload followed by a percent sign.
export const percentPlotter = <T>(text: string, mapper: (T => T) = multiplier(1)) => (payload: T) => {
	const p = mapper(payload);
	if (typeof p !== 'number') {
		return null;
	}
	return (
		<Typography type='caption' color='inherit'>
			<span style={styles.light}>{text}</span> {p.toFixed(2)} %
		</Typography>
	);
};

// bytePlotter renders a tooltip, which displays the payload as a byte value.
export const bytePlotter = <T>(text: string, mapper: (T => T) = multiplier(1)) => (payload: T) => {
	const p = mapper(payload);
	if (typeof p !== 'number') {
		return null;
	}
	return (
		<Typography type='caption' color='inherit'>
			<span style={styles.light}>{text}</span> {simplifyBytes(p)}
		</Typography>
	);
};

// bytePlotter renders a tooltip, which displays the payload as a byte value followed by '/s'.
export const bytePerSecPlotter = <T>(text: string, mapper: (T => T) = multiplier(1)) => (payload: T) => {
	const p = mapper(payload);
	if (typeof p !== 'number') {
		return null;
	}
	return (
		<Typography type='caption' color='inherit'>
			<span style={styles.light}>{text}</span>
			{simplifyBytes(p)}/s
		</Typography>
	);
};

export type Props = {
	active: boolean,
	payload: Object,
	tooltip: <T>(text: string, mapper?: T => T) => (payload: mixed) => null | React$Element<any>,
};

// CustomTooltip takes a tooltip function, and uses it to plot the active value of the chart.
class CustomTooltip extends Component<Props> {
	render() {
		const {active, payload, tooltip} = this.props;
		if (!active || typeof tooltip !== 'function' || !Array.isArray(payload) || payload.length < 1) {
			return null;
		}
		return tooltip(payload[0].value);
	}
}

export default CustomTooltip;
