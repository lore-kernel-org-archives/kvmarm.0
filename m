Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCF6C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 840C220857
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="GOCuZWYr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 840C220857
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 404CF4B407;
	Thu, 25 Jun 2020 09:14:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id by8DhKJyWtRu; Thu, 25 Jun 2020 09:14:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13B204B543;
	Thu, 25 Jun 2020 09:14:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD9574B2E0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dpE4wME77hAZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:30 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A83084B54B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:30 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id t194so5881580wmt.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=gqQTH97HtY38hoyHVjBtUD2yI3/M5sungIhVTZmvSaI=;
 b=GOCuZWYrfvWWj5emPIMjcBA3NlpdFL5BZ43NdBMXbB8zZ3B81DmJXO8vCVuGzVo1Xc
 Y16TbKwn9hN7elpN37ANd/VPU3tt0wE5OHP7fk/WCQzmP+YuGX4Ta2r48koYnodYRMzK
 1gC42/4mFCeRKFzvIJU7fNtipSFpX716yzu0+pIbI6JzfN5YGpgMPdnwXY+7dv+B7HdI
 ASk+l1fz6lNfAyu4YTXEMx/Mw6mlgsj4Jv18Ewe+ZGRz7ftDj6DXjyMXefYyZiiRC/u+
 vQqCYIXd7sVXaaAG4PtL1NOYOGwMdVsU+kBsKGLwZvRRVK/t4Xt7wIvoj5y+U7O4uT4U
 b0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=gqQTH97HtY38hoyHVjBtUD2yI3/M5sungIhVTZmvSaI=;
 b=tXq1GuOeYUtw9kg6jilOYd2nt25x4ttiI3svM3VWAAUdXdxdexYCjaYhhc3Ft7Ai8+
 AC5tzNkdO6NA9NWLYXoDiH2Se3filrgoypLUdX1GJR+7PRBb7XXM+YFfvHZ70zqTEuMj
 0In7XipFbjOSwyf33R/Tb4+whaYkBDlDxLI3bPzO0dmgwaAJoAcdQ7k7GxLNrzOVG+Jq
 b1DkkIHPae46zeeOjceOHd1OjHl8R5NilGxwsrM7tVbsz41U0yiYCGQHawDI530dwT0I
 G7k3p0P48V2PAJMgGLWDssDYX97ojTXw61gS6dJerrHk13F81+DE4a9Dk45ZJfVy3n3K
 J6Lg==
X-Gm-Message-State: AOAM530gMRH3Yl/WQu6QEGN2ZBIiTviKsUwlrpgY3BJL/yXKFLvSuy4p
 ccP3Z9E2XZeUIU7brlQfmwh+ng==
X-Google-Smtp-Source: ABdhPJwaokAKPaTtdDxI+IVCVgh0HO5v1xcjChmdSVNVz+edayYBMWriz+QIPgrgrr3c2K0F2FeUug==
X-Received: by 2002:a05:600c:2241:: with SMTP id
 a1mr3241729wmm.168.1593090869555; 
 Thu, 25 Jun 2020 06:14:29 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id d132sm12325895wmd.35.2020.06.25.06.14.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:28 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 03/15] arm64: kvm: Add build rules for separate VHE/nVHE
 object files
Date: Thu, 25 Jun 2020 14:14:08 +0100
Message-Id: <20200625131420.71444-4-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625131420.71444-1-dbrazdil@google.com>
References: <20200625131420.71444-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Add new folders arch/arm64/kvm/hyp/{vhe,nvhe} and Makefiles for building code
that runs in EL2 under VHE/nVHE KVM, repsectivelly. Add an include folder for
hyp-specific header files which will include code common to VHE/nVHE.

Build nVHE code with -D__KVM_NVHE_HYPERVISOR__, VHE code with
-D__KVM_VHE_HYPERVISOR__.

Under nVHE compile each source file into a `.hyp.tmp.o` object first, then
prefix all its symbols with "__kvm_nvhe_" using `objcopy` and produce
a `.hyp.o`. Suffixes were chosen so that it would be possible for VHE and nVHE
to share some source files, but compiled with different CFLAGS.

The nVHE ELF symbol prefix is added to kallsyms.c as ignored. EL2-only symbols
will never appear in EL1 stack traces.

Due to symbol prefixing, add a section in image-vars.h for aliases of symbols
that are defined in nVHE EL2 and accessed by kernel in EL1 or vice versa.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/image-vars.h   | 14 +++++++++++++
 arch/arm64/kvm/hyp/Makefile      | 10 +++++++---
 arch/arm64/kvm/hyp/nvhe/Makefile | 34 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/Makefile  | 17 ++++++++++++++++
 scripts/kallsyms.c               |  1 +
 5 files changed, 73 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/Makefile
 create mode 100644 arch/arm64/kvm/hyp/vhe/Makefile

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index be0a63ffed23..3dc27da47712 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -51,4 +51,18 @@ __efistub__ctype		= _ctype;
 
 #endif
 
+#ifdef CONFIG_KVM
+
+/*
+ * KVM nVHE code has its own symbol namespace prefixed with __kvm_nvhe_, to
+ * separate it from the kernel proper. The following symbols are legally
+ * accessed by it, therefore provide aliases to make them linkable.
+ * Do not include symbols which may not be safely accessed under hypervisor
+ * memory mappings.
+ */
+
+#define KVM_NVHE_ALIAS(sym) __kvm_nvhe_##sym = sym;
+
+#endif /* CONFIG_KVM */
+
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 5d8357ddc234..9c5dfe6ff80b 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -3,10 +3,14 @@
 # Makefile for Kernel-based Virtual Machine module, HYP part
 #
 
-ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
-		$(DISABLE_STACKLEAK_PLUGIN)
+incdir := $(srctree)/$(src)/include
+subdir-asflags-y := -I$(incdir)
+subdir-ccflags-y := -I$(incdir)				\
+		    -fno-stack-protector		\
+		    -DDISABLE_BRANCH_PROFILING		\
+		    $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += hyp.o
+obj-$(CONFIG_KVM) += hyp.o nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
 hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
new file mode 100644
index 000000000000..955f4188e00f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -0,0 +1,34 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for Kernel-based Virtual Machine module, HYP/nVHE part
+#
+
+asflags-y := -D__KVM_NVHE_HYPERVISOR__
+ccflags-y := -D__KVM_NVHE_HYPERVISOR__
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
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
new file mode 100644
index 000000000000..e04375546081
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for Kernel-based Virtual Machine module, HYP/nVHE part
+#
+
+asflags-y := -D__KVM_VHE_HYPERVISOR__
+ccflags-y := -D__KVM_VHE_HYPERVISOR__
+
+obj-y :=
+
+# KVM code is run at a different exception code with a different map, so
+# compiler instrumentation that inserts callbacks or checks into the code may
+# cause crashes. Just disable it.
+GCOV_PROFILE	:= n
+KASAN_SANITIZE	:= n
+UBSAN_SANITIZE	:= n
+KCOV_INSTRUMENT	:= n
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 6dc3078649fa..0096cd965332 100644
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
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
