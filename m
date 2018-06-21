From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 14/16] KVM: arm64/sve: Add SVE support to register access
 ioctl interface
Date: Thu, 21 Jun 2018 15:57:38 +0100
Message-ID: <1529593060-542-15-git-send-email-Dave.Martin@arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A81334A0D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WPG0dDVwNfdk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jun 2018 10:47:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B37984A0D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:05 -0400 (EDT)
In-Reply-To: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds the following registers for access via the
KVM_{GET,SET}_ONE_REG interface:

 * KVM_REG_ARM64_SVE_ZREG(n, i) (n = 0..31) (in 2048-bit slices)
 * KVM_REG_ARM64_SVE_PREG(n, i) (n = 0..15) (in 256-bit slices)
 * KVM_REG_ARM64_SVE_FFR(i) (in 256-bit slices)

In order to adapt gracefully to future architectural extensions,
the registers are divided up into slices as noted above:  the i
parameter denotes the slice index.

For simplicity, bits or slices that exceed the maximum vector
length supported for the vcpu are ignored for KVM_SET_ONE_REG, and
read as zero for KVM_GET_ONE_REG.

For the current architecture, only slice i = 0 is significant.  The
interface design allows i to increase to up to 31 in the future if
required by future architectural amendments.

The registers are only visible for vcpus that have SVE enabled.
They are not enumerated by KVM_GET_REG_LIST on vcpus that do not
have SVE.  In all cases, surplus slices are not enumerated by
KVM_GET_REG_LIST.

Accesses to the FPSIMD registers via KVM_REG_ARM_CORE are
redirected to access the underlying vcpu SVE register storage as
appropriate.  In order to make this more straightforward, register
accesses that straddle register boundaries are no longer guaranteed
to succeed.  (Support for such use was never deliberate, and
userspace does not currently seem to be relying on it.)

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h |  10 ++
 arch/arm64/kvm/guest.c            | 219 +++++++++++++++++++++++++++++++++++---
 2 files changed, 216 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 4e76630..f54a9b0 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -213,6 +213,16 @@ struct kvm_arch_memory_slot {
 					 KVM_REG_ARM_FW | ((r) & 0xffff))
 #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
 
+/* SVE registers */
+#define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
+#define KVM_REG_ARM64_SVE_ZREG(n, i)	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
+					 KVM_REG_SIZE_U2048 |		\
+					 ((n) << 5) | (i))
+#define KVM_REG_ARM64_SVE_PREG(n, i)	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
+					 KVM_REG_SIZE_U256 |		\
+					 ((n) << 5) | (i) | 0x400)
+#define KVM_REG_ARM64_SVE_FFR(i)	KVM_REG_ARM64_SVE_PREG(16, i)
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 4a9d77c..005394b 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -23,14 +23,19 @@
 #include <linux/err.h>
 #include <linux/kvm_host.h>
 #include <linux/module.h>
+#include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
+#include <linux/stddef.h>
 #include <kvm/arm_psci.h>
 #include <asm/cputype.h>
 #include <linux/uaccess.h>
+#include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
+#include <asm/kvm_host.h>
+#include <asm/sigcontext.h>
 
 #include "trace.h"
 
@@ -57,6 +62,106 @@ static u64 core_reg_offset_from_id(u64 id)
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
 }
 
+static bool is_zreg(const struct kvm_one_reg *reg)
+{
+	return	reg->id >= KVM_REG_ARM64_SVE_ZREG(0, 0) &&
+		reg->id <= KVM_REG_ARM64_SVE_ZREG(SVE_NUM_ZREGS, 0x1f);
+}
+
+static bool is_preg(const struct kvm_one_reg *reg)
+{
+	return	reg->id >= KVM_REG_ARM64_SVE_PREG(0, 0) &&
+		reg->id <= KVM_REG_ARM64_SVE_FFR(0x1f);
+}
+
+static unsigned int sve_reg_num(const struct kvm_one_reg *reg)
+{
+	return (reg->id >> 5) & 0x1f;
+}
+
+static unsigned int sve_reg_index(const struct kvm_one_reg *reg)
+{
+	return reg->id & 0x1f;
+}
+
+struct reg_bounds_struct {
+	char *kptr;
+	size_t start_offset;
+	size_t copy_count;
+	size_t flush_count;
+};
+
+static int copy_bounded_reg_to_user(void __user *uptr,
+				    const struct reg_bounds_struct *b)
+{
+	if (copy_to_user(uptr, b->kptr, b->copy_count) ||
+	    clear_user((char __user *)uptr + b->copy_count, b->flush_count))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int copy_bounded_reg_from_user(const struct reg_bounds_struct *b,
+				      const void __user *uptr)
+{
+	if (copy_from_user(b->kptr, uptr, b->copy_count))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int fpsimd_vreg_bounds(struct reg_bounds_struct *b,
+			      struct kvm_vcpu *vcpu,
+			      const struct kvm_one_reg *reg)
+{
+	const size_t stride = KVM_REG_ARM_CORE_REG(fp_regs.vregs[1]) -
+				KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]);
+	const size_t start = KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]);
+	const size_t limit = KVM_REG_ARM_CORE_REG(fp_regs.vregs[32]);
+
+	const u64 uoffset = core_reg_offset_from_id(reg->id);
+	size_t usize = KVM_REG_SIZE(reg->id);
+	size_t start_vreg, end_vreg;
+
+	if (WARN_ON((reg->id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM_CORE))
+		return -ENOENT;
+
+	if (usize % sizeof(u32))
+		return -EINVAL;
+
+	usize /= sizeof(u32);
+
+	if ((uoffset <= start && usize <= start - uoffset) ||
+	    uoffset >= limit)
+		return -ENOENT;	/* not a vreg */
+
+	BUILD_BUG_ON(uoffset > limit);
+	if (uoffset < start || usize > limit - uoffset)
+		return -EINVAL;	/* overlaps vregs[] bounds */
+
+	start_vreg = (uoffset - start) / stride;
+	end_vreg = ((uoffset - start) + usize - 1) / stride;
+	if (start_vreg != end_vreg)
+		return -EINVAL;	/* spans multiple vregs */
+
+	b->start_offset = ((uoffset - start) % stride) * sizeof(u32);
+	b->copy_count = usize * sizeof(u32);
+	b->flush_count = 0;
+
+	if (vcpu_has_sve(&vcpu->arch)) {
+		const unsigned int vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
+
+		b->kptr = vcpu->arch.sve_state;
+		b->kptr += (SVE_SIG_ZREG_OFFSET(vq, start_vreg) -
+			    SVE_SIG_REGS_OFFSET);
+	} else {
+		b->kptr = (char *)&vcpu_gp_regs(vcpu)->fp_regs.vregs[
+				start_vreg];
+	}
+
+	return 0;
+}
+
 static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	/*
@@ -65,11 +170,20 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	 * array. Hence below, nr_regs is the number of entries, and
 	 * off the index in the "array".
 	 */
+	int err;
+	struct reg_bounds_struct b;
 	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
 	struct kvm_regs *regs = vcpu_gp_regs(vcpu);
 	int nr_regs = sizeof(*regs) / sizeof(__u32);
 	u32 off;
 
+	err = fpsimd_vreg_bounds(&b, vcpu, reg);
+	switch (err) {
+	case 0:		return copy_bounded_reg_to_user(uaddr, &b);
+	case -ENOENT:	break;	/* not and FPSIMD vreg */
+	default:	return err;
+	}
+
 	/* Our ID is an index into the kvm_regs struct. */
 	off = core_reg_offset_from_id(reg->id);
 	if (off >= nr_regs ||
@@ -84,14 +198,23 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	int err;
+	struct reg_bounds_struct b;
 	__u32 __user *uaddr = (__u32 __user *)(unsigned long)reg->addr;
 	struct kvm_regs *regs = vcpu_gp_regs(vcpu);
 	int nr_regs = sizeof(*regs) / sizeof(__u32);
 	__uint128_t tmp;
 	void *valp = &tmp;
 	u64 off;
-	int err = 0;
 
+	err = fpsimd_vreg_bounds(&b, vcpu, reg);
+	switch (err) {
+	case 0:		return copy_bounded_reg_from_user(&b, uaddr);
+	case -ENOENT:	break;	/* not and FPSIMD vreg */
+	default:	return err;
+	}
+
+	err = 0;
 	/* Our ID is an index into the kvm_regs struct. */
 	off = core_reg_offset_from_id(reg->id);
 	if (off >= nr_regs ||
@@ -130,6 +253,78 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return err;
 }
 
+static int sve_reg_bounds(struct reg_bounds_struct *b,
+			  const struct kvm_vcpu *vcpu,
+			  const struct kvm_one_reg *reg)
+{
+	unsigned int n = sve_reg_num(reg);
+	unsigned int i = sve_reg_index(reg);
+	unsigned int vl = vcpu->arch.sve_max_vl;
+	unsigned int vq = sve_vq_from_vl(vl);
+	unsigned int start, copy_limit, limit;
+
+	b->kptr = vcpu->arch.sve_state;
+	if (is_zreg(reg)) {
+		b->kptr += SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET;
+		start = i * 0x100;
+		limit = start + 0x100;
+		copy_limit = vl;
+	} else if (is_preg(reg)) {
+		b->kptr += SVE_SIG_PREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET;
+		start = i * 0x20;
+		limit = start + 0x20;
+		copy_limit = vl / 8;
+	} else {
+		WARN_ON(1);
+		start = 0;
+		copy_limit = limit = 0;
+	}
+
+	b->kptr += start;
+
+	if (copy_limit < start)
+		copy_limit = start;
+	else if (copy_limit > limit)
+		copy_limit = limit;
+
+	b->copy_count = copy_limit - start;
+	b->flush_count = limit - copy_limit;
+
+	return 0;
+}
+
+static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	int ret;
+	struct reg_bounds_struct b;
+	char __user *uptr = (char __user *)reg->addr;
+
+	if (!vcpu_has_sve(&vcpu->arch))
+		return -ENOENT;
+
+	ret = sve_reg_bounds(&b, vcpu, reg);
+	if (ret)
+		return ret;
+
+	return copy_bounded_reg_to_user(uptr, &b);
+}
+
+static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	int ret;
+	struct reg_bounds_struct b;
+	char __user *uptr = (char __user *)reg->addr;
+
+	if (!vcpu_has_sve(&vcpu->arch))
+		return -ENOENT;
+
+	ret = sve_reg_bounds(&b, vcpu, reg);
+	if (ret)
+		return ret;
+
+	return copy_bounded_reg_from_user(&b, uptr);
+}
+
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	return -EINVAL;
@@ -251,12 +446,11 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
 		return -EINVAL;
 
-	/* Register group 16 means we want a core register. */
-	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
-		return get_core_reg(vcpu, reg);
-
-	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
-		return kvm_arm_get_fw_reg(vcpu, reg);
+	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
+	case KVM_REG_ARM_CORE:	return get_core_reg(vcpu, reg);
+	case KVM_REG_ARM_FW:	return kvm_arm_get_fw_reg(vcpu, reg);
+	case KVM_REG_ARM64_SVE:	return get_sve_reg(vcpu, reg);
+	}
 
 	if (is_timer_reg(reg->id))
 		return get_timer_reg(vcpu, reg);
@@ -270,12 +464,11 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
 		return -EINVAL;
 
-	/* Register group 16 means we set a core register. */
-	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
-		return set_core_reg(vcpu, reg);
-
-	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
-		return kvm_arm_set_fw_reg(vcpu, reg);
+	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
+	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
+	case KVM_REG_ARM_FW:	return kvm_arm_set_fw_reg(vcpu, reg);
+	case KVM_REG_ARM64_SVE:	return set_sve_reg(vcpu, reg);
+	}
 
 	if (is_timer_reg(reg->id))
 		return set_timer_reg(vcpu, reg);
-- 
2.1.4
