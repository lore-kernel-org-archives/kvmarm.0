From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v7 7/7] KVM: arm: enable KVM_SIGNAL_MSI and MSI routing
Date: Thu, 21 Jul 2016 23:10:51 +0200
Message-ID: <9fa6bc46-6711-5825-48a3-1de5262ee34f@redhat.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-8-git-send-email-eric.auger@redhat.com>
 <20160721163341.GE32739@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160721163341.GE32739@potion>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Radim,

On 21/07/2016 18:33, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> 2016-07-18 13:25+0000, Eric Auger:
>> If the ITS modality is not available, let's simply support MSI
>> injection by transforming the MSI.data into an SPI ID.
>>
>> This becomes possible to use KVM_SIGNAL_MSI ioctl and MSI
>> routing for arm too.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v6 -> v7:
>> - move vgic_v2m_inject_msi into vgic-irqfd
>>
>> v4 -> v5:
>> - on vgic_v2m_inject_msi check the msi->data is within the SPI range
>> - move KVM_HAVE_MSI in the KVM section (to be symetrical with ARM64)
>>
>> v2 -> v3:
>> - reword the commit message
>> - add sanity check about devid provision
>>
>> v1 -> v2:
>> - introduce vgic_v2m_inject_msi in vgic-v2-emul.c following Andre's
>>   advice
>> ---
>> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic=
-irqfd.c
>> +static int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi=
)
>> +{
>> +	if (msi->flags & KVM_MSI_VALID_DEVID)
>> +		return -EINVAL;
>> +	if (!vgic_valid_spi(kvm, msi->data))
>> +		return -EINVAL;
>> +
>> +	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);
>=20
> Hm, this isn't very MSI related ...
>=20
> arm already has KVM_IRQ_LINE/kvm_vm_ioctl_irq_line with
> KVM_ARM_IRQ_TYPE_SPI that does
>   kvm_vgic_inject_irq(kvm, 0, irq_num, level)
>=20
> Is that interface lacking?

You mean KVM_SIGNAL_MSI? Well at QEMU level, for ARM/ARM64 is doesn't.
=46or kvm-tools I guess, Andre manages without.

My first feeling was it is part of the KVM API and we can implement it
easily for GICv2M, as we do for GICv3 ITS . This can avoid a user app t=
o
do what QEMU implements as "kvm_gsi_direct_mapping" and manage the
translation into the semantic of the ARM GSI.

But Well, if you prefer we do not implement it for GICv2M, since
considered as far fetched I can remove this patch.

Thank you for your time

Best Regards

Eric
>=20
> Thanks.
>=20
>> +}
>> +
>> +/**
>>   * kvm_set_msi: inject the MSI corresponding to the
>>   * MSI routing entry
>>   *
>> @@ -96,7 +113,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_ent=
ry *e,
>>  	msi.devid =3D e->msi_devid;
>> =20
>>  	if (!vgic_has_its(kvm))
>> -		return -ENODEV;
>> +		return vgic_v2m_inject_msi(kvm, &msi);
>> =20
>>  	return vgic_its_inject_msi(kvm, &msi);
>>  }
>> --=20
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
