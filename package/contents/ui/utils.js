function apiValueFromKelvin(kelvin) {

    // Returns a value used by the API from the given kelvin temperature.

    return Math.round(1000000 / kelvin);
}

function kelvinValueFromApi(value) {

    // Returns a value used by api converted to kelvin rounded to the closest number divisable by 50.

    const unrounded = 1000000 / value;

    return Math.round(unrounded / 50.0) * 50;
}
