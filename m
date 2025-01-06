Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67491DF244
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 18:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736188341; cv=none; b=px5SfxQbktNGLXNhYqHHRihYBR0J+fGle7/evfqnHQJ5ob8xgiNK8y+Uejgi56UqvUppKFO91j5yphPJGxuyyO11QPsH0f0j/bx4Cb8ND4ij8VqWx9PVsUmJBnOC2dt4o45x6Dafg3ya7YG/IegUNlXvz+nESd7ZwTRVeR0wHt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736188341; c=relaxed/simple;
	bh=9am/nlJUYfwTGhYDbGeiAOrRHeBRpqmgQoduL+8umoU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OMhHRowhp5eAtYUTpLs7AutsXR2K57jJ/RxcK0fLjKe3WK/z+fcU8BWcd8rWbaToQJa6yj5glWZ5Ia84ihsVv2aJrXInckQuQ11sTv6nVrvpNQJtqBOB5e3ytAdKybdj3JEXEG87kUbzdlSOGa7ZpcWb92yvL42irA+govDuK1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bqWhLUzm; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bqWhLUzm"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3862b364578so7287515f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jan 2025 10:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736188337; x=1736793137; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mMBHoWGKqgX/Qc6KXJyNk8iaddCY/jFnFkKsjyLo+bs=;
        b=bqWhLUzmiOk0LdCIuH84LtRTyfOjV5Q445VfsN8SVeIJyF+Nysu0iZx5zp2A+sQzh7
         DR0xbDl2qSb1MzO8156q+/W+pXeiFJGVT4zOMlTnSEFn5OZ1rf3B6SzHULro4/gLUSny
         0KI7Ay7JL68G9VmZ5XLeFaq/ZtUYH7SntOkUXcafSvICKsJzTTDCKQEsOj5FD9sejUQF
         7D/UAFIoTJSVOtA6PagLJC+n7hbzxrfuJtKuLQKSvYrfjRVrp1IeX7oGhrwbasttF2Zi
         89W0UZRt8L6NV0plggYZmmyiXAt2ZSDFaxTrEuJu4jkA4T7aiOSytj/MAt/okvPz4mOy
         pDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736188337; x=1736793137;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mMBHoWGKqgX/Qc6KXJyNk8iaddCY/jFnFkKsjyLo+bs=;
        b=SNAGQJq4IwEfiFe7bEZMbvesDdETWLz4nZtdFnxqXKKbFtgGzQpTmk6zbtAnRqv3g8
         Gf019HLRd9hKjLEYwEMTgX6fpoidKZIUkzODBCUjrijWNdrD+nEdyfO4dmpmPBCjZTAo
         62MoFPkC2ENm0sIJbZxffQ58qMJg3jFYwspx7qii9sstZ+wJFUgaxJlTPtePTrKGV319
         wdR4srC/j9gTjctbN6CjM5JSgqgcnU+EDx1wwPVGXy3cTxll+/3YZmHcPjuIYaDclwgF
         WWf9l7L6TlnDrvwSz/ZpkOqoE4q+PN7fo+ljbBeV6Ywp/Qk4j86tCoOCApn5qY4lg5iS
         FWLw==
X-Gm-Message-State: AOJu0YyF0URcPJQRRHrnfALYTk/M6FTGNQUHBLSrHrMq9wcMlTeZ8XKO
	OTXqEhjcQZ8H3IAWFwtqZby4f1oOFsarulp+ShpYh36bHE88keCwzkpByVCZtrOZAmTWtDNLt9B
	pp5GvBXsoqGapb0eiCA==
X-Google-Smtp-Source: AGHT+IG5n82ztTIgQ8mNVnITN9/jqp+oTUnhPTHVxgRvKMcf4+SVIsSRmIj/SKnm+YL5qePo6RJCpb6nXQrhC9Pv
X-Received: from wmqb1.prod.google.com ([2002:a05:600c:4e01:b0:434:ef30:4be3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1446:b0:388:cacf:24b0 with SMTP id ffacd0b85a97d-38a791253dbmr235580f8f.2.1736188336997;
 Mon, 06 Jan 2025 10:32:16 -0800 (PST)
Date: Mon,  6 Jan 2025 18:32:13 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250106183213.4094616-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Fix nVHE stacktrace VA bits mask
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, kernel-team@android.com, 
	linux-arm-kernel@lists.infradead.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The hypervisor VA space size depends on both the ID map's
(IDMAP_VA_BITS) and the kernel stage-1 (VA_BITS). When VA_BITS is
smaller than IDMAP_VA_BITS (i.e. 39-bit), the stacktrace can contain
addresses bigger than the current VA_BITS mask.

As the hyp_va_bits value needs to be used outside of the init code now,
use a global variable, shared by all the kvm users in mmu.c, arm.c and
now stacktrace.c.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 66d93e320ec8..8195a77056a9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -139,6 +139,8 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 
 #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
 
+extern u32 hyp_va_bits;
+
 /*
  * We currently support using a VM-specified IPA size. For backward
  * compatibility, the default IPA size is fixed to 40bits.
@@ -182,7 +184,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
-int __init kvm_mmu_init(u32 *hyp_va_bits);
+int __init kvm_mmu_init(void);
 
 static inline void *__kvm_vector_slot2addr(void *base,
 					   enum arm64_hyp_spectre_vector slot)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..90d28c35c5b5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1987,7 +1987,7 @@ static int kvm_init_vector_slots(void)
 	return 0;
 }
 
-static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
+static void __init cpu_prepare_hyp_mode(int cpu)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 	u64 mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
@@ -2351,7 +2351,7 @@ static void __init teardown_hyp_mode(void)
 	}
 }
 
-static int __init do_pkvm_init(u32 hyp_va_bits)
+static int __init do_pkvm_init(void)
 {
 	void *per_cpu_base = kvm_ksym_ref(kvm_nvhe_sym(kvm_arm_hyp_percpu_base));
 	int ret;
@@ -2412,7 +2412,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 }
 
-static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
+static int __init kvm_hyp_init_protection(void)
 {
 	void *addr = phys_to_virt(hyp_mem_base);
 	int ret;
@@ -2421,7 +2421,7 @@ static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
 	if (ret)
 		return ret;
 
-	ret = do_pkvm_init(hyp_va_bits);
+	ret = do_pkvm_init();
 	if (ret)
 		return ret;
 
@@ -2505,7 +2505,6 @@ static void pkvm_hyp_init_ptrauth(void)
 /* Inits Hyp-mode on all online CPUs */
 static int __init init_hyp_mode(void)
 {
-	u32 hyp_va_bits;
 	int cpu;
 	int err = -ENOMEM;
 
@@ -2519,7 +2518,7 @@ static int __init init_hyp_mode(void)
 	/*
 	 * Allocate Hyp PGD and setup Hyp identity mapping
 	 */
-	err = kvm_mmu_init(&hyp_va_bits);
+	err = kvm_mmu_init();
 	if (err)
 		goto out_err;
 
@@ -2633,7 +2632,7 @@ static int __init init_hyp_mode(void)
 		}
 
 		/* Prepare the CPU initialization parameters */
-		cpu_prepare_hyp_mode(cpu, hyp_va_bits);
+		cpu_prepare_hyp_mode(cpu);
 	}
 
 	kvm_hyp_init_symbols();
@@ -2654,7 +2653,7 @@ static int __init init_hyp_mode(void)
 		if (err)
 			goto out_err;
 
-		err = kvm_hyp_init_protection(hyp_va_bits);
+		err = kvm_hyp_init_protection();
 		if (err) {
 			kvm_err("Failed to init hyp memory protection\n");
 			goto out_err;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9d46ad57e52..62a99c86cd1d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -29,6 +29,8 @@ static unsigned long __ro_after_init hyp_idmap_start;
 static unsigned long __ro_after_init hyp_idmap_end;
 static phys_addr_t __ro_after_init hyp_idmap_vector;
 
+u32 __ro_after_init hyp_va_bits;
+
 static unsigned long __ro_after_init io_map_base;
 
 static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
@@ -1986,7 +1988,7 @@ static struct kvm_pgtable_mm_ops kvm_hyp_mm_ops = {
 	.virt_to_phys		= kvm_host_pa,
 };
 
-int __init kvm_mmu_init(u32 *hyp_va_bits)
+int __init kvm_mmu_init(void)
 {
 	int err;
 	u32 idmap_bits;
@@ -2020,9 +2022,9 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
 	 */
 	idmap_bits = IDMAP_VA_BITS;
 	kernel_bits = vabits_actual;
-	*hyp_va_bits = max(idmap_bits, kernel_bits);
+	hyp_va_bits = max(idmap_bits, kernel_bits);
 
-	kvm_debug("Using %u-bit virtual addresses at EL2\n", *hyp_va_bits);
+	kvm_debug("Using %u-bit virtual addresses at EL2\n", hyp_va_bits);
 	kvm_debug("IDMAP page: %lx\n", hyp_idmap_start);
 	kvm_debug("HYP VA range: %lx:%lx\n",
 		  kern_hyp_va(PAGE_OFFSET),
@@ -2047,7 +2049,7 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
 		goto out;
 	}
 
-	err = kvm_pgtable_hyp_init(hyp_pgtable, *hyp_va_bits, &kvm_hyp_mm_ops);
+	err = kvm_pgtable_hyp_init(hyp_pgtable, hyp_va_bits, &kvm_hyp_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index 3ace5b75813b..ef7a22598d89 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -19,6 +19,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_mmu.h>
 #include <asm/stacktrace/nvhe.h>
 
 static struct stack_info stackinfo_get_overflow(void)
@@ -145,7 +146,7 @@ static void unwind(struct unwind_state *state,
  */
 static bool kvm_nvhe_dump_backtrace_entry(void *arg, unsigned long where)
 {
-	unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
+	unsigned long va_mask = GENMASK_ULL(hyp_va_bits - 1, 0);
 	unsigned long hyp_offset = (unsigned long)arg;
 
 	/* Mask tags and convert to kern addr */

base-commit: 13563da6ffcf49b8b45772e40b35f96926a7ee1e
-- 
2.47.1.613.gc27f4b7a9f-goog

