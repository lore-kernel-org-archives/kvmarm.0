From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v7 1/4] arm64: kvm: route synchronous external abort exceptions to EL2
Date: Tue, 17 Oct 2017 22:14:46 +0800
Message-ID: <1508249689-10350-2-git-send-email-gengdongjiu@huawei.com>
References: <1508249689-10350-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1508249689-10350-1-git-send-email-gengdongjiu@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, gengdongjiu@huawei.com, wuquanming@huawei.com, kristina.martsenko@arm.com, mingo@kernel.org, punit.agrawal@arm.com, stephen.boyd@linaro.org, kamensky@cisco.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

ARMv8.2 adds a new bit HCR_EL2.TEA which controls to
route synchronous external aborts to EL2, and adds a
trap control bit HCR_EL2.TERR which controls to
trap all Non-secure EL1&0 error record accesses to EL2.

This patch enables the two bits for the guest OS.
when an synchronous abort is generated in the guest OS,
it will trap to EL3 firmware, EL3 firmware will check the
HCR_EL2.TEA value to decide to jump to hypervisor or host
OS. Enabling HCR_EL2.TERR makes error record access
from guest trap to EL2.

Add some minimal emulation for RAS-Error-Record registers.
In the emulation, ERRIDR_EL1 and ERRSELR_EL1 are zero.
Then, the others ERX* registers are RAZ/WI.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/include/asm/kvm_arm.h     |  2 ++
 arch/arm64/include/asm/kvm_emulate.h |  7 +++++++
 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/asm/sysreg.h      | 10 +++++++++
 arch/arm64/kvm/sys_regs.c            | 40 ++++++++++++++++++++++++++++++++++++
 5 files changed, 61 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 61d694c..1188272 100644
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
index fe39e68..47983db 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -47,6 +47,13 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
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
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d686300..af55b3bc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -105,6 +105,8 @@ enum vcpu_sysreg {
 	TTBR1_EL1,	/* Translation Table Base Register 1 */
 	TCR_EL1,	/* Translation Control Register */
 	ESR_EL1,	/* Exception Syndrome Register */
+	ERRIDR_EL1,     /* Error Record ID Register */
+	ERRSELR_EL1,    /* Error Record Select Register */
 	AFSR0_EL1,	/* Auxiliary Fault Status Register 0 */
 	AFSR1_EL1,	/* Auxiliary Fault Status Register 1 */
 	FAR_EL1,	/* Fault Address Register */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 35b786b..bd11ca0 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -169,6 +169,16 @@
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
index 2e070d3..a74617b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -775,6 +775,36 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool access_error_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	/* accessing ERRIDR_EL1 */
+	if (r->CRm == 3 && r->Op2 == 0) {
+		if (p->is_write)
+			vcpu_sys_reg(vcpu, ERRIDR_EL1) = 0;
+
+		return trap_raz_wi(vcpu, p, r);
+	}
+
+	/* accessing ERRSELR_EL1 */
+	if (r->CRm == 3 && r->Op2 == 1) {
+		if (p->is_write)
+			vcpu_sys_reg(vcpu, ERRSELR_EL1) = 0;
+
+		return trap_raz_wi(vcpu, p, r);
+	}
+
+	/*
+	 * If ERRSELR_EL1.SEL is greater than or equal to ERRIDR_EL1.NUM,
+	 * the ERX* registers are RAZ/WI.
+	 */
+	if ((vcpu_sys_reg(vcpu, ERRSELR_EL1) & 0xff) >=
+			(vcpu_sys_reg(vcpu, ERRIDR_EL1) && 0xff))
+		return trap_raz_wi(vcpu, p, r);
+
+	return true;
+}
+
 static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
@@ -953,6 +983,16 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
+
+	{ SYS_DESC(SYS_ERRIDR_EL1), access_error_reg, reset_val, ERRIDR_EL1, 0 },
+	{ SYS_DESC(SYS_ERRSELR_EL1), access_error_reg, reset_val, ERRSELR_EL1, 0 },
+	{ SYS_DESC(SYS_ERXFR_EL1), access_error_reg },
+	{ SYS_DESC(SYS_ERXCTLR_EL1), access_error_reg },
+	{ SYS_DESC(SYS_ERXSTATUS_EL1), access_error_reg },
+	{ SYS_DESC(SYS_ERXADDR_EL1), access_error_reg },
+	{ SYS_DESC(SYS_ERXMISC0_EL1), access_error_reg },
+	{ SYS_DESC(SYS_ERXMISC1_EL1), access_error_reg },
+
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
-- 
2.10.1
