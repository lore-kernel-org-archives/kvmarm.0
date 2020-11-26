Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558B5C63697
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E365521D7E
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="vuRWz2Vz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E365521D7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 980534C0BB;
	Thu, 26 Nov 2020 10:54:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lkbdbVxZ9yFv; Thu, 26 Nov 2020 10:54:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ACB74C095;
	Thu, 26 Nov 2020 10:54:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 041504C0B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6b3-7YKZuelk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:54:53 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72AC74C08B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:54:51 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id m6so2632252wrg.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 07:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=e2DA2lb08NjF2kLgte3niLs4IyK5ibsw6X8kGTbt6og=;
 b=vuRWz2VzCx+NsTyFxiM9DdVajdfpccRX2BWXmB2CRIKJ8IzexQMvbefFsjGqaWVBCk
 jWYzf55/dDIw1J5itVsU6h1tTPCWRlLRysQ7+3qrYy+EoIg+fWGWDuwzw2ZQVAsIjn0F
 tl1qerp25yz+79MsbHXnIG7eE0AEPzyspl6b05MfemZ1kEW7LD/IP9Z+g6oyvenjQUyR
 OYRrcPmdT7/xKDifSqGlleIWs/7ENNoHBYcekTQhjra9BKPI8jSuBf0moV3uceCgIGTE
 ND4L4ysHhmtYmCnqlon52bBx8YPNEqSXVO2o6mzj9yoL1P2LxOMw54fSC2rF/y7o5xDt
 LJYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=e2DA2lb08NjF2kLgte3niLs4IyK5ibsw6X8kGTbt6og=;
 b=C/RdoUdTE0bWtW0rg1fjYJf9yQ08Mu4hgLwr9jTOZCYRhSKseJyFWKoD+ZsxUTFO8A
 nBvHEc1Wo4s9zWZ+WKEN84szC+wQvb5Oxc0K/AYpNfEj7zbgxpoTJARYN3jQuFQdJweh
 hMiR9hIQHQsaGIrJ99WM33eIo6Sj2JokyEyndClSzWqp+UFJJRTv3a+rOzUQFpKGVMBA
 Ht6xx31E21cbws9VHbZ3LnQbrBmCKCTC7aQ9LzQC9gUz4nSxhoe9qOZ83B5BJgmAlq+h
 QIQkwbHgcNdGfijHZJqn9KtMHBq9d4ooquo8mL+BWEtnie/orc6XUMSjy2wdWjeGY9X3
 nboA==
X-Gm-Message-State: AOAM533WNDMzU4ZQ730xxxv8KGZC3sp7T6167ifldgZPto3WEFHU2P2H
 Jwl3zyuHwdsPGKshmpEHXNiSjoQR/Ed+zGeK
X-Google-Smtp-Source: ABdhPJx6VhjNHKBFfpNR31U6UDoq1VL+sz6rt7bUK0/RH8aBigcXdj9z3q8fmfoUnFbrGm/vavCgnA==
X-Received: by 2002:a5d:4349:: with SMTP id u9mr4496622wrr.319.1606406090191; 
 Thu, 26 Nov 2020 07:54:50 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:f008:704d:8d4b:9951])
 by smtp.gmail.com with ESMTPSA id d8sm8608344wmb.11.2020.11.26.07.54.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 26 Nov 2020 07:54:49 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 11/23] kvm: arm64: Support per_cpu_ptr in nVHE hyp code
Date: Thu, 26 Nov 2020 15:54:09 +0000
Message-Id: <20201126155421.14901-12-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126155421.14901-1-dbrazdil@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
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
index 4b32588918d9..8539f34d7538 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -102,6 +102,9 @@ KVM_NVHE_ALIAS(gic_nonsecure_priorities);
 KVM_NVHE_ALIAS(__start___kvm_ex_table);
 KVM_NVHE_ALIAS(__stop___kvm_ex_table);
 
+/* Array containing bases of nVHE per-CPU memory regions. */
+KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 77b8c4e06f2f..cf11f8182756 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,8 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o hyp-main.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
+	 hyp-main.o hyp-smp.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
new file mode 100644
index 000000000000..c168d86f885a
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
+	cpu_base_array = (unsigned long*)hyp_symbol_addr(kvm_arm_hyp_percpu_base);
+	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
+	elf_base = (unsigned long)hyp_symbol_addr(__per_cpu_start);
+	return this_cpu_base - elf_base;
+}
-- 
2.29.2.454.gaff20da3a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
