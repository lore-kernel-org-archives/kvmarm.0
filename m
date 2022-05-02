Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50687C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 19:13:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C63864B286;
	Mon,  2 May 2022 15:13:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ou9Eu3KRHR3D; Mon,  2 May 2022 15:13:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A06784B1BD;
	Mon,  2 May 2022 15:13:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B79A74B152
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 15:13:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3m4dUODhUg9l for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 15:13:48 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B48704A7FD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 15:13:48 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 b11-20020a5b008b000000b00624ea481d55so13892109ybp.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 12:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=NecAjaKo6a145Hd4bQjyaTWZfIjyHs70zkocfLAKQSs=;
 b=QVB6MW5tJEeXEtBnaqj+68WPwqmSC0IDheiS7ttyTWBXJheFxYJ7C/cvodMmjalP5S
 vgZ+25BOK1Vt3B+UC80FJgGZdJxmILirm2qIWWMzqQF9btkic9cKsZ4U90LlRJKgOIQb
 OrTHHTjrX2SGtENn6w3FoHexOsjv2+FfLK1KiMDV/DFHYvlaEcbXAMk9Uha4wZsMlT57
 r3Qm38iqI4B/e8OLYePe0sEmEzTlEV4o1W4+PTuBcWIQ9QCFi9NQMtRyR9gXalxyZAsd
 L8fbI+dfQxvDWPmAQbezRSSCqwvyOACkyZSwVL6lKIEY19fxQPrqDUQjvTJeSh4cKII1
 /WCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=NecAjaKo6a145Hd4bQjyaTWZfIjyHs70zkocfLAKQSs=;
 b=SONpSfcIYJRDieglAZA+ZBe3N4xhMyUoZzmOa6cvnFWMyy8tq4nvN7W2L7AVGh7Mbc
 2m5iCvjB3DA4W5jDfjgEgs5NMcb1rJqmQbi9PRNibPWGZnMXm63qmiCl6E2XKFMGHKJu
 npiUi2r71KtjACOAIgfrLj7dijXuh4wvttdoaTCnAtjTWbLv22Gkcu2Skd5crKIE3Zbc
 G76s2Ix0eoKX8Lim0qbQWZTXVg6FRaDnvycUy4HO2kRN+5TaJT2k0XdhjUkNBB0HVAbX
 /djpnbURPxGxn8x5mQ8Sn2qTncli1Psf4uj8Sdk+45Bx+ubsXJNoyOCitwvQAb3YzXLp
 qm+Q==
X-Gm-Message-State: AOAM530omWyBrC1lT02pZpuEuO+/Cr4HU0jqsaPqrQ5Z8cbLEegw4nDa
 pUvdgMo7NrTdeCXXARcP8vL6gRhKYUNhROOTVQ==
X-Google-Smtp-Source: ABdhPJx8M1O6z1nhK+MdMqqpss40uQyyOjlwfPNkVGWLfomVVPIxF8Rydp8wjn3kM3vkNvKVXWoWNEL5hggFgOkzAg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:55c:7548:7073:c14f])
 (user=kaleshsingh job=sendgmr) by 2002:a25:7243:0:b0:649:1be0:5061 with SMTP
 id n64-20020a257243000000b006491be05061mr11146766ybc.597.1651518828253; Mon,
 02 May 2022 12:13:48 -0700 (PDT)
Date: Mon,  2 May 2022 12:12:03 -0700
In-Reply-To: <20220502191222.4192768-1-kaleshsingh@google.com>
Message-Id: <20220502191222.4192768-4-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220502191222.4192768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 3/5] KVM: arm64: Add hypervisor overflow stack
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Marco Elver <elver@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, broonie@kernel.org, Peter Collingbourne <pcc@google.com>,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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
index 09b5254fb497..1cd2de4f039e 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -179,13 +179,8 @@ SYM_FUNC_END(__host_hvc)
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
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
