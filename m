Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A93C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 18:48:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2874B211;
	Wed, 27 Apr 2022 14:48:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rIa2pTyfLt8t; Wed, 27 Apr 2022 14:48:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 302E04B1CB;
	Wed, 27 Apr 2022 14:48:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 297114B1CB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:48:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dk5YHvzGivOT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 14:48:32 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 211024B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:48:32 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2f825f8c944so24282927b3.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 11:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=Ukl4ZPUY8nPN3AM2d1WxIlfrlMTerAUV8TUpQy4uNBg=;
 b=MwumuTMcrRhIVZ9j7swb6gFPtCMubn8HLn1QrjGmsWx6TDamUjamppzeC7+Fpo2zsC
 Hn4bx3jBlAkmNArZrSe6MdpVTjEJg354zjO4FkLXTKbIoUVQPlCUBjO2SZCJxc5IkFM8
 cDuvx4Cjo2Ct4xWbHuhsaSXdjyU9NRnacoQoThUDFhnn0R1qKldXoHqIdeFSuyIQg2pC
 chNYgFV6zRM7TOLluFi18wIvk6VKlbVk1NgR+RDLPm9CxC6YqCUydpbanBRewfexSaQv
 7fpo7I+PJ8U4nSeyCdXBluXkIB1PCAe1DvM/MnApanh4SLKGov6OQPuc3nE3UJpm+UME
 sagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=Ukl4ZPUY8nPN3AM2d1WxIlfrlMTerAUV8TUpQy4uNBg=;
 b=IidOk9A3WNI5vlGw/1USoYZeg9eo+z7xE7dhCroHMBl0aBBtwJ+DdUEGANvlAOIEN1
 PTxRfBhCfciMhCyGfru3dbcgyjwTxUch38pzrV4B5dbnalf3baT+FbbkcnrO0jQSC8k4
 FW9upnoeaQDX1zgRRH9w2j+AoGlOqzuoLE41CXJwGdYH3ImKeYHqQS2HdVVGiSIWtd9m
 TxE4LQsTdTYKoo0PowfpBqICDtUVYp0V0rcE9tM9ACqekeGzI09g2Ret0Ofs6tYVNTq4
 6pGN64A2ctTtey8Gan98UqMJVtSlqPREsddNx0qG6slVbSFK3vB2X6Xig4d363sDdwcs
 oBFA==
X-Gm-Message-State: AOAM532hc75aquP27ISnESBurgPEnZT/u6MlUnFcdKiDq62+ih3kQZ0D
 qUee9Zxlwr+en/Tb+ILzGjaSs+PSE2b9ie7Rlg==
X-Google-Smtp-Source: ABdhPJxdWYMm4hIQLef81VH/XkscxGsflUx325g8OpMWgt9ADdwq/DhwrfHi07KPyxCIExLBSzRF/kaTl78lvVXnTw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:16ec:6da0:8cc5:5f24])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:44:0:b0:645:d798:590f with SMTP id
 e4-20020a5b0044000000b00645d798590fmr23864940ybp.228.1651085311643; Wed, 27
 Apr 2022 11:48:31 -0700 (PDT)
Date: Wed, 27 Apr 2022 11:46:57 -0700
In-Reply-To: <20220427184716.1949239-1-kaleshsingh@google.com>
Message-Id: <20220427184716.1949239-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220427184716.1949239-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 2/4] KVM: arm64: Add hypervisor overflow stack
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-kernel@vger.kernel.org,
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
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
