Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AADBC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD25261078
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DD25261078
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91A194B089;
	Tue, 12 Oct 2021 00:36:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wMuuNNPigw9O; Tue, 12 Oct 2021 00:36:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A77BE4B0D9;
	Tue, 12 Oct 2021 00:36:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB6694048B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6MrSree491BY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:33 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 130054B0B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:33 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 x16-20020a25b910000000b005b6b7f2f91cso26133261ybj.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=pzYVrFzh/ZGEBEeS21xkrtQC5IckuFCKV+U32wAyb5M=;
 b=diOkSIXrqtH7r0bfBGZW7u/LYKDBg+4BjHQcGcA3rV2Gh/2LcXchanV1lcur9ie3oo
 LvDlKk075kJBdq5sh+OWM0i+svTEYp3NyZAMwwh1O44PAEnASPIQDvDfVnGoFBNLiJrt
 Wzv+yVIV/8aHiA4ug04hojX+Ahi7w4EPSilF4lcAFwEkVcAvyL07HFNTwRnPMLEp3tT0
 i7jfjivHk5ylheFbUg2cWF8j3Iar696FO5q2CJpQxkTIMAKcjXh2EehSGcUALv0yFZho
 iYSGIeZNMz4/aynPURq/OqckkdQMi77Dpkq5kqkn1sxFl7Ly1MzWXg7YrmjamT1NXpRD
 ufew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=pzYVrFzh/ZGEBEeS21xkrtQC5IckuFCKV+U32wAyb5M=;
 b=IiojBrLX68HDpDaAqyPMzeg9d6xukij14YlsWKupScqPlNkXlAlHoLfyMbZUdOB91b
 bboOcq58wFaqj89sjYseOu42EFXKDplcY+PSN+yfhU52P1CcoMi6Flkk4S56O/cza4zn
 RuJmdr48j0URqNC2/hr4ad47oREXW3y2GNXFGoW8jLWwAbgO6f4rJw7VRu6UKaD8PaHW
 EJCWiJ4hoI5VgTYUsOgjoGSZqg066b538xxhDELf0ca16/d2PPua4hwfkBJ9N9d/5VMB
 2W4rvguz68TxUyW3R59MCsnunL4ammcApHHQRkxkYoCkexrrfFzc0z+vPlNKvupeFjua
 4PNA==
X-Gm-Message-State: AOAM532KZR5oxyQv1Zm5pnU2KzkQCBosdrR47Y0MV35k6wBnRXmQgZ6e
 3hkY3ZmmEXPfJGrzRYQ9zgcxW7YhDT8=
X-Google-Smtp-Source: ABdhPJzVGAWlMaiSu1gHhA7Qs49UaGPQLo8/PBNvV9kyjNVw7VtUymOyejUZS98k6GvinFn8SKOa3ZtVE5U=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a25:3620:: with SMTP id
 d32mr25907878yba.46.1634013392668; 
 Mon, 11 Oct 2021 21:36:32 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:19 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-10-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 09/25] KVM: arm64: Make ID_AA64ISAR1_EL1 writable
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

This patch adds id_reg_info for ID_AA64ISAR1_EL1 to make it
writable by userspace.

Return an error if userspace tries to set PTRAUTH related fields
of the register to values that conflict with PTRAUTH configuration
for the guest (via KVM_ARM_VCPU_INIT).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 79 +++++++++++++++++++++++++++++++++++----
 1 file changed, 72 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 73b5dad0b2ee..7819a07ee248 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -263,6 +263,24 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+#define PTRAUTH_MASK	(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |	\
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) | \
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |	\
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI))
+
+#define aa64isar1_has_apa(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_APA_SHIFT) >= \
+	 ID_AA64ISAR1_APA_ARCHITECTED)
+#define aa64isar1_has_api(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_API_SHIFT) >= \
+	 ID_AA64ISAR1_API_IMP_DEF)
+#define aa64isar1_has_gpa(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPA_SHIFT) >= \
+	 ID_AA64ISAR1_GPA_ARCHITECTED)
+#define aa64isar1_has_gpi(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
+	 ID_AA64ISAR1_GPI_IMP_DEF)
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -353,6 +371,37 @@ static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu, u64 val)
 	return 0;
 }
 
+static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	unsigned int gpi, gpa, api, apa;
+	bool generic, address;
+	bool vcpu_ptrauth = vcpu_has_ptrauth(vcpu);
+
+	gpi = aa64isar1_has_gpi(val);
+	gpa = aa64isar1_has_gpa(val);
+	api = aa64isar1_has_api(val);
+	apa = aa64isar1_has_apa(val);
+	if ((gpi && gpa) || (api && apa))
+		return -EINVAL;
+
+	generic = gpi || gpa;
+	address = api || apa;
+
+	/*
+	 * Since the current KVM guest implementation works by enabling
+	 * both address/generic pointer authentication features,
+	 * return an error if they conflict.
+	 */
+	if (generic ^ address)
+		return -EPERM;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_ptrauth ^ (generic && address))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit;
@@ -388,6 +437,14 @@ static void init_id_aa64pfr1_el1_info(struct id_reg_info *id_reg)
 		(id_reg->sys_val & ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE)));
 }
 
+static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
+{
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	id_reg->vcpu_limit_val = system_has_full_ptr_auth() ?
+				 id_reg->sys_val :
+				 (id_reg->sys_val & ~PTRAUTH_MASK);
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     struct id_reg_info *idr)
 {
@@ -404,6 +461,13 @@ static u64 get_reset_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE)));
 }
 
+static u64 get_reset_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
+				      struct id_reg_info *idr)
+{
+	return vcpu_has_ptrauth(vcpu) ?
+	       idr->vcpu_limit_val : (idr->vcpu_limit_val & ~PTRAUTH_MASK);
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.init = init_id_aa64pfr0_el1_info,
@@ -426,6 +490,13 @@ static struct id_reg_info id_aa64isar0_el1_info = {
 	.validate = validate_id_aa64isar0_el1,
 };
 
+static struct id_reg_info id_aa64isar1_el1_info = {
+	.sys_reg = SYS_ID_AA64ISAR1_EL1,
+	.init = init_id_aa64isar1_el1_info,
+	.validate = validate_id_aa64isar1_el1,
+	.get_reset_val = get_reset_id_aa64isar1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -438,6 +509,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -1274,13 +1346,6 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
-	case SYS_ID_AA64ISAR1_EL1:
-		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI));
-		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
