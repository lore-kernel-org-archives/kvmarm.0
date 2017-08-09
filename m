From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 02/27] arm64: KVM: Hide unsupported AArch64 CPU features from
 guests
Date: Wed,  9 Aug 2017 13:05:08 +0100
Message-ID: <1502280338-23002-3-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75DA640D14
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:04:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wuf3-LIHA3w6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Aug 2017 08:04:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE90349C30
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:04:30 -0400 (EDT)
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

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
---
 arch/arm64/kvm/hyp/switch.c |   6 ++
 arch/arm64/kvm/sys_regs.c   | 224 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 185 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 945e79c..35a90b8 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -81,11 +81,17 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	 * it will cause an exception.
 	 */
 	val = vcpu->arch.hcr_el2;
+
 	if (!(val & HCR_RW) && system_supports_fpsimd()) {
 		write_sysreg(1 << 30, fpexc32_el2);
 		isb();
 	}
+
+	if (val & HCR_RW) /* for AArch64 only: */
+		val |= HCR_TID3; /* TID3: trap feature register accesses */
+
 	write_sysreg(val, hcr_el2);
+
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 	/*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2e070d3..6583dd7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -892,6 +892,135 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
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
+			    const struct sys_reg_desc const *r,
+			    bool raz)
+{
+	if (p->is_write) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
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
+	BUG_ON(KVM_REG_SIZE(id) != sizeof(val));
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
+	BUG_ON(KVM_REG_SIZE(id) != sizeof(val));
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
+/* sys_reg_desc initialiser for cpufeature ID register name_EL1 */
+#define _ID(name) {			\
+	SYS_DESC(SYS_##name##_EL1),	\
+	.access	= access_id_reg,	\
+	.get_user = get_id_reg,		\
+	.set_user = set_id_reg,		\
+}
+
+/*
+ * sys_reg_desc initialiser for cpufeature ID register ID_name_EL1
+ * (So we can get 4 regs to 1 line.)
+ */
+#define ID(name) _ID(ID_##name)
+
+/*
+ * sys_reg_desc initialiser for unknown (RAZ) cpufeature ID register
+ * Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
+ * (1 <= crm < 8, 0 <= Op2 < 8).
+ */
+#define _ID_RAZ(crm, op2) {				\
+	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
+	.access = access_raz_id_reg,			\
+	.get_user = get_raz_id_reg,			\
+	.set_user = set_raz_id_reg,			\
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -944,6 +1073,32 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
 
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
+
+	/*
+	 * All non-RAZ feature registers listed here must also be
+	 * present in arm64_ftr_regs[].
+	 */
+
+	/* AArch64 mappings of the AArch32 ID registers */
+	/* ID_AFR0_EL1 not exposed to guests for now */
+	ID(PFR0),	ID(PFR1),	ID(DFR0),	_ID_RAZ(1,3),
+	ID(MMFR0),	ID(MMFR1),	ID(MMFR2),	ID(MMFR3),
+	ID(ISAR0),	ID(ISAR1),	ID(ISAR2),	ID(ISAR3),
+	ID(ISAR4),	ID(ISAR5),	ID(MMFR4),	_ID_RAZ(2,7),
+	_ID(MVFR0),	_ID(MVFR1),	_ID(MVFR2),	_ID_RAZ(3,3),
+	_ID_RAZ(3,4),	_ID_RAZ(3,5),	_ID_RAZ(3,6),	_ID_RAZ(3,7),
+
+	/* AArch64 ID registers */
+	ID(AA64PFR0),	ID(AA64PFR1),	_ID_RAZ(4,2),	_ID_RAZ(4,3),
+	_ID_RAZ(4,4),	_ID_RAZ(4,5),	_ID_RAZ(4,6),	_ID_RAZ(4,7),
+	ID(AA64DFR0),	ID(AA64DFR1),	_ID_RAZ(5,2),	_ID_RAZ(5,3),
+	/* ID_AA64AFR0_EL1 and ID_AA64AFR0_EL1 not exposed to guests for now */
+	_ID_RAZ(5,4),	_ID_RAZ(5,5),	_ID_RAZ(5,6),	_ID_RAZ(5,7),
+	ID(AA64ISAR0),	ID(AA64ISAR1),	_ID_RAZ(6,2),	_ID_RAZ(6,3),
+	_ID_RAZ(6,4),	_ID_RAZ(6,5),	_ID_RAZ(6,6),	_ID_RAZ(6,7),
+	ID(AA64MMFR0),	ID(AA64MMFR1),	ID(AA64MMFR2),	_ID_RAZ(7,3),
+	_ID_RAZ(7,4),	_ID_RAZ(7,5),	_ID_RAZ(7,6),	_ID_RAZ(7,7),
+
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
@@ -1790,8 +1945,8 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	if (!r)
 		r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
-	/* Not saved in the sys_reg array? */
-	if (r && !r->reg)
+	/* Not saved in the sys_reg array and not otherwise accessible? */
+	if (r && !(r->reg || r->get_user))
 		r = NULL;
 
 	return r;
@@ -1815,20 +1970,6 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
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
 
@@ -1836,20 +1977,6 @@ FUNCTION_INVARIANT(aidr_el1)
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
@@ -2079,12 +2206,31 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
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
@@ -2098,21 +2244,9 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
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
+		err = walk_one_sys_reg(cmp <= 0 ? i1 : i2, &uind, &total);
+		if (err)
+			return err;
 
 		if (cmp <= 0 && ++i1 == end1)
 			i1 = NULL;
-- 
2.1.4
