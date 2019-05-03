Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84654C43219
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 436B52081C
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 436B52081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF6314A4D6;
	Fri,  3 May 2019 08:45:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qk9ZNZDTyyjW; Fri,  3 May 2019 08:45:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 884504A51A;
	Fri,  3 May 2019 08:45:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1C14A4F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A38PHaHR+K6z for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:45:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B94754A4E6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 657BC15AD;
 Fri,  3 May 2019 05:45:21 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E2BD3F220;
 Fri,  3 May 2019 05:45:18 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 11/56] KVM: arm64: Support runtime sysreg visibility filtering
Date: Fri,  3 May 2019 13:43:42 +0100
Message-Id: <20190503124427.190206-12-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 "zhang . lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 kvmarm@lists.cs.columbia.edu, Amit Daniel Kachhap <amit.kachhap@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Dave Martin <Dave.Martin@arm.com>

Some optional features of the Arm architecture add new system
registers that are not present in the base architecture.

Where these features are optional for the guest, the visibility of
these registers may need to depend on some runtime configuration,
such as a flag passed to KVM_ARM_VCPU_INIT.

For example, ZCR_EL1 and ID_AA64ZFR0_EL1 need to be hidden if SVE
is not enabled for the guest, even though these registers may be
present in the hardware and visible to the host at EL2.

Adding special-case checks all over the place for individual
registers is going to get messy as the number of conditionally-
visible registers grows.

In order to help solve this problem, this patch adds a new sysreg
method visibility() that can be used to hook in any needed runtime
visibility checks.  This method can currently return
REG_HIDDEN_USER to inhibit enumeration and ioctl access to the
register for userspace, and REG_HIDDEN_GUEST to inhibit runtime
access by the guest using MSR/MRS.  Wrappers are added to allow
these flags to be conveniently queried.

This approach allows a conditionally modified view of individual
system registers such as the CPU ID registers, in addition to
completely hiding register where appropriate.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 24 +++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.h | 25 +++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a5d14b5e2ea4..c86a7b0d3e6b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1927,6 +1927,12 @@ static void perform_access(struct kvm_vcpu *vcpu,
 {
 	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
 
+	/* Check for regs disabled by runtime config */
+	if (sysreg_hidden_from_guest(vcpu, r)) {
+		kvm_inject_undefined(vcpu);
+		return;
+	}
+
 	/*
 	 * Not having an accessor means that we have configured a trap
 	 * that we don't know how to handle. This certainly qualifies
@@ -2438,6 +2444,10 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (!r)
 		return get_invariant_sys_reg(reg->id, uaddr);
 
+	/* Check for regs disabled by runtime config */
+	if (sysreg_hidden_from_user(vcpu, r))
+		return -ENOENT;
+
 	if (r->get_user)
 		return (r->get_user)(vcpu, r, reg, uaddr);
 
@@ -2459,6 +2469,10 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (!r)
 		return set_invariant_sys_reg(reg->id, uaddr);
 
+	/* Check for regs disabled by runtime config */
+	if (sysreg_hidden_from_user(vcpu, r))
+		return -ENOENT;
+
 	if (r->set_user)
 		return (r->set_user)(vcpu, r, reg, uaddr);
 
@@ -2515,7 +2529,8 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
 	return true;
 }
 
-static int walk_one_sys_reg(const struct sys_reg_desc *rd,
+static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
+			    const struct sys_reg_desc *rd,
 			    u64 __user **uind,
 			    unsigned int *total)
 {
@@ -2526,6 +2541,9 @@ static int walk_one_sys_reg(const struct sys_reg_desc *rd,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
+	if (sysreg_hidden_from_user(vcpu, rd))
+		return 0;
+
 	if (!copy_reg_to_user(rd, uind))
 		return -EFAULT;
 
@@ -2554,9 +2572,9 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
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
index 3b1bc7f01d0b..2be99508dcb9 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -64,8 +64,15 @@ struct sys_reg_desc {
 			const struct kvm_one_reg *reg, void __user *uaddr);
 	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			const struct kvm_one_reg *reg, void __user *uaddr);
+
+	/* Return mask of REG_* runtime visibility overrides */
+	unsigned int (*visibility)(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd);
 };
 
+#define REG_HIDDEN_USER		(1 << 0) /* hidden from userspace ioctls */
+#define REG_HIDDEN_GUEST	(1 << 1) /* hidden from guest */
+
 static inline void print_sys_reg_instr(const struct sys_reg_params *p)
 {
 	/* Look, we even formatted it for you to paste into the table! */
@@ -102,6 +109,24 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
 	__vcpu_sys_reg(vcpu, r->reg) = r->val;
 }
 
+static inline bool sysreg_hidden_from_guest(const struct kvm_vcpu *vcpu,
+					    const struct sys_reg_desc *r)
+{
+	if (likely(!r->visibility))
+		return false;
+
+	return r->visibility(vcpu, r) & REG_HIDDEN_GUEST;
+}
+
+static inline bool sysreg_hidden_from_user(const struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc *r)
+{
+	if (likely(!r->visibility))
+		return false;
+
+	return r->visibility(vcpu, r) & REG_HIDDEN_USER;
+}
+
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 			      const struct sys_reg_desc *i2)
 {
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
