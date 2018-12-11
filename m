From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v3 11/24] KVM: arm64: Support runtime sysreg filtering for
 KVM_GET_REG_LIST
Date: Tue, 11 Dec 2018 23:28:48 +0000
Message-ID: <1544570941-7377-12-git-send-email-Dave.Martin@arm.com>
References: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02E4F4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bW2ttb3o1nsY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 18:30:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C63854A384
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:11 -0500 (EST)
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

KVM_GET_REG_LIST should only enumerate registers that are actually
accessible, so it is necessary to filter out any register that is
not exposed to the guest.  For features that are configured at
runtime, this will require a dynamic check.

For example, ZCR_EL1 and ID_AA64ZFR0_EL1 would need to be hidden
if SVE is not enabled for the guest.

Special-casing walk_one_sys_reg() for specific registers will make
the code unnecessarily messy, so this patch adds a new sysreg
method check_present() that, if defined, indicates whether the
sysreg should be enumerated.  If the guest runtime configuration
may require a particular system register to be hidden,
check_present should point to a function that returns true or false
to enable or disable enumeration of that register respectively.

Currently check_present() is not used for any other purpose, but it
may be a useful foundation for abstracting other parts of the code
to handle conditionally-present sysregs, if required.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 10 +++++++---
 arch/arm64/kvm/sys_regs.h |  4 ++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0dfd064..adb6cbd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2437,7 +2437,8 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
 	return true;
 }
 
-static int walk_one_sys_reg(const struct sys_reg_desc *rd,
+static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
+			    const struct sys_reg_desc *rd,
 			    u64 __user **uind,
 			    unsigned int *total)
 {
@@ -2448,6 +2449,9 @@ static int walk_one_sys_reg(const struct sys_reg_desc *rd,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
+	if (rd->check_present && !rd->check_present(vcpu, rd))
+		return 0;
+
 	if (!copy_reg_to_user(rd, uind))
 		return -EFAULT;
 
@@ -2476,9 +2480,9 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
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
index add27cc..c7a0c23 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -66,6 +66,10 @@ struct sys_reg_desc {
 			const struct kvm_one_reg *reg, void __user *uaddr);
 	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			const struct kvm_one_reg *reg, void __user *uaddr);
+
+	/* Return true iff the register exists; assume present if NULL */
+	bool (*check_present)(const struct kvm_vcpu *vcpu,
+			      const struct sys_reg_desc *rd);
 };
 
 static inline void print_sys_reg_instr(const struct sys_reg_params *p)
-- 
2.1.4
