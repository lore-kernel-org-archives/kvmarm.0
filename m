Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91355C63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27132221E2
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:55:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ZVUoTU+g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27132221E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C95F64C05A;
	Thu, 26 Nov 2020 10:55:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id En93GrNGXsyT; Thu, 26 Nov 2020 10:55:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9B404C070;
	Thu, 26 Nov 2020 10:55:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 569EC4BC69
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lXtu3LV0u-Bd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:55:11 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14B184C0C7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:55:11 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id 23so2636731wrc.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=zOoo3Sgmv8F42l97WnsUvAdYKac9P9JfqD+cuM/Sn9g=;
 b=ZVUoTU+gAuCOCKAA0JLDhF23GWfoPMRCkpRKeYuO2EHe2Onkr6VOoTZUTexi44Rir1
 M7Vec/VJjU910zroh1GatIekcjEn1KcoZUYX6zTIR6xbl5/W+BI4ijNuriBY4wzxq6o0
 th2sQXhqNToAPL2A4a3jTYDvdhRPGxKoBR1YLOiGZat0oLUmpTjtTL5xf9QYbPo6cRaz
 LeC0zcowK1CpA5rM9SPW/xuLsByt07lyInueXKnZbfVrraPEbzK2Hp2YKnke9CJtx74L
 7eywhbuxnO+at1gvgIEjiycO99JM0jHyGOtXQzmevEWogclk6qZxfgi8ain9mePuu9R6
 wdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=zOoo3Sgmv8F42l97WnsUvAdYKac9P9JfqD+cuM/Sn9g=;
 b=aG6elXM1V8f8yKYS1phjhS2kwjoTOi9TI+eYpWxtKNGtbgBGkLMWmWXEJ0YtptWGRe
 9uzPfY7/DzB4PH98w8JsQJT8yB/tmFUXdYX+Nq4Ot4B4YbF8YWAjF9yhOqSIXPr1bZCr
 gSQmLNRw7ILvvij6sLDZTI6Bgdakohy94u1sDvjKR1x1iNTVLuI/MddtK/PlxGH6zueR
 M/Kjj2taAvXjPKz3yn5Op/5V8b3RZxh1H8nUkOkUmyr9pxng+9MTdeXW15GVHUaYTBch
 Ra8PsJTOu5nwTjl5WVwUDt8TfxFvE3P6oRuT9aIbqCdNyJhAM1Mei3tLSKlPq/vvIwVM
 KfPw==
X-Gm-Message-State: AOAM533V9otqneZiB7qQ/55o1oeNLVgv28OlrEyWGN3JFeELEIYb8U2x
 GxqmMWzm0nNq7c2tYoa7ordJ04nroeIK0Bli
X-Google-Smtp-Source: ABdhPJx7GWZaDHcnXn1i3ov34ALXy1EHh5jMhQYPSdtzUtu5jpP/ecukZb3UeFP0dVO5FD7/MCcz8A==
X-Received: by 2002:adf:82f5:: with SMTP id 108mr4670137wrc.269.1606406109770; 
 Thu, 26 Nov 2020 07:55:09 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id d13sm10931063wrb.39.2020.11.26.07.55.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:55:08 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 20/23] kvm: arm64: Intercept host's CPU_SUSPEND PSCI SMCs
Date: Thu, 26 Nov 2020 15:54:18 +0000
Message-Id: <20201126155421.14901-21-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
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
behaves like a CPU_OFF+CPU_ON except that the core is still considered
online when asleep.

The handler saves r0,pc of the host and makes the same call to EL3 with
the hyp CPU entry point. It either returns back to the handler and then
back to the host, or wakes up into the entry point and initializes EL2
state before dropping back to EL1.

A core can only suspend itself but other cores can concurrently invoke
CPU_ON with this core as target. To avoid racing them for the same
boot args struct, CPU_SUSPEND uses a different struct instance and entry
point. Each entry point selects the corresponding struct to restore host
boot args from. This avoids the need for locking in CPU_SUSPEND.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  9 +++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 50 +++++++++++++++++++++++++---
 2 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index ea71f653af55..fbb195851fb9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -162,7 +162,15 @@ alternative_else_nop_endif
 	ret
 SYM_CODE_END(___kvm_hyp_init)
 
+SYM_CODE_START(__kvm_hyp_cpu_suspend_entry)
+	mov	x28, #0				// is_cpu_on = false
+	b	__kvm_hyp_cpu_common_entry
+SYM_CODE_END(__kvm_hyp_cpu_suspend_entry)
+
 SYM_CODE_START(__kvm_hyp_cpu_on_entry)
+	mov	x28, #1				// is_cpu_on = true
+
+SYM_INNER_LABEL(__kvm_hyp_cpu_common_entry, SYM_L_LOCAL)
 	msr	SPsel, #1			// We want to use SP_EL{1,2}
 
 	/* Check that the core was booted in EL2. */
@@ -188,6 +196,7 @@ SYM_CODE_START(__kvm_hyp_cpu_on_entry)
 	kimg_hyp_va x1, x2
 
 	/* Leave idmap. */
+	mov	x0, x28
 	br	x1
 SYM_CODE_END(__kvm_hyp_cpu_on_entry)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 39e507672e6e..592c11e9851c 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -17,6 +17,7 @@
 #include <nvhe/trap_handler.h>
 
 extern char __kvm_hyp_cpu_on_entry[];
+extern char __kvm_hyp_cpu_suspend_entry[];
 
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 
@@ -39,6 +40,7 @@ struct cpu_boot_args {
 
 static DEFINE_PER_CPU(atomic_t, cpu_on_lock) = ATOMIC_INIT(0);
 static DEFINE_PER_CPU(struct cpu_boot_args, cpu_on_args);
+static DEFINE_PER_CPU(struct cpu_boot_args, cpu_suspend_args);
 
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
@@ -112,6 +114,34 @@ static unsigned int find_cpu_id(u64 mpidr)
 	return INVALID_CPU_ID;
 }
 
+static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, power_state, host_ctxt, 1);
+	DECLARE_REG(unsigned long, pc, host_ctxt, 2);
+	DECLARE_REG(unsigned long, r0, host_ctxt, 3);
+
+	struct cpu_boot_args *boot_args;
+	struct kvm_nvhe_init_params *init_params;
+
+	boot_args = this_cpu_ptr(hyp_symbol_addr(cpu_suspend_args));
+	init_params = this_cpu_ptr(hyp_symbol_addr(kvm_init_params));
+
+	/*
+	 * No need to acquire a lock before writing to boot_args because a core
+	 * can only suspend itself and the racy CPU_ON uses a separate struct.
+	 */
+
+	*boot_args = (struct cpu_boot_args){ .pc = pc, .r0 = r0 };
+
+	/*
+	 * Will either return if shallow sleep state, or wake up into the entry
+	 * point if it is a deep sleep state.
+	 */
+	return psci_call(func_id, power_state,
+			 __hyp_pa(hyp_symbol_addr(__kvm_hyp_cpu_suspend_entry)),
+			 __hyp_pa(init_params));
+}
+
 static __always_inline bool try_acquire_cpu_on_lock(atomic_t *l) {
 	return atomic_cmpxchg_acquire(l, CPU_UNLOCKED, CPU_LOCKED) == CPU_UNLOCKED;
 }
@@ -165,27 +195,35 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	return ret;
 }
 
-asmlinkage void __noreturn __kvm_hyp_psci_cpu_entry(void)
+asmlinkage void __noreturn __kvm_hyp_psci_cpu_entry(bool is_cpu_on)
 {
 	atomic_t *lock;
 	struct cpu_boot_args *boot_args;
 	struct kvm_cpu_context *host_ctxt;
 
-	lock = this_cpu_ptr(hyp_symbol_addr(cpu_on_lock));
-	boot_args = this_cpu_ptr(hyp_symbol_addr(cpu_on_args));
+	if (is_cpu_on)
+		boot_args = this_cpu_ptr(hyp_symbol_addr(cpu_on_args));
+	else
+		boot_args = this_cpu_ptr(hyp_symbol_addr(cpu_suspend_args));
+
 	host_ctxt = &this_cpu_ptr(hyp_symbol_addr(kvm_host_data))->host_ctxt;
 
 	cpu_reg(host_ctxt, 0) = boot_args->r0;
 	write_sysreg_el2(boot_args->pc, SYS_ELR);
 
-	release_cpu_on_lock(lock);
+	if (is_cpu_on) {
+		lock = this_cpu_ptr(hyp_symbol_addr(cpu_on_lock));
+		release_cpu_on_lock(lock);
+	}
 
 	__host_enter(host_ctxt);
 }
 
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
-	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
+	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_SUSPEND])
+		return psci_cpu_suspend(func_id, host_ctxt);
+	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
 		return psci_forward(host_ctxt);
 	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_ON])
 		return psci_cpu_on(func_id, host_ctxt);
@@ -209,6 +247,8 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
 	case PSCI_0_2_FN_SYSTEM_RESET:
 		psci_forward_noreturn(host_ctxt);
 		unreachable();
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+		return psci_cpu_suspend(func_id, host_ctxt);
 	case PSCI_0_2_FN64_CPU_ON:
 		return psci_cpu_on(func_id, host_ctxt);
 	default:
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
