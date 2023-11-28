Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1165788D
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TObP6ENQ"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5cd2100f467so71758817b3.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 06:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701180245; x=1701785045; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M5ruBIinMPKJlukHAHCPwm8Qh97z9k2/3LbeTzmgDgg=;
        b=TObP6ENQjkTbb8QXmWapMERdayoyfnEaSuAb1ttmTHt4CErhrnM8sb/Hsx1m3xpyiT
         yhTkXC+Wrwub3e5XQKVz6dn+NU6Fp2F4z4wSkeoJFZA1PMWuuzo0ARhVleLJx9iK8Cmt
         GdNuPONz4s1uXpVYnKw5Pj1T6EsBOMMZUBBX6o5E56yb3xOboIzMqEO2mq7O45d4a9C9
         I+7+n4ALzRKOfOVoSY9lUH2nBta4qXAtPUlVU90vRtAPHpD5pH282TaDOTTBjfdysieF
         VAxFI09zOhlm8o1K2xp04B47LS8OR0miPuqQyY5k1SJSvdkH45X4IXHMgjaBWqr6XmZ+
         z+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701180245; x=1701785045;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M5ruBIinMPKJlukHAHCPwm8Qh97z9k2/3LbeTzmgDgg=;
        b=W2WUbqlqgoNbug+oxHhz2/V7vkAhWRWERz9VIYxdtSbYt19JvK/bjKJw0m/3yoEX9/
         1mzSNfY3v5s1tlyqUN0ceIYRra2EYGyS2Z+K4XtU4EADS4muLcqbaCpcaCdgeb8YG9K2
         pl4l5sGIbEKIWxMeGyNYBfuKQ/PQWZpkkYF1p3nqeFQ7hdFl6djqoI65Bu9AoPXgP5I0
         JuN4Ip5o+gHiurP/PmU4geTGWwqjUFZdJPol8iigDjR1nj/TjXkS1ifrxcjNHkRGpr4r
         IED7s0CWwjkT2W2iMPovnuuAsNonBaUSjeI8h99M6H7BD/6gYv+SNq5M41W8+tUnbdgO
         uFQA==
X-Gm-Message-State: AOJu0Yw2sA0t4lqcSem6+ojfw9zQiR7BuarrzbUbEg43u23sHMPWZiHb
	erRGKPSUztm8zofRQsaxbGDqSueb
X-Google-Smtp-Source: AGHT+IHZQRFzyL/8vbeaW/6SPareZpgpy1k+vWPIarKyBNnQY6gPYEVmPO3cTlOPsNIR7XFDpBhqNVqK
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:690c:903:b0:59b:eb63:4beb with SMTP id
 cb3-20020a05690c090300b0059beb634bebmr522738ywb.7.1701180244776; Tue, 28 Nov
 2023 06:04:04 -0800 (PST)
Date: Tue, 28 Nov 2023 15:04:01 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=10761; i=ardb@kernel.org;
 h=from:subject; bh=a/xfvZ3Um+C+qD3HlmL/KtezhqvltCPQ2uIyZa9KCt0=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JITX1c4CUUbhyqCKbxpW93dtENpzoOZr9VFe2YJP26oMzr
 8r+DnrTUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACayRJuRoTttQvLDRbPePrg4
 u/ZTQe6MyJPhBolRklIRz//JLUn51czIsF3k63zBJwsm3ngvxf3Q83l2l1HhR0HOD9sm8UaJ/z3 dygIA
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231128140400.3132145-2-ardb@google.com>
Subject: [PATCH] KVM: arm64: Use helpers to classify exception types reported
 via ESR
From: Ard Biesheuvel <ardb@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Currently, we rely on the fact that exceptions can be trivially
classified by applying a mask/value pair to the syndrome value reported
via the ESR register, but this will no longer be true once we enable
support for 5 level paging.

So introduce a couple of helpers that encapsulate this mask/value pair
matching, and wire them up in the code. No functional change intended,
the actual handling of translation level -1 will be added in a
subsequent patch.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
Upon Marc's request, I have separated this from my LPA2 series so it
can be taken via the KVM tree directly (upon which the next rev of my
LPA2 series is going to depend in any case)

 arch/arm64/include/asm/esr.h            | 15 ++++++++
 arch/arm64/include/asm/kvm_emulate.h    | 36 +++++++++-----------
 arch/arm64/kvm/hyp/include/hyp/fault.h  |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/mmu.c                    | 35 +++++++++----------
 5 files changed, 50 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index ae35939f395b..450bf8fc908e 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -392,6 +392,21 @@ static inline bool esr_is_data_abort(unsigned long esr)
 	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
 }
 
+static inline bool esr_is_translation_fault(unsigned long esr)
+{
+	return (esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_FAULT;
+}
+
+static inline bool esr_is_permission_fault(unsigned long esr)
+{
+	return (esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_PERM;
+}
+
+static inline bool esr_is_access_flag_fault(unsigned long esr)
+{
+	return (esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_ACCESS;
+}
+
 const char *esr_get_class_string(unsigned long esr);
 #endif /* __ASSEMBLY */
 
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d4f1e9cdd554..9b141452b6d7 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -404,24 +404,25 @@ static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
 	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC;
 }
 
-static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
+static inline
+bool kvm_vcpu_trap_is_permission_fault(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_TYPE;
+	return esr_is_permission_fault(kvm_vcpu_get_esr(vcpu));
 }
 
-static __always_inline s8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
+static inline
+bool kvm_vcpu_trap_is_translation_fault(const struct kvm_vcpu *vcpu)
 {
-	/*
-	 * Note: With the introduction of FEAT_LPA2 an extra level of
-	 * translation (level -1) is added. This level (obviously) doesn't
-	 * follow the previous convention of encoding the 4 levels in the 2 LSBs
-	 * of the FSC so this function breaks if the fault is for level -1.
-	 *
-	 * However, stage2 tables always use concatenated tables for first level
-	 * lookup and therefore it is guaranteed that the level will be between
-	 * 0 and 3, and this function continues to work.
-	 */
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_LEVEL;
+	return esr_is_translation_fault(kvm_vcpu_get_esr(vcpu));
+}
+
+static inline
+u64 kvm_vcpu_trap_get_perm_fault_granule(const struct kvm_vcpu *vcpu)
+{
+	unsigned long esr = kvm_vcpu_get_esr(vcpu);
+
+	BUG_ON(!esr_is_permission_fault(esr));
+	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(esr & ESR_ELx_FSC_LEVEL));
 }
 
 static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
@@ -464,12 +465,7 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 		 * first), then a permission fault to allow the flags
 		 * to be set.
 		 */
-		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
-		case ESR_ELx_FSC_PERM:
-			return true;
-		default:
-			return false;
-		}
+		return kvm_vcpu_trap_is_permission_fault(vcpu);
 	}
 
 	if (kvm_vcpu_trap_is_iabt(vcpu))
diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
index 9ddcfe2c3e57..18b0ffbc40a2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/fault.h
+++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
@@ -60,7 +60,7 @@ static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
 	 */
 	if (!(esr & ESR_ELx_S1PTW) &&
 	    (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
-	     (esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_PERM)) {
+	     esr_is_permission_fault(esr))) {
 		if (!__translate_far_to_hpfar(far, &hpfar))
 			return false;
 	} else {
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f99d8af0b9af..f44fb11307fb 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -591,7 +591,7 @@ static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
 		bool valid;
 
-		valid = kvm_vcpu_trap_get_fault_type(vcpu) == ESR_ELx_FSC_FAULT &&
+		valid = kvm_vcpu_trap_is_translation_fault(vcpu) &&
 			kvm_vcpu_dabt_isvalid(vcpu) &&
 			!kvm_vcpu_abt_issea(vcpu) &&
 			!kvm_vcpu_abt_iss1tw(vcpu);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 986a2e6fb900..bdf2a1f0f6a9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1376,7 +1376,7 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  unsigned long fault_status)
+			  bool fault_is_perm)
 {
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
@@ -1390,17 +1390,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	s8 fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 
-	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
+	if (fault_is_perm)
+		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_BUG_ON(write_fault && exec_fault);
 
-	if (fault_status == ESR_ELx_FSC_PERM && !write_fault && !exec_fault) {
+	if (fault_is_perm && !write_fault && !exec_fault) {
 		kvm_err("Unexpected L2 read permission error\n");
 		return -EFAULT;
 	}
@@ -1411,8 +1411,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	if (fault_status != ESR_ELx_FSC_PERM ||
-	    (logging_active && write_fault)) {
+	if (!fault_is_perm || (logging_active && write_fault)) {
 		ret = kvm_mmu_topup_memory_cache(memcache,
 						 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
 		if (ret)
@@ -1529,8 +1528,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * backed by a THP and thus use block mapping if possible.
 	 */
 	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
-		if (fault_status ==  ESR_ELx_FSC_PERM &&
-		    fault_granule > PAGE_SIZE)
+		if (fault_is_perm && fault_granule > PAGE_SIZE)
 			vma_pagesize = fault_granule;
 		else
 			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
@@ -1543,7 +1541,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 	}
 
-	if (fault_status != ESR_ELx_FSC_PERM && !device && kvm_has_mte(kvm)) {
+	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
 		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
@@ -1569,7 +1567,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault_status == ESR_ELx_FSC_PERM && vma_pagesize == fault_granule)
+	if (fault_is_perm && vma_pagesize == fault_granule)
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
 	else
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
@@ -1620,7 +1618,7 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
  */
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 {
-	unsigned long fault_status;
+	unsigned long esr;
 	phys_addr_t fault_ipa;
 	struct kvm_memory_slot *memslot;
 	unsigned long hva;
@@ -1628,12 +1626,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int ret, idx;
 
-	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
+	esr = kvm_vcpu_get_esr(vcpu);
 
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
-	if (fault_status == ESR_ELx_FSC_FAULT) {
+	if (esr_is_permission_fault(esr)) {
 		/* Beyond sanitised PARange (which is the IPA limit) */
 		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
 			kvm_inject_size_fault(vcpu);
@@ -1668,9 +1666,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
 	/* Check the stage-2 fault is trans. fault or write fault */
-	if (fault_status != ESR_ELx_FSC_FAULT &&
-	    fault_status != ESR_ELx_FSC_PERM &&
-	    fault_status != ESR_ELx_FSC_ACCESS) {
+	if (!esr_is_translation_fault(esr) &&
+	    !esr_is_permission_fault(esr) &&
+	    !esr_is_access_flag_fault(esr)) {
 		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
 			kvm_vcpu_trap_get_class(vcpu),
 			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
@@ -1732,13 +1730,14 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	/* Userspace should not be able to register out-of-bounds IPAs */
 	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->arch.hw_mmu));
 
-	if (fault_status == ESR_ELx_FSC_ACCESS) {
+	if (esr_is_access_flag_fault(esr)) {
 		handle_access_fault(vcpu, fault_ipa);
 		ret = 1;
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
+	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva,
+			     esr_is_permission_fault(esr));
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.43.0.rc1.413.gea7ed67945-goog

