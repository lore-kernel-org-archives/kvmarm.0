From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC v7 1/7] KVM: api: pass the devid in the msi routing entry
Date: Thu, 21 Jul 2016 17:43:41 +0100
Message-ID: <6c971903-1158-e450-f41c-665dd4ba660e@arm.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-2-git-send-email-eric.auger@redhat.com>
 <20160721160124.GB32739@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160721160124.GB32739@potion>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Radim,

On 21/07/16 17:01, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> 2016-07-18 13:25+0000, Eric Auger:
>> On ARM, the MSI msg (address and data) comes along with
>> out-of-band device ID information. The device ID encodes the
>> device that writes the MSI msg. Let's convey the device id in
>> kvm_irq_routing_msi and use KVM_MSI_VALID_DEVID flag value in
>> kvm_irq_routing_entry to indicate the msi devid is populated.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
>>
>> ---
>>
>> v6 -> v7:
>> - Added Andre's R-b
>>
>> v4 -> v5:
>> - some rephrasing in api.txt according to Christoffer's comments
>> v2 -> v3:
>> - replace usage of KVM_IRQ_ROUTING_EXTENDED_MSI type by
>>   usage of KVM_MSI_VALID_DEVID flag
>> - add note about KVM_CAP_MSI_DEVID capability
>>
>> v1 -> v2:
>> - devid id passed in kvm_irq_routing_msi instead of in
>>   kvm_irq_routing_entry
>>
>> RFC -> PATCH
>> - remove kvm_irq_routing_extended_msi and use union instead
>> ---
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtu=
al/kvm/api.txt
>> @@ -1479,9 +1483,20 @@ struct kvm_irq_routing_msi {
>>  	__u32 address_lo;
>>  	__u32 address_hi;
>>  	__u32 data;
>> -	__u32 pad;
>> +	union {
>> +		__u32 pad;
>> +		__u32 devid;
>> +	};
>>  };
>> =20
>> +devid: If KVM_MSI_VALID_DEVID is set, contains a unique device iden=
tifier
>> +       for the device that wrote the MSI message.
>> +       For PCI, this is usually a BFD identifier in the lower 16 bi=
ts.
>> +
>> +The per-VM KVM_CAP_MSI_DEVID capability advertises the requirement =
to
>> +provide the device ID. If this capability is not set, userland cann=
ot
>> +rely on the kernel to allow the KVM_MSI_VALID_DEVID flag being set.
>=20
> It would be better to enforce this mentioned dependency on set
> KVM_CAP_MSI_DEVID, but is the dependency even required?
> It seems we were checking flags for zero, so KVM_MSI_VALID_DEVID
> couldn't have been set by old userspaces, therefor it is ok to only m=
ake
> it depend only on the presence of KVM_CAP_MSI_DEVID, like the patch d=
oes
> now.  (I assume KVM_MSI_VALID_DEVID and KVM_CAP_MSI_DEVID are being
> merged at the same time.)
>=20
> Then there would be little point in having KVM_CAP_MSI_DEVID enableab=
le,
> so does enabling KVM_CAP_MSI_DEVID mean that every MSI must have a va=
lid
> devid?

KVM_CAP_MSI_DEVID tells userland that it's fine to set the
KVM_MSI_VALID_DEVID flag (because the kernel would bark otherwise).

KVM_MSI_VALID_DEVID tells the kernel that there is some meaningful
device ID data in the field formerly known as "pad".

IIRC we started with the VALID_DEVID flag, then found that we need the
CAP because we repurposed the pad field.

Does that make sense? Admittedly this _is_ confusing ;-)

Cheers,
Andre.


>=20
> Thanks.
>=20
> ---
> I'm confused about the purpose behind two dynamic flags that seem to =
do
> that same thing, but those are just nitpicks, the API looks good in
> general.
>=20
