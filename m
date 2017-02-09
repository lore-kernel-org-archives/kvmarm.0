From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 24/25] KVM: arm64: Add the EL1 physical timer access handler
Date: Thu,  9 Feb 2017 14:59:22 +0000
Message-ID: <1486652363-7696-25-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 122A440BD2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y2gie+LneJaR for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Feb 2017 09:59:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BD9A40C28
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:50 -0500 (EST)
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

KVM traps on the EL1 phys timer accesses from VMs, but it doesn't handle
those traps. This results in terminating VMs. Instead, set a handler for
the EL1 phys timer access, and inject an undefined exception as an
intermediate step.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index caa47ce..1cd3464 100644
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
@@ -1029,6 +1053,16 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
2.1.4
