Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D988C2BB84
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:34:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0BF9222464
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="PCdTbfdD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BF9222464
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1A0F4B4D2;
	Wed, 16 Sep 2020 13:34:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HgFbHtJvCPnD; Wed, 16 Sep 2020 13:34:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 236974B4E1;
	Wed, 16 Sep 2020 13:34:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E3BE4B4A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NJW4rkGo5CbI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 13:34:49 -0400 (EDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2A7C4B3AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:34:48 -0400 (EDT)
Received: by mail-wm1-f52.google.com with SMTP id e17so3581463wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 10:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=jeccRoVH2xzd2nQpZdaO6Z+WgudupLqXpR0BDecSqSQ=;
 b=PCdTbfdDQ/ZI/CI69hr6atdnbbkN1TozI1DD1MkQa16lxMvmQu52uc4k3a9neBl9jh
 5nkow1vbp1XzL5hRIFTrHl6gtF7ejYHqYb18RwIHoF+hKN80s197Hu7VywjYXmXbWLMm
 /sEe6JF5T3Dc2XtbHW64AotI8hwXowHxuZtLJEDTMIRTN655L8AvZxnFuqRqdTDLtafc
 WhT2AQQp3DBQsic9bNzoZoM9ENaP+DbSEFYaiU5B86/vfNdHhEBSjSR/SXAM4YAgT8+Y
 ty/yTr3FK4YDXEHSCVra6JmPkydeZ1zmORW7VxGB46T4DW4tnL8OTufsJ0HvX2kPuX4J
 uTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=jeccRoVH2xzd2nQpZdaO6Z+WgudupLqXpR0BDecSqSQ=;
 b=KFKQc+6m0zM9dUhhhaSNuSqIMk/tW51bIkBOyoGqVBS6ho39Q7mON+/tyaZu8TgPZq
 nkM1ZeYo8IKVSnOni0USE1L3CmBp71DttLGEYcdXmc6yUv1h/6Ue44MVfrpqU/ODoet7
 dgFrlpxWUzVDknA2RkKI3JTjBh9cvuKQZwvf2BqgVKEOOpoOHVJ3+bJnw3mUJQeSo3E7
 Uo5x2qosQibELWmkdJnIIGMO1bLVri0im4fLu1yvn1+R7c363E0bklnEZiEBa4wo3hiS
 Ltki02J0scb67LMBgr3AftxtjoIGIoUT/gpgv1sqoqHB69tTN6f8ac5eAsYV1KYHk5g7
 qE9w==
X-Gm-Message-State: AOAM532RKR57KEx9aec4oyFRloZYBTeNjIeKp9U9kMPud8RVwSn0JmEK
 7JbyGjTWPaUGf/89xRfChbnb7mTG3e8deIuS
X-Google-Smtp-Source: ABdhPJxtYWNdopesl9Q0NNtQrGFhJvZo052EApCUbh7x2DWg3tiDSUR1Z+UKPrMRUBzu4fiWi1PJnw==
X-Received: by 2002:a1c:e90b:: with SMTP id q11mr5819113wmc.39.1600277687253; 
 Wed, 16 Sep 2020 10:34:47 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id z83sm6911988wmb.4.2020.09.16.10.34.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Sep 2020 10:34:46 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 01/11] kvm: arm64: Partially link nVHE hyp code,
 simplify HYPCOPY
Date: Wed, 16 Sep 2020 18:34:29 +0100
Message-Id: <20200916173439.32265-2-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916173439.32265-1-dbrazdil@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
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

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/hyp_image.h | 24 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   | 60 ++++++++++++++++--------------
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S  | 13 +++++++
 3 files changed, 70 insertions(+), 27 deletions(-)
 create mode 100644 arch/arm64/include/asm/hyp_image.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp.lds.S

diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
new file mode 100644
index 000000000000..5b1e3b9ef376
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
+	HYP_SECTION_NAME(NAME) : { *(NAME NAME##.[0-9a-zA-Z_]*) }
+
+#endif /* LINKER_SCRIPT */
+
+#endif /* __ARM64_HYP_IMAGE_H__ */
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
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
