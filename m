Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF045C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76BBD619F6
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 76BBD619F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CB6F4B156;
	Wed, 17 Nov 2021 01:53:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UsKawgkEB0kG; Wed, 17 Nov 2021 01:53:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DE234B15E;
	Wed, 17 Nov 2021 01:53:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9323A4B1AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eBEsdarcVmbm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:52 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4AA64B1B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:50 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 184-20020a6217c1000000b0049f9aad0040so1090827pfx.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=l9cL+44fLGdDyYUFjHlYq+dL32isCwZtQcuWO6mBjWA=;
 b=o36k6i54cI44CkxNoyng06/1cnBbAHYmtiCr8v2I/KDJLlWFA9DKoh2o8QlHJ4ioDR
 ZBxEhJYYuxUj3CTLSPaVa+LdwzJtLW5vmimI7ZyOL/v2EdkMBv8s7Zb8aNQg1qDNc1Ji
 0DxExQLqbrEaTySPkb4iHM10iwaD6drKdifBiW/5Im3Zz2e/K9hPnXG1khJlse+zcZfe
 e1gO5CpHsd0NA0rBCs8UNOzB5v4100BqKNd+PqC7I11geGCXteo1kcbBCX3QdXqmulGu
 Uet1f3rbkcNvy1NTGYTYO05MVb+WFisTpVESqHDn9yTzGcCfcX+q2hF+HlQKq8DvKfbW
 rToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=l9cL+44fLGdDyYUFjHlYq+dL32isCwZtQcuWO6mBjWA=;
 b=c+Rbpa1ED+8WsnLJ/HDghBnK5LBXlVWNSSbQP0WzalbKV86q6z4dJen3GaPLXhSCIp
 DWumb0n5NId4gtuPwGKJd0ncy74I5+lK8EB8dBlIw8cqoLpares5S5Dt6vv3/EXuh4vs
 vvpGtCY8nw0kOrA/f0AYHXhvNM8Zl+deM/uHtftNN0R7EBATkiIPK/oU3aB3PChnMm1/
 kaUc08VYNgKVE599gkyigPZGFS1c353PScBVoTJnj8eWPBBwldnVOHjH/nWmty2Liy66
 iMs+eKdcEVn4xJIB+6Brwr2cfL6RIcuwnQrrfXsZJo+NsJfyU/U6ybA3b7Ii9UssIPZm
 f2+A==
X-Gm-Message-State: AOAM532d/M5/Ti30croOZJT3YZlbjzB2VojwUcMZpgUfNTkQ0Sg8HlB9
 SKfYMMqg1VxyevDcDuM+unNw/O35s0Q=
X-Google-Smtp-Source: ABdhPJx9DDeQMUXc6095SOTfgNA0s7/GlZiDRs9vbKaSt1H48YgTnr7zDO2ifTxH2Q2Olse8b10fDPjrRfI=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:df97:: with SMTP id
 p23mr6831251pjv.3.1637132029846; Tue, 16 Nov 2021 22:53:49 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:56 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-27-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 26/29] KVM: arm64: Trap disabled features of
 ID_AA64ISAR1_EL1
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

Add feature_config_ctrl for PTRAUTH, which is indicated in
ID_AA64ISAR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3d3b29515b8b..f1f975ce7b07 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -376,6 +376,30 @@ static int arm64_check_features(u64 check_types, u64 val, u64 lim)
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+/*
+ * Return true if ptrauth needs to be trapped.
+ * (i.e. if ptrauth is supported on the host but not exposed to the guest)
+ */
+static bool vcpu_need_trap_ptrauth(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+	bool generic, address;
+
+	if (!system_has_full_ptr_auth())
+		/* The feature is not supported. */
+		return false;
+
+	val = __read_id_reg(vcpu, SYS_ID_AA64ISAR1_EL1);
+	generic = aa64isar1_has_gpi(val) || aa64isar1_has_gpa(val);
+	address = aa64isar1_has_api(val) || aa64isar1_has_apa(val);
+	if (generic && address)
+		/* The feature is available. */
+		return false;
+
+	/* The feature is supported but hidden. */
+	return true;
+}
+
 enum vcpu_config_reg {
 	VCPU_HCR_EL2 = 1,
 	VCPU_MDCR_EL2,
@@ -480,6 +504,14 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.cfg_val = HCR_TLOR,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = (HCR_API | HCR_APK),
+	.cfg_val = 0,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -977,6 +1009,10 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.init = init_id_aa64isar1_el1_info,
 	.validate = validate_id_aa64isar1_el1,
 	.get_reset_val = get_reset_id_aa64isar1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64mmfr0_el1_info = {
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
