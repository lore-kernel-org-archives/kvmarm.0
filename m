From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v2 06/10] KVM: arm/arm64: Update the physical timer interrupt
 level
Date: Thu, 26 Jan 2017 20:04:56 -0500
Message-ID: <1485479100-4966-7-git-send-email-jintack@cs.columbia.edu>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FB15409A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:04:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K8d2iNncmeyt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jan 2017 20:04:57 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89DB540980
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:04:57 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R156tv051189
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:08 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id E943981
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:08 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id C0C0487
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:08 -0500 (EST)
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com
 [209.85.216.198])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R158dp011909
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:08 -0500
Received: by mail-qt0-f198.google.com with SMTP id k15so256520682qtg.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 17:05:08 -0800 (PST)
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

Now that we maintain the EL1 physical timer register states of VMs,
update the physical timer interrupt level along with the virtual one.

Note that the emulated EL1 physical timer is not mapped to any hardware
timer, so we call a proper vgic function.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 virt/kvm/arm/arch_timer.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 0f6e935..3b6bd50 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -180,6 +180,21 @@ static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
 	WARN_ON(ret);
 }
 
+static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
+				 struct arch_timer_context *timer)
+{
+	int ret;
+
+	BUG_ON(!vgic_initialized(vcpu->kvm));
+
+	timer->irq.level = new_level;
+	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
+				   timer->irq.level);
+	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, timer->irq.irq,
+				  timer->irq.level);
+	WARN_ON(ret);
+}
+
 /*
  * Check if there was a change in the timer state (should we raise or lower
  * the line level to the GIC).
@@ -188,6 +203,7 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	/*
 	 * If userspace modified the timer registers via SET_ONE_REG before
@@ -201,6 +217,10 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	if (kvm_timer_should_fire(vcpu, vtimer) != vtimer->irq.level)
 		kvm_timer_update_mapped_irq(vcpu, !vtimer->irq.level, vtimer);
 
+	/* The emulated EL1 physical timer irq is not mapped to hardware */
+	if (kvm_timer_should_fire(vcpu, ptimer) != ptimer->irq.level)
+		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
+
 	return 0;
 }
 
-- 
1.9.1
