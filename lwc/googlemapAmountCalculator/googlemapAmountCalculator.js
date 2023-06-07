import { LightningElement } from 'lwc';
import getAddress from '@salesforce/apex/MapController.getAddress';
import getAddressDetailsByPlaceId from '@salesforce/apex/MapController.getPlaceDetails';
import getDistanceCost from '@salesforce/apex/MapController.getDistanceCost';



export default class SearchAPIAddress extends LightningElement {
    addressRecommendations = [];
    selectedAddress = '';
    addressDetail = {};
    city;
    country;
    pincode;
    state;

    addressRecommendations2 = [];
    selectedAddress2 = '';
    addressDetail2 = {};
    city2;
    country2;
    pincode2;
    state2;
    place_id1;
    place_id2;
    searchWrapper = [];


    modeTrans = 'DRIVING';

    get options() {
        return [
            { label: 'BICYCLING', value: 'bicycling' },
            { label: 'DRIVING', value: 'driving' },
            { label: 'TRANSIT', value: 'transit' },
            { label: 'WALKING', value: 'walking' },

        ];
    }
    x
    handleChangemodeTrans(event) {
        this.modeTrans = event.detail.value;
    }


    get hasRecommendations() {
        return (this.addressRecommendations !== null && this.addressRecommendations.length);
    }


    get hasRecommendations2() {
        return (this.addressRecommendations2 !== null && this.addressRecommendations2.length);
    }


    handleChange(event) {
        console.log('ererer');
        var source = event.target.name;
        event.preventDefault();
        let searchText = event.target.value;
        if (searchText) this.getAddressRecommendations(searchText, event.target.name);
        if (source == 'searchAddressSour') {
            this.addressRecommendations = [];
        } else {
            this.addressRecommendations2 = [];

        }

    }



    calculateDistance(event) {
        getDistanceCost({ place_id1: this.place_id1, place_id2: this.place_id2, modeTrans: this.modeTrans })
            .then(response => {
                this.searchWrapper = response;
            }).catch(error => {
                console.log('error : ' + JSON.stringify(error));
            });



    }


    getAddressRecommendations(searchText, source) {
        getAddress({ searchString: searchText })
            .then(response => {

                this.addressRecommendations = [];


                let addressRecommendations = [];
                response.forEach(prediction => {
                    addressRecommendations.push({
                        main_text: prediction.AddComplete,
                        secondary_text: prediction.AddComplete,
                        place_id: prediction.placeId,
                    });
                });

                if (source == 'searchAddressSour') {

                    this.addressRecommendations = addressRecommendations;
                } else {
                    this.addressRecommendations2 = addressRecommendations;

                }
            }).catch(error => {
                console.log('error : ' + JSON.stringify(error));
            });
    }


    handleAddressRecommendationSelect(event) {
        console.log('ererer');
        event.preventDefault();
        let placeId = event.currentTarget.dataset.value;
        this.addressRecommendations = [];
        this.addressRecommendations2 = [];
        var source = event.currentTarget.getAttribute("name");

        getAddressDetailsByPlaceId({ placeId: placeId })
            .then(response => {
                if (source == 'source') {
                    this.city = '';
                    this.country = '';
                    this.pincode = '';
                    this.state = '';
                    this.selectedAddress = '';

                    response = JSON.parse(response.responseBody);
                    this.place_id1 = response.result.place_id;
                    console.log('place_id1' + this.place_id1);
                    response.result.address_components.forEach(address => {
                        let type = address.types[0];
                        switch (type) {
                            case 'locality':
                                this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                                this.city = address.long_name;
                                break;
                            case 'country':
                                this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                                this.country = address.long_name;
                                break;
                            case 'administrative_area_level_1':
                                this.selectedAddress = this.selectedAddress + ' ' + address.short_name;
                                this.state = address.short_name;
                                break;
                            case 'postal_code':
                                this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                                this.pincode = address.long_name;
                                break;
                            case 'sublocality_level_2':
                                this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                                this.addressDetail.subLocal2 = address.long_name;
                                break;
                            case 'sublocality_level_1':
                                this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                                this.addressDetail.subLocal1 = address.long_name;
                                break;
                            case 'street_number':
                                this.selectedAddress = this.selectedAddress + ' ' + address.long_name;
                                this.addressDetail.streetNumber = address.long_name;
                                break;
                            case 'route':
                                this.selectedAddress = this.selectedAddress + ' ' + address.short_name;
                                this.addressDetail.route = address.short_name;
                                break;
                            default:
                                break;
                        }
                    });
                } else {
                    this.city2 = '';
                    this.country2 = '';
                    this.pincode2 = '';
                    this.state2 = '';
                    this.selectedAddress2 = '';

                    response = JSON.parse(response.responseBody);
                    this.place_id2 = response.result.place_id;
                    console.log('place_id2' + this.place_id2);

                    response.result.address_components.forEach(address => {
                        let type = address.types[0];
                        switch (type) {
                            case 'locality':
                                this.selectedAddress2 = this.selectedAddress2 + ' ' + address.long_name;
                                this.city2 = address.long_name;
                                break;
                            case 'country':
                                this.selectedAddress2 = this.selectedAddress2 + ' ' + address.long_name;
                                this.country2 = address.long_name;
                                break;
                            case 'administrative_area_level_1':
                                this.selectedAddress2 = this.selectedAddress2 + ' ' + address.short_name;
                                this.state2 = address.short_name;
                                break;
                            case 'postal_code':
                                this.selectedAddress2 = this.selectedAddress2 + ' ' + address.long_name;
                                this.pincode2 = address.long_name;
                                break;
                            case 'sublocality_level_2':
                                this.selectedAddress2 = this.selectedAddress2 + ' ' + address.long_name;
                                this.addressDetail2.subLocal2 = address.long_name;
                                break;
                            case 'sublocality_level_1':
                                this.selectedAddress2 = this.selectedAddress2 + ' ' + address.long_name;
                                this.addressDetail2.subLocal1 = address.long_name;
                                break;
                            case 'street_number':
                                this.selectedAddress2 = this.selectedAddress2 + ' ' + address.long_name;
                                this.addressDetail2.streetNumber = address.long_name;
                                break;
                            case 'route':
                                this.selectedAddress2 = this.selectedAddress2 + ' ' + address.short_name;
                                this.addressDetail2.route = address.short_name;
                                break;
                            default:
                                break;
                        }
                    });

                }

            })
            .catch(error => {
                console.log('error : ' + JSON.stringify(error));
            });
    }


}