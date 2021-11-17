Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B778C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:50:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0563963212
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:50:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0563963212
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FD5D4A19F;
	Wed, 17 Nov 2021 01:50:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HJzHYvKGixsK; Wed, 17 Nov 2021 01:50:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DDCE4B0EF;
	Wed, 17 Nov 2021 01:50:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 533234A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:50:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iNxuwgAUgkrk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:50:08 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0F6149E5F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:50:07 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 z13-20020a627e0d000000b004a2849e589aso1162167pfc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tq9EsnBDsIULQVxeorKH97JMfxdcU3KwA0yIbRqb8nc=;
 b=Yfc5AyPfrAryp4Ly0NWpHvWkMzvobkI4oVp3ewLCX41K3bjSVjPldr2kYS+ztybCjt
 5AnGjw8annOa4qaveRkzMBLnQpwxpITb5wACIILLFPP2l9bfKYll9XOqxL1IZAcwgqEU
 vhCleY0OFQjLwmop8/zWloUH6byFk+JUA+H2YmwXO0sZbMLIstxFWsRJ8MIpgYqoKQ9y
 45HqmWmuC0xStSdr5Fkp3mxIBc/rGMey5VtzYvSkGP2jAQ9RQDDjXFlFXw60NEMHPRJM
 3vXEJRG1XJpl+8b5kL2rVtzwOqc4Ulx7Q528xcpC/XAExBQYk+yyrJcxLxuOBrZUy1nQ
 5+dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tq9EsnBDsIULQVxeorKH97JMfxdcU3KwA0yIbRqb8nc=;
 b=W+ihLg+tuGsFHBQQ9ogqtgPSvCSVe5BBRwVhuC40sI4AXtrIctOW/sXYXd0ygzb36u
 XhOeHrw0WS3CiISsl8wMRMdlw4bBiYgkmJOdNk+M3xIhPd4iFL/GbJKX2g5SesnWH8zP
 F20V+PPiZO6qquIiZvaTFZbSOMoz/LazFFNaOQmMNM8vg9nS0CV6t28A2t/Yf4aIyXRU
 p0G/RCwy22hNukJLLJDW3TZ1mC9pdJO7p/hYZEGXPhmyNt4R0gcuCouNFiney3SeznG+
 C6Eee4sELEk4LWts4wLM3AGWiNa6Vdd5+UJkpLYmdlhmN8vlceYA7YhRfbMksu0TeULC
 ffcg==
X-Gm-Message-State: AOAM5304/heh6ne5wPuzTTmnZqLMC8hAmxyRLjIqZ3xMDq1cFmlXxFfQ
 WjuK2VpOQ1v0PrL/jsbJ+GtZbKOFOqc=
X-Google-Smtp-Source: ABdhPJyw3+jvRUQTNuXU0Rs/FuDUFQG75ZnH7tR0+PpZD5NxVMfLc/BgVA4P+9YHIUJfIQCNVEBtndUZ0eA=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:9692:b0:143:d9ad:d151 with SMTP id
 n18-20020a170902969200b00143d9add151mr5223500plp.40.1637131807111; Tue, 16
 Nov 2021 22:50:07 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:35 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-6-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 05/29] KVM: arm64: Make ID_AA64PFR1_EL1 writable
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
 arch/arm64/kvm/sys_regs.c       | 44 ++++++++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 597609f26331..b7ad59fd22e2 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -800,6 +800,7 @@
 #define ID_AA64PFR0_ELx_32BIT_64BIT	0x2
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 35400869067a..7dc2b0d41b75 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -433,6 +433,21 @@ static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -464,6 +479,12 @@ static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_aa64pfr1_el1_info(struct id_reg_info *id_reg)
+{
+	if (!system_supports_mte())
+		id_reg->vcpu_limit_val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     const struct id_reg_info *idr)
 {
@@ -478,6 +499,14 @@ static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static u64 get_reset_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *idr)
+{
+	return kvm_has_mte(vcpu->kvm) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE)));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
@@ -487,6 +516,16 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 	.get_reset_val = get_reset_id_aa64pfr0_el1,
 };
 
+static struct id_reg_info id_aa64pfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64PFR1_EL1,
+	.ftr_check_types = U_FCT(ID_AA64PFR1_RASFRAC_SHIFT, FCT_IGNORE) |
+			   U_FCT(ID_AA64PFR1_MPAMFRAC_SHIFT, FCT_IGNORE) |
+			   U_FCT(ID_AA64PFR1_CSV2FRAC_SHIFT, FCT_IGNORE),
+	.init = init_id_aa64pfr1_el1_info,
+	.validate = validate_id_aa64pfr1_el1,
+	.get_reset_val = get_reset_id_aa64pfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -497,6 +536,7 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -1345,10 +1385,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), gic_lim);
 		}
 		break;
-	case SYS_ID_AA64PFR1_EL1:
-		if (!kvm_has_mte(vcpu->kvm))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
