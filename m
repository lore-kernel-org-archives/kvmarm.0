From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v7 6/7] KVM: arm/arm64: enable MSI routing
Date: Thu, 21 Jul 2016 22:50:00 +0200
Message-ID: <67d2749f-483b-948a-8ee8-ad737dc90271@redhat.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-7-git-send-email-eric.auger@redhat.com>
 <20160721162121.GD32739@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160721162121.GD32739@potion>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Radim,
On 21/07/2016 18:21, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> 2016-07-18 13:25+0000, Eric Auger:
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
>> @@ -209,7 +209,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
>>  			goto out;
>> =20
>>  		r =3D -EINVAL;
>> -		if (ue->flags) {
>> +		if (ue->flags & ~KVM_MSI_VALID_DEVID) {
>=20
> This allows KVM_MSI_VALID_DEVID flag for all route types, which is no=
t
> what we want.
> To avoid checking separately when setting MSI route in every arch,
> I think we could have a switch (ue->type) here as well.
Yes correct, I will add this type check.

Thanks

Eric
>=20
>>  			kfree(e);
>>  			goto out;
>>  		}
