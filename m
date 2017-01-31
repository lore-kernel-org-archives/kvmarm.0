From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 11/13] arm64: kvm: use common invariant sysreg definitions
Date: Tue, 31 Jan 2017 18:05:49 +0000
Message-ID: <1485885951-2747-12-git-send-email-mark.rutland@arm.com>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA8140B5C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:07:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 89AGo92lVsuq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:07:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8D4240BE4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:07:05 -0500 (EST)
In-Reply-To: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that we have common definitions for the register encodings used by
KVM, make the KVM code uses thse for invariant sysreg definitions. This
makes said definitions a reasonable amount shorter, especially as many
comments are rendered redundant and can be removed.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/sys_regs.c | 57 ++++++++++++++++-------------------------------
 1 file changed, 19 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 332aa1b..ec01776 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1790,44 +1790,25 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] = {
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b000),
-	  NULL, get_midr_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b110),
-	  NULL, get_revidr_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b000),
-	  NULL, get_id_pfr0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b001),
-	  NULL, get_id_pfr1_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b010),
-	  NULL, get_id_dfr0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b011),
-	  NULL, get_id_afr0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b100),
-	  NULL, get_id_mmfr0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b101),
-	  NULL, get_id_mmfr1_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b110),
-	  NULL, get_id_mmfr2_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b111),
-	  NULL, get_id_mmfr3_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b000),
-	  NULL, get_id_isar0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b001),
-	  NULL, get_id_isar1_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b010),
-	  NULL, get_id_isar2_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b011),
-	  NULL, get_id_isar3_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b100),
-	  NULL, get_id_isar4_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b101),
-	  NULL, get_id_isar5_el1 },
-	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b001),
-	  NULL, get_clidr_el1 },
-	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b111),
-	  NULL, get_aidr_el1 },
-	{ Op0(0b11), Op1(0b011), CRn(0b0000), CRm(0b0000), Op2(0b001),
-	  NULL, get_ctr_el0 },
+	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
+	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
+	{ SYS_DESC(SYS_ID_PFR0_EL1), NULL, get_id_pfr0_el1 },
+	{ SYS_DESC(SYS_ID_PFR1_EL1), NULL, get_id_pfr1_el1 },
+	{ SYS_DESC(SYS_ID_DFR0_EL1), NULL, get_id_dfr0_el1 },
+	{ SYS_DESC(SYS_ID_AFR0_EL1), NULL, get_id_afr0_el1 },
+	{ SYS_DESC(SYS_ID_MMFR0_EL1), NULL, get_id_mmfr0_el1 },
+	{ SYS_DESC(SYS_ID_MMFR1_EL1), NULL, get_id_mmfr1_el1 },
+	{ SYS_DESC(SYS_ID_MMFR2_EL1), NULL, get_id_mmfr2_el1 },
+	{ SYS_DESC(SYS_ID_MMFR3_EL1), NULL, get_id_mmfr3_el1 },
+	{ SYS_DESC(SYS_ID_ISAR0_EL1), NULL, get_id_isar0_el1 },
+	{ SYS_DESC(SYS_ID_ISAR1_EL1), NULL, get_id_isar1_el1 },
+	{ SYS_DESC(SYS_ID_ISAR2_EL1), NULL, get_id_isar2_el1 },
+	{ SYS_DESC(SYS_ID_ISAR3_EL1), NULL, get_id_isar3_el1 },
+	{ SYS_DESC(SYS_ID_ISAR4_EL1), NULL, get_id_isar4_el1 },
+	{ SYS_DESC(SYS_ID_ISAR5_EL1), NULL, get_id_isar5_el1 },
+	{ SYS_DESC(SYS_CLIDR_EL1), NULL, get_clidr_el1 },
+	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
+	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
 };
 
 static int reg_from_user(u64 *val, const void __user *uaddr, u64 id)
-- 
1.9.1
