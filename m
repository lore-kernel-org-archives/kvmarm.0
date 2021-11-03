Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2CB9C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C09661175
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9C09661175
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 455804B0F1;
	Wed,  3 Nov 2021 02:28:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PwlskkZllYab; Wed,  3 Nov 2021 02:28:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3C14B188;
	Wed,  3 Nov 2021 02:28:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D00A04B1B0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bg4lOTtU6Toq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:38 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1DD24B1B6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:36 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 k9-20020a170902c40900b001421e921ccaso159665plk.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BX4KfiOrqcyrws1uL0O/L9kuIJ9ad1jF0+cPWSoKuUE=;
 b=Cq+Ej5Dj1LWD30hdNkPSEz0exbwNZnXqqPulw8Gmqzc7LR4lC1jHqktbHVxfhABplQ
 R9YrjUB/wF/5c0X663TPQAoEyOgm2s8MaUCPKA//pe+hdhCLIELWB9f+c9MePXEfkwwW
 S8xGsHcZfNSrlUrYoq6iTdvI/MQQWKbzxBHM6OKfL4DXiEjS+klxjDQ17u8YAMZ4cVP2
 eiuRKwsTRikzUj11zQXxroBCJhKZccdC9rinDOvLf0fMqGJuRQcPqsdJ4iIfKBUMsgbH
 N/tn/NDfYP5FFFbw+eq2fsqG/DGZb//M8atMntiHRDwqK81M/PBJJDc+T+kczg87BNrG
 wnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BX4KfiOrqcyrws1uL0O/L9kuIJ9ad1jF0+cPWSoKuUE=;
 b=BpoR7uLddYP/2bFHwX9DWA81Y4n5QSmgzTI5bDzmIIsmDPdF+Ztwz2E6BW7XNJObLI
 88hlx7ZdE+L0GAePaoPWUF0dUwBzs6r3ddrBhrmANMe623vFf1epZN72DuVyaCB7XGRT
 tX3UwaF7QZ0lfmT3fyYQoD2gg4IgXXdUriiJVpklUAPODxqCiWeUP9yAws1SYE+NfWjc
 2TDqnKmzeStP9pyKdrNsK6zYI73QAn92lOrFjTzUmldx33OwQtzzy+DqLawL/64QZiXn
 Em+S/5G1kTq0faT3blxIOYhKbfSiA+aKllgPGs8ki0aWGXzmlpXmZTxYkrCMKplT7Sxc
 zetw==
X-Gm-Message-State: AOAM5315i7WbdNbKszehfnHIL1n52PDT4jl953wg7mCYxWgFDS1jYADl
 LQ9n0rIog3jd5VhpE0ctG/B4G82Cc1Q=
X-Google-Smtp-Source: ABdhPJzuUEYjbQ+VthWhEtBAz70l7/XdAP5N4DRm0ePAhD1+zGjxBUKsgIracOcC41SAcK82UPr9qsMgAzE=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:a5c2:b0:140:14bb:8efd with SMTP id
 t2-20020a170902a5c200b0014014bb8efdmr36677073plq.31.1635920916024; Tue, 02
 Nov 2021 23:28:36 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:17 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-26-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 25/28] KVM: arm64: Trap disabled features of
 ID_AA64MMFR1_EL1
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

Add feature_config_ctrl for LORegions, which is indicated in
ID_AA64MMFR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Change trap_loregion() to use vcpu_feature_is_available()
to simplify checking of the feature's availability.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 67f56ff08e41..2d2263abac90 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -467,6 +467,17 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
 	.cfg_val = MDCR_EL2_TTRF,
 };
 
+/* For ID_AA64MMFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_lor = {
+	.ftr_reg = SYS_ID_AA64MMFR1_EL1,
+	.ftr_shift = ID_AA64MMFR1_LOR_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = HCR_TLOR,
+	.cfg_val = HCR_TLOR,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -968,6 +979,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	},
 };
 
+static struct id_reg_info id_aa64mmfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64MMFR1_EL1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_lor,
+		NULL,
+	},
+};
+
 static struct id_reg_info id_dfr0_el1_info = {
 	.sys_reg = SYS_ID_DFR0_EL1,
 	.init = init_id_dfr0_el1_info,
@@ -1010,6 +1029,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -1104,10 +1124,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
