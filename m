From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 39/59] KVM: arm/arm64: GICv4: Add property field and
 per-VM predicate
Date: Wed, 30 Aug 2017 10:46:05 +0100
Message-ID: <45590bb0-0d0e-668f-5553-0443ef8de9a5@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-40-marc.zyngier@arm.com> <20170826194915.GE11074@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170826194915.GE11074@cbox>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 26/08/17 20:49, Christoffer Dall wrote:
> On Mon, Jul 31, 2017 at 06:26:17PM +0100, Marc Zyngier wrote:
>> Add a new has_gicv4 field in the global VGIC state that indicates
>> whether the HW is GICv4 capable, as a per-VM predicate indicating
>> if there is a possibility for a VM to support direct injection
>> (the above being true and the VM having an ITS).
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  include/kvm/arm_vgic.h           | 3 +++
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 5 +++++
>>  virt/kvm/arm/vgic/vgic.h         | 2 ++
>>  3 files changed, 10 insertions(+)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index ee8587c8c715..84694b42373a 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -73,6 +73,9 @@ struct vgic_global {
>>  	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
>>  	bool			can_emulate_gicv2;
>>  
>> +	/* Does have GICv4? */
> 
> nit: questionable comment, how about
> 
>   /* Hardware has GICv4? */
> or
>   /* Do we have GICv4? */

Yup, reads much better.

>> +	bool			has_gicv4;
>> +
>>  	/* GIC system register CPU interface */
>>  	struct static_key_false gicv3_cpuif;
>>  
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 714fa3933546..74109ca75cc0 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -54,6 +54,11 @@ bool vgic_has_its(struct kvm *kvm)
>>  	return dist->has_its;
>>  }
>>  
>> +bool vgic_is_v4_capable(struct kvm *kvm)
>> +{
>> +	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
>> +}
>> +
> 
> uber nit: the naming here is a bit funny, because we won't be presenting
> a GICv4 GIC to the guest, so I'd prefer something like
> vgic_supports_direct_msis() or something like that, but this is
> obviously not a deal breaker.

I like it. It has the advantage of not tying the predicate to a
particular direct injection method, should we one day have a GICv6 (no,
please...).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
