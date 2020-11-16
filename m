Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38848C4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C89C722245
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="MsbOd6ta"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C89C722245
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78BEC4C249;
	Mon, 16 Nov 2020 15:43:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dCBL4OIrdt2k; Mon, 16 Nov 2020 15:43:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 508A14C24B;
	Mon, 16 Nov 2020 15:43:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC2EB4C24E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id APyQoTbtFtEM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:48 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1D414C249
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:45 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id d142so590069wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=5iQEQpIF1PXpAPkqqqPgQKLoiJmzjddJihqJJIArDJs=;
 b=MsbOd6taJGyK7f3jVg4pvaqVWGnW7Ka7tJiSpJC8dVUX7bTtwSrQOovl2aoY1bj0Zj
 XuC35VxDT9lGVdsuJHVD3S0e2rK8bi5lOSoiacc2caS8/5OG+cjsVpRLq3kzUFDkaSft
 vA9Dem9PsCnpO2FcF6gwgDyVnvjikI1mOdLD+prS9wMd9YDiYXuM+QdeXNXXj1i9ul7o
 ZOItW+FR33UhFib8M98gFdn3XR1ZxUK+JpKX0FO7pABd/x5x+EI1UujZzO/N4ibNfYDA
 2ioJ/gwpHpWGrSZ5RQxGJXYujKD7yYwzuGGQEl8cUuA5ZItet1KCDXPJfd/yQof2EYw8
 NNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=5iQEQpIF1PXpAPkqqqPgQKLoiJmzjddJihqJJIArDJs=;
 b=RBoYwkr2DVsiczpU6ZMs7yTvpWUsg9y3xhM5LrDLtWWG3Bj8bCluT11LIWZJYDhD9H
 XOledgxCD/yr4YaXW+ClU6kH/sPXtUt5VGQ4PjXW+1kNy3iSocoWgeQJ66shIlPMvGZ+
 8FmRBtFUoyGfnEaV6R8Zji3qOIUq02b4PEWhY5g2uoqZKJ/JUYy1sfPTyvey3TDxgPx2
 1yTLqwTlLNivyKF8KIXlh4TYTzFwHChl7zwzv5Vx0UDM6Pw9fRRcanhQ4+XeNPOXzXDp
 gVuLPQPBsaIhAXtqUAkbn6S/mfjDtFa8pFHnWseKb9a9yAxnAWy56WYIoVBCO8at6pTk
 lb+w==
X-Gm-Message-State: AOAM530uDJd0PY3UtBTJKgROUlE/WvT0AWlKjfNP8gI60T+W91oxp0k6
 lGbtyXHIH/boPVKkV3wjaEmd/rIxIJM/Herwbsw=
X-Google-Smtp-Source: ABdhPJyClWfGvHmjKoEyhOBm6/DvdXlpi5pEWhsc2qE/0XWt+4yi0pu0Mpj5dpRYtOW/TA+NM3pRGA==
X-Received: by 2002:a1c:2384:: with SMTP id j126mr745260wmj.116.1605559424454; 
 Mon, 16 Nov 2020 12:43:44 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id t23sm538884wmn.4.2020.11.16.12.43.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:43 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 10/24] kvm: arm64: Support per_cpu_ptr in nVHE hyp code
Date: Mon, 16 Nov 2020 20:43:04 +0000
Message-Id: <20201116204318.63987-11-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116204318.63987-1-dbrazdil@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
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

When compiling with __KVM_NVHE_HYPERVISOR__ redefine per_cpu_offset() to
__hyp_per_cpu_offset() which looks up the base of the nVHE per-CPU
region of the given cpu and computes its offset from the
.hyp.data..percpu section.

This enables use of per_cpu_ptr() helpers in nVHE hyp code. Until now
only this_cpu_ptr() was supported by setting TPIDR_EL2.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/percpu.h   |  6 ++++++
 arch/arm64/kernel/image-vars.h    |  3 +++
 arch/arm64/kvm/hyp/nvhe/Makefile  |  3 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 24 ++++++++++++++++++++++++
 4 files changed, 35 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-smp.c

diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index 1599e17379d8..8f1661603b78 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -239,6 +239,12 @@ PERCPU_RET_OP(add, add, ldadd)
 #define this_cpu_cmpxchg_8(pcp, o, n)	\
 	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+extern unsigned long __hyp_per_cpu_offset(unsigned int cpu);
+#define __per_cpu_offset
+#define per_cpu_offset(cpu)	__hyp_per_cpu_offset((cpu))
+#endif
+
 #include <asm-generic/percpu.h>
 
 /* Redefine macros for nVHE hyp under DEBUG_PREEMPT to avoid its dependencies. */
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index c615b285ff5b..78a42a7cdb72 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -103,6 +103,9 @@ KVM_NVHE_ALIAS(gic_nonsecure_priorities);
 KVM_NVHE_ALIAS(__start___kvm_ex_table);
 KVM_NVHE_ALIAS(__stop___kvm_ex_table);
 
+/* Array containing bases of nVHE per-CPU memory regions. */
+KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index ddde15fe85f2..2d842e009a40 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,8 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o hyp-main.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
+	 hyp-main.o hyp-smp.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
new file mode 100644
index 000000000000..7b0363b4857f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 - Google LLC
+ * Author: David Brazdil <dbrazdil@google.com>
+ */
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+unsigned long __hyp_per_cpu_offset(unsigned int cpu)
+{
+	unsigned long *cpu_base_array;
+	unsigned long this_cpu_base;
+	unsigned long elf_base;
+
+	if (cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base))
+		hyp_panic();
+
+	cpu_base_array = (unsigned long *)hyp_symbol_addr(kvm_arm_hyp_percpu_base);
+	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
+	elf_base = (unsigned long)hyp_symbol_addr(__per_cpu_start);
+	return this_cpu_base - elf_base;
+}
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
