Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90751A7257
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 11:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728903705; cv=none; b=M14xivjRLo7CKkmhrvb9wHrDfWQqqEYF886qIVw8kcEv8nzr1z7/JyuGrGFYE/OhOxAHslOp6l4lKsxhpGdnCVRnU6ASkWDZlcOfbaHLwSWJ182nEEe8qwFSAGrS1uRefA4lmw3HG82yYg3NYkpCaKbGeaiIEjuFWJJ9Rw39AAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728903705; c=relaxed/simple;
	bh=7rwnwr7dp/7fWoCANFfKtm0Po5dtdm8z9ge0fcc1qCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJvm6gs2CmkAFC45hC17m7nVE4qk+aaALEpgB6v9n/e9mAjlhRLXQU2FWSTqLy+oH620ByRLLG59LndQfNlnDht1hUFpeCI6TBzeHkqG2y1RG0wVmm2MzKdQaKsWdVLkf+8sVfIFrhjr80cmjkHodI062uyVBpj2IycS/fvQqRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEC241763;
	Mon, 14 Oct 2024 04:02:12 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 722EB3F51B;
	Mon, 14 Oct 2024 04:01:40 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Marsden <greg.marsden@oracle.com>,
	Ivan Ivanov <ivan.ivanov@suse.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Matthias Brugger <mbrugger@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1 44/57] arm64: Align sections to PAGE_SIZE_MAX
Date: Mon, 14 Oct 2024 11:58:51 +0100
Message-ID: <20241014105912.3207374-44-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241014105912.3207374-1-ryan.roberts@arm.com>
References: <20241014105514.3206191-1-ryan.roberts@arm.com>
 <20241014105912.3207374-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Increase alignment of sections in nvhe hyp, vdso and final vmlinux image
from PAGE_SIZE to PAGE_SIZE_MAX. For compile-time PAGE_SIZE,
PAGE_SIZE_MAX == PAGE_SIZE so there is no change. For boot-time
PAGE_SIZE, PAGE_SIZE_MAX is the largest selectable page size.

For a boot-time page size build, image size is comparable to a 64K page
size compile-time build. In future, it may be desirable to optimize
run-time memory consumption by freeing unused padding pages when the
boot-time selected page size is less than PAGE_SIZE_MAX.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---

***NOTE***
Any confused maintainers may want to read the cover note here for context:
https://lore.kernel.org/all/20241014105514.3206191-1-ryan.roberts@arm.com/

 arch/arm64/include/asm/memory.h     |  4 +--
 arch/arm64/kernel/vdso-wrap.S       |  4 +--
 arch/arm64/kernel/vdso.c            |  7 +++---
 arch/arm64/kernel/vdso/vdso.lds.S   |  4 +--
 arch/arm64/kernel/vdso32-wrap.S     |  4 +--
 arch/arm64/kernel/vdso32/vdso.lds.S |  4 +--
 arch/arm64/kernel/vmlinux.lds.S     | 38 ++++++++++++++---------------
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S   |  2 +-
 8 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 6aa97fa22dc30..5393a859183f7 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -195,13 +195,13 @@
  *  Open-coded (swapper_pg_dir - reserved_pg_dir) as this cannot be calculated
  *  until link time.
  */
-#define RESERVED_SWAPPER_OFFSET	(PAGE_SIZE)
+#define RESERVED_SWAPPER_OFFSET	(PAGE_SIZE_MAX)
 
 /*
  *  Open-coded (swapper_pg_dir - tramp_pg_dir) as this cannot be calculated
  *  until link time.
  */
-#define TRAMP_SWAPPER_OFFSET	(2 * PAGE_SIZE)
+#define TRAMP_SWAPPER_OFFSET	(2 * PAGE_SIZE_MAX)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kernel/vdso-wrap.S b/arch/arm64/kernel/vdso-wrap.S
index c4b1990bf2be0..79fa77628199b 100644
--- a/arch/arm64/kernel/vdso-wrap.S
+++ b/arch/arm64/kernel/vdso-wrap.S
@@ -13,10 +13,10 @@
 
 	.globl vdso_start, vdso_end
 	.section .rodata
-	.balign PAGE_SIZE
+	.balign PAGE_SIZE_MAX
 vdso_start:
 	.incbin "arch/arm64/kernel/vdso/vdso.so"
-	.balign PAGE_SIZE
+	.balign PAGE_SIZE_MAX
 vdso_end:
 
 	.previous
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 89b6e78400023..1efe98909a2e0 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -195,7 +195,7 @@ static int __setup_additional_pages(enum vdso_abi abi,
 
 	vdso_text_len = vdso_info[abi].vdso_pages << PAGE_SHIFT;
 	/* Be sure to map the data page */
-	vdso_mapping_len = vdso_text_len + VVAR_NR_PAGES * PAGE_SIZE;
+	vdso_mapping_len = vdso_text_len + VVAR_NR_PAGES * PAGE_SIZE_MAX;
 
 	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
 	if (IS_ERR_VALUE(vdso_base)) {
@@ -203,7 +203,8 @@ static int __setup_additional_pages(enum vdso_abi abi,
 		goto up_fail;
 	}
 
-	ret = _install_special_mapping(mm, vdso_base, VVAR_NR_PAGES * PAGE_SIZE,
+	ret = _install_special_mapping(mm, vdso_base,
+				       VVAR_NR_PAGES * PAGE_SIZE_MAX,
 				       VM_READ|VM_MAYREAD|VM_PFNMAP,
 				       vdso_info[abi].dm);
 	if (IS_ERR(ret))
@@ -212,7 +213,7 @@ static int __setup_additional_pages(enum vdso_abi abi,
 	if (system_supports_bti_kernel())
 		gp_flags = VM_ARM64_BTI;
 
-	vdso_base += VVAR_NR_PAGES * PAGE_SIZE;
+	vdso_base += VVAR_NR_PAGES * PAGE_SIZE_MAX;
 	mm->context.vdso = (void *)vdso_base;
 	ret = _install_special_mapping(mm, vdso_base, vdso_text_len,
 				       VM_READ|VM_EXEC|gp_flags|
diff --git a/arch/arm64/kernel/vdso/vdso.lds.S b/arch/arm64/kernel/vdso/vdso.lds.S
index 45354f2ddf706..f7d1537a689e8 100644
--- a/arch/arm64/kernel/vdso/vdso.lds.S
+++ b/arch/arm64/kernel/vdso/vdso.lds.S
@@ -18,9 +18,9 @@ OUTPUT_ARCH(aarch64)
 
 SECTIONS
 {
-	PROVIDE(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE);
+	PROVIDE(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE_MAX);
 #ifdef CONFIG_TIME_NS
-	PROVIDE(_timens_data = _vdso_data + PAGE_SIZE);
+	PROVIDE(_timens_data = _vdso_data + PAGE_SIZE_MAX);
 #endif
 	. = VDSO_LBASE + SIZEOF_HEADERS;
 
diff --git a/arch/arm64/kernel/vdso32-wrap.S b/arch/arm64/kernel/vdso32-wrap.S
index e72ac7bc4c04f..1c6069d6c457e 100644
--- a/arch/arm64/kernel/vdso32-wrap.S
+++ b/arch/arm64/kernel/vdso32-wrap.S
@@ -10,10 +10,10 @@
 
 	.globl vdso32_start, vdso32_end
 	.section .rodata
-	.balign PAGE_SIZE
+	.balign PAGE_SIZE_MAX
 vdso32_start:
 	.incbin "arch/arm64/kernel/vdso32/vdso.so"
-	.balign PAGE_SIZE
+	.balign PAGE_SIZE_MAX
 vdso32_end:
 
 	.previous
diff --git a/arch/arm64/kernel/vdso32/vdso.lds.S b/arch/arm64/kernel/vdso32/vdso.lds.S
index 8d95d7d35057d..c46d18a69d1ce 100644
--- a/arch/arm64/kernel/vdso32/vdso.lds.S
+++ b/arch/arm64/kernel/vdso32/vdso.lds.S
@@ -18,9 +18,9 @@ OUTPUT_ARCH(arm)
 
 SECTIONS
 {
-	PROVIDE_HIDDEN(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE);
+	PROVIDE_HIDDEN(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE_MAX);
 #ifdef CONFIG_TIME_NS
-	PROVIDE_HIDDEN(_timens_data = _vdso_data + PAGE_SIZE);
+	PROVIDE_HIDDEN(_timens_data = _vdso_data + PAGE_SIZE_MAX);
 #endif
 	. = VDSO_LBASE + SIZEOF_HEADERS;
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 7f3f6d709ae73..1ef6dea13b57c 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -15,16 +15,16 @@
 
 #define HYPERVISOR_DATA_SECTIONS				\
 	HYP_SECTION_NAME(.rodata) : {				\
-		. = ALIGN(PAGE_SIZE);				\
+		. = ALIGN(PAGE_SIZE_MAX);			\
 		__hyp_rodata_start = .;				\
 		*(HYP_SECTION_NAME(.data..ro_after_init))	\
 		*(HYP_SECTION_NAME(.rodata))			\
-		. = ALIGN(PAGE_SIZE);				\
+		. = ALIGN(PAGE_SIZE_MAX);			\
 		__hyp_rodata_end = .;				\
 	}
 
 #define HYPERVISOR_PERCPU_SECTION				\
-	. = ALIGN(PAGE_SIZE);					\
+	. = ALIGN(PAGE_SIZE_MAX);				\
 	HYP_SECTION_NAME(.data..percpu) : {			\
 		*(HYP_SECTION_NAME(.data..percpu))		\
 	}
@@ -39,7 +39,7 @@
 #define BSS_FIRST_SECTIONS					\
 	__hyp_bss_start = .;					\
 	*(HYP_SECTION_NAME(.bss))				\
-	. = ALIGN(PAGE_SIZE);					\
+	. = ALIGN(PAGE_SIZE_MAX);				\
 	__hyp_bss_end = .;
 
 /*
@@ -48,7 +48,7 @@
  * between them, which can in some cases cause the linker to misalign them. To
  * work around the issue, force a page alignment for __bss_start.
  */
-#define SBSS_ALIGN			PAGE_SIZE
+#define SBSS_ALIGN			PAGE_SIZE_MAX
 #else /* CONFIG_KVM */
 #define HYPERVISOR_EXTABLE
 #define HYPERVISOR_DATA_SECTIONS
@@ -75,14 +75,14 @@ ENTRY(_text)
 jiffies = jiffies_64;
 
 #define HYPERVISOR_TEXT					\
-	. = ALIGN(PAGE_SIZE);				\
+	. = ALIGN(PAGE_SIZE_MAX);			\
 	__hyp_idmap_text_start = .;			\
 	*(.hyp.idmap.text)				\
 	__hyp_idmap_text_end = .;			\
 	__hyp_text_start = .;				\
 	*(.hyp.text)					\
 	HYPERVISOR_EXTABLE				\
-	. = ALIGN(PAGE_SIZE);				\
+	. = ALIGN(PAGE_SIZE_MAX);			\
 	__hyp_text_end = .;
 
 #define IDMAP_TEXT					\
@@ -113,11 +113,11 @@ jiffies = jiffies_64;
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 #define TRAMP_TEXT					\
-	. = ALIGN(PAGE_SIZE);				\
+	. = ALIGN(PAGE_SIZE_MAX);			\
 	__entry_tramp_text_start = .;			\
 	*(.entry.tramp.text)				\
-	. = ALIGN(PAGE_SIZE);				\
 	__entry_tramp_text_end = .;			\
+	. = ALIGN(PAGE_SIZE_MAX);			\
 	*(.entry.tramp.rodata)
 #else
 #define TRAMP_TEXT
@@ -187,7 +187,7 @@ SECTIONS
 	_etext = .;			/* End of text section */
 
 	/* everything from this point to __init_begin will be marked RO NX */
-	RO_DATA(PAGE_SIZE)
+	RO_DATA(PAGE_SIZE_MAX)
 
 	HYPERVISOR_DATA_SECTIONS
 
@@ -206,22 +206,22 @@ SECTIONS
 		HIBERNATE_TEXT
 		KEXEC_TEXT
 		IDMAP_TEXT
-		. = ALIGN(PAGE_SIZE);
+		. = ALIGN(PAGE_SIZE_MAX);
 	}
 
 	idmap_pg_dir = .;
-	. += PAGE_SIZE;
+	. += PAGE_SIZE_MAX;
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	tramp_pg_dir = .;
-	. += PAGE_SIZE;
+	. += PAGE_SIZE_MAX;
 #endif
 
 	reserved_pg_dir = .;
-	. += PAGE_SIZE;
+	. += PAGE_SIZE_MAX;
 
 	swapper_pg_dir = .;
-	. += PAGE_SIZE;
+	. += PAGE_SIZE_MAX;
 
 	. = ALIGN(SEGMENT_ALIGN);
 	__init_begin = .;
@@ -290,7 +290,7 @@ SECTIONS
 
 	_data = .;
 	_sdata = .;
-	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
+	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE_MAX, THREAD_ALIGN)
 
 	/*
 	 * Data written with the MMU off but read with the MMU on requires
@@ -317,7 +317,7 @@ SECTIONS
 	/* start of zero-init region */
 	BSS_SECTION(SBSS_ALIGN, 0, 0)
 
-	. = ALIGN(PAGE_SIZE);
+	. = ALIGN(PAGE_SIZE_MAX);
 	init_pg_dir = .;
 	. += INIT_DIR_SIZE_MAX;
 	init_pg_end = .;
@@ -356,7 +356,7 @@ SECTIONS
  * former is page-aligned, but the latter may not be with 16K or 64K pages, so
  * it should also not cross a page boundary.
  */
-ASSERT(__hyp_idmap_text_end - __hyp_idmap_text_start <= PAGE_SIZE,
+ASSERT(__hyp_idmap_text_end - __hyp_idmap_text_start <= SZ_4K,
 	"HYP init code too big")
 ASSERT(__idmap_text_end - (__idmap_text_start & ~(SZ_4K - 1)) <= SZ_4K,
 	"ID map text too big or misaligned")
@@ -367,7 +367,7 @@ ASSERT(__hibernate_exit_text_start == swsusp_arch_suspend_exit,
        "Hibernate exit text does not start with swsusp_arch_suspend_exit")
 #endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) <= 3*PAGE_SIZE,
+ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) <= 3 * SZ_4K,
 	"Entry trampoline text too big")
 #endif
 #ifdef CONFIG_KVM
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index f4562f417d3fc..74c7c21626270 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -21,7 +21,7 @@ SECTIONS {
 	 * .hyp..data..percpu needs to be page aligned to maintain the same
 	 * alignment for when linking into vmlinux.
 	 */
-	. = ALIGN(PAGE_SIZE);
+	. = ALIGN(PAGE_SIZE_MAX);
 	BEGIN_HYP_SECTION(.data..percpu)
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	END_HYP_SECTION
-- 
2.43.0

