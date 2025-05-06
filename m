Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8084928A416
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550150; cv=none; b=hphgQgcSwe3JDiH8f85eOSLkuCdRCC9GZXq464Ndr8PkfuARisCR9e9XzbYp3vB+U2ayrAZNb9YvmIydiceJv2Vbq7YD6kn08ENJlc7IbCHXL/AutWAFlc9cQpcL0ziRnyN5Lb8nmpKyNjxmP5otkHu8sSYK8iqy3yoVnB2av/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550150; c=relaxed/simple;
	bh=zOYY0EGgrjFCfJ3HkINdv7HvNCnJ1uSFQ5N/H5vv7dw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pIDjy3uyslcIlUmxU4Dn5yz9WZqtig5jSpMQQXcyJDIrqUBPA69dBMBGM0DC6Xk8nnZhWYzDfWZri/O1c7WXDqq/BwDIjrtARkjt+bZosfY9SJ3vFOTOBwiiYRdkQlyRqREh3xJ+G+Gxg/1QMLCK7iJuMwx/88nxgL9/GgHFnO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BGnXuvhx; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BGnXuvhx"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cec217977so35311545e9.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550147; x=1747154947; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7C3WPuCy+qpuZZVpz27zDoZpe8zx2Xoj4eG92N2KUaM=;
        b=BGnXuvhxFywozeV28PjT1dMGtZW2kF/W411gYEydidaH4KqG9iDh1jb2YzbKc6oU3G
         KHwy+IGSymIIN688m3i2G05sjTQ6OyUAmBfQA881HvjjzsCWUF87uCU1+h2Tgy3zhBFd
         2xdfZf0VjUseZdrRJxHdKuWkl+ywsY9d66wZdN7LPX6bSZvxLDYaPvzuFyuqi8VO3jYf
         MiX6+bbXjAX/pxb8zASeESZT5ZomAVcITTSYWOWiqV+d7yPqDv9o9OtTrQKaW2cgBEHw
         WaRak14OlV7X56XNplOuGCMyKWUSgCOy8B/KpAxkjXoFJ3QOtRGfuMjRQyqwnegVdZ2J
         XGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550147; x=1747154947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7C3WPuCy+qpuZZVpz27zDoZpe8zx2Xoj4eG92N2KUaM=;
        b=Nf5n+Nt4xfBETo5WUiWfDFgjSK1JFHTnoc6BcBu3BXrOk14PK3t2u4aUbGZh29gGt2
         uLdYOrmjNkO5+OuEyemNrj/Dl7RA+nzVQqI+SMRZ4COFCAwRMZTpUq9499P88cVb6j+r
         rC+K47azQIe46ab0HL1k1Rx8GJd6pTktGdpy8lFMhqquwiXJTILMNPrnpqwVVGLWydTf
         mfG8iMou2JlAZ/+1IIBkrWaffg0kgVQCsIABfTjG6c/UX3NDPhiSqBnC9INGBJZw9L+Y
         o+4pvstGEukO2LfhWR1BZ29S5Wy7j1dwn2HNduT9F//UzXpFdXvXLDVwthV6uSxP2Jst
         Jz7w==
X-Gm-Message-State: AOJu0Yzi2iUikIFoh3GjiyzRUBAJEmNiZkBBig+4v31fGAA9sc7BdruR
	hlfuO/r889fy1ov2LV/dDs1EIhB1fvlUvXlO0fx2OHl0NmRpuuQaXoWfuXmMiQBLtMbQmDOvJwn
	ILogId8ULBn7WOC9Y2Q==
X-Google-Smtp-Source: AGHT+IF7ojYXqkZ5V+iTaYolJ/Z6/ACckxfH3IbRRaRpxwKWSi1sy6gef3xj2zw6+90icnL5SP+LXnZpGd7RLvBG
X-Received: from wmhu9.prod.google.com ([2002:a05:600c:a369:b0:43d:1873:dbaf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:870c:b0:43c:f61e:6ea8 with SMTP id 5b1f17b1804b1-441c48b0293mr115167875e9.2.1746550146800;
 Tue, 06 May 2025 09:49:06 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:11 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-16-vdonnefort@google.com>
Subject: [PATCH v4 15/24] KVM: arm64: Add .hyp.data section
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow the init of non-zero data in the pKVM hypervisor by adding support
for the .data section.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

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
index 5e3c4b58f279..9c5345f1ab66 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -131,6 +131,8 @@ KVM_NVHE_ALIAS(__hyp_text_start);
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
index 68fec8c95fee..58e8119f66bd 100644
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
2.49.0.967.g6a0df3ecc3-goog

