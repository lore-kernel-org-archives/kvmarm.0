Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB4C1DE2AD
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402867; cv=none; b=P5HIcrUi+CN1Fym1RREuGMQ6T2SzbJPdvA+9bCYSuqhnc8YLmWn6nRN7FCcnDZmEJNkMaylKH+F4CV+Tyflr6WWAv/eySPXK6r0cd5IvqQ5e3qWIRZW03iHALcccdabAi2TBbClEpbnUDqrqWREu6y7WcUcJERdq2XiGE6xFAiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402867; c=relaxed/simple;
	bh=GFdibPOC36wpV8Uous2RaSr1XY5geTjwZRL1v/9HRRY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lvfWXYjin1fbUOpBkgg6KMU5hkz2tesCJGRIKnkEFR1qNe9mSfSbvyNNWH0sk/tsQ/pcQFsIU6+lnSLwikXFVwkR1Yb+HIXHABZy3L3H5nq1vncpq1GI1gKTUwLVD/igtiTpyiGpZGxzWOjcSj46vDEIOHL87cLRfbITy5XPWUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hluYuJmc; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hluYuJmc"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43efa869b19so16210855e9.2
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402864; x=1748007664; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UnPspQ9npIBrd4S4MmL9DdGLdrnLPvxyuuuGQ/DUw7k=;
        b=hluYuJmcgjXGNikqWNmD4ZY2nj1+fE2LCe34tZa7RYBUqLy/TzOXFQt/bCSUVot10R
         K9bRWXQwlH3n5OOGMAWY8h7CSwL6R6x8LeCaZGZmcVupgi9HtxYZ+SE2b/EYw5jhH3Ps
         S+nlBYVsJIOcbIyAZOudL+07IWw9AKHugBiTQYeYFogIwABOIUaSP+oEIsBjUYZsrRs9
         WVKAC1IkCyJvGT1s5ZPH1yJTeOgUO95j+PEJzUox2OacKC7XjCBZg3lV2KVL0HuMrso8
         W+iq0rQJvW5HS/o16q+vjGI8due22hcQ3o4siLApVJCGtbZG2lBmWPhlp1axaHJZ0hET
         G6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402864; x=1748007664;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UnPspQ9npIBrd4S4MmL9DdGLdrnLPvxyuuuGQ/DUw7k=;
        b=S70eT8/PHyVgYbgB8w/cCE6m/HjF5zzLLYkQsAGFlcLnklJX9gV49graq0YqN2NixK
         RAQisnjMwAbEo8PfdVFdvUioTEh4SkQvLvtGOG/uLKaiJFu6eqHaF82iSYYQErbiWfS9
         4sVTLcMs1h0ZPeyX6XfbpMqo/lPHauQbTepwbuHQZush4QaPeHU1a2XDH6upBPLOmJ56
         B+PuBq97RB42Hj7ZIL98m9kAXGDeQDLbuTmUKfrWWfgXo+QO2rlEiqF2VePsQwlP6MM8
         VL4lR2qa0G6eGHV0YR3Qs/fwstB/esIqEAz75FFc2rcaDUmwCwD2LM+bOyPYVP8NmFox
         X8dw==
X-Gm-Message-State: AOJu0Yy2FfHSC008lUMJ0EPp1zUaQYEPiVupaKAOKJeO1mkK4ijqeRZe
	idKFPrLjRBUtHGtToCyklioWjdWs4lq5S9vjg5SPkjv4G5ulIYwkS1UmeVkwxggqHEG4HDXL8Ar
	LShHxr4NdwiMhxLDEPlrdMw==
X-Google-Smtp-Source: AGHT+IGZgZ/Gc79ZOBKRvjg0SEuMNrVkd6guUMpYnYNcmNkDaw6H5jIch8mAkGbsI3ipZMEvlgcscvNmccBDHpRZ
X-Received: from wmbes8.prod.google.com ([2002:a05:600c:8108:b0:440:59df:376a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f87:b0:43c:ea36:9840 with SMTP id 5b1f17b1804b1-442ff031805mr20621965e9.22.1747402864032;
 Fri, 16 May 2025 06:41:04 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:22 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-17-vdonnefort@google.com>
Subject: [PATCH v5 16/25] KVM: arm64: Add .hyp.data section
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	David Brazdil <dbrazdil@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Brazdil <dbrazdil@google.com>

The hypervisor has not needed its own .data section because all globals
were either .rodata or .bss. To avoid having to initialize future
data-structures at run-time, let's introduce add a .data section to the
hypervisor.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Link: https://lore.kernel.org/r/20250416160900.3078417-2-qperret@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 40971ac1303f..51b0d594239e 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -11,6 +11,7 @@ extern char __alt_instructions[], __alt_instructions_end[];
 extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
 extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 extern char __hyp_text_start[], __hyp_text_end[];
+extern char __hyp_data_start[], __hyp_data_end[];
 extern char __hyp_rodata_start[], __hyp_rodata_end[];
 extern char __hyp_reloc_begin[], __hyp_reloc_end[];
 extern char __hyp_bss_start[], __hyp_bss_end[];
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 2004b4f41ade..798405ec48a3 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -127,6 +127,8 @@ KVM_NVHE_ALIAS(__hyp_text_start);
 KVM_NVHE_ALIAS(__hyp_text_end);
 KVM_NVHE_ALIAS(__hyp_bss_start);
 KVM_NVHE_ALIAS(__hyp_bss_end);
+KVM_NVHE_ALIAS(__hyp_data_start);
+KVM_NVHE_ALIAS(__hyp_data_end);
 KVM_NVHE_ALIAS(__hyp_rodata_start);
 KVM_NVHE_ALIAS(__hyp_rodata_end);
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index e73326bd3ff7..7c770053f072 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -13,7 +13,7 @@
 	*(__kvm_ex_table)					\
 	__stop___kvm_ex_table = .;
 
-#define HYPERVISOR_DATA_SECTIONS				\
+#define HYPERVISOR_RODATA_SECTIONS				\
 	HYP_SECTION_NAME(.rodata) : {				\
 		. = ALIGN(PAGE_SIZE);				\
 		__hyp_rodata_start = .;				\
@@ -23,6 +23,15 @@
 		__hyp_rodata_end = .;				\
 	}
 
+#define HYPERVISOR_DATA_SECTION					\
+	HYP_SECTION_NAME(.data) : {				\
+		. = ALIGN(PAGE_SIZE);				\
+		__hyp_data_start = .;				\
+		*(HYP_SECTION_NAME(.data))			\
+		. = ALIGN(PAGE_SIZE);				\
+		__hyp_data_end = .;				\
+	}
+
 #define HYPERVISOR_PERCPU_SECTION				\
 	. = ALIGN(PAGE_SIZE);					\
 	HYP_SECTION_NAME(.data..percpu) : {			\
@@ -51,7 +60,8 @@
 #define SBSS_ALIGN			PAGE_SIZE
 #else /* CONFIG_KVM */
 #define HYPERVISOR_EXTABLE
-#define HYPERVISOR_DATA_SECTIONS
+#define HYPERVISOR_RODATA_SECTIONS
+#define HYPERVISOR_DATA_SECTION
 #define HYPERVISOR_PERCPU_SECTION
 #define HYPERVISOR_RELOC_SECTION
 #define SBSS_ALIGN			0
@@ -190,7 +200,7 @@ SECTIONS
 	/* everything from this point to __init_begin will be marked RO NX */
 	RO_DATA(PAGE_SIZE)
 
-	HYPERVISOR_DATA_SECTIONS
+	HYPERVISOR_RODATA_SECTIONS
 
 	.got : { *(.got) }
 	/*
@@ -295,6 +305,8 @@ SECTIONS
 	_sdata = .;
 	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
 
+	HYPERVISOR_DATA_SECTION
+
 	/*
 	 * Data written with the MMU off but read with the MMU on requires
 	 * cache lines to be invalidated, discarding up to a Cache Writeback
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 19ca57def629..6c42682bc66f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2604,6 +2604,13 @@ static int __init init_hyp_mode(void)
 		goto out_err;
 	}
 
+	err = create_hyp_mappings(kvm_ksym_ref(__hyp_data_start),
+				  kvm_ksym_ref(__hyp_data_end), PAGE_HYP);
+	if (err) {
+		kvm_err("Cannot map .hyp.data section\n");
+		goto out_err;
+	}
+
 	err = create_hyp_mappings(kvm_ksym_ref(__hyp_rodata_start),
 				  kvm_ksym_ref(__hyp_rodata_end), PAGE_HYP_RO);
 	if (err) {
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index f4562f417d3f..d724f6d69302 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -25,5 +25,7 @@ SECTIONS {
 	BEGIN_HYP_SECTION(.data..percpu)
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	END_HYP_SECTION
+
 	HYP_SECTION(.bss)
+	HYP_SECTION(.data)
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index d62bcb5634a2..46d9bd04348f 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -119,6 +119,10 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
+	ret = pkvm_create_mappings(__hyp_data_start, __hyp_data_end, PAGE_HYP);
+	if (ret)
+		return ret;
+
 	ret = pkvm_create_mappings(__hyp_rodata_start, __hyp_rodata_end, PAGE_HYP_RO);
 	if (ret)
 		return ret;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 0f89157d31fd..c462140e640a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -262,6 +262,7 @@ static int __init finalize_pkvm(void)
 	 * at, which would end badly once inaccessible.
 	 */
 	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
+	kmemleak_free_part(__hyp_data_start, __hyp_data_end - __hyp_data_start);
 	kmemleak_free_part(__hyp_rodata_start, __hyp_rodata_end - __hyp_rodata_start);
 	kmemleak_free_part_phys(hyp_mem_base, hyp_mem_size);
 
-- 
2.49.0.1101.gccaa498523-goog

