Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9595FC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A41661039
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3A41661039
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D431A4A531;
	Tue, 12 Oct 2021 00:36:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J2zeqQDkpA8u; Tue, 12 Oct 2021 00:36:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0CD34B0AC;
	Tue, 12 Oct 2021 00:36:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7917D4048B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Vr8zA-8MSVe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:22 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6234F402A9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:22 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b197-20020a2534ce000000b005b71a4e189eso26115450yba.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Z93DnbmChJRf3NM+LBnf4mN1DuMUD7rE5aIVZuW+HL0=;
 b=PtmrX72/0sGKpcnwJcLOf/UaKOFDQ+5S9S3IlXTMv7zJdIXpUksHL2ftiSNgSk+z4k
 QOVclAU5P4X9Hn/pdysFT9NVb9xUfiDDVUgHRpOzN5LQ0JSb/wOCRbJJLEiYyco6fVbu
 0dct7uPkpb+K55Tzg9Gfo7gpLDvfMVS9w3HYEaFzgieo2h7wFwYVqKhDi16h4WNF0HM6
 sw460YgYVjor3ULd0thxbX/NpQjjrrRfhAtzLlaJ779WGCI1aVuC8OWNxBREIKeEHjkR
 hXo2+jdZnTNhicSObQee3qNLC3uIHFMl5aYoQu/ZDSiFcrcch4+zkqs/q77gbV5eKKfe
 Lvew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Z93DnbmChJRf3NM+LBnf4mN1DuMUD7rE5aIVZuW+HL0=;
 b=5sdYpEsRd8ycn35At6RiotuTHeQQV3smW1eIZ+cvg/lCyDBbs4hN+c8Pdmm+WWxUgu
 dWMZ9voOW/1g0Z9BQ7/bDkFRvcA/9qM63S3jS6NJ8RDBkQ1mC9PqjrJZY7C1+B3dU38N
 lSYUNZwDGXujWlCBSknxY/5Y6ekOfY1BrrA0MJK1T77qiMfgmKGh6bb10RG8TShcbWwv
 F/7iS9waMgI6PuKpxVIBKSaRtb6VtM1mBNCOZyW+OnWsE5/Y60KZpqmMnPV2CYzIbYAH
 FzaAdDWZ4KCts3wWPf2JjXtwtGOXskVYVDMpyYUS2FAJbvU+InyfBGk6r84BgGnVlTMN
 MBiQ==
X-Gm-Message-State: AOAM5302wRlqhlEdeCaB7JkLC6PSmBnD3LPq61/Yd8Uy/ii+DfN9oRFU
 GPu7AmPfCxaZyWYiKWJjNGDTrU1WiYA=
X-Google-Smtp-Source: ABdhPJyItztYg/nGIOk04Hx9xUnOSJKLgu2KzOyCL+f/o2RFo4gV8CWyqEUbibEQ2BnxvEaZPLTO7gz/xB8=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a25:2e01:: with SMTP id
 u1mr17924282ybu.363.1634013381864; 
 Mon, 11 Oct 2021 21:36:21 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:12 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-3-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 02/25] KVM: arm64: Save ID registers' sanitized value per
 vCPU
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

Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
registers' sanitized value in the array for the vCPU at the first
vCPU reset. Use the saved ones when ID registers are read by
userspace (via KVM_GET_ONE_REG) or the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
 arch/arm64/kvm/sys_regs.c         | 26 ++++++++++++++++++--------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9b5e7a3b6011..0cd351099adf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -145,6 +145,14 @@ struct kvm_vcpu_fault_info {
 	u64 disr_el1;		/* Deferred [SError] Status Register */
 };
 
+/*
+ * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
+ * where 0<=crm<8, 0<=op2<8.
+ */
+#define KVM_ARM_ID_REG_MAX_NUM 64
+#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
+#define IDREG_SYS_IDX(id)	(ID_REG_BASE + IDREG_IDX(id))
+
 enum vcpu_sysreg {
 	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 	MPIDR_EL1,	/* MultiProcessor Affinity Register */
@@ -209,6 +217,8 @@ enum vcpu_sysreg {
 	CNTP_CVAL_EL0,
 	CNTP_CTL_EL0,
 
+	ID_REG_BASE,
+	ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
 	/* Memory Tagging Extension registers */
 	RGSR_EL1,	/* Random Allocation Tag Seed Register */
 	GCR_EL1,	/* Tag Control Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..72ca518e7944 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -273,7 +273,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
@@ -1059,12 +1059,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = reg_to_encoding(r);
-	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
+	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -1174,6 +1173,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
+{
+	u32 id = reg_to_encoding(rd);
+
+	if (vcpu_has_reset_once(vcpu))
+		return;
+
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
+}
+
 static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       const struct kvm_one_reg *reg, void __user *uaddr)
@@ -1219,9 +1228,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 /*
  * cpufeature ID register user accessors
  *
- * For now, these registers are immutable for userspace, so no values
- * are stored, and for set_id_reg() we don't allow the effective value
- * to be changed.
+ * We don't allow the effective value to be changed.
  */
 static int __get_id_reg(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1375,6 +1382,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
 	.access	= access_id_reg,		\
+	.reset	= reset_id_reg,			\
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
@@ -1830,8 +1838,10 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = __vcpu_sys_reg(vcpu,
+					 IDREG_SYS_IDX(SYS_ID_AA64DFR0_EL1));
+		u64 pfr = __vcpu_sys_reg(vcpu,
+					 IDREG_SYS_IDX(SYS_ID_AA64PFR0_EL1));
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
