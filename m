From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: 4.15-rc1 crash on Midway in teardown_hyp_mode()
Date: Wed, 6 Dec 2017 14:23:38 +0000
Message-ID: <b54e7124-daba-1cea-7f9c-584b0d8ad46e@arm.com>
References: <45e72322-52dd-4fdb-2e51-176524fb56a8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ABCB49D46
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 09:20:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IS4h-3JWUjf4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 09:20:28 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ECD240651
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 09:20:28 -0500 (EST)
In-Reply-To: <45e72322-52dd-4fdb-2e51-176524fb56a8@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Rob Herring <robh@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/12/17 14:11, Andre Przywara wrote:
> Hi,
> 
> while trying to boot 4.15-rc1 on my Calxeda Midway I observed a crash
> (see below). I can't look further into this today, but wanted to report
> this anyway.
> 
> Digging around a bit this is due to the VGIC not initializing properly
> due to GICC being advertised as just 4K, not 8K.
> This can be worked around by adjusting the DT or using
> irqchip.gicv2_force_probe. However this still raises some questions:
> 1) Even if the VGIC fails to register, we should certainly not crash.
> The chain of events seems to be:
> virt/kvm/arm/arm.c:init_subsystems():
>   - kvm_vgic_hyp_init() returns -ENODEV, this leads to vgic_present
>     being set to false, but "err" being reset to 0 (meaning: carry on).
>     However this seems now to miss some initialization.
>   - kvm_timer_hyp_init() now fails on calling irq_set_vcpu_affinity(),
>     because this returns -ENOSYS. This leads to it returning this error,
>     init_subsystems() failing and subsequently tearing down KVM.
>   - This seems to have some bug and leads to the kernel crash.
> 
> Even with the VGIC not being usable, we should be able to cleanly tear
> down KVM (or HYP?).
> 
> 2) Is it intended that an unusable VGIC now denies KVM entirely? I
> believe in the past we could live with that (no arch timer
> virtualization, no in-kernel GIC emulation) and rely on userland
> emulation (for instance in QEMU). This seemed to have changed now?
> 3) Wouldn't it be smarter to fix up the GICC range by default, if we
> have enough evidence that the GICC is actually 8K? Shouldn't this be
> true for every architecture compliant GICv2, actually? So whenever we
> see "arm,cortex-a15-gic", for instance, we force GICC to 8K?
> Or do we know of GICs which have only 4K, but advertise themselves
> wrongly? Otherwise this could just go as some firmware quirk, based on a
> compatible string, for instance, or some ID registers.

I'm certainly not willing to blindly apply some range extension to the
the GIC registers without the user telling me that it is safe to do so.
There is too much quirky HW out there to do otherwise. How can you prove
that because you see "arm,cortex-a15-gic", you can safely extend the
range to 8K?

The rational is: you don't describe the HW correctly, you don't get a
working kernel. I don't think that's something new.

> The reason I am asking is that the Midway loads the DT from firmware
> flash, and this one hasn't changed in years (for obvious reasons). So
> while *I* am able to update the DT in the SPI flash, I guess many users
> just won't do so, so they are left with a crashing kernel (or loosing
> KVM), starting from 4.15. All the previous kernels booted and ran KVM
> guests fine in the past with the existing DT.

Which is why these people now get a kernel option that says "my firmware
is busted, do as I say".

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
