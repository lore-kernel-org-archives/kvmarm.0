From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 13/13] KVM: arm64: Emulate RAS error registers and set
 HCR_EL2's TERR & TEA
Date: Mon, 15 Jan 2018 19:39:06 +0000
Message-ID: <20180115193906.30053-14-james.morse@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C154549E14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:37:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cQQaO8H7xh+k for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 14:37:07 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 442D849DFA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:37:07 -0500 (EST)
In-Reply-To: <20180115193906.30053-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Dongjiu Geng <gengdongjiu@huawei.com>

ARMv8.2 adds a new bit HCR_EL2.TEA which routes synchronous external
aborts to EL2, and adds a trap control bit HCR_EL2.TERR which traps
all Non-secure EL1&0 error record accesses to EL2.

This patch enables the two bits for the guest OS, guaranteeing that
KVM takes external aborts and traps attempts to access the physical
error registers.

ERRIDR_EL1 advertises the number of error records, we return
zero meaning we can treat all the other registers as RAZ/WI too.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
[removed specific emulation, use trap_raz_wi() directly for everything,
 rephrased parts of the commit message]
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
v5 of this series/patch missed the Reviewed-by's, which come from here:
https://patchwork.kernel.org/patch/10017537/

 arch/arm64/include/asm/kvm_arm.h     |  2 ++
 arch/arm64/include/asm/kvm_emulate.h |  7 +++++++
 arch/arm64/include/asm/sysreg.h      | 10 ++++++++++
 arch/arm64/kvm/sys_regs.c            | 10 ++++++++++
 4 files changed, 29 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 715d395ef45b..b0c84171e6a3 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -23,6 +23,8 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_TEA		(UL(1) << 37)
+#define HCR_TERR	(UL(1) << 36)
 #define HCR_E2H		(UL(1) << 34)
 #define HCR_ID		(UL(1) << 33)
 #define HCR_CD		(UL(1) << 32)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index e002ab7f919a..413dc82b1e89 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -50,6 +50,13 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
 	if (is_kernel_in_hyp_mode())
 		vcpu->arch.hcr_el2 |= HCR_E2H;
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
+		/* route synchronous external abort exceptions to EL2 */
+		vcpu->arch.hcr_el2 |= HCR_TEA;
+		/* trap error record accesses */
+		vcpu->arch.hcr_el2 |= HCR_TERR;
+	}
+
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 }
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index e213bd92e998..a16eb8d00689 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -176,6 +176,16 @@
 #define SYS_AFSR0_EL1			sys_reg(3, 0, 5, 1, 0)
 #define SYS_AFSR1_EL1			sys_reg(3, 0, 5, 1, 1)
 #define SYS_ESR_EL1			sys_reg(3, 0, 5, 2, 0)
+
+#define SYS_ERRIDR_EL1			sys_reg(3, 0, 5, 3, 0)
+#define SYS_ERRSELR_EL1			sys_reg(3, 0, 5, 3, 1)
+#define SYS_ERXFR_EL1			sys_reg(3, 0, 5, 4, 0)
+#define SYS_ERXCTLR_EL1			sys_reg(3, 0, 5, 4, 1)
+#define SYS_ERXSTATUS_EL1		sys_reg(3, 0, 5, 4, 2)
+#define SYS_ERXADDR_EL1			sys_reg(3, 0, 5, 4, 3)
+#define SYS_ERXMISC0_EL1		sys_reg(3, 0, 5, 5, 0)
+#define SYS_ERXMISC1_EL1		sys_reg(3, 0, 5, 5, 1)
+
 #define SYS_FAR_EL1			sys_reg(3, 0, 6, 0, 0)
 #define SYS_PAR_EL1			sys_reg(3, 0, 7, 4, 0)
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9edf4ac8a320..50a43c7b97ca 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1159,6 +1159,16 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
+
+	{ SYS_DESC(SYS_ERRIDR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERRSELR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXFR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXCTLR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXSTATUS_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXADDR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
+
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
-- 
2.15.1
