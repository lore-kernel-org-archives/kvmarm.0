From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 23/25] KVM: arm/arm64: Set up a background timer for the
 physical timer emulation
Date: Thu,  9 Feb 2017 14:59:21 +0000
Message-ID: <1486652363-7696-24-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4175D40A63
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lRLV9I3Y5W7z for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Feb 2017 09:59:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05C9F40C5D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:48 -0500 (EST)
In-Reply-To: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Jintack Lim <jintack@cs.columbia.edu>

Set a background timer for the EL1 physical timer emulation while VMs
are running, so that VMs get the physical timer interrupts in a timely
manner.

Schedule the background timer on entry to the VM and cancel it on exit.
This would not have any performance impact to the guest OSes that
currently use the virtual timer since the physical timer is always not
enabled.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 0ea7452..33257b5 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -229,6 +229,22 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+/* Schedule the background timer for the emulated timer. */
+static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
+			      struct arch_timer_context *timer_ctx)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	if (kvm_timer_should_fire(timer_ctx))
+		return;
+
+	if (!kvm_timer_irq_can_fire(timer_ctx))
+		return;
+
+	/*  The timer has not yet expired, schedule a background timer */
+	timer_arm(timer, kvm_timer_compute_delta(timer_ctx));
+}
+
 /*
  * Schedule the background timer before calling kvm_vcpu_block, so that this
  * thread is removed from its waitqueue and made runnable when there's a timer
@@ -286,6 +302,9 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (kvm_timer_update_state(vcpu))
 		return;
 
+	/* Set the background timer for the physical timer emulation. */
+	kvm_timer_emulate(vcpu, vcpu_ptimer(vcpu));
+
 	/*
 	* If we enter the guest with the virtual input level to the VGIC
 	* asserted, then we have already told the VGIC what we need to, and
@@ -348,7 +367,11 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
-	BUG_ON(timer_is_armed(timer));
+	/*
+	 * This is to cancel the background timer for the physical timer
+	 * emulation if it is set.
+	 */
+	timer_disarm(timer);
 
 	/*
 	 * The guest could have modified the timer registers or the timer
-- 
2.1.4
