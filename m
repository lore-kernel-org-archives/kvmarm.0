From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 18/22] KVM: ARM64: Add access handlers for PMEVCNTRn and
 PMEVTYPERn register
Date: Fri, 11 Sep 2015 16:55:11 +0800
Message-ID: <1441961715-11688-19-git-send-email-zhaoshenglong@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDDC941349
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ELmNobWcPWX7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2015 04:55:45 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60E27418D8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:37 -0400 (EDT)
In-Reply-To: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Add access handler which emulates writing and reading PMEVCNTRn and
PMEVTYPERn.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 164 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 24d00a0..cf2cb47 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -395,6 +395,20 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
 	  trap_debug_regs, reset_val, (DBGWCR0_EL1 + (n)), 0 }
 
+/* Macro to expand the PMEVCNTRn_EL0 register */
+#define PMU_PMEVCNTR_EL0(n)						\
+	/* PMEVCNTRn_EL0 */						\
+	{ Op0(0b11), Op1(0b011), CRn(0b1110),				\
+	  CRm((0b1000 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
+	  access_pmu_regs, reset_unknown, (PMEVCNTR0_EL0 + n), }
+
+/* Macro to expand the PMEVTYPERn_EL0 register */
+#define PMU_PMEVTYPER_EL0(n)						\
+	/* PMEVTYPERn_EL0 */						\
+	{ Op0(0b11), Op1(0b011), CRn(0b1110),				\
+	  CRm((0b1100 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
+	  access_pmu_regs, reset_unknown, (PMEVTYPER0_EL0 + n), }
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -616,6 +630,74 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b011),
 	  NULL, reset_unknown, TPIDRRO_EL0 },
 
+	/* PMEVCNTRn_EL0 */
+	PMU_PMEVCNTR_EL0(0),
+	PMU_PMEVCNTR_EL0(1),
+	PMU_PMEVCNTR_EL0(2),
+	PMU_PMEVCNTR_EL0(3),
+	PMU_PMEVCNTR_EL0(4),
+	PMU_PMEVCNTR_EL0(5),
+	PMU_PMEVCNTR_EL0(6),
+	PMU_PMEVCNTR_EL0(7),
+	PMU_PMEVCNTR_EL0(8),
+	PMU_PMEVCNTR_EL0(9),
+	PMU_PMEVCNTR_EL0(10),
+	PMU_PMEVCNTR_EL0(11),
+	PMU_PMEVCNTR_EL0(12),
+	PMU_PMEVCNTR_EL0(13),
+	PMU_PMEVCNTR_EL0(14),
+	PMU_PMEVCNTR_EL0(15),
+	PMU_PMEVCNTR_EL0(16),
+	PMU_PMEVCNTR_EL0(17),
+	PMU_PMEVCNTR_EL0(18),
+	PMU_PMEVCNTR_EL0(19),
+	PMU_PMEVCNTR_EL0(20),
+	PMU_PMEVCNTR_EL0(21),
+	PMU_PMEVCNTR_EL0(22),
+	PMU_PMEVCNTR_EL0(23),
+	PMU_PMEVCNTR_EL0(24),
+	PMU_PMEVCNTR_EL0(25),
+	PMU_PMEVCNTR_EL0(26),
+	PMU_PMEVCNTR_EL0(27),
+	PMU_PMEVCNTR_EL0(28),
+	PMU_PMEVCNTR_EL0(29),
+	PMU_PMEVCNTR_EL0(30),
+	/* PMEVTYPERn_EL0 */
+	PMU_PMEVTYPER_EL0(0),
+	PMU_PMEVTYPER_EL0(1),
+	PMU_PMEVTYPER_EL0(2),
+	PMU_PMEVTYPER_EL0(3),
+	PMU_PMEVTYPER_EL0(4),
+	PMU_PMEVTYPER_EL0(5),
+	PMU_PMEVTYPER_EL0(6),
+	PMU_PMEVTYPER_EL0(7),
+	PMU_PMEVTYPER_EL0(8),
+	PMU_PMEVTYPER_EL0(9),
+	PMU_PMEVTYPER_EL0(10),
+	PMU_PMEVTYPER_EL0(11),
+	PMU_PMEVTYPER_EL0(12),
+	PMU_PMEVTYPER_EL0(13),
+	PMU_PMEVTYPER_EL0(14),
+	PMU_PMEVTYPER_EL0(15),
+	PMU_PMEVTYPER_EL0(16),
+	PMU_PMEVTYPER_EL0(17),
+	PMU_PMEVTYPER_EL0(18),
+	PMU_PMEVTYPER_EL0(19),
+	PMU_PMEVTYPER_EL0(20),
+	PMU_PMEVTYPER_EL0(21),
+	PMU_PMEVTYPER_EL0(22),
+	PMU_PMEVTYPER_EL0(23),
+	PMU_PMEVTYPER_EL0(24),
+	PMU_PMEVTYPER_EL0(25),
+	PMU_PMEVTYPER_EL0(26),
+	PMU_PMEVTYPER_EL0(27),
+	PMU_PMEVTYPER_EL0(28),
+	PMU_PMEVTYPER_EL0(29),
+	PMU_PMEVTYPER_EL0(30),
+	/* PMCCFILTR_EL0 */
+	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b1111), Op2(0b111),
+	  access_pmu_regs, reset_unknown, PMCCFILTR_EL0, },
+
 	/* DACR32_EL2 */
 	{ Op0(0b11), Op1(0b100), CRn(0b0011), CRm(0b0000), Op2(0b000),
 	  NULL, reset_unknown, DACR32_EL2 },
@@ -885,6 +967,20 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/* Macro to expand the PMEVCNTRn register */
+#define PMU_PMEVCNTR(n)							\
+	/* PMEVCNTRn */							\
+	{ Op1(0), CRn(0b1110),						\
+	  CRm((0b1000 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
+	  access_pmu_cp15_regs, reset_unknown_cp15, (c14_PMEVCNTR0 + n), }
+
+/* Macro to expand the PMEVTYPERn register */
+#define PMU_PMEVTYPER(n)						\
+	/* PMEVTYPERn */						\
+	{ Op1(0), CRn(0b1110),						\
+	  CRm((0b1100 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
+	  access_pmu_cp15_regs, reset_unknown_cp15, (c14_PMEVTYPER0 + n), }
+
 /*
  * Trapped cp15 registers. TTBR0/TTBR1 get a double encoding,
  * depending on the way they are accessed (as a 32bit or a 64bit
@@ -953,6 +1049,74 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn(12), CRm(12), Op2( 5), trap_raz_wi },
 
 	{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, c13_CID },
+
+	/* PMEVCNTRn */
+	PMU_PMEVCNTR(0),
+	PMU_PMEVCNTR(1),
+	PMU_PMEVCNTR(2),
+	PMU_PMEVCNTR(3),
+	PMU_PMEVCNTR(4),
+	PMU_PMEVCNTR(5),
+	PMU_PMEVCNTR(6),
+	PMU_PMEVCNTR(7),
+	PMU_PMEVCNTR(8),
+	PMU_PMEVCNTR(9),
+	PMU_PMEVCNTR(10),
+	PMU_PMEVCNTR(11),
+	PMU_PMEVCNTR(12),
+	PMU_PMEVCNTR(13),
+	PMU_PMEVCNTR(14),
+	PMU_PMEVCNTR(15),
+	PMU_PMEVCNTR(16),
+	PMU_PMEVCNTR(17),
+	PMU_PMEVCNTR(18),
+	PMU_PMEVCNTR(19),
+	PMU_PMEVCNTR(20),
+	PMU_PMEVCNTR(21),
+	PMU_PMEVCNTR(22),
+	PMU_PMEVCNTR(23),
+	PMU_PMEVCNTR(24),
+	PMU_PMEVCNTR(25),
+	PMU_PMEVCNTR(26),
+	PMU_PMEVCNTR(27),
+	PMU_PMEVCNTR(28),
+	PMU_PMEVCNTR(29),
+	PMU_PMEVCNTR(30),
+	/* PMEVTYPERn */
+	PMU_PMEVTYPER(0),
+	PMU_PMEVTYPER(1),
+	PMU_PMEVTYPER(2),
+	PMU_PMEVTYPER(3),
+	PMU_PMEVTYPER(4),
+	PMU_PMEVTYPER(5),
+	PMU_PMEVTYPER(6),
+	PMU_PMEVTYPER(7),
+	PMU_PMEVTYPER(8),
+	PMU_PMEVTYPER(9),
+	PMU_PMEVTYPER(10),
+	PMU_PMEVTYPER(11),
+	PMU_PMEVTYPER(12),
+	PMU_PMEVTYPER(13),
+	PMU_PMEVTYPER(14),
+	PMU_PMEVTYPER(15),
+	PMU_PMEVTYPER(16),
+	PMU_PMEVTYPER(17),
+	PMU_PMEVTYPER(18),
+	PMU_PMEVTYPER(19),
+	PMU_PMEVTYPER(20),
+	PMU_PMEVTYPER(21),
+	PMU_PMEVTYPER(22),
+	PMU_PMEVTYPER(23),
+	PMU_PMEVTYPER(24),
+	PMU_PMEVTYPER(25),
+	PMU_PMEVTYPER(26),
+	PMU_PMEVTYPER(27),
+	PMU_PMEVTYPER(28),
+	PMU_PMEVTYPER(29),
+	PMU_PMEVTYPER(30),
+	/* PMCCFILTR */
+	{ Op1(0), CRn(14), CRm(15), Op2(7), access_pmu_cp15_regs,
+	  reset_val_cp15, c14_PMCCFILTR, 0 },
 };
 
 static const struct sys_reg_desc cp15_64_regs[] = {
-- 
2.0.4
