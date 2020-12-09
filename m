Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B71AC4361B
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F001723B45
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:18:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F001723B45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2FB84B2EF;
	Wed,  9 Dec 2020 08:18:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2r7LuCUqZlmj; Wed,  9 Dec 2020 08:18:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 537174B2FE;
	Wed,  9 Dec 2020 08:18:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA1F24B2FF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:18:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zGndrwfcAmjl for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 08:18:10 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B7CF4B313
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:18:10 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id l9so1692002wrt.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 05:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=w6vSHAYoQKu8XGlm7CRNOjlMO18mzd4d/VT7UzJjsWc=;
 b=M2EjPjYaPTZQdOf4ksEbBwAQW94UxN9wS929V4aj5l6pAeXJokz3aZyp7xjnRcNiMG
 NKGLB/sX55udo5pfl2U52FthoDQzEdWWwqRiQEPxOHwWZ/rX2iVZmt2LOmX6nHfh8uHh
 R3EKiTz+TOxLmuhtEYHFPgPSsvsO0OLJcj97R8WlvFlor4NaGA2wiuAsTZ3Y40dthg1h
 2AzE3Yhh1mJGmwVlXAdzxpUDJxBMzLsGjTMzkWDhUpYOogFH5yQ3IY/qJhIi08uEDH3q
 bhyZ2WoLFJLdPkrVQNtrLITs1ByMKmo2BAqzibbJ+hhvH8EuvBDBeMf1VNIiEmCv0k+z
 ADuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=w6vSHAYoQKu8XGlm7CRNOjlMO18mzd4d/VT7UzJjsWc=;
 b=V9flelM3hrLn9xEyBWnrv7x+0JR2VXLuEBJOyrVwT9a1ULQG8AdVF9jXDGGQ99gkbC
 +bFMK5/ThiZMlWseCXB1sH4J3YVuJ2muIaZ04emmSZP1cmVP0lR53ctGAzb5VqSDWUW7
 j4LlK99+4FHI3ZY5IZwjvkYe4fpIdTw+bSMb82XqvQVWgrjmJ9PLX/wpynp3zXam8quB
 qS8gYNvhmafd/1QzLNvD9zuoJgj7MXxDgD1UybvXEJdCDWJuZkBgJ+f6IoyG8Y1rrPVa
 GSoXhCaAOoR1XyLFcCaQv63tBieP00vD0CvngHjXKmZhwaA5sZzzMo+ENev0HwqMoJvf
 aGJw==
X-Gm-Message-State: AOAM533PQeFe+uXWdDvhx6sxtoaGkuxTpjZiAiWgE/I3CbNtmdIMNmsH
 sxigYoeco+uvOccg0fhO/5ffxuq7JB/ZuQ==
X-Google-Smtp-Source: ABdhPJyvB9EL367TzDMyOMYd5F+ScAh1vR3kafMvhosXFATpK1QBNQ3dG7m4JoGBD31iEAkyLXYwaw==
X-Received: by 2002:a5d:4d88:: with SMTP id b8mr2668962wru.134.1607519889197; 
 Wed, 09 Dec 2020 05:18:09 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9d1b:d0eb:db43:6cd2])
 by smtp.gmail.com with ESMTPSA id o83sm3205019wme.21.2020.12.09.05.18.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Dec 2020 05:18:08 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 9/9] KVM: arm64: Remove hyp_symbol_addr
Date: Wed,  9 Dec 2020 13:17:46 +0000
Message-Id: <20201209131746.85622-10-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209131746.85622-1-dbrazdil@google.com>
References: <20201209131746.85622-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

Hyp code used the hyp_symbol_addr helper to force PC-relative addressing
because absolute addressing results in kernel VAs due to the way hyp
code is linked. This is not true anymore, so remove the helper and
update all of its users.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h         | 20 --------------------
 arch/arm64/kvm/hyp/include/hyp/switch.h  |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c        |  4 ++--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c     | 24 ++++++++++++------------
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 5 files changed, 17 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 7ccf770c53d9..22d933e9b59e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -199,26 +199,6 @@ extern void __vgic_v3_init_lrs(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
-/*
- * Obtain the PC-relative address of a kernel symbol
- * s: symbol
- *
- * The goal of this macro is to return a symbol's address based on a
- * PC-relative computation, as opposed to a loading the VA from a
- * constant pool or something similar. This works well for HYP, as an
- * absolute VA is guaranteed to be wrong. Only use this if trying to
- * obtain the address of a symbol (i.e. not something you obtained by
- * following a pointer).
- */
-#define hyp_symbol_addr(s)						\
-	({								\
-		typeof(s) *addr;					\
-		asm("adrp	%0, %1\n"				\
-		    "add	%0, %0, :lo12:%1\n"			\
-		    : "=r" (addr) : "S" (&s));				\
-		addr;							\
-	})
-
 #define __KVM_EXTABLE(from, to)						\
 	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
 	"	.align		3\n"					\
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 84473574c2e7..54f4860cd87c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -505,8 +505,8 @@ static inline void __kvm_unexpected_el2_exception(void)
 	struct exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
 
-	entry = hyp_symbol_addr(__start___kvm_ex_table);
-	end = hyp_symbol_addr(__stop___kvm_ex_table);
+	entry = &__start___kvm_ex_table;
+	end = &__stop___kvm_ex_table;
 
 	while (entry < end) {
 		addr = (unsigned long)&entry->insn + entry->insn;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index cbab0c6246e2..2048725517f8 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -33,8 +33,8 @@ unsigned long __hyp_per_cpu_offset(unsigned int cpu)
 	if (cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base))
 		hyp_panic();
 
-	cpu_base_array = (unsigned long *)hyp_symbol_addr(kvm_arm_hyp_percpu_base);
+	cpu_base_array = (unsigned long *)&kvm_arm_hyp_percpu_base;
 	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
-	elf_base = (unsigned long)hyp_symbol_addr(__per_cpu_start);
+	elf_base = (unsigned long)&__per_cpu_start;
 	return this_cpu_base - elf_base;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 08dc9de69314..746fb7079581 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -151,8 +151,8 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	if (cpu_id == INVALID_CPU_ID)
 		return PSCI_RET_INVALID_PARAMS;
 
-	boot_args = per_cpu_ptr(hyp_symbol_addr(cpu_on_args), cpu_id);
-	init_params = per_cpu_ptr(hyp_symbol_addr(kvm_init_params), cpu_id);
+	boot_args = per_cpu_ptr(&cpu_on_args, cpu_id);
+	init_params = per_cpu_ptr(&kvm_init_params, cpu_id);
 
 	/* Check if the target CPU is already being booted. */
 	if (!try_acquire_boot_args(boot_args))
@@ -163,7 +163,7 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	wmb();
 
 	ret = psci_call(func_id, mpidr,
-			__hyp_pa(hyp_symbol_addr(kvm_hyp_cpu_entry)),
+			__hyp_pa(&kvm_hyp_cpu_entry),
 			__hyp_pa(init_params));
 
 	/* If successful, the lock will be released by the target CPU. */
@@ -182,8 +182,8 @@ static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	struct psci_boot_args *boot_args;
 	struct kvm_nvhe_init_params *init_params;
 
-	boot_args = this_cpu_ptr(hyp_symbol_addr(suspend_args));
-	init_params = this_cpu_ptr(hyp_symbol_addr(kvm_init_params));
+	boot_args = this_cpu_ptr(&suspend_args);
+	init_params = this_cpu_ptr(&kvm_init_params);
 
 	/*
 	 * No need to acquire a lock before writing to boot_args because a core
@@ -197,7 +197,7 @@ static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	 * point if it is a deep sleep state.
 	 */
 	return psci_call(func_id, power_state,
-			 __hyp_pa(hyp_symbol_addr(kvm_hyp_cpu_resume)),
+			 __hyp_pa(&kvm_hyp_cpu_resume),
 			 __hyp_pa(init_params));
 }
 
@@ -209,8 +209,8 @@ static int psci_system_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	struct psci_boot_args *boot_args;
 	struct kvm_nvhe_init_params *init_params;
 
-	boot_args = this_cpu_ptr(hyp_symbol_addr(suspend_args));
-	init_params = this_cpu_ptr(hyp_symbol_addr(kvm_init_params));
+	boot_args = this_cpu_ptr(&suspend_args);
+	init_params = this_cpu_ptr(&kvm_init_params);
 
 	/*
 	 * No need to acquire a lock before writing to boot_args because a core
@@ -221,7 +221,7 @@ static int psci_system_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 
 	/* Will only return on error. */
 	return psci_call(func_id,
-			 __hyp_pa(hyp_symbol_addr(kvm_hyp_cpu_resume)),
+			 __hyp_pa(&kvm_hyp_cpu_resume),
 			 __hyp_pa(init_params), 0);
 }
 
@@ -230,12 +230,12 @@ asmlinkage void __noreturn kvm_host_psci_cpu_entry(bool is_cpu_on)
 	struct psci_boot_args *boot_args;
 	struct kvm_cpu_context *host_ctxt;
 
-	host_ctxt = &this_cpu_ptr(hyp_symbol_addr(kvm_host_data))->host_ctxt;
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 
 	if (is_cpu_on)
-		boot_args = this_cpu_ptr(hyp_symbol_addr(cpu_on_args));
+		boot_args = this_cpu_ptr(&cpu_on_args);
 	else
-		boot_args = this_cpu_ptr(hyp_symbol_addr(suspend_args));
+		boot_args = this_cpu_ptr(&suspend_args);
 
 	cpu_reg(host_ctxt, 0) = boot_args->r0;
 	write_sysreg_el2(boot_args->pc, SYS_ELR);
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 8f0585640241..87a54375bd6e 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -64,7 +64,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	}
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
-	addr  = hyp_symbol_addr(kvm_vgic_global_state)->vcpu_hyp_va;
+	addr  = kvm_vgic_global_state.vcpu_hyp_va;
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
-- 
2.29.2.576.ga3fc446d84-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
