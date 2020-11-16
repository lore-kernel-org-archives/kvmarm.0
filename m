Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92EBC6379F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B9392224B
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="bu7IUUGl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B9392224B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B814C195;
	Mon, 16 Nov 2020 15:44:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wzeSxbgaUWxJ; Mon, 16 Nov 2020 15:44:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FD554C282;
	Mon, 16 Nov 2020 15:44:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0464B87E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id capJ1r497b1h for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:44:06 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEFAE4BDB9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:44:04 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id a65so587468wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=WBQXxHKSrw4ISOY6hPN/ivUM/b0haQ+fAYVOgu8djuU=;
 b=bu7IUUGlZCfQ2rBLEsCeFuHkYsbOcNpBTrTUGYlPuDZuDDjHRhGEszmMbRLj/j/teS
 ietQnuyeMB7TDmik5JfPefh7nAbSg+toOpBh7l8k/sPJbweEaNjxQzhkP8rVxVs3ZbkN
 FraCt+nCmU1j4AjhXwdeCaHx0EGKJ9jJnSx8EWib+2Smw4dyitr9Rw8OqQQDWJI6s0yL
 CHRyrRpfp1vRNLdkISI2MPqtyg5fOREa5NBfIDiUjYnS9lsdFpYAXkMdhL9V63poZO3B
 O9woJ9l5e/odjIXxlUtSQFbzwPz86lXWQXXsqUWJn0FPhjjaU2KQiw/c6RIcdPEpCL4t
 KhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=WBQXxHKSrw4ISOY6hPN/ivUM/b0haQ+fAYVOgu8djuU=;
 b=Iz1SAjxeb3q/Qa8cBLKgBwjZHmZByea41j6bx+X4nYFzY0pHIVoJtZZaIj8BSXuY44
 F7f/jO7zl2d70MPCY8zYCsbe2zj+HEuGdthGi94ZE1y9wicb5MT1h2ksOFfLcuSVF9zI
 HLw4vzwR3rshcf304i9ZQ5QC4kBeG2e37z0BnSuDToiZNTvWQ64fvNgYUrF9B0vEo82q
 4qGRspgqOF68jvgZw3D1dF5tuAKMBU7Dbz0fE5aV1qlOqCZYJB4LW+IdsBhQZT8Q40OX
 oe0FPEe+WUPhLZge5GqcPc8OQNf3bpfFSEJreGNzb/OCf3ISL319yBEOL8HKqbPdBsmT
 Hx9g==
X-Gm-Message-State: AOAM530DNtEYB/N06pix50Q6sPCKMZ0P4TaQmNgHOE3j9kqIrCEqSqLK
 vxs3AAmVdOh/gtLdsc4AeeNiHYJSMz3qY4SWc5A=
X-Google-Smtp-Source: ABdhPJyPFq9EpMZcJa+H5AM5ddZ4jULWGNnXylZP2109D0VFfOIUUOCtj9Sn5MyoxE8gpnwA2d3f5Q==
X-Received: by 2002:a1c:e345:: with SMTP id a66mr712197wmh.188.1605559443484; 
 Mon, 16 Nov 2020 12:44:03 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id z19sm546928wmk.12.2020.11.16.12.44.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:44:02 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 19/24] kvm: arm64: Intercept host's PSCI_CPU_ON SMCs
Date: Mon, 16 Nov 2020 20:43:13 +0000
Message-Id: <20201116204318.63987-20-dbrazdil@google.com>
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

Add a handler of the CPU_ON PSCI call from host. When invoked, it looks
up the logical CPU ID corresponding to the provided MPIDR and populates
the state struct of the target CPU with the provided x0, pc. It then
calls CPU_ON itself, with an entry point in hyp that initializes EL2
state before returning ERET to the provided PC in EL1.

There is a simple atomic lock around the reset state struct. If it is
already locked, CPU_ON will return PENDING_ON error code.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h     |   8 ++-
 arch/arm64/kvm/arm.c                 |   1 +
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 104 +++++++++++++++++++++++++++
 3 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 109867fb76f6..2e36ba4be748 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -175,9 +175,11 @@ struct kvm_s2_mmu;
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_host_vector);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
-#define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
-#define __kvm_hyp_host_vector	CHOOSE_NVHE_SYM(__kvm_hyp_host_vector)
-#define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
+DECLARE_KVM_NVHE_SYM(__kvm_hyp_psci_cpu_entry);
+#define __kvm_hyp_init			CHOOSE_NVHE_SYM(__kvm_hyp_init)
+#define __kvm_hyp_host_vector		CHOOSE_NVHE_SYM(__kvm_hyp_host_vector)
+#define __kvm_hyp_vector		CHOOSE_HYP_SYM(__kvm_hyp_vector)
+#define __kvm_hyp_psci_cpu_entry	CHOOSE_NVHE_SYM(__kvm_hyp_psci_cpu_entry)
 
 extern unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_SYM(__per_cpu_start);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7d2270eeecfb..c76a8e5bd19c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1365,6 +1365,7 @@ static void cpu_init_hyp_mode(void)
 
 	params->vector_hyp_va = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_host_vector));
 	params->stack_hyp_va = kern_hyp_va(__this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE);
+	params->entry_hyp_va = (unsigned long)kern_hyp_va(kvm_ksym_ref(__kvm_hyp_psci_cpu_entry));
 	params->pgd_pa = kvm_mmu_get_httbr();
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 7542de8bd679..2daf52b59846 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -9,10 +9,15 @@
 #include <asm/kvm_mmu.h>
 #include <kvm/arm_hypercalls.h>
 #include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
 #include <linux/psci.h>
 #include <kvm/arm_psci.h>
 #include <uapi/linux/psci.h>
 
+#define INVALID_CPU_ID UINT_MAX
+
+extern char __kvm_hyp_cpu_entry[];
+
 /* Config options set by the host. */
 u32 __ro_after_init kvm_host_psci_version = PSCI_VERSION(0, 0);
 u32 __ro_after_init kvm_host_psci_function_id[PSCI_FN_MAX];
@@ -20,6 +25,14 @@ s64 __ro_after_init hyp_physvirt_offset;
 
 #define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
 
+struct kvm_host_psci_state {
+	atomic_t pending_on;
+	unsigned long pc;
+	unsigned long r0;
+};
+
+static DEFINE_PER_CPU(struct kvm_host_psci_state, kvm_host_psci_state);
+
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
 {
 	return host_ctxt->regs.regs[0];
@@ -76,10 +89,99 @@ static __noreturn unsigned long psci_forward_noreturn(struct kvm_cpu_context *ho
 	hyp_panic(); /* unreachable */
 }
 
+static unsigned int find_cpu_id(u64 mpidr)
+{
+	int i;
+
+	if (mpidr != INVALID_HWID) {
+		for (i = 0; i < NR_CPUS; i++) {
+			if (cpu_logical_map(i) == mpidr)
+				return i;
+		}
+	}
+
+	return INVALID_CPU_ID;
+}
+
+static bool try_acquire_reset_state(struct kvm_host_psci_state *cpu_state,
+				    unsigned long pc, unsigned long r0)
+{
+	if (atomic_cmpxchg_acquire(&cpu_state->pending_on, 0, 1) != 0)
+		return false;
+
+	cpu_state->pc = pc;
+	cpu_state->r0 = r0;
+	wmb();
+
+	return true;
+}
+
+static void release_reset_state(struct kvm_host_psci_state *cpu_state)
+{
+	atomic_set_release(&cpu_state->pending_on, 0);
+}
+
+static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	u64 mpidr = host_ctxt->regs.regs[1];
+	unsigned long pc = host_ctxt->regs.regs[2];
+	unsigned long r0 = host_ctxt->regs.regs[3];
+	unsigned int cpu_id;
+	struct kvm_host_psci_state *cpu_state;
+	struct kvm_nvhe_init_params *cpu_params;
+	int ret;
+
+	/*
+	 * Find the logical CPU ID for the given MPIDR. The search set is
+	 * the set of CPUs that were online at the point of KVM initialization.
+	 * Booting other CPUs is rejected because their cpufeatures were not
+	 * checked against the finalized capabilities. This could be relaxed
+	 * by doing the feature checks in hyp.
+	 */
+	cpu_id = find_cpu_id(mpidr);
+	if (cpu_id == INVALID_CPU_ID)
+		return PSCI_RET_INVALID_PARAMS;
+
+	cpu_state = per_cpu_ptr(&kvm_host_psci_state, cpu_id);
+	cpu_params = per_cpu_ptr(&kvm_init_params, cpu_id);
+
+	if (!try_acquire_reset_state(cpu_state, pc, r0))
+		return PSCI_RET_ALREADY_ON;
+
+	ret = psci_call(func_id, mpidr,
+			__hyp_pa(hyp_symbol_addr(__kvm_hyp_cpu_entry)),
+			__hyp_pa(cpu_params));
+
+	/*
+	 * If CPU_ON was successful, the reset state will be released in
+	 * kvm_host_psci_cpu_entry().
+	 */
+	if (ret != PSCI_RET_SUCCESS)
+		release_reset_state(cpu_state);
+	return ret;
+}
+
+void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
+
+asmlinkage void __noreturn __kvm_hyp_psci_cpu_entry(void)
+{
+	struct kvm_host_psci_state *cpu_state = this_cpu_ptr(&kvm_host_psci_state);
+	struct kvm_cpu_context *host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+
+	host_ctxt->regs.regs[0] = cpu_state->r0;
+	write_sysreg_el2(cpu_state->pc, SYS_ELR);
+
+	release_reset_state(cpu_state);
+
+	__host_enter(host_ctxt);
+}
+
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
 	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
 		return psci_forward(host_ctxt);
+	else if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_ON])
+		return psci_cpu_on(func_id, host_ctxt);
 	else if (func_id == kvm_host_psci_function_id[PSCI_FN_MIGRATE])
 		return psci_forward(host_ctxt);
 	else
@@ -100,6 +202,8 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
 	case PSCI_0_2_FN_SYSTEM_RESET:
 		psci_forward_noreturn(host_ctxt);
 		unreachable();
+	case PSCI_0_2_FN64_CPU_ON:
+		return psci_cpu_on(func_id, host_ctxt);
 	default:
 		return PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
