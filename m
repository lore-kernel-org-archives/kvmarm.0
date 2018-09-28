From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 16/23] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Fri, 28 Sep 2018 14:39:20 +0100
Message-ID: <1538141967-15375-17-git-send-email-Dave.Martin@arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3FC04A0C9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qJvGLKLdc7Tv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:40:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 788E54A2D2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:47 -0400 (EDT)
In-Reply-To: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
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

Changes since RFCv1:

 * Simplify enumerate_sve_regs() based on Andrew Jones' approach.

 * Reg copying loops are inverted for brevity, since the order we
   spit out the regs in doesn't really matter.

(I tried to keep part of my approach to avoid the duplicate logic
between num_sve_regs() and copy_sve_reg_indices(), but although
it works in principle, gcc fails to fully collapse the num_regs()
case... so I gave up.  The two functions need to be manually kept
consistent, but hopefully that's fairly straightforward.)
---
 arch/arm64/kvm/guest.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 320db0f..89eab68 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -323,6 +323,46 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
 }
 
+static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
+{
+	const unsigned int slices = DIV_ROUND_UP(
+		vcpu->arch.sve_max_vl,
+		KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0)));
+
+	if (!vcpu_has_sve(vcpu))
+		return 0;
+
+	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */);
+}
+
+static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu, u64 __user **uind)
+{
+	const unsigned int slices = DIV_ROUND_UP(
+		vcpu->arch.sve_max_vl,
+		KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0)));
+	unsigned int i, n;
+
+	if (!vcpu_has_sve(vcpu))
+		return 0;
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
@@ -333,6 +373,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 	unsigned long res = 0;
 
 	res += num_core_regs();
+	res += num_sve_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
 	res += NUM_TIMER_REGS;
@@ -357,6 +398,10 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
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
