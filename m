Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A18C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 06:59:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AF9540AEA;
	Mon, 14 Feb 2022 01:59:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZdlKsLKKLBba; Mon, 14 Feb 2022 01:59:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D270140BC0;
	Mon, 14 Feb 2022 01:59:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F30B408A7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bp6XpXrgBAAO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 01:59:20 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD9C340307
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:19 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 l9-20020a170903120900b0014a4205ebe3so5775825plh.11
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 22:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nFKWm08/SB0d1ggvgDB8huKOebJguFEKlgavW3DhhV4=;
 b=SOWCDC49txblCKM7OcSGkDgPljb9jONYJiHVoeUuZ56PTzt2rs3EFqAWPpqr+nGeA2
 gkrUnT4xd5S3SJ2gluMqYUAUse6VME5NQ8dyIXWFn47qUH6MiNcFiQ7BiV6qRmf/vmyK
 e/R7NaRt+xXPMCQMJoJb7JEOWaR7iLQKGr2dp3eEN0cmECwg1LX322YmJIPhW0Jmapmn
 qolXdtQFRvX2akhBM3XpoSqBAeyMFFrjI4AiIi1Zd85cQ1zHNLI48OGPDUGpbYGRVfS9
 T5NWsskLzyDzORA/maWh797SmjqRSzGErm/95RKIFSiideKmVoIQ7SmdQ6j6ZJ6Tn4u/
 Hd6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nFKWm08/SB0d1ggvgDB8huKOebJguFEKlgavW3DhhV4=;
 b=m18c3C+H0TnruTYlR33l89vvqCrks0YG3RLTEaJSEwnLbL74TOGs0eZ1phnncyx2nW
 PTAjU8fRC5n/TIzOcDtEvdpVADRwciQM9JVWa95zp6Pfjrk6/+dwxzhwgifmcIdMec77
 ezM87dLCYU5LmtbzClBvAe7wwKUweYMvaNhPK8KxuNLJnRY+iCKbX7xDM/zr+fb2q14f
 ny9B4/WkRlObOsGofkapdwXVgRLi8FEBXDYDgMTjemw5b11MTa6E6v7XIwtL0YONhwZP
 06DKAAroFrjEWnuqDU56KMHaup+kSlbf9vM/SmJ1W/oLEYkoDuZQlrB4+til1nMh/B4T
 oZ5w==
X-Gm-Message-State: AOAM533Htj/RkQW/2ooOEuQp0rHG/bYFGqpaCS0AETdvTiZcXkOrjnb0
 ypnlXQnAbUOkHgMWgbq7gsQ0Ez8ySjk=
X-Google-Smtp-Source: ABdhPJx2Ec/+nsYcWA84TY73qEpvM2PGqi5gbUk1tbJNdJx+hg4p8r62EcMY+Q+HnKZCTC5AQjivum7e1yM=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1514:: with SMTP id
 q20mr13246603pfu.82.1644821958877; Sun, 13 Feb 2022 22:59:18 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:24 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-6-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 05/27] KVM: arm64: Make ID_AA64PFR1_EL1 writable
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
Skip fractional feature fields validation at present and they will
be handled by the following patches.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 arch/arm64/kvm/sys_regs.c       | 42 +++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index bfdf32ff5985..b7fb26f5a8f8 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -816,6 +816,7 @@
 #define ID_AA64PFR0_GIC3		0x1
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 14df7c112e57..b41e9662736d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -372,6 +372,21 @@ static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_info *id_reg, u64 val)
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
 	u64 limit = id_reg->vcpu_limit_val;
@@ -403,12 +418,24 @@ static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_aa64pfr1_el1_info(struct id_reg_info *id_reg)
+{
+	if (!system_supports_mte())
+		id_reg->vcpu_limit_val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
+}
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
 					 const struct id_reg_info *idr)
 {
 	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
 }
 
+static u64 vcpu_mask_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu,
+					 const struct id_reg_info *idr)
+{
+	return kvm_has_mte(vcpu->kvm) ? 0 : (ARM64_FEATURE_MASK(ID_AA64PFR1_MTE));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC),
@@ -417,6 +444,16 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
 };
 
+static struct id_reg_info id_aa64pfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64PFR1_EL1,
+	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
+		       ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
+		       ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
+	.init = init_id_aa64pfr1_el1_info,
+	.validate = validate_id_aa64pfr1_el1,
+	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -427,6 +464,7 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
@@ -1351,10 +1389,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
 
 	switch (id) {
-	case SYS_ID_AA64PFR1_EL1:
-		if (!kvm_has_mte(vcpu->kvm))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
