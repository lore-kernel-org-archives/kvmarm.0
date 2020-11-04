Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98125C2D0A3
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 127C120780
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="UB+tujjI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 127C120780
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A72094B6D6;
	Wed,  4 Nov 2020 13:37:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WItiv6Uce6OD; Wed,  4 Nov 2020 13:37:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2BA4B7B4;
	Wed,  4 Nov 2020 13:37:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF374B7B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SLlYObt7a4RL for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:22 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B9DE4B6ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:22 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id k18so3266456wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=u52kHMW+kn83ag3JaEyoWb0+pW9IMqD4BMU2psxNYnQ=;
 b=UB+tujjIDqFaIg2HCII9phSYVmB1j1zP+b/oy7LyLRa4tpi5vDWKwHeXFjBBncAnue
 t5NLaznwL2a6xMO0nB+gZ1W8lR7ASbIC/5uqmVhA4JQkT8FQVwPkHEVtrHZCcXTrelEg
 Zybm4GkCW5RvA/LoFm5TG4qJIoz2BcdeKP84kW3j4+j6F6ikYpJRGjwhjPTkgRLHOEOA
 cA6gGhLerR0LCsX7vhQgqN2GD4VTP/yLKxPGn0+VV1j/Z289/Gkvpx8lCV0Qvg7UoJaD
 DifqvbMmXizjEGf/EPyu+gGhSSM476YffGBtRUTz5V1wN96efp7x2jpSTvTq4TqipO86
 eGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=u52kHMW+kn83ag3JaEyoWb0+pW9IMqD4BMU2psxNYnQ=;
 b=dNhXQ/Cvw1WMLYNY3mBt4JBLsgaSC74ypLHrArdMsmM8Af6VXv2y/80sd36nz9nl/0
 aSUAnpm/EH8OFTfWvvd4sCUSChFi11Rf4MB+0NHrvMMVbR5Sp17euC1u521OCJxggsqH
 VgpLWsyhvVnvilSTx0iV3oMzS6Q7SWeldfGBYf5EILK7xMYnd/oPQtDaV9ex8EswSUZC
 0Gd2NAww2HjhN8uqvPIhcS0VA7LXA9Mf6vKu0+0U093UgSb61f6sBptxeEhnjjEWsUoc
 W0NerT/3PPWGe7Ef6GSSMprAM9xpt/OaNyfeznUn54YPQkIL8h93BeUxa78n9ixrHttB
 /FSQ==
X-Gm-Message-State: AOAM532y6H6AOUyPzcpMFIvJxKi54fhMdng5MX6FmQ9P2w71AnAMzu0f
 qpHbmUqh9OuZ91csak9a7tJ3lCN5vegm6g0i
X-Google-Smtp-Source: ABdhPJwsJeUZZiJ/5qjoSIdAagJRDj0FAch74PF5fDj6WKHQ0ZxsPbVmvF9ETVGgMlYzKzkwDQ1P3g==
X-Received: by 2002:a1c:2842:: with SMTP id o63mr5935820wmo.59.1604515040904; 
 Wed, 04 Nov 2020 10:37:20 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id t5sm4349312wrb.21.2020.11.04.10.37.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:19 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 20/26] kvm: arm64: Add CPU entry point in nVHE hyp
Date: Wed,  4 Nov 2020 18:36:24 +0000
Message-Id: <20201104183630.27513-21-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
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

When nVHE hyp starts interception host's PSCI CPU_ON SMCs, it will need
to install KVM on the newly booted CPU before returning to the host. Add
an entry point which expects the same kvm_nvhe_init_params struct as the
__kvm_hyp_init HVC in the CPU_ON context argument (x0).

The entry point initializes EL2 state with the same init_el2_state macro
used by the kernel's entry point. It then initializes KVM using the same
helper function used in the __kvm_hyp_init HVC.

When done, the entry point branches to a function provided in the init
params.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kernel/asm-offsets.c    |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 30 ++++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9eecb37db6df..8350b95ce94e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -155,6 +155,7 @@ struct kvm_nvhe_init_params {
 	unsigned long tpidr_el2;
 	unsigned long hyp_stack_ptr;
 	unsigned long vector_ptr;
+	unsigned long psci_cpu_entry_fn;
 };
 
 enum kvm_nvhe_psci_state {
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 0cbb86135c7c..ffc84e68ad97 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -114,6 +114,7 @@ int main(void)
   DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params, tpidr_el2));
   DEFINE(NVHE_INIT_STACK_PTR,	offsetof(struct kvm_nvhe_init_params, hyp_stack_ptr));
   DEFINE(NVHE_INIT_VECTOR_PTR,	offsetof(struct kvm_nvhe_init_params, vector_ptr));
+  DEFINE(NVHE_INIT_PSCI_CPU_ENTRY_FN,	offsetof(struct kvm_nvhe_init_params, psci_cpu_entry_fn));
 #endif
 #ifdef CONFIG_CPU_PM
   DEFINE(CPU_CTX_SP,		offsetof(struct cpu_suspend_ctx, sp));
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 1726cc44b3ee..dd297a1a8f82 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -6,6 +6,7 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/linkage.h>
+#include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/alternative.h>
 #include <asm/assembler.h>
@@ -159,6 +160,35 @@ alternative_else_nop_endif
 	ret
 SYM_CODE_END(___kvm_hyp_init)
 
+SYM_CODE_START(__kvm_hyp_cpu_entry)
+	msr	SPsel, #1			// We want to use SP_EL{1,2}
+
+	/*
+	 * Check that the core was booted in EL2. Loop indefinitely if not
+	 * because it cannot be safely given to the host without installing KVM.
+	 */
+	mrs	x1, CurrentEL
+	cmp	x1, #CurrentEL_EL2
+	b.ne	.
+
+	/* Initialize EL2 CPU state to sane values. */
+	mov	x29, x0
+	init_el2_state nvhe
+	mov	x0, x29
+
+	/*
+	 * Load hyp VA of C entry function. Must do so before switching on the
+	 * MMU because the struct pointer is PA and not identity-mapped in hyp.
+	 */
+	ldr	x29, [x0, #NVHE_INIT_PSCI_CPU_ENTRY_FN]
+
+	/* Enable MMU, set vectors and stack. */
+	bl	___kvm_hyp_init
+
+	/* Leave idmap. */
+	br	x29
+SYM_CODE_END(__kvm_hyp_cpu_entry)
+
 SYM_CODE_START(__kvm_handle_stub_hvc)
 	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	1f
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
