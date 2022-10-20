Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535F93C20
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 13:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E51C433D7;
	Thu, 20 Oct 2022 13:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666273195;
	bh=pvaYXug0hNpmDYywZvDH12QrW2BGInmPiwQ9xyFQG5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgsUoBbNxt1OpVNwNpkVkXQr/oZ1c2ibTvbv05j1fEDCxcDyp+EOgF2/6YNrjhs9U
	 Dm7fYDE0ksN/J4hH7rBQwaV459l5b4iuHCHGiaUyeUbz+prUTX3edFrZgWkSRFYkzH
	 61NrqPj+s/YD13MEOyw1pFj+ebW4oCn9CFHenNVUMEMc2gNf/u6yKW2JNZ4byCiXyZ
	 GJ24aft3KzUecl0LyPiEm7uJPJJZpN6BXZKr97AKyCeWwqETfnRg/1NGreY6Los5WF
	 T3GaDGcOT9sJ6iPOGCwOTpg/BWZ6R27nKvQZdHyKqyHAkszUW4DS+4A7Kn/iSGXXZx
	 7TYoGR6JUTwMA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Quentin Perret <qperret@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kernel-team@android.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 21/25] KVM: arm64: Unmap 'kvm_arm_hyp_percpu_base' from the host
Date: Thu, 20 Oct 2022 14:38:23 +0100
Message-Id: <20221020133827.5541-22-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221020133827.5541-1-will@kernel.org>
References: <20221020133827.5541-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Quentin Perret <qperret@google.com>

When pKVM is enabled, the hypervisor at EL2 does not trust the host at
EL1 and must therefore prevent it from having unrestricted access to
internal hypervisor state.

The 'kvm_arm_hyp_percpu_base' array holds the offsets for hypervisor
per-cpu allocations, so move this this into the nVHE code where it
cannot be modified by the untrusted host at EL1.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h  | 4 ++--
 arch/arm64/kernel/image-vars.h    | 3 ---
 arch/arm64/kvm/arm.c              | 9 ++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 2 ++
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index de52ba775d48..43c3bc0f9544 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -109,7 +109,7 @@ enum __kvm_host_smccc_func {
 #define per_cpu_ptr_nvhe_sym(sym, cpu)						\
 	({									\
 		unsigned long base, off;					\
-		base = kvm_arm_hyp_percpu_base[cpu];				\
+		base = kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu];		\
 		off = (unsigned long)&CHOOSE_NVHE_SYM(sym) -			\
 		      (unsigned long)&CHOOSE_NVHE_SYM(__per_cpu_start);		\
 		base ? (typeof(CHOOSE_NVHE_SYM(sym))*)(base + off) : NULL;	\
@@ -214,7 +214,7 @@ DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
 #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
 #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
 
-extern unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
+extern unsigned long kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[];
 DECLARE_KVM_NVHE_SYM(__per_cpu_start);
 DECLARE_KVM_NVHE_SYM(__per_cpu_end);
 
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 7f4e43bfaade..ae8f37f4aa8c 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -89,9 +89,6 @@ KVM_NVHE_ALIAS(gic_nonsecure_priorities);
 KVM_NVHE_ALIAS(__start___kvm_ex_table);
 KVM_NVHE_ALIAS(__stop___kvm_ex_table);
 
-/* Array containing bases of nVHE per-CPU memory regions. */
-KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
-
 /* PMU available static key */
 #ifdef CONFIG_HW_PERF_EVENTS
 KVM_NVHE_ALIAS(kvm_arm_pmu_available);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f78eefa02f6b..25467f24803d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -51,7 +51,6 @@ DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
-unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 static bool vgic_present;
@@ -1857,13 +1856,13 @@ static void teardown_hyp_mode(void)
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
@@ -1967,7 +1966,7 @@ static int init_hyp_mode(void)
 
 		page_addr = page_address(page);
 		memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size());
-		kvm_arm_hyp_percpu_base[cpu] = (unsigned long)page_addr;
+		kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu] = (unsigned long)page_addr;
 	}
 
 	/*
@@ -2060,7 +2059,7 @@ static int init_hyp_mode(void)
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
2.38.0.413.g74048e4d9e-goog

