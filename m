From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v7 19/27] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Fri, 29 Mar 2019 13:00:44 +0000
Message-ID: <1553864452-15080-20-git-send-email-Dave.Martin@arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 817474A418
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:02:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id khcwniHF9DTW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Mar 2019 09:02:24 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CAC64A456
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:02:23 -0400 (EDT)
In-Reply-To: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
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

This patch includes the SVE register IDs in the list returned by
KVM_GET_REG_LIST, as appropriate.

On a non-SVE-enabled vcpu, no new IDs are added.

On an SVE-enabled vcpu, IDs for the FPSIMD V-registers are removed
from the list, since userspace is required to access the Z-
registers instead in order to access the V-register content.  For
the variably-sized SVE registers, the appropriate set of slice IDs
are enumerated, depending on the maximum vector length for the
vcpu.

As it currently stands, the SVE architecture never requires more
than one slice to exist per register, so this patch adds no
explicit support for enumerating multiple slices.  The code can be
extended straightforwardly to support this in the future, if
needed.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>

---

Changes since v6:

 * [Julien Thierry] Add a #define to replace the magic "slices = 1",
   and add a comment explaining to maintainers what needs to happen if
   this is updated in the future.

Changes since v5:

(Dropped Julien Thierry's Reviewed-by due to non-trivial rebasing)

 * Move mis-split reword to prevent put_user()s being accidentally the
   correct size from KVM: arm64/sve: Add pseudo-register for the guest's
   vector lengths.
---
 arch/arm64/kvm/guest.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 736d8cb..2aa80a5 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -222,6 +222,13 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 #define KVM_SVE_ZREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0))
 #define KVM_SVE_PREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_PREG(0, 0))
 
+/*
+ * number of register slices required to cover each whole SVE register on vcpu
+ * NOTE: If you are tempted to modify this, you must also to rework
+ * sve_reg_to_region() to match:
+ */
+#define vcpu_sve_slices(vcpu) 1
+
 /* Bounds of a single SVE register slice within vcpu->arch.sve_state */
 struct sve_state_reg_region {
 	unsigned int koffset;	/* offset into sve_state in kernel memory */
@@ -411,6 +418,56 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
 }
 
+static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
+{
+	/* Only the first slice ever exists, for now */
+	const unsigned int slices = vcpu_sve_slices(vcpu);
+
+	if (!vcpu_has_sve(vcpu))
+		return 0;
+
+	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */);
+}
+
+static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
+				u64 __user *uindices)
+{
+	/* Only the first slice ever exists, for now */
+	const unsigned int slices = vcpu_sve_slices(vcpu);
+	u64 reg;
+	unsigned int i, n;
+	int num_regs = 0;
+
+	if (!vcpu_has_sve(vcpu))
+		return 0;
+
+	for (i = 0; i < slices; i++) {
+		for (n = 0; n < SVE_NUM_ZREGS; n++) {
+			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
+			if (put_user(reg, uindices++))
+				return -EFAULT;
+
+			num_regs++;
+		}
+
+		for (n = 0; n < SVE_NUM_PREGS; n++) {
+			reg = KVM_REG_ARM64_SVE_PREG(n, i);
+			if (put_user(reg, uindices++))
+				return -EFAULT;
+
+			num_regs++;
+		}
+
+		reg = KVM_REG_ARM64_SVE_FFR(i);
+		if (put_user(reg, uindices++))
+			return -EFAULT;
+
+		num_regs++;
+	}
+
+	return num_regs;
+}
+
 /**
  * kvm_arm_num_regs - how many registers do we present via KVM_GET_ONE_REG
  *
@@ -421,6 +478,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 	unsigned long res = 0;
 
 	res += num_core_regs(vcpu);
+	res += num_sve_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
 	res += NUM_TIMER_REGS;
@@ -442,6 +500,11 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		return ret;
 	uindices += ret;
 
+	ret = copy_sve_reg_indices(vcpu, uindices);
+	if (ret)
+		return ret;
+	uindices += ret;
+
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret)
 		return ret;
-- 
2.1.4
