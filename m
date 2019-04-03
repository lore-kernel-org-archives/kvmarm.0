From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH] KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST
Date: Wed,  3 Apr 2019 17:20:18 +0100
Message-ID: <1554308418-26138-1-git-send-email-Dave.Martin@arm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Since commit d26c25a9d19b ("arm64: KVM: Tighten guest core register
access from userspace"), KVM_{GET,SET}_ONE_REG rejects register IDs
that do not correspond to a single underlying architectural register.

KVM_GET_REG_LIST was not changed to match however: instead, it
simply yields a list of 32-bit register IDs that together cover the
whole kvm_regs struct.  This means that if userspace tries to use
the resulting list of IDs directly to drive calls to KVM_*_ONE_REG,
some of those calls will now fail.

This was not the intention.  Instead, iterating KVM_*_ONE_REG over
the list of IDs returned by KVM_GET_REG_LIST should be guaranteed
to work.

This patch fixes the problem by splitting validate_core_offset()
into a backend core_reg_size_from_offset() which does all of the
work except for checking that the size field in the register ID
matches, and kvm_arm_copy_reg_indices() and num_core_regs() are
converted to use this to enumerate the valid offsets.

kvm_arm_copy_reg_indices() now also sets the register ID size field
appropriately based on the value returned, so the register ID
supplied to userspace is fully qualified for use with the register
access ioctls.

Cc: stable@vger.kernel.org
Fixes: d26c25a9d19b ("arm64: KVM: Tighten guest core register access from userspace")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Tested by hacking kvmtool to dump the register list and eyballing the
results, both with and without this patch, and with and without SVE.

Qemu testing to follow.

Note that upstream kvmtool doesn't currently use KVM_GET_REG_LIST at
all.  Qemu uses this ioctl, but doesn't appear to use the core reg IDs
in the list, using hard-coded IDs instead.


Changes since v2:

 * Rebased onto the kvmarm next branch [1].

   This required some refactoring, but the fundamentals of this patch
   remain the same as before.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
5d8d4af24460 ("arm64: KVM: Fix system register enumeration")
---
 arch/arm64/kvm/guest.c | 53 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 4f7b26b..51c9457 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -71,10 +71,8 @@ static u64 core_reg_offset_from_id(u64 id)
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
 }
 
-static int validate_core_offset(const struct kvm_vcpu *vcpu,
-				const struct kvm_one_reg *reg)
+static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 {
-	u64 off = core_reg_offset_from_id(reg->id);
 	int size;
 
 	switch (off) {
@@ -104,8 +102,7 @@ static int validate_core_offset(const struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
-	if (KVM_REG_SIZE(reg->id) != size ||
-	    !IS_ALIGNED(off, size / sizeof(__u32)))
+	if (!IS_ALIGNED(off, size / sizeof(__u32)))
 		return -EINVAL;
 
 	/*
@@ -116,6 +113,21 @@ static int validate_core_offset(const struct kvm_vcpu *vcpu,
 	if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
 		return -EINVAL;
 
+	return size;
+}
+
+static int validate_core_offset(const struct kvm_vcpu *vcpu,
+				const struct kvm_one_reg *reg)
+{
+	u64 off = core_reg_offset_from_id(reg->id);
+	int size = core_reg_size_from_offset(vcpu, off);
+
+	if (size < 0)
+		return -EINVAL;
+
+	if (KVM_REG_SIZE(reg->id) != size)
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -428,19 +440,34 @@ static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
 {
 	unsigned int i;
 	int n = 0;
-	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
 
 	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
-		/*
-		 * The KVM_REG_ARM64_SVE regs must be used instead of
-		 * KVM_REG_ARM_CORE for accessing the FPSIMD V-registers on
-		 * SVE-enabled vcpus:
-		 */
-		if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(i))
+		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
+		int size = core_reg_size_from_offset(vcpu, i);
+
+		if (size < 0)
+			continue;
+
+		switch (size) {
+		case sizeof(__u32):
+			reg |= KVM_REG_SIZE_U32;
+			break;
+
+		case sizeof(__u64):
+			reg |= KVM_REG_SIZE_U64;
+			break;
+
+		case sizeof(__uint128_t):
+			reg |= KVM_REG_SIZE_U128;
+			break;
+
+		default:
+			WARN_ON(1);
 			continue;
+		}
 
 		if (uindices) {
-			if (put_user(core_reg | i, uindices))
+			if (put_user(reg, uindices))
 				return -EFAULT;
 			uindices++;
 		}
-- 
2.1.4
