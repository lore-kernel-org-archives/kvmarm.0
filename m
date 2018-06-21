From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 15/16] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Thu, 21 Jun 2018 15:57:39 +0100
Message-ID: <1529593060-542-16-git-send-email-Dave.Martin@arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E33EE4A0E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z6CO7HDZVoxo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jun 2018 10:47:15 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F074A0EE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:07 -0400 (EDT)
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

This patch includes the SVE register IDs in the list returned by
KVM_GET_REG_LIST, as appropriate.

On a non-SVE-enabled vcpu, no extra IDs are added.

On an SVE-enabled vcpu, the appropriate number of slide IDs are
enumerated for each SVE register, depending on the maximum vector
length for the vcpu.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/guest.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 005394b..5152362 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -21,6 +21,7 @@
 
 #include <linux/errno.h>
 #include <linux/err.h>
+#include <linux/kernel.h>
 #include <linux/kvm_host.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
@@ -253,6 +254,73 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return err;
 }
 
+static void copy_reg_index_to_user(u64 __user **uind, int *total, int *cerr,
+				   u64 id)
+{
+	int err;
+
+	if (*cerr)
+		return;
+
+	if (uind) {
+		err = put_user(id, *uind);
+		if (err) {
+			*cerr = err;
+			return;
+		}
+	}
+
+	++*total;
+	if (uind)
+		++*uind;
+}
+
+static int enumerate_sve_regs(const struct kvm_vcpu *vcpu, u64 __user **uind)
+{
+	unsigned int n, i;
+	int err = 0;
+	int total = 0;
+	unsigned int slices;
+
+	if (!vcpu_has_sve(&vcpu->arch))
+		return 0;
+
+	slices = DIV_ROUND_UP(vcpu->arch.sve_max_vl,
+			      KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0)));
+
+	for (n = 0; n < SVE_NUM_ZREGS; ++n)
+		for (i = 0; i < slices; ++i)
+			copy_reg_index_to_user(uind, &total, &err,
+					       KVM_REG_ARM64_SVE_ZREG(n, i));
+
+	for (n = 0; n < SVE_NUM_PREGS; ++n)
+		for (i = 0; i < slices; ++i)
+			copy_reg_index_to_user(uind, &total, &err,
+					       KVM_REG_ARM64_SVE_PREG(n, i));
+
+	for (i = 0; i < slices; ++i)
+		copy_reg_index_to_user(uind, &total, &err,
+				       KVM_REG_ARM64_SVE_FFR(i));
+
+	if (err)
+		return -EFAULT;
+
+	return total;
+}
+
+static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
+{
+	return enumerate_sve_regs(vcpu, NULL);
+}
+
+static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu, u64 __user **uind)
+{
+	int err;
+
+	err = enumerate_sve_regs(vcpu, uind);
+	return err < 0 ? err : 0;
+}
+
 static int sve_reg_bounds(struct reg_bounds_struct *b,
 			  const struct kvm_vcpu *vcpu,
 			  const struct kvm_one_reg *reg)
@@ -403,6 +471,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 	unsigned long res = 0;
 
 	res += num_core_regs();
+	res += num_sve_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
 	res += NUM_TIMER_REGS;
@@ -427,6 +496,10 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		uindices++;
 	}
 
+	ret = copy_sve_reg_indices(vcpu, &uindices);
+	if (ret)
+		return ret;
+
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret)
 		return ret;
-- 
2.1.4
