From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 5/5] arm64: mmu: apply strict permissions to .init.text and
 .init.data
Date: Sat, 11 Feb 2017 20:23:06 +0000
Message-ID: <1486844586-26135-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 262DA40A74
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Feb 2017 15:23:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Bei9qQFiL+T for <kvmarm@lists.cs.columbia.edu>;
 Sat, 11 Feb 2017 15:23:35 -0500 (EST)
Received: from mail-wr0-f180.google.com (mail-wr0-f180.google.com
 [209.85.128.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F25540A42
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Feb 2017 15:23:34 -0500 (EST)
Received: by mail-wr0-f180.google.com with SMTP id k90so128686381wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Feb 2017 12:24:14 -0800 (PST)
In-Reply-To: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, keescook@chromium.org, marc.zyngier@arm.com, andre.przywara@arm.com, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

To avoid having mappings that are writable and executable at the same
time, split the init region into a .init.text region that is mapped
read-only, and a .init.data region that is mapped non-executable.

This is possible now that the alternative patching occurs via the linear
mapping, and the linear alias of the init region is always mapped writable
(but never executable).

Since the alternatives descriptions themselves are read-only data, move
those into the .init.text region.

Reviewed-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/sections.h |  3 ++-
 arch/arm64/kernel/vmlinux.lds.S   | 25 +++++++++++++-------
 arch/arm64/mm/mmu.c               | 12 ++++++----
 3 files changed, 26 insertions(+), 14 deletions(-)

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
index b8deffa9e1bf..2c93d259046c 100644
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
@@ -164,15 +179,6 @@ SECTIONS
 
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
 	.rela : ALIGN(8) {
 		*(.rela .rela*)
 	}
@@ -181,6 +187,7 @@ SECTIONS
 	__rela_size	= SIZEOF(.rela);
 
 	. = ALIGN(SEGMENT_ALIGN);
+	__initdata_end = .;
 	__init_end = .;
 
 	_data = .;
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e97f1ce967ec..c53c43b4ed3f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -479,12 +479,16 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
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
