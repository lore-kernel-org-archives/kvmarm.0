From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 2/2] KVM: arm64: Factor out KVM_GET_REG_LIST core register
 enumeration
Date: Wed, 12 Dec 2018 20:17:04 +0000
Message-ID: <1544645824-16461-3-git-send-email-Dave.Martin@arm.com>
References: <1544645824-16461-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B03D4A331
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 15:17:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I0oPLdfzO51v for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 15:17:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E4FC4A1DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 15:17:58 -0500 (EST)
In-Reply-To: <1544645824-16461-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
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
 arch/arm64/kvm/guest.c | 65 ++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index cbe423b..46eb867 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -205,23 +205,53 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return -EINVAL;
 }
 
-static unsigned long num_core_regs(void)
+static int copy_core_reg_indices(u64 __user **uind)
 {
 	unsigned int i;
 	int n = 0;
 
 	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
+		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
 		int size = core_reg_size_from_offset(i);
 
 		if (size < 0)
 			continue;
 
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
+			continue;
+		}
+
+		if (uind) {
+			if (put_user(reg, *uind))
+				return -EFAULT;
+			++*uind;
+		}
+
 		n++;
 	}
 
 	return n;
 }
 
+static unsigned long num_core_regs(void)
+{
+	return copy_core_reg_indices(NULL);
+}
+
 /**
  * ARM64 versions of the TIMER registers, always available on arm64
  */
@@ -293,38 +323,11 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
  */
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	unsigned int i;
 	int ret;
 
-	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
-		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
-		int size = core_reg_size_from_offset(i);
-
-		if (size < 0)
-			continue;
-
-		switch (size) {
-		case sizeof(__u32):
-			reg |= KVM_REG_SIZE_U32;
-			break;
-
-		case sizeof(__u64):
-			reg |= KVM_REG_SIZE_U64;
-			break;
-
-		case sizeof(__uint128_t):
-			reg |= KVM_REG_SIZE_U128;
-			break;
-
-		default:
-			WARN_ON(1);
-			continue;
-		}
-
-		if (put_user(reg, uindices))
-			return -EFAULT;
-		uindices++;
-	}
+	ret = copy_core_reg_indices(&uindices);
+	if (ret < 0)
+		return ret;
 
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret)
-- 
2.1.4
