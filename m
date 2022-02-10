Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B7EC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 09:28:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2BB34A19A;
	Fri, 11 Feb 2022 04:28:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ho-NPxNSNdNl; Fri, 11 Feb 2022 04:28:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED33B4B08E;
	Fri, 11 Feb 2022 04:28:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B480840BC0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:46:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uncHTrnPdD54 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 17:46:01 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B565408BA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 17:46:01 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 s73-20020a25aa4f000000b0061d764d3c13so15213742ybi.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=/IZyRrpjogHkvvKAbn/wuM+XhkmHZlGRNHWt0e5zr8A=;
 b=PBkmRwuFiGGrv5iRHo7tLluafzQlZXF9AN4cUQvrlWacXQcrnAlFwCuc/zOtvTnj3A
 eyIK8Dr7DfK8BlaH06yRYxaDcs2bvmYni1BgVFeXEqyLnH4uCPmVWvtXo1p/9EFiq8OK
 yozHbjdo5J8wCe1HRkEpfHLkD8SJn8NzBv9iKIQrno5l1WcFw65NEM8NvqQ6xCxV2EW5
 EPhU/2linown0tcJ3M3OITrVQ+B7l8BdSNdus0cc0Zg5pAix41rloxydzHuthJS8zX7p
 ctJ0Xrcr/w2hgACd8f01767tNpufMelYYz/KRWp+lszWzveeyi2sIdj7lorWwXkseetK
 RatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=/IZyRrpjogHkvvKAbn/wuM+XhkmHZlGRNHWt0e5zr8A=;
 b=2bu/FMmNi8Hep4z/f0nr70aTETXbhlE48h9t1W19PG1gKw92fDk5x8hofZqPnUKFOz
 oDJ0Z4pFsEsx2WLIWl6dqYlqFdIaLLPGdTZ8ERpuu9VrIv0XK+aFDEKXZIy2X4I3Zk0r
 I0zkwHZKl3H2hB5w9AArio/X2ElpVn8+ktA5IWI+n5afw3CytHW8xfBWMdak8VzjwN0y
 XjUnzPrfr6dkjhIQfpDYx66CJz6nA3vGcxReD0DbELdF1nTgrLP1JX/VuugUS6QN50qk
 gtbRUP6miRu3UjaXPHIyEOtqx7y7rSODo2InCAfA01aM/vMdMdei8tTBNf+IrzGTq7je
 RQww==
X-Gm-Message-State: AOAM532nL/GO/LsZMOI2bg9yBWpjRU2CqwKPRko9fKJdqBQM7BYo1QQZ
 Sp1cgF6KVbLQ0q4rAGEgwPua1mGMHaaPDW8awQ==
X-Google-Smtp-Source: ABdhPJxltTVLo3VOurL3QnroR1cp79bh23NqnvdKXTYN3qVmilP7Lx3u//hZdXpNdmMvGA/0NZZ08lArO17mKqkodg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:8f02:232:ad86:2ab2])
 (user=kaleshsingh job=sendgmr) by 2002:a81:3494:: with SMTP id
 b142mr9302016ywa.246.1644533161146; Thu, 10 Feb 2022 14:46:01 -0800 (PST)
Date: Thu, 10 Feb 2022 14:41:46 -0800
In-Reply-To: <20220210224220.4076151-1-kaleshsingh@google.com>
Message-Id: <20220210224220.4076151-6-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220210224220.4076151-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH 5/7] KVM: arm64: Add Hyp overflow stack
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Fri, 11 Feb 2022 04:28:10 -0500
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
 arch/arm64/kvm/hyp/nvhe/host.S  | 5 +++++
 arch/arm64/kvm/hyp/nvhe/setup.c | 5 +++++
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
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 114053dff228..39937fa6a1b2 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -20,6 +20,11 @@
 
 unsigned long hyp_nr_cpus;
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], hyp_overflow_stack)
+	__aligned(16);
+#endif
+
 #define hyp_percpu_size ((unsigned long)__per_cpu_end - \
 			 (unsigned long)__per_cpu_start)
 
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
