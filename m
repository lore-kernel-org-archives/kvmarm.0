Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CA2C4727D
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB2B62376F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="hJj9lEEE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB2B62376F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2CC4B2FB;
	Tue, 22 Sep 2020 16:49:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vku1qepvurcC; Tue, 22 Sep 2020 16:49:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE0B04B318;
	Tue, 22 Sep 2020 16:49:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A458C4B2F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 94ZnEwYJwelP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 16:49:16 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69EEB4B2E6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:16 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id x23so4760105wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=n8WMvh/M36m/HHZO4bZ/eAus+osznWrqnXUcsLjXplE=;
 b=hJj9lEEERmhN4+sqAp+uIFAVssLdQlctJRz7NU1SWitKX7yBNAnGt77GefD2gQRGRe
 NtzY80oMmPr8YO59ngaGHO4s9C+J82THeYIDB49v8POeevew/PaXUZbiKjsWfM4NHtMx
 iO8hHiU3Zbe3MiRrhCnHmi249L6ujezpVStQQQgNYYhIHUY6Xej/lKhXg7sjDH/1wsHw
 p8kqRLVDEUiD5I9Gv2Ip5Iuytq6zvRtEG1DGf2WD372uAAWRj1HkDcKVWjcQjK99NtCD
 BH65rPUaqv1FtuY0jljPGjvw7SrfDgYiexm3Snbtl3mQWQhIgWvHOcGOLLOKedNMpgoR
 SCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=n8WMvh/M36m/HHZO4bZ/eAus+osznWrqnXUcsLjXplE=;
 b=klK1lnejsoPJDiY8+H2GwLebGXstWaTXDb2xydstEDpfif22DEHN8M5s3sZ+Nt3iae
 /Ge9adebAfCuZtNlCFY3CZugMYxQ4dnazzGVoy1d4NGbMETdRhDltymNukOVI8kMkPk+
 G+Et8H1hcXUlPVebHY4Nej7ZYdDVv7nAmJMflw57JIRPXdBnjzONcwG32A6taTXIdKEo
 FR8S/TNdwijcy0xF7JKI+21tK9t3gUJ06GWAgSRk12Dn2FWIbls42H0f4IEN2wvBbY36
 zjxJI/I4lEKn2KpFxJs+SEsMdplKyFhlp07yMr1vZY0a4POeul+QKjYeGRG/QK7Ax5Oi
 lapQ==
X-Gm-Message-State: AOAM530w+yGFfNjfu0FkJb+lR565PbqDiZfmlFqI1XVZVW38I4bH0nXz
 2bwF1IAjJQYxt9zgC01siNEkAYsVJ402jQOy
X-Google-Smtp-Source: ABdhPJy7KYvLvnPwj2fGqUP63Em4mHW7Y2V0uBzNAe8iy7rM6p/ip38nATWJ70G4xFS82vyj3GApsw==
X-Received: by 2002:a1c:a988:: with SMTP id s130mr2813995wme.31.1600807755125; 
 Tue, 22 Sep 2020 13:49:15 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:1105:630f:e990:272f])
 by smtp.gmail.com with ESMTPSA id t6sm30408813wre.30.2020.09.22.13.49.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Sep 2020 13:49:14 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 01/10] kvm: arm64: Partially link nVHE hyp code,
 simplify HYPCOPY
Date: Tue, 22 Sep 2020 21:49:01 +0100
Message-Id: <20200922204910.7265-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922204910.7265-1-dbrazdil@google.com>
References: <20200922204910.7265-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

Relying on objcopy to prefix the ELF section names of the nVHE hyp code
is brittle and prevents us from using wildcards to match specific
section names.

Improve the build rules by partially linking all '.nvhe.o' files and
prefixing their ELF section names using a linker script. Continue using
objcopy for prefixing ELF symbol names.

One immediate advantage of this approach is that all subsections
matching a pattern can be merged into a single prefixed section, eg.
.text and .text.* can be linked into a single '.hyp.text'. This removes
the need for -fno-reorder-functions on GCC and will be useful in the
future too: LTO builds use .text subsections, compilers routinely
generate .rodata subsections, etc.

Partially linking all hyp code into a single object file also makes it
easier to analyze.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/hyp_image.h | 24 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/.gitignore |  2 +
 arch/arm64/kvm/hyp/nvhe/Makefile   | 60 ++++++++++++++++--------------
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S  | 13 +++++++
 4 files changed, 72 insertions(+), 27 deletions(-)
 create mode 100644 arch/arm64/include/asm/hyp_image.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/.gitignore
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp.lds.S

diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
new file mode 100644
index 000000000000..2e38fcda02fc
--- /dev/null
+++ b/arch/arm64/include/asm/hyp_image.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Google LLC.
+ * Written by David Brazdil <dbrazdil@google.com>
+ */
+
+#ifndef __ARM64_HYP_IMAGE_H__
+#define __ARM64_HYP_IMAGE_H__
+
+#ifdef LINKER_SCRIPT
+
+/*
+ * KVM nVHE ELF section names are prefixed with .hyp, to separate them
+ * from the kernel proper.
+ */
+#define HYP_SECTION_NAME(NAME)	.hyp##NAME
+
+/* Defines an ELF hyp section from input section @NAME and its subsections. */
+#define HYP_SECTION(NAME) \
+	HYP_SECTION_NAME(NAME) : { *(NAME NAME##.*) }
+
+#endif /* LINKER_SCRIPT */
+
+#endif /* __ARM64_HYP_IMAGE_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/.gitignore b/arch/arm64/kvm/hyp/nvhe/.gitignore
new file mode 100644
index 000000000000..695d73d0249e
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+hyp.lds
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index aef76487edc2..2b27b60182f9 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -10,40 +10,46 @@ obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
-obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
-extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
+##
+## Build rules for compiling nVHE hyp code
+## Output of this folder is `kvm_nvhe.o`, a partially linked object
+## file containing all nVHE hyp code and data.
+##
 
-$(obj)/%.hyp.tmp.o: $(src)/%.c FORCE
+hyp-obj := $(patsubst %.o,%.nvhe.o,$(obj-y))
+obj-y := kvm_nvhe.o
+extra-y := $(hyp-obj) kvm_nvhe.tmp.o hyp.lds
+
+# 1) Compile all source files to `.nvhe.o` object files. The file extension
+#    avoids file name clashes for files shared with VHE.
+$(obj)/%.nvhe.o: $(src)/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
-$(obj)/%.hyp.tmp.o: $(src)/%.S FORCE
+$(obj)/%.nvhe.o: $(src)/%.S FORCE
 	$(call if_changed_rule,as_o_S)
-$(obj)/%.hyp.o: $(obj)/%.hyp.tmp.o FORCE
-	$(call if_changed,hypcopy)
 
-# Disable reordering functions by GCC (enabled at -O2).
-# This pass puts functions into '.text.*' sections to aid the linker
-# in optimizing ELF layout. See HYPCOPY comment below for more info.
-ccflags-y += $(call cc-option,-fno-reorder-functions)
+# 2) Compile linker script.
+$(obj)/hyp.lds: $(src)/hyp.lds.S FORCE
+	$(call if_changed_dep,cpp_lds_S)
+
+# 3) Partially link all '.nvhe.o' files and apply the linker script.
+#    Prefixes names of ELF sections with '.hyp', eg. '.hyp.text'.
+#    Note: The following rule assumes that the 'ld' rule puts LDFLAGS before
+#          the list of dependencies to form '-T $(obj)/hyp.lds'. This is to
+#          keep the dependency on the target while avoiding an error from
+#          GNU ld if the linker script is passed to it twice.
+LDFLAGS_kvm_nvhe.tmp.o := -r -T
+$(obj)/kvm_nvhe.tmp.o: $(obj)/hyp.lds $(addprefix $(obj)/,$(hyp-obj)) FORCE
+	$(call if_changed,ld)
+
+# 4) Produce the final 'kvm_nvhe.o', ready to be linked into 'vmlinux'.
+#    Prefixes names of ELF symbols with '__kvm_nvhe_'.
+$(obj)/kvm_nvhe.o: $(obj)/kvm_nvhe.tmp.o FORCE
+	$(call if_changed,hypcopy)
 
 # The HYPCOPY command uses `objcopy` to prefix all ELF symbol names
-# and relevant ELF section names to avoid clashes with VHE code/data.
-#
-# Hyp code is assumed to be in the '.text' section of the input object
-# files (with the exception of specialized sections such as
-# '.hyp.idmap.text'). This assumption may be broken by a compiler that
-# divides code into sections like '.text.unlikely' so as to optimize
-# ELF layout. HYPCOPY checks that no such sections exist in the input
-# using `objdump`, otherwise they would be linked together with other
-# kernel code and not memory-mapped correctly at runtime.
+# to avoid clashes with VHE code/data.
 quiet_cmd_hypcopy = HYPCOPY $@
-      cmd_hypcopy =							\
-	if $(OBJDUMP) -h $< | grep -F '.text.'; then			\
-		echo "$@: function reordering not supported in nVHE hyp code" >&2; \
-		/bin/false;						\
-	fi;								\
-	$(OBJCOPY) --prefix-symbols=__kvm_nvhe_				\
-		   --rename-section=.text=.hyp.text			\
-		   $< $@
+      cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__kvm_nvhe_ $< $@
 
 # Remove ftrace and Shadow Call Stack CFLAGS.
 # This is equivalent to the 'notrace' and '__noscs' annotations.
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
new file mode 100644
index 000000000000..3b13d1c7cd1a
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Google LLC.
+ * Written by David Brazdil <dbrazdil@google.com>
+ *
+ * Linker script used for partial linking of nVHE EL2 object files.
+ */
+
+#include <asm/hyp_image.h>
+
+SECTIONS {
+	HYP_SECTION(.text)
+}
-- 
2.28.0.681.g6f77f65b4e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
