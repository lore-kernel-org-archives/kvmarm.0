From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v3 3/5] KVM: arm/arm64: Support arch timers with a
 userspace gic
Date: Thu, 6 Apr 2017 10:27:27 +0200
Message-ID: <404c7b67-663e-2c09-f07a-944f767127d5@suse.de>
References: <20170405092815.22503-1-cdall@linaro.org>
 <20170405092815.22503-4-cdall@linaro.org>
 <358febe2-eb7b-93fa-fa95-ca618443f242@suse.de>
 <d1ac49c8-3a17-17e5-95e6-fd993d768bdc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <d1ac49c8-3a17-17e5-95e6-fd993d768bdc@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, Pekka Enberg <penberg@iki.fi>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 06.04.17 10:25, Marc Zyngier wrote:
> On 06/04/17 09:16, Alexander Graf wrote:
>>
>>
>> On 05.04.17 11:28, Christoffer Dall wrote:
>>> From: Alexander Graf <agraf@suse.de>
>>>

>>> @@ -559,6 +628,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>>>  	if (timer->enabled)
>>>  		return 0;
>>>
>>> +	/* Without a VGIC we do not map virtual IRQs to physical IRQs */
>>> +	if (!irqchip_in_kernel(vcpu->kvm))
>>> +		goto no_vgic;
>>> +
>>> +	if (!vgic_initialized(vcpu->kvm))
>>> +		return -ENODEV;
>>> +
>>>  	/*
>>>  	 * Find the physical IRQ number corresponding to the host_vtimer_irq
>>>  	 */
>>> @@ -582,8 +658,8 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>>>  	if (ret)
>>>  		return ret;
>>>
>>> +no_vgic:
>>>  	timer->enabled = 1;
>>
>> What happens if
>>
>>    1) User space spawns a VM with user space irqchip
>>    2) Runs the VM
>>    3) Then adds a virtual gic device
>
> As soon as a vcpu has run once, it is not possible to instantiate a vgic
> (see virt/kvm/arm/vgic/vgic-init.c:kvm_vgic_create around line 101).

Ah, I was missing that part. Awesome, all problems solved :).


Alex
