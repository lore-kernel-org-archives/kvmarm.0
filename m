From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v2 09/10] KVM: arm64: Add the EL1 physical timer access handler
Date: Thu, 26 Jan 2017 20:04:59 -0500
Message-ID: <1485479100-4966-10-git-send-email-jintack@cs.columbia.edu>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10A17409C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5n03Gmo99z3A for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jan 2017 20:05:05 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3C1A40A20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:04:59 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R156oM063935
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:11 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 480B390
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:11 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 26B5F94
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:11 -0500 (EST)
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com
 [209.85.216.197])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R15ACG035884
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:11 -0500
Received: by mail-qt0-f197.google.com with SMTP id x49so254845128qtc.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 17:05:11 -0800 (PST)
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

KVM traps on the EL1 phys timer accesses from VMs, but it doesn't handle
those traps. This results in terminating VMs. Instead, set a handler for
the EL1 phys timer access, and inject an undefined exception as an
intermediate step.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/sys_regs.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 87e7e66..fd9e747 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -820,6 +820,30 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	  CRm((0b1100 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
 	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
 
+static bool access_cntp_tval(struct kvm_vcpu *vcpu,
+		struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	kvm_inject_undefined(vcpu);
+	return true;
+}
+
+static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
+		struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	kvm_inject_undefined(vcpu);
+	return true;
+}
+
+static bool access_cntp_cval(struct kvm_vcpu *vcpu,
+		struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	kvm_inject_undefined(vcpu);
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -1029,6 +1053,16 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b011),
 	  NULL, reset_unknown, TPIDRRO_EL0 },
 
+	/* CNTP_TVAL_EL0 */
+	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b0010), Op2(0b000),
+	  access_cntp_tval },
+	/* CNTP_CTL_EL0 */
+	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b0010), Op2(0b001),
+	  access_cntp_ctl },
+	/* CNTP_CVAL_EL0 */
+	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b0010), Op2(0b010),
+	  access_cntp_cval },
+
 	/* PMEVCNTRn_EL0 */
 	PMU_PMEVCNTR_EL0(0),
 	PMU_PMEVCNTR_EL0(1),
-- 
1.9.1
