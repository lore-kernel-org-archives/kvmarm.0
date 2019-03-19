From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 16/27] KVM: arm64: Factor out core register ID enumeration
Date: Tue, 19 Mar 2019 17:52:07 +0000
Message-ID: <1553017938-710-17-git-send-email-Dave.Martin@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0C24A43B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5MqUIXU7vfQE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 13:53:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52EC24A4B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 13:53:41 -0400 (EDT)
In-Reply-To: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for adding logic to filter out some KVM_REG_ARM_CORE
registers from the KVM_GET_REG_LIST output, this patch factors out
the core register enumeration into a separate function and rebuilds
num_core_regs() on top of it.

This may be a little more expensive (depending on how good a job
the compiler does of specialising the code), but KVM_GET_REG_LIST
is not a hot path.

This will make it easier to consolidate ID filtering code in one
place.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since v5:

 * New patch.

   This reimplements part of the separately-posted patch "KVM: arm64:
   Factor out KVM_GET_REG_LIST core register enumeration", minus aspects
   that potentially break the ABI.

   As a result, the opportunity to truly consolidate all the ID reg
   filtering in one place is deliberately left on the floor, for now.
   This will be addressed in a separate series later on.
---
 arch/arm64/kvm/guest.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 3e38eb2..a391a61 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -23,6 +23,7 @@
 #include <linux/err.h>
 #include <linux/kvm_host.h>
 #include <linux/module.h>
+#include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
@@ -194,9 +195,28 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return -EINVAL;
 }
 
+static int kvm_arm_copy_core_reg_indices(u64 __user *uindices)
+{
+	unsigned int i;
+	int n = 0;
+	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
+
+	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
+		if (uindices) {
+			if (put_user(core_reg | i, uindices))
+				return -EFAULT;
+			uindices++;
+		}
+
+		n++;
+	}
+
+	return n;
+}
+
 static unsigned long num_core_regs(void)
 {
-	return sizeof(struct kvm_regs) / sizeof(__u32);
+	return kvm_arm_copy_core_reg_indices(NULL);
 }
 
 /**
@@ -276,15 +296,12 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
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
+	ret = kvm_arm_copy_core_reg_indices(uindices);
+	if (ret)
+		return ret;
+	uindices += ret;
 
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret)
-- 
2.1.4
