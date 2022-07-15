Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF38C43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F424BDDC;
	Fri, 15 Jul 2022 02:11:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J2MXhCWSBfHj; Fri, 15 Jul 2022 02:11:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67D684BC0C;
	Fri, 15 Jul 2022 02:11:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFD104BC0C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c96DiwwZZW73 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:19 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A07AC4BD6E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:19 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31dfe25bd47so620957b3.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=l1XnM4q3x1ewVUNvHs0HuWFtRu/IpcbYPtIh1O0D3HY=;
 b=HAos/OmCJvgcvlVr+l4rgZ529Zy9AgZUmxRT5wAwy49nbAxCFX1OoZOy/MbJm5YfaI
 MRjaNeuCZinL0cnj7NX8XMcpCfHHUqWQbv0RAohFcbRY1T4dBE3coMErpa8THr3j468g
 2Mni4CUr/d6Yiy2Xf8toN4vxOmJ8Zi7NDsSuV9FH7qDcmxJowgkg5gzsyeIOlz9g3CCJ
 +cjX93wr1FiRJEKVcXe5xqj+sIUGsei1iANx4eYiKCQ/VZ1DqzZW87VQZnOwwT+6vm2L
 NAve5p5YpRJ6utTnsbjjTignNi4kvQ9AH/UAD2WaDja1b7TkTUFdfYo7/bXdsqoyTW8F
 JnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=l1XnM4q3x1ewVUNvHs0HuWFtRu/IpcbYPtIh1O0D3HY=;
 b=p2uNFdhZym20tNLlYtW2St4lISCOX9+iIhnzKVD1ip5hsjgMC3clhBK6blrkennS0A
 QrA+xjKtTWCPcwdCdYZSTxN/2o49vEgn+vXN0UHaMngT+BwNUmKSOwlV2g/NSo9eG+wO
 wuuvaz/38Tr+1X+4W8pHlDi/vmmguD7jsUBNIMvgihf9gsaC7GAWjvcsQXF9xrtgBiHO
 /q8M/CMkNuVW2pLcyQhwFI5VNNjLQwwnJ7AaM72Jgk7/CxJH6NxYQOCUC1C//f/tqtPq
 XMvPb0KeFizBmj+Bxr3reEar5E4mXmz4rXqyFwybY2bOznFzlEB2zKO5N7OtAhcErQO5
 uSUw==
X-Gm-Message-State: AJIora/BOSgsp187dyL4ZVAiEK+/rbNO9UblbQWR8nYnwOJlRsPysOI6
 ytkqns86G9ZyYCh3eQR7UkoZUHfpWZ4kAZ73kA==
X-Google-Smtp-Source: AGRyM1sFpdc9SV33p7szlsb0+to9mu3jgVu9zuERuzC22gv4CQEQSvN6S0V0TElCV8Mv01JeqbR8z7tOfs91AebCxA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:d18b:0:b0:66f:3536:c35a with SMTP
 id i133-20020a25d18b000000b0066f3536c35amr12561943ybg.546.1657865479300; Thu,
 14 Jul 2022 23:11:19 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:16 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-8-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 07/18] KVM: arm64: On stack overflow switch to hyp
 overflow_stack
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, android-mm@google.com, andreyknvl@gmail.com,
 kernel-team@android.com, drjones@redhat.com,
 linux-arm-kernel@lists.infradead.org, russell.king@oracle.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

On hyp stack overflow switch to 16-byte aligned secondary stack.
This provides us stack space to better handle overflows; and is
used in a subsequent patch to dump the hypervisor stacktrace.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile     |  2 +-
 arch/arm64/kvm/hyp/nvhe/host.S       |  9 ++-------
 arch/arm64/kvm/hyp/nvhe/stacktrace.c | 11 +++++++++++
 3 files changed, 14 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/stacktrace.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index f9fe4dc21b1f..524e7dad5739 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index ea6a397b64a6..b6c0188c4b35 100644
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
+	adr_this_cpu sp, overflow_stack + OVERFLOW_STACK_SIZE, x0
 
 	b	hyp_panic_bad_stack
 	ASM_BUG()
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
new file mode 100644
index 000000000000..a3d5b34e1249
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM nVHE hypervisor stack tracing support.
+ *
+ * Copyright (C) 2022 Google LLC
+ */
+#include <asm/memory.h>
+#include <asm/percpu.h>
+
+DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
+	__aligned(16);
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
