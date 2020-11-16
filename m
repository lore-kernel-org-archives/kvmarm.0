Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000EFC64E7B
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7602023A32
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="CePHDUN1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7602023A32
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 241C84C284;
	Mon, 16 Nov 2020 15:44:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qboym0yVcp5k; Mon, 16 Nov 2020 15:44:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B174A4C28C;
	Mon, 16 Nov 2020 15:44:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D09D74B87E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FedU8ddEFqFd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:44:06 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5F954C282
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:06 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id h2so611874wmm.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=wD+a3FpezM46vtDRvUYZ5HtVvRxQTV1ZGJA/wg4Ex98=;
 b=CePHDUN1veATU5Fbosl/2glcCRr5WzC8phqSaumNvMV+29qseMvtZ5AYULHe86VL0Y
 Fl0rKdltr3pyBfvDMv2DYbtiug1MoFDP0prQEQ8QkT6PbcqArN6MEiHuSA3PxAxCk7IY
 URLQBAJTWMpZJ1b72mXGCIC5AicuMS45rYFWJQuTvwx26dLIvMvieTi/iK/y+VGo+a03
 cbD5e/0T+nHVCXYB+UkwBwooP+59t6Xv3IvoPW5qLJMcW6BcLhslZAIzfLgjirBkAjGz
 dW4LjnXf2FVaT6dljBPU4tSL0J8oSTM4rgT+xYCiRsYqLo6+tciGHlUB1LqJbaHGdTE0
 +A1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=wD+a3FpezM46vtDRvUYZ5HtVvRxQTV1ZGJA/wg4Ex98=;
 b=tQG4t8lYnRD+5zwRa+reOXBV918bzKaqzOVB/iKdu7azBSKLdZDyakEH86vn78zd5O
 HA6K9MNhtDvPa/XJhjiDYDxTz36e8H0yGJjDhQkI6/19Tt5Zqf0uTZEoF3mEZ7F1hh71
 5JKl7XmfmqvdxnlufOqfwl7KP+bDx20N8rO8wrHZtsgQzlb1dUAe5064XygggLX8aL3u
 hvcqKEuhLMOXLU1Wy6gwmdUUe+nuC1atZVg6G2rbmdnU5P9/I7/rZQUJwVPuUdBvaCCJ
 adElsE3+9LEkc6x1MkBF2QLutjYd2rtkMXIr5u2FwUJkfIoBWnnuEfTastcJJCRqDVSN
 SdAQ==
X-Gm-Message-State: AOAM5303dPJq38INC5OZbO42zehXVvWXkEkXPBVveLofQ7/RRnRorZYI
 61tJSXArnoI8YFlUYrSh+OGU+HjrHzfWWLdRGUM=
X-Google-Smtp-Source: ABdhPJzetTRH/cFVZbrbGHGqSRHTJfKqrhpUhK6CneVfklDTfCbBbV/l/O0oOWso6KYVg8ahVpsLgQ==
X-Received: by 2002:a05:600c:4147:: with SMTP id
 h7mr713498wmm.186.1605559445403; 
 Mon, 16 Nov 2020 12:44:05 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id t5sm565383wmg.19.2020.11.16.12.44.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:44:04 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 20/24] kvm: arm64: Intercept host's CPU_SUSPEND PSCI SMCs
Date: Mon, 16 Nov 2020 20:43:14 +0000
Message-Id: <20201116204318.63987-21-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Add a handler of CPU_SUSPEND host PSCI SMCs. The SMC can either enter
a sleep state indistinguishable from a WFI or a deeper sleep state that
behaves like a CPU_OFF+CPU_ON.

The handler saves r0,pc of the host and makes the same call to EL3 with
the hyp CPU entry point. It either returns back to the handler and then
back to the host, or wakes up into the entry point and initializes EL2
state before dropping back to EL1.

There is a simple atomic lock around the reset state struct to protect
from races with CPU_ON. A well-behaved host should never run CPU_ON
against an already online core, and the kernel indeed does not allow
that, so if the core sees its reset state struct locked, it will return
a non-spec error code PENDING_ON. This protects the hypervisor state and
avoids the need for more complicated locking and/or tracking power state
of individual cores.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 39 +++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 2daf52b59846..313ef42f0eab 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -121,6 +121,39 @@ static void release_reset_state(struct kvm_host_psci_state *cpu_state)
 	atomic_set_release(&cpu_state->pending_on, 0);
 }
 
+static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	u64 power_state = host_ctxt->regs.regs[1];
+	unsigned long pc = host_ctxt->regs.regs[2];
+	unsigned long r0 = host_ctxt->regs.regs[3];
+	struct kvm_host_psci_state *cpu_state;
+	struct kvm_nvhe_init_params *cpu_params;
+	int ret;
+
+	cpu_state = this_cpu_ptr(&kvm_host_psci_state);
+	cpu_params = this_cpu_ptr(&kvm_init_params);
+
+	/*
+	 * Lock the reset state struct. This fails if the host has concurrently
+	 * called CPU_ON with this CPU as target. The kernel keeps track of
+	 * online CPUs, so that should never happen. If it does anyway, return
+	 * a non-spec error. This avoids the need for spinlocks.
+	 */
+	if (!try_acquire_reset_state(cpu_state, pc, r0))
+		return PSCI_RET_ALREADY_ON;
+
+	/*
+	 * Will either return if shallow sleep state, or wake up into the entry
+	 * point if it is a deep sleep state.
+	 */
+	ret = psci_call(func_id, power_state,
+			__hyp_pa(hyp_symbol_addr(__kvm_hyp_cpu_entry)),
+			__hyp_pa(cpu_params));
+
+	release_reset_state(cpu_state);
+	return ret;
+}
+
 static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
 	u64 mpidr = host_ctxt->regs.regs[1];
@@ -178,7 +211,9 @@ asmlinkage void __noreturn __kvm_hyp_psci_cpu_entry(void)
 
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
-	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
+	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_SUSPEND])
+		return psci_cpu_suspend(func_id, host_ctxt);
+	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
 		return psci_forward(host_ctxt);
 	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_ON])
 		return psci_cpu_on(func_id, host_ctxt);
@@ -202,6 +237,8 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
 	case PSCI_0_2_FN_SYSTEM_RESET:
 		psci_forward_noreturn(host_ctxt);
 		unreachable();
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+		return psci_cpu_suspend(func_id, host_ctxt);
 	case PSCI_0_2_FN64_CPU_ON:
 		return psci_cpu_on(func_id, host_ctxt);
 	default:
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
