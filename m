From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v3 10/10] KVM: arm/arm64: Emulate the EL1 phys timer registers
Date: Wed,  1 Feb 2017 12:43:10 -0500
Message-ID: <1485970990-13775-11-git-send-email-jintack@cs.columbia.edu>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96AFF40C36
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Td6e5ysWD8h1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 12:43:05 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7307040C51
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:04 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v11He8aM030681
 for <kvmarm@lists.cs.columbia.edu>; Wed, 1 Feb 2017 12:43:25 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id C674D86
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:25 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id AF17286
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:25 -0500 (EST)
Received: from mail-qt0-f200.google.com (mail-qt0-f200.google.com
 [209.85.216.200])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v11HhPjw048258
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 1 Feb 2017 12:43:25 -0500
Received: by mail-qt0-f200.google.com with SMTP id x49so398065889qtc.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Feb 2017 09:43:25 -0800 (PST)
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

Emulate read and write operations to CNTP_TVAL, CNTP_CVAL and CNTP_CTL.
Now VMs are able to use the EL1 physical timer.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/sys_regs.c    | 37 ++++++++++++++++++++++++++++++++++---
 include/kvm/arm_arch_timer.h |  2 ++
 virt/kvm/arm/arch_timer.c    |  2 +-
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1cd3464..0e26f8c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -824,7 +824,14 @@ static bool access_cntp_tval(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	kvm_inject_undefined(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	u64 now = kvm_phys_timer_read();
+
+	if (p->is_write)
+		ptimer->cnt_cval = p->regval + now;
+	else
+		p->regval = ptimer->cnt_cval - now;
+
 	return true;
 }
 
@@ -832,7 +839,25 @@ static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	kvm_inject_undefined(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+
+	if (p->is_write) {
+		/* ISTATUS bit is read-only */
+		ptimer->cnt_ctl = p->regval & ~ARCH_TIMER_CTRL_IT_STAT;
+	} else {
+		u64 now = kvm_phys_timer_read();
+
+		p->regval = ptimer->cnt_ctl;
+		/*
+		 * Set ISTATUS bit if it's expired.
+		 * Note that according to ARMv8 ARM Issue A.k, ISTATUS bit is
+		 * UNKNOWN when ENABLE bit is 0, so we chose to set ISTATUS bit
+		 * regardless of ENABLE bit for our implementation convenience.
+		 */
+		if (ptimer->cnt_cval <= now)
+			p->regval |= ARCH_TIMER_CTRL_IT_STAT;
+	}
+
 	return true;
 }
 
@@ -840,7 +865,13 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
 {
-	kvm_inject_undefined(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+
+	if (p->is_write)
+		ptimer->cnt_cval = p->regval;
+	else
+		p->regval = ptimer->cnt_cval;
+
 	return true;
 }
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index f1d2fba0..fe797d6 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -72,6 +72,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 void kvm_timer_schedule(struct kvm_vcpu *vcpu);
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
 
+u64 kvm_phys_timer_read(void);
+
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
 void kvm_timer_init_vhe(void);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 1806e5e..93c811c 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -40,7 +40,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu_vtimer(vcpu)->active_cleared_last = false;
 }
 
-static u64 kvm_phys_timer_read(void)
+u64 kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
 }
-- 
1.9.1
