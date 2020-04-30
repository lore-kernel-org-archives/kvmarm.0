Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6F7C4724C
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:48:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7FE932074A
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="bjghkyai"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FE932074A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38AD34B502;
	Thu, 30 Apr 2020 10:48:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wBuCNEV0qZZe; Thu, 30 Apr 2020 10:48:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F20BF4B505;
	Thu, 30 Apr 2020 10:48:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B08404B394
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:48:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RiNFhapbFANh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 10:48:53 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 715E64B4FE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:48:53 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id x18so7286197wrq.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=740igj1bEYMW0532toQIm1KV1KgyWGqVpSAfrDZ2cxU=;
 b=bjghkyaiXjdRETcAiyeCoGipb9NpVwpAjTmTZs6UWm1Kf3j9noZdWPBfA6/JgO1Xck
 Ct+KhqIbf8ay/K0N7BvgxJQ4DflwSEfc92VsN+0wtt0Oytn3SkBndtv1EEQIFW4LrvO7
 qnyAHH0oQfFlK5XXXliPZBLVslWR3vvib8D2Ee6Nv9RYFEOJS1DrvvqGjwYqSM9/t5Ew
 ngwk2kC1csd4y6GOOJpBgz6idu4/Os6qKVt0P9dsFf9e4oW3HfqKKlSk6UTO+BjpayIz
 KBE0CfClP2er/3jD+mQvK0ChNjL/z/Mizo8hYwM5GiZC5V/NhZCgFJIx+2qEpfRhs9lS
 4OqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=740igj1bEYMW0532toQIm1KV1KgyWGqVpSAfrDZ2cxU=;
 b=TyP8Bn/SXIEGSQr9SAe+Bmaoq+dDeOdP1IJU1ejzXJYxWzvxwuTMhfUy3JHhPF9/6k
 IP1nZqderZjQs7PHulWFaAc6clJT9CgoinTThMmPGLBx2sQz3/mbRK3tstGgl9LzwpqM
 7aDr/qOlyBVbhdkCzEkZL45nSugvP84urK0vAy39czqko/YTG68lxRErij3AWUrmO/yR
 ETypecWA1XEZp92U7EFlPxlh4886oGKRjchVRgr6iS69bcbH8tJz0LXntHexRIS4nCL0
 XMWZbHx1tvhcY0xNdZDkQnjmqYQMiBTGUjSZBiuWp1em+i4GDE/s41ayzl1VMviVB1mz
 qaDw==
X-Gm-Message-State: AGi0PuabsrD8duqW8XAYktihSCuHPD9mvRkMfeDNG+G8Uw000Ek6etEC
 cubeQVGGHdKSOKGkKg07OmcEzA==
X-Google-Smtp-Source: APiQypIxA6sGXnhh2DZW818CDWrJOloGB/7zrs6zvXqUO6B/T0ZiG4YRLv4p2mhxHk/JReEjy1GROQ==
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr4422939wrp.82.1588258132187; 
 Thu, 30 Apr 2020 07:48:52 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d4b6:9828:8bd2:ce6f])
 by smtp.gmail.com with ESMTPSA id f7sm4132867wrt.10.2020.04.30.07.48.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Apr 2020 07:48:51 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH 04/15] arm64: kvm: Add build rules for separate nVHE object
 files
Date: Thu, 30 Apr 2020 15:48:20 +0100
Message-Id: <20200430144831.59194-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200430144831.59194-1-dbrazdil@google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

Add new folder arch/arm64/kvm/hyp/nvhe and a Makefile for building code that
runs in EL2 under nVHE KVM.

Compile each source file into a `.hyp.tmp.o` object first, then prefix all
its symbols with "__hyp_text_" using `objcopy` and produce a `.hyp.o`.
Suffixes were chosen so that it would be possible for VHE and nVHE to share
some source files, but compiled with different CFLAGS. nVHE build rules add
-D__HYPERVISOR__.

Macros are added for prefixing a nVHE symbol name when referenced from kernel
proper.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 13 ++++++++++++
 arch/arm64/kernel/image-vars.h   | 12 +++++++++++
 arch/arm64/kvm/hyp/Makefile      |  4 ++--
 arch/arm64/kvm/hyp/nvhe/Makefile | 35 ++++++++++++++++++++++++++++++++
 scripts/kallsyms.c               |  1 +
 5 files changed, 63 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/Makefile

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 7c7eeeaab9fa..99ab204519ca 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -42,6 +42,12 @@
 
 #include <linux/mm.h>
 
+/* Translate the name of @sym to its nVHE equivalent. */
+#define kvm_nvhe_sym(sym)	__hyp_text_##sym
+
+/* Choose between VHE and nVHE variants of a symbol. */
+#define kvm_hyp_sym(sym)	(has_vhe() ? sym : kvm_nvhe_sym(sym))
+
 /* Translate a kernel address of @sym into its equivalent linear mapping */
 #define kvm_ksym_ref(sym)						\
 	({								\
@@ -51,6 +57,13 @@
 		val;							\
 	 })
 
+/*
+ * Translate a kernel address of @sym into its equivalent linear mapping,
+ * choosing between VHE and nVHE variant of @sym accordingly.
+ */
+#define kvm_hyp_ref(sym) \
+	(has_vhe() ? kvm_ksym_ref(sym) : kvm_ksym_ref(kvm_nvhe_sym(sym)))
+
 struct kvm;
 struct kvm_vcpu;
 
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 7f06ad93fc95..13850134fc28 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -51,4 +51,16 @@ __efistub__ctype		= _ctype;
 
 #endif
 
+#ifdef CONFIG_KVM
+
+/*
+ * KVM nVHE code has its own symbol namespace prefixed by __hyp_text_, to
+ * isolate it from the kernel proper. The following symbols are legally
+ * accessed by it, therefore provide aliases to make them linkable.
+ * Do not include symbols which may not be safely accessed under hypervisor
+ * memory mappings.
+ */
+
+#endif /* CONFIG_KVM */
+
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 29e2b2cd2fbc..79bf822a484b 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -6,9 +6,9 @@
 ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 		$(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += hyp.o
+obj-$(CONFIG_KVM) += vhe.o nvhe/
 
-hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
+vhe-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
 	 debug-sr.o entry.o switch.o fpsimd.o tlb.o host_hypercall.o hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
new file mode 100644
index 000000000000..873d3ab0fd68
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -0,0 +1,35 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for Kernel-based Virtual Machine module, HYP/nVHE part
+#
+
+asflags-y := -D__HYPERVISOR__
+ccflags-y := -D__HYPERVISOR__ -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
+	     $(DISABLE_STACKLEAK_PLUGIN)
+
+obj-y :=
+
+obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
+extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
+
+$(obj)/%.hyp.tmp.o: $(src)/%.c FORCE
+	$(call if_changed_rule,cc_o_c)
+$(obj)/%.hyp.tmp.o: $(src)/%.S FORCE
+	$(call if_changed_rule,as_o_S)
+$(obj)/%.hyp.o: $(obj)/%.hyp.tmp.o FORCE
+	$(call if_changed,hypcopy)
+
+quiet_cmd_hypcopy = HYPCOPY $@
+      cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__hyp_text_ $< $@
+
+# KVM nVHE code is run at a different exception code with a different map, so
+# compiler instrumentation that inserts callbacks or checks into the code may
+# cause crashes. Just disable it.
+GCOV_PROFILE	:= n
+KASAN_SANITIZE	:= n
+UBSAN_SANITIZE	:= n
+KCOV_INSTRUMENT	:= n
+
+# Skip objtool checking for this directory because nVHE code is compiled with
+# non-standard build rules.
+OBJECT_FILES_NON_STANDARD := y
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 3e8dea6e0a95..b5c9dc6de38d 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -109,6 +109,7 @@ static bool is_ignored_symbol(const char *name, char type)
 		".LASANPC",		/* s390 kasan local symbols */
 		"__crc_",		/* modversions */
 		"__efistub_",		/* arm64 EFI stub namespace */
+		"__hyp_text_",		/* arm64 non-VHE KVM namespace */
 		NULL
 	};
 
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
