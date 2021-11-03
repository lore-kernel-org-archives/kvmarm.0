Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCBAC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8AB3A60240
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8AB3A60240
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A2654B1B6;
	Wed,  3 Nov 2021 02:28:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GtM5jcS0lEdg; Wed,  3 Nov 2021 02:28:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B3454B1CF;
	Wed,  3 Nov 2021 02:28:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E46E74B152
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9yeq21qFg0Tk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:38 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7598B4B16F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:38 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 m74-20020a633f4d000000b0029fed7e61f9so999187pga.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Ep2NTeFQHRtb1x7tniQeG2pd+DzpIaqpLIGDyxGNaak=;
 b=fFT02gdqViWYrbCdTEQFZh2dd8gF3sRFDKawTgXYqjLI7nmc2vVWIHc5fQYX9NKzEd
 OrN0S2OhP0OEbUusgLIOJ24ho/2alYvcos4x7SolFhapIn6YxL0Q/VDzjpdSyamRXq5s
 RrMyR8gjtsL8vUcd0lgvbJ6rN2iAQkzAgkFYvLsnRwgoEAjFhXUV3qEsGRMH+1yMZEsW
 29uITSD/EwfM2NeAOOpPDlb7zlKc6xEPzSf2xyfOc7+pQtJPKZvN+WxtlnnDnD9b2L8D
 LRn27uaxX+R+rYFbVrWjFF0aBcTVeCPiqJg9ZhuOt107MpCcOF6wgHso+ZYIQoYbVD/j
 HDkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Ep2NTeFQHRtb1x7tniQeG2pd+DzpIaqpLIGDyxGNaak=;
 b=siXBz3w5BP5S89XZ6WzpkA5VvJZYBfFGTlHGG6be6TYEg/kNgVntUt7LtKVwfIqvzn
 muDrjxBhnUVdLPQAcEXKT7PzROdlpv/4uVEQIsGCXeopkN6mfxLBOB0ONoYqJcgi3bxs
 aOVT5zs47HGoM+GXlggK1dRHqk2T4ydaGB9io/vPiCc7RMskEsKHY6m/QyCR07+hJBRO
 0r/h/fpGaAAu8Kct6T2YUXNVHMkErDK6CfHi6FdGf2/r0k3IPzeJYF2kKGc1HOnkzFxn
 pH/b4ZgWwvBU7dEDrGkb3CUy2LFkl4pcvRVsvHTY1rcNkCi1XFrupQeH7cLIHXIKFaWC
 BLKQ==
X-Gm-Message-State: AOAM533NxLaOw/rcsIjhwtKgyisClL5AIsjSygRMyFpIepO+Lr4G08GJ
 Wl5JUtFreamEROL74vsKM2mt7AOKooE=
X-Google-Smtp-Source: ABdhPJxq8mVjnPJ20WpU44gAZn9NtxzZ4+sWrLWZuqNplD2biJyP84pZy1BiGUiTUN9ebm+egsfYYdatDyg=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:24c:b0:13f:2377:ef3a with SMTP id
 j12-20020a170903024c00b0013f2377ef3amr36514167plh.59.1635920917622; Tue, 02
 Nov 2021 23:28:37 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:18 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-27-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 26/28] KVM: arm64: Trap disabled features of
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
index 2d2263abac90..fd38b3574864 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -374,6 +374,30 @@ static int arm64_check_features(u64 check_types, u64 val, u64 lim)
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
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64ISAR1_EL1));
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
@@ -478,6 +502,14 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
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
@@ -953,6 +985,10 @@ static struct id_reg_info id_aa64isar1_el1_info = {
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
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
