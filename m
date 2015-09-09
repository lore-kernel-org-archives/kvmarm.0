From: Tushar Jagad <tushar.jagad@linaro.org>
Subject: [PATCH RFC 2/4] arm64: kvm: enable trapping of read access to regs in
 TID3 group
Date: Wed,  9 Sep 2015 14:08:32 +0530
Message-ID: <1441787914-3191-3-git-send-email-tushar.jagad@linaro.org>
References: <1441787914-3191-1-git-send-email-tushar.jagad@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1441787914-3191-1-git-send-email-tushar.jagad@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, patches@apm.com, qemu-devel@nongnu.org, tushar.jagad@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch modifies the HCR_GUEST_FLAGS to enable trapping of
non secure read to registers under the HCR_EL2.TID3 group to EL2.

We emulate the accesses to capability registers which list the number of
breakpoints, watchpoints, etc. These values are provided by the user when
starting the VM. The emulated values are constructed at runtime from the
trap handler.

Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 Documentation/virtual/kvm/api.txt |    8 +
 arch/arm/kvm/arm.c                |   50 ++++-
 arch/arm64/include/asm/kvm_arm.h  |    2 +-
 arch/arm64/include/asm/kvm_asm.h  |   38 +++-
 arch/arm64/include/asm/kvm_host.h |    4 +-
 arch/arm64/include/uapi/asm/kvm.h |    7 +
 arch/arm64/kvm/sys_regs.c         |  443 +++++++++++++++++++++++++++++++++----
 7 files changed, 503 insertions(+), 49 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index a7926a9..b06c104 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2561,6 +2561,14 @@ Possible features:
 	  Depends on KVM_CAP_ARM_EL1_32BIT (arm64 only).
 	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 for the CPU.
 	  Depends on KVM_CAP_ARM_PSCI_0_2.
+	- KVM_ARM_VCPU_NUM_BPTS: Number of supported h/w breakpoints
+	  This is a 4-bit value which defines number of hardware
+	  breakpoints supported on guest. If this is not sepecified or
+	  set to zero then the guest sees the value as is from the host.
+	- KVM_ARM_VCPU_NUM_WPTS: Number of supported h/w watchpoints
+	  This is a 4-bit value which defines number of hardware
+	  watchpoints supported on guest. If this is not sepecified or
+	  set to zero then the guest sees the value as is from the host.
 
 
 4.83 KVM_ARM_PREFERRED_TARGET
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index bc738d2..8907d37 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -696,6 +696,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 			       const struct kvm_vcpu_init *init)
 {
 	unsigned int i;
+	u64 aa64dfr;
+
 	int phys_target = kvm_target_cpu();
 
 	if (init->target != phys_target)
@@ -708,6 +710,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	if (vcpu->arch.target != -1 && vcpu->arch.target != init->target)
 		return -EINVAL;
 
+	asm volatile("mrs %0, ID_AA64DFR0_EL1\n" : "=r" (aa64dfr));
+
 	/* -ENOENT for unknown features, -EINVAL for invalid combinations. */
 	for (i = 0; i < sizeof(init->features) * 8; i++) {
 		bool set = (init->features[i / 32] & (1 << (i % 32)));
@@ -715,6 +719,50 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 		if (set && i >= KVM_VCPU_MAX_FEATURES)
 			return -ENOENT;
 
+		if (i == KVM_ARM_VCPU_NUM_BPTS) {
+			int h_bpts;
+			int g_bpts;
+
+			h_bpts = ((aa64dfr >> 12) & 0xf) + 1;
+			g_bpts = (init->features[KVM_ARM_VCPU_BPTS_FEATURES_IDX] &
+					KVM_ARM_VCPU_BPTS_MASK) >> KVM_ARM_VCPU_NUM_BPTS;
+
+			/*
+			 * We ensure that the host can support the requested
+			 * number of hardware breakpoints.
+			 */
+			if (g_bpts > h_bpts)
+				return -EINVAL;
+
+			vcpu->arch.bpts = g_bpts;
+
+			i  += 3;
+
+			continue;
+		}
+
+		if (i == KVM_ARM_VCPU_NUM_WPTS) {
+			int h_wpts;
+			int g_wpts;
+
+			h_wpts = ((aa64dfr >> 20) & 0xf) + 1;
+			g_wpts = (init->features[KVM_ARM_VCPU_WPTS_FEATURES_IDX] &
+					KVM_ARM_VCPU_WPTS_MASK) >> KVM_ARM_VCPU_NUM_WPTS;
+
+			/*
+			 * We ensure that the host can support the requested
+			 * number of hardware watchpoints.
+			 */
+			if (g_wpts > h_wpts)
+				return -EINVAL;
+
+			vcpu->arch.wpts = g_wpts;
+
+			i += 3;
+
+			continue;
+		}
+
 		/*
 		 * Secondary and subsequent calls to KVM_ARM_VCPU_INIT must
 		 * use the same feature set.
@@ -727,7 +775,7 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 			set_bit(i, vcpu->arch.features);
 	}
 
-	vcpu->arch.target = phys_target;
+	vcpu->arch.target = init->target;
 
 	/* Now we know what it is, we can reset it. */
 	return kvm_reset_vcpu(vcpu);
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index ac6fafb..3b67051 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -78,7 +78,7 @@
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
-			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
+			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TID3)
 #define HCR_VIRT_EXCP_MASK (HCR_VA | HCR_VI | HCR_VF)
 #define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
 
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index c1d5bde..087d104 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -56,15 +56,39 @@
 #define DBGWVR15_EL1	86
 #define MDCCINT_EL1	87	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 #define MIDR_EL1	88	/* Main ID Register */
+#define ID_AA64MMFR0_EL1	89	/* AArch64 Memory Model Feature Register 0 */
+#define ID_AA64MMFR1_EL1	90	/* AArch64 Memory Model Feature Register 1 */
+#define MVFR0_EL1	91	/* AArch32 Media and VFP Feature Register 0 */
+#define MVFR1_EL1	92	/* AArch32 Media and VFP Feature Register 1 */
+#define MVFR2_EL1	93	/* AArch32 Media and VFP Feature Register 2 */
+#define ID_AA64PFR0_EL1	94	/* AArch64 Processor Feature Register 0 */
+#define ID_AA64PFR1_EL1	95	/* AArch64 Processor Feature Register 1 */
+#define ID_AA64DFR0_EL1	96	/* AArch64 Debug Feature Register 0 */
+#define ID_AA64DFR1_EL1	97	/* AArch64 Debug Feature Register 1 */
+#define ID_AA64ISAR0_EL1	98	/* AArch64 Instruction Set Attribute Register 0 */
+#define ID_AA64ISAR1_EL1	99	/* AArch64 Instruction Set Attribute Register 1 */
+#define ID_PFR0_EL1	100	/* AArch32 Processor Feature Register 0 */
+#define ID_PFR1_EL1	101	/* AArch32 Processor Feature Register 1 */
+#define ID_DFR0_EL1	102	/* AArch32 Debug Feature Register 0 */
+#define ID_ISAR0_EL1	103	/* AArch32 Instruction Set Attribute Register 0 */
+#define ID_ISAR1_EL1	104	/* AArch32 Instruction Set Attribute Register 1 */
+#define ID_ISAR2_EL1	105	/* AArch32 Instruction Set Attribute Register 2 */
+#define ID_ISAR3_EL1	106	/* AArch32 Instruction Set Attribute Register 3 */
+#define ID_ISAR4_EL1	107	/* AArch32 Instruction Set Attribute Register 4 */
+#define ID_ISAR5_EL1	108	/* AArch32 Instruction Set Attribute Register 5 */
+#define ID_MMFR0_EL1	109	/* AArch32 Memory Model Feature Register 0 */
+#define ID_MMFR1_EL1	110	/* AArch32 Memory Model Feature Register 1 */
+#define ID_MMFR2_EL1	111	/* AArch32 Memory Model Feature Register 2 */
+#define ID_MMFR3_EL1	112	/* AArch32 Memory Model Feature Register 3 */
 
 /* 32bit specific registers. Keep them at the end of the range */
-#define	DACR32_EL2	89	/* Domain Access Control Register */
-#define	IFSR32_EL2	90	/* Instruction Fault Status Register */
-#define	FPEXC32_EL2	91	/* Floating-Point Exception Control Register */
-#define	DBGVCR32_EL2	92	/* Debug Vector Catch Register */
-#define	TEECR32_EL1	93	/* ThumbEE Configuration Register */
-#define	TEEHBR32_EL1	94	/* ThumbEE Handler Base Register */
-#define	NR_SYS_REGS	95
+#define	DACR32_EL2	113	/* Domain Access Control Register */
+#define	IFSR32_EL2	114	/* Instruction Fault Status Register */
+#define	FPEXC32_EL2	115	/* Floating-Point Exception Control Register */
+#define	DBGVCR32_EL2	116	/* Debug Vector Catch Register */
+#define	TEECR32_EL1	117	/* ThumbEE Configuration Register */
+#define	TEEHBR32_EL1	118	/* ThumbEE Handler Base Register */
+#define	NR_SYS_REGS	119
 
 /* 32bit mapping */
 #define c0_MIDR		(MIDR_EL1 * 2)	/* Main ID Register */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2709db2..c780227 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -43,7 +43,7 @@
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
 
-#define KVM_VCPU_MAX_FEATURES 3
+#define KVM_VCPU_MAX_FEATURES 12
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
@@ -137,6 +137,8 @@ struct kvm_vcpu_arch {
 	/* Target CPU and feature flags */
 	int target;
 	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
+	u32 bpts;
+	u32 wpts;
 
 	/* Detect first run of a vcpu */
 	bool has_run_once;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index d268320..94d1fc9 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -88,6 +88,13 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
+#define KVM_ARM_VCPU_NUM_BPTS		3 /* Number of breakpoints supported */
+#define KVM_ARM_VCPU_NUM_WPTS		7 /* Number of watchpoints supported */
+
+#define KVM_ARM_VCPU_BPTS_FEATURES_IDX	0
+#define KVM_ARM_VCPU_WPTS_FEATURES_IDX	0
+#define KVM_ARM_VCPU_BPTS_MASK		0x00000078
+#define KVM_ARM_VCPU_WPTS_MASK		0x00000780
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7047292..273eecd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -244,6 +244,330 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
 }
 
+static bool trap_tid3(struct kvm_vcpu *vcpu,
+		const struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	if (p->is_write) {
+		vcpu_sys_reg(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
+	} else {
+		*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
+	}
+
+	return true;
+}
+
+static bool trap_pfr(struct kvm_vcpu *vcpu,
+		const struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	return trap_tid3(vcpu, p, r);
+}
+
+static void reset_pfr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u32 prf;
+	u32 idx;
+
+	switch (r->Op2) {
+	case 0:
+		asm volatile("mrs %0, ID_PFR0_EL1\n" : "=r" (prf));
+		idx = ID_PFR0_EL1;
+		break;
+	case 1:
+		asm volatile("mrs %0, ID_PFR1_EL1\n" : "=r" (prf));
+		idx = ID_PFR1_EL1;
+		break;
+
+	default:
+		BUG();
+	}
+
+	vcpu_sys_reg(vcpu, idx) = prf;
+}
+
+static bool trap_dfr(struct kvm_vcpu *vcpu,
+		const struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	return trap_tid3(vcpu, p, r);
+}
+
+static void reset_dfr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u32 dfr;
+
+	asm volatile("mrs %0, ID_DFR0_EL1\n" : "=r" (dfr));
+	vcpu_sys_reg(vcpu, ID_DFR0_EL1) = dfr;
+}
+
+static bool trap_mmfr(struct kvm_vcpu *vcpu,
+		const struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	return trap_tid3(vcpu, p, r);
+}
+
+static void reset_mmfr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u32 mmfr;
+	u32 idx;
+
+	switch (r->CRm) {
+	case 1:
+		switch (r->Op2) {
+		case 4:
+			asm volatile("mrs %0, ID_MMFR0_EL1\n" : "=r" (mmfr));
+			idx = ID_MMFR0_EL1;
+			break;
+
+		case 5:
+			asm volatile("mrs %0, ID_MMFR1_EL1\n" : "=r" (mmfr));
+			idx = ID_MMFR1_EL1;
+			break;
+
+		case 6:
+			asm volatile("mrs %0, ID_MMFR2_EL1\n" : "=r" (mmfr));
+			idx = ID_MMFR2_EL1;
+			break;
+
+		case 7:
+			asm volatile("mrs %0, ID_MMFR3_EL1\n" : "=r" (mmfr));
+			idx = ID_MMFR3_EL1;
+			break;
+
+		default:
+			BUG();
+		}
+		break;
+
+#if 0
+	case 2:
+		asm volatile("mrs %0, ID_MMFR4_EL1\n" : "=r" (mmfr));
+		idx = ID_MMFR4_EL1;
+		break;
+#endif
+
+	default:
+		BUG();
+	}
+	vcpu_sys_reg(vcpu, idx) = mmfr;
+}
+
+static bool trap_isar(struct kvm_vcpu *vcpu,
+		const struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	return trap_tid3(vcpu, p, r);
+}
+
+static void reset_isar(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u32 isar;
+	u32 idx;
+
+	switch (r->Op2) {
+	case 0:
+		asm volatile("mrs %0, ID_ISAR0_EL1\n" : "=r" (isar));
+		idx = ID_ISAR0_EL1;
+		break;
+
+	case 1:
+		asm volatile("mrs %0, ID_ISAR1_EL1\n" : "=r" (isar));
+		idx = ID_ISAR1_EL1;
+		break;
+
+	case 2:
+		asm volatile("mrs %0, ID_ISAR2_EL1\n" : "=r" (isar));
+		idx = ID_ISAR2_EL1;
+		break;
+
+	case 3:
+		asm volatile("mrs %0, ID_ISAR3_EL1\n" : "=r" (isar));
+		idx = ID_ISAR3_EL1;
+		break;
+
+	case 4:
+		asm volatile("mrs %0, ID_ISAR4_EL1\n" : "=r" (isar));
+		idx = ID_ISAR4_EL1;
+		break;
+
+	case 5:
+		asm volatile("mrs %0, ID_ISAR5_EL1\n" : "=r" (isar));
+		idx = ID_ISAR5_EL1;
+		break;
+
+	default:
+		BUG();
+	}
+	vcpu_sys_reg(vcpu, idx) = isar;
+}
+
+static bool trap_mvfr(struct kvm_vcpu *vcpu,
+		const struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	return trap_tid3(vcpu, p, r);
+}
+
+static void reset_mvfr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u32 mvfr;
+	u32 idx;
+
+	switch (r->Op2) {
+	case 0:
+		asm volatile("mrs %0, MVFR0_EL1\n" : "=r" (mvfr));
+		idx = MVFR0_EL1;
+		break;
+	case 1:
+		asm volatile("mrs %0, MVFR1_EL1\n" : "=r" (mvfr));
+		idx = MVFR1_EL1;
+		break;
+
+	case 2:
+		asm volatile("mrs %0, MVFR2_EL1\n" : "=r" (mvfr));
+		idx = MVFR2_EL1;
+		break;
+
+	default:
+		BUG();
+	}
+
+	vcpu_sys_reg(vcpu, idx) = mvfr;
+}
+
+static bool trap_aa64pfr(struct kvm_vcpu *vcpu,
+		const struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	return trap_tid3(vcpu, p, r);
+}
+
+static void reset_aa64pfr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 aa64pfr;
+	u32 idx;
+
+	switch (r->Op2) {
+	case 0:
+		asm volatile("mrs %0, ID_AA64PFR0_EL1\n" : "=r" (aa64pfr));
+		idx = ID_AA64PFR0_EL1;
+		break;
+	case 1:
+		asm volatile("mrs %0, ID_AA64PFR1_EL1\n" : "=r" (aa64pfr));
+		idx = ID_AA64PFR1_EL1;
+		break;
+
+	default:
+		BUG();
+	}
+
+	vcpu_sys_reg(vcpu, idx) = aa64pfr;
+}
+
+static bool trap_aa64dfr(struct kvm_vcpu *vcpu,
+		const struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	return trap_tid3(vcpu, p, r);
+}
+
+static void reset_aa64dfr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 aa64dfr;
+	u32 idx;
+	u32 bpts;
+	u32 wpts;
+
+	bpts = vcpu->arch.bpts;
+	if (bpts)
+		bpts--;
+
+	wpts = vcpu->arch.wpts;
+	if (wpts)
+		wpts--;
+
+	switch (r->Op2) {
+	case 0:
+		asm volatile("mrs %0, ID_AA64DFR0_EL1\n" : "=r" (aa64dfr));
+		idx = ID_AA64DFR0_EL1;
+		if (bpts)
+			aa64dfr = ((aa64dfr) & ~(0xf << 12)) | (bpts << 12) ;
+		if (wpts)
+			aa64dfr = ((aa64dfr) & ~(0xf << 20)) | (wpts << 20) ;
+		break;
+	case 1:
+		asm volatile("mrs %0, ID_AA64DFR1_EL1\n" : "=r" (aa64dfr));
+		idx = ID_AA64DFR1_EL1;
+		break;
+
+	default:
+		BUG();
+	}
+
+	vcpu_sys_reg(vcpu, idx) = aa64dfr;
+}
+
+static bool trap_aa64isar(struct kvm_vcpu *vcpu,
+		const struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	return trap_tid3(vcpu, p, r);
+}
+
+static void reset_aa64isar(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u32 aa64isar;
+	u32 idx;
+
+	switch (r->Op2) {
+	case 0:
+		asm volatile("mrs %0, ID_AA64ISAR0_EL1\n" : "=r" (aa64isar));
+		idx = ID_AA64ISAR0_EL1;
+		break;
+
+	case 1:
+		asm volatile("mrs %0, ID_AA64ISAR1_EL1\n" : "=r" (aa64isar));
+		idx = ID_AA64ISAR1_EL1;
+		break;
+
+	default:
+		BUG();
+	}
+	vcpu_sys_reg(vcpu, idx) = aa64isar;
+}
+
+static bool trap_aa64mmfr(struct kvm_vcpu *vcpu,
+		const struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	return trap_tid3(vcpu, p, r);
+}
+
+static void reset_aa64mmfr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 aa64mmfr;
+	u32 idx;
+
+	switch (r->Op2) {
+	case 0:
+		asm volatile("mrs %0, ID_AA64MMFR0_EL1\n" : "=r" (aa64mmfr));
+		idx = ID_AA64MMFR0_EL1;
+		break;
+	case 1:
+		asm volatile("mrs %0, ID_AA64MMFR1_EL1\n" : "=r" (aa64mmfr));
+		idx = ID_AA64MMFR1_EL1;
+		break;
+
+	default:
+		BUG();
+	}
+
+	vcpu_sys_reg(vcpu, idx) = aa64mmfr;
+}
+
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -364,6 +688,86 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* MPIDR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b101),
 	  NULL, reset_mpidr, MPIDR_EL1 },
+
+	/* ID_PFR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b000),
+	  trap_pfr, reset_pfr, ID_PFR0_EL1 },
+	/* ID_PFR1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b001),
+	  trap_pfr, reset_pfr, ID_PFR1_EL1 },
+	/* ID_DFR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b010),
+	  trap_dfr, reset_dfr, ID_DFR0_EL1 },
+	/* ID_MMFR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b100),
+	  trap_mmfr, reset_mmfr, ID_MMFR0_EL1 },
+	/* ID_MMFR1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b101),
+	  trap_mmfr, reset_mmfr, ID_MMFR1_EL1 },
+	/* ID_MMFR2_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b110),
+	  trap_mmfr, reset_mmfr, ID_MMFR2_EL1 },
+	/* ID_MMFR3_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b111),
+	  trap_mmfr, reset_mmfr, ID_MMFR3_EL1 },
+
+	/* ID_ISAR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b000),
+	  trap_isar, reset_isar, ID_ISAR0_EL1 },
+	/* ID_ISAR1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b001),
+	  trap_isar, reset_isar, ID_ISAR1_EL1 },
+	/* ID_ISAR2_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b010),
+	  trap_isar, reset_isar, ID_ISAR2_EL1 },
+	/* ID_ISAR3_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b011),
+	  trap_isar, reset_isar, ID_ISAR3_EL1 },
+	/* ID_ISAR4_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b100),
+	  trap_isar, reset_isar, ID_ISAR4_EL1 },
+	/* ID_ISAR5_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b101),
+	  trap_isar, reset_isar, ID_ISAR5_EL1 },
+
+	/* MVFR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0011), Op2(0b000),
+	  trap_mvfr, reset_mvfr, MVFR0_EL1 },
+	/* MVFR1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0011), Op2(0b001),
+	  trap_mvfr, reset_mvfr, MVFR1_EL1 },
+	/* MVFR2_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0011), Op2(0b010),
+	  trap_mvfr, reset_mvfr, MVFR2_EL1 },
+
+	/* ID_AA64PFR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0100), Op2(0b000),
+	  trap_aa64pfr, reset_aa64pfr, ID_AA64PFR0_EL1 },
+	/* ID_AA64PFR1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0100), Op2(0b001),
+	  trap_aa64pfr, reset_aa64pfr, ID_AA64PFR1_EL1 },
+
+	/* ID_AA64DFR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0101), Op2(0b000),
+	  trap_aa64dfr, reset_aa64dfr, ID_AA64DFR0_EL1 },
+	/* ID_AA64DFR1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0101), Op2(0b001),
+	  trap_aa64dfr, reset_aa64dfr, ID_AA64DFR1_EL1 },
+
+	/* ID_AA64ISAR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0110), Op2(0b000),
+	  trap_aa64isar, reset_aa64isar, ID_AA64ISAR0_EL1 },
+	/* ID_AA64ISAR1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0110), Op2(0b001),
+	  trap_aa64isar, reset_aa64isar, ID_AA64ISAR1_EL1 },
+
+	/* ID_AA64MMFR0_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0111), Op2(0b000),
+	  trap_aa64mmfr, reset_aa64mmfr, ID_AA64MMFR0_EL1 },
+	/* ID_AA64MMFR1_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0111), Op2(0b001),
+	  trap_aa64mmfr, reset_aa64mmfr, ID_AA64MMFR1_EL1 },
+
 	/* SCTLR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b000),
 	  access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
@@ -1104,20 +1508,7 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 
 FUNCTION_INVARIANT(ctr_el0)
 FUNCTION_INVARIANT(revidr_el1)
-FUNCTION_INVARIANT(id_pfr0_el1)
-FUNCTION_INVARIANT(id_pfr1_el1)
-FUNCTION_INVARIANT(id_dfr0_el1)
 FUNCTION_INVARIANT(id_afr0_el1)
-FUNCTION_INVARIANT(id_mmfr0_el1)
-FUNCTION_INVARIANT(id_mmfr1_el1)
-FUNCTION_INVARIANT(id_mmfr2_el1)
-FUNCTION_INVARIANT(id_mmfr3_el1)
-FUNCTION_INVARIANT(id_isar0_el1)
-FUNCTION_INVARIANT(id_isar1_el1)
-FUNCTION_INVARIANT(id_isar2_el1)
-FUNCTION_INVARIANT(id_isar3_el1)
-FUNCTION_INVARIANT(id_isar4_el1)
-FUNCTION_INVARIANT(id_isar5_el1)
 FUNCTION_INVARIANT(clidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
@@ -1125,34 +1516,8 @@ FUNCTION_INVARIANT(aidr_el1)
 static struct sys_reg_desc invariant_sys_regs[] = {
 	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b110),
 	  NULL, get_revidr_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b000),
-	  NULL, get_id_pfr0_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b001),
-	  NULL, get_id_pfr1_el1 },
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b010),
-	  NULL, get_id_dfr0_el1 },
 	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b011),
 	  NULL, get_id_afr0_el1 },
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
 	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b001),
 	  NULL, get_clidr_el1 },
 	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b111),
-- 
1.7.9.5
