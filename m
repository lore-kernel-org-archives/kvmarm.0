From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 1/3] KVM: arm64: Factor out core register size determination
 and validation
Date: Tue, 11 Dec 2018 15:41:24 +0000
Message-ID: <1544542886-28882-2-git-send-email-Dave.Martin@arm.com>
References: <1544542886-28882-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 292AE4A2BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 10:41:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SOtQTjSZjYl7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 10:41:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E51274A1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 10:41:32 -0500 (EST)
In-Reply-To: <1544542886-28882-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Currently, the only code that needs to deduce the proper size of a
KVM core register on arm64 is validate_core_offset().

In order to make this code easier to reuse, this patch factors out
the size determination into a separate function
core_reg_size_from_offset().

Since validate_core_offset() can be relevant in situations where
only a register ID is available, this patch also modifies the
interface to validate_core_offset() to take a register ID instead
of a struct kvm_one_reg.  In order to avoid confusion, the function
is renamed to validate_core_reg_id() to reflect the changed
semantics.

Subsequent patches will make use of these changes.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/guest.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dd436a5..b0a63fc 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -57,11 +57,8 @@ static u64 core_reg_offset_from_id(u64 id)
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
 }
 
-static int validate_core_offset(const struct kvm_one_reg *reg)
+static int core_reg_size_from_offset(u64 off)
 {
-	u64 off = core_reg_offset_from_id(reg->id);
-	int size;
-
 	switch (off) {
 	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
 	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
@@ -72,25 +69,29 @@ static int validate_core_offset(const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_CORE_REG(elr_el1):
 	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
 	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
-		size = sizeof(__u64);
-		break;
+		return sizeof(__u64);
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
 	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
-		size = sizeof(__uint128_t);
-		break;
+		return sizeof(__uint128_t);
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpcr):
-		size = sizeof(__u32);
-		break;
-
-	default:
-		return -EINVAL;
+		return sizeof(__u32);
 	}
 
-	if (KVM_REG_SIZE(reg->id) == size &&
-	    IS_ALIGNED(off, size / sizeof(__u32)))
+	return -EINVAL;
+}
+
+static int validate_core_reg_id(u64 id)
+{
+	u64 off = core_reg_offset_from_id(id);
+	int size = core_reg_size_from_offset(off);
+
+	if (size < 0)
+		return size;
+
+	if (KVM_REG_SIZE(id) == size && IS_ALIGNED(off, size / sizeof(__u32)))
 		return 0;
 
 	return -EINVAL;
@@ -115,7 +116,7 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	    (off + (KVM_REG_SIZE(reg->id) / sizeof(__u32))) >= nr_regs)
 		return -ENOENT;
 
-	if (validate_core_offset(reg))
+	if (validate_core_reg_id(reg->id))
 		return -EINVAL;
 
 	if (copy_to_user(uaddr, ((u32 *)regs) + off, KVM_REG_SIZE(reg->id)))
@@ -140,7 +141,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	    (off + (KVM_REG_SIZE(reg->id) / sizeof(__u32))) >= nr_regs)
 		return -ENOENT;
 
-	if (validate_core_offset(reg))
+	if (validate_core_reg_id(reg->id))
 		return -EINVAL;
 
 	if (KVM_REG_SIZE(reg->id) > sizeof(tmp))
-- 
2.1.4
