Return-Path: <SRS0=nzcv=65=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6332C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 730F4207CB
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="a2mePthr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 730F4207CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 185A14B4D7;
	Fri, 15 May 2020 06:59:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qv8CLOVOWWdE; Fri, 15 May 2020 06:59:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF6924B4F3;
	Fri, 15 May 2020 06:59:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E69484B4D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S0OXa+tLN-FF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2020 06:59:03 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 590664B4DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:02 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id w64so2161558wmg.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 03:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=WNlsZuKpbaQAO6z1kYuuvPgoFNE3ZTHmZItsK3A1s/4=;
 b=a2mePthrCkqiv1vOToW6CSfM1wFwyuINH7E8m7j8zyotUbo2SiNOEq+uMYyTMNBrtJ
 E/gcD+YlaC+y93uhxlTueo9WVda7X9RPZS9K9DakyLmz4dxE7PEbobbL0dVXCmzJvfwK
 uSYXjdVnwaCRcDVzs1ieIkpKYKB31AtCEcrjY/80JPlRcYqaYZHFB62siP6rxzQ62HlC
 39GnrwVZIFOPec4OPezzfAKoarg0qnJu/kfJUsLlac1ZOV5MD/UkDmsQ9mJRqlPyCIPC
 hO0pFxf+gCVfPSSf3D5JAeZ9sNEjhuHQ/Rl9LGLWrQA7jVHDWX+zL/dPlq28Yb5Vz9lH
 QAmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=WNlsZuKpbaQAO6z1kYuuvPgoFNE3ZTHmZItsK3A1s/4=;
 b=aOM2BZBvn11a3laK6pLZ9bJvn3sw3s6lFZOOknBMTDB/ubIbOOyai2tiWklRtr+W6n
 N3S4zGhdAM+ZpvizcLeYJ3gIZ5k4Dfs8epl0N/hZ+RusTQm0PCCeH7uWj20cFz3kes9K
 xfLLKPt4hT7BUe768fpZCNSkCNmnCgT+HrO7IlAIznz5Wc5vEZqQLvgcpACJYAHjikQV
 596oBoKJp2eK3LxRjEFat71JWQrhpMauIq3BT2hZcyWWFlwLJzFOEnoiEfSqNaO3pe8s
 oN0GWoRZTMtwFMPrLmzNP9EYJiPXXflpLTMRdzbq1coaB/7D53ONzOmndFkASQH1BkGC
 RzlQ==
X-Gm-Message-State: AOAM530STfLKX3R97+ez3bI/6abgBLGBrRPW4RwGMbkp4Dwzc3P0mHwx
 Il8MrXb+I3REZO+Ann5fPKxTRw==
X-Google-Smtp-Source: ABdhPJzyvDNr0FNuz6vpDMEhT8+N3AHdMTtoUX6V7+HUHnGp3w2eUv3jrhxHrrXAFF5VEGySY19F+g==
X-Received: by 2002:a7b:c778:: with SMTP id x24mr3625426wmk.144.1589540341191; 
 Fri, 15 May 2020 03:59:01 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d11b:f847:8002:7411])
 by smtp.gmail.com with ESMTPSA id p9sm3130293wrj.29.2020.05.15.03.59.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 May 2020 03:59:00 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v2 04/14] arm64: kvm: Add build rules for separate nVHE object
 files
Date: Fri, 15 May 2020 11:58:31 +0100
Message-Id: <20200515105841.73532-5-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515105841.73532-1-dbrazdil@google.com>
References: <20200515105841.73532-1-dbrazdil@google.com>
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
its symbols with "__kvm_nvhe_" using `objcopy` and produce a `.hyp.o`.
Suffixes were chosen so that it would be possible for VHE and nVHE to share
some source files, but compiled with different CFLAGS. nVHE build rules add
-D__KVM_NVHE_HYPERVISOR__.

The nVHE ELF symbol prefix is added to kallsyms.c as ignored. EL2-only symbols
will never appear in EL1 stack traces.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/image-vars.h   | 12 +++++++++++
 arch/arm64/kvm/hyp/Makefile      |  4 ++--
 arch/arm64/kvm/hyp/nvhe/Makefile | 35 ++++++++++++++++++++++++++++++++
 scripts/kallsyms.c               |  1 +
 4 files changed, 50 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/Makefile

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
index 5d8357ddc234..c9fd8618980d 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -6,10 +6,10 @@
 ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 		$(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += hyp.o
+obj-$(CONFIG_KVM) += vhe.o nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
-hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
+vhe-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
 	 debug-sr.o entry.o switch.o fpsimd.o tlb.o hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
new file mode 100644
index 000000000000..7d64235dba62
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -0,0 +1,35 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for Kernel-based Virtual Machine module, HYP/nVHE part
+#
+
+asflags-y := -D__KVM_NVHE_HYPERVISOR__
+ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -fno-stack-protector \
+	     -DDISABLE_BRANCH_PROFILING $(DISABLE_STACKLEAK_PLUGIN)
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
+      cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__kvm_nvhe_ $< $@
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
index 3e8dea6e0a95..523a1a337ebd 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -109,6 +109,7 @@ static bool is_ignored_symbol(const char *name, char type)
 		".LASANPC",		/* s390 kasan local symbols */
 		"__crc_",		/* modversions */
 		"__efistub_",		/* arm64 EFI stub namespace */
+		"__kvm_nvhe_",		/* arm64 non-VHE KVM namespace */
 		NULL
 	};
 
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
