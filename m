From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 01/31] arm64: KVM: Hide unsupported AArch64 CPU features from guests
Date: Mon,  2 Oct 2017 22:09:29 -0500
Message-ID: <1507000169-3586-1-git-send-email-jintack.lim@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: Dave.Martin@arm.com, jintack@cs.columbia.edu, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Dave Martin <Dave.Martin@arm.com>

Currently, a guest kernel sees the true CPU feature registers
(ID_*_EL1) when it reads them using MRS instructions.  This means
that the guest will observe features that are present in the
hardware but the host doesn't understand or doesn't provide support
for.  A guest may legimitately try to use such a feature as per the
architecture, but use of the feature may trap instead of working
normally, triggering undef injection into the guest.

This is not a problem for the host, but the guest may go wrong when
running on newer hardware than the host knows about.

This patch hides from guest VMs any AArch64-specific CPU features
that the host doesn't support, by exposing to the guest the
sanitised versions of the registers computed by the cpufeatures
framework, instead of the true hardware registers.  To achieve
this, HCR_EL2.TID3 is now set for AArch64 guests, and emulation
code is added to KVM to report the sanitised versions of the
affected registers in response to MRS and register reads from
userspace.

The affected registers are removed from invariant_sys_regs[] (since
the invariant_sys_regs handling is no longer quite correct for
them) and added to sys_reg_desgs[], with appropriate access(),
get_user() and set_user() methods.  No runtime vcpu storage is
allocated for the registers: instead, they are read on demand from
the cpufeatures framework.  This may need modification in the
future if there is a need for userspace to customise the features
visible to the guest.

Attempts by userspace to write the registers are handled similarly
to the current invariant_sys_regs handling: writes are permitted,
but only if they don't attempt to change the value.  This is
sufficient to support VM snapshot/restore from userspace.

Because of the additional registers, restoring a VM on an older
kernel may not work unless userspace knows how to handle the extra
VM registers exposed to the KVM user ABI by this patch.

Under the principle of least damage, this patch makes no attempt to
handle any of the other registers currently in
invariant_sys_regs[], or to emulate registers for AArch32: however,
these could be handled in a similar way in future, as necessary.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>

---

Changes since v1
----------------

Requested by Marc Zyngier:

* Get rid of ternary operator use in walk_sys_regs().

* Call write_to_read_only() if an attempt to write an ID reg is
trapped, rather than reinventing.
Probably we won't get there anyway: the architecture says that this
should undef at EL1 instead.

* Make ID register sysreg table less cryptic and spread the entries one
per line.
Also, make the architecturally unallocated and allocated but hidden
cases more clearly distinct.  These require the same behaviour but for
different reasons, so it's better to identify them as separate.

Other:

* Delete BUG_ON()s that are skipped by construction:
These check that the result of sys_reg_to_index() is a 64-bit
register, which is always true because sys_reg_to_index()
explicitly sets this.

* Remove duplicate const in __access_id_reg args [sparse]
---
 arch/arm64/include/asm/sysreg.h |   3 +
 arch/arm64/kvm/hyp/switch.c     |   5 +
 arch/arm64/kvm/sys_regs.c       | 282 +++++++++++++++++++++++++++++++++-------
 3 files changed, 245 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b8d4d0c..a051d42 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -149,6 +149,9 @@
 #define SYS_ID_AA64DFR0_EL1		sys_reg(3, 0, 0, 5, 0)
 #define SYS_ID_AA64DFR1_EL1		sys_reg(3, 0, 0, 5, 1)
 
+#define SYS_ID_AA64AFR0_EL1		sys_reg(3, 0, 0, 5, 4)
+#define SYS_ID_AA64AFR1_EL1		sys_reg(3, 0, 0, 5, 5)
+
 #define SYS_ID_AA64ISAR0_EL1		sys_reg(3, 0, 0, 6, 0)
 #define SYS_ID_AA64ISAR1_EL1		sys_reg(3, 0, 0, 6, 1)
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 50c90f2..2a64a5c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -88,11 +88,15 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	 * it will cause an exception.
 	 */
 	val = vcpu->arch.hcr_el2;
+
 	if (!(val & HCR_RW) && system_supports_fpsimd()) {
 		write_sysreg(1 << 30, fpexc32_el2);
 		isb();
 	}
 
+	if (val & HCR_RW) /* for AArch64 only: */
+		val |= HCR_TID3; /* TID3: trap feature register accesses */
+
 	if (is_hyp_ctxt(vcpu)) {
 		/*
 		 * For a guest hypervisor on v8.0, trap and emulate the EL1
@@ -113,6 +117,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	}
 
 	write_sysreg(val, hcr_el2);
+
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 	/*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ba2966d..65f4c20 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1114,6 +1114,137 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/* Read a sanitised cpufeature ID register by sys_reg_desc */
+static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
+{
+	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
+			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
+
+	return raz ? 0 : read_sanitised_ftr_reg(id);
+}
+
+/* cpufeature ID register access trap handlers */
+
+static bool __access_id_reg(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r,
+			    bool raz)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = read_id_reg(r, raz);
+	return true;
+}
+
+static bool access_id_reg(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	return __access_id_reg(vcpu, p, r, false);
+}
+
+static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
+			      struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	return __access_id_reg(vcpu, p, r, true);
+}
+
+static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
+static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
+static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
+
+/*
+ * cpufeature ID register user accessors
+ *
+ * For now, these registers are immutable for userspace, so no values
+ * are stored, and for set_id_reg() we don't allow the effective value
+ * to be changed.
+ */
+static int __get_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
+			bool raz)
+{
+	const u64 id = sys_reg_to_index(rd);
+	const u64 val = read_id_reg(rd, raz);
+
+	return reg_to_user(uaddr, &val, id);
+}
+
+static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
+			bool raz)
+{
+	const u64 id = sys_reg_to_index(rd);
+	int err;
+	u64 val;
+
+	err = reg_from_user(&val, uaddr, id);
+	if (err)
+		return err;
+
+	/* This is what we mean by invariant: you can't change it. */
+	if (val != read_id_reg(rd, raz))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		      const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	return __get_id_reg(rd, uaddr, false);
+}
+
+static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		      const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	return __set_id_reg(rd, uaddr, false);
+}
+
+static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			  const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	return __get_id_reg(rd, uaddr, true);
+}
+
+static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			  const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	return __set_id_reg(rd, uaddr, true);
+}
+
+/* sys_reg_desc initialiser for known cpufeature ID registers */
+#define ID_SANITISED(name) {			\
+	SYS_DESC(SYS_##name),			\
+	.access	= access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+}
+
+/*
+ * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
+ * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
+ * (1 <= crm < 8, 0 <= Op2 < 8).
+ */
+#define ID_UNALLOCATED(crm, op2) {			\
+	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
+	.access = access_raz_id_reg,			\
+	.get_user = get_raz_id_reg,			\
+	.set_user = set_raz_id_reg,			\
+}
+
+/*
+ * sys_reg_desc initialiser for known ID registers that we hide from guests.
+ * For now, these are exposed just like unallocated ID regs: they appear
+ * RAZ for the guest.
+ */
+#define ID_HIDDEN(name) {			\
+	SYS_DESC(SYS_##name),			\
+	.access = access_raz_id_reg,		\
+	.get_user = get_raz_id_reg,		\
+	.set_user = set_raz_id_reg,		\
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -1166,6 +1297,84 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
 	{ SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
 
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
+
+	/*
+	 * ID regs: all ID_SANITISED() entries here must have corresponding
+	 * entries in arm64_ftr_regs[].
+	 */
+
+	/* AArch64 mappings of the AArch32 ID registers */
+	/* CRm=1 */
+	ID_SANITISED(ID_PFR0_EL1),
+	ID_SANITISED(ID_PFR1_EL1),
+	ID_SANITISED(ID_DFR0_EL1),
+	ID_HIDDEN(ID_AFR0_EL1),
+	ID_SANITISED(ID_MMFR0_EL1),
+	ID_SANITISED(ID_MMFR1_EL1),
+	ID_SANITISED(ID_MMFR2_EL1),
+	ID_SANITISED(ID_MMFR3_EL1),
+
+	/* CRm=2 */
+	ID_SANITISED(ID_ISAR0_EL1),
+	ID_SANITISED(ID_ISAR1_EL1),
+	ID_SANITISED(ID_ISAR2_EL1),
+	ID_SANITISED(ID_ISAR3_EL1),
+	ID_SANITISED(ID_ISAR4_EL1),
+	ID_SANITISED(ID_ISAR5_EL1),
+	ID_SANITISED(ID_MMFR4_EL1),
+	ID_UNALLOCATED(2,7),
+
+	/* CRm=3 */
+	ID_SANITISED(MVFR0_EL1),
+	ID_SANITISED(MVFR1_EL1),
+	ID_SANITISED(MVFR2_EL1),
+	ID_UNALLOCATED(3,3),
+	ID_UNALLOCATED(3,4),
+	ID_UNALLOCATED(3,5),
+	ID_UNALLOCATED(3,6),
+	ID_UNALLOCATED(3,7),
+
+	/* AArch64 ID registers */
+	/* CRm=4 */
+	ID_SANITISED(ID_AA64PFR0_EL1),
+	ID_SANITISED(ID_AA64PFR1_EL1),
+	ID_UNALLOCATED(4,2),
+	ID_UNALLOCATED(4,3),
+	ID_UNALLOCATED(4,4),
+	ID_UNALLOCATED(4,5),
+	ID_UNALLOCATED(4,6),
+	ID_UNALLOCATED(4,7),
+
+	/* CRm=5 */
+	ID_SANITISED(ID_AA64DFR0_EL1),
+	ID_SANITISED(ID_AA64DFR1_EL1),
+	ID_UNALLOCATED(5,2),
+	ID_UNALLOCATED(5,3),
+	ID_HIDDEN(ID_AA64AFR0_EL1),
+	ID_HIDDEN(ID_AA64AFR1_EL1),
+	ID_UNALLOCATED(5,6),
+	ID_UNALLOCATED(5,7),
+
+	/* CRm=6 */
+	ID_SANITISED(ID_AA64ISAR0_EL1),
+	ID_SANITISED(ID_AA64ISAR1_EL1),
+	ID_UNALLOCATED(6,2),
+	ID_UNALLOCATED(6,3),
+	ID_UNALLOCATED(6,4),
+	ID_UNALLOCATED(6,5),
+	ID_UNALLOCATED(6,6),
+	ID_UNALLOCATED(6,7),
+
+	/* CRm=7 */
+	ID_SANITISED(ID_AA64MMFR0_EL1),
+	ID_SANITISED(ID_AA64MMFR1_EL1),
+	ID_SANITISED(ID_AA64MMFR2_EL1),
+	ID_UNALLOCATED(7,3),
+	ID_UNALLOCATED(7,4),
+	ID_UNALLOCATED(7,5),
+	ID_UNALLOCATED(7,6),
+	ID_UNALLOCATED(7,7),
+
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	{ SYS_DESC(SYS_CPACR_EL1), access_cpacr, reset_val, CPACR_EL1, 0 },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
@@ -2123,8 +2332,8 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	if (!r)
 		r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
-	/* Not saved in the sys_reg array? */
-	if (r && !r->reg)
+	/* Not saved in the sys_reg array and not otherwise accessible? */
+	if (r && !(r->reg || r->get_user))
 		r = NULL;
 
 	return r;
@@ -2148,20 +2357,6 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 FUNCTION_INVARIANT(midr_el1)
 FUNCTION_INVARIANT(ctr_el0)
 FUNCTION_INVARIANT(revidr_el1)
-FUNCTION_INVARIANT(id_pfr0_el1)
-FUNCTION_INVARIANT(id_pfr1_el1)
-FUNCTION_INVARIANT(id_dfr0_el1)
-FUNCTION_INVARIANT(id_afr0_el1)
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
 
@@ -2169,20 +2364,6 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 static struct sys_reg_desc invariant_sys_regs[] = {
 	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
 	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
-	{ SYS_DESC(SYS_ID_PFR0_EL1), NULL, get_id_pfr0_el1 },
-	{ SYS_DESC(SYS_ID_PFR1_EL1), NULL, get_id_pfr1_el1 },
-	{ SYS_DESC(SYS_ID_DFR0_EL1), NULL, get_id_dfr0_el1 },
-	{ SYS_DESC(SYS_ID_AFR0_EL1), NULL, get_id_afr0_el1 },
-	{ SYS_DESC(SYS_ID_MMFR0_EL1), NULL, get_id_mmfr0_el1 },
-	{ SYS_DESC(SYS_ID_MMFR1_EL1), NULL, get_id_mmfr1_el1 },
-	{ SYS_DESC(SYS_ID_MMFR2_EL1), NULL, get_id_mmfr2_el1 },
-	{ SYS_DESC(SYS_ID_MMFR3_EL1), NULL, get_id_mmfr3_el1 },
-	{ SYS_DESC(SYS_ID_ISAR0_EL1), NULL, get_id_isar0_el1 },
-	{ SYS_DESC(SYS_ID_ISAR1_EL1), NULL, get_id_isar1_el1 },
-	{ SYS_DESC(SYS_ID_ISAR2_EL1), NULL, get_id_isar2_el1 },
-	{ SYS_DESC(SYS_ID_ISAR3_EL1), NULL, get_id_isar3_el1 },
-	{ SYS_DESC(SYS_ID_ISAR4_EL1), NULL, get_id_isar4_el1 },
-	{ SYS_DESC(SYS_ID_ISAR5_EL1), NULL, get_id_isar5_el1 },
 	{ SYS_DESC(SYS_CLIDR_EL1), NULL, get_clidr_el1 },
 	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
 	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
@@ -2412,12 +2593,31 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
 	return true;
 }
 
+static int walk_one_sys_reg(const struct sys_reg_desc *rd,
+			    u64 __user **uind,
+			    unsigned int *total)
+{
+	/*
+	 * Ignore registers we trap but don't save,
+	 * and for which no custom user accessor is provided.
+	 */
+	if (!(rd->reg || rd->get_user))
+		return 0;
+
+	if (!copy_reg_to_user(rd, uind))
+		return -EFAULT;
+
+	(*total)++;
+	return 0;
+}
+
 /* Assumed ordered tables, see kvm_sys_reg_table_init. */
 static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 {
 	const struct sys_reg_desc *i1, *i2, *end1, *end2;
 	unsigned int total = 0;
 	size_t num;
+	int err;
 
 	/* We check for duplicates here, to allow arch-specific overrides. */
 	i1 = get_target_table(vcpu->arch.target, true, &num);
@@ -2431,21 +2631,13 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 	while (i1 || i2) {
 		int cmp = cmp_sys_reg(i1, i2);
 		/* target-specific overrides generic entry. */
-		if (cmp <= 0) {
-			/* Ignore registers we trap but don't save. */
-			if (i1->reg) {
-				if (!copy_reg_to_user(i1, &uind))
-					return -EFAULT;
-				total++;
-			}
-		} else {
-			/* Ignore registers we trap but don't save. */
-			if (i2->reg) {
-				if (!copy_reg_to_user(i2, &uind))
-					return -EFAULT;
-				total++;
-			}
-		}
+		if (cmp <= 0)
+			err = walk_one_sys_reg(i1, &uind, &total);
+		else
+			err = walk_one_sys_reg(i2, &uind, &total);
+
+		if (err)
+			return err;
 
 		if (cmp <= 0 && ++i1 == end1)
 			i1 = NULL;
-- 
1.9.1
