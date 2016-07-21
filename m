From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RFC v7 1/7] KVM: api: pass the devid in the msi routing entry
Date: Thu, 21 Jul 2016 19:15:14 +0200
Message-ID: <20160721171514.GF32739@potion>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-2-git-send-email-eric.auger@redhat.com>
 <20160721160124.GB32739@potion>
 <6c971903-1158-e450-f41c-665dd4ba660e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6c971903-1158-e450-f41c-665dd4ba660e@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-21 17:43+0100, Andre Przywara:
> Hi Radim,
>=20
> On 21/07/16 17:01, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>> 2016-07-18 13:25+0000, Eric Auger:
>>> On ARM, the MSI msg (address and data) comes along with
>>> out-of-band device ID information. The device ID encodes the
>>> device that writes the MSI msg. Let's convey the device id in
>>> kvm_irq_routing_msi and use KVM_MSI_VALID_DEVID flag value in
>>> kvm_irq_routing_entry to indicate the msi devid is populated.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
>>>
>>> ---
>>> =20
>>> +devid: If KVM_MSI_VALID_DEVID is set, contains a unique device ide=
ntifier
>>> +       for the device that wrote the MSI message.
>>> +       For PCI, this is usually a BFD identifier in the lower 16 b=
its.
>>> +
>>> +The per-VM KVM_CAP_MSI_DEVID capability advertises the requirement=
 to
>>> +provide the device ID. If this capability is not set, userland can=
not
>>> +rely on the kernel to allow the KVM_MSI_VALID_DEVID flag being set=
=2E
>>=20
>> It would be better to enforce this mentioned dependency on set
>> KVM_CAP_MSI_DEVID, but is the dependency even required?
>> It seems we were checking flags for zero, so KVM_MSI_VALID_DEVID
>> couldn't have been set by old userspaces, therefor it is ok to only =
make
>> it depend only on the presence of KVM_CAP_MSI_DEVID, like the patch =
does
>> now.  (I assume KVM_MSI_VALID_DEVID and KVM_CAP_MSI_DEVID are being
>> merged at the same time.)
>>=20
>> Then there would be little point in having KVM_CAP_MSI_DEVID enablea=
ble,
>> so does enabling KVM_CAP_MSI_DEVID mean that every MSI must have a v=
alid
>> devid?
>=20
> KVM_CAP_MSI_DEVID tells userland that it's fine to set the
> KVM_MSI_VALID_DEVID flag (because the kernel would bark otherwise).
>=20
> KVM_MSI_VALID_DEVID tells the kernel that there is some meaningful
> device ID data in the field formerly known as "pad".
>=20
> IIRC we started with the VALID_DEVID flag, then found that we need th=
e
> CAP because we repurposed the pad field.
>=20
> Does that make sense? Admittedly this _is_ confusing ;-)

It does, thanks.
Some capability is need and I thought that KVM_CAP_MSI_DEVID has to be
enabled by userspace before KVM_MSI_VALID_DEVID can be used, which isn'=
t
the case.  It is enabled conditionally based on vgic ITS ... my bad.
