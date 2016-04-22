From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 1/2] arm/arm64: KVM: Detect vGIC presence at runtime
Date: Fri, 22 Apr 2016 08:50:58 +0100
Message-ID: <5719D7E2.6090309@arm.com>
References: <cover.1448874023.git.p.fedin@samsung.com>
 <f759b4ba37d4cacdc971d2a416cdc8ecf0c3c3d9.1448874023.git.p.fedin@samsung.com>
 <57194919.5080007@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <57194919.5080007@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>, Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 21/04/16 22:41, Alexander Graf wrote:
> 
> 
> On 30.11.15 10:40, Pavel Fedin wrote:
>> Before commit 662d9715840aef44dcb573b0f9fab9e8319c868a
>> ("arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}") is was possible to
>> compile the kernel without vGIC and vTimer support. Commit message says
>> about possibility to detect vGIC support in runtime, but this has never
>> been implemented.
>>
>> This patch introdices runtime check, restoring the lost functionality.
>> It again allows to use KVM on hardware without vGIC. Interrupt
>> controller has to be emulated in userspace in this case.
>>
>> -ENODEV return code from probe function means there's no GIC at all.
>> -ENXIO happens when, for example, there is GIC node in the device tree,
>> but it does not specify vGIC resources. Normally this means that vGIC
>> hardware is defunct. Any other error code is still treated as full stop
>> because it might mean some really serious problems.
>>
>> This patch does not touch any virtual timer code, suggesting that timer
>> hardware is actually in place. Normally on boards in question it is true,
>> however since vGIC is missing, it is impossible to correctly utilize
>> interrupts from the virtual timer. Since virtual timer handling is in
> 
> So effectively all we'd need is to set CNTHCTL_EL2.EL1PCEN to 0 for
> guests that have no in-kernel irqchip, no? We should then trap on all
> timer accesses and be able to emulate them in user space where we can
> inject IRQs into an emulated GIC again.

That's for the counter. The timer is already trapped.

That very nice, until you realize that Linux guests use the virtual
timer, not the physical one. Yes, you can hack that. And at that point,
you might as well have a different timer altogether, which solves the
problem entirely, without having to forward anything to userspace.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
