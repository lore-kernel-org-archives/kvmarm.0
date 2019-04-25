From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] KVM: arm/arm64: Don't emulate virtual timers on userspace
 ioctls
Date: Thu, 25 Apr 2019 13:57:40 +0100
Message-ID: <20190425125740.238036-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D76044A331
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 08:57:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R5xY-aeFECnd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 08:57:56 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81C454A321
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 08:57:56 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

When a VCPU never runs before a guest exists, but we set timer registers
up via ioctls, the associated hrtimer might never get cancelled.

Since we moved vcpu_load/put into the arch-specific implementations and
only have load/put for KVM_RUN, we won't ever have a scheduled hrtimer
for emulating a timer when modifying the timer state via an ioctl from
user space.  All we need to do is make sure that we pick up the right
state when we load the timer state next time userspace calls KVM_RUN
again.

We also do not need to worry about this interacting with the bg_timer,
because if we were in WFI from the guest, and somehow ended up in a
kvm_arm_timer_set_reg, it means that:

 1. the VCPU thread has received a signal,
 2. we have called vcpu_load when being scheduled in again,
 3. we have called vcpu_put when we returned to userspace for it to issue
    another ioctl

And therefore will not have a bg_timer programmed and the event is
treated as a spurious wakeup from WFI if userspace decides to run the
vcpu again even if there are not virtual interrupts.

This fixes stray virtual timer interrupts triggered by an expiring
hrtimer, which happens after a failed live migration, for instance.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Reported-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/arch_timer.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 3417f2dbc366..3538bc39a87a 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -507,6 +507,14 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
+	/*
+	 * Update the timer output so that it is likely to match the
+	 * state we're about to restore. If the timer expires between
+	 * this point and the register restoration, we'll take the
+	 * interrupt anyway.
+	 */
+	kvm_timer_update_irq(vcpu, kvm_timer_should_fire(vtimer), vtimer);
+
 	/*
 	 * When using a userspace irqchip with the architected timers and a
 	 * host interrupt controller that doesn't support an active state, we
@@ -730,7 +738,6 @@ static void kvm_timer_init_interrupt(void *info)
 int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 {
 	struct arch_timer_context *timer;
-	bool level;
 
 	switch (regid) {
 	case KVM_REG_ARM_TIMER_CTL:
@@ -758,10 +765,6 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 		return -1;
 	}
 
-	level = kvm_timer_should_fire(timer);
-	kvm_timer_update_irq(vcpu, level, timer);
-	timer_emulate(timer);
-
 	return 0;
 }
 
-- 
2.17.1
