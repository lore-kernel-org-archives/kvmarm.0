From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/4] arm64: mmu: apply strict permissions to .init.text and
 .init.data
Date: Fri, 10 Feb 2017 17:16:45 +0000
Message-ID: <1486747005-15973-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE52740C27
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Feb 2017 12:16:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ueuV2MVmGfdA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Feb 2017 12:16:25 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F399A40C2A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Feb 2017 12:16:24 -0500 (EST)
Received: by mail-wm0-f52.google.com with SMTP id c85so266182674wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Feb 2017 09:17:02 -0800 (PST)
In-Reply-To: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, keescook@chromium.org, labbott@fedoraproject.org, james.morse@arm.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, marc.zyngier@arm.com, andre.przywara@arm.com, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

To avoid having mappings that are writable and executable at the same
time, split the init region into a .init.text region that is mapped
read-only, and a .init.data region that is mapped non-executable.

This is possible now that the alternative patching occurs via the linear
mapping, and the linear alias of the init region is always mapped writable
(but never executable).

Since the alternatives descriptions themselves are read-only data, move
those into the .init.text region. The .rela section does not have to be
mapped at all after applying the relocations, so drop that from the init
mapping entirely.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/sections.h |  3 +-
 arch/arm64/kernel/vmlinux.lds.S   | 32 ++++++++++++++------
 arch/arm64/mm/init.c              |  3 +-
 arch/arm64/mm/mmu.c               | 12 +++++---
 4 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 4e7e7067afdb..22582819b2e5 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -24,7 +24,8 @@ extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
 extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 extern char __hyp_text_start[], __hyp_text_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
+extern char __initdata_begin[], __initdata_end[];
+extern char __inittext_begin[], __inittext_end[];
 extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
-
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index b8deffa9e1bf..fa144d16bc91 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -143,12 +143,27 @@ SECTIONS
 
 	. = ALIGN(SEGMENT_ALIGN);
 	__init_begin = .;
+	__inittext_begin = .;
 
 	INIT_TEXT_SECTION(8)
 	.exit.text : {
 		ARM_EXIT_KEEP(EXIT_TEXT)
 	}
 
+	. = ALIGN(4);
+	.altinstructions : {
+		__alt_instructions = .;
+		*(.altinstructions)
+		__alt_instructions_end = .;
+	}
+	.altinstr_replacement : {
+		*(.altinstr_replacement)
+	}
+
+	. = ALIGN(PAGE_SIZE);
+	__inittext_end = .;
+	__initdata_begin = .;
+
 	.init.data : {
 		INIT_DATA
 		INIT_SETUP(16)
@@ -164,15 +179,14 @@ SECTIONS
 
 	PERCPU_SECTION(L1_CACHE_BYTES)
 
-	. = ALIGN(4);
-	.altinstructions : {
-		__alt_instructions = .;
-		*(.altinstructions)
-		__alt_instructions_end = .;
-	}
-	.altinstr_replacement : {
-		*(.altinstr_replacement)
-	}
+	. = ALIGN(PAGE_SIZE);
+	__initdata_end = .;
+
+	/*
+	 * The .rela section is not covered by __inittext or __initdata since
+	 * there is no reason to keep it mapped when we switch to the permanent
+	 * swapper page tables.
+	 */
 	.rela : ALIGN(8) {
 		*(.rela .rela*)
 	}
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 8a2713018f2f..6a55feaf46c8 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -493,7 +493,8 @@ void free_initmem(void)
 	 * prevents the region from being reused for kernel modules, which
 	 * is not supported by kallsyms.
 	 */
-	unmap_kernel_range((u64)__init_begin, (u64)(__init_end - __init_begin));
+	unmap_kernel_range((u64)__inittext_begin,
+			   (u64)(__initdata_end - __inittext_begin));
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 5b0dbb9156ce..e6a4bf2acd59 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -482,12 +482,16 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
  */
 static void __init map_kernel(pgd_t *pgd)
 {
-	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
+	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_inittext,
+				vmlinux_initdata, vmlinux_data;
 
 	map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_ROX, &vmlinux_text);
-	map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
-	map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
-			   &vmlinux_init);
+	map_kernel_segment(pgd, __start_rodata, __inittext_begin, PAGE_KERNEL,
+			   &vmlinux_rodata);
+	map_kernel_segment(pgd, __inittext_begin, __inittext_end, PAGE_KERNEL_ROX,
+			   &vmlinux_inittext);
+	map_kernel_segment(pgd, __initdata_begin, __initdata_end, PAGE_KERNEL,
+			   &vmlinux_initdata);
 	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
 
 	if (!pgd_val(*pgd_offset_raw(pgd, FIXADDR_START))) {
-- 
2.7.4
