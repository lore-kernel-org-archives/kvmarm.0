Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03AEC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:00:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A366404FA;
	Mon, 14 Feb 2022 02:00:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cFibe3fni0yZ; Mon, 14 Feb 2022 02:00:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 306B740AEA;
	Mon, 14 Feb 2022 02:00:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 591D9404B2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:00:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bxKv2Grb3oyr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:00:31 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0C45402DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:00:30 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 v14-20020a170902e8ce00b0014b48e8e498so5782866plg.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=bOvKI1kPCaNNGWhIjOWMoR69tGeqR4WLISP2Q7llMqI=;
 b=csOB7hi1VBA/oFDOyjQMZYQFqlg8l/OnmxylmJhek12832NT8JhFn5Phv7C6mUHwbp
 AKruxmYtN8nVv4ced2ng2XspMYt/cavaRDSE9kd8AsUuTGyjGmcIqUzihAgLo9HcDuB6
 BKZZ4iza/sROO2ChnPsyCtEyqhIstwciWY1Bs1iz9w93e+WCzWDG9+wgT9g3NrJi2m5o
 2mXJwZC6t+JxapfS4ExaBSlUMRQEj9sBcrQlQl75AxtlYa/XH9WUCCSZVc9vt/uzSogG
 YSlwNIZ0jXx8QSNce60sNbxG5PzHlTEWVEqjb7+D4psXrlSiEDExSYtKX1EolSUDlfmc
 EYWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=bOvKI1kPCaNNGWhIjOWMoR69tGeqR4WLISP2Q7llMqI=;
 b=dMfsYa6Uxm3XbgY1gkTuw2mqYuUEREslwypNWULZlF4M5QcO4M9Ev74uWP5JnVZczo
 UuNZoTugAVz/p4kGzgzfjnzIJun8s+M4FX0XZF76bwN6uzCvh8EwE+4GqvmSaMxYntyb
 12FhmmNmsqb7PCGArLHXOA9md4i0Wj2xrFl2Ymek92R8pjSuri0s+V5WcrR4ARS9d/Tz
 eW5Cw9fal3cIJaQLR97/pvKlWorycnueRFr8tUfoMXbVIeD4c2/rYZWlEgSbYyTcebpm
 OD6W1x75je34YsJBfDUjN6VQYs3NN/DN2JUEFw/m8ZkRok06mxb1Dvs+Rcu5yjz2N24a
 SdDg==
X-Gm-Message-State: AOAM5321Qy2gphgn65HNUJTBGh1n/k9MWiY/A57Xum1hfvjg9zS1G7iG
 Dq7Qd72V9p2I8GNQ8CE/0/h37CffTSk=
X-Google-Smtp-Source: ABdhPJx0j283c3uteG5vU/Wm7GzzzV9S4GvLk6zEMwainkGx3b9r3oXjbaFonEE5MPqvOlYgJbXjZ0p1T3E=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:aa7:9ad0:: with SMTP id
 x16mr12998774pfp.55.1644822030158; 
 Sun, 13 Feb 2022 23:00:30 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:32 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-14-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 13/27] KVM: arm64: Make MVFR1_EL1 writable
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

This patch adds id_reg_info for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 90e6a85d4e31..fea7b49018b2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -654,6 +654,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu,
+			      const struct id_reg_info *id_reg, u64 val)
+{
+	unsigned int fphp, simdhp;
+	struct fphp_simdhp {
+		unsigned int fphp;
+		unsigned int simdhp;
+	};
+	/* Permitted fphp/simdhp value combinations according to Arm ARM */
+	struct fphp_simdhp valid_fphp_simdhp[3] = {{0, 0}, {2, 1}, {3, 2}};
+	int i;
+	bool is_valid_fphp_simdhp = false;
+
+	fphp = cpuid_feature_extract_unsigned_field(val, MVFR1_FPHP_SHIFT);
+	simdhp = cpuid_feature_extract_unsigned_field(val, MVFR1_SIMDHP_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(valid_fphp_simdhp); i++) {
+		if (valid_fphp_simdhp[i].fphp == fphp &&
+		    valid_fphp_simdhp[i].simdhp == simdhp) {
+			is_valid_fphp_simdhp = true;
+			break;
+		}
+	}
+
+	if (!is_valid_fphp_simdhp)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -816,6 +846,11 @@ static struct id_reg_info id_dfr0_el1_info = {
 	.vcpu_mask = vcpu_mask_id_dfr0_el1,
 };
 
+static struct id_reg_info mvfr1_el1_info = {
+	.sys_reg = SYS_MVFR1_EL1,
+	.validate = validate_mvfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -826,6 +861,7 @@ static struct id_reg_info id_dfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_MVFR1_EL1)] = &mvfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
