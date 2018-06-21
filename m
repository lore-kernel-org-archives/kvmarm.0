From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 08/16] KVM: arm64: Support dynamically hideable system
 registers
Date: Thu, 21 Jun 2018 15:57:32 +0100
Message-ID: <1529593060-542-9-git-send-email-Dave.Martin@arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F0004A0FE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8WZVcOsfxBBe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jun 2018 10:46:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1E3B4A0CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:46:53 -0400 (EDT)
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

Some system registers may or may not logically exist for a vcpu
depending on whether certain architectural features are enabled for
the vcpu.

In order to avoid spuriously emulating access to these registers
when they should not exist, or allowing the registers to be
spuriously enumerated or saved/restored through the ioctl
interface, a means is needed to allow registers to be hidden
depending on the vcpu configuration.

In order to support this in a flexible way, this patch adds a
check_present() method to struct sys_reg_desc, and updates the
generic system register access and enumeration code to be aware of
it:  if check_present() returns false, the code behaves as if the
register did not exist.

For convenience, the complete check is wrapped up in a new helper
sys_reg_present().

An attempt has been made to hook the new check into the generic
accessors for trapped system registers.  This should reduce the
potential for future surprises, although the redundant check will
add a small cost.  No system register depends on this functionality
yet, and some paths needing the check may also need attention.

Naturally, this facility makes sense only for registers that are
trapped.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 20 +++++++++++++++-----
 arch/arm64/kvm/sys_regs.h | 11 +++++++++++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a436373..31a351a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1840,7 +1840,7 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
 
 	r = find_reg(params, table, num);
 
-	if (r) {
+	if (likely(r) && sys_reg_present(vcpu, r)) {
 		perform_access(vcpu, params, r);
 		return 0;
 	}
@@ -2016,7 +2016,7 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	if (!r)
 		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
-	if (likely(r)) {
+	if (likely(r) && sys_reg_present(vcpu, r)) {
 		perform_access(vcpu, params, r);
 	} else {
 		kvm_err("Unsupported guest sys_reg access at: %lx\n",
@@ -2313,6 +2313,9 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (!r)
 		return get_invariant_sys_reg(reg->id, uaddr);
 
+	if (!sys_reg_present(vcpu, r))
+		return -ENOENT;
+
 	if (r->get_user)
 		return (r->get_user)(vcpu, r, reg, uaddr);
 
@@ -2334,6 +2337,9 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (!r)
 		return set_invariant_sys_reg(reg->id, uaddr);
 
+	if (!sys_reg_present(vcpu, r))
+		return -ENOENT;
+
 	if (r->set_user)
 		return (r->set_user)(vcpu, r, reg, uaddr);
 
@@ -2390,7 +2396,8 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
 	return true;
 }
 
-static int walk_one_sys_reg(const struct sys_reg_desc *rd,
+static int walk_one_sys_reg(struct kvm_vcpu *vcpu,
+			    const struct sys_reg_desc *rd,
 			    u64 __user **uind,
 			    unsigned int *total)
 {
@@ -2401,6 +2408,9 @@ static int walk_one_sys_reg(const struct sys_reg_desc *rd,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
+	if (!sys_reg_present(vcpu, rd))
+		return 0;
+
 	if (!copy_reg_to_user(rd, uind))
 		return -EFAULT;
 
@@ -2429,9 +2439,9 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 		int cmp = cmp_sys_reg(i1, i2);
 		/* target-specific overrides generic entry. */
 		if (cmp <= 0)
-			err = walk_one_sys_reg(i1, &uind, &total);
+			err = walk_one_sys_reg(vcpu, i1, &uind, &total);
 		else
-			err = walk_one_sys_reg(i2, &uind, &total);
+			err = walk_one_sys_reg(vcpu, i2, &uind, &total);
 
 		if (err)
 			return err;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index cd710f8..dfbb342 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -22,6 +22,9 @@
 #ifndef __ARM64_KVM_SYS_REGS_LOCAL_H__
 #define __ARM64_KVM_SYS_REGS_LOCAL_H__
 
+#include <linux/compiler.h>
+#include <linux/types.h>
+
 struct sys_reg_params {
 	u8	Op0;
 	u8	Op1;
@@ -61,8 +64,16 @@ struct sys_reg_desc {
 			const struct kvm_one_reg *reg, void __user *uaddr);
 	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			const struct kvm_one_reg *reg, void __user *uaddr);
+	bool (*check_present)(const struct kvm_vcpu *vpcu,
+			      const struct sys_reg_desc *rd);
 };
 
+static inline bool sys_reg_present(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd)
+{
+	return likely(!rd->check_present) || rd->check_present(vcpu, rd);
+}
+
 static inline void print_sys_reg_instr(const struct sys_reg_params *p)
 {
 	/* Look, we even formatted it for you to paste into the table! */
-- 
2.1.4
