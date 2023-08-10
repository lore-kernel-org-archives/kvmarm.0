Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FCC1E1D8
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 13:34:40 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-58960b53007so12572597b3.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 06:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691674479; x=1692279279;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5KJK/NVH/i/qG6PHa4eldkwVnz7+20TuRWmoOP1g65o=;
        b=zlYPWO1qS/NuNRjh9db4/GxFZb+QMkOrWHx84kkMzxO+d7LRS66Zfyd0Gv46MUmzQf
         mLvS9wPWm2z3J+esFXCwQSA84Ti0ZyyCHaqsmJMkkbFHz0Up4GsC0Y6KAFKPWyI0wYjD
         8FJgMevKm5SSbG9ZE3oFu7rGoLmMWaXgoDAofLT7sDmxydLEyfAtI7e3UuY7z7OQWPCp
         6AjA3hKTg77o/l5cSb2W3rRh6TZMbuKU1m2NDrdv5wHYGXNdk26bpsi8bIYYw7s8xptg
         M8ZbOU/8Zvf4GjTU6jil2X0LjOMI7mRAgPmcX6o/nsnsfu1FGg3CaSoA8P2OKP3nQ9Dh
         nKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691674479; x=1692279279;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5KJK/NVH/i/qG6PHa4eldkwVnz7+20TuRWmoOP1g65o=;
        b=H2XEGyplOxXOSQT5xJQA+a+XIyblPv2dgQTDwd2f/EsFvwvhy37fco+dtkMJ2TvPp7
         V3Wdry9J3sNWPhmnfWSWCTzagaXjZor7npyc7tNeN+34fzWbA912A4ckR7+/rLsfTla0
         ziQwld9tf0k4/23JfdjBsZLSW35oPl5asNMnE004R/+HOmafUyE99mnv1NVKrf1ebu91
         FR6v+KrW+ZTX0tDHrrLhpvGXogYW5ubi3rLoow31IRVip3Rlhxj/eCgWZWsJ5ZrrKdz7
         DxMcVYi4VaiWAz50D+VNSbnp9Res7TDNQfnDn9hd5DwBg3HMF5yPK8A1Cw13VkkDtK1h
         opgw==
X-Gm-Message-State: AOJu0YzAbA9LOdfXhrJbqRgVZpWK5wbfRO0rtfAp/iXc5uWgMnz5GRin
	/9AfC0TikVxFeIvp6n1NQrqRgAA849NmEOgz
X-Google-Smtp-Source: AGHT+IFmOS9ixtEf3/4fj8/YozUQ5to/4izmvFbQqfHfnxsKKsbicOnwJdI9iWdQ/a8LAnEeF3Ujm7M5laM0WiIg
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a81:ac45:0:b0:568:c4ea:ce66 with SMTP
 id z5-20020a81ac45000000b00568c4eace66mr45126ywj.5.1691674479300; Thu, 10 Aug
 2023 06:34:39 -0700 (PDT)
Date: Thu, 10 Aug 2023 14:34:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230810133432.680392-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Do not size-order align pkvm_alloc_private_va_range()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, qperret@google.com, smostafa@google.com, 
	kaleshsingh@google.com, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

commit f922c13e778d ("KVM: arm64: Introduce pkvm_alloc_private_va_range()")
added an alignment for the start address of any allocation into the nVHE
protected hypervisor private VA range.

This alignment (order of the size of the allocation) intends to enable
efficient stack guard verification (if the PAGE_SHIFT bit is zero, the
stack pointer is on the stack guard page, a stack overflow occurred).

But a such alignment only makes sense for stack allocation and can waste
a lot of VA space. So instead make a stack specific allocation function
(hyp_create_stack()) handling the stack guard page requirements, while
other users (e.g. fixmap) will only get page alignment.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index d5ec972b5c1e..71d17ddb562f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -18,6 +18,7 @@ void *hyp_fixmap_map(phys_addr_t phys);
 void hyp_fixmap_unmap(void);
 
 int hyp_create_idmap(u32 hyp_va_bits);
+int hyp_create_stack(unsigned long stack_pa, unsigned long *stack_va);
 int hyp_map_vectors(void);
 int hyp_back_vmemmap(phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 318298eb3d6b..275e33a8be9a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -44,6 +44,28 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 	return err;
 }
 
+static int __pkvm_alloc_private_va_range(unsigned long start, size_t size)
+{
+	unsigned long cur;
+	int ret = 0;
+
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+
+	if (!start || start < __io_map_base)
+		return -EINVAL;
+
+	/* The allocated size is always a multiple of PAGE_SIZE */
+	cur = start + PAGE_ALIGN(size);
+
+	/* Are we overflowing on the vmemmap ? */
+	if (cur > __hyp_vmemmap)
+		ret = -ENOMEM;
+	else
+		__io_map_base = cur;
+
+	return ret;
+}
+
 /**
  * pkvm_alloc_private_va_range - Allocates a private VA range.
  * @size:	The size of the VA range to reserve.
@@ -56,27 +78,16 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
  */
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
 {
-	unsigned long base, addr;
-	int ret = 0;
+	unsigned long addr;
+	int ret;
 
 	hyp_spin_lock(&pkvm_pgd_lock);
-
-	/* Align the allocation based on the order of its size */
-	addr = ALIGN(__io_map_base, PAGE_SIZE << get_order(size));
-
-	/* The allocated size is always a multiple of PAGE_SIZE */
-	base = addr + PAGE_ALIGN(size);
-
-	/* Are we overflowing on the vmemmap ? */
-	if (!addr || base > __hyp_vmemmap)
-		ret = -ENOMEM;
-	else {
-		__io_map_base = base;
-		*haddr = addr;
-	}
-
+	addr = __io_map_base;
+	ret = __pkvm_alloc_private_va_range(addr, size);
 	hyp_spin_unlock(&pkvm_pgd_lock);
 
+	*haddr = addr;
+
 	return ret;
 }
 
@@ -340,6 +351,39 @@ int hyp_create_idmap(u32 hyp_va_bits)
 	return __pkvm_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
 }
 
+int hyp_create_stack(unsigned long stack_pa, unsigned long *stack_va)
+{
+	unsigned long addr;
+	size_t size;
+	int ret;
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+
+	/* Make room for the guard page */
+	size = PAGE_SIZE * 2;
+	addr = ALIGN(__io_map_base, size);
+
+	ret = __pkvm_alloc_private_va_range(addr, size);
+	if (!ret) {
+		/*
+		 * Since the stack grows downwards, map the stack to the page
+		 * at the higher address and leave the lower guard page
+		 * unbacked.
+		 *
+		 * Any valid stack address now has the PAGE_SHIFT bit as 1
+		 * and addresses corresponding to the guard page have the
+		 * PAGE_SHIFT bit as 0 - this is used for overflow detection.
+		 */
+		ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr + PAGE_SIZE,
+					  PAGE_SIZE, stack_pa, PAGE_HYP);
+	}
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	*stack_va = addr + size;
+
+	return ret;
+}
+
 static void *admit_host_page(void *arg)
 {
 	struct kvm_hyp_memcache *host_mc = arg;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index bb98630dfeaf..782c8d0fb905 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -121,33 +121,11 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 		if (ret)
 			return ret;
 
-		/*
-		 * Allocate a contiguous HYP private VA range for the stack
-		 * and guard page. The allocation is also aligned based on
-		 * the order of its size.
-		 */
-		ret = pkvm_alloc_private_va_range(PAGE_SIZE * 2, &hyp_addr);
+		ret = hyp_create_stack(params->stack_pa, &hyp_addr);
 		if (ret)
 			return ret;
 
-		/*
-		 * Since the stack grows downwards, map the stack to the page
-		 * at the higher address and leave the lower guard page
-		 * unbacked.
-		 *
-		 * Any valid stack address now has the PAGE_SHIFT bit as 1
-		 * and addresses corresponding to the guard page have the
-		 * PAGE_SHIFT bit as 0 - this is used for overflow detection.
-		 */
-		hyp_spin_lock(&pkvm_pgd_lock);
-		ret = kvm_pgtable_hyp_map(&pkvm_pgtable, hyp_addr + PAGE_SIZE,
-					PAGE_SIZE, params->stack_pa, PAGE_HYP);
-		hyp_spin_unlock(&pkvm_pgd_lock);
-		if (ret)
-			return ret;
-
-		/* Update stack_hyp_va to end of the stack's private VA range */
-		params->stack_hyp_va = hyp_addr + (2 * PAGE_SIZE);
+		params->stack_hyp_va = hyp_addr;
 	}
 
 	/*

base-commit: 52a93d39b17dc7eb98b6aa3edb93943248e03b2f
-- 
2.41.0.640.ga95def55d0-goog

