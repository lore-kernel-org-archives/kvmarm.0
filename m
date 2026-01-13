Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9228F3815C4
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 19:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768333476; cv=none; b=jkXx2YJemm7sDeLdcZ/pCRDsiBhWrjvSKKGj/wRJVO2Ve5Yr+NP1d+j6oRyidNUQUufL4aXq4WkaZxrCnZqY1SuJ+9wlaMqzBnu3zdEXnNeWAvaquzZVWkvnM/IZuIDoaSWSFyaFm0XXIQ2LJjDbskKW8bZ4xHr9pEPTvLj64Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768333476; c=relaxed/simple;
	bh=9beGvur0hQMCRdqdbzjjb80dUCVbPaoiYXiOUDD3dNM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AWHpI0ZG6L570vhBcIWnCWv6nh1GLO4mG5SLtkiB+uIf8jHkUwWv1RQ01be5TOf1g6iNsr+qtiarxaSuYsoylNnwLSz89IY9QeJBExGBTVGoBtJHheBLAgpUMl1tWQTzGGV6YuBhdY8Z8pH/ZGt8y6DdCeuvNa53Q0ZTfoF+9D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--pekangas.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DC4LIqEu; arc=none smtp.client-ip=74.125.82.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pekangas.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DC4LIqEu"
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-11dd10b03d9so10450010c88.0
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 11:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768333474; x=1768938274; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ho649RqPWtDKTBK/otaPjQ2vodB52aFfCurSi2+zmns=;
        b=DC4LIqEuXT5Fe4o6FgmB6QGkW53xLQ4CEpVfMvRPdKsgtLyNbhWVtRfrvitxkdPJLg
         9bdZWt8FPHD0H+y8wkDyv5MYGRL2KXJvS888LaMUu0WHJl2TBXp4qqcomqed4iHxNWmK
         TGOh8dTmCPuvruPhOdo6ya6XnwwTL4lWzIcgspbmpXpesF1AokTnnML07ZId/mF/x3Mh
         10ihqiNyPGRIL4rHuUTK2hJMEXqrs7tF0aH8e1f5ddrwDtV9u876J6ubg3Y7x+S34XLB
         s1L1/Qj5E+vwbv9jKMtgcxOHaKS40/VrmtOcJZPPmJCQzGFHjT/IQ9+/htKQCO59Cugt
         Wypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768333474; x=1768938274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ho649RqPWtDKTBK/otaPjQ2vodB52aFfCurSi2+zmns=;
        b=uUeh12kViKcw8UJc8MgFGg6VnjvwZgtW428QjCTw6mGh+JqbJMLhWTLCtl8mL+4oGk
         X5wC5YpTXzilbeHOaOKZFq2935UWNc/RGRUKZSYheRcPrTO5tc25Owb1PtuqrLsqqQgq
         O/dPUe1jyrlJmzeDz6ImycABgBG0VtbkWtfkIOtAeum99jKPxOnjLgQoKLnBKOdvPOJI
         UT5Vm/icxaPir5XgF6JwFJm51DBPfJ/OZBdaz0JvgUiUxrpJZZpNtq0irfdpySPhMT3C
         6GKMUXH92YoLuVpm4oXkzQEJDQ7WCp0d/35+6OoVAaVyoukzlB16lB2x2nicxzxFytvV
         11fw==
X-Gm-Message-State: AOJu0Yy6Uxgxj9h5Wg5WjKilf4p3LPF3s0KUcFEZF0Y5hqmF/bD4zGU1
	Wj7mwxVe8YEm4GaMoUHeXbBakIxz6QdJLRkjnqxK5YWfgWv9JxVXm7iUdEFqJhisFfDBhru5A53
	ZFHUzhxGfm0jHJBZ3kMeU1NULhylWqCvdgqkH8+Jj27t0ssDBaF6KnAIp7Pc0p6bJUH75sROO6Z
	oPEQsWbIaZk5L4BhMq0Sxw/48+GqHoU3eKv19E4XKgkb7SOXU=
X-Received: from dlbcq13.prod.google.com ([2002:a05:7022:248d:b0:11d:cf4c:62ab])
 (user=pekangas job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:220b:b0:119:e56b:98bf with SMTP id a92af1059eb24-12336a82526mr109229c88.38.1768333473633;
 Tue, 13 Jan 2026 11:44:33 -0800 (PST)
Date: Tue, 13 Jan 2026 19:44:09 +0000
In-Reply-To: <20260113194409.2970324-1-pekangas@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260113194409.2970324-1-pekangas@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113194409.2970324-2-pekangas@google.com>
Subject: [PATCH v2 1/1] KVM: arm64: Calculate hyp VA size only once
From: Petteri Kangaslampi <pekangas@google.com>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Vincent Donnefort <vdonnefort@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Petteri Kangaslampi <pekangas@google.com>
Content-Type: text/plain; charset="UTF-8"

Calculate the hypervisor's VA size only once to maintain consistency
between the memory layout and MMU initialization logic. Previously the
two would be inconsistent when the kernel is configured for less than
IDMAP_VA_BITS of VA space.

Signed-off-by: Petteri Kangaslampi <pekangas@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  3 ++-
 arch/arm64/kvm/arm.c             |  4 ++--
 arch/arm64/kvm/mmu.c             | 28 ++++-----------------------
 arch/arm64/kvm/va_layout.c       | 33 +++++++++++++++++++++++++++-----
 4 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 2dc5e6e742bb..d968aca0461a 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -103,6 +103,7 @@ alternative_cb_end
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
 void kvm_compute_layout(void);
+u32 kvm_hyp_va_bits(void);
 void kvm_apply_hyp_relocations(void);
 
 #define __hyp_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)
@@ -185,7 +186,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
-int __init kvm_mmu_init(u32 *hyp_va_bits);
+int __init kvm_mmu_init(u32 hyp_va_bits);
 
 static inline void *__kvm_vector_slot2addr(void *base,
 					   enum arm64_hyp_spectre_vector slot)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4f80da0c0d1d..4703f0e15102 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2568,7 +2568,7 @@ static void pkvm_hyp_init_ptrauth(void)
 /* Inits Hyp-mode on all online CPUs */
 static int __init init_hyp_mode(void)
 {
-	u32 hyp_va_bits;
+	u32 hyp_va_bits = kvm_hyp_va_bits();
 	int cpu;
 	int err = -ENOMEM;
 
@@ -2582,7 +2582,7 @@ static int __init init_hyp_mode(void)
 	/*
 	 * Allocate Hyp PGD and setup Hyp identity mapping
 	 */
-	err = kvm_mmu_init(&hyp_va_bits);
+	err = kvm_mmu_init(hyp_va_bits);
 	if (err)
 		goto out_err;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 48d7c372a4cd..d5a506c99f73 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2284,11 +2284,9 @@ static struct kvm_pgtable_mm_ops kvm_hyp_mm_ops = {
 	.virt_to_phys		= kvm_host_pa,
 };
 
-int __init kvm_mmu_init(u32 *hyp_va_bits)
+int __init kvm_mmu_init(u32 hyp_va_bits)
 {
 	int err;
-	u32 idmap_bits;
-	u32 kernel_bits;
 
 	hyp_idmap_start = __pa_symbol(__hyp_idmap_text_start);
 	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
@@ -2302,25 +2300,7 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
 	 */
 	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
 
-	/*
-	 * The ID map is always configured for 48 bits of translation, which
-	 * may be fewer than the number of VA bits used by the regular kernel
-	 * stage 1, when VA_BITS=52.
-	 *
-	 * At EL2, there is only one TTBR register, and we can't switch between
-	 * translation tables *and* update TCR_EL2.T0SZ at the same time. Bottom
-	 * line: we need to use the extended range with *both* our translation
-	 * tables.
-	 *
-	 * So use the maximum of the idmap VA bits and the regular kernel stage
-	 * 1 VA bits to assure that the hypervisor can both ID map its code page
-	 * and map any kernel memory.
-	 */
-	idmap_bits = IDMAP_VA_BITS;
-	kernel_bits = vabits_actual;
-	*hyp_va_bits = max(idmap_bits, kernel_bits);
-
-	kvm_debug("Using %u-bit virtual addresses at EL2\n", *hyp_va_bits);
+	kvm_debug("Using %u-bit virtual addresses at EL2\n", hyp_va_bits);
 	kvm_debug("IDMAP page: %lx\n", hyp_idmap_start);
 	kvm_debug("HYP VA range: %lx:%lx\n",
 		  kern_hyp_va(PAGE_OFFSET),
@@ -2345,7 +2325,7 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
 		goto out;
 	}
 
-	err = kvm_pgtable_hyp_init(hyp_pgtable, *hyp_va_bits, &kvm_hyp_mm_ops);
+	err = kvm_pgtable_hyp_init(hyp_pgtable, hyp_va_bits, &kvm_hyp_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
@@ -2354,7 +2334,7 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
 		goto out_destroy_pgtable;
 
 	io_map_base = hyp_idmap_start;
-	__hyp_va_bits = *hyp_va_bits;
+	__hyp_va_bits = hyp_va_bits;
 	return 0;
 
 out_destroy_pgtable:
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 91b22a014610..2346f9435a71 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -46,9 +46,31 @@ static void init_hyp_physvirt_offset(void)
 	hyp_physvirt_offset = (s64)__pa(kern_va) - (s64)hyp_va;
 }
 
+/*
+ * Calculate the actual VA size used by the hypervisor
+ */
+__init u32 kvm_hyp_va_bits(void)
+{
+	/*
+	 * The ID map is always configured for 48 bits of translation, which may
+	 * be different from the number of VA bits used by the regular kernel
+	 * stage 1.
+	 *
+	 * At EL2, there is only one TTBR register, and we can't switch between
+	 * translation tables *and* update TCR_EL2.T0SZ at the same time. Bottom
+	 * line: we need to use the extended range with *both* our translation
+	 * tables.
+	 *
+	 * So use the maximum of the idmap VA bits and the regular kernel stage
+	 * 1 VA bits as the hypervisor VA size to assure that the hypervisor can
+	 * both ID map its code page and map any kernel memory.
+	 */
+	return max(IDMAP_VA_BITS, vabits_actual);
+}
+
 /*
  * We want to generate a hyp VA with the following format (with V ==
- * vabits_actual):
+ * hypervisor VA bits):
  *
  *  63 ... V |     V-1    | V-2 .. tag_lsb | tag_lsb - 1 .. 0
  *  ---------------------------------------------------------
@@ -61,10 +83,11 @@ __init void kvm_compute_layout(void)
 {
 	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
 	u64 hyp_va_msb;
+	u32 hyp_va_bits = kvm_hyp_va_bits();
 
 	/* Where is my RAM region? */
-	hyp_va_msb  = idmap_addr & BIT(vabits_actual - 1);
-	hyp_va_msb ^= BIT(vabits_actual - 1);
+	hyp_va_msb  = idmap_addr & BIT(hyp_va_bits - 1);
+	hyp_va_msb ^= BIT(hyp_va_bits - 1);
 
 	tag_lsb = fls64((u64)phys_to_virt(memblock_start_of_DRAM()) ^
 			(u64)(high_memory - 1));
@@ -72,9 +95,9 @@ __init void kvm_compute_layout(void)
 	va_mask = GENMASK_ULL(tag_lsb - 1, 0);
 	tag_val = hyp_va_msb;
 
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb != (vabits_actual - 1)) {
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb != (hyp_va_bits - 1)) {
 		/* We have some free bits to insert a random tag. */
-		tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
+		tag_val |= get_random_long() & GENMASK_ULL(hyp_va_bits - 2, tag_lsb);
 	}
 	tag_val >>= tag_lsb;
 
-- 
2.52.0.457.g6b5491de43-goog

