Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2812C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8901D610A3
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8901D610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DD044B08A;
	Tue, 12 Oct 2021 00:36:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K0Lug1PEAC3d; Tue, 12 Oct 2021 00:36:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 889224B0D0;
	Tue, 12 Oct 2021 00:36:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B584B091
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P90ooEgDDHB9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:33 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B1FE4B0A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:32 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 pg13-20020a17090b1e0d00b001a094e26d51so1239689pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YN5X7g7A0IcM/p+7vsiMHZtNXVKHJ9chV2Lsbk7C1zQ=;
 b=D9t2oSmy3ndrP6bG2CsMouv9WCLzBGAUEH9kU9GDfWruie5xcB4VWV5N3fdKM04NQT
 y7exLiVXuZ5lFdKYyePdLkoPo8cn1KqjXXh2Bzo6fXPw7dt8Teh9e+XAsRniQxTFH2mj
 myl0tm3EG6VL6ui4G3GvrZAcc0a+CQ2Lu67tFDcHuFdPNLPfR4C+BiNq81g4Lrip9dW3
 /BhRDqpetIQC6EqPlJuNc5GtsRceGBjoNScBNh8IPSRwQe1/D9hxC0nPlBkscc4lwz/O
 B48K0R37H4tPXUoiS6eIn0jXuDnOjMxP4kD4HyUDRMZT8H/DCqAyH7zyrmvQK/CheTFN
 IfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YN5X7g7A0IcM/p+7vsiMHZtNXVKHJ9chV2Lsbk7C1zQ=;
 b=WGCyo0bR84WA54FeVDepFKYVK+9E3VX3lJhHXGAxwYwle6A0wSLxFXckE3qTf3sV0m
 8AKLbIiatxlVcY0fzcC0KzAbJizPuEmS56PsmU3AMHTpdH015vVDI7meJyvIMN+Dnqhc
 JsiPHREyD6peDa/awQEcObolnJVKlgcPJcHLmz6YuDUP9IzneqsuMPLefV0sVZPHtoXq
 AOgaeER1vYgRMimPNWQ8xn+iBbvv4iJ2KXQi5x1J2ZbWoX+A9ZvDkE6FNC3xqX2ZGlpQ
 NXjZdRbuASjriN9Fj911b5MoIpcQPxXVzqg86EvhJT3sTTapIJ7yiIY6SbOVi83jOfaS
 0XQw==
X-Gm-Message-State: AOAM5321uigrTrV0PlUdKuETpWlNiwsaWMLgiXcyP/nYmqvfSMstXOiM
 Cbv1GMLiVzbMV54a6CPt8VEUA+HZBfs=
X-Google-Smtp-Source: ABdhPJx7SjSGAN6iiMVQeGbe49tKa2HXO9o45gNjMgaiwIrwZeu4H15V70apGcoFeW+OXBwcRgRJdrHYH/Q=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90a:3ee4:: with SMTP id
 k91mr295558pjc.1.1634013390825; Mon, 11 Oct 2021 21:36:30 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:18 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-9-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 08/25] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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
 arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0e4423a81cb9..73b5dad0b2ee 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -328,6 +328,31 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu, u64 val)
 	return 0;
 }
 
+static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	unsigned int sm3, sm4, sha1, sha2, sha3;
+
+	/* Run consistency checkings according to Arm ARM */
+	sm3 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM3_SHIFT);
+	sm4 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM4_SHIFT);
+	if (sm3 != sm4)
+		return -EINVAL;
+
+	sha1 = cpuid_feature_extract_unsigned_field(val,
+						    ID_AA64ISAR0_SHA1_SHIFT);
+	sha2 = cpuid_feature_extract_unsigned_field(val,
+						    ID_AA64ISAR0_SHA2_SHIFT);
+	if ((sha1 == 0) ^ (sha2 == 0))
+		return -EINVAL;
+
+	sha3 = cpuid_feature_extract_unsigned_field(val,
+						    ID_AA64ISAR0_SHA3_SHIFT);
+	if (((sha2 == 2) ^ (sha3 == 1)) || (!sha1 && sha3))
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit;
@@ -396,6 +421,11 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
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
@@ -407,6 +437,7 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
