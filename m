From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 2/3] Detect vGIC presence at runtime
Date: Fri, 14 Aug 2015 15:26:56 +0300
Message-ID: <017201d0d68c$82ae4950$880adbf0$@samsung.com>
References: <cover.1438770954.git.p.fedin@samsung.com>
 <cad42f98c38c042430da47bf69ac2db81cb957af.1438770954.git.p.fedin@samsung.com>
 <55CDD056.8010703@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55CDD056.8010703@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: 'Christoffer Dall' <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello! Thank you for quick response.

> This is fairly unreadable. Please use a switch statement instead.

 Christoffer disliked it in v1, so i thought a bit and changed it. Ok, will change it back.

> And here, we're going to assume that the arch timer still usable. We
> definitely need a way to *prevent* the timer to be used when there is no
> GIC. Otherwise, we're going to start trying to setup the mapping for the
> active state, and the guest may start poking it.

But, this seems to be already done, isn't it?
According to http://lxr.free-electrons.com/source/arch/arm/kvm/arm.c#L439:
--- cut ---
459         /*
460          * Enable the arch timers only if we have an in-kernel VGIC
461          * and it has been properly initialized, since we cannot handle
462          * interrupts from the virtual timer with a userspace gic.
463          */
464         if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
465                 kvm_timer_enable(kvm);
--- cut ---
 
 Without kvm->arch.timer.enabled set to 1 by kvm_timer_enable() VM context save/restore code will
not actually touch timer registers. Therefore the host part of the code will not do anything.
 As to guest itself, only userspace can stop it from accessing timer registers. My experimental qemu
does this by removing generic timer node from guest's device tree. Virtual timer access simply
cannot be trapped, otherwise there would be no problem at all. But, OK, even if the guest programs
timer, we will just see "Unexpected IRQ 27" on the console, and the guest will not work, so it's not
terribly fatal.

 You know, i actually looked at it before posting v3. I tried to omit kvm_timer_hyp_init() call too,
and got lots of crashes because:
1. kvm_timer_init() is called unconditionally
2. qemu does some initialization of timer registers unconditionally using ioctl, and they end up in
kvm_arm_timer_set_reg()
 Both of these points end up in kvm_phys_timer_read() which dereferences timecounter == NULL.
 Well, i could make kvm_phys_timer_read() just returning 0 in this case, but this could mis-trigger
kvm_timer_should_fire() in some circumstances. I would have to patch it too... At this point i
decided to stop because the result perhaps does not worth the effort and amount of patching.

 While writing this message i was walking through this code once again, and... I have a suggestion.
Actually, if we are really paranoid, we could be afraid of kvm_vgic_inject_irq() being called, which
would do some weird things without vGIC. It is possible to add a check for kvm->arch.timer.enabled
in kvm_timer_sync_hwstate() and kvm_timer_flush_hwstate(). If the timer is disabled those functions
will simply return doing nothing. This would guarantee that interrupt injection is never attempted.

 What do you think?

 And some more. Actually, it is possible to emulate generic timer in userspace, just not the virtual
one. IIRC access to physical timer can be trapped. So, if we modify guest's device tree by removing
virtual timer IRQ, the guest will fall back to physical timer. And this will be caught by the
hypervisor. After this all we have to do is to add corresponding exit code which would allow the
userspace to emulate missing CP15 (or system in case of ARM64) registers. So, this timer issue is
not grave, just i postpone implementing it until GIC issues are settled down.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


