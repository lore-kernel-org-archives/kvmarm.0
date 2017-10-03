From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 15/31] KVM: arm64: Move system register helper
 functions around
Date: Mon,  2 Oct 2017 22:10:57 -0500
Message-ID: <1507000273-3735-13-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DC0549D3B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1vkzPwkEJ6bx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:38 -0400 (EDT)
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com
 [209.85.214.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEAA140638
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:35 -0400 (EDT)
Received: by mail-it0-f44.google.com with SMTP id x15so9995865itb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:55 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Jintack Lim <jintack@cs.columbia.edu>

We are about to add a framework to handle system instruction traps. To
reuse existing helper functions, let's move them around.

No functional change.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 89 ++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 395b964..541bb97 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1621,6 +1621,51 @@ static bool access_id_aa64mmfr0_el1(struct kvm_vcpu *v,
 	{ SYS_DESC(SYS_SP_EL2), NULL, reset_special, SP_EL2, 0},
 };
 
+#define reg_to_match_value(x)						\
+	({								\
+		unsigned long val;					\
+		val  = (x)->Op0 << 14;					\
+		val |= (x)->Op1 << 11;					\
+		val |= (x)->CRn << 7;					\
+		val |= (x)->CRm << 3;					\
+		val |= (x)->Op2;					\
+		val;							\
+	 })
+
+static int match_sys_reg(const void *key, const void *elt)
+{
+	const unsigned long pval = (unsigned long)key;
+	const struct sys_reg_desc *r = elt;
+
+	return pval - reg_to_match_value(r);
+}
+
+static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
+					 const struct sys_reg_desc table[],
+					 unsigned int num)
+{
+	unsigned long pval = reg_to_match_value(params);
+
+	return bsearch((void *)pval, table, num, sizeof(table[0]),
+		       match_sys_reg);
+}
+
+static void perform_access(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *params,
+			   const struct sys_reg_desc *r)
+{
+	/*
+	 * Not having an accessor means that we have configured a trap
+	 * that we don't know how to handle. This certainly qualifies
+	 * as a gross bug that should be fixed right away.
+	 */
+	BUG_ON(!r->access);
+
+	/* Skip instruction if instructed so */
+	if (likely(r->access(vcpu, params, r)))
+		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+}
+
 static bool trap_dbgidr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -1968,56 +2013,12 @@ static const struct sys_reg_desc *get_target_table(unsigned target,
 	}
 }
 
-#define reg_to_match_value(x)						\
-	({								\
-		unsigned long val;					\
-		val  = (x)->Op0 << 14;					\
-		val |= (x)->Op1 << 11;					\
-		val |= (x)->CRn << 7;					\
-		val |= (x)->CRm << 3;					\
-		val |= (x)->Op2;					\
-		val;							\
-	 })
-
-static int match_sys_reg(const void *key, const void *elt)
-{
-	const unsigned long pval = (unsigned long)key;
-	const struct sys_reg_desc *r = elt;
-
-	return pval - reg_to_match_value(r);
-}
-
-static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
-					 const struct sys_reg_desc table[],
-					 unsigned int num)
-{
-	unsigned long pval = reg_to_match_value(params);
-
-	return bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
-}
-
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
 
-static void perform_access(struct kvm_vcpu *vcpu,
-			   struct sys_reg_params *params,
-			   const struct sys_reg_desc *r)
-{
-	/*
-	 * Not having an accessor means that we have configured a trap
-	 * that we don't know how to handle. This certainly qualifies
-	 * as a gross bug that should be fixed right away.
-	 */
-	BUG_ON(!r->access);
-
-	/* Skip instruction if instructed so */
-	if (likely(r->access(vcpu, params, r)))
-		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-}
-
 /*
  * emulate_cp --  tries to match a sys_reg access in a handling table, and
  *                call the corresponding trap handler.
-- 
1.9.1
