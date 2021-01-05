Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B31C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1BC9622CF7
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BC9622CF7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE4064B383;
	Tue,  5 Jan 2021 13:06:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dJ4MX4DvpXAl; Tue,  5 Jan 2021 13:06:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EF5C4B369;
	Tue,  5 Jan 2021 13:06:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E90694B38B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qcB6MmcsP751 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 13:06:10 -0500 (EST)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF9B34B392
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:10 -0500 (EST)
Received: by mail-wm1-f45.google.com with SMTP id a6so372544wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 10:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Gbp0yeP9fLTV4dr+t+2KX9FiCtVVsbkdYRtcsAjBIrU=;
 b=jFQIQrL34kPIQiwDILOVev4AaFi3ZoNyBOA8xZ6iS62BqlqSP7dEc+U5DcuueL5AZY
 yms3fpksZn+wuTcHbIA6fAydqmWnIy6wQhjzueC1z9F2cSvxNRkbK6Bfm49JBV/+CSxy
 f8uJYUJBM70p/Ehv4N2VR2lMw3RQWDHnZBNJ5bk9Kb3vjEfyL9DWHUjOedWgEasHZnm7
 3hFhQehbUkyMB4YiRZO+AzqUb8zKtnU8W93R5RjuTCvMB7G68FdA1oQQ+m4nJYt7vZvR
 rHJtRZJOaJR3iu30iN/W1uhb9mboTBcscGAA5bxlqXoSl6XfH2+T3TYVAtHp7W+aiA4p
 OU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Gbp0yeP9fLTV4dr+t+2KX9FiCtVVsbkdYRtcsAjBIrU=;
 b=RntwIS1APBhg6fZOcyzPwNr2AH8uWbDG//0Qyv2XxxZtG8uUbEJT9soWW8OCDQdVbx
 W2+aqZ5PayPjhHmGzBq78NmC5OsIYU2rgblW/NAQJrz+ggKMgWK+kP3vY/hQjMAEzbBQ
 6hSHwSmEfiIzddHPeTf+8XVpycPmdSbE8UAfm/+FcBzZpkLYlMEw0vPwW3JKVnRnyWeV
 iTiYkBVkyeZvnuckz8WcEVq0vb4uzydG6zTjMDYJGhWwjVMdL9Uvxkf8VMO24ua9mHw2
 fl0nEkwtDwvch5XKbgrO/CQrTaRdZHAz/FWjV8zjAKneGgHyoWC3j14bKNg/nLXvJx/S
 PD9w==
X-Gm-Message-State: AOAM532zQ4JMv16h5pj+z6i+9cdTpmklCrKLKTsmZaDv2IYigCV5gAiy
 XIZp7Of6pc9XE7AVs7tgOiVQ77LRse+OUw==
X-Google-Smtp-Source: ABdhPJzPGG9RBoyhJQLzttz8EAAC11owesE8rsq+vvvfbhxoYZs+I3UtJZieKVfwRoMz686oJu0KDw==
X-Received: by 2002:a1c:7d58:: with SMTP id y85mr347623wmc.50.1609869969348;
 Tue, 05 Jan 2021 10:06:09 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:4957:71a5:7b5c:c94f])
 by smtp.gmail.com with ESMTPSA id l5sm658028wrv.44.2021.01.05.10.06.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Jan 2021 10:06:08 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 8/8] KVM: arm64: Remove hyp_symbol_addr
Date: Tue,  5 Jan 2021 18:05:41 +0000
Message-Id: <20210105180541.65031-9-dbrazdil@google.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105180541.65031-1-dbrazdil@google.com>
References: <20210105180541.65031-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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
 arch/arm64/include/asm/kvm_asm.h         | 26 ------------------------
 arch/arm64/kvm/hyp/include/hyp/switch.h  |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c        |  4 ++--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c     | 24 +++++++++++-----------
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 5 files changed, 17 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 8a33d83ea843..22d933e9b59e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -199,32 +199,6 @@ extern void __vgic_v3_init_lrs(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
-#if defined(GCC_VERSION) && GCC_VERSION < 50000
-#define SYM_CONSTRAINT	"i"
-#else
-#define SYM_CONSTRAINT	"S"
-#endif
-
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
-		    : "=r" (addr) : SYM_CONSTRAINT (&s));		\
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
index 2997aa156d8e..879559057dee 100644
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
index e3947846ffcb..f254a425cb3a 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -134,8 +134,8 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	if (cpu_id == INVALID_CPU_ID)
 		return PSCI_RET_INVALID_PARAMS;
 
-	boot_args = per_cpu_ptr(hyp_symbol_addr(cpu_on_args), cpu_id);
-	init_params = per_cpu_ptr(hyp_symbol_addr(kvm_init_params), cpu_id);
+	boot_args = per_cpu_ptr(&cpu_on_args, cpu_id);
+	init_params = per_cpu_ptr(&kvm_init_params, cpu_id);
 
 	/* Check if the target CPU is already being booted. */
 	if (!try_acquire_boot_args(boot_args))
@@ -146,7 +146,7 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	wmb();
 
 	ret = psci_call(func_id, mpidr,
-			__hyp_pa(hyp_symbol_addr(kvm_hyp_cpu_entry)),
+			__hyp_pa(&kvm_hyp_cpu_entry),
 			__hyp_pa(init_params));
 
 	/* If successful, the lock will be released by the target CPU. */
@@ -165,8 +165,8 @@ static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	struct psci_boot_args *boot_args;
 	struct kvm_nvhe_init_params *init_params;
 
-	boot_args = this_cpu_ptr(hyp_symbol_addr(suspend_args));
-	init_params = this_cpu_ptr(hyp_symbol_addr(kvm_init_params));
+	boot_args = this_cpu_ptr(&suspend_args);
+	init_params = this_cpu_ptr(&kvm_init_params);
 
 	/*
 	 * No need to acquire a lock before writing to boot_args because a core
@@ -180,7 +180,7 @@ static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	 * point if it is a deep sleep state.
 	 */
 	return psci_call(func_id, power_state,
-			 __hyp_pa(hyp_symbol_addr(kvm_hyp_cpu_resume)),
+			 __hyp_pa(&kvm_hyp_cpu_resume),
 			 __hyp_pa(init_params));
 }
 
@@ -192,8 +192,8 @@ static int psci_system_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	struct psci_boot_args *boot_args;
 	struct kvm_nvhe_init_params *init_params;
 
-	boot_args = this_cpu_ptr(hyp_symbol_addr(suspend_args));
-	init_params = this_cpu_ptr(hyp_symbol_addr(kvm_init_params));
+	boot_args = this_cpu_ptr(&suspend_args);
+	init_params = this_cpu_ptr(&kvm_init_params);
 
 	/*
 	 * No need to acquire a lock before writing to boot_args because a core
@@ -204,7 +204,7 @@ static int psci_system_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 
 	/* Will only return on error. */
 	return psci_call(func_id,
-			 __hyp_pa(hyp_symbol_addr(kvm_hyp_cpu_resume)),
+			 __hyp_pa(&kvm_hyp_cpu_resume),
 			 __hyp_pa(init_params), 0);
 }
 
@@ -213,12 +213,12 @@ asmlinkage void __noreturn kvm_host_psci_cpu_entry(bool is_cpu_on)
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
2.29.2.729.g45daf8777d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
