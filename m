Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8877C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 703864C48B;
	Wed, 23 Feb 2022 06:02:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MFzZV6srav2k; Wed, 23 Feb 2022 06:02:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2C24C49E;
	Wed, 23 Feb 2022 06:02:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3672A404B2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 12:00:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q4tPqcA7Ke6Q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 12:00:40 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0494440C1B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 12:00:39 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 v4-20020a63f844000000b003745fd0919aso2960825pgj.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 09:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=5qb5Zh5e8x0hA/HCW8SK7letHwHax9Wce8Hz1k3JTdg=;
 b=ITgvGI+DDxrws5QD+aqNmanS1XXPkR5OB1mc/GjeEFKe1PUFInLivQOj2yo7QUg+Ms
 jiQqEBIgx8+pm/kTGUv4kJbSou6k/zNoYhVYDkZAoPQcycS+1hRaIFS0LySP1N6gBZzN
 UaUG12NsYuyKvxTJaL6deitrMeqYZr6WLyZD3VhFhAjEtFzDl9XHbYq3JslYm4d8OYjz
 X/npdOM7xhWI6vlrhC6uIMRYM7xjLfG1ykah3QVJqU0WAp7G1+U7twKq7GAqvOV9yNkk
 pKJSH3usycLKHhOjCm8vwteuS3A7gapZDcF2n0sPj1Iupc/Hz3asBMWMKtVvwjT0Yhf5
 /1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=5qb5Zh5e8x0hA/HCW8SK7letHwHax9Wce8Hz1k3JTdg=;
 b=oyK9br87QA1YcFiuDBE/ywmnq5MS8OTIah+chtHCsSeAtvQQRK1LgHz2ec1MNCn5jP
 GhmjL7S0lW1/wGCLR2gXE9OrhRjiPDd0RJMQlx8EWhet4kNyDeV4p+F37gWfv+V0sIoj
 Nv7JGBL4n/1q2u6pOvfdmkQ8EwjhIU4aS8jEbvrVu1Hbp3D/H9sKwOLQRtdhntriAFbQ
 lal3K2lgB4R7F3OSlx3VRnXJrEVElb8yL+miWfUk13t7qxyCSQAV+veIFku1DPLvC9U+
 q+ZW6Fkwd0LXGrnP2Xpat/xPlUmPiGtHutx5PkwMd8asf2MNCEaiGBLvbzH/i2+6eXyE
 0qaQ==
X-Gm-Message-State: AOAM5303f0M6uVWZxOcOKeYmhW9xlt4+gCxxOQfYc/OO9Cc+RC4tTfo0
 OcinyQjLCQNti0DO9Am/KLwZFFj0324hIZrC2g==
X-Google-Smtp-Source: ABdhPJzH5Lfs/f/UpeVcOR5FEQsrODh9JTFqCt6nAPQwaG7BkrPBoWZU4Etxumn3mAF9Ju4JlTfm2YcSMf2h76tr4w==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5db7:1235:b3dd:cfcb])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6a00:2296:b0:4e1:3029:ee2 with
 SMTP id f22-20020a056a00229600b004e130290ee2mr25396129pfe.22.1645549239077;
 Tue, 22 Feb 2022 09:00:39 -0800 (PST)
Date: Tue, 22 Feb 2022 08:51:08 -0800
In-Reply-To: <20220222165212.2005066-1-kaleshsingh@google.com>
Message-Id: <20220222165212.2005066-8-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220222165212.2005066-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v2 7/9] KVM: arm64: Add hypervisor overflow stack
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Kalesh Singh <kaleshsingh@google.com>,
 surenb@google.com, linux-arm-kernel@lists.infradead.org
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

Allocate and switch to 16-byte aligned secondary stack on overflow. This
provides us stack space to better handle overflows; and is used in
a subsequent patch to dump the hypervisor stacktrace. The overflow stack
is only allocated if CONFIG_NVHE_EL2_DEBUG is enabled, as hypervisor
stacktraces is a debug feature dependent on CONFIG_NVHE_EL2_DEBUG.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S   | 5 +++++
 arch/arm64/kvm/hyp/nvhe/switch.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 78e4b612ac06..751a4b9e429f 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -171,6 +171,10 @@ SYM_FUNC_END(__host_hvc)
 	b	hyp_panic
 
 .L__hyp_sp_overflow\@:
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	/* Switch to the overflow stack */
+	adr_this_cpu sp, hyp_overflow_stack + PAGE_SIZE, x0
+#else
 	/*
 	 * Reset SP to the top of the stack, to allow handling the hyp_panic.
 	 * This corrupts the stack but is ok, since we won't be attempting
@@ -178,6 +182,7 @@ SYM_FUNC_END(__host_hvc)
 	 */
 	ldr_this_cpu	x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
 	mov	sp, x0
+#endif
 
 	bl	hyp_panic_bad_stack
 	ASM_BUG()
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 5a2e1ab79913..2accc158210f 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -34,6 +34,11 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], hyp_overflow_stack)
+	__aligned(16);
+#endif
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
