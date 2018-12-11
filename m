From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 2/3] KVM: arm64: Factor out KVM_GET_REG_LIST core register
 enumeration
Date: Tue, 11 Dec 2018 15:41:25 +0000
Message-ID: <1544542886-28882-3-git-send-email-Dave.Martin@arm.com>
References: <1544542886-28882-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C499F4A372
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 10:41:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Ss3peobt5bd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 10:41:35 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA8FA4A334
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 10:41:33 -0500 (EST)
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

Currently, enumeration of the core register IDs for
KVM_GET_REG_LIST is open-coded in kvm_arm_copy_reg_indices().

This will become cumbersome as the enumeration logic becomes more
complex.  In preparation for future patches, this patch factors the
code out into a separate function copy_core_reg_indices(),
consistently with the way other classes of registers are handled.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/guest.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index b0a63fc..19e4a83 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -194,6 +194,20 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return -EINVAL;
 }
 
+static int copy_core_reg_indices(u64 __user **uind)
+{
+	unsigned int i;
+	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
+
+	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
+		if (put_user(core_reg | i, *uind))
+			return -EFAULT;
+		++*uind;
+	}
+
+	return 0;
+}
+
 static unsigned long num_core_regs(void)
 {
 	return sizeof(struct kvm_regs) / sizeof(__u32);
@@ -270,15 +284,11 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
  */
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	unsigned int i;
-	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
 	int ret;
 
-	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
-		if (put_user(core_reg | i, uindices))
-			return -EFAULT;
-		uindices++;
-	}
+	ret = copy_core_reg_indices(&uindices);
+	if (ret)
+		return ret;
 
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret)
-- 
2.1.4
