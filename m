From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v7 2/7] KVM: kvm_host: add devid in
 kvm_kernel_irq_routing_entry
Date: Thu, 21 Jul 2016 18:25:48 +0100
Message-ID: <5791059C.70700@arm.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-3-git-send-email-eric.auger@redhat.com>
 <20160721161328.GC32739@potion> <5790FE42.103@arm.com>
 <20160721172239.GA9019@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160721172239.GA9019@potion>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 21/07/16 18:22, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> 2016-07-21 17:54+0100, Marc Zyngier:
>> On 21/07/16 17:13, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
>>> 2016-07-18 13:25+0000, Eric Auger:
>>>> Extend kvm_kernel_irq_routing_entry to transport the device id
>>>> field, devid. A new flags field makes possible to indicate the
>>>> devid is valid. Those additions are used for ARM GICv3 ITS MSI
>>>> injection.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>>
>>>> ---
>>>> v6 -> v7:
>>>> - added msi_ prefix to flags and dev_id fields
>>>>
>>>> v4 -> v5:
>>>> - add Christoffer's R-b
>>>>
>>>> v2 -> v3:
>>>> - add flags
>>>>
>>>> v1 -> v2:
>>>> - replace msi_msg field by a struct composed of msi_msg and devid
>>>>
>>>> RFC -> PATCH:
>>>> - reword the commit message after change in first patch (uapi)
>>>> ---
>>>>  include/linux/kvm_host.h | 6 +++++-
>>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>>> index c87fe6f..3d2cbb4 100644
>>>> --- a/include/linux/kvm_host.h
>>>> +++ b/include/linux/kvm_host.h
>>>> @@ -317,7 +317,11 @@ struct kvm_kernel_irq_routing_entry {
>>>>  			unsigned irqchip;
>>>>  			unsigned pin;
>>>>  		} irqchip;
>>>> -		struct msi_msg msi;
>>>> +		struct {
>>>> +			struct msi_msg msi;
>>>> +			u32 msi_flags;
>>>> +			u32 msi_devid;
>>>
>>> I'd much rather see them as msi.flags and msi.devid.
>>
>> That's not really possible, as msi_msg is the core data structure fo=
r
>> MSIs, and nobody really expects this tructure to change.
>>
>>> I didn't notice a code that passes struct msi_msg anywhere, so usin=
g an
>>> ad-hoc struct like irqchip or defining a new one would work fine.
>>
>> I guess we could have an arm-specific one:
>>
>> 		struct arm_msi {
>> 			struct msi_msg msg;
>> 			u32 flags;
>> 			u32 devid;
>> 		};
>>
>> and use that. Would that be OK with you?
>=20
> The feature wants to be arch-neutral, so I would rather ignore struct
> msi_msg.  kvm_kernel_irq_routing_entry practically mirrors routing
> entries from KVM API and there we have:
>=20
>   struct kvm_msi {
>   	__u32 address_lo;
>   	__u32 address_hi;
>   	__u32 data;
>   	__u32 flags;
>   	__u32 devid;
>   	__u8  pad[12];
>   };
>=20
> I think that something like
>=20
>   struct {
>   	u32 address_lo;
>   	u32 address_hi;
>   	u32 data;
>   	u32 flags;
>   	u32 devid;
>   } msi;
>=20
> would get us consistency, minimal changes to existing code, no namesp=
ace
> hierarchy, and no "." vs "_" mistakes at a good price of some code
> duplication and concept separation.

=46air enough. Eric, can you give this a try?

Thanks,

	M.
--=20
Jazz is not dead. It just smells funny...
