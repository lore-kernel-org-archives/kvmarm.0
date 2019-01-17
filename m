From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 21/25] KVM: arm64/sve: Add pseudo-register for the guest's
 vector lengths
Date: Thu, 17 Jan 2019 20:33:35 +0000
Message-ID: <1547757219-19439-22-git-send-email-Dave.Martin@arm.com>
References: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF2D64A3AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jan 2019 15:35:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xLj1rwnVTQ0u for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jan 2019 15:35:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA494A375
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jan 2019 15:35:13 -0500 (EST)
In-Reply-To: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
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

This patch adds a new pseudo-register KVM_REG_ARM64_SVE_VLS to
allow userspace to set and query the set of vector lengths visible
to the guest, along with corresponding storage in struct
kvm_vcpu_arch.

Once the number of SVE register slices visible through the ioctl
interface has been determined, we cannot allow the vector length
set to be changed any more.  For this reason, this patch adds
support to track vcpu finalization explicitly.

The new pseudo-register is not exposed yet.  Subsequent patches
will allow SVE to be turned on for guest vcpus, making it visible.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |   8 ++-
 arch/arm64/include/uapi/asm/kvm.h |   2 +
 arch/arm64/kvm/guest.c            | 108 +++++++++++++++++++++++++++++++++++---
 arch/arm64/kvm/reset.c            |   9 ++++
 4 files changed, 119 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 55bf9d0..82a99f6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -24,6 +24,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/kvm_types.h>
 #include <asm/cpufeature.h>
 #include <asm/daifflags.h>
@@ -214,6 +215,7 @@ struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
 	unsigned int sve_max_vl;
+	u64 sve_vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
 
 	/* HYP configuration */
 	u64 hcr_el2;
@@ -317,6 +319,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
 #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
 #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
+#define KVM_ARM64_VCPU_FINALIZED	(1 << 6) /* vcpu config completed */
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() && \
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
@@ -540,7 +543,8 @@ void kvm_arch_free_vm(struct kvm *kvm);
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
 /* Commit to the set of vcpu registers currently configured: */
-static inline int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu) { return 0; }
-#define kvm_arm_vcpu_finalized(vcpu) true
+int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu);
+#define kvm_arm_vcpu_finalized(vcpu) \
+	((vcpu)->arch.flags & KVM_ARM64_VCPU_FINALIZED)
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1ff68fa..6dfbfa3 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -235,6 +235,8 @@ struct kvm_vcpu_events {
 					 KVM_REG_SIZE_U256 |		\
 					 ((n) << 5) | (i) | 0x400)
 #define KVM_REG_ARM64_SVE_FFR(i)	KVM_REG_ARM64_SVE_PREG(16, i)
+#define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
+					 KVM_REG_SIZE_U512 | 0xffff)
 
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2d248e7..a636330 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -215,6 +215,65 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return err;
 }
 
+static bool vq_present(
+	const u64 (*vqs)[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)],
+	unsigned int vq)
+{
+	unsigned int i = vq - SVE_VQ_MIN;
+
+	return (*vqs)[i / 64] & ((u64)1 << (i % 64));
+}
+
+static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	if (WARN_ON(sizeof(vcpu->arch.sve_vqs) != KVM_REG_SIZE(reg->id) ||
+		    !sve_vl_valid(vcpu->arch.sve_max_vl)))
+		return -EINVAL;
+
+	if (copy_to_user((void __user *)reg->addr, vcpu->arch.sve_vqs,
+			 sizeof(vcpu->arch.sve_vqs)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	unsigned int vq, max_vq;
+
+	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
+
+	if (kvm_arm_vcpu_finalized(vcpu))
+		return -EPERM; /* too late! */
+
+	if (WARN_ON(sizeof(vcpu->arch.sve_vqs) != KVM_REG_SIZE(reg->id) ||
+		    sizeof(vcpu->arch.sve_vqs) != sizeof(vqs) ||
+		    !sve_vl_valid(vcpu->arch.sve_max_vl) ||
+		    vcpu->arch.sve_state))
+		return -EINVAL;
+
+	if (copy_from_user(vqs, (const void __user *)reg->addr, sizeof(vqs)))
+		return -EFAULT;
+
+	max_vq = 0;
+	for (vq = SVE_VQ_MIN; vq <= SVE_VQ_MAX; ++vq)
+		if (vq_present(&vqs, vq))
+			max_vq = vq;
+
+	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
+		if (vq_present(&vqs, vq) != sve_vq_available(vq))
+			return -EINVAL;
+
+	/* Can't run with no vector lengths at all: */
+	if (max_vq < SVE_VQ_MIN)
+		return -EINVAL;
+
+	vcpu->arch.sve_max_vl = sve_vl_from_vq(max_vq);
+	memcpy(vcpu->arch.sve_vqs, vqs, sizeof(vcpu->arch.sve_vqs));
+
+	return 0;
+}
+
 struct kreg_region {
 	char *kptr;
 	size_t size;
@@ -296,9 +355,21 @@ static int sve_reg_region(struct kreg_region *b,
 static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	struct kreg_region kreg;
+	int ret;
 	char __user *uptr = (char __user *)reg->addr;
 
-	if (!vcpu_has_sve(vcpu) || sve_reg_region(&kreg, vcpu, reg))
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
+	if (reg->id == KVM_REG_ARM64_SVE_VLS)
+		return get_sve_vls(vcpu, reg);
+
+	/* Finalize the number of slices per SVE register: */
+	ret = kvm_arm_vcpu_finalize(vcpu);
+	if (ret)
+		return ret;
+
+	if (sve_reg_region(&kreg, vcpu, reg))
 		return -ENOENT;
 
 	if (copy_to_user(uptr, kreg.kptr, kreg.size) ||
@@ -311,9 +382,21 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	struct kreg_region kreg;
+	int ret;
 	char __user *uptr = (char __user *)reg->addr;
 
-	if (!vcpu_has_sve(vcpu) || sve_reg_region(&kreg, vcpu, reg))
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
+	if (reg->id == KVM_REG_ARM64_SVE_VLS)
+		return set_sve_vls(vcpu, reg);
+
+	/* Finalize the number of slices per SVE register: */
+	ret = kvm_arm_vcpu_finalize(vcpu);
+	if (ret)
+		return ret;
+
+	if (sve_reg_region(&kreg, vcpu, reg))
 		return -ENOENT;
 
 	if (copy_from_user(kreg.kptr, uptr, kreg.size))
@@ -449,30 +532,43 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 		return 0;
 
 	slices = KVM_SVE_SLICES(vcpu);
-	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */);
+	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
+		+ 1; /* KVM_REG_ARM64_SVE_VLS */
 }
 
 static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu, u64 __user **uind)
 {
+	u64 reg;
 	unsigned int slices, i, n;
 
 	if (!vcpu_has_sve(vcpu))
 		return 0;
 
+	/*
+	 * Enumerate this first, so that userspace can save/restore in
+	 * the order reported by KVM_GET_REG_LIST:
+	 */
+	reg = KVM_REG_ARM64_SVE_VLS;
+	if (put_user(reg, (*uind)++))
+		return -EFAULT;
+
 	slices = KVM_SVE_SLICES(vcpu);
 
 	for (i = 0; i < slices; i++) {
 		for (n = 0; n < SVE_NUM_ZREGS; n++) {
-			if (put_user(KVM_REG_ARM64_SVE_ZREG(n, i), (*uind)++))
+			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
+			if (put_user(reg, (*uind)++))
 				return -EFAULT;
 		}
 
 		for (n = 0; n < SVE_NUM_PREGS; n++) {
-			if (put_user(KVM_REG_ARM64_SVE_PREG(n, i), (*uind)++))
+			reg = KVM_REG_ARM64_SVE_PREG(n, i);
+			if (put_user(reg, (*uind)++))
 				return -EFAULT;
 		}
 
-		if (put_user(KVM_REG_ARM64_SVE_FFR(i), (*uind)++))
+		reg = KVM_REG_ARM64_SVE_FFR(i);
+		if (put_user(reg, (*uind)++))
 			return -EFAULT;
 	}
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b72a3dd..1379fb2 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -98,6 +98,15 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu)
+{
+	if (likely(kvm_arm_vcpu_finalized(vcpu)))
+		return 0;
+
+	vcpu->arch.flags |= KVM_ARM64_VCPU_FINALIZED;
+	return 0;
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
-- 
2.1.4
