From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v3 15/24] KVM: arm64: Reject ioctl access to FPSIMD V-regs
 on SVE vcpus
Date: Tue, 11 Dec 2018 23:28:52 +0000
Message-ID: <1544570941-7377-16-git-send-email-Dave.Martin@arm.com>
References: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2F0A4A214
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9j5EMBFcxC2P for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 18:30:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F8A74A39C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:19 -0500 (EST)
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

In order to avoid the pointless complexity of maintaining two ioctl
register access views of the same data, this patch blocks ioctl
access to the FPSIMD V-registers on vcpus that support SVE.

This will make it more straightforward to add SVE register access
support.

Since SVE is an opt-in feature for userspace, this will not affect
existing users.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since RFC v2:

 * New patch

   The initial code was split from "KVM: arm64/sve: Add SVE support to
   register access ioctl interface".  However, some additional
   refactoring makes this change quite noisy: for ease of review,
   I decided it was best to keep the two parts of the change separate.

 * Move core_reg_offset_is_vreg() before validate_core_reg_id()
   (which now makes use of it).

 * Move rejection of KVM_REG_ARM_CORE view of the FPSIMD V-regs on
   SVE-enabled vcpus into validate_core_reg_id(), so that it can be
   applied everywhere appropriate instead of being open-coded.

   This requires vcpu to be pushed down into a few code paths
   (This is the noise alluded to above).
---
 arch/arm64/kvm/guest.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 0bf0ed3..e1ea73e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -83,7 +83,13 @@ static int core_reg_size_from_offset(u64 off)
 	return -EINVAL;
 }
 
-static int validate_core_reg_id(u64 id)
+static bool core_reg_offset_is_vreg(u64 off)
+{
+	return off >= KVM_REG_ARM_CORE_REG(fp_regs.vregs) &&
+		off < KVM_REG_ARM_CORE_REG(fp_regs.fpsr);
+}
+
+static int validate_core_reg_id(const struct kvm_vcpu *vcpu, u64 id)
 {
 	u64 off = core_reg_offset_from_id(id);
 	int size = core_reg_size_from_offset(off);
@@ -91,10 +97,18 @@ static int validate_core_reg_id(u64 id)
 	if (size < 0)
 		return size;
 
-	if (KVM_REG_SIZE(id) == size && IS_ALIGNED(off, size / sizeof(__u32)))
-		return 0;
+	if (KVM_REG_SIZE(id) != size || !IS_ALIGNED(off, size / sizeof(__u32)))
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
@@ -116,7 +130,7 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	    (off + (KVM_REG_SIZE(reg->id) / sizeof(__u32))) >= nr_regs)
 		return -ENOENT;
 
-	if (validate_core_reg_id(reg->id))
+	if (validate_core_reg_id(vcpu, reg->id))
 		return -EINVAL;
 
 	if (copy_to_user(uaddr, ((u32 *)regs) + off, KVM_REG_SIZE(reg->id)))
@@ -141,7 +155,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	    (off + (KVM_REG_SIZE(reg->id) / sizeof(__u32))) >= nr_regs)
 		return -ENOENT;
 
-	if (validate_core_reg_id(reg->id))
+	if (validate_core_reg_id(vcpu, reg->id))
 		return -EINVAL;
 
 	if (KVM_REG_SIZE(reg->id) > sizeof(tmp))
@@ -194,7 +208,8 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return -EINVAL;
 }
 
-static int copy_core_reg_indices(u64 __user **uind)
+static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
+				 u64 __user **uind)
 {
 	unsigned int i;
 	int total = 0;
@@ -228,7 +243,7 @@ static int copy_core_reg_indices(u64 __user **uind)
 			break;
 		}
 
-		if (validate_core_reg_id(id))
+		if (validate_core_reg_id(vcpu, id))
 			continue;
 
 		if (uind) {
@@ -243,9 +258,9 @@ static int copy_core_reg_indices(u64 __user **uind)
 	return total;
 }
 
-static unsigned long num_core_regs(void)
+static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
 {
-	return copy_core_reg_indices(NULL);
+	return copy_core_reg_indices(vcpu, NULL);
 }
 
 /**
@@ -310,7 +325,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 {
 	unsigned long res = 0;
 
-	res += num_core_regs();
+	res += num_core_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
 	res += NUM_TIMER_REGS;
@@ -327,7 +342,7 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
 	int ret;
 
-	ret = copy_core_reg_indices(&uindices);
+	ret = copy_core_reg_indices(vcpu, &uindices);
 	if (ret < 0)
 		return ret;
 
-- 
2.1.4
