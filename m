From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/2] ARM: soft-reboot into same mode that we entered the
 kernel
Date: Wed, 14 Dec 2016 13:42:45 +0000
Message-ID: <2c6fd1cb-dd14-56f7-60c5-5030e0b02e1d@arm.com>
References: <20161213113044.GC19985@leverpostej>
 <E1cH751-0003kk-Ts@rmk-PC.armlinux.org.uk>
 <20161214115648.GG17982@leverpostej>
 <20161214120541.GD14217@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8F3140354
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2016 08:41:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qn8vI0YlG3r5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Dec 2016 08:41:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3283401E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2016 08:41:39 -0500 (EST)
In-Reply-To: <20161214120541.GD14217@n2100.armlinux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@armlinux.org.uk>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, dave.martin@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 14/12/16 12:05, Russell King - ARM Linux wrote:
> On Wed, Dec 14, 2016 at 11:56:49AM +0000, Mark Rutland wrote:
>> On Wed, Dec 14, 2016 at 10:46:35AM +0000, Russell King wrote:
>>> When we soft-reboot (eg, kexec) from one kernel into the next, we need
>>> to ensure that we enter the new kernel in the same processor mode as
>>> when we were entered, so that (eg) the new kernel can install its own
>>> hypervisor - the old kernel's hypervisor will have been overwritten.
>>>
>>> In order to do this, we need to pass a flag to cpu_reset() so it knows
>>> what to do, and we need to modify the kernel's own hypervisor stub to
>>> allow it to handle a soft-reboot.
>>>
>>> As we are always guaranteed to install our own hypervisor if we're
>>> entered in HYP32 mode, and KVM will have moved itself out of the way
>>> on kexec/normal reboot, we can assume that our hypervisor is in place
>>> when we want to kexec, so changing our hypervisor API should not be a
>>> problem.
>>
>> Just to check, does that also hold true for kdump?
>>
>> I haven't gone digging yet, but it looks like KVM might still be
>> installed, rather than the hyp stub, and we might need some logic to
>> ensure that it's torn down...
> 
> The same problem will be true of ARM64 - I don't see any solution to
> that in the present state.
> 
>>> @@ -51,7 +52,9 @@ static void __soft_restart(void *addr)
>>>  
>>>  	/* Switch to the identity mapping. */
>>>  	phys_reset = (phys_reset_t)virt_to_idmap(cpu_reset);
>>> -	phys_reset((unsigned long)addr);
>>> +
>>> +	/* original stub should be restored by kvm */
>>> +	phys_reset((unsigned long)addr, is_hyp_mode_available());
>>
>> ... otherwise here we'd call into the KVM hyp code in a potentially
>> confusing manner.
>>
>> Otherwise, this looks fine to me.
> 
> The only thing that I can think which would resolve that would be to
> lay down a standard API for the hyp code, so things like reboot into
> hyp mode can work irrespective of the hyp stub in place.

That looks like a sensible thing to do. I'll look into it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
