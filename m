Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACC3C5519F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB4CC2222C
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Dnk6DEKL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB4CC2222C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 364FF4B5F8;
	Tue, 17 Nov 2020 13:16:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jJLwzz1pxNZi; Tue, 17 Nov 2020 13:16:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EB664B855;
	Tue, 17 Nov 2020 13:16:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8C3D4B5F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UKfsvFL9nzKO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:24 -0500 (EST)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6824C4B5E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:24 -0500 (EST)
Received: by mail-qk1-f202.google.com with SMTP id w189so14641357qkd.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=BJadavlyJaEECXi/UfC92ghmWl3ZHk3QkybvjorYO/E=;
 b=Dnk6DEKLEHkZgTwkTbD6MYFgmWYFpJl2OGFyj4gCuoFYePt7Mtzuqdl8/Pq1pvD11U
 BWX8ZkLWbm00UHzCwQKUlwmt7cxlXEikfwIeaywi0jAmubiAVQC6UFZRSD64nhv4OajC
 8GM+OO1cEmHVMjDnBj1yjfr+CpFs5FuisgZcCrst6Kti8soVn7OtELYLgmoHevMNGj7L
 Ui7OZS+hF5d9GnfYGHSfJS66fNDOL0URBhlRZdoDaUHxQZNAySSvA8fmrx/lkyK/2roN
 5HV6l22AiuuUqQ38FO7K47r4nUDftLLbmFziAUUXdVz5RHqS++6+XcMJfWYt3sxg7qBB
 Li+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BJadavlyJaEECXi/UfC92ghmWl3ZHk3QkybvjorYO/E=;
 b=OHcSyjPrzBHnPglvCeKd2oV4QogW+lVOc0IP+dN4aH67G80KDnKW2muN8A8OAJ+437
 Ps81Pt0XFD/s2TiaAPTbcgMXHV0PmTEJyv+zb/JbkXQp2gwRtTB1DGIEERXng/BTEHf8
 s3cyOrWd9cR4NJEycliCdgqjUBSLTb/Pn288gVf3wrEBMlEHb1bZOm0/7KyJxVl9bMEE
 UJtXQnVVE1t+ZgjGwU9XANyL8EmCEsamYZrmCNXlki6zZWcMEDGNEomZhY+4mFaUkgmI
 v8T1XnaRsElK0xwBv8p+PJMva2bm2UOBkwHqxEbZZfYzsQkAdxXwhPjPujk+Le9P+Y+2
 3+nA==
X-Gm-Message-State: AOAM5313MKB18AiXVMeuYZSxPzMs52NZP8TD07FvgIUu5TE+Kbv0jlyE
 bFs/P6mEUvN4wfaL0+5mcSFJ+W81J7/D
X-Google-Smtp-Source: ABdhPJwADVZ7KA4lluf+rS88dHojtzpcrwFUrsFZ5Z/Kf+n3XgZdS9/NeT5dfwme4Jn7l/egpgFYp8Qa6c6N
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a0c:cd92:: with SMTP id
 v18mr884407qvm.47.1605636983901; Tue, 17 Nov 2020 10:16:23 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:42 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-3-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 02/27] KVM: arm64: Link position-independent string
 routines into .hyp.text
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

From: Will Deacon <will@kernel.org>

Pull clear_page(), copy_page(), memcpy() and memset() into the nVHE hyp
code and ensure that we always execute the '__pi_' entry point on the
offchance that it changes in future.

[ qperret: Commit title nits ]

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kernel/image-vars.h   | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 8539f34d7538..dd8ccc9efb6a 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -105,6 +105,17 @@ KVM_NVHE_ALIAS(__stop___kvm_ex_table);
 /* Array containing bases of nVHE per-CPU memory regions. */
 KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
 
+/* Position-independent library routines */
+__kvm_nvhe_clear_page			= __kvm_nvhe___pi_clear_page;
+__kvm_nvhe_copy_page			= __kvm_nvhe___pi_copy_page;
+__kvm_nvhe_memcpy			= __kvm_nvhe___pi_memcpy;
+__kvm_nvhe_memset			= __kvm_nvhe___pi_memset;
+
+#ifdef CONFIG_KASAN
+__kvm_nvhe___memcpy			= __kvm_nvhe___pi_memcpy;
+__kvm_nvhe___memset			= __kvm_nvhe___pi_memset;
+#endif
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 1f1e351c5fe2..590fdefb42dd 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,10 +6,14 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
+lib-objs := clear_page.o copy_page.o memcpy.o memset.o
+lib-objs := $(addprefix ../../../lib/, $(lib-objs))
+
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
+obj-y += $(lib-objs)
 
 ##
 ## Build rules for compiling nVHE hyp code
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
