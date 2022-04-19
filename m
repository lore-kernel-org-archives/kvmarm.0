Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBEEC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77A694B1D2;
	Tue, 19 Apr 2022 02:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SIwhq7GOOsH1; Tue, 19 Apr 2022 02:57:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BDD14B1F2;
	Tue, 19 Apr 2022 02:57:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81DED4B1D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3mobbFj6LajD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:19 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36B0E4B1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:19 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 i36-20020a25b224000000b006420453d37aso9636754ybj.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=F9GVjgg0f4Eemfa1MtjY71p4mXhfcLBZ4BAQg8wg5XY=;
 b=X+pobMbVaGwgu5LTnSwRAhxIsSPT3tTWzl4eEAhJdrVtMOSpFKA4Ke42asU/3dvssI
 381enhjh7yPijf8pAlX+aqtsdIj0duWitAwAoy42KcoMXeMZTmkNw4w9t3jtqUELlT7n
 vtJIM8CFxZuqkSv+/d7hpVxYopPx34tb94wNS19mvpV0aVTYCUiO3Ji7bfQgxyj1Zq+M
 Xxzajz4UsXketmCrnsvZkfgkOdXdgsp1xQ5NNW2ko6f9U22L3NeQx7cwF22PipUE8l1u
 bR7YuhvhEH5FAdYOx3Z4CTFCXbfRgfY96WHeJlj5IHlUeGIzTLqXst1wNQH5GsLfwIQL
 exfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=F9GVjgg0f4Eemfa1MtjY71p4mXhfcLBZ4BAQg8wg5XY=;
 b=uEJs2q2oU3jZGMlki3AsMX/UlC/BZmCh8fK5zHqWrnyJblOl5SBQGkAxuHsVgwxoGJ
 SF+wFsWX86t5C9YG6UW93X4QfEcOK3L4kn/9IX0yHM0SG+h6W4oV+FFU7j6YEl/N9QRh
 th6V7wFZ1VM/yGMFm1CHDTW8CNJV5t6esxBep1QHFR01hLguYC3A/7JLwn/uHEvE6gDP
 II5mBsEpKBJXOdm96t0Ey+/9GoY0fduPPLJt+9L4kx2ZdWkCsR5LjE5dkfH+1UQq9y3U
 fvIUD0rW4lN8YhQvCGfs9x8qqdQTGSClszJVGC7vbU4CpCIaTs6Nbazqc0oYGcIgYQJm
 KQmQ==
X-Gm-Message-State: AOAM532HIXD9ciXTvrkCrszgOw3PCvf+lhiXrvAdIYO6v7wn8JKnjPBu
 P+JHhDZAGynrB44Xa/RmHz/IMXtMcf0=
X-Google-Smtp-Source: ABdhPJyKCFDKA+Kv2LJacZJZ+S367HCU69wGD+6+X9uBwvbwrCQWpjBQK8XUhugss+g+U3Xwz9Iz0thLwQE=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:e050:0:b0:645:3723:f52d with SMTP id
 x77-20020a25e050000000b006453723f52dmr2116304ybg.144.1650351438821; Mon, 18
 Apr 2022 23:57:18 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:14 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-9-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 08/38] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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

This patch adds id_reg_desc for ID_AA64ISAR0_EL1 to make it writable
by userspace.

Updating sm3, sm4, sha1, sha2 and sha3 fields are allowed only
if values of those fields follow Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c3537cd4fe58..c01038cbdb31 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -425,6 +425,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_desc *id_reg, u64 val)
+{
+	unsigned int sm3, sm4, sha1, sha2, sha3;
+
+	/* Run consistency checkings according to Arm ARM */
+	sm3 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM3_SHIFT);
+	sm4 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM4_SHIFT);
+	if (sm3 != sm4)
+		return -EINVAL;
+
+	sha1 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA1_SHIFT);
+	sha2 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA2_SHIFT);
+	if ((sha1 == 0) ^ (sha2 == 0))
+		return -EINVAL;
+
+	sha3 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA3_SHIFT);
+	if (((sha2 == 2) ^ (sha3 == 1)) || (!sha1 && sha3))
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -3256,6 +3279,11 @@ static struct id_reg_desc id_aa64pfr1_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
 };
 
+static struct id_reg_desc id_aa64isar0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64ISAR0_EL1),
+	.validate = validate_id_aa64isar0_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3264,6 +3292,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
+
+	/* CRm=6 */
+	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
