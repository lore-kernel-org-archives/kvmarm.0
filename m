From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v8 6/7] KVM: arm/arm64: Enable MSI routing
Date: Fri, 22 Jul 2016 16:46:01 +0200
Message-ID: <331ef966-b079-0967-bb3f-a8a527229801@redhat.com>
References: <1469195200-6498-1-git-send-email-eric.auger@redhat.com>
 <1469195200-6498-7-git-send-email-eric.auger@redhat.com>
 <20160722141425.GB9019@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160722141425.GB9019@potion>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu



On 22/07/2016 16:14, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> 2016-07-22 13:46+0000, Eric Auger:
>> Up to now, only irqchip routing entries could be set. This patch
>> adds the capability to insert MSI routing entries.
>>
>> For ARM64, let's also increase KVM_MAX_IRQ_ROUTES to 4096: this
>> include SPI irqchip routes plus MSI routes. In the future this
>> might be extended.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
>>
>> ---
>> v7 -> v8:
>> - adapt to changes in kvm_kernel_irq_routing_entry and check the
>>   user entry flags according to the user entry type
>>
>> v6 -> v7:
>> - added Andre's R-b
>>
>> v2 -> v3:
>> - remove any reference to KVM_IRQ_ROUTING_EXTENDED_MSI type
>> - unconditionnaly uapi flags and devid downto the kernel
>>   routing entry struct
>> - handle KVM_MSI_VALID_DEVID flag in kvm_set_irq_routing
>> - note about KVM_CAP_MSI_DEVID moved in the first patch file
>>   of the series
>>
>> v1 -> v2:
>> - adapt to new routing entry types
>>
>> RFC -> PATCH:
>> - move api MSI routing updates into that patch file
>> - use new devid field of user api struct
>> ---
>> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
>> @@ -201,23 +202,25 @@ int kvm_set_irq_routing(struct kvm *kvm,
>>  			new->chip[i][j] =3D -1;
>> =20
>>  	for (i =3D 0; i < nr; ++i) {
>> -		struct kvm_kernel_irq_routing_entry *e;
>> -
>>  		r =3D -ENOMEM;
>>  		e =3D kzalloc(sizeof(*e), GFP_KERNEL);
>>  		if (!e)
>>  			goto out;
>> =20
>>  		r =3D -EINVAL;
>> -		if (ue->flags) {
>> -			kfree(e);
>> -			goto out;
>> +		switch (ue->type) {
>> +		case KVM_IRQ_ROUTING_IRQCHIP:
>> +			if (ue->flags)
>> +				goto free_entry;
>> +			break;
>> +		case KVM_IRQ_ROUTING_MSI:
>> +			if (ue->flags & ~KVM_MSI_VALID_DEVID)
>> +				goto free_entry;
>> +			break;
>=20
> The function is common for all arches and there are currently two oth=
er
> routing types (S390_ADAPTER and HV_SINT) that ought to be checked as
> well, so "default" instead of "KVM_IRQ_ROUTING_IRQCHIP" would be bett=
er.
Sure

Thanks

Eric
>=20
>>  		}
>>  		r =3D setup_routing_entry(new, e, ue);
>> -		if (r) {
>> -			kfree(e);
>> -			goto out;
>> -		}
>> +		if (r)
>> +			goto free_entry;
>>  		++ue;
>>  	}
>> =20
