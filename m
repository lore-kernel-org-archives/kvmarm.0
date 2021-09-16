Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA94FC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A15B36120C
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A15B36120C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5546B4B1A2;
	Thu, 16 Sep 2021 14:16:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HSvStdIiPMkF; Thu, 16 Sep 2021 14:16:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2094B1C7;
	Thu, 16 Sep 2021 14:16:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BD724B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1HEuk-iSgQho for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:16:10 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CD174B163
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:08 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 o9-20020ac80249000000b002a0c9fd54d5so63171229qtg.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Xw4+tgKVLmvm8JQWsGHVEpFbMf77zCGqq8rbz5yrSuw=;
 b=aqj3HRCmfQvWoQtSN5RzC1ysFfx+mQMpaBU2bf9JiwokiR0SsR1mjFVZwlMsYRWd5F
 S1wO4hvUJBxqXeG0m7E3iOLmvRhccSonfYKnGvnrmcxRXwiajJF8WrW/0OjYx2jBhPNg
 mSeQYdEI69TgXBb0UzLjUrlsKeOQachsm67AH76Wx+H8gHYl2PSGhNNq6W7jYvQM/XC3
 LXaisjjlREFlx0rMPKJ2YsgTBksZdWAA2o3kTilLBfa1XqxawES6tGn2os4UI+BOIu19
 gZFLCmlXEaeNDs7eyflXYmGj3j9j1rvbHboi2PjGfs2Sd46TUcfd88SDJvadas/9BxEe
 FnxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Xw4+tgKVLmvm8JQWsGHVEpFbMf77zCGqq8rbz5yrSuw=;
 b=L6HmrvCIFbCTbVINdf9MZdBLSjj9lXqgdpZKhqFN7RBG2rQZy8z7Du4mw+HpBue6MV
 0xco3SF8h+9zdvpnXmAfnLCQyCP0vZqvSvol2V4gztqrMULQkj1lkCJKQ2LOqppHoP/9
 sH1Im/tcD6KmSVy9RIY0y70hEPUeit+m6NdIixXN7TiLZkWiF8Lw5mt4YaOkhj+0Mk9e
 phaNsBPHP1DWvMBwFCIBhcxK/IARrOSeUdyffdv+0jeMZ9iqBvSNpFaLBsbBF4DGuAfb
 vYRxhFX+Uv4D3p7pUPPYkBfXyZiO5lq6A9OmH0I3fDCQ2QpCUp+e8HCVa3/VmrZ1mfq4
 lJRA==
X-Gm-Message-State: AOAM533Mh/CRTwrRmSVBe9Az1Pnl6vaicORAek4Q04axKcZJILn7KDNA
 KN9BAlB+ItaSNVB2qdHbeujn+IWtwWA=
X-Google-Smtp-Source: ABdhPJwwEMjf9bn2Y68JHX2UcSLI5bYpoUc13K4VaVdU55eP01YXVcQ93R0zLYLdVbktp7FtkAMXNw1xICs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:1372:: with SMTP id
 c18mr4801098qvw.28.1631816167832; Thu, 16 Sep 2021 11:16:07 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:55 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-10-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 9/9] selftests: KVM: Test vtimer offset reg in get-reg-list
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Assert that KVM exposes KVM_REG_ARM_TIMER_OFFSET in the KVM_GET_REG_LIST
ioctl when userspace buys in to the new behavior.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..4f337d8b793a 100644
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
 
+static void enable_caps(struct kvm_vm *vm, struct vcpu_config *c)
+{
+	struct kvm_enable_cap cap = {0};
+	struct reg_sublist *s;
+
+	for_each_sublist(c, s) {
+		if (s->enable_capability) {
+			cap.cap = s->enable_capability;
+			vm_enable_cap(vm, &cap);
+		}
+	}
+}
+
 static bool print_list;
 static bool print_filtered;
 static bool fixup_core_regs;
@@ -412,6 +426,8 @@ static void run_test(struct vcpu_config *c)
 	check_supported(c);
 
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	enable_caps(vm, c);
+
 	prepare_vcpu_init(c, &init);
 	aarch64_vcpu_add_default(vm, 0, &init, NULL);
 	finalize_vcpu(vm, 0, c);
@@ -1014,6 +1030,10 @@ static __u64 sve_rejects_set[] = {
 	KVM_REG_ARM64_SVE_VLS,
 };
 
+static __u64 vtimer_offset_regs[] = {
+	KVM_REG_ARM_TIMER_OFFSET,
+};
+
 #define BASE_SUBLIST \
 	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
 #define VREGS_SUBLIST \
@@ -1025,6 +1045,10 @@ static __u64 sve_rejects_set[] = {
 	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
 	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
 	  .rejects_set = sve_rejects_set, .rejects_set_n = ARRAY_SIZE(sve_rejects_set), }
+#define VTIMER_OFFSET_SUBLIST \
+	{ "vtimer_offset", .capability = KVM_CAP_ARM_VTIMER_OFFSET, \
+	  .enable_capability = KVM_CAP_ARM_VTIMER_OFFSET, .regs = vtimer_offset_regs, \
+	  .regs_n = ARRAY_SIZE(vtimer_offset_regs), }
 
 static struct vcpu_config vregs_config = {
 	.sublists = {
@@ -1041,6 +1065,14 @@ static struct vcpu_config vregs_pmu_config = {
 	{0},
 	},
 };
+static struct vcpu_config vregs_vtimer_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	VREGS_SUBLIST,
+	VTIMER_OFFSET_SUBLIST,
+	{0},
+	},
+};
 static struct vcpu_config sve_config = {
 	.sublists = {
 	BASE_SUBLIST,
@@ -1056,11 +1088,21 @@ static struct vcpu_config sve_pmu_config = {
 	{0},
 	},
 };
+static struct vcpu_config sve_vtimer_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	SVE_SUBLIST,
+	VTIMER_OFFSET_SUBLIST,
+	{0},
+	},
+};
 
 static struct vcpu_config *vcpu_configs[] = {
 	&vregs_config,
 	&vregs_pmu_config,
+	&vregs_vtimer_config,
 	&sve_config,
 	&sve_pmu_config,
+	&sve_vtimer_config,
 };
 static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
