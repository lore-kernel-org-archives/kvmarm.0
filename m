Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134C5C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 06:59:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAB1949E27;
	Mon, 14 Feb 2022 01:59:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q-LUeUXM42Ax; Mon, 14 Feb 2022 01:59:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8722C4087B;
	Mon, 14 Feb 2022 01:59:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F4D408A7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NGZDNvmOM0o7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 01:59:50 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E36E40BC0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:50 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 p7-20020a1709026b8700b0014a8d8fbf6fso5743363plk.23
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 22:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Brz6Y3j0MZViYAVMVNSgTmSSQnU2BlZWdtLqRqNaGsU=;
 b=Zu/UInFm39+Vm/bojUEccM94nZ9lA0DMX2QsEIaUyNi8fhkgvXbwYgWeczj5b+togF
 OMZJQ6q0qT+ld4tcgGrXQqv4ToFMTZ2Y9L/bIMZGz6WCDzumtbAA6qh+dQhCaKD8U1Fc
 cUTF8pUdBeTFJgl/6rtcjojOSrcXYXYnlWZF9OiwZE8qdd9uihGFSmBUwXW+YpTykR0w
 do5vJatra5x1BNWBA02xXjlt/ghW9hNKqzsVg8YLdRuoEMKUWLmDdsNZUnR7NvAdwQlt
 +kQLPlttHiIFiijR9O85L0qGSS2/OsSZMNIuhy5no5X7OsBRsee+pRBI0k8KPonH4m0z
 QRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Brz6Y3j0MZViYAVMVNSgTmSSQnU2BlZWdtLqRqNaGsU=;
 b=CWH/9xI9UmmBV6zM+0ffi248u5G5UzRGnkSuF/engxOl5D+/WTrxKtLj7/tzDc8OWF
 jzbs6443KOzdI9YWEgxrWEIk2y3gFgp5CRpdBQihT0EcK5PyyekSnjnbcMinq/f5XsSS
 FGjPUDy8xc1ykbIK6tdl9Z43e7bMRMu6C1FWQdIjtEn4eQbNsRbKjnD7aGGIUUjw+EZZ
 XLaCsoQVEKBXAuU7fKEjx6/ee1RUvb4yHISe4kTffRhgNZvN7d9cJT/XgWLrzYVssfkk
 QTDrmELGFC5D02FJ5P907gB3jVxs0CQFIp74Egv4YBXJ6LxelqkLqMX0LE9Pgiv3MVHI
 V8kQ==
X-Gm-Message-State: AOAM531JoG3yMi4eWyYQbxo777gGGq2fjQVnR2MdzHKEl5yRTm1/tfCP
 omcQQ5Hog1NFQ+ajLq+T1YtP6cjw9JA=
X-Google-Smtp-Source: ABdhPJwWwbe9hH9AKFYWngQ18eSzKL4vUbmfnE2yQiNzgqPynQfz0rkiJhzI+TM01pY5PO5th91tCagghrU=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:894:: with SMTP id
 q20mr12856682pfj.79.1644821989848; Sun, 13 Feb 2022 22:59:49 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:28 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-10-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 09/27] KVM: arm64: Make ID_AA64MMFR1_EL1 writable
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

This patch adds id_reg_info for ID_AA64MMFR1_EL1 to make it
writable by userspace.

Hardware update of Access flag and/or Dirty state in translation
table needs to be disabled for the guest to let userspace set
ID_AA64MMFR1_EL1.HAFDBS field to a lower value. It requires trapping
the guest's accessing TCR_EL1, which KVM doesn't always do (in order
to trap it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which
also traps many other virtual memory control registers).
So, userspace won't be allowed to modify the value of the HAFDBS field.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4ed15ae7f160..1c137f8c236f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -570,6 +570,30 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64mmfr1_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *id_reg, u64 val)
+{
+	u64 limit = id_reg->vcpu_limit_val;
+	unsigned int hafdbs, lim_hafdbs;
+
+	hafdbs = cpuid_feature_extract_unsigned_field(val, ID_AA64MMFR1_HADBS_SHIFT);
+	lim_hafdbs = cpuid_feature_extract_unsigned_field(limit, ID_AA64MMFR1_HADBS_SHIFT);
+
+	/*
+	 * Don't allow userspace to modify the value of HAFDBS.
+	 * Hardware update of Access flag and/or Dirty state in translation
+	 * table needs to be disabled for the guest to let userspace set
+	 * HAFDBS field to a lower value. It requires trapping the guest's
+	 * accessing TCR_EL1, which KVM doesn't always do (in order to trap
+	 * it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which also
+	 * traps many other virtual memory control registers).
+	 */
+	if (hafdbs != lim_hafdbs)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -675,6 +699,11 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
 	.validate = validate_id_aa64mmfr0_el1,
 };
 
+static struct id_reg_info id_aa64mmfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64MMFR1_EL1,
+	.validate = validate_id_aa64mmfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -689,6 +718,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
