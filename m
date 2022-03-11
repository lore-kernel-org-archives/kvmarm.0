Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B6EC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:48:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E5BD49EC2;
	Thu, 10 Mar 2022 23:48:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WXlUkjrI2JPp; Thu, 10 Mar 2022 23:48:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4344549EE4;
	Thu, 10 Mar 2022 23:48:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B2834966F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EN1uml-4oQCh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:48:43 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04BA443479
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:42 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 j9-20020a170903024900b0015195e68490so3903598plh.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=i1Q8oMVcIDawwcpspY0YFzmCHnlNLuWjVrH+1Iwojj8=;
 b=jVLOPO1C6Ge6K9MG6QbzCVTmnGDbg8jZOD1sL0KvfQwDeSvvbXuCxHIh9stqZKw7o7
 m0BVY3IxNn55nzY/Tq9XLu/IiOng74LRlvqo6E6T1rr/98gS9IDg8BpcnCjATjov5so9
 PtUgvUnGTNwMTLRZG1vo1oh9KTI7T9CSS/aHcKZjuFkCJ9JZVO64cqoNqredM66vA/hu
 LDihsicff+dxFB7+dRK10RK6CIvs3oKpyaKUMhvuJF+tGg1wBRtAiAjJsXrcLaiqZLXy
 E+wRlPN8J8Sn7I3xE/U1ZPoYGH5asekcZGHH0u4dk9Xg3hj2WMXVj+HaHl48qqjp7Abo
 0pWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=i1Q8oMVcIDawwcpspY0YFzmCHnlNLuWjVrH+1Iwojj8=;
 b=i/BK/DQPtMLD4EEMdwACvSlAMBcNiiWtbgRQMDka+EInQ4aiASGqU4vBGZnzRrGU8s
 faQfyGx+EeFxilwz7TyeK3uo2sdDxVDbuxnE+sQoPtimv/9Hvfn6RZY8E+sOP960H9Wf
 jUlbmCEpNfdGgDEiQaUiUxwPtwb823msfcbyS4RX3QnDLelWXJ+hHv1sW3pwSJF+xkiR
 w0wJcz+NPhQT5cNqmYfDbYaOyDVOkXvnZbH9jziSQQKXnQ1f8mJTlpNiCDPZRNkQjFuI
 J15/Pv9n65CiYyc2v1XNTbK1HxGnnTDSxR/WrFQVxq1BaFthyVcCIM0OjcS6junQOLNr
 mikQ==
X-Gm-Message-State: AOAM533iQHrvpZMg4RZDy91cf8EH11rXrxlESsmAkw9fsU1AJjaIxTwU
 wz/UUih7yZjR/bIDqxUx8PsNcnr7o9E=
X-Google-Smtp-Source: ABdhPJyqzZBFBrLfDZqJ/MEY5oQH2n+E2ImHCp7e6LaNBlZdtcnXcxrMItVl9Ayaa8AX1b+4PjFrf3CrT4s=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:11c7:b0:151:7290:ccc with SMTP id
 q7-20020a17090311c700b0015172900cccmr8717277plh.95.1646974121195; Thu, 10 Mar
 2022 20:48:41 -0800 (PST)
Date: Thu, 10 Mar 2022 20:47:52 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-7-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 06/25] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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
index 4294dbfd8fd4..378777238c68 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -389,6 +389,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
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
@@ -3167,6 +3190,11 @@ static struct id_reg_desc id_aa64pfr1_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
 };
 
+static struct id_reg_desc id_aa64isar0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64ISAR0_EL1),
+	.validate = validate_id_aa64isar0_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3175,6 +3203,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
+
+	/* CRm=6 */
+	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
