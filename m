Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6A8C5DF9D
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60EA1208C7
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Nx93E9yy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60EA1208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03D214B7A9;
	Wed,  4 Nov 2020 13:36:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xmr3mi+79F3P; Wed,  4 Nov 2020 13:36:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C547A4B7BE;
	Wed,  4 Nov 2020 13:36:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCC5F4B7A8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dvk5ImLpoRUQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:36:54 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADE644B6A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:54 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id k18so3265319wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=/Qa/ORiTczGU+wzc7d9QZzh5/niq1xeS+URCXTTt4r4=;
 b=Nx93E9yyY//kvChBV3KCeNqvnYwrNO2ZgDrCYTrU0G3sLsnpH5B+kY1/8elaSaHdfw
 HzA05rPUsQd+1O936ysg9hDnB+m7qGA0yA/fCbDjMEC24foxz3qejCDvvP/ogU38u4JJ
 U6iOV2bgUjnGUl0/kwdbTGln1yZ07j3+9EkIC1wznpT5C9dGNpaUL7flUrUywhoeJxep
 Wzq+coBb4Jkt0eRYX55seXPFpVc8OJBmMM9eXV/Na0tuwDnZ9llo+xBd+yflExNcQ+aW
 KL1CYXtO82nsOaaPC8oRLdp3PKxgmvCy1VlOydEjqSsUUncvVeg2+lmyb57UYZffXHjz
 fhig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=/Qa/ORiTczGU+wzc7d9QZzh5/niq1xeS+URCXTTt4r4=;
 b=DDK/bRBgmrC04xS43P6iKC6XwBs5JCiOzOUDZHZcvqSszMPhC/V12CLrg9zkacFf7h
 lJib0T+UIvPSH1Rog+njbya+WqdlmGv48uIval6AjauOC4WKzUw++GuZHKBDwTpHsPvi
 qZ6Stc37FKyT1xM9/ZcgaVkkABPx0KgOqwfJmOTRzAAnlGz23XMpLKs0eBYcf2JWz1dy
 /6yuepoDQNMPVL424k5EfYFnYYB6AgojOusJpVJidv+ljoBAa/SSNOK3mMQl+7NgcH1e
 vjyy1JWsdXU9gsUGpcoRK6Mj1WOXOz+TrF9NpqudYmXj0jR+TKzgwn8Fw+ZTTMfX57Sp
 M6gQ==
X-Gm-Message-State: AOAM531VpNdSpsidqz/IGgZDkZPkIuHa3S3RobCIE0m2m45ROBh5nIx5
 vBr1h2pgMRMD7WYQ4YyfNrW6O4NV9eO4vPuD
X-Google-Smtp-Source: ABdhPJwP0oSnvZLNGQUvlE/1pKvC6M7nrsCqZGLWPZQiLMwgoxQ84TyR2rJEK0iBP/DF19+A8Bwokg==
X-Received: by 2002:a7b:c11a:: with SMTP id w26mr5889073wmi.131.1604515013329; 
 Wed, 04 Nov 2020 10:36:53 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id e7sm4290328wrm.6.2020.11.04.10.36.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:52 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 07/26] kvm: arm64: Support per_cpu_ptr in nVHE hyp code
Date: Wed,  4 Nov 2020 18:36:11 +0000
Message-Id: <20201104183630.27513-8-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
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
 arch/arm64/include/asm/percpu.h  |  6 ++++++
 arch/arm64/kernel/image-vars.h   |  3 +++
 arch/arm64/kvm/hyp/nvhe/Makefile |  3 ++-
 arch/arm64/kvm/hyp/nvhe/percpu.c | 22 ++++++++++++++++++++++
 4 files changed, 33 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/percpu.c

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
index ddde15fe85f2..c45f440cce51 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,8 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o hyp-main.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
+	 hyp-main.o percpu.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/percpu.c b/arch/arm64/kvm/hyp/nvhe/percpu.c
new file mode 100644
index 000000000000..5fd0c5696907
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/percpu.c
@@ -0,0 +1,22 @@
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
+
+	if (cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base))
+		hyp_panic();
+
+	cpu_base_array = kern_hyp_va(&kvm_arm_hyp_percpu_base[0]);
+	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
+	return this_cpu_base - (unsigned long)&__per_cpu_start;
+}
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
