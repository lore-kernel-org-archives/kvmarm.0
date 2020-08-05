Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E34C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:26:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 267FC22DFB
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:26:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pK4wi7Os"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 267FC22DFB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7C9C4B47A;
	Wed,  5 Aug 2020 14:26:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZrvzDviPUwBm; Wed,  5 Aug 2020 14:26:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DC484B4E3;
	Wed,  5 Aug 2020 14:26:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C4574B476
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:26:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CwSI8VXzrdIz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 14:26:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0555A4B456
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:26:55 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 26B0C22DD3;
 Wed,  5 Aug 2020 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596652014;
 bh=7hW5fdAsy9PYasogXzYqOTMQluoobizDJMKb9Hv3w00=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=pK4wi7Osrl8uu0SA8+mdHDhANG8e3rU8GbQRkzFyBO9z+xqMe8MvF82nRbhYU7gFt
 2+ZZv/k5bh6Tf1sPrio32//FYKR3yF5JnVJ2qvAjj6Lpp4GK88+YcuclaTQtXs2zke
 FGOp+lvxMqR1V5dOTdV/ulNHgvlWcmih9k4e9YdM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3NfL-0004w9-IN; Wed, 05 Aug 2020 18:57:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 15/56] KVM: arm64: Add build rules for separate VHE/nVHE
 object files
Date: Wed,  5 Aug 2020 18:56:19 +0100
Message-Id: <20200805175700.62775-16-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: David Brazdil <dbrazdil@google.com>

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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200625131420.71444-4-dbrazdil@google.com
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
