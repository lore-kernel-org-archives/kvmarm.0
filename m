From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 16/25] KVM: arm64: Reject ioctl access to FPSIMD V-regs on
 SVE vcpus
Date: Thu, 17 Jan 2019 20:33:30 +0000
Message-ID: <1547757219-19439-17-git-send-email-Dave.Martin@arm.com>
References: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75C104A382
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jan 2019 15:35:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cUC3KlOcQBJC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jan 2019 15:35:04 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 655A94A3C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jan 2019 15:35:03 -0500 (EST)
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

In order to avoid the pointless complexity of maintaining two ioctl
register access views of the same data, this patch blocks ioctl
access to the FPSIMD V-registers on vcpus that support SVE.

This will make it more straightforward to add SVE register access
support.

Since SVE is an opt-in feature for userspace, this will not affect
existing users.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/guest.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 65f4338..ffa38d4 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -94,7 +94,14 @@ static int core_reg_size_from_offset(u64 off)
 	return -EINVAL;
 }
 
-static int validate_core_offset(const struct kvm_one_reg *reg)
+static bool core_reg_offset_is_vreg(u64 off)
+{
+	return off >= KVM_REG_ARM_CORE_REG(fp_regs.vregs) &&
+		off < KVM_REG_ARM_CORE_REG(fp_regs.fpsr);
+}
+
+static int validate_core_offset(const struct kvm_vcpu *vcpu,
+				const struct kvm_one_reg *reg)
 {
 	u64 off = core_reg_offset_from_id(reg->id);
 	int size = core_reg_size_from_offset(off);
@@ -102,10 +109,18 @@ static int validate_core_offset(const struct kvm_one_reg *reg)
 	if (size < 0)
 		return -EINVAL;
 
-	if (KVM_REG_SIZE(reg->id) == size)
-		return 0;
+	if (KVM_REG_SIZE(reg->id) != size)
+		return -EINVAL;
 
-	return -EINVAL;
+	/*
+	 * The KVM_REG_ARM64_SVE regs must be used instead of
+	 * KVM_REG_ARM_CORE for accessing the FPSIMD V-registers on
+	 * SVE-enabled vcpus:
+	 */
+	if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
+		return -EINVAL;
+
+	return 0;
 }
 
 static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
@@ -127,7 +142,7 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	    (off + (KVM_REG_SIZE(reg->id) / sizeof(__u32))) >= nr_regs)
 		return -ENOENT;
 
-	if (validate_core_offset(reg))
+	if (validate_core_offset(vcpu, reg))
 		return -EINVAL;
 
 	if (copy_to_user(uaddr, ((u32 *)regs) + off, KVM_REG_SIZE(reg->id)))
@@ -152,7 +167,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	    (off + (KVM_REG_SIZE(reg->id) / sizeof(__u32))) >= nr_regs)
 		return -ENOENT;
 
-	if (validate_core_offset(reg))
+	if (validate_core_offset(vcpu, reg))
 		return -EINVAL;
 
 	if (KVM_REG_SIZE(reg->id) > sizeof(tmp))
@@ -205,7 +220,8 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return -EINVAL;
 }
 
-static int copy_core_reg_indices(u64 __user **uind)
+static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
+				 u64 __user **uind)
 {
 	unsigned int i;
 	int n = 0;
@@ -247,9 +263,9 @@ static int copy_core_reg_indices(u64 __user **uind)
 	return n;
 }
 
-static unsigned long num_core_regs(void)
+static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
 {
-	return copy_core_reg_indices(NULL);
+	return copy_core_reg_indices(vcpu, NULL);
 }
 
 /**
@@ -314,7 +330,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 {
 	unsigned long res = 0;
 
-	res += num_core_regs();
+	res += num_core_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
 	res += NUM_TIMER_REGS;
@@ -331,7 +347,7 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
 	int ret;
 
-	ret = copy_core_reg_indices(&uindices);
+	ret = copy_core_reg_indices(vcpu, &uindices);
 	if (ret < 0)
 		return ret;
 
-- 
2.1.4
