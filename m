Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA73C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C63BA61177
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C63BA61177
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 669194B091;
	Wed,  3 Nov 2021 02:28:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h39VepskupNl; Wed,  3 Nov 2021 02:28:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 498224B11C;
	Wed,  3 Nov 2021 02:28:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3AFA4B091
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bOHuSUNdgaem for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:07 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 111FD4B090
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:07 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 n9-20020a170902968900b0013f23b51142so673979plp.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Gm7mR1LOrJBKTHxCMeDmedILqwUP3OMytAls+H/S7bU=;
 b=jPsuNnbg/QU+2caiIez8a8TyHTUk/yd+DEx9LtczN9tZprd+9kHOPY+WTAVfiBJ6ai
 kzBH3B3/w81JPllA73p+RDDa3TzrwdZNZYBVr/PPQyq/vNmLLXGPSIL8P1NBu7lWCoa0
 dHDK9bbyO4r5QKxFc1pDDfOlPFaJhX0E0UqNp8fIB8i5SivMPXLJwe/lRK2WPY/qy32P
 BWUjNgmK+s8JOKv2bWAfhQZyTR1T0KE2eBP1NbGgRNZ/VWdEq7tGTvlA82xdbD8NTibE
 7BsUZ7muTN/zFD1beM9hgHFZSw6BLJbETIzDlZDPiNkgkYQzNccXc5H9Dq8FNK8l41XY
 bUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Gm7mR1LOrJBKTHxCMeDmedILqwUP3OMytAls+H/S7bU=;
 b=5sH9DkWpVyHy/JgYntDXWbcoDvJDMczNSNE0uZV7zqmiaKq/ajL1P8OOZmOTINbhNY
 LYT4OA5Kvy520+wH0z8eR9t4h2nqEO3BJ26tF7OYoxVgYMRDJX0BSdrC73+SQP6PCeIl
 lVngPcG9ooX2ZzUilq696SHvEluT28IkOnzUwo9DtNnpuS1kVocS3GDGDsA2/9q5Qdog
 AGl1HArtyO46uvlJjqzpWelgWbJy+MZwUuH6lZISfLwMb5lCieIJf+lSJYNOHl4AgLkS
 bOQ5trCYjYy7mz3Wmoqwnisb1/mQnys2Ae7N7bzrpZR4RMLJXCFvh7klY9nxzv3hA5bk
 WXjQ==
X-Gm-Message-State: AOAM531Eo6abVE2QQCebamzqjf4y0dn4dJuNHHwDU8iQnr3iRktWSmvn
 jMvDhTM39smYsHSdy1BAaJjjPtvtu7E=
X-Google-Smtp-Source: ABdhPJx4iUpI5oPSkMfBiiSHZTrxt3jDZPbO9Y5vkrpaP5+G0KSWuasdv0FcSGbk6TmKos+QwAbRI+dV8AU=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:ab8c:b0:13a:22d1:88d with SMTP id
 f12-20020a170902ab8c00b0013a22d1088dmr36282740plr.33.1635920886142; Tue, 02
 Nov 2021 23:28:06 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:24:59 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-8-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 07/28] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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

This patch adds id_reg_info for ID_AA64ISAR0_EL1 to make it writable
by userspace.

Updating sm3, sm4, sha1, sha2 and sha3 fields are allowed only
if values of those fields follow Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 00ebf4dfc4f8..7f505853b569 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -437,6 +437,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *id_reg, u64 val)
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
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -502,6 +525,11 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
 };
 
+static struct id_reg_info id_aa64isar0_el1_info = {
+	.sys_reg = SYS_ID_AA64ISAR0_EL1,
+	.validate = validate_id_aa64isar0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -513,6 +541,7 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
