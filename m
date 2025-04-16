Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DF220FAAC
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 16:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744819749; cv=none; b=pZ4mrPZlw/bK6uV5pg1yTb3nyKKPR1OC0NWVfi+aEjQYS7yFXZqBf/jw62fHeFUQaLTjusQ8EUF9HTJj4oc5gRsOY5VfhDnMMIwNyhwfvfpY8ige+EdwprYLXI3LyVQ8QHW1KSYuZuUD3lYmib2zYhDh7bjMPlWNcsZpoYb2cu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744819749; c=relaxed/simple;
	bh=Phj6Z8bd0z00tKtTpT2UJxiQehIZbjeTZC1Km0GG+JQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FceX3NL2TvHlH0IGNK8fCfxDix5WPtd5LzzaUwcPgMrPEt9sEUd5GhOv2dUkq83/anuIxXgTBrVstPJchALFvzddBQ1JiCAbjqN1w5ZV4ACMx5YH/E5FbMOS75irZ63OwwVXJo7R08adcTsa4lY8RNj9lUi77IHi+fxMYtvcmIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UkN5CPD1; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UkN5CPD1"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ac293748694so664887766b.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 09:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744819746; x=1745424546; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qk46ikY00j+5+57DCaLJRftXVwdO91Q7aH3vc94jYB4=;
        b=UkN5CPD1/wiIXI5tssUzC255jIsl1lYs6YPo6+Nd/KIEP4ULpmc7OcSo9u2NXavk8i
         NremXoHnL6TcRvczqHYkd5wKcLQnwVnZzinz0osDEu+cjpElJ1RwFSkTIjQjRTZwwMHf
         nLq7/nnFmdG0UN+oNY0J1uiM+wlt3B3FpeWVOz+irZ6zV9bYsXa87aSawwEuIGSdqLdv
         xj4OGKA5PA8Yga7hiHUuMqf8YMQ0SwL0zvVF8ciSOjJF5J2EV1p3VhrhGTkR7CMyuo1X
         I60uBYR68UXv5OqZhhzSOji4fNFgSNshP0kBXyZ8KI3SGWY/NlKhKOJztrUcnpAhudFF
         VkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744819746; x=1745424546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qk46ikY00j+5+57DCaLJRftXVwdO91Q7aH3vc94jYB4=;
        b=cwGDQQmqClhMRSZScRGY084lFkvH7EIxwejyJIfIFY1IdsyXGrJFRZoGL1kmrsbUJD
         Z6DGXilaCbSOuzfiyc67n2nc/vXT3Yjev14sDh1TrmcvX4WROdoWAJeLUbdnDeMT//JR
         jRy9KQkd2kNx81SAOIr6RkFez7UiwRFKxwJFDnvN4QaiyzS+wcEkfFdGTO8wy5f41Uqs
         o9+gTLGJWkStKdBQoSV2EH9QI7W/Gq4yEe1RRoPcgSX8u07+5jEnWZOy2VU0kqZg6nOt
         PFLUOlWiFBTVq+ySAzwV9bh+fF8De6B9lLL0X0r2NR52ZKFdudlHhEZgO/g8zE7CNU6T
         7K/A==
X-Forwarded-Encrypted: i=1; AJvYcCXpmFixsnr08TNCq7iMYq5GZuG5pztrDT+gDbUToxDeGbKfivG4adEMClR4/3JGmIxbObtcFoo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAsDq2BJfJ5t81NabcjqAeancbajNYsQJO5goD+IuzUmbFLzBJ
	GTOqS3uAWSjr2Jz9izyuoSEeLkei17VDVXwIN4HSk2ZIeEdr07HWH3TnNdm56mOlboKOEoO5irJ
	C7PqKIQ==
X-Google-Smtp-Source: AGHT+IF0Qgk4Z9REtBCKxe6tx7t27J9UAsPYpAOJnWiB4lAJ8d3qRn0XaVBtwgLkIydXHfh5DlnZK0uF0PD6
X-Received: from edcf13.prod.google.com ([2002:a50:a6cd:0:b0:5ec:d8f6:4a7a])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:97c5:b0:ac6:f4c1:b797
 with SMTP id a640c23a62f3a-acb42987babmr251744266b.19.1744819745708; Wed, 16
 Apr 2025 09:09:05 -0700 (PDT)
Date: Wed, 16 Apr 2025 16:08:57 +0000
In-Reply-To: <20250416160900.3078417-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416160900.3078417-1-qperret@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416160900.3078417-2-qperret@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: Add .hyp.data section
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: David Brazdil <dbrazdil@google.com>

The hypervisor has not needed its own .data section because all globals
were either .rodata or .bss. To avoid having to initialize future
data-structures at run-time, let's introduce add a .data section to the
hypervisor.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/image-vars.h    |  2 ++
 arch/arm64/kernel/vmlinux.lds.S   | 18 +++++++++++++++---
 arch/arm64/kvm/arm.c              |  7 +++++++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  2 ++
 arch/arm64/kvm/hyp/nvhe/setup.c   |  4 ++++
 arch/arm64/kvm/pkvm.c             |  1 +
 7 files changed, 32 insertions(+), 3 deletions(-)

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
index 955c431af5d0..2050bb5a6de7 100644
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
2.49.0.604.gff1f9ca942-goog

