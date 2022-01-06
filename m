Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FC1C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:28:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA7A840BBF;
	Wed,  5 Jan 2022 23:28:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K9jAcVWjxDZI; Wed,  5 Jan 2022 23:28:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1DDE49F17;
	Wed,  5 Jan 2022 23:28:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D939449E1A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w+DZoXZ9GZ-H for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:38 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DFCB40BBF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:38 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 b4-20020a17090a6e0400b001b179d36a57so3991957pjk.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qd73lKkEwp4pXgOEovTQqkO4qsQJst+kertasctVO0I=;
 b=htuin5WXm7Rrpou/vBLh0txyP8bbdWdjvGAzpt7dGMTaglBii2BAZRNBcTX4/Sx8zw
 BIaEGmC1AaCc7yM2qbyOC3yW3tRYi7/kBwck/5l+nu0uL6n3LGm0ATjW3tTCrfGI4yij
 /q8BhmPS+QF9KY5ml3EZ4179v13mJK3hQkiYWa1LDLgjhgwCWt0U17JxUVEd9086z2kL
 43YP5SuMRB2kvm5wFwGb1aErOAF08R4qEzTi8TWWytolOVLKRt2pz5yDN9x7aqXEzERZ
 ABpg4yqgt9gAmvxW+GJ05wFv6hJvDSz9cVt+fL6VgNkvRvzLxUoBH5pCmNmU0jmlaQCO
 5fOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qd73lKkEwp4pXgOEovTQqkO4qsQJst+kertasctVO0I=;
 b=kBqvZRLNEAT8mS77nd6nHRXWutGosZwSVExnNlcLe+AkMfmy02PdDwCybpbUzcWwBu
 L5U/Um3A0kiRkMaFSh50XBE9KsDINRfsKPO35eZiGTlNZv8WFPS4P2cTN76LDLtLUTew
 of4axU3xWwg5aVkCChhvL0HXXCGIhKxLW5JjThHi9HhjWFvMd5zK6QvE19eHu/wqgjSe
 sxGHQuoFCmghiO9uBXIUrf6vfvh06hXv9P6KzynZlYnqxpvXEfUMNkdd8gkEDT0vy6Fp
 Ocoj40hg+yBfeNCZZFftxbJv+Wztk9cu2D5pHWKJ5H0Tu9ftUuBfuyVg8/0DZI6uBjiX
 mAwA==
X-Gm-Message-State: AOAM532cHQdg1iekPTmJbRTAIhPa50mtz5IbC/ZkImXF14AtOsocM4WD
 +GRVFILYNsZjKqJxOasxeEkV6j9YzMw=
X-Google-Smtp-Source: ABdhPJxuGlf1H5nhDbfEXwbJ81sUGxMyi6/4UT0GpUOgBmgL39/uLHiDysLu3tr0d7MZS7QmSmZsev2JGRc=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:2444:b0:149:2f0f:e466 with SMTP id
 l4-20020a170903244400b001492f0fe466mr56984109pls.145.1641443317545; Wed, 05
 Jan 2022 20:28:37 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:47 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-6-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 05/26] KVM: arm64: Make ID_AA64PFR1_EL1 writable
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
index e26027817171..f55513002281 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -801,6 +801,7 @@
 #define ID_AA64PFR0_GIC3		0x1
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1eb5c5fb614f..ae9ca341a2e4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -359,6 +359,21 @@ static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -390,12 +405,24 @@ static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
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
@@ -404,6 +431,16 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
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
@@ -414,6 +451,7 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
@@ -1331,10 +1369,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
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
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
