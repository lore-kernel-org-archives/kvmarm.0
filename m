From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2] arm64/kvm: Prohibit guest LOR accesses
Date: Tue, 13 Feb 2018 13:39:23 +0000
Message-ID: <20180213133923.40002-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We don't currently limit guest accesses to the LOR registers, which we
neither virtualize nor context-switch. As such, guests are provided with
unusable information/controls, and are not isolated from each other (or
the host).

To prevent these issues, we can trap register accesses and present the
illusion LORegions are unssupported by the CPU. To do this, we mask
ID_AA64MMFR1.LO, and set HCR_EL2.TLOR to trap accesses to the following
registers:

* LORC_EL1
* LOREA_EL1
* LORID_EL1
* LORN_EL1
* LORSA_EL1

... when trapped, we inject an UNDEFINED exception to EL1, simulating
their non-existence.

As noted in D7.2.67, when no LORegions are implemented, LoadLOAcquire
and StoreLORelease must behave as LoadAcquire and StoreRelease
respectively. We can ensure this by clearing LORC_EL1.EN when a CPU's
EL2 is first initialized, as the host kernel will not modify this.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_arm.h |  4 +++-
 arch/arm64/include/asm/sysreg.h  |  6 ++++++
 arch/arm64/kernel/head.S         |  7 +++++++
 arch/arm64/kvm/sys_regs.c        | 20 ++++++++++++++++++++
 4 files changed, 36 insertions(+), 1 deletion(-)

Since v1 [1]:
* Mask ID_AA64MMFR1.LO
* Always inject an UNDEF for SYS_LOR* accesses

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-February/558987.html

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b0c84171e6a3..1b438c334463 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -25,6 +25,7 @@
 /* Hyp Configuration Register (HCR) bits */
 #define HCR_TEA		(UL(1) << 37)
 #define HCR_TERR	(UL(1) << 36)
+#define HCR_TLOR	(UL(1) << 35)
 #define HCR_E2H		(UL(1) << 34)
 #define HCR_ID		(UL(1) << 33)
 #define HCR_CD		(UL(1) << 32)
@@ -64,6 +65,7 @@
 
 /*
  * The bits we set in HCR:
+ * TLOR:	Trap LORegion register accesses
  * RW:		64bit by default, can be overridden for 32bit VMs
  * TAC:		Trap ACTLR
  * TSC:		Trap SMC
@@ -81,7 +83,7 @@
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
-			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
+			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR)
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 0e1960c59197..69a99856461c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -288,6 +288,12 @@
 #define SYS_MAIR_EL1			sys_reg(3, 0, 10, 2, 0)
 #define SYS_AMAIR_EL1			sys_reg(3, 0, 10, 3, 0)
 
+#define SYS_LORSA_EL1			sys_reg(3, 0, 10, 4, 0)
+#define SYS_LOREA_EL1			sys_reg(3, 0, 10, 4, 1)
+#define SYS_LORN_EL1			sys_reg(3, 0, 10, 4, 2)
+#define SYS_LORC_EL1			sys_reg(3, 0, 10, 4, 3)
+#define SYS_LORID_EL1			sys_reg(3, 0, 10, 4, 7)
+
 #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
 #define SYS_DISR_EL1			sys_reg(3, 0, 12, 1, 1)
 
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 2b6b8b24e5ab..b0853069702f 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -577,6 +577,13 @@ set_hcr:
 7:
 	msr	mdcr_el2, x3			// Configure debug traps
 
+	/* LORegions */
+	mrs	x1, id_aa64mmfr1_el1
+	ubfx	x0, x1, #ID_AA64MMFR1_LOR_SHIFT, 4
+	cbz	x0, 1f
+	msr_s	SYS_LORC_EL1, xzr
+1:
+
 	/* Stage-2 translation */
 	msr	vttbr_el2, xzr
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 50a43c7b97ca..55982b565eb2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -175,6 +175,14 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+static bool trap_undef(struct kvm_vcpu *vcpu,
+		       struct sys_reg_params *p,
+		       const struct sys_reg_desc *r)
+{
+	kvm_inject_undefined(vcpu);
+	return false;
+}
+
 static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
@@ -893,6 +901,12 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 				    task_pid_nr(current));
 
 		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
+	} else if (id == SYS_ID_AA64MMFR1_EL1) {
+		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
+			pr_err_once("kvm [%i]: LORegions unsupported for guests, suppressing\n",
+				    task_pid_nr(current));
+
+		val &= ~(0xfUL << ID_AA64MMFR1_LOR_SHIFT);
 	}
 
 	return val;
@@ -1178,6 +1192,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
 
+	{ SYS_DESC(SYS_LORSA_EL1), trap_undef },
+	{ SYS_DESC(SYS_LOREA_EL1), trap_undef },
+	{ SYS_DESC(SYS_LORN_EL1), trap_undef },
+	{ SYS_DESC(SYS_LORC_EL1), trap_undef },
+	{ SYS_DESC(SYS_LORID_EL1), trap_undef },
+
 	{ SYS_DESC(SYS_VBAR_EL1), NULL, reset_val, VBAR_EL1, 0 },
 	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
 
-- 
2.11.0
