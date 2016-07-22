From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v7 7/7] KVM: arm: enable KVM_SIGNAL_MSI and MSI routing
Date: Fri, 22 Jul 2016 15:52:16 +0200
Message-ID: <8ddc1ced-18c7-d249-ed72-600fad9c90d6@redhat.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-8-git-send-email-eric.auger@redhat.com>
 <20160721163341.GE32739@potion>
 <9fa6bc46-6711-5825-48a3-1de5262ee34f@redhat.com>
 <20160722133937.GA11512@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160722133937.GA11512@potion>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Radim,

On 22/07/2016 15:39, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> 2016-07-21 23:10+0200, Auger Eric:
>> On 21/07/2016 18:33, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>>> 2016-07-18 13:25+0000, Eric Auger:
>>>> If the ITS modality is not available, let's simply support MSI
>>>> injection by transforming the MSI.data into an SPI ID.
>>>>
>>>> This becomes possible to use KVM_SIGNAL_MSI ioctl and MSI
>>>> routing for arm too.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
>>>> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vg=
ic-irqfd.c
>>>> +static int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *m=
si)
>>>> +{
>>>> +	if (msi->flags & KVM_MSI_VALID_DEVID)
>>>> +		return -EINVAL;
>>>> +	if (!vgic_valid_spi(kvm, msi->data))
>>>> +		return -EINVAL;
>>>> +
>>>> +	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);
>>>
>>> Hm, this isn't very MSI related ...
>>>
>>> arm already has KVM_IRQ_LINE/kvm_vm_ioctl_irq_line with
>>> KVM_ARM_IRQ_TYPE_SPI that does
>>>   kvm_vgic_inject_irq(kvm, 0, irq_num, level)
>>>
>>> Is that interface lacking?
>>
>> You mean KVM_SIGNAL_MSI? Well at QEMU level, for ARM/ARM64 is doesn'=
t.
>=20
> No, I meant KVM_IRQ_LINE, the one that is used to deliver SPI today.
> Or isn't it?
>=20
>> For kvm-tools I guess, Andre manages without.
>>
>> My first feeling was it is part of the KVM API and we can implement =
it
>> easily for GICv2M, as we do for GICv3 ITS . This can avoid a user ap=
p to
>> do what QEMU implements as "kvm_gsi_direct_mapping" and manage the
>> translation into the semantic of the ARM GSI.
>=20
> I think that reusing KVM_SIGNAL_MSI and KVM_IRQ_ROUTING_MSI for SPI i=
s
> unfortunate.
>=20
> SPI only uses msi.data, which makes remaining fields in the msi struc=
t
> arbitrary and [5/7] defined KVM_IRQ_ROUTING_IRQCHIP for SPI, so two
> route types now do the same, but only sometimes (without ITS), which
> makes the situation even less understandable ...
>=20
> Delivering SPI as KVM_IRQ_ROUTING_IRQCHIP seems more sensible and if =
we
> wanted ad-hoc delivery of KVM_IRQ_ROUTING_IRQCHIP, then I would prefe=
r a
> new interface to two different meanings for KVM_SIGNAL_MSI:
> KVM_SIGNAL_MSI was created because we didn't have anything that could
> inject an interrupt without setting up a route with KVM_SET_GSI_ROUTI=
NG
> and we are still missing a generic interface to do that.
>=20
>> But Well, if you prefer we do not implement it for GICv2M, since
>> considered as far fetched I can remove this patch.
>=20
> I do, thanks.  Documentation in [6/7] was ahead and needs changing th=
en.

Argh just saw your reply after sending v8. Will respin immediatly.

Sorry for the confusion

Thanks

Eric
>=20
