From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v3 06/10] KVM: arm/arm64: Update the physical timer interrupt
 level
Date: Wed,  1 Feb 2017 12:43:06 -0500
Message-ID: <1485970990-13775-7-git-send-email-jintack@cs.columbia.edu>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A64A40C17
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gEIelq7js-x7 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 12:43:01 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C36740BD7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:00 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v11He8iQ030672
 for <kvmarm@lists.cs.columbia.edu>; Wed, 1 Feb 2017 12:43:21 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 9450881
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:21 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 7CD6086
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:21 -0500 (EST)
Received: from mail-qt0-f199.google.com (mail-qt0-f199.google.com
 [209.85.216.199])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v11HhL5X044953
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 1 Feb 2017 12:43:21 -0500
Received: by mail-qt0-f199.google.com with SMTP id c25so153960184qtg.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Feb 2017 09:43:21 -0800 (PST)
In-Reply-To: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
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

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 virt/kvm/arm/arch_timer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index ae38703..1b086fd6 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -186,6 +186,7 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	/*
 	 * If userspace modified the timer registers via SET_ONE_REG before
@@ -199,6 +200,9 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	if (kvm_timer_should_fire(vtimer) != vtimer->irq.level)
 		kvm_timer_update_irq(vcpu, !vtimer->irq.level, vtimer);
 
+	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
+		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
+
 	return 0;
 }
 
-- 
1.9.1
