Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E59CC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1F4222D50
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 18:06:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1F4222D50
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 862A74B37E;
	Tue,  5 Jan 2021 13:06:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LvyGUqrbg4AA; Tue,  5 Jan 2021 13:06:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C41234B371;
	Tue,  5 Jan 2021 13:06:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E3DD4B36F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U+DcgBLq69hG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 13:06:03 -0500 (EST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 140724B275
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 13:06:03 -0500 (EST)
Received: by mail-wm1-f43.google.com with SMTP id 3so379241wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 10:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=d+uHwEYDJF0rNRcNiLI17FoJnHpTNGz4U1iUVCU1JMk=;
 b=A1qy8Fatn8t1RgSdISmQVC6qlsH4y803Jan86/kD1WZTeDTDvDjLWOrDqegDFFSmw8
 TKdh2NLwqJiS3TYEJKUAqXIHbMK3mgavA/VTK8tDz5Q5NWZB/5ItLHqv8JnOVQXJHhf9
 kL3ias0GUa15vJo7GDLebt/2Lm5YsJzw7EbEzu8VNFFbDJz3aep4C8W6CumJPT37dVmh
 iSdMnOmHpakEs+5nO0La0CUOigRqS6VN33HkC5e/q6pj/MrL7mJQnDAWg/IukEOQjbLL
 3iSeuXk7MuxoeOSf+SJtOHXvBilGQ94GFfV/tJpJa9/M68qgQivprW1pbYxQmpDbIE93
 s77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=d+uHwEYDJF0rNRcNiLI17FoJnHpTNGz4U1iUVCU1JMk=;
 b=T0Pfb8KK98tMIGewv9dm6dYtph9M81j2nb8voeCQW1owIydiCk0q3GYYMreb+J53Qp
 VVIX14CAGNJbRu9DeZYnS2JBkKf4oMF73kr5cNfGmOMk8k/yyky3+hk4CZa9sr6JId5X
 6VaW0yAC4urSLJjPZ+SsBRUgu4QD6/MxP9ZRAFcG+XpG4E4xuPqd5yT9ES0kET34gbUG
 qdRS6Vrd5vLqvJEmRf8vAstcF4b4OpTVu0OAuLR04rQzFLVzzFQ+jgVZZrCUd+M5+Nj7
 oIbzwtY8wI7slLX6x9FR5j1BNab8UQRX/lYmaWGo+Ep7MKx8xPs9lpThJbvhLLce9D7U
 xATQ==
X-Gm-Message-State: AOAM531yhRCmyDbL2cCm/4aDj+z8YHEIRR43gxYf6aUdWUr0nikly1IK
 zfIedrbpCQBTBKdqCO3qHKkKOO3/xCzT0w==
X-Google-Smtp-Source: ABdhPJyttuUSg1/y8da7Nsm0xx22SLzgWchOpa8g8t76VGziw9lqq43TXg5/UfCSbAKypW5NUqu+nQ==
X-Received: by 2002:a1c:e90b:: with SMTP id q11mr343802wmc.102.1609869961442; 
 Tue, 05 Jan 2021 10:06:01 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:4957:71a5:7b5c:c94f])
 by smtp.gmail.com with ESMTPSA id n14sm344620wmi.1.2021.01.05.10.06.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Jan 2021 10:06:00 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 4/8] KVM: arm64: Generate hyp relocation data
Date: Tue,  5 Jan 2021 18:05:37 +0000
Message-Id: <20210105180541.65031-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105180541.65031-1-dbrazdil@google.com>
References: <20210105180541.65031-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add a post-processing step to compilation of KVM nVHE hyp code which
calls a custom host tool (gen-hyprel) on the partially linked object
file (hyp sections' names prefixed).

The tool lists all R_AARCH64_ABS64 data relocations targeting hyp
sections and generates an assembly file that will form a new section
.hyp.reloc in the kernel binary. The new section contains an array of
32-bit offsets to the positions targeted by these relocations.

Since these addresses of those positions will not be determined until
linking of `vmlinux`, each 32-bit entry carries a R_AARCH64_PREL32
relocation with addend <section_base_sym> + <r_offset>. The linker of
`vmlinux` will therefore fill the slot accordingly.

This relocation data will be used at runtime to convert the kernel VAs
at those positions to hyp VAs.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/vmlinux.lds.S      |  11 +
 arch/arm64/kvm/hyp/nvhe/.gitignore   |   2 +
 arch/arm64/kvm/hyp/nvhe/Makefile     |  28 +-
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 413 +++++++++++++++++++++++++++
 4 files changed, 451 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 9672b54bba7c..636ca45aa1d4 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -43,10 +43,19 @@ jiffies = jiffies_64;
 	HYP_SECTION_NAME(.data..percpu) : {			\
 		*(HYP_SECTION_NAME(.data..percpu))		\
 	}
+
+#define HYPERVISOR_RELOC_SECTION				\
+	.hyp.reloc : ALIGN(4) {					\
+		__hyp_reloc_begin = .;				\
+		*(.hyp.reloc)					\
+		__hyp_reloc_end = .;				\
+	}
+
 #else /* CONFIG_KVM */
 #define HYPERVISOR_EXTABLE
 #define HYPERVISOR_DATA_SECTIONS
 #define HYPERVISOR_PERCPU_SECTION
+#define HYPERVISOR_RELOC_SECTION
 #endif
 
 #define HYPERVISOR_TEXT					\
@@ -217,6 +226,8 @@ SECTIONS
 	PERCPU_SECTION(L1_CACHE_BYTES)
 	HYPERVISOR_PERCPU_SECTION
 
+	HYPERVISOR_RELOC_SECTION
+
 	.rela.dyn : ALIGN(8) {
 		*(.rela .rela*)
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/.gitignore b/arch/arm64/kvm/hyp/nvhe/.gitignore
index 695d73d0249e..5b6c43cc96f8 100644
--- a/arch/arm64/kvm/hyp/nvhe/.gitignore
+++ b/arch/arm64/kvm/hyp/nvhe/.gitignore
@@ -1,2 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
+gen-hyprel
 hyp.lds
+hyp-reloc.S
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 1f1e351c5fe2..268be1376f74 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,6 +6,8 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
+hostprogs := gen-hyprel
+
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
@@ -19,7 +21,7 @@ obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 
 hyp-obj := $(patsubst %.o,%.nvhe.o,$(obj-y))
 obj-y := kvm_nvhe.o
-extra-y := $(hyp-obj) kvm_nvhe.tmp.o hyp.lds
+extra-y := $(hyp-obj) kvm_nvhe.tmp.o kvm_nvhe.rel.o hyp.lds hyp-reloc.S hyp-reloc.o
 
 # 1) Compile all source files to `.nvhe.o` object files. The file extension
 #    avoids file name clashes for files shared with VHE.
@@ -42,11 +44,31 @@ LDFLAGS_kvm_nvhe.tmp.o := -r -T
 $(obj)/kvm_nvhe.tmp.o: $(obj)/hyp.lds $(addprefix $(obj)/,$(hyp-obj)) FORCE
 	$(call if_changed,ld)
 
-# 4) Produce the final 'kvm_nvhe.o', ready to be linked into 'vmlinux'.
+# 4) Generate list of hyp code/data positions that need to be relocated at
+#    runtime. Because the hypervisor is part of the kernel binary, relocations
+#    produce a kernel VA. We enumerate relocations targeting hyp at build time
+#    and convert the kernel VAs at those positions to hyp VAs.
+$(obj)/hyp-reloc.S: $(obj)/kvm_nvhe.tmp.o $(obj)/gen-hyprel
+	$(call if_changed,hyprel)
+
+# 5) Compile hyp-reloc.S and link it into the existing partially linked object.
+#    The object file now contains a section with pointers to hyp positions that
+#    will contain kernel VAs at runtime. These pointers have relocations on them
+#    so that they get updated as the hyp object is linked into `vmlinux`.
+LDFLAGS_kvm_nvhe.rel.o := -r
+$(obj)/kvm_nvhe.rel.o: $(obj)/kvm_nvhe.tmp.o $(obj)/hyp-reloc.o FORCE
+	$(call if_changed,ld)
+
+# 6) Produce the final 'kvm_nvhe.o', ready to be linked into 'vmlinux'.
 #    Prefixes names of ELF symbols with '__kvm_nvhe_'.
-$(obj)/kvm_nvhe.o: $(obj)/kvm_nvhe.tmp.o FORCE
+$(obj)/kvm_nvhe.o: $(obj)/kvm_nvhe.rel.o FORCE
 	$(call if_changed,hypcopy)
 
+# The HYPREL command calls `gen-hyprel` to generate an assembly file with
+# a list of relocations targeting hyp code/data.
+quiet_cmd_hyprel = HYPREL  $@
+      cmd_hyprel = $(obj)/gen-hyprel $< > $@
+
 # The HYPCOPY command uses `objcopy` to prefix all ELF symbol names
 # to avoid clashes with VHE code/data.
 quiet_cmd_hypcopy = HYPCOPY $@
diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
new file mode 100644
index 000000000000..58fe31fdba8e
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
@@ -0,0 +1,413 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 - Google LLC
+ * Author: David Brazdil <dbrazdil@google.com>
+ *
+ * Generates relocation information used by the kernel to convert
+ * absolute addresses in hyp data from kernel VAs to hyp VAs.
+ *
+ * This is necessary because hyp code is linked into the same binary
+ * as the kernel but executes under different memory mappings.
+ * If the compiler used absolute addressing, those addresses need to
+ * be converted before they are used by hyp code.
+ *
+ * The input of this program is the relocatable ELF object containing
+ * all hyp code/data, not yet linked into vmlinux. Hyp section names
+ * should have been prefixed with `.hyp` at this point.
+ *
+ * The output (printed to stdout) is an assembly file containing
+ * an array of 32-bit integers and static relocations that instruct
+ * the linker of `vmlinux` to populate the array entries with offsets
+ * to positions in the kernel binary containing VAs used by hyp code.
+ *
+ * Note that dynamic relocations could be used for the same purpose.
+ * However, those are only generated if CONFIG_RELOCATABLE=y.
+ */
+
+#include <elf.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#define HYP_SECTION_PREFIX		".hyp"
+#define HYP_RELOC_SECTION		".hyp.reloc"
+#define HYP_SECTION_SYMBOL_PREFIX	"__hyp_section_"
+
+/*
+ * AArch64 relocation type constants.
+ * Included in case these are not defined in the host toolchain.
+ */
+#ifndef R_AARCH64_ABS64
+#define R_AARCH64_ABS64			257
+#endif
+#ifndef R_AARCH64_LD_PREL_LO19
+#define R_AARCH64_LD_PREL_LO19		273
+#endif
+#ifndef R_AARCH64_ADR_PREL_LO21
+#define R_AARCH64_ADR_PREL_LO21		274
+#endif
+#ifndef R_AARCH64_ADR_PREL_PG_HI21
+#define R_AARCH64_ADR_PREL_PG_HI21	275
+#endif
+#ifndef R_AARCH64_ADR_PREL_PG_HI21_NC
+#define R_AARCH64_ADR_PREL_PG_HI21_NC	276
+#endif
+#ifndef R_AARCH64_ADD_ABS_LO12_NC
+#define R_AARCH64_ADD_ABS_LO12_NC	277
+#endif
+#ifndef R_AARCH64_LDST8_ABS_LO12_NC
+#define R_AARCH64_LDST8_ABS_LO12_NC	278
+#endif
+#ifndef R_AARCH64_TSTBR14
+#define R_AARCH64_TSTBR14		279
+#endif
+#ifndef R_AARCH64_CONDBR19
+#define R_AARCH64_CONDBR19		280
+#endif
+#ifndef R_AARCH64_JUMP26
+#define R_AARCH64_JUMP26		282
+#endif
+#ifndef R_AARCH64_CALL26
+#define R_AARCH64_CALL26		283
+#endif
+#ifndef R_AARCH64_LDST16_ABS_LO12_NC
+#define R_AARCH64_LDST16_ABS_LO12_NC	284
+#endif
+#ifndef R_AARCH64_LDST32_ABS_LO12_NC
+#define R_AARCH64_LDST32_ABS_LO12_NC	285
+#endif
+#ifndef R_AARCH64_LDST64_ABS_LO12_NC
+#define R_AARCH64_LDST64_ABS_LO12_NC	286
+#endif
+#ifndef R_AARCH64_MOVW_PREL_G0
+#define R_AARCH64_MOVW_PREL_G0		287
+#endif
+#ifndef R_AARCH64_MOVW_PREL_G0_NC
+#define R_AARCH64_MOVW_PREL_G0_NC	288
+#endif
+#ifndef R_AARCH64_MOVW_PREL_G1
+#define R_AARCH64_MOVW_PREL_G1		289
+#endif
+#ifndef R_AARCH64_MOVW_PREL_G1_NC
+#define R_AARCH64_MOVW_PREL_G1_NC	290
+#endif
+#ifndef R_AARCH64_MOVW_PREL_G2
+#define R_AARCH64_MOVW_PREL_G2		291
+#endif
+#ifndef R_AARCH64_MOVW_PREL_G2_NC
+#define R_AARCH64_MOVW_PREL_G2_NC	292
+#endif
+#ifndef R_AARCH64_MOVW_PREL_G3
+#define R_AARCH64_MOVW_PREL_G3		293
+#endif
+#ifndef R_AARCH64_LDST128_ABS_LO12_NC
+#define R_AARCH64_LDST128_ABS_LO12_NC	299
+#endif
+
+/* Global state of the processed ELF. */
+static struct {
+	const char	*path;
+	char		*begin;
+	size_t		size;
+	Elf64_Ehdr	*ehdr;
+	Elf64_Shdr	*sh_table;
+	const char	*sh_string;
+} elf;
+
+#define fatal_error(fmt, ...)						\
+	({								\
+		fprintf(stderr, "error: %s: " fmt "\n",			\
+			elf.path, ## __VA_ARGS__);			\
+		exit(EXIT_FAILURE);					\
+		__builtin_unreachable();				\
+	})
+
+#define fatal_perror(msg)						\
+	({								\
+		fprintf(stderr, "error: %s: " msg ": %s\n",		\
+			elf.path, strerror(errno));			\
+		exit(EXIT_FAILURE);					\
+		__builtin_unreachable();				\
+	})
+
+#define assert_op(lhs, rhs, fmt, op)					\
+	({								\
+		typeof(lhs) _lhs = (lhs);				\
+		typeof(rhs) _rhs = (rhs);				\
+									\
+		if (!(_lhs op _rhs)) {					\
+			fatal_error("assertion " #lhs " " #op " " #rhs	\
+				" failed (lhs=" fmt ", rhs=" fmt	\
+				", line=%d)", _lhs, _rhs, __LINE__);	\
+		}							\
+	})
+
+#define assert_eq(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, ==)
+#define assert_ne(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, !=)
+#define assert_lt(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, <)
+#define assert_ge(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, >=)
+
+/*
+ * Return a pointer of a given type at a given offset from
+ * the beginning of the ELF file.
+ */
+#define elf_ptr(type, off) ((type *)(elf.begin + (off)))
+
+/* Iterate over all sections in the ELF. */
+#define for_each_section(var) \
+	for (var = elf.sh_table; var < elf.sh_table + elf.ehdr->e_shnum; ++var)
+
+/* Iterate over all Elf64_Rela relocations in a given section. */
+#define for_each_rela(shdr, var)					\
+	for (var = elf_ptr(Elf64_Rela, shdr->sh_offset);		\
+	     var < elf_ptr(Elf64_Rela, shdr->sh_offset + shdr->sh_size); var++)
+
+/* True if a string starts with a given prefix. */
+static inline bool starts_with(const char *str, const char *prefix)
+{
+	return memcmp(str, prefix, strlen(prefix)) == 0;
+}
+
+/* Returns a string containing the name of a given section. */
+static inline const char *section_name(Elf64_Shdr *shdr)
+{
+	return elf.sh_string + shdr->sh_name;
+}
+
+/* Returns a pointer to the first byte of section data. */
+static inline const char *section_begin(Elf64_Shdr *shdr)
+{
+	return elf_ptr(char, shdr->sh_offset);
+}
+
+/* Find a section by its offset from the beginning of the file. */
+static inline Elf64_Shdr *section_by_off(Elf64_Off off)
+{
+	assert_ne(off, 0UL, "%lu");
+	return elf_ptr(Elf64_Shdr, off);
+}
+
+/* Find a section by its index. */
+static inline Elf64_Shdr *section_by_idx(uint16_t idx)
+{
+	assert_ne(idx, SHN_UNDEF, "%u");
+	return &elf.sh_table[idx];
+}
+
+/*
+ * Memory-map the given ELF file, perform sanity checks, and
+ * populate global state.
+ */
+static void init_elf(const char *path)
+{
+	int fd, ret;
+	struct stat stat;
+
+	/* Store path in the global struct for error printing. */
+	elf.path = path;
+
+	/* Open the ELF file. */
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		fatal_perror("Could not open ELF file");
+
+	/* Get status of ELF file to obtain its size. */
+	ret = fstat(fd, &stat);
+	if (ret < 0) {
+		close(fd);
+		fatal_perror("Could not get status of ELF file");
+	}
+
+	/* mmap() the entire ELF file read-only at an arbitrary address. */
+	elf.begin = mmap(0, stat.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (elf.begin == MAP_FAILED) {
+		close(fd);
+		fatal_perror("Could not mmap ELF file");
+	}
+
+	/* mmap() was successful, close the FD. */
+	close(fd);
+
+	/* Get pointer to the ELF header. */
+	assert_ge(stat.st_size, sizeof(*elf.ehdr), "%lu");
+	elf.ehdr = elf_ptr(Elf64_Ehdr, 0);
+
+	/* Check the ELF magic. */
+	assert_eq(elf.ehdr->e_ident[EI_MAG0], ELFMAG0, "0x%x");
+	assert_eq(elf.ehdr->e_ident[EI_MAG1], ELFMAG1, "0x%x");
+	assert_eq(elf.ehdr->e_ident[EI_MAG2], ELFMAG2, "0x%x");
+	assert_eq(elf.ehdr->e_ident[EI_MAG3], ELFMAG3, "0x%x");
+
+	/* Sanity check that this is an ELF64 relocatable object for AArch64. */
+	assert_eq(elf.ehdr->e_ident[EI_CLASS], ELFCLASS64, "%u");
+	assert_eq(elf.ehdr->e_ident[EI_DATA], ELFDATA2LSB, "%u");
+	assert_eq(elf.ehdr->e_type, ET_REL, "%u");
+	assert_eq(elf.ehdr->e_machine, EM_AARCH64, "%u");
+
+	/* Populate fields of the global struct. */
+	elf.sh_table = section_by_off(elf.ehdr->e_shoff);
+	elf.sh_string = section_begin(section_by_idx(elf.ehdr->e_shstrndx));
+}
+
+/* Print the prologue of the output ASM file. */
+static void emit_prologue(void)
+{
+	printf(".data\n"
+	       ".pushsection " HYP_RELOC_SECTION ", \"a\"\n");
+}
+
+/* Print ASM statements needed as a prologue to a processed hyp section. */
+static void emit_section_prologue(const char *sh_orig_name)
+{
+	/* Declare the hyp section symbol. */
+	printf(".global %s%s\n", HYP_SECTION_SYMBOL_PREFIX, sh_orig_name);
+}
+
+/*
+ * Print ASM statements to create a hyp relocation entry for a given
+ * R_AARCH64_ABS64 relocation.
+ *
+ * The linker of vmlinux will populate the position given by `rela` with
+ * an absolute 64-bit kernel VA. If the kernel is relocatable, it will
+ * also generate a dynamic relocation entry so that the kernel can shift
+ * the address at runtime for KASLR.
+ *
+ * Emit a 32-bit offset from the current address to the position given
+ * by `rela`. This way the kernel can iterate over all kernel VAs used
+ * by hyp at runtime and convert them to hyp VAs. However, that offset
+ * will not be known until linking of `vmlinux`, so emit a PREL32
+ * relocation referencing a symbol that the hyp linker script put at
+ * the beginning of the relocated section + the offset from `rela`.
+ */
+static void emit_rela_abs64(Elf64_Rela *rela, const char *sh_orig_name)
+{
+	/* Offset of this reloc from the beginning of HYP_RELOC_SECTION. */
+	static size_t reloc_offset;
+
+	/* Create storage for the 32-bit offset. */
+	printf(".word 0\n");
+
+	/*
+	 * Create a PREL32 relocation which instructs the linker of `vmlinux`
+	 * to insert offset to position <base> + <offset>, where <base> is
+	 * a symbol at the beginning of the relocated section, and <offset>
+	 * is `rela->r_offset`.
+	 */
+	printf(".reloc %lu, R_AARCH64_PREL32, %s%s + 0x%lx\n",
+		reloc_offset, HYP_SECTION_SYMBOL_PREFIX, sh_orig_name,
+		rela->r_offset);
+
+	reloc_offset += 4;
+}
+
+/* Print the epilogue of the output ASM file. */
+static void emit_epilogue(void)
+{
+	printf(".popsection\n");
+}
+
+/*
+ * Iterate over all RELA relocations in a given section and emit
+ * hyp relocation data for all absolute addresses in hyp code/data.
+ *
+ * Static relocations that generate PC-relative-addressing are ignored.
+ * Failure is reported for unexpected relocation types.
+ */
+static void emit_rela_section(Elf64_Shdr *sh_rela)
+{
+	Elf64_Shdr *sh_orig = &elf.sh_table[sh_rela->sh_info];
+	const char *sh_orig_name = section_name(sh_orig);
+	Elf64_Rela *rela;
+
+	/* Skip all non-hyp sections. */
+	if (!starts_with(sh_orig_name, HYP_SECTION_PREFIX))
+		return;
+
+	emit_section_prologue(sh_orig_name);
+
+	for_each_rela(sh_rela, rela) {
+		uint32_t type = (uint32_t)rela->r_info;
+
+		/* Check that rela points inside the relocated section. */
+		assert_lt(rela->r_offset, sh_orig->sh_size, "0x%lx");
+
+		switch (type) {
+		/*
+		 * Data relocations to generate absolute addressing.
+		 * Emit a hyp relocation.
+		 */
+		case R_AARCH64_ABS64:
+			emit_rela_abs64(rela, sh_orig_name);
+			break;
+		/* Allow relocations to generate PC-relative addressing. */
+		case R_AARCH64_LD_PREL_LO19:
+		case R_AARCH64_ADR_PREL_LO21:
+		case R_AARCH64_ADR_PREL_PG_HI21:
+		case R_AARCH64_ADR_PREL_PG_HI21_NC:
+		case R_AARCH64_ADD_ABS_LO12_NC:
+		case R_AARCH64_LDST8_ABS_LO12_NC:
+		case R_AARCH64_LDST16_ABS_LO12_NC:
+		case R_AARCH64_LDST32_ABS_LO12_NC:
+		case R_AARCH64_LDST64_ABS_LO12_NC:
+		case R_AARCH64_LDST128_ABS_LO12_NC:
+			break;
+		/* Allow relative relocations for control-flow instructions. */
+		case R_AARCH64_TSTBR14:
+		case R_AARCH64_CONDBR19:
+		case R_AARCH64_JUMP26:
+		case R_AARCH64_CALL26:
+			break;
+		/* Allow group relocations to create PC-relative offset inline. */
+		case R_AARCH64_MOVW_PREL_G0:
+		case R_AARCH64_MOVW_PREL_G0_NC:
+		case R_AARCH64_MOVW_PREL_G1:
+		case R_AARCH64_MOVW_PREL_G1_NC:
+		case R_AARCH64_MOVW_PREL_G2:
+		case R_AARCH64_MOVW_PREL_G2_NC:
+		case R_AARCH64_MOVW_PREL_G3:
+			break;
+		default:
+			fatal_error("Unexpected RELA type %u", type);
+		}
+	}
+}
+
+/* Iterate over all sections and emit hyp relocation data for RELA sections. */
+static void emit_all_relocs(void)
+{
+	Elf64_Shdr *shdr;
+
+	for_each_section(shdr) {
+		switch (shdr->sh_type) {
+		case SHT_REL:
+			fatal_error("Unexpected SHT_REL section \"%s\"",
+				section_name(shdr));
+		case SHT_RELA:
+			emit_rela_section(shdr);
+			break;
+		}
+	}
+}
+
+int main(int argc, const char **argv)
+{
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <elf_input>\n", argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	init_elf(argv[1]);
+
+	emit_prologue();
+	emit_all_relocs();
+	emit_epilogue();
+
+	return EXIT_SUCCESS;
+}
-- 
2.29.2.729.g45daf8777d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
