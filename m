Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD96C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 06:59:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 624E5408A7;
	Mon, 14 Feb 2022 01:59:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9iwEWi2hu7T9; Mon, 14 Feb 2022 01:59:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 048E540BC1;
	Mon, 14 Feb 2022 01:59:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CAB440AEA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VXZqn1xwgAAi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 01:59:30 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C02F7408A7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:30 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 62-20020a17090a09c400b001b80b0742b0so10287064pjo.8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 22:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=M/a/Vc/shmJJLkjZEVBmniQlBoL+OJyInbuc84cKOVo=;
 b=oHiVtTsoFuP7yxvyHQnSpouOUcn7G4EYC+Ud3GVI/+GZOlUg97m7sK+ac0e7acp21k
 br/kA9rY0/54R62sM2+J6XotY6GpkxYuJsq96VMGi2rokSONE9v65Nk0WLHRhgqQ+kkz
 j6XS69iblworG4svJ04iUpjYT8hYS4RSKesB+K2856MWjkpvigJyP0bOMW1mo2gcJBrl
 5Qj4dZUhifjRold70IjyqXd944ao9fLKeVarR4PxB6/a47gB3xqndq4YcD3bYKqjmNBf
 ktzk+MGTgVt6OZbt1a0wY1KSoLsOl64r7hw+BPjxAIQ1OfkQjvNbPcsoT3XoxHuKUeDq
 31Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=M/a/Vc/shmJJLkjZEVBmniQlBoL+OJyInbuc84cKOVo=;
 b=1EtmORA0MKEjvCalhAZOSvQ8SLZo9UrxeO3fo3LSwHvQxRd39Zm0JUBWM0hL00bnh4
 2tGEKLVTm4XOD8vwqGsgD1EByk0gKTfaiGBMroiamh2pqvc9fhukk19eF+dhyCi4Wa3J
 Juy5a2CJT2BKwNdyB2kfZWFT7Y2h9oePPSXumFGiGAfRU2G/85zr0nXaElgfqEsw96ca
 Vuh38TaBTaGXmh7/1eTH2znOH8DPld1Ec1/NZRnoG90HpuLJF/dZgtuIflu/WzZ9vVDM
 BnlYbxPASpUkrUADw7HmbHdL7aiMD/qJo27N4739zxzVpkGkC2msEQHTKfjqH1IrDNyg
 MXcw==
X-Gm-Message-State: AOAM531R+ojrgVDYt/ziGp+c0zRccQRqjrNwC16jVUjBspudtXGtnu7s
 vfvHYASyxF/E2TegXCuU4EtOmtabzWs=
X-Google-Smtp-Source: ABdhPJwsfhL7pM3Pz0k0600RZWcFVmJjjZYx2f1pfIZDVbRupYBHsW6Obk+gUclfejqilFnthPKptjfIvSo=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4c8e:: with SMTP id
 my14mr1640298pjb.0.1644821969667; Sun, 13 Feb 2022 22:59:29 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:25 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-7-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 06/27] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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
index b41e9662736d..eb2ae03cbf54 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -387,6 +387,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
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
@@ -454,6 +477,11 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
 };
 
+static struct id_reg_info id_aa64isar0_el1_info = {
+	.sys_reg = SYS_ID_AA64ISAR0_EL1,
+	.validate = validate_id_aa64isar0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -465,6 +493,7 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
