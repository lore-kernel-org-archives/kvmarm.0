Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13924C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 11:34:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5D4420708
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 11:33:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5D4420708
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E8F34B0EC;
	Mon, 22 Jun 2020 07:33:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZYlkKto7H96j; Mon, 22 Jun 2020 07:33:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1030F4B0DB;
	Mon, 22 Jun 2020 07:33:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91EF84B0D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 07:33:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iVXyDawpd0BA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 07:33:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33E8C4B0F1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 07:33:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E38951FB;
 Mon, 22 Jun 2020 04:33:54 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20E583F71E;
 Mon, 22 Jun 2020 04:33:54 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/5] KVM: arm64: Remove target_table from exit handlers
Date: Mon, 22 Jun 2020 11:33:16 +0000
Message-Id: <20200622113317.20477-5-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200622113317.20477-1-james.morse@arm.com>
References: <20200622113317.20477-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>
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

Whenever KVM searches for a register (e.g. due to a guest exit), it
works with two tables, as the target table overrides the sys_regs array.

Now that everything is in the sys_regs array, and the target table is
empty, stop doing that.

Remove the second table and its size from all the functions that take
it.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 87 +++++++--------------------------------
 1 file changed, 16 insertions(+), 71 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f8407cfa9032..14333005b476 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2269,9 +2269,7 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
  */
 static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 			    const struct sys_reg_desc *global,
-			    size_t nr_global,
-			    const struct sys_reg_desc *target_specific,
-			    size_t nr_specific)
+			    size_t nr_global)
 {
 	struct sys_reg_params params;
 	u32 hsr = kvm_vcpu_get_hsr(vcpu);
@@ -2298,14 +2296,11 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 	}
 
 	/*
-	 * Try to emulate the coprocessor access using the target
-	 * specific table first, and using the global table afterwards.
-	 * If either of the tables contains a handler, handle the
+	 * If the table contains a handler, handle the
 	 * potential register operation in the case of a read and return
 	 * with success.
 	 */
-	if (!emulate_cp(vcpu, &params, target_specific, nr_specific) ||
-	    !emulate_cp(vcpu, &params, global, nr_global)) {
+	if (!emulate_cp(vcpu, &params, global, nr_global)) {
 		/* Split up the value between registers for the read side */
 		if (!params.is_write) {
 			vcpu_set_reg(vcpu, Rt, lower_32_bits(params.regval));
@@ -2326,9 +2321,7 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
  */
 static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 			    const struct sys_reg_desc *global,
-			    size_t nr_global,
-			    const struct sys_reg_desc *target_specific,
-			    size_t nr_specific)
+			    size_t nr_global)
 {
 	struct sys_reg_params params;
 	u32 hsr = kvm_vcpu_get_hsr(vcpu);
@@ -2344,8 +2337,7 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 	params.Op1 = (hsr >> 14) & 0x7;
 	params.Op2 = (hsr >> 17) & 0x7;
 
-	if (!emulate_cp(vcpu, &params, target_specific, nr_specific) ||
-	    !emulate_cp(vcpu, &params, global, nr_global)) {
+	if (!emulate_cp(vcpu, &params, global, nr_global)) {
 		if (!params.is_write)
 			vcpu_set_reg(vcpu, Rt, params.regval);
 		return 1;
@@ -2357,38 +2349,22 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	const struct sys_reg_desc *target_specific;
-	size_t num;
-
-	target_specific = get_target_table(vcpu->arch.target, false, &num);
-	return kvm_handle_cp_64(vcpu,
-				cp15_64_regs, ARRAY_SIZE(cp15_64_regs),
-				target_specific, num);
+	return kvm_handle_cp_64(vcpu, cp15_64_regs, ARRAY_SIZE(cp15_64_regs));
 }
 
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	const struct sys_reg_desc *target_specific;
-	size_t num;
-
-	target_specific = get_target_table(vcpu->arch.target, false, &num);
-	return kvm_handle_cp_32(vcpu,
-				cp15_regs, ARRAY_SIZE(cp15_regs),
-				target_specific, num);
+	return kvm_handle_cp_32(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs));
 }
 
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	return kvm_handle_cp_64(vcpu,
-				cp14_64_regs, ARRAY_SIZE(cp14_64_regs),
-				NULL, 0);
+	return kvm_handle_cp_64(vcpu, cp14_64_regs, ARRAY_SIZE(cp14_64_regs));
 }
 
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	return kvm_handle_cp_32(vcpu,
-				cp14_regs, ARRAY_SIZE(cp14_regs),
-				NULL, 0);
+	return kvm_handle_cp_32(vcpu, cp14_regs, ARRAY_SIZE(cp14_regs));
 }
 
 static bool is_imp_def_sys_reg(struct sys_reg_params *params)
@@ -2400,15 +2376,9 @@ static bool is_imp_def_sys_reg(struct sys_reg_params *params)
 static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *params)
 {
-	size_t num;
-	const struct sys_reg_desc *table, *r;
-
-	table = get_target_table(vcpu->arch.target, true, &num);
+	const struct sys_reg_desc *r;
 
-	/* Search target-specific then generic table. */
-	r = find_reg(params, table, num);
-	if (!r)
-		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
 	if (likely(r)) {
 		perform_access(vcpu, params, r);
@@ -2512,8 +2482,7 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 						    u64 id)
 {
-	size_t num;
-	const struct sys_reg_desc *table, *r;
+	const struct sys_reg_desc *r;
 	struct sys_reg_params params;
 
 	/* We only do sys_reg for now. */
@@ -2523,10 +2492,7 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	if (!index_to_params(id, &params))
 		return NULL;
 
-	table = get_target_table(vcpu->arch.target, true, &num);
-	r = find_reg(&params, table, num);
-	if (!r)
-		r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
 	/* Not saved in the sys_reg array and not otherwise accessible? */
 	if (r && !(r->reg || r->get_user))
@@ -2826,38 +2792,17 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 /* Assumed ordered tables, see kvm_sys_reg_table_init. */
 static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 {
-	const struct sys_reg_desc *i1, *i2, *end1, *end2;
+	const struct sys_reg_desc *i2, *end2;
 	unsigned int total = 0;
-	size_t num;
 	int err;
 
-	/* We check for duplicates here, to allow arch-specific overrides. */
-	i1 = get_target_table(vcpu->arch.target, true, &num);
-	end1 = i1 + num;
 	i2 = sys_reg_descs;
 	end2 = sys_reg_descs + ARRAY_SIZE(sys_reg_descs);
 
-	if (i1 == end1)
-		i1 = NULL;
-
-	BUG_ON(i2 == end2);
-
-	/* Walk carefully, as both tables may refer to the same register. */
-	while (i1 || i2) {
-		int cmp = cmp_sys_reg(i1, i2);
-		/* target-specific overrides generic entry. */
-		if (cmp <= 0)
-			err = walk_one_sys_reg(vcpu, i1, &uind, &total);
-		else
-			err = walk_one_sys_reg(vcpu, i2, &uind, &total);
-
+	while (i2 != end2) {
+		err = walk_one_sys_reg(vcpu, i2++, &uind, &total);
 		if (err)
 			return err;
-
-		if (cmp <= 0 && ++i1 == end1)
-			i1 = NULL;
-		if (cmp >= 0 && ++i2 == end2)
-			i2 = NULL;
 	}
 	return total;
 }
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
