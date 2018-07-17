From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] kvm: arm/arm64: Fix emulated physical timer IRQ injection
Date: Tue, 17 Jul 2018 12:10:40 +0200
Message-ID: <20180717101040.GE30570@e113682-lin.lund.arm.com>
References: <20180716172357.6121-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180716172357.6121-1-andre.przywara@arm.com>
Sender: stable-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Stable <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 16, 2018 at 06:23:57PM +0100, Andre Przywara wrote:
> When KVM emulates a physical timer, we keep track of the interrupt
> condition and try to inject an IRQ to the guest when needed.
> This works if the timer expires when either the guest is running or KVM
> does work on behalf of it, since it calls kvm_timer_update_state().
> However when the guest's VCPU is not scheduled (for instance because
> the guest issued a WFI instruction before), we miss injecting the interrupt
> when the VCPU's state gets restored back in kvm_timer_vcpu_load().
> 
> Fix this by moving the interrupt injection check into the
> phys_timer_emulate() function, so that all possible paths of execution
> are covered.
> 
> This fixes the physical timer emulation, which broke when it got changed
> in the 4.15 merge window.
> The respective kvm-unit-test check has been posted already.
> 
> Cc: Stable <stable@vger.kernel.org> # 4.15+
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/arch_timer.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index bd3d57f40f1b..1949fb0b80a4 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -294,17 +294,26 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu)
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  
> +	/* If the timer cannot fire at all, then we don't need a soft timer. */
> +	if (!kvm_timer_irq_can_fire(ptimer)) {
> +		soft_timer_cancel(&timer->phys_timer, NULL);
> +		kvm_timer_update_irq(vcpu, false, ptimer);
> +		return;
> +	}

This stuff is breaking what the intention is with the
phys_timer_emulate() function.  See the comment above the function,
which says that this is about scheduling the background soft timer, and
not about managing the rest of the state.

At least that function needs updating.

> +
>  	/*
> -	 * If the timer can fire now we have just raised the IRQ line and we
> -	 * don't need to have a soft timer scheduled for the future.  If the
> -	 * timer cannot fire at all, then we also don't need a soft timer.
> +	 * If the timer can fire now, we don't need to have a soft timer
> +	 * scheduled for the future, as we also raise the IRQ line.
>  	 */
> -	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer)) {
> +	if (kvm_timer_should_fire(ptimer)) {
>  		soft_timer_cancel(&timer->phys_timer, NULL);
> +		kvm_timer_update_irq(vcpu, true, ptimer);
> +
>  		return;
>  	}
>  
>  	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(ptimer));
> +	kvm_timer_update_irq(vcpu, false, ptimer);

This is clearly racy as you'll lower the interrupt that may have just
fired between these two lines.

>  }
>  
>  /*
> @@ -316,7 +325,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> -	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  	bool level;
>  
>  	if (unlikely(!timer->enabled))
> @@ -332,9 +340,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  	level = kvm_timer_should_fire(vtimer);
>  	kvm_timer_update_irq(vcpu, level, vtimer);
>  
> -	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
> -		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
> -
>  	phys_timer_emulate(vcpu);
>  }
>  
> -- 
> 2.14.4
> 

Overall, I think this approach is wrong.

Please see the following suggestion for doing this in two patches
instead:

>From 08b40157cc6a69d72a37afff38fce9d0b482953f Mon Sep 17 00:00:00 2001
From: Christoffer Dall <christoffer.dall@arm.com>
Date: Tue, 17 Jul 2018 11:53:39 +0200
Subject: [PATCH 1/2] KVM: arm/arm64: Fix potential loss of ptimer interrupts

kvm_timer_update_state() is called when changing the phys timer
configuration registers, either via vcpu reset, as a result of a trap
from the guest, or when userspace programs the registers.

phys_timer_emulate() is in turn called by kvm_timer_update_state() to
either cancel an existing software timer, or program a new software
timer, to emulate the behavior of a real phys timer, based on the change
in configuration registers.

Unfortunately, the interaction between these two functions left a small
race; if the conceptual emulated phys timer should actually fire, but
the soft timer hasn't executed its callback yet, we cancel the timer in
phys_timer_emulate without injecting an irq.  This only happens if the
check in kvm_timer_update_state is called before the timer should fire,
which is relatively unlikely, but possible.

The solution is to update the state of the phys timer after calling
phys_timer_emulate, which will pick up the pending timer state and
update the interrupt value.

Note that this leaves the opportunity of raising the interrupt twice,
once in the just-programmed soft timer, and once in
kvm_timer_update_state.  Since this always happens synchronously with
the VCPU execution, there is no harm in this, and the guest ever only
sees a single timer interrupt.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 virt/kvm/arm/arch_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index bd3d57f..4db1fbf 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -332,10 +332,10 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	level = kvm_timer_should_fire(vtimer);
 	kvm_timer_update_irq(vcpu, level, vtimer);
 
+	phys_timer_emulate(vcpu);
+
 	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
 		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
-
-	phys_timer_emulate(vcpu);
 }
 
 static void vtimer_save_state(struct kvm_vcpu *vcpu)
-- 
2.7.4


>From bce5c9ec3d7e0e2e7b8d4c733a18c0a987be16f5 Mon Sep 17 00:00:00 2001
From: Christoffer Dall <christoffer.dall@arm.com>
Date: Tue, 17 Jul 2018 12:04:28 +0200
Subject: [PATCH 2/2] KVM: arm/arm64: Fix lost IRQs from emulated physcial
 timer when blocked

When the VCPU is blocked (for example from WFI) we don't inject the
physical timer interrupt if it should fire while the CPU is blocked, but
instead we just wake up the VCPU and expect kvm_timer_vcpu_load to take
care of injecting the interrupt.

Unfortunately, kvm_timer_vcpu_load() doesn't actually do that, it only
has support to schedule a soft timer if the emulated phys timer is
expected to fire in the future.

Follow the same pattern as kvm_timer_update_state() and update the irq
state after potentially scheduling a soft timer.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 virt/kvm/arm/arch_timer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 4db1fbf..bd64fb4 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -502,6 +502,10 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 
 	/* Set the background timer for the physical timer emulation. */
 	phys_timer_emulate(vcpu);
+
+	/* If the timer fired while we weren't running, inject it now */
+	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
+		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
-- 
2.7.4



Thanks,
-Christoffer
