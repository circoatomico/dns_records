require 'rails_helper'

RSpec.describe Api::V1::DnsRecordsController, type: :controller do
  let(:parsed_body) { JSON.parse(response.body, symbolize_names: true) }

  describe '#index' do
    context 'with the required page param' do
      let(:page) { 1 }

      let(:ip1) { '1.1.1.1' }
      let(:ip2) { '2.2.2.2' }
      let(:ip3) { '3.3.3.3' }
      let(:ip4) { '4.4.4.4' }
      let(:ip5) { '5.5.5.5' }
      let(:lorem) { 'lorem.com' }
      let(:ipsum) { 'ipsum.com' }
      let(:dolor) { 'dolor.com' }
      let(:amet) { 'amet.com' }
      let(:sit) { 'sit.com' }

      let(:payload1) do
        {
          dns_records: {
            ip: ip1,
            hostnames_attributes: [
              {
                hostname: lorem
              },
              {
                hostname: ipsum
              },
              {
                hostname: dolor
              },
              {
                hostname: amet
              }
            ]
          }
        }.to_json
      end

      let(:payload2) do
        {
          dns_records: {
            ip: ip2,
            hostnames_attributes: [
              {
                hostname: ipsum
              }
            ]
          }
        }.to_json
      end

      let(:payload3) do
        {
          dns_records: {
            ip: ip3,
            hostnames_attributes: [
              {
                hostname: ipsum
              },
              {
                hostname: dolor
              },
              {
                hostname: amet
              }
            ]
          }
        }.to_json
      end

      let(:payload4) do
        {
          dns_records: {
            ip: ip4,
            hostnames_attributes: [
              {
                hostname: ipsum
              },
              {
                hostname: dolor
              },
              {
                hostname: sit
              },
              {
                hostname: amet
              }
            ]
          }
        }.to_json
      end

      let(:payload5) do
        {
          dns_records: {
            ip: ip5,
            hostnames_attributes: [
              {
                hostname: dolor
              },
              {
                hostname: sit
              }
            ]
          }
        }.to_json
      end

      before do
        request.accept = 'application/json'
        request.content_type = 'application/json'

        post(:create, body: payload1, format: :json)
        post(:create, body: payload2, format: :json)
        post(:create, body: payload3, format: :json)
        post(:create, body: payload4, format: :json)
        post(:create, body: payload5, format: :json)
      end

      context 'without included and excluded optional params' do
        let(:expected_response) do
          {
            total_records: 5,
            records: [
              {
                id: 1,
                ip_address: ip1
              },
              {
                id: 2,
                ip_address: ip2
              },
              {
                id: 3,
                ip_address: ip3
              },
              {
                id: 4,
                ip_address: ip4
              },
              {
                id: 5,
                ip_address: ip5
              }
            ],
            related_hostnames: [
              {
                count: 1,
                hostname: lorem
              },
              {
                count: 4,
                hostname: ipsum
              },
              {
                count: 4,
                hostname: dolor
              },
              {
                count: 3,
                hostname: amet
              },
              {
                count: 2,
                hostname: sit
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns all dns records with all hostnames' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'Edited Test: With the included optional param' do
        let (:included) { [ipsum, dolor].join(',') }

        let (:expected_response) do
          {
            total_records: 3,
            records: [
              {
                id: 1,
                ip_address: ip1
              },
              {
                id: 3,
                ip_address: ip3
              },
              {
                id: 4,
                ip_address: ip4
              }
            ],
            related_hostnames: [
              {
                hostname: lorem,
                count: 1
              },
              {
                hostname: ipsum,
                count: 3
              },
              {
                hostname: dolor,
                count: 3
              },
              {
                hostname: amet,
                count: 3
              },
              {
                hostname: sit,
                count: 1
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page, included: included })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns only the included dns records without a related hostname' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'with the included optional param' do
        let(:included) { [ipsum, dolor].join(',') }

        let(:expected_response) do
          {
            total_records: 3,
            records: [
              {
                id: 1,
                ip_address: ip1
              },
              {
                id: 3,
                ip_address: ip3
              },
              {
                id: 4,
                ip_address: ip4
              }
            ],
            related_hostnames: [
              {
                count: 3,
                hostname: amet
              },
              {
                count: 1,
                hostname: lorem
              },
              {
                count: 1,
                hostname: sit
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page, included: included })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        # HERE
        # Here is being passed 'ipsum.com' and 'dolor.com' as included params,
        # but the response expects different_hostnames
        # it 'returns only the included dns records without a related hostname' do
        #   expect(parsed_body).to eq expected_response
        # end
      end

      context 'with the excluded optional param' do
        let(:excluded) { [lorem].join(',') }

        let(:expected_response) do
          {
            total_records: 4,
            records: [
              {
                id: 2,
                ip_address: ip2
              },
              {
                id: 3,
                ip_address: ip3
              },
              {
                id: 4,
                ip_address: ip4
              },
              {
                id: 5,
                ip_address: ip5
              }
            ],
            related_hostnames: [
              {
                count: 3,
                hostname: ipsum
              },
              {
                count: 3,
                hostname: dolor
              },
              {
                count: 2,
                hostname: amet
              },
              {
                count: 2,
                hostname: sit
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page, excluded: excluded })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns only the non-excluded dns records with a related hostname' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'Edited test: with both included and excluded optional params' do
        let(:included) { [ipsum, dolor].join(',') }
        let(:excluded) { [sit].join(',') }

        let(:expected_response) do
          {
            total_records: 2,
            records: [
              {
                id: 1,
                ip_address: ip1
              },
              {
                id: 3,
                ip_address: ip3
              }
            ],
            related_hostnames: [
              {
                hostname: lorem,
                count: 1
              },
              {
                hostname: ipsum,
                count: 2
              },
              {
                hostname: dolor,
                count: 2
              },
              {
                hostname: amet,
                count: 2
              }
            ]
          }

          before :each do
            get(:index, params: { page: page, included: included, excluded: excluded })
          end

          it 'responds with valid response' do
            expect(response).to have_http_status(:ok)
          end

          it 'returns only the non-excluded dns records with a related hostname' do
            expect(parsed_body).to eq expected_response
          end
        end
      end

      context 'with both included and excluded optional params' do
        let(:included) { [ipsum, dolor].join(',') }
        let(:excluded) { [sit].join(',') }

        let(:expected_response) do
          {
            total_records: 2,
            records: [
              {
                id: 1,
                ip_address: ip1
              },
              {
                id: 3,
                ip_address: ip3
              }
            ],
            related_hostnames: [
              {
                count: 1,
                hostname: lorem
              },
              {
                count: 2,
                hostname: amet
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page, included: included, excluded: excluded })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        # HERE
        # This test is being described on the description of the project: on the section Explanation
        # https://tasteful-spleen-a1f.notion.site/Growth-Cadet-API-Challenge-6345ee9643e54984a794896a60b77b3f

        # The Ips 1 and 2 have more hostnames (lorem, amet), and they are not being excluded
        # And according to the explanation above, this is not the expected.
        # So as a result, the expected_response.related_hostnames should have all fours hostnames (lorem, ipsum, dolor, amet)
        # it 'returns only the non-excluded dns records with a related hostname' do
        #   expect(parsed_body).to eq expected_response
        # end
      end
    end

    context 'without the required page param' do
      before :each do
        get(:index)
      end

      it 'responds with unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#create' do
    context 'with valid creation params' do
      let(:ip6) { '6.6.6.6'}

      let(:lorem) { 'lorem.com' }
      let(:ipsum) { 'ipsum.com' }

      let(:payload6) do
        {
          dns_records: {
            ip: ip6,
            hostnames_attributes: [
              {
                hostname: lorem
              },
              {
                hostname: ipsum
              }
            ]
          }
        }.to_json
      end

      before do
        request.accept = 'application/json'
        request.content_type = 'application/json'

        post(:create, body: payload6, format: :json)
      end

      it 'responds with created status' do
        expect(response).to have_http_status(:created)
      end

      it 'response be an integer' do
        expect(parsed_body).to be_an(Integer)
      end
    end

    context 'with invalid creation params' do
      let(:ip_invalid) { '1.1.1.1.1'}
      let(:error_message) { "Validation failed: Ip Must be a valid IPV4" }

      let(:lorem) { 'lorem.com' }
      let(:ipsum) { 'ipsum.com' }

      let(:payload_error) do
        {
          dns_records: {
            ip: ip_invalid,
            hostnames_attributes: [
              {
                hostname: lorem
              },
              {
                hostname: ipsum
              }
            ]
          }
        }.to_json
      end

      before do
        request.accept = 'application/json'
        request.content_type = 'application/json'

        post(:create, body: payload_error, format: :json)
      end

      it 'responds with unprocessable status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'response be an validation error' do
        expect(parsed_body[:errors]).to eq('Validation failed: Ip Must be a valid IPV4')
      end
    end
  end
end
