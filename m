Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3F2C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 16:52:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE0A14B312;
	Tue,  7 Jun 2022 12:52:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hTLG4XzpW+T6; Tue,  7 Jun 2022 12:52:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 748C64B31D;
	Tue,  7 Jun 2022 12:52:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C0BF4B2FB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 12:52:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BVIJSM7ambgw for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 12:52:26 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E19F4B24C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 12:52:26 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3077947cbb8so153406017b3.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jun 2022 09:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=x4HYk8ZXIQ3L7NS6dgOSqFvxE7Amt+Ba78KLaT8irts=;
 b=bbRfr+VLNGH5abSF72ZiMEU0zNJsQdJuZGojBmlWNAKmd1Ix07dEopbMuqAJ5xYIMb
 z01k3Ui7ONQkbcxRWF9ga19riZtMb8V7AbmCO4w39rPeR/t8TvN1l3MyXBCK/tQXXgBt
 +8NF8qc1zN7qjitT9iTsE1VPPfeXteLDvl9Ay4SBBHThXEGq/BXjsxwklqYe70WmQ8ht
 B//5R0e0lXiDLWSo1IWOJLY2QJzHyPd5V+AnnA2sqNE39mfpfPTbR7oRZ1zS2kIl3LpD
 g7cHHtq6aP+d8NyxJqCmyhVy37PTQdtOFWQ2sJus28hTcinWBTQXvWv7QiBi74k2Tz1M
 dw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=x4HYk8ZXIQ3L7NS6dgOSqFvxE7Amt+Ba78KLaT8irts=;
 b=kH+5JWjLv0IXjtBaQOKmxur0vH6+eRD5wBNmkc5bs08phvmYO8II2QmfiBUq0r9eXa
 xehSJ3u+jxlk+B2VgilR4OAgd0tgCqv0fkex8UTuQIWbOdS3DPNKJqOlbDV7fytHxq8X
 Uyf00HLUdW9c5p8ILG5FEljHcgvR0MLFh7YgfbR3YDSbAHrKoHD3IUc0uaQAZiO6uaBI
 hmywpcyPKnhdrG94bKruhPXlo2laGWamWADR0tPHE5LrqqV1BDxvxYb8ujqMBABlqukf
 N1/+dhDtauhLKdgR0NXhAwi/NYtx/SBoWy+cCbstG+hLdOB+0nBSSkH6PtPQnVYWA2SU
 rybg==
X-Gm-Message-State: AOAM531azyGGopFP+hKdlrVXvVpEfOH1U9MUNaQ14Vp/6J35xdRCCzu3
 SgA3nZUE7jZwQwet8voD6VgYCNMcebxXZ0uABw==
X-Google-Smtp-Source: ABdhPJz5cu56sG78OQqQQjV0I3/hccrWnE63JIWa21o18y/iEx0ZFYvdLKe0iAXWzw5Pfvq5YrrnFsuiy2fijwl19w==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:7091:8518:ec1e:93dc])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:12:0:b0:663:e4df:7bc0 with SMTP id
 a18-20020a5b0012000000b00663e4df7bc0mr2722447ybp.208.1654620745478; Tue, 07
 Jun 2022 09:52:25 -0700 (PDT)
Date: Tue,  7 Jun 2022 09:50:45 -0700
In-Reply-To: <20220607165105.639716-1-kaleshsingh@google.com>
Message-Id: <20220607165105.639716-4-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220607165105.639716-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v3 3/5] KVM: arm64: Add hypervisor overflow stack
From: Kalesh Singh <kaleshsingh@google.com>
To: mark.rutland@arm.com, broonie@kernel.org, maz@kernel.org
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, surenb@google.com, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, tjmercier@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>
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
a subsequent patch to dump the hypervisor stacktrace.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kernel/stacktrace.c | 3 +++
 arch/arm64/kvm/hyp/nvhe/host.S | 9 ++-------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index a84e38d41d38..f346b4c66f1c 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -242,4 +242,7 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 
 	unwind(task, &state, consume_entry, cookie);
 }
+#else /* __KVM_NVHE_HYPERVISOR__ */
+DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], overflow_stack)
+	__aligned(16);
 #endif /* !__KVM_NVHE_HYPERVISOR__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index ea6a397b64a6..4e3032a244e1 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -177,13 +177,8 @@ SYM_FUNC_END(__host_hvc)
 	b	hyp_panic
 
 .L__hyp_sp_overflow\@:
-	/*
-	 * Reset SP to the top of the stack, to allow handling the hyp_panic.
-	 * This corrupts the stack but is ok, since we won't be attempting
-	 * any unwinding here.
-	 */
-	ldr_this_cpu	x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
-	mov	sp, x0
+	/* Switch to the overflow stack */
+	adr_this_cpu sp, overflow_stack + PAGE_SIZE, x0
 
 	b	hyp_panic_bad_stack
 	ASM_BUG()
-- 
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
