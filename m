From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v2 08/10] KVM: arm/arm64: Set up a background timer for the
 physical timer emulation
Date: Thu, 26 Jan 2017 20:04:58 -0500
Message-ID: <1485479100-4966-9-git-send-email-jintack@cs.columbia.edu>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D22440A06
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kkLEDX5E3Vs9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jan 2017 20:05:05 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0B1D40A1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:04:59 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R156ox063917
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:11 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 4378C87
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:11 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 5A3618D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:10 -0500 (EST)
Received: from mail-qt0-f199.google.com (mail-qt0-f199.google.com
 [209.85.216.199])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R15AE0035950
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:10 -0500
Received: by mail-qt0-f199.google.com with SMTP id k15so256521545qtg.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 17:05:10 -0800 (PST)
In-Reply-To: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Set a background timer for the EL1 physical timer emulation while VMs
are running, so that VMs get the physical timer interrupts in a timely
manner.

Schedule the background timer on entry to the VM and cancel it on exit.
This would not have any performance impact to the guest OSes that
currently use the virtual timer since the physical timer is always not
enabled.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 virt/kvm/arm/arch_timer.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index d3925e2..b366bb2 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -247,6 +247,23 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+/* Schedule the background timer for the emulated timer. */
+static void kvm_timer_emulate(struct kvm_vcpu *vcpu,
+			      struct arch_timer_context *timer_ctx)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	if (kvm_timer_should_fire(vcpu, timer_ctx))
+		return;
+
+	if (!kvm_timer_irq_can_fire(timer_ctx))
+		return;
+
+	/*  The timer has not yet expired, schedule a background timer */
+	BUG_ON(timer_is_armed(timer));
+	timer_arm(timer, kvm_timer_compute_delta(vcpu, timer_ctx));
+}
+
 /*
  * Schedule the background timer before calling kvm_vcpu_block, so that this
  * thread is removed from its waitqueue and made runnable when there's a timer
@@ -306,6 +323,9 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (kvm_timer_update_state(vcpu))
 		return;
 
+	/* Set the background timer for the physical timer emulation. */
+	kvm_timer_emulate(vcpu, vcpu_ptimer(vcpu));
+
 	/*
 	* If we enter the guest with the virtual input level to the VGIC
 	* asserted, then we have already told the VGIC what we need to, and
@@ -368,7 +388,11 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
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
1.9.1
