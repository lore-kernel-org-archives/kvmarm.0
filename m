Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F120C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0782D61177
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0782D61177
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6DAB4B0F1;
	Wed,  3 Nov 2021 02:28:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r17r4PrnUAoi; Wed,  3 Nov 2021 02:28:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45CF84B16F;
	Wed,  3 Nov 2021 02:28:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B48C64B163
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LATXOtL8BHzZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:21 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B7044B152
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:20 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 m26-20020a62a21a000000b0041361973ba7so821792pff.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=23B18KCm6Ef3G7/a/geAU0JJefv7D3zT1xrTavh52uo=;
 b=TJOFxqE5MKgPy2BU7Sw3QhOpxRNeKudKuKKjMFP3BxR4yJKXV8O2GszJPdJTLi914P
 3EWI/MTTzLwFoyVxXun5bBW7w7PjeHiXcT/pOhLcMtKZ3Y/vFU176tZ+yj+mmZg4N4KP
 1HZ55D9w2iPe0tawLlbshFprqWovMHF+a/i7ubcg966vwylt5un5aydqLaKKfcfKfYvD
 42K9dSyaMigT3QRT+Kf8hG0iHhZwIWNwP+SEbcbQ6ABkJZOEK1rpqEtklhSuteaYdMXI
 Wk11L8P8IC9oVFXJ/zcnmiMKqrRK2XN2+qJtrycqxmeXbPofqNkPOvGzBByVFvni9hem
 N92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=23B18KCm6Ef3G7/a/geAU0JJefv7D3zT1xrTavh52uo=;
 b=MCmN8ZqiZE5P/EKjcu9DYVuId0YtAebD8xM1FGgYyd+BbhcsUiiVgb38dUhUyapkJ5
 JWwzNPqCRceUJ19FeOAgOKdiVW290fqFiWOtc0fGjRm7JsNbV/VQXRk+vtJd3jP+dbiW
 QQv/bEtXhJHfa4VcUUDnYtO2u2ObOTry+Qgmwd6/1lTI4vq15g5szYMeHhKJVOInAhHA
 2meHmNgmrdKNbgf3RjRMqzaQ0/bqTg7MFLEsAdbyOOq9m6aROAADypI9dYeuqghPe1fg
 ifvvi2quq9hCFnq/+KmdZSPhzCplpaZbCT3PU3rI714frQ9m/DW2WYgiWY/2KIkTiE8T
 elQQ==
X-Gm-Message-State: AOAM530sXgpP4rKeBEw0dIDZrWRmFEuCjKSZeJ7eh+0XB9MuPF9xGPGB
 hr3yvcEXZ2U2DMyFkHuQzwlqVO/aSvA=
X-Google-Smtp-Source: ABdhPJx0JzpdmVa2hGMrf0I8g1N0qU+cSRr0gP5gtA+oqT2tR+iwo2LuP4bq6crb6rDwpf/AuaG6Vsn/aSU=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:6b0c:b0:13f:aaf4:3db4 with SMTP id
 o12-20020a1709026b0c00b0013faaf43db4mr36190330plk.46.1635920899378; Tue, 02
 Nov 2021 23:28:19 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:07 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-16-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 15/28] KVM: arm64: Make MVFR1_EL1 writable
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
index cfa3624ee081..99dc2d622df2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -675,6 +675,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -846,6 +876,11 @@ static struct id_reg_info id_mmfr0_el1_info = {
 			   S_FCT(ID_MMFR0_OUTERSHR_SHIFT, FCT_LOWER_SAFE),
 };
 
+static struct id_reg_info mvfr1_el1_info = {
+	.sys_reg = SYS_MVFR1_EL1,
+	.validate = validate_mvfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -857,6 +892,7 @@ static struct id_reg_info id_mmfr0_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_MMFR0_EL1)] = &id_mmfr0_el1_info,
+	[IDREG_IDX(SYS_MVFR1_EL1)] = &mvfr1_el1_info,
 	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
