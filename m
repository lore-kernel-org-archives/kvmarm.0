Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA13E414A0F;
	Thu, 16 Jul 2026 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210994; cv=none; b=NuLlqiiCWmQyLQ6amMyDt8AMWiQih5sw7JTbFr/Kysi1WyRZ92Xxgs1ZQBsAk7ChfB4iOUQ5caZehW2fmE+ekiN1jNc19TTXRNyIC19wpRqZx2nGIl8GKulBkEo7WjsvPUHQYyDVNKt7W5Cp5S8bNlKZzUyyOHNXajYRxcEt6iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210994; c=relaxed/simple;
	bh=GctVr1DgD6Jz34y6GPxpYmwKbkU1HBpG+IhUiTfroCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+RasJy1OYPWJMQ80lqTwd87jGlG9ntRHvjhsMBsLh5WoZdo8/1Mc3Ar7nGJVFk2PxVgCM50iygrt6mXnn9091n9pOBgmrkGRlvYaO9Ai3dPCq2EZmlCEd7ZA7lBIwOjM373fPHk5lJLJ9AGdsovrtYq3k2vEVbujDfLb5rU+pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A67Yizku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A67Yizku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281F31F00A3A;
	Thu, 16 Jul 2026 14:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784210992;
	bh=jCeHexlG946Nk3LJkXBgsYOFeHolftNzDBMOUV6Plgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A67YizkuSaQzd14Fkiw3HkuWSsg3eRQhzLwXaXFF5VkzQX9jIgfYbaEP9SyjcqqH2
	 fgPS0zJKtIENwH+hdF2qVgiYMAzEV1r9W8jEE7j5UJTzY6JFhD3cM+RYevXfeaOdct
	 PY2OkmglSBtMPB688v5H6bAwXcDHy0n3QqWL3m4hcluEJTkscsglvBLFny8xAXOBYa
	 uFp+zKpChPg05TRS59JX8H6hWdAnIljnbYwMeOJ6iabeHRf4VyuFqI0YYc06q+eJXh
	 RuFXkKyJLHbAT/Ri3Ys3D1KficczmUQb3KcvljZ5UG1M5vih3ldj0mudYjczpLDPgg
	 Va+/8tKVUv/uQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [RFC PATCH 1/5] KVM: arm64: Make hyp symbol address conversion explicit
Date: Thu, 16 Jul 2026 19:39:32 +0530
Message-ID: <20260716140936.4003182-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260716140936.4003182-1-aneesh.kumar@kernel.org>
References: <20260716140936.4003182-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_ksym_ref() and kvm_ksym_ref_nvhe() have confusing names which do not
clearly describe the address conversion they perform.

Replace them with kvm_hyp_kimg_kaddr() for selecting the kernel address
of a hyp symbol and kern_sym_hyp_va() for obtaining its hyp VA. Use
lm_alias() directly where a linear-map address is required.

This is a naming cleanup with no functional change.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h | 10 ---------
 arch/arm64/include/asm/kvm_mmu.h | 33 +++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c             | 38 ++++++++++++++++----------------
 arch/arm64/kvm/va_layout.c       |  2 +-
 4 files changed, 53 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78..6e0cc007bfe1 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -233,16 +233,6 @@ struct kvm_nvhe_stacktrace_info {
 	unsigned long pc;
 };
 
-/* Translate a kernel address @ptr into its equivalent linear mapping */
-#define kvm_ksym_ref(ptr)						\
-	({								\
-		void *val = (ptr);					\
-		if (!is_kernel_in_hyp_mode())				\
-			val = lm_alias((ptr));				\
-		val;							\
-	 })
-#define kvm_ksym_ref_nvhe(sym)	kvm_ksym_ref(kvm_nvhe_sym(sym))
-
 struct kvm;
 struct kvm_vcpu;
 struct kvm_s2_mmu;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6eae7e7e2a68..6b708ff176fd 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -107,6 +107,28 @@ u32 kvm_hyp_va_bits(void);
 void kvm_apply_hyp_relocations(void);
 
 #define __hyp_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)
+/**
+ * kvm_hyp_kimg_kaddr - Select the kernel address used for an EL2 mapping
+ * @ptr: Address within the kernel image
+ *
+ * Return @ptr when EL2 uses the kernel-image address directly, as with
+ * VHE. Otherwise return the corresponding linear-map alias used as input
+ * to the legacy nVHE VA conversion.
+ *
+ * Return: A kernel address suitable as the basis for an EL2 virtual address.
+ */
+static __always_inline void *kvm_hyp_kimg_kaddr(void *ptr)
+{
+	/*
+	 * With VHE, the host runs at EL2 using the kernel mapping, so
+	 * kernel-image VAs need no translation.
+	 * Only legacy nVHE requires a linear-map alias.
+	 */
+	if (is_kernel_in_hyp_mode())
+		return ptr;
+
+	return lm_alias(ptr);
+}
 
 /*
  * Convert a kernel VA into a HYP VA.
@@ -140,6 +162,17 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 
 #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
 
+/**
+ * kern_sym_hyp_va - Convert a kernel image symbol address to its runtime hyp VA
+ * @ptr: Address of a symbol in the kernel image
+ *
+ * Return: The runtime hyp virtual address corresponding to @ptr.
+ */
+static __always_inline void *kern_sym_hyp_va(void *ptr)
+{
+	return kern_hyp_va(kvm_hyp_kimg_kaddr(ptr));
+}
+
 extern u32 __hyp_va_bits;
 
 /*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..e1613186efb0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2105,10 +2105,10 @@ static int kvm_init_vector_slots(void)
 	int err;
 	void *base;
 
-	base = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
+	base = kern_sym_hyp_va(__kvm_hyp_vector);
 	kvm_init_vector_slot(base, HYP_VECTOR_DIRECT);
 
-	base = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
+	base = kern_sym_hyp_va(__bp_harden_hyp_vecs);
 	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_DIRECT);
 
 	if (kvm_system_needs_idmapped_vectors() &&
@@ -2136,7 +2136,7 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	 * Also drop the KASAN tag which gets in the way...
 	 */
 	params->tpidr_el2 = (unsigned long)kasan_reset_tag(per_cpu_ptr_nvhe_sym(__per_cpu_start, cpu)) -
-			    (unsigned long)kvm_ksym_ref(CHOOSE_NVHE_SYM(__per_cpu_start));
+			    (unsigned long)kvm_hyp_kimg_kaddr(CHOOSE_NVHE_SYM(__per_cpu_start));
 
 	params->mair_el2 = read_sysreg(mair_el1);
 
@@ -2532,13 +2532,13 @@ static void __init teardown_hyp_mode(void)
 
 static int __init do_pkvm_init(u32 hyp_va_bits)
 {
-	void *per_cpu_base = kvm_ksym_ref(kvm_nvhe_sym(kvm_arm_hyp_percpu_base));
+	void *per_cpu_base = kvm_nvhe_sym(kvm_arm_hyp_percpu_base);
 	int ret;
 
 	preempt_disable();
 	cpu_hyp_init_context();
 	ret = kvm_call_hyp_nvhe(__pkvm_init, hyp_mem_base, hyp_mem_size,
-				kern_hyp_va(per_cpu_base),
+				kern_sym_hyp_va(per_cpu_base),
 				hyp_va_bits);
 	cpu_hyp_init_features();
 
@@ -2611,8 +2611,8 @@ static void kvm_hyp_init_symbols(void)
 	 * Flush entire BSS since part of its data containing init symbols is read
 	 * while the MMU is off.
 	 */
-	kvm_flush_dcache_to_poc(kvm_ksym_ref(__hyp_bss_start),
-				kvm_ksym_ref(__hyp_bss_end) - kvm_ksym_ref(__hyp_bss_start));
+	kvm_flush_dcache_to_poc(lm_alias(__hyp_bss_start),
+				lm_alias(__hyp_bss_end) - lm_alias(__hyp_bss_start));
 }
 
 static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
@@ -2772,29 +2772,29 @@ static int __init init_hyp_mode(void)
 	/*
 	 * Map the Hyp-code called directly from the host
 	 */
-	err = create_hyp_mappings(kvm_ksym_ref(__hyp_text_start),
-				  kvm_ksym_ref(__hyp_text_end), PAGE_HYP_EXEC);
+	err = create_hyp_mappings(kvm_hyp_kimg_kaddr(__hyp_text_start),
+				  kvm_hyp_kimg_kaddr(__hyp_text_end), PAGE_HYP_EXEC);
 	if (err) {
 		kvm_err("Cannot map world-switch code\n");
 		goto out_err;
 	}
 
-	err = create_hyp_mappings(kvm_ksym_ref(__hyp_data_start),
-				  kvm_ksym_ref(__hyp_data_end), PAGE_HYP);
+	err = create_hyp_mappings(kvm_hyp_kimg_kaddr(__hyp_data_start),
+				  kvm_hyp_kimg_kaddr(__hyp_data_end), PAGE_HYP);
 	if (err) {
 		kvm_err("Cannot map .hyp.data section\n");
 		goto out_err;
 	}
 
-	err = create_hyp_mappings(kvm_ksym_ref(__hyp_rodata_start),
-				  kvm_ksym_ref(__hyp_rodata_end), PAGE_HYP_RO);
+	err = create_hyp_mappings(kvm_hyp_kimg_kaddr(__hyp_rodata_start),
+				  kvm_hyp_kimg_kaddr(__hyp_rodata_end), PAGE_HYP_RO);
 	if (err) {
 		kvm_err("Cannot map .hyp.rodata section\n");
 		goto out_err;
 	}
 
-	err = create_hyp_mappings(kvm_ksym_ref(__start_rodata),
-				  kvm_ksym_ref(__end_rodata), PAGE_HYP_RO);
+	err = create_hyp_mappings(kvm_hyp_kimg_kaddr(__start_rodata),
+				  kvm_hyp_kimg_kaddr(__end_rodata), PAGE_HYP_RO);
 	if (err) {
 		kvm_err("Cannot map rodata section\n");
 		goto out_err;
@@ -2805,15 +2805,15 @@ static int __init init_hyp_mode(void)
 	 * section thanks to an assertion in the linker script. Map it RW and
 	 * the rest of .bss RO.
 	 */
-	err = create_hyp_mappings(kvm_ksym_ref(__hyp_bss_start),
-				  kvm_ksym_ref(__hyp_bss_end), PAGE_HYP);
+	err = create_hyp_mappings(kvm_hyp_kimg_kaddr(__hyp_bss_start),
+				  kvm_hyp_kimg_kaddr(__hyp_bss_end), PAGE_HYP);
 	if (err) {
 		kvm_err("Cannot map hyp bss section: %d\n", err);
 		goto out_err;
 	}
 
-	err = create_hyp_mappings(kvm_ksym_ref(__hyp_bss_end),
-				  kvm_ksym_ref(__bss_stop), PAGE_HYP_RO);
+	err = create_hyp_mappings(kvm_hyp_kimg_kaddr(__hyp_bss_end),
+				  kvm_hyp_kimg_kaddr(__bss_stop), PAGE_HYP_RO);
 	if (err) {
 		kvm_err("Cannot map bss section\n");
 		goto out_err;
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 2346f9435a71..63bb58a7868a 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -223,7 +223,7 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 	/*
 	 * Compute HYP VA by using the same computation as kern_hyp_va()
 	 */
-	addr = __early_kern_hyp_va((u64)kvm_ksym_ref(__kvm_hyp_vector));
+	addr = __early_kern_hyp_va((u64)kvm_hyp_kimg_kaddr(__kvm_hyp_vector));
 
 	/* Use PC[10:7] to branch to the same vector in KVM */
 	addr |= ((u64)origptr & GENMASK_ULL(10, 7));
-- 
2.43.0

