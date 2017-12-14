From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Thu, 14 Dec 2017 16:45:18 +0100
Message-ID: <20171214154518.GX910@cbox>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
 <20171213091803.GQ910@cbox>
 <dc95b58c-ee6c-e5c7-1f37-8f69c789a1fc@gmail.com>
 <20171214130954.GV910@cbox>
 <5615f3e1-756e-0537-f0b6-20ae8626ac87@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5615f3e1-756e-0537-f0b6-20ae8626ac87@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia He <hejianet@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Jia He <jia.he@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 14, 2017 at 11:28:04PM +0800, Jia He wrote:
> 
> On 12/14/2017 9:09 PM, Christoffer Dall Wrote:
> >On Thu, Dec 14, 2017 at 12:57:54PM +0800, Jia He wrote:
> >Hi Jia,
> >
> >>I have tried your newer level-mapped-v7 branch, but bug is still there.
> >>
> >>There is no special load in both host and guest. The guest (kernel
> >>4.14) is often hanging when booting
> >>
> >>the guest kernel log
> >>
> >>[ OK ] Reached target Remote File Systems.
> >>Starting File System Check on /dev/mapper/fedora-root...
> >>[ OK ] Started File System Check on /dev/mapper/fedora-root.
> >>Mounting /sysroot...
> >>[ 2.670764] SGI XFS with ACLs, security attributes, no debug enabled
> >>[ 2.678180] XFS (dm-0): Mounting V5 Filesystem
> >>[ 2.740364] XFS (dm-0): Ending clean mount
> >>[ OK ] Mounted /sysroot.
> >>[ OK ] Reached target Initrd Root File System.
> >>Starting Reload Configuration from the Real Root...
> >>[ 61.288215] INFO: rcu_sched detected stalls on CPUs/tasks:
> >>[ 61.290791] 1-...!: (0 ticks this GP) idle=574/0/0 softirq=5/5 fqs=1
> >>[ 61.293664] (detected by 0, t=6002 jiffies, g=-263, c=-264, q=39760)
> >>[ 61.296480] Task dump for CPU 1:
> >>[ 61.297938] swapper/1 R running task 0 0 1 0x00000020
> >>[ 61.300643] Call trace:
> >>[ 61.301260] __switch_to+0x6c/0x78
> >>[ 61.302095] cpu_number+0x0/0x8
> >>[ 61.302867] rcu_sched kthread starved for 6000 jiffies!
> >>g18446744073709551353 c18446744073709551352 f0x0 RCU_GP_WAIT_FQS(3)
> >>->state=0x402 ->cpu=1
> >>[ 61.305941] rcu_sched I 0 8 2 0x00000020
> >>[ 61.307250] Call trace:
> >>[ 61.307854] __switch_to+0x6c/0x78
> >>[ 61.308693] __schedule+0x268/0x8f0
> >>[ 61.309545] schedule+0x2c/0x88
> >>[ 61.310325] schedule_timeout+0x84/0x3b8
> >>[ 61.311278] rcu_gp_kthread+0x4d4/0x7d8
> >>[ 61.312213] kthread+0x134/0x138
> >>[ 61.313001] ret_from_fork+0x10/0x1c
> >>
> >>Maybe my previous patch is not perfect enough, thanks for your comments.
> >>
> >>I digged it futher more, do you think below code logic is possibly
> >>problematic?
> >>
> >>
> >>vtimer_save_state           (vtimer->loaded = false, cntv_ctl is 0)
> >>
> >>kvm_arch_timer_handler        (read cntv_ctl and set vtimer->cnt_ctl = 0)
> >>
> >>vtimer_restore_state            (write vtimer->cnt_ctl to cntv_ctl,
> >>then cntv_ctl will
> >>
> >>                        be 0 forever)
> >>
> >>
> >>If above analysis is reasonable
> >Yes, I think there's something there if the hardware doesn't retire the
> >signal fast enough...
> >
> >>how about below patch? already
> >>tested in my arm64 server.
> >>
> >>diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >>index f9555b1..ee6dd3f 100644
> >>--- a/virt/kvm/arm/arch_timer.c
> >>+++ b/virt/kvm/arm/arch_timer.c
> >>@@ -99,7 +99,7 @@ static irqreturn_t kvm_arch_timer_handler(int irq,
> >>void *dev_id)
> >>         }
> >>         vtimer = vcpu_vtimer(vcpu);
> >>
> >>-       if (!vtimer->irq.level) {
> >>+       if (vtimer->loaded && !vtimer->irq.level) {
> >>                 vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> >>                 if (kvm_timer_irq_can_fire(vtimer))
> >>                         kvm_timer_update_irq(vcpu, true, vtimer);
> >>
> >There's nothing really wrong with that patch, I just didn't think it
> >would be necessary, as we really shouldn't see interrupts if the timer
> >is not loaded.  Can you confirm that a WARN_ON(!vtimer->loaded) in
> >kvm_arch_timer_handler() gives you a splat?
> Please see the WARN_ON result (without my patch)
> [   72.171706] WARNING: CPU: 24 PID: 1768 at
> arch/arm64/kvm/../../../virt/kvm/arm/arch_timer.c:101
> kvm_arch_timer_handler+0xc0/0xc8
> 
> >Also, could you give the following a try (without your patch):
> >
> >diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >index 73d262c4712b..4751255345d1 100644
> >--- a/virt/kvm/arm/arch_timer.c
> >+++ b/virt/kvm/arm/arch_timer.c
> >@@ -367,6 +367,7 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
> >  	/* Disable the virtual timer */
> >  	write_sysreg_el0(0, cntv_ctl);
> >+	isb();
> No luck， the bug is still there
> 

ok, so this is a slightly different approach to what you were trying to
do.  Can you please give this a try and let me know how it goes?


diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 73d262c4712b..544ed15fbbb3 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -46,7 +46,7 @@ static const struct kvm_irq_level default_vtimer_irq = {
 	.level	= 1,
 };
 
-static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
+static bool kvm_timer_irq_can_fire(u32 cnt_ctl);
 static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 				 struct arch_timer_context *timer_ctx);
 static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
@@ -94,6 +94,7 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 {
 	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
 	struct arch_timer_context *vtimer;
+	u32 cnt_ctl;
 
 	if (!vcpu) {
 		pr_warn_once("Spurious arch timer IRQ on non-VCPU thread\n");
@@ -101,8 +102,8 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 	}
 	vtimer = vcpu_vtimer(vcpu);
 
-	vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
-	if (kvm_timer_irq_can_fire(vtimer))
+	cnt_ctl = read_sysreg_el0(cntv_ctl);
+	if (kvm_timer_irq_can_fire(cnt_ctl))
 		kvm_timer_update_irq(vcpu, true, vtimer);
 
 	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
@@ -148,10 +149,10 @@ static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
 	return 0;
 }
 
-static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
+static bool kvm_timer_irq_can_fire(u32 cnt_ctl)
 {
-	return !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
-		(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
+	return !(cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
+		(cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
 }
 
 /*
@@ -164,10 +165,10 @@ static u64 kvm_timer_earliest_exp(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
-	if (kvm_timer_irq_can_fire(vtimer))
+	if (kvm_timer_irq_can_fire(vtimer->cnt_ctl))
 		min_virt = kvm_timer_compute_delta(vtimer);
 
-	if (kvm_timer_irq_can_fire(ptimer))
+	if (kvm_timer_irq_can_fire(ptimer->cnt_ctl))
 		min_phys = kvm_timer_compute_delta(ptimer);
 
 	/* If none of timers can fire, then return 0 */
@@ -231,7 +232,7 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 {
 	u64 cval, now;
 
-	if (!kvm_timer_irq_can_fire(timer_ctx))
+	if (!kvm_timer_irq_can_fire(timer_ctx->cnt_ctl))
 		return false;
 
 	cval = timer_ctx->cnt_cval;
@@ -306,7 +307,7 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu)
 	 * don't need to have a soft timer scheduled for the future.  If the
 	 * timer cannot fire at all, then we also don't need a soft timer.
 	 */
-	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer)) {
+	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer->cnt_ctl)) {
 		soft_timer_cancel(&timer->phys_timer, NULL);
 		return;
 	}
@@ -367,6 +368,7 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
 
 	/* Disable the virtual timer */
 	write_sysreg_el0(0, cntv_ctl);
+	isb();
 
 	vtimer->loaded = false;
 out:
@@ -398,7 +400,8 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 	 * If both timers are not capable of raising interrupts (disabled or
 	 * masked), then there's no more work for us to do.
 	 */
-	if (!kvm_timer_irq_can_fire(vtimer) && !kvm_timer_irq_can_fire(ptimer))
+	if (!kvm_timer_irq_can_fire(vtimer->cnt_ctl) &&
+	    !kvm_timer_irq_can_fire(ptimer->cnt_ctl))
 		return;
 
 	/*

Thanks,
-Christoffer
