Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000115102F
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951911; cv=none; b=BGZ6yYoXOqSjhZzLhetkg8ulgj+IflL/zlGzjntUPNU14W2e++xHUX6nC06dORNmSoIIYeSLGYkQbwURL82mHsoZavx5s1YspeSsYlhH7kzi2r8+gafC7lHeNwyLTv8VnjQDRxPCy2zMNJ8R/xR33zC4PPfvNfJLomy8Bqw/S3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951911; c=relaxed/simple;
	bh=0D6iu+3s1VrnA0i1dDZ76qvh9z7keLB7w/NzFLSfBMs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SQYNXhWZpjeS+R+3d4GjHSjYbPYI93hKi5pOl9GyeC4iIkxQKJj2+fNsu0Wwtnjt2yrx2G26i4i0JxVosRarJEgd9RGscmsXQiRWRQv2w7nVoGx9mifpDB0gYUR0MRfM17H+NURgqEfM3HdxL73fQsaPHNGNAXjJEPj6jXWOHys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fdBjYUVM; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fdBjYUVM"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df1cfa720aaso5063545276.2
        for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 06:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715951909; x=1716556709; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=53K1PXzqcYMbK1SrCCxQ9YoceTt2QjykSPDYBNJyvCc=;
        b=fdBjYUVMdpXEfKiTnzVUgukWZ7mkClRF6SnO86UwbYPkhuldIB/S6DrAthNff+RiUL
         LqMa3FKpRSJaovmaCkV4Kc5VMHDRcVIwggALQD6G+n1/RYZiXTVuF5GzTmBLot0kUR0W
         B0bCFMrZ2/jntaBOzWNgp1/Rjzvp/fR9xbI3LC9kXWxRG+QevNEOjcITWLBg1fhXQ+5p
         jY77MrUq6udm2tohTu73LVPpfEjjA3568NhSSSPSi7nZSJDA9T4+9TV+EB5lDGnMFocu
         EqjJkgd8x7oUxtmat+34gy0dXsfCI+gdycID4izbCNkBJ0vTcoXNpU4I1tFImUzClgtG
         qgog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715951909; x=1716556709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=53K1PXzqcYMbK1SrCCxQ9YoceTt2QjykSPDYBNJyvCc=;
        b=nG7WLAc0aW+oiOgI6czjPwXGvGuI1St/nPDDNC8axOZ782QcyfSGCFE/LK/aT0NYva
         RTHzS630Aysk1vtDgXN+2VmQtXsypxXi0b9al1mo6ZcUQfaBVeetytKxCgDnWg5LS9vO
         0fvPxM+3Rwoa4joNSNK2UEIsPyc+Xzb9aqAUALI/Fj7tqcoBL7EyCtdcVm5UdOVSJ+LX
         SkIXKV4j1+YFDfPMVSR/3aSmcoNdPMbnLttbacGmaK35ieSXrFcVH4FXVyRZNLY1pGAz
         NpPH/bezxTxD+d9ulyqLrx8eBbdxrlFiL2T3Kq4RvgLVDqNuHj2oFNFhTJurrLU3rX6w
         mECg==
X-Gm-Message-State: AOJu0YxjuSD9Ejovs09sQEk1EXJBrg4c0RgXOQf0mm9JUbjRqQS3c6iy
	G7D4j9bu78HjojvWbcQEXBDy2UinLS/haf+51Q4zKAUknusgc7s10NiIQpnJ0F3fetjanrVrK10
	CCrVkak4wnN7g5MucEKbru6L5CPPCluH8/jM2oHGzSJNZx+b4vwBiDdizm4vj41vXjd/LJ1Pvj0
	jgaR28HCyENkx92qDTzyMTB0PukEo=
X-Google-Smtp-Source: AGHT+IHMdLmokwdBafcUkrZ6e79i3LWgX8erTOsstj/Flpch2UQwNhCoAof/gmhwCE5KP3TWz4PILESXrQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:10c3:b0:dee:7c5c:e336 with SMTP id
 3f1490d57ef6-dee7c5ce8a4mr1304707276.10.1715951908854; Fri, 17 May 2024
 06:18:28 -0700 (PDT)
Date: Fri, 17 May 2024 14:18:12 +0100
In-Reply-To: <20240517131814.719933-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240517131814.719933-6-tabba@google.com>
Subject: [PATCH v1 5/7] KVM: arm64: Allocate memory at hyp for host sve state
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Protected mode needs to maintain (save/restore) the host's sve
state, rather than relying on the host kernel to do that. This is
to avoid leaking information to the host about guests and the
type of operations they are performing.

As a first step towards that, allocate memory at hyp, per cpu, to
hold the host sve data. The following patch will use this memory
to save/restore the host state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
Note that the last patch in this series will consolidate the
setup of the host's fpsimd and sve states, which currently take
place in two different locations. Moreover, that last patch will
also place the host fpsimd and sve_state pointers in a union.
---
 arch/arm64/include/asm/kvm_host.h    |  2 +
 arch/arm64/include/asm/kvm_pkvm.h    |  9 ++++
 arch/arm64/include/uapi/asm/ptrace.h | 14 ++++++
 arch/arm64/kvm/arm.c                 | 68 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c      | 24 ++++++++++
 5 files changed, 117 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0a5fceb20f3a..7b3745ef1d73 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -535,7 +535,9 @@ struct kvm_cpu_context {
  */
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
+
 	struct user_fpsimd_state *fpsimd_state;	/* hyp VA */
+	struct user_sve_state *sve_state;	/* hyp VA */
 
 	/* Ownership of the FP regs */
 	enum {
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ad9cfb5c1ff4..b9d12e123efb 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -128,4 +128,13 @@ static inline unsigned long hyp_ffa_proxy_pages(void)
 	return (2 * KVM_FFA_MBOX_NR_PAGES) + DIV_ROUND_UP(desc_max, PAGE_SIZE);
 }
 
+static inline size_t pkvm_host_sve_state_size(void)
+{
+	if (!system_supports_sve())
+		return 0;
+
+	return size_add(sizeof(struct user_sve_state),
+			SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_sve_max_vl)));
+}
+
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index 7fa2f7036aa7..77aabf964071 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -120,6 +120,20 @@ struct user_sve_header {
 	__u16 __reserved;
 };
 
+struct user_sve_state {
+	__u64 zcr_el1;
+
+	/*
+	 * Ordering is important since __sve_save_state/__sve_restore_state
+	 * relies on it.
+	 */
+	__u32 fpsr;
+	__u32 fpcr;
+
+	/* Must be SVE_VQ_BYTES (128 bit) aligned. */
+	__u8 sve_regs[];
+};
+
 /* Definitions for user_sve_header.flags: */
 #define SVE_PT_REGS_MASK		(1 << 0)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9e565ea3d645..a9b1b0e9c319 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1931,6 +1931,11 @@ static unsigned long nvhe_percpu_order(void)
 	return size ? get_order(size) : 0;
 }
 
+static size_t pkvm_host_sve_state_order(void)
+{
+	return get_order(pkvm_host_sve_state_size());
+}
+
 /* A lookup table holding the hypervisor VA for each vector slot */
 static void *hyp_spectre_vector_selector[BP_HARDEN_EL2_SLOTS];
 
@@ -2316,7 +2321,15 @@ static void __init teardown_hyp_mode(void)
 	for_each_possible_cpu(cpu) {
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
 		free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
+
+		if (system_supports_sve() && is_protected_kvm_enabled()) {
+			struct user_sve_state *sve_state;
+
+			sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
+			free_pages((unsigned long) sve_state, pkvm_host_sve_state_order());
+		}
 	}
+
 }
 
 static int __init do_pkvm_init(u32 hyp_va_bits)
@@ -2399,6 +2412,50 @@ static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
 	return 0;
 }
 
+static int init_pkvm_host_sve_state(void)
+{
+	int cpu;
+
+	if (!system_supports_sve())
+		return 0;
+
+	/* Allocate pages for host sve state in protected mode. */
+	for_each_possible_cpu(cpu) {
+		struct page *page = alloc_pages(GFP_KERNEL, pkvm_host_sve_state_order());
+
+		if (!page)
+			return -ENOMEM;
+
+		per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state = page_address(page);
+	}
+
+	/*
+	 * Don't map the pages in hyp since these are only used in protected
+	 * mode, which will (re)create its own mapping when initialized.
+	 */
+
+	return 0;
+}
+
+/*
+ * Finalizes the initialization of hyp mode, once everything else is initialized
+ * and the initialziation process cannot fail.
+ */
+static void finalize_init_hyp_mode(void)
+{
+	int cpu;
+
+	if (!is_protected_kvm_enabled() || !system_supports_sve())
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct user_sve_state *sve_state;
+
+		sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
+		per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state = kern_hyp_va(sve_state);
+	}
+}
+
 static void pkvm_hyp_init_ptrauth(void)
 {
 	struct kvm_cpu_context *hyp_ctxt;
@@ -2567,6 +2624,10 @@ static int __init init_hyp_mode(void)
 			goto out_err;
 		}
 
+		err = init_pkvm_host_sve_state();
+		if (err)
+			goto out_err;
+
 		err = kvm_hyp_init_protection(hyp_va_bits);
 		if (err) {
 			kvm_err("Failed to init hyp memory protection\n");
@@ -2731,6 +2792,13 @@ static __init int kvm_arm_init(void)
 	if (err)
 		goto out_subs;
 
+	/*
+	 * This should be called after initialization is done and failure isn't
+	 * possible anymore.
+	 */
+	if (!in_hyp_mode)
+		finalize_init_hyp_mode();
+
 	kvm_arm_initialised = true;
 
 	return 0;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 859f22f754d3..5c8cd806efb9 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -67,6 +67,28 @@ static int divide_memory_pool(void *virt, unsigned long size)
 	return 0;
 }
 
+static int pkvm_create_host_sve_mappings(void)
+{
+	void *start, *end;
+	int ret, i;
+
+	if (!system_supports_sve())
+		return 0;
+
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		struct kvm_host_data *host_data = per_cpu_ptr(&kvm_host_data, i);
+		struct user_sve_state *sve_state = host_data->sve_state;
+
+		start = kern_hyp_va(sve_state);
+		end = start + PAGE_ALIGN(pkvm_host_sve_state_size());
+		ret = pkvm_create_mappings(start, end, PAGE_HYP);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 				 unsigned long *per_cpu_base,
 				 u32 hyp_va_bits)
@@ -125,6 +147,8 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 			return ret;
 	}
 
+	pkvm_create_host_sve_mappings();
+
 	/*
 	 * Map the host sections RO in the hypervisor, but transfer the
 	 * ownership from the host to the hypervisor itself to make sure they
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

