Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB42C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 07:42:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF5449ED4;
	Tue, 22 Mar 2022 03:42:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T1oBvJoaDDW3; Tue, 22 Mar 2022 03:42:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6E7F49ED6;
	Tue, 22 Mar 2022 03:42:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A01349ED4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 03:42:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ArzPs8Xhpjcg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 03:42:38 -0400 (EDT)
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com
 [209.85.166.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B967449ED3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 03:42:38 -0400 (EDT)
Received: by mail-io1-f54.google.com with SMTP id k25so19223280iok.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 00:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rHrnAaz5t76UG2JwgEvwPleGU0MvRMDMpxjoGYiF+CQ=;
 b=AqNqTzOP6nOh+P8EhP5YaQVXwSpBaB4EOZgmXMB0voLFwbLZUI7NgJbtOZQlaeY6Nz
 gVqNg3sl4QnKntKarOFgu/rZPofdwCq26OzT8CyuxJygAsmIGcv6V/SGCoaKagPsk6Wp
 9yE7Gc4gVL9dAO7/BST/RG+q306x2Qe/kwi4SDDP30yrio0KgPodEbHKzMacVWho7kta
 J2HGFOb+tZM1fJRBadYLB3E+O07sN1tBk4U1gSTjwCelgE0p5yzO3x10KX4tbLCJvQru
 yrFJ2+a88cR2VFFoBEIs8CA+owPGwCuypJiT50r1aYNtyOfk+XmyvCD/sU0Xu8bLaFTF
 4vPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rHrnAaz5t76UG2JwgEvwPleGU0MvRMDMpxjoGYiF+CQ=;
 b=GGHER6Igq5wAKKYGHktVEhxC8lfjLhz3aS76kXsJXtyt5+SoBrdSQxW2VpriP8pLV7
 Yih4vih+mM+CmT7nUE+jxnWpwtm2RTNAY7uAj/Vv7V9HM/2GCM/xp3plWMaTWNXuM4CM
 CGvJRQB0ckeT0CgQBunTOggOWKJF1/rNkncr7Ze3ZhizoVR7lm+w1n6oFJ1cgxrFnuXO
 pWLxf8Q7Xxd/kyFkMSWPYFxobSHfThCMWU0CVN+V7135gz2Gd3tCaotgUI5qLyeHqE6z
 YY5m3cl2gwovW6KiCgzRyxOkJdSfOalnWSeum0YaKla/YWJ3wqeMPUMltf41/CqxejOt
 XsPw==
X-Gm-Message-State: AOAM531x0518v1bcg4a0Mew9ku1P3X2APk1ierlGtwu/Wl4NIYcyBzuX
 mE5SAWJa3YLLyodWFrG7D3SwYA==
X-Google-Smtp-Source: ABdhPJxdEupF10MGveiVRreMiqsEJc59sTLObwFckWBLfHJmNdEDcg4GwP43G51CHlniwAF+42ZCBw==
X-Received: by 2002:a05:6638:2195:b0:31a:8815:f0c0 with SMTP id
 s21-20020a056638219500b0031a8815f0c0mr8418816jaj.301.1647934957686; 
 Tue, 22 Mar 2022 00:42:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 f2-20020a056e020b4200b002c805b9b4c4sm6259885ilu.16.2022.03.22.00.42.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Mar 2022 00:42:36 -0700 (PDT)
Date: Tue, 22 Mar 2022 07:42:33 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v6 01/25] KVM: arm64: Introduce a validation function for
 an ID register
Message-ID: <Yjl96UQ7lUovKBWD@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-2-reijiw@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Jy922konoFvWkL0i"
Content-Disposition: inline
In-Reply-To: <20220311044811.1980336-2-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--Jy922konoFvWkL0i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Reiji,

On Thu, Mar 10, 2022 at 08:47:47PM -0800, Reiji Watanabe wrote:
> Introduce arm64_check_features(), which does a basic validity checking
> of an ID register value against the register's limit value, which is
> generally the host's sanitized value.
> 
> This function will be used by the following patches to check if an ID
> register value that userspace tries to set for a guest can be supported
> on the host.
> 
> The validation is done using arm64_ftr_bits_kvm, which is created from
> arm64_ftr_regs, with some entries overwritten by entries from
> arm64_ftr_bits_kvm_override.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

I have some concerns regarding the API between cpufeature and KVM that's
being proposed here. It would appear that we are adding some of KVM's
implementation details into the cpufeature code. In particular, I see
that KVM's limitations on AA64DFR0 are being copied here.

Additionally, I think it would be preferable to expose this in a manner
that does not require CONFIG_KVM guards in other parts of the kernel.

WDYT about having KVM keep its set of feature overrides and otherwise
rely on the kernel's feature tables? I messed around with the idea a
bit until I could get something workable (attached). I only compile
tested this :)

--
Thanks,
Oliver

--Jy922konoFvWkL0i
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-arm64-cpufeature-Expose-a-helper-for-validating-feat.patch"

From e095ae6f138418bdb0981b6ef2c07930736aa2c2 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oupton@google.com>
Date: Tue, 22 Mar 2022 07:22:28 +0000
Subject: [PATCH] arm64: cpufeature: Expose a helper for validating feature
 registers

KVM is another part of the kernel that needs to deal with feature
registers. Subsequent changes to KVM will make the feature ID registers
writable from userspace, allowing VMMs to limit the exposed ISA to its
guests. However, KVM does not have any good constructs for validating
whether a particular register value constitutes a subset of the features
supported by the system.

Add a helper to check that a feature register value is a subset of the
system's safe value. Allow the caller to specify a set of overridden
feature fields for the case where KVM is more restrictive than the
kernel.

Signed-off-by: Oliver Upton <oupton@google.com>
Change-Id: Iffb134b5517d143377832d9236d5840183283e7f
---
 arch/arm64/include/asm/cpufeature.h |  8 +++
 arch/arm64/kernel/cpufeature.c      | 82 +++++++++++++++++++++++++++--
 2 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..3cda05f5c0e9 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -63,6 +63,12 @@ struct arm64_ftr_bits {
 	s64		safe_val; /* safe value for FTR_EXACT features */
 };
 
+/* Terminator for an array of struct arm64_ftr_bits */
+#define ARM64_FTR_END					\
+	{						\
+		.width = 0,				\
+	}
+
 /*
  * Describe the early feature override to the core override code:
  *
@@ -632,6 +638,8 @@ void check_local_cpu_capabilities(void);
 u64 read_sanitised_ftr_reg(u32 id);
 u64 __read_sysreg_by_encoding(u32 sys_id);
 
+bool arm64_ftr_reg_valid(u32 sys_id, u64 val, const struct arm64_ftr_bits *override);
+
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
 	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e5f23dab1c8d..ba09fbd7b2d0 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -172,11 +172,6 @@ EXPORT_SYMBOL(cpu_hwcap_keys);
 #define S_ARM64_FTR_BITS(VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
 	__ARM64_FTR_BITS(FTR_SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL)
 
-#define ARM64_FTR_END					\
-	{						\
-		.width = 0,				\
-	}
-
 static void cpu_enable_cnp(struct arm64_cpu_capabilities const *cap);
 
 static bool __system_matches_cap(unsigned int n);
@@ -751,6 +746,83 @@ static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
 	return ret;
 }
 
+static bool arm64_ftr_field_valid(const struct arm64_ftr_bits *ftrp, s64 new,
+				 s64 cur)
+{
+	return arm64_ftr_safe_value(ftrp, new, cur) == new;
+}
+
+bool __arm64_ftr_reg_valid(const struct arm64_ftr_bits *ftr_bits, u64 val,
+			   u64 safe_val, u64 *mask)
+{
+	const struct arm64_ftr_bits *ftrp;
+	s64 bits, safe_bits;
+	u64 ftr_mask;
+
+	for (ftrp = ftr_bits; ftrp->width; ftrp++) {
+		/*
+		 * Skip validation of the field if mask indicates the field has
+		 * already been checked.
+		 */
+		ftr_mask = arm64_ftr_mask(ftr_bits);
+		if (*mask & ftr_mask)
+			continue;
+
+		*mask |= ftr_mask;
+
+		safe_bits = arm64_ftr_value(ftr_bits, safe_val);
+		bits = arm64_ftr_value(ftr_bits, val);
+
+		/*
+		 * Check to see if 'val' attempts to advertise more than is
+		 * actually supported.
+		 */
+		if (!arm64_ftr_field_valid(ftr_bits, bits, safe_bits))
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * arm64_ftr_reg_valid() - Determines if a feature register value constitutes a
+ * subset of features supported by the system.
+ *
+ * @sys_reg: The encoded feature register ID
+ * @val: The feature value register to check
+ * @override: Pointer to an ARM64_FTR_END terminated array of overrides. Certain
+ *	      subsystems (such as KVM) are more restrictive than the kernel and
+ *	      impose tighter limits on certain feature fields.
+ *
+ * Return: true if 'val' is an allowed subset of features w.r.t. the system and
+ * the caller-provided overrides.
+ */
+bool arm64_ftr_reg_valid(u32 sys_reg, u64 val, const struct arm64_ftr_bits *override)
+{
+	const struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
+	u64 safe_val;
+	u64 mask = 0;
+
+	if (!reg)
+		return false;
+
+	safe_val = read_sanitised_ftr_reg(sys_reg);
+
+	/*
+	 * Use caller overrides for checking field validity, then check what's
+	 * remaining with our feature table.
+	 */
+	if (!__arm64_ftr_reg_valid(override, val, safe_val, &mask) ||
+	    !__arm64_ftr_reg_valid(reg->ftr_bits, val, safe_val, &mask))
+		return false;
+
+	/* Ensure that no unrecognized fields are set */
+	if (val & ~mask)
+		return false;
+
+	return true;
+}
+
 static void __init sort_ftr_regs(void)
 {
 	unsigned int i;
-- 
2.35.1.894.gb6a874cedc-goog


--Jy922konoFvWkL0i
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--Jy922konoFvWkL0i--
