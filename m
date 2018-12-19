From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 20/28] KVM: arm/arm64: Remove arch timer workqueue
Date: Wed, 19 Dec 2018 18:03:41 +0000
Message-ID: <20181219180349.242681-21-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CED1749F94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BRa53Uuw6veY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:05:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79E5D4A37A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:05 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

The use of a work queue in the hrtimer expire function for the bg_timer
is a leftover from the time when we would inject interrupts when the
bg_timer expired.

Since we are no longer doing that, we can instead call
kvm_vcpu_wake_up() directly from the hrtimer function and remove all
workqueue functionality from the arch timer code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_arch_timer.h |  4 ----
 virt/kvm/arm/arch_timer.c    | 34 +++++++---------------------------
 2 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 6502feb9524b..33771352dcd6 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -21,7 +21,6 @@
 
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
-#include <linux/workqueue.h>
 
 struct arch_timer_context {
 	/* Registers: control register, timer value */
@@ -52,9 +51,6 @@ struct arch_timer_cpu {
 	/* Background timer used when the guest is not running */
 	struct hrtimer			bg_timer;
 
-	/* Work queued with the above timer expires */
-	struct work_struct		expired;
-
 	/* Physical timer emulation */
 	struct hrtimer			phys_timer;
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 17cecc96f735..da261f5e2a91 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -70,11 +70,9 @@ static void soft_timer_start(struct hrtimer *hrt, u64 ns)
 		      HRTIMER_MODE_ABS);
 }
 
-static void soft_timer_cancel(struct hrtimer *hrt, struct work_struct *work)
+static void soft_timer_cancel(struct hrtimer *hrt)
 {
 	hrtimer_cancel(hrt);
-	if (work)
-		cancel_work_sync(work);
 }
 
 static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
@@ -102,23 +100,6 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/*
- * Work function for handling the backup timer that we schedule when a vcpu is
- * no longer running, but had a timer programmed to fire in the future.
- */
-static void kvm_timer_inject_irq_work(struct work_struct *work)
-{
-	struct kvm_vcpu *vcpu;
-
-	vcpu = container_of(work, struct kvm_vcpu, arch.timer_cpu.expired);
-
-	/*
-	 * If the vcpu is blocked we want to wake it up so that it will see
-	 * the timer has expired when entering the guest.
-	 */
-	kvm_vcpu_wake_up(vcpu);
-}
-
 static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
 {
 	u64 cval, now;
@@ -188,7 +169,7 @@ static enum hrtimer_restart kvm_bg_timer_expire(struct hrtimer *hrt)
 		return HRTIMER_RESTART;
 	}
 
-	schedule_work(&timer->expired);
+	kvm_vcpu_wake_up(vcpu);
 	return HRTIMER_NORESTART;
 }
 
@@ -300,7 +281,7 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu)
 	 * then we also don't need a soft timer.
 	 */
 	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer)) {
-		soft_timer_cancel(&timer->phys_timer, NULL);
+		soft_timer_cancel(&timer->phys_timer);
 		return;
 	}
 
@@ -426,7 +407,7 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
 
 	vtimer_restore_state(vcpu);
 
-	soft_timer_cancel(&timer->bg_timer, &timer->expired);
+	soft_timer_cancel(&timer->bg_timer);
 }
 
 static void set_cntvoff(u64 cntvoff)
@@ -544,7 +525,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	 * In any case, we re-schedule the hrtimer for the physical timer when
 	 * coming back to the VCPU thread in kvm_timer_vcpu_load().
 	 */
-	soft_timer_cancel(&timer->phys_timer, NULL);
+	soft_timer_cancel(&timer->phys_timer);
 
 	/*
 	 * The kernel may decide to run userspace after calling vcpu_put, so
@@ -637,7 +618,6 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
 	vcpu_ptimer(vcpu)->cntvoff = 0;
 
-	INIT_WORK(&timer->expired, kvm_timer_inject_irq_work);
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	timer->bg_timer.function = kvm_bg_timer_expire;
 
@@ -794,8 +774,8 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	soft_timer_cancel(&timer->bg_timer, &timer->expired);
-	soft_timer_cancel(&timer->phys_timer, NULL);
+	soft_timer_cancel(&timer->bg_timer);
+	soft_timer_cancel(&timer->phys_timer);
 	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
 }
 
-- 
2.19.2
