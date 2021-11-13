Return-Path: <SRS0=3yKf=QA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609CFC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:23:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 12D17610CC
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 12D17610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B70254B2A2;
	Fri, 12 Nov 2021 20:23:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kC-Zub98aNpg; Fri, 12 Nov 2021 20:23:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98B074B32D;
	Fri, 12 Nov 2021 20:23:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7B554B24F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:23:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pCwLneb-GEbF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 20:23:12 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 332624B367
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:23:11 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 a16-20020a17090aa51000b001a78699acceso5562748pjq.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 17:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=W9jgYHrBbOBPThTYAHaXWa7wASjXvARMo5Uw/YrP4D4=;
 b=j/7E/Vu3kI/f1cEYZS/kLiJf80TELS9BMtqVtMVK14mKCIl14PK7ClNZsBgnOLnTb4
 lVpbTvKA0n9MERMBMncC6o/S7pSa2rPaxrtRdBirpDqwbpN5JEJJBTmWEwTPzze8FIr7
 35bvrbOR+puUi1tS3dolUhQN6hZZzQaN/n3bftdWd38D5u+fQelOHw7irNv2JP7eWbwh
 wJri8Ec4MSC8KRrbZcFT6sxVw50msmp7OHJALPXjoeqWsDd4JseFzc+7rPeb2PWluIri
 KXj3KQKAsv1tvIB/gMG5EQctkI1vQFgAdc3r7sWxvzlv+nzsJcmxxYGgXwtSm50PheaZ
 N5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=W9jgYHrBbOBPThTYAHaXWa7wASjXvARMo5Uw/YrP4D4=;
 b=l+MUVSfJXl7IPZoQuaGHkJwmsgDfDpZUl3FMchmWiEcBCb9HYAV/HaOCFl2tWom+Ci
 JWvVgm1iNXLPLRwwtJsaItFN+K5I/qxTQmF8CTENUKn1vrR0IShaVkO6DZ+KB6v/1WmU
 vYdWveGGbz7ymPTuy8Nfc3gktdpOileWePglK6onxgDE3XHe80zM4xneRyjuRf0HpDHD
 Nnwjlf8leCnIP3CjzXZ3q6xhuEVFUnQVwmRmNY/MqwUGBSM27dTMMXUQ8ljlZTQnnF7F
 v5NMWcYBG4VoTD6Iws12Q+peGT+4UudxDeyaLH9s2gD+i4Q2RP3uNrpQSe9JauBB2GXk
 gLVA==
X-Gm-Message-State: AOAM533Q6UKI018Cr9Bgxm6+1bRLIGB5Kgwg7EpWVjLTl8ypSuYYKG3J
 sOnNbbosMHXKk/Np0xfx+l/X6Eu6IlEV
X-Google-Smtp-Source: ABdhPJwcBcvi28OtcoG+93M1eX9jXnuPRibbcU2MahTwrQfS01Fey723ak2y8SCBZC4gDLQsXQ3mgwAI2Skg
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1305:b0:4a2:75cd:883b with SMTP
 id j5-20020a056a00130500b004a275cd883bmr6889352pfu.44.1636766590385; Fri, 12
 Nov 2021 17:23:10 -0800 (PST)
Date: Sat, 13 Nov 2021 01:22:34 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-12-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 11/11] selftests: KVM: aarch64: Add the bitmap firmware
 registers to get-reg-list
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The bitmap firmware psuedo-registers needs special handling, such as
enabling the capability KVM_CAP_ARM_HVC_FW_REG_BMAP. Since there's
no support as of yet in get-reg-list to enable a capability, add a
field 'enable_capability' in the 'struct reg_sublist' to
incorporate this. Also, to not mess with the existing configurations,
create a new vcpu_config to hold these bitmap firmware registers.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..7479d0ae501e 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -40,6 +40,7 @@ static __u64 *blessed_reg, blessed_n;
 struct reg_sublist {
 	const char *name;
 	long capability;
+	long enable_capability;
 	int feature;
 	bool finalize;
 	__u64 *regs;
@@ -397,6 +398,19 @@ static void check_supported(struct vcpu_config *c)
 	}
 }
 
+static void enable_capabilities(struct kvm_vm *vm, struct vcpu_config *c)
+{
+	struct reg_sublist *s;
+
+	for_each_sublist(c, s) {
+		if (s->enable_capability) {
+			struct kvm_enable_cap cap = {.cap = s->enable_capability};
+
+			vm_enable_cap(vm, &cap);
+		}
+	}
+}
+
 static bool print_list;
 static bool print_filtered;
 static bool fixup_core_regs;
@@ -414,6 +428,7 @@ static void run_test(struct vcpu_config *c)
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 	prepare_vcpu_init(c, &init);
 	aarch64_vcpu_add_default(vm, 0, &init, NULL);
+	enable_capabilities(vm, c);
 	finalize_vcpu(vm, 0, c);
 
 	reg_list = vcpu_get_reg_list(vm, 0);
@@ -1014,6 +1029,12 @@ static __u64 sve_rejects_set[] = {
 	KVM_REG_ARM64_SVE_VLS,
 };
 
+static __u64 fw_reg_bmap_set[] = {
+	KVM_REG_ARM_FW_REG(3),		/* KVM_REG_ARM_STD_BMAP */
+	KVM_REG_ARM_FW_REG(4),		/* KVM_REG_ARM_STD_HYP_BMAP */
+	KVM_REG_ARM_FW_REG(5),		/* KVM_REG_ARM_VENDOR_HYP_BMAP */
+};
+
 #define BASE_SUBLIST \
 	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
 #define VREGS_SUBLIST \
@@ -1025,6 +1046,10 @@ static __u64 sve_rejects_set[] = {
 	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
 	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
 	  .rejects_set = sve_rejects_set, .rejects_set_n = ARRAY_SIZE(sve_rejects_set), }
+#define FW_REG_BMAP_SUBLIST \
+	{ "fw_reg_bmap", .regs = fw_reg_bmap_set, .regs_n = ARRAY_SIZE(fw_reg_bmap_set), \
+	 .capability = KVM_CAP_ARM_HVC_FW_REG_BMAP, \
+	 .enable_capability = KVM_CAP_ARM_HVC_FW_REG_BMAP, }
 
 static struct vcpu_config vregs_config = {
 	.sublists = {
@@ -1057,10 +1082,20 @@ static struct vcpu_config sve_pmu_config = {
 	},
 };
 
+static struct vcpu_config vregs_fw_regs_bmap_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	VREGS_SUBLIST,
+	FW_REG_BMAP_SUBLIST,
+	{0},
+	},
+};
+
 static struct vcpu_config *vcpu_configs[] = {
 	&vregs_config,
 	&vregs_pmu_config,
 	&sve_config,
 	&sve_pmu_config,
+	&vregs_fw_regs_bmap_config,
 };
 static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
