From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/3] KVM: ARM64: Fix guest dead loop when register accessor
 returns false
Date: Wed, 13 Jan 2016 11:02:54 +0000
Message-ID: <56962EDE.9070106@arm.com>
References: <1452676601-14796-1-git-send-email-zhaoshenglong@huawei.com>
 <1452676601-14796-4-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23EB549B0A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 05:58:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zx+aNzgT47d8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2016 05:58:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BBB649B06
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 05:58:51 -0500 (EST)
In-Reply-To: <1452676601-14796-4-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 13/01/16 09:16, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Currently emulate_cp will return 0 (Handled) no matter what the accessor
> returns. If register accessor returns false, it will not skip current PC
> while emulate_cp return handled. Then guest will stuck in a dead loop.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4048934..2e90371 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1007,10 +1007,9 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
>  		if (likely(r->access(vcpu, params, r))) {
>  			/* Skip instruction, since it was emulated */
>  			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> +			/* Handled */
> +			return 0;
>  		}
> -
> -		/* Handled */
> -		return 0;
>  	}
>  
>  	/* Not handled */
> 

Good catch again, but I'd rather approach this in a way that is similar
to the patch I posted last year, unifying some of the paths between
the 32 and 64 accesses (the code paths are really pointlessly different).

I have the below patch, fully untested. What we could also do would be
to take your patch as a fix, and then consider refactoring the beast...

Thoughts?

	M.


>From b9bd3074ef1d4c569aa3e6ce880afe297f262b1d Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Mon, 21 Dec 2015 13:14:38 +0000
Subject: [PATCH] arm64: KVM: Refactor system register access

System register access handling is pointlessly different between
32 and 64bit guests, leading to some subtle bugs.

This patch makes most of the table parsing and accessor calling
common, and uses a stricter convention for the return value.

Reported-by: Shannon Zhao <shannon.zhao@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 84 ++++++++++++++++++++---------------------------
 1 file changed, 35 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d2650e8..5f0bbc9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -973,19 +973,20 @@ int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
 }
 
 /*
- * emulate_cp --  tries to match a sys_reg access in a handling table, and
- *                call the corresponding trap handler.
+ * access_sys_reg --  tries to match a sys_reg access in a handling table,
+ *                    and call the corresponding trap handler.
  *
  * @params: pointer to the descriptor of the access
  * @table: array of trap descriptors
  * @num: size of the trap descriptor array
  *
- * Return 0 if the access has been handled, and -1 if not.
+ * Returns 1 if the access succeded, 0 if it didn't, and -1 on
+ * failure.
  */
-static int emulate_cp(struct kvm_vcpu *vcpu,
-		      struct sys_reg_params *params,
-		      const struct sys_reg_desc *table,
-		      size_t num)
+static int access_sys_reg(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *params,
+			  const struct sys_reg_desc *table,
+			  size_t num)
 {
 	const struct sys_reg_desc *r;
 
@@ -994,26 +995,22 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
 
 	r = find_reg(params, table, num);
 
-	if (r) {
-		/*
-		 * Not having an accessor means that we have
-		 * configured a trap that we don't know how to
-		 * handle. This certainly qualifies as a gross bug
-		 * that should be fixed right away.
-		 */
-		BUG_ON(!r->access);
-
-		if (likely(r->access(vcpu, params, r))) {
-			/* Skip instruction, since it was emulated */
-			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-		}
+	if (unlikely(!r))
+		return -1;
 
-		/* Handled */
-		return 0;
+	/*
+	 * Not having an accessor means that we have configured a trap
+	 * that we don't know how to handle. This certainly qualifies
+	 * as a gross bug that should be fixed right away.
+	 */
+	BUG_ON(!r->access);
+
+	if (likely(r->access(vcpu, params, r))) {
+		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+		return 1;
 	}
 
-	/* Not handled */
-	return -1;
+	return 0;
 }
 
 static void unhandled_cp_access(struct kvm_vcpu *vcpu,
@@ -1076,9 +1073,9 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 		params.regval |= vcpu_get_reg(vcpu, Rt2) << 32;
 	}
 
-	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
+	if (access_sys_reg(vcpu, &params, target_specific, nr_specific) == 1)
 		goto out;
-	if (!emulate_cp(vcpu, &params, global, nr_global))
+	if (access_sys_reg(vcpu, &params, global, nr_global) == 1)
 		goto out;
 
 	unhandled_cp_access(vcpu, &params);
@@ -1118,8 +1115,8 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 	params.Op1 = (hsr >> 14) & 0x7;
 	params.Op2 = (hsr >> 17) & 0x7;
 
-	if (!emulate_cp(vcpu, &params, target_specific, nr_specific) ||
-	    !emulate_cp(vcpu, &params, global, nr_global)) {
+	if (access_sys_reg(vcpu, &params, target_specific, nr_specific) == 1 ||
+	    access_sys_reg(vcpu, &params, global, nr_global) == 1) {
 		if (!params.is_write)
 			vcpu_set_reg(vcpu, Rt, params.regval);
 		return 1;
@@ -1169,31 +1166,20 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *params)
 {
 	size_t num;
-	const struct sys_reg_desc *table, *r;
+	const struct sys_reg_desc *table;
+	int ret;
 
 	table = get_target_table(vcpu->arch.target, true, &num);
 
 	/* Search target-specific then generic table. */
-	r = find_reg(params, table, num);
-	if (!r)
-		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
-
-	if (likely(r)) {
-		/*
-		 * Not having an accessor means that we have
-		 * configured a trap that we don't know how to
-		 * handle. This certainly qualifies as a gross bug
-		 * that should be fixed right away.
-		 */
-		BUG_ON(!r->access);
-
-		if (likely(r->access(vcpu, params, r))) {
-			/* Skip instruction, since it was emulated */
-			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-			return 1;
-		}
-		/* If access function fails, it should complain. */
-	} else {
+	ret = access_sys_reg(vcpu, params, table, num);
+	if (ret == -1)
+		ret = access_sys_reg(vcpu, params,
+				     sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	if (ret == 1)
+		return 1;
+
+	if (ret == -1) {
 		kvm_err("Unsupported guest sys_reg access at: %lx\n",
 			*vcpu_pc(vcpu));
 		print_sys_reg_instr(params);
-- 
2.1.4

-- 
Jazz is not dead. It just smells funny...
