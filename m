Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C269DC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:44:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF0F4B211;
	Thu, 19 May 2022 09:44:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WtSjVsDwxY9v; Thu, 19 May 2022 09:44:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 336C94B3EC;
	Thu, 19 May 2022 09:44:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E786E4B211
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KtFMS3z8DICd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:44:46 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA0244B28D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:46 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 53301B824A6;
 Thu, 19 May 2022 13:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2201C385AA;
 Thu, 19 May 2022 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967884;
 bh=4phMg5qKrrVOBZXC4vAMZ7uzsL/5lQSk91h6zsw+z5Q=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=eYWUF7O+dZINKj8uUBJpxtiB+gKrfEI/2nL7l0N2Lr5z7rDx+cb0dAwDbLOcrYoGY
 WWM9Ip1wrYt2oIR8x34eqWc/uKJatACQ3BBWo6RdvTSOcuoRNh8aZriG5Ap+nN4Cc4
 sGlX1GkSoza2sWPCH+ZnmulcJRnnGkgoDUokF5hSoWC4MdHyh1CaQUtqIbf1Pq2/cj
 44Oo9U2tqWNRXFu64vNzoRvFXHZ4k1EXABMGdZjLMcNNM95bacGWt9AFeQcQkDtmaS
 SexpSKJc2RvTJ75aUFSaXQ8Bz2JU2uOph3beGtY23t+1DAaeC55ZnsUby52r1F2Ij4
 /DfDowgaTA3fw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 35/89] KVM: arm64: Unmap kvm_arm_hyp_percpu_base from the host
Date: Thu, 19 May 2022 14:41:10 +0100
Message-Id: <20220519134204.5379-36-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
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
---
 arch/arm64/include/asm/kvm_asm.h  | 4 ++--
 arch/arm64/kernel/image-vars.h    | 3 ---
 arch/arm64/kvm/arm.c              | 9 ++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 2 ++
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 931a351da3f2..35b9d590bb74 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -110,7 +110,7 @@ enum __kvm_host_smccc_func {
 #define per_cpu_ptr_nvhe_sym(sym, cpu)						\
 	({									\
 		unsigned long base, off;					\
-		base = kvm_arm_hyp_percpu_base[cpu];				\
+		base = kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu];		\
 		off = (unsigned long)&CHOOSE_NVHE_SYM(sym) -			\
 		      (unsigned long)&CHOOSE_NVHE_SYM(__per_cpu_start);		\
 		base ? (typeof(CHOOSE_NVHE_SYM(sym))*)(base + off) : NULL;	\
@@ -198,7 +198,7 @@ DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
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
index 5b41551a978b..c7b362db692f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -51,7 +51,6 @@ DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
-unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 static bool vgic_present;
@@ -1800,13 +1799,13 @@ static void teardown_hyp_mode(void)
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
@@ -1907,7 +1906,7 @@ static int init_hyp_mode(void)
 
 		page_addr = page_address(page);
 		memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size());
-		kvm_arm_hyp_percpu_base[cpu] = (unsigned long)page_addr;
+		kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu] = (unsigned long)page_addr;
 	}
 
 	/*
@@ -1968,7 +1967,7 @@ static int init_hyp_mode(void)
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
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
