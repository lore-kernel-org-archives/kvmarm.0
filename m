Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BFEC43334
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jun 2022 13:59:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A10A4B4A8;
	Thu, 30 Jun 2022 09:59:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 44DCO7FjRUxw; Thu, 30 Jun 2022 09:59:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A819C4B4C6;
	Thu, 30 Jun 2022 09:59:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 122184B378
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:59:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iSvM4n-SD5jo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 09:59:15 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4035B4B49B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:59:15 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id DAB54B82AF8;
 Thu, 30 Jun 2022 13:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464A5C341D0;
 Thu, 30 Jun 2022 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656597553;
 bh=iwY971UQlP6XyQNLg8Rxql9axBhgXqtqK6Nz3Ky5qwk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=YkUO4LZzjk1DoBdQROa5avkgKAVygOgVS8aFczH5nw4I8ZkJExZU6kSDQn9Io5Gi7
 Bx4CFY31w+Tu3ZnKf2faBW7N6k9rZ5JI/kO09g1V9hCWOQIu9rsUU2dFgsnqmLE3O3
 fq0Bje0/4rjFomB4cubNY2Lk4EdXz4kF2L+AXHypKCdyyMm8AR3bA49jfF24nKQI/r
 DefptzkS7BO9lmHYqNSCARffXpJ9NeqdCyczhwMpxFql5F/EXuoDMCLN31QIdLbl0d
 mZc6DQmiuRpq4rvc0iFYJx5x+QUJ6WOA1h9PcqxDiL36vqF5oyxkeqOdOwygUR1aUK
 wQrOYoHhdpCAg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 20/24] KVM: arm64: Unmap kvm_arm_hyp_percpu_base from the
 host
Date: Thu, 30 Jun 2022 14:57:43 +0100
Message-Id: <20220630135747.26983-21-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

In pKVM mode, we can't trust the host not to mess with the hypervisor
per-cpu offsets, so let's move the array containing them to the nVHE
code.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h  | 4 ++--
 arch/arm64/kernel/image-vars.h    | 3 ---
 arch/arm64/kvm/arm.c              | 9 ++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 2 ++
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index fac4ed699913..d92f2ccae74c 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -108,7 +108,7 @@ enum __kvm_host_smccc_func {
 #define per_cpu_ptr_nvhe_sym(sym, cpu)						\
 	({									\
 		unsigned long base, off;					\
-		base = kvm_arm_hyp_percpu_base[cpu];				\
+		base = kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu];		\
 		off = (unsigned long)&CHOOSE_NVHE_SYM(sym) -			\
 		      (unsigned long)&CHOOSE_NVHE_SYM(__per_cpu_start);		\
 		base ? (typeof(CHOOSE_NVHE_SYM(sym))*)(base + off) : NULL;	\
@@ -197,7 +197,7 @@ DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
 #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
 #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
 
-extern unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
+extern unsigned long kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[];
 DECLARE_KVM_NVHE_SYM(__per_cpu_start);
 DECLARE_KVM_NVHE_SYM(__per_cpu_end);
 
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 4e3b6d618ac1..37a2d833851a 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -102,9 +102,6 @@ KVM_NVHE_ALIAS(gic_nonsecure_priorities);
 KVM_NVHE_ALIAS(__start___kvm_ex_table);
 KVM_NVHE_ALIAS(__stop___kvm_ex_table);
 
-/* Array containing bases of nVHE per-CPU memory regions. */
-KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
-
 /* PMU available static key */
 #ifdef CONFIG_HW_PERF_EVENTS
 KVM_NVHE_ALIAS(kvm_arm_pmu_available);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90e0e7f38bb5..1934fcb2c2d3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -51,7 +51,6 @@ DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
-unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 static bool vgic_present;
@@ -1865,13 +1864,13 @@ static void teardown_hyp_mode(void)
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu) {
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
-		free_pages(kvm_arm_hyp_percpu_base[cpu], nvhe_percpu_order());
+		free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
 	}
 }
 
 static int do_pkvm_init(u32 hyp_va_bits)
 {
-	void *per_cpu_base = kvm_ksym_ref(kvm_arm_hyp_percpu_base);
+	void *per_cpu_base = kvm_ksym_ref(kvm_nvhe_sym(kvm_arm_hyp_percpu_base));
 	int ret;
 
 	preempt_disable();
@@ -1975,7 +1974,7 @@ static int init_hyp_mode(void)
 
 		page_addr = page_address(page);
 		memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size());
-		kvm_arm_hyp_percpu_base[cpu] = (unsigned long)page_addr;
+		kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu] = (unsigned long)page_addr;
 	}
 
 	/*
@@ -2068,7 +2067,7 @@ static int init_hyp_mode(void)
 	}
 
 	for_each_possible_cpu(cpu) {
-		char *percpu_begin = (char *)kvm_arm_hyp_percpu_base[cpu];
+		char *percpu_begin = (char *)kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu];
 		char *percpu_end = percpu_begin + nvhe_percpu_size();
 
 		/* Map Hyp percpu pages */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 9f54833af400..04d194583f1e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -23,6 +23,8 @@ u64 cpu_logical_map(unsigned int cpu)
 	return hyp_cpu_logical_map[cpu];
 }
 
+unsigned long __ro_after_init kvm_arm_hyp_percpu_base[NR_CPUS];
+
 unsigned long __hyp_per_cpu_offset(unsigned int cpu)
 {
 	unsigned long *cpu_base_array;
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
