Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49755C56201
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B35E12220B
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:33:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="q9g/yH0W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B35E12220B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53C3A4B4E1;
	Mon,  9 Nov 2020 06:33:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K52IQanmWZie; Mon,  9 Nov 2020 06:33:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B695B4B741;
	Mon,  9 Nov 2020 06:33:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC584B310
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tt1VTjn+v5BG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:33:22 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9B934B327
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:33:21 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id 10so6882641wml.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=NS+1ZuglZo9Zn7yUnAclLe5esR1R1/5yk9FHSFQ7d8k=;
 b=q9g/yH0WIaLvx219DqcXDw1PkbjnU9PKjXT0aixjKFwDfVrboe09k14qFs5wzeSKNF
 jz414gJie7cGqI6l1RvEB3fXslz27Oht8VEEZXRaVSWglOGKUTV41SgHoKBSRvdEnW4h
 fPWQ2mIpmCCFyeMkXcBodWBvtonybukFkMho8gtFiz2xo6Yh2v0wNIqODsV1Bd90W+V6
 qJFDd3M2lmQC6Q8J9RJ6UNKXZ51/wOhOyXnoOAgBEpp1F/ciYNUFSuwpZETWHgIy4vbe
 gqowPqSa+VdGf44IWcD9TzZ9HOW6Oy9XZsuOdaLKHChTP7J75C7a+tVq7gn6DgFmOQDQ
 T0TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=NS+1ZuglZo9Zn7yUnAclLe5esR1R1/5yk9FHSFQ7d8k=;
 b=dYW1Lt3Lz1gjfgyfu1F0oYpZDXWryt/pH05SBcpRKhvEcJXCHuwXymcMrB31/zcPZn
 wUnJOjoiuLS5eoF/cwYiWRQ3Jk937YKJnja07pW2zB6j+6zb4GoVQtJM7zo9UocFov+m
 g7lMUdjW9I+DrB1YCgNGonpjn3FVnsZnH/v6HPGD5UGxhc3d3d08ZKfV1TJGjw0IyaaD
 28DUxjo4MbWOnsXcsf0T6Acnl+dQ+Gn1swt8/CSahOaXubLgeEsUoKsIs3BewyUlLckS
 WQBTXzkR0Hq57f2P+riz3I1V4hd93f24+P5yNyMRt6o5syHn6SgGSE1JWFAAC824FpHx
 RpbA==
X-Gm-Message-State: AOAM533fBrn1Levr7LHAXrZ0IkGpghkX0WfWYN/VzkQxzRsvqZWl6JUk
 JD8OMqV/Rl7cN8zuQ5pS3M4ieR2/04TihZhW
X-Google-Smtp-Source: ABdhPJw+z6E2az4tGXEKJ+aoSJh6Li+u4guKF5JI2ND/5xzgqTGZfkNsdEo5CHTN+G3OtJpOjMODLA==
X-Received: by 2002:a1c:6456:: with SMTP id y83mr14727428wmb.59.1604921600616; 
 Mon, 09 Nov 2020 03:33:20 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id n128sm5063892wmb.46.2020.11.09.03.33.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:33:19 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 20/24] kvm: arm64: Intercept host's CPU_SUSPEND PSCI SMCs
Date: Mon,  9 Nov 2020 11:32:29 +0000
Message-Id: <20201109113233.9012-21-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
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
 arch/arm64/kvm/hyp/nvhe/psci.c | 39 +++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
index f9b82a87bf44..ec00036a1613 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci.c
@@ -127,6 +127,39 @@ static void release_reset_state(struct kvm_host_psci_state *cpu_state)
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
+			__hyp_pa_symbol(__kvm_hyp_cpu_entry),
+			__hyp_pa(cpu_params));
+
+	release_reset_state(cpu_state);
+	return ret;
+}
+
 static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
 	u64 mpidr = host_ctxt->regs.regs[1];
@@ -180,7 +213,9 @@ asmlinkage void __noreturn kvm_host_psci_cpu_entry(void)
 
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
-	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
+	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_SUSPEND])
+		return psci_cpu_suspend(func_id, host_ctxt);
+	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
 		return psci_forward(host_ctxt);
 	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_ON])
 		return psci_cpu_on(func_id, host_ctxt);
@@ -204,6 +239,8 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
 	case PSCI_0_2_FN_SYSTEM_RESET:
 		psci_forward_noreturn(host_ctxt);
 		unreachable();
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+		return psci_cpu_suspend(func_id, host_ctxt);
 	case PSCI_0_2_FN64_CPU_ON:
 		return psci_cpu_on(func_id, host_ctxt);
 	default:
-- 
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
