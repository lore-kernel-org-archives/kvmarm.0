From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v3 17/24] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Tue, 11 Dec 2018 23:28:54 +0000
Message-ID: <1544570941-7377-18-git-send-email-Dave.Martin@arm.com>
References: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89C724A391
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sz7m58hGs27Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 18:30:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4358B4A392
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:23 -0500 (EST)
In-Reply-To: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
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

On an SVE-enabled vcpu, the appropriate number of slice IDs are
enumerated for each SVE register, depending on the maximum vector
length for the vcpu.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since RFC v2:

 * Add KVM_SVE_{Z,P}REG_SIZE, KVM_SVE_SLICES(vcpu) macros to abstract
   out awkward expressions for the size of SVE registers and number
   of register slices.

   The underlying expressions are rather awkward and best not spelled
   out longhand.
---
 arch/arm64/kvm/guest.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 29f3f54..9657e9d 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -222,6 +222,11 @@ struct kreg_region {
 
 #define SVE_NUM_SLICES (1 << SVE_REG_SLICE_BITS)
 
+#define KVM_SVE_ZREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0))
+#define KVM_SVE_PREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_PREG(0, 0))
+#define KVM_SVE_SLICES(vcpu) \
+	DIV_ROUND_UP((vcpu)->arch.sve_max_vl, KVM_SVE_ZREG_SIZE)
+
 static int sve_reg_region(struct kreg_region *b,
 			  const struct kvm_vcpu *vcpu,
 			  const struct kvm_one_reg *reg)
@@ -239,7 +244,7 @@ static int sve_reg_region(struct kreg_region *b,
 	if (reg->id >= KVM_REG_ARM64_SVE_ZREG(0, 0) &&
 	    reg->id <= KVM_REG_ARM64_SVE_ZREG(SVE_NUM_ZREGS - 1,
 					      SVE_NUM_SLICES - 1)) {
-		slice_size = KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0));
+		slice_size = KVM_SVE_ZREG_SIZE;
 
 		/* Compute start and end of the register: */
 		offset = SVE_SIG_ZREG_OFFSET(vq, reg_num) - SVE_SIG_REGS_OFFSET;
@@ -251,7 +256,7 @@ static int sve_reg_region(struct kreg_region *b,
 		   reg->id <= KVM_REG_ARM64_SVE_FFR(SVE_NUM_SLICES - 1)) {
 		/* (FFR is P16 for our purposes) */
 
-		slice_size = KVM_REG_SIZE(KVM_REG_ARM64_SVE_PREG(0, 0));
+		slice_size = KVM_SVE_PREG_SIZE;
 
 		/* Compute start and end of the register: */
 		offset = SVE_SIG_PREG_OFFSET(vq, reg_num) - SVE_SIG_REGS_OFFSET;
@@ -423,6 +428,44 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
 }
 
+static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
+{
+	unsigned int slices;
+
+	if (!vcpu_has_sve(vcpu))
+		return 0;
+
+	slices = KVM_SVE_SLICES(vcpu);
+	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */);
+}
+
+static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu, u64 __user **uind)
+{
+	unsigned int slices, i, n;
+
+	if (!vcpu_has_sve(vcpu))
+		return 0;
+
+	slices = KVM_SVE_SLICES(vcpu);
+
+	for (i = 0; i < slices; i++) {
+		for (n = 0; n < SVE_NUM_ZREGS; n++) {
+			if (put_user(KVM_REG_ARM64_SVE_ZREG(n, i), (*uind)++))
+				return -EFAULT;
+		}
+
+		for (n = 0; n < SVE_NUM_PREGS; n++) {
+			if (put_user(KVM_REG_ARM64_SVE_PREG(n, i), (*uind)++))
+				return -EFAULT;
+		}
+
+		if (put_user(KVM_REG_ARM64_SVE_FFR(i), (*uind)++))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 /**
  * kvm_arm_num_regs - how many registers do we present via KVM_GET_ONE_REG
  *
@@ -433,6 +476,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 	unsigned long res = 0;
 
 	res += num_core_regs(vcpu);
+	res += num_sve_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
 	res += NUM_TIMER_REGS;
@@ -453,6 +497,10 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	if (ret < 0)
 		return ret;
 
+	ret = copy_sve_reg_indices(vcpu, &uindices);
+	if (ret)
+		return ret;
+
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
 	if (ret)
 		return ret;
-- 
2.1.4
