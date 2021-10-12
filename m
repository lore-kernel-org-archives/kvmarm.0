Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A99C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48CEA610A3
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 48CEA610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1EE04B091;
	Tue, 12 Oct 2021 00:36:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aTAWXaqk+w3P; Tue, 12 Oct 2021 00:36:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73BC34B0C5;
	Tue, 12 Oct 2021 00:36:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78A4D4B0A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XG52rpxGz0r3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:30 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F9764B0CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:30 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 p8-20020a17090ab90800b001a094e12f18so3163349pjr.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nTXMtA3D4TOs62yx9xXmosWMy1vxPMYLyf89zj4P3sg=;
 b=DrM5WEJPxxLwrWWTHYAj8Qc4xV1msbr3ZUUIz+Vgg9CThMSACYyczJ1UDERNSK6Ggi
 oQ1MytUagNqi0alUFD2TBfQHxcb/biUjA9kU3iUrAkSkECbDozt/+ZHlOM2vIMgDe9DU
 xnCxdoFjVo+srhzN1SSDvIGsxKNr5p6kS/QEdy9M/mC+bcmA2HauNgHXrv7L/yShq/FW
 9+CVeX4qwbX1/3Vpkveb9m3MH0vBJ1z79pzJh+E/UumcChjyMGgSgu86T5Y5nhHt0Gm/
 YYSE3P8dAWvEZkJPNtplpVhxEpAPiOCT0+snPnaL7fQLiew9mZ19iajPqb9Fb8nQRLcu
 dJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nTXMtA3D4TOs62yx9xXmosWMy1vxPMYLyf89zj4P3sg=;
 b=ApgIgHdZ6DfhBSDx5si4Qw1Qw873a5nHKTvToDcFPvTxS+h9nFK+84cgvids3nVhrX
 XMc6cbueCVqw+r5uNXj7XQa2Wq2xUIIihA6gUHtqalSacJijjzyF5WFCkaRcWwbCzHWA
 tWlowkBop0z4VtdHv9oD8SYQWHJVdEzcku7kkOc5ukjvzsoVhsEQhtnbkzaXSJxMhvth
 gMu6nS22RN3NEmXEszkOMrveYkwjKwazjohZr7RPEPasWnxIFNIw7Zy3M6B+1aswUp+q
 1aKXRQIoVRh1UVtG1RegQ4el1i0UaoQ5kXqS1cFVIhVeQKCXiSyG2kgWAGZUPNjJHACN
 MJSQ==
X-Gm-Message-State: AOAM530YdO+PZP04NWLYEAoHGq/bzJOn9ZqKIak8iiFBLWu4yRmPaHK/
 UTJ8QlZyPae2ICsW5WUkY4gknpiFAEk=
X-Google-Smtp-Source: ABdhPJxUJvThrtjbXZAeg5X6W4utelZnX4+QN62pfB876yK1oZAkUxR/X7DkF7nkuOQxW5rPD2nt286kpBA=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90b:3b44:: with SMTP id
 ot4mr3486235pjb.145.1634013389503; Mon, 11 Oct 2021 21:36:29 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:17 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-8-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 07/25] KVM: arm64: Make ID_AA64PFR1_EL1 writable
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

This patch adds id_reg_info for ID_AA64PFR1_EL1 to make it writable
by userspace.

Return an error if userspace tries to set MTE field of the register
to a value that conflicts with KVM_CAP_ARM_MTE configuration for
the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 arch/arm64/kvm/sys_regs.c       | 51 ++++++++++++++++++++++++++-------
 2 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b268082d67ed..aa0692595122 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -793,6 +793,7 @@
 #define ID_AA64PFR0_ELx_32BIT_64BIT	0x2
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 63eb207b387f..0e4423a81cb9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -314,6 +314,20 @@ static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu, u64 val)
 	return 0;
 }
 
+static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	bool kvm_mte = kvm_has_mte(vcpu->kvm);
+	unsigned int mte;
+
+	mte = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR1_MTE_SHIFT);
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT. */
+	if (kvm_mte ^ (mte > 0))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit;
@@ -341,6 +355,14 @@ static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_aa64pfr1_el1_info(struct id_reg_info *id_reg)
+{
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	id_reg->vcpu_limit_val = (system_supports_mte() ?
+		id_reg->sys_val :
+		(id_reg->sys_val & ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE)));
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     struct id_reg_info *idr)
 {
@@ -349,6 +371,14 @@ static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64PFR0_SVE)));
 }
 
+static u64 get_reset_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+				     struct id_reg_info *idr)
+{
+	return kvm_has_mte(vcpu->kvm) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE)));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.init = init_id_aa64pfr0_el1_info,
@@ -356,6 +386,16 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 	.get_reset_val = get_reset_id_aa64pfr0_el1,
 };
 
+static struct id_reg_info id_aa64pfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64PFR1_EL1,
+	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
+		       ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
+		       ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
+	.init = init_id_aa64pfr1_el1_info,
+	.validate = validate_id_aa64pfr1_el1,
+	.get_reset_val = get_reset_id_aa64pfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -366,6 +406,7 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -1202,16 +1243,6 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
-	case SYS_ID_AA64PFR1_EL1:
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		if (kvm_has_mte(vcpu->kvm)) {
-			u64 pfr, mte;
-
-			pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
-			mte = cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR1_MTE_SHIFT);
-			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), mte);
-		}
-		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
