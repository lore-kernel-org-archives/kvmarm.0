Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52657C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:48:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0984343479;
	Thu, 10 Mar 2022 23:48:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MGqcalvPVH5Y; Thu, 10 Mar 2022 23:48:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18D1A49EAA;
	Thu, 10 Mar 2022 23:48:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F22D540CF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OdHxbr5UJDGg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:48:50 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D612A410FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:48 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 z13-20020a1709027e8d00b001518de7a06cso3915001pla.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uoX+Y+G6xoHPXp4kqnfSVmpfMNJMZgMHDhyE0auL83Q=;
 b=YNltLUs0JQ2gFkvqzjAXUoHgAi9ZfaLM/L+GHykWnnLtUkQPfLjXODJYzEL9TwOD6t
 KT525jlPQqr6DC8/EAKJleLT4RIABEucKJ5u44URo1HHUaVsuoJY+jybtXEexOHuofJ6
 wCj0ICOlApK+2jJbRNw4N3p1WM8pFyr4Ubpf6Pt8qMqU0jlcXMYsJZjx35tteE0y5NUY
 qnS6lOa6QbzS4qN2M5utqKhbabagUFrSOdlffYrSdoPd8AZqgRpu5tPA0ERglZjeaJ5R
 1E63LdOlRt9IhJ41HAwVfOJRFHL9oVsIcfQZg6j8+/BIPZmoEh1N4r0YC/zkS2bMai5t
 aVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uoX+Y+G6xoHPXp4kqnfSVmpfMNJMZgMHDhyE0auL83Q=;
 b=j9SUvTPsCAaf9gY67fidypLIIYSMijwDfvfPUpPQhJcBvHqJwlOkyr+jQ/Pp2shX8s
 XrMFgTOINRjhZtuwV/XAxXkjOWe7hv7qOG4HH8J6If+Pk6aXL1c47NEg0cZfwV9mbOKv
 zBariqgai7jy4IiLal8fLpnsRm2d5z4hEpS0UAtHlNm3zEzWSTl6RmPw+uEFsq737axD
 iUpi2nboQOvK/B0w/Wq5+7VovDhTAQF8YVgTCeCr5G+plL4yb0SkLPODcPDIATN50YAh
 PTm2OnXahOxmhGarUKxX6uZzeq4Aide+q9EwdzF/RZ7LvBcT0oHAYEgQik73hKZoVtUY
 J8Gg==
X-Gm-Message-State: AOAM532pRSFtGxEBXZSBZBZ9EOT97ee/qbitfzoUdLy4khkLKJKhqqix
 Xub3YA3DU8h0smxDF8MRyqKL0+UHDe0=
X-Google-Smtp-Source: ABdhPJzlEs8FIbA8U2Dis881SY2f6s+kkp+46U11VGjc7k6FSU9t7G0DvVjrYGujHVyxJSa56LXMGJhejwU=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1a47:b0:4e1:5bc7:840d with SMTP id
 h7-20020a056a001a4700b004e15bc7840dmr8455437pfv.10.1646974127983; Thu, 10 Mar
 2022 20:48:47 -0800 (PST)
Date: Thu, 10 Mar 2022 20:47:56 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-11-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 10/25] KVM: arm64: Make MVFR1_EL1 writable
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

This patch adds id_reg_desc for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 46d95626f4d5..45d22b9e0d40 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -632,6 +632,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu,
+			      const struct id_reg_desc *id_reg, u64 val)
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
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -3474,6 +3504,11 @@ static struct id_reg_desc id_dfr0_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_dfr0_el1,
 };
 
+static struct id_reg_desc mvfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(MVFR1_EL1),
+	.validate = validate_mvfr1_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3482,6 +3517,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=1 */
 	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
 
+	/* CRm=3 */
+	ID_DESC(MVFR1_EL1, &mvfr1_el1_desc),
+
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
