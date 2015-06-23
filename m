From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 1/6] KVM: api: add kvm_irq_routing_extended_msi
Date: Tue, 23 Jun 2015 09:36:47 +0200
Message-ID: <55890C8F.7060502@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org> <1434649258-27065-2-git-send-email-eric.auger@linaro.org> <558838BB.9090908@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <558838BB.9090908@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, "eric.auger@st.com" <eric.auger@st.com>
Cc: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "p.fedin@samsung.com" <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andr=E9,
On 06/22/2015 06:32 PM, Andre Przywara wrote:
> Hi Eric,
>=20
> On 18/06/15 18:40, Eric Auger wrote:
>> On ARM, the MSI msg (address and data) comes along with
>> out-of-band device ID information. The device ID encodes the device
>> that composes the MSI msg. Let's create a new routing entry structur=
e
>> that enables to encode that information on top of standard MSI
>> message
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  Documentation/virtual/kvm/api.txt | 9 +++++++++
>>  include/uapi/linux/kvm.h          | 9 +++++++++
>>  2 files changed, 18 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtu=
al/kvm/api.txt
>> index d20fd94..bcec91e 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -1419,6 +1419,7 @@ struct kvm_irq_routing_entry {
>>  		struct kvm_irq_routing_irqchip irqchip;
>>  		struct kvm_irq_routing_msi msi;
>>  		struct kvm_irq_routing_s390_adapter adapter;
>> +		struct kvm_irq_routing_extended_msi ext_msi;
>>  		__u32 pad[8];
>>  	} u;
>>  };
>> @@ -1427,6 +1428,7 @@ struct kvm_irq_routing_entry {
>>  #define KVM_IRQ_ROUTING_IRQCHIP 1
>>  #define KVM_IRQ_ROUTING_MSI 2
>>  #define KVM_IRQ_ROUTING_S390_ADAPTER 3
>> +#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
>> =20
>>  No flags are specified so far, the corresponding field must be set =
to zero.
>> =20
>> @@ -1442,6 +1444,13 @@ struct kvm_irq_routing_msi {
>>  	__u32 pad;
>>  };
>> =20
>> +struct kvm_irq_routing_extended_msi {
>> +	__u32 address_lo;
>> +	__u32 address_hi;
>> +	__u32 data;
>> +	__u32 devid;
>> +};
>> +
>=20
> I wonder if we could re-use the existing struct kvm_irq_routing_msi,
> which has an u32 pad field already. Since we use a different type
> number, this should not break. Admittedly not the nicest thing, but
> reduces interface bloat:
>=20
> struct kvm_irq_routing_msi {
> 	__u32 address_lo;
> 	__u32 address_hi;
> 	__u32 data;
> 	union {
> 		__u32 pad;
> 		__u32 devid;
> 	};
> };
>=20
> to maintain backward compatibility on the userland source level.
I also envisioned that solution. I eventually chose adding a new struct=
,
for sake of homogeneity since the fellow kvm struct does not have such =
a
padding field: struct kvm_kernel_irq_routing_entry (kvm_host.h).

But I don't have a strong preference so if it is a general preference I
will follow, of course.

Thanks

Eric


>=20
> Cheers,
> Andre.
>=20
>>  struct kvm_irq_routing_s390_adapter {
>>  	__u64 ind_addr;
>>  	__u64 summary_addr;
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 2a23705..e3f65a0 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -829,6 +829,13 @@ struct kvm_irq_routing_msi {
>>  	__u32 pad;
>>  };
>> =20
>> +struct kvm_irq_routing_extended_msi {
>> +	__u32 address_lo;
>> +	__u32 address_hi;
>> +	__u32 data;
>> +	__u32 devid;
>> +};
>> +
>>  struct kvm_irq_routing_s390_adapter {
>>  	__u64 ind_addr;
>>  	__u64 summary_addr;
>> @@ -841,6 +848,7 @@ struct kvm_irq_routing_s390_adapter {
>>  #define KVM_IRQ_ROUTING_IRQCHIP 1
>>  #define KVM_IRQ_ROUTING_MSI 2
>>  #define KVM_IRQ_ROUTING_S390_ADAPTER 3
>> +#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
>> =20
>>  struct kvm_irq_routing_entry {
>>  	__u32 gsi;
>> @@ -851,6 +859,7 @@ struct kvm_irq_routing_entry {
>>  		struct kvm_irq_routing_irqchip irqchip;
>>  		struct kvm_irq_routing_msi msi;
>>  		struct kvm_irq_routing_s390_adapter adapter;
>> +		struct kvm_irq_routing_extended_msi ext_msi;
>>  		__u32 pad[8];
>>  	} u;
>>  };
>>

--
To unsubscribe from this list: send the line "unsubscribe kvm" in
