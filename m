Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D06C5DF9D
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0228920719
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="m8K5bU/p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0228920719
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 960984B606;
	Wed,  4 Nov 2020 13:37:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id scxYKVXHbZA5; Wed,  4 Nov 2020 13:37:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1178B4B7A4;
	Wed,  4 Nov 2020 13:37:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3792A4B7B3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qZers6DUz2wB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:36:59 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDF444B6DE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:58 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id n18so23143946wrs.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=yHpZ9wtBmkho6WWTpMsPbAPapSxOhOKPIw2D5X4b/kc=;
 b=m8K5bU/p3bcrkcVWYa/Sh88AnifU54Kz8+53se/R/bVZ/VKDTqqZu7LmPsP4mFeNVv
 Q+q9Ko2M3D0VRvShU58WDoXLNfSfEjzW1HfzErPgkGP5JSvi5PS6PcA63vuZg7AiOYbc
 kHHZC2MfXu29algZJjbudHQlBWPHQ3gMUsnqJgiLae77ewjoh8ku7oVXra/O8Nn0j8ll
 EAg03uR6xdNvB2ESOV3tEc7FhB9sE2h96modaPk/60u8p6yBkJR/A55ctvaOXbZRKENj
 sASw51SSO4HpzZZmaANpV3IZ7TwUTPCAe2bH9uOKft0GjTlS6Gs9ws8Bu2TpG3PLBAzU
 huKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=yHpZ9wtBmkho6WWTpMsPbAPapSxOhOKPIw2D5X4b/kc=;
 b=YMRMSqGdZctmCXauo37VhhOU3W2f1aB+VqOMxFea/GEQjncA50RN1E+ydVqUklqKfw
 L3hxZg+/KavbRkPRQeOWijIv3SD4kJJ5kfT64pttT/ekhUvrrSeNToPMnD5YACFfKyEH
 MX4o95eUAZtJ0xVQrS6dG/fS/G4V2lU7WK6vhE7ElVG9TZYoz5AxNzpuelQ2dOhEqIlK
 ZaDRGs7rHRxq1n0wV2E00F2OX5oe52TrkoUxiubQmwEZpn/ifvfgrpcuUhfQ4a1l4DHZ
 xScfFij4gy+AKCi4tWFg6dE+ZyvJK4AtADXxOMCX4z/YQrv8NUlcQ0Ezii7hOvtNwr97
 6GQg==
X-Gm-Message-State: AOAM530Yl50XX8UgvkiLEfqUrv4P5f+ngnljKzDuyBUGSX5yzRMacbY6
 ssEmE3cV4PLnjZR3EstZ/68O9cWOEaS3CEq/
X-Google-Smtp-Source: ABdhPJyGohO4e+3lizetDAfnmuzcf5QMzfiAMeVyZMS3REu9yZqv6LDFsroY0eavwMSVaSHDGXWjcg==
X-Received: by 2002:adf:c803:: with SMTP id d3mr18719800wrh.108.1604515017450; 
 Wed, 04 Nov 2020 10:36:57 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id a17sm4198738wra.61.2020.11.04.10.36.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:56 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 09/26] kvm: arm64: Move hyp-init params to a per-CPU struct
Date: Wed,  4 Nov 2020 18:36:13 +0000
Message-Id: <20201104183630.27513-10-dbrazdil@google.com>
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

Once we start initializing KVM on newly booted cores before the rest of
the kernel, parameters to __do_hyp_init will need to be provided by EL2
rather than EL1. At that point it will not be possible to pass its four
arguments directly because PSCI_CPU_ON only supports one context
argument.

Refactor __do_hyp_init to accept its parameters in a struct. This
prepares the code for KVM booting cores as well as removes any limits on
the number of __do_hyp_init arguments.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  7 +++++++
 arch/arm64/include/asm/kvm_hyp.h   |  4 ++++
 arch/arm64/kernel/asm-offsets.c    |  4 ++++
 arch/arm64/kvm/arm.c               | 26 ++++++++++++++------------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 21 ++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  2 ++
 6 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 54387ccd1ab2..a49a87a186c3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -150,6 +150,13 @@ extern void *__vhe_undefined_symbol;
 
 #endif
 
+struct kvm_nvhe_init_params {
+	phys_addr_t pgd_ptr;
+	unsigned long tpidr_el2;
+	unsigned long hyp_stack_ptr;
+	unsigned long vector_ptr;
+};
+
 /* Translate a kernel address @ptr into its equivalent linear mapping */
 #define kvm_ksym_ref(ptr)						\
 	({								\
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 6b664de5ec1f..a3289071f3d8 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -15,6 +15,10 @@
 DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+#endif
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 7d32fc959b1a..0cbb86135c7c 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -110,6 +110,10 @@ int main(void)
   DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
   DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
+  DEFINE(NVHE_INIT_PGD_PTR,	offsetof(struct kvm_nvhe_init_params, pgd_ptr));
+  DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params, tpidr_el2));
+  DEFINE(NVHE_INIT_STACK_PTR,	offsetof(struct kvm_nvhe_init_params, hyp_stack_ptr));
+  DEFINE(NVHE_INIT_VECTOR_PTR,	offsetof(struct kvm_nvhe_init_params, vector_ptr));
 #endif
 #ifdef CONFIG_CPU_PM
   DEFINE(CPU_CTX_SP,		offsetof(struct cpu_suspend_ctx, sp));
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 58e9cc183bd5..ff200fc8d653 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -50,6 +50,7 @@ DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
+DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
@@ -1331,10 +1332,7 @@ static int kvm_map_vectors(void)
 
 static void cpu_init_hyp_mode(void)
 {
-	phys_addr_t pgd_ptr;
-	unsigned long hyp_stack_ptr;
-	unsigned long vector_ptr;
-	unsigned long tpidr_el2;
+	struct kvm_nvhe_init_params *params = this_cpu_ptr_nvhe_sym(kvm_init_params);
 	struct arm_smccc_res res;
 
 	/* Switch from the HYP stub to our own HYP init vector */
@@ -1345,13 +1343,18 @@ static void cpu_init_hyp_mode(void)
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
 	 * so that we can use adr_l to access per-cpu variables in EL2.
 	 */
-	tpidr_el2 = (unsigned long)this_cpu_ptr_nvhe_sym(__per_cpu_start) -
-		    (unsigned long)kvm_ksym_ref(CHOOSE_NVHE_SYM(__per_cpu_start));
+	params->tpidr_el2 = (unsigned long)this_cpu_ptr_nvhe_sym(__per_cpu_start) -
+			    (unsigned long)kvm_ksym_ref(CHOOSE_NVHE_SYM(__per_cpu_start));
 
-	pgd_ptr = kvm_mmu_get_httbr();
-	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
-	hyp_stack_ptr = kern_hyp_va(hyp_stack_ptr);
-	vector_ptr = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
+	params->pgd_ptr = kvm_mmu_get_httbr();
+	params->vector_ptr = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
+	params->hyp_stack_ptr = kern_hyp_va(__this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE);
+
+	/*
+	 * Flush the init params from the data cache because the struct will
+	 * be read from while the MMU is off.
+	 */
+	__flush_dcache_area(params, sizeof(*params));
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
@@ -1360,8 +1363,7 @@ static void cpu_init_hyp_mode(void)
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!system_capabilities_finalized());
-	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init),
-			  pgd_ptr, tpidr_el2, hyp_stack_ptr, vector_ptr, &res);
+	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__kvm_hyp_init), virt_to_phys(params), &res);
 	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 96e70f976ff5..6f3ac5d428ec 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -47,10 +47,7 @@ __invalid:
 
 	/*
 	 * x0: SMCCC function ID
-	 * x1: HYP pgd
-	 * x2: per-CPU offset
-	 * x3: HYP stack
-	 * x4: HYP vectors
+	 * x1: struct kvm_nvhe_init_params PA
 	 */
 __do_hyp_init:
 	/* Check for a stub HVC call */
@@ -71,10 +68,16 @@ __do_hyp_init:
 	mov	x0, #SMCCC_RET_NOT_SUPPORTED
 	eret
 
-1:
-	/* Set tpidr_el2 for use by HYP to free a register */
-	msr	tpidr_el2, x2
+1:	ldr	x0, [x1, #NVHE_INIT_TPIDR_EL2]
+	msr	tpidr_el2, x0
 
+	ldr	x0, [x1, #NVHE_INIT_STACK_PTR]
+	mov	sp, x0
+
+	ldr	x0, [x1, #NVHE_INIT_VECTOR_PTR]
+	msr	vbar_el2, x0
+
+	ldr	x1, [x1, #NVHE_INIT_PGD_PTR]
 	phys_to_ttbr x0, x1
 alternative_if ARM64_HAS_CNP
 	orr	x0, x0, #TTBR_CNP_BIT
@@ -134,10 +137,6 @@ alternative_else_nop_endif
 	msr	sctlr_el2, x0
 	isb
 
-	/* Set the stack and new vectors */
-	mov	sp, x3
-	msr	vbar_el2, x4
-
 	/* Hello, World! */
 	mov	x0, #SMCCC_RET_SUCCESS
 	eret
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e2eafe2c93af..411b0f652417 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -14,6 +14,8 @@
 
 #include <kvm/arm_hypercalls.h>
 
+DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+
 static void handle_host_hcall(unsigned long func_id,
 			      struct kvm_cpu_context *host_ctxt)
 {
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
