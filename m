From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 3/3] KVM: arm64: Filter out invalid core register IDs in
 KVM_GET_REG_LIST
Date: Tue, 11 Dec 2018 15:41:26 +0000
Message-ID: <1544542886-28882-4-git-send-email-Dave.Martin@arm.com>
References: <1544542886-28882-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1316D4A385
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 10:41:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PRPlfsOq9gJ7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 10:41:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB5414A1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 10:41:34 -0500 (EST)
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

This patch fixes the problem by marking each core register ID with
the appropriate size, and by filtering out any misaligned IDs using
validate_core_reg_id().

The number of core register IDs resulting from the process is now
not trivial to determine (even though it is still theoretically
compile-time constant).  In order to avoid implementing complex
logic twice, copy_core_reg_indices() is now used both to count and
copy the indices.  This will add a small runtime cost, but this is
deemed acceptable since KVM_GET_REG_LIST is not performance-
critical for userspace.

Fixes: d26c25a9d19b ("arm64: KVM: Tighten guest core register access from userspace")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/guest.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 19e4a83..1d547db 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -197,20 +197,55 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 static int copy_core_reg_indices(u64 __user **uind)
 {
 	unsigned int i;
-	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
+	int total = 0;
 
 	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
-		if (put_user(core_reg | i, *uind))
-			return -EFAULT;
-		++*uind;
+		u64 id = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
+		int size = core_reg_size_from_offset(i);
+
+		if (size < 0)
+			continue;
+
+		switch (size) {
+		case sizeof(__u32):
+			id |= KVM_REG_SIZE_U32;
+			break;
+
+		case sizeof(__u64):
+			id |= KVM_REG_SIZE_U64;
+			break;
+
+		case sizeof(__uint128_t):
+			id |= KVM_REG_SIZE_U128;
+			break;
+
+		default:
+			WARN_ON(1);
+			/*
+			 * leave reg size field as zero:
+			 * validate_core_reg_id() will reject it
+			 */
+			break;
+		}
+
+		if (validate_core_reg_id(id))
+			continue;
+
+		if (uind) {
+			if (put_user(id, *uind))
+				return -EFAULT;
+			++*uind;
+		}
+
+		++total;
 	}
 
-	return 0;
+	return total;
 }
 
 static unsigned long num_core_regs(void)
 {
-	return sizeof(struct kvm_regs) / sizeof(__u32);
+	return copy_core_reg_indices(NULL);
 }
 
 /**
@@ -287,7 +322,7 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	int ret;
 
 	ret = copy_core_reg_indices(&uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
-- 
2.1.4
