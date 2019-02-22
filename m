From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 08/27] KVM: arm/arm64: Simplify bg_timer programming
Date: Fri, 22 Feb 2019 16:25:46 +0000
Message-ID: <20190222162605.5054-9-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 144414A3BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:27:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ed+xPSnqyhDi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:27:38 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8334A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:27:38 -0500 (EST)
In-Reply-To: <20190222162605.5054-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

Instead of calling into kvm_timer_[un]schedule from the main kvm
blocking path, test if the VCPU is on the wait queue from the load/put
path and perform the background timer setup/cancel in this path.

This has the distinct advantage that we no longer race between load/put
and schedule/unschedule and programming and canceling of the bg_timer
always happens when the timer state is not loaded.

Note that we must now remove the checks in kvm_timer_blocking that do
not schedule a background timer if one of the timers can fire, because
we no longer have a guarantee that kvm_vcpu_check_block() will be called
before kvm_timer_blocking.

Reported-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_arch_timer.h |  3 ---
 virt/kvm/arm/arch_timer.c    | 35 ++++++++++++++---------------------
 virt/kvm/arm/arm.c           |  2 --
 3 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 33771352dcd6..d6e6a45d1d24 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -76,9 +76,6 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 
 bool kvm_timer_is_pending(struct kvm_vcpu *vcpu);
 
-void kvm_timer_schedule(struct kvm_vcpu *vcpu);
-void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
-
 u64 kvm_phys_timer_read(void);
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index b07ac4614e1c..4986028d9829 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -349,22 +349,12 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
  * thread is removed from its waitqueue and made runnable when there's a timer
  * interrupt to handle.
  */
-void kvm_timer_schedule(struct kvm_vcpu *vcpu)
+static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
-	vtimer_save_state(vcpu);
-
-	/*
-	 * No need to schedule a background timer if any guest timer has
-	 * already expired, because kvm_vcpu_block will return before putting
-	 * the thread to sleep.
-	 */
-	if (kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer))
-		return;
-
 	/*
 	 * If both timers are not capable of raising interrupts (disabled or
 	 * masked), then there's no more work for us to do.
@@ -373,12 +363,19 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 		return;
 
 	/*
-	 * The guest timers have not yet expired, schedule a background timer.
+	 * At least one guest time will expire. Schedule a background timer.
 	 * Set the earliest expiration time among the guest timers.
 	 */
 	soft_timer_start(&timer->bg_timer, kvm_timer_earliest_exp(vcpu));
 }
 
+static void kvm_timer_unblocking(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	soft_timer_cancel(&timer->bg_timer);
+}
+
 static void vtimer_restore_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
@@ -401,15 +398,6 @@ static void vtimer_restore_state(struct kvm_vcpu *vcpu)
 	local_irq_restore(flags);
 }
 
-void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
-{
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-
-	vtimer_restore_state(vcpu);
-
-	soft_timer_cancel(&timer->bg_timer);
-}
-
 static void set_cntvoff(u64 cntvoff)
 {
 	u32 low = lower_32_bits(cntvoff);
@@ -485,6 +473,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	/* Set the background timer for the physical timer emulation. */
 	phys_timer_emulate(vcpu);
 
+	kvm_timer_unblocking(vcpu);
+
 	/* If the timer fired while we weren't running, inject it now */
 	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
 		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
@@ -527,6 +517,9 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	 */
 	soft_timer_cancel(&timer->phys_timer);
 
+	if (swait_active(kvm_arch_vcpu_wq(vcpu)))
+		kvm_timer_blocking(vcpu);
+
 	/*
 	 * The kernel may decide to run userspace after calling vcpu_put, so
 	 * we reset cntvoff to 0 to ensure a consistent read between user
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index b77db673bb03..9fbdb9e1c51f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -335,13 +335,11 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
-	kvm_timer_schedule(vcpu);
 	kvm_vgic_v4_enable_doorbell(vcpu);
 }
 
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
-	kvm_timer_unschedule(vcpu);
 	kvm_vgic_v4_disable_doorbell(vcpu);
 }
 
-- 
2.20.1
