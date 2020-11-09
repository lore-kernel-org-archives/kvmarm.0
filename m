Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CF6C4741F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88135221FF
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 11:32:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Fxm0Hnjl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88135221FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2787B4B590;
	Mon,  9 Nov 2020 06:32:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W2OulsLxPEpR; Mon,  9 Nov 2020 06:32:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBE424B74E;
	Mon,  9 Nov 2020 06:32:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B4AA4B765
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qb8X1RPqtN3X for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 06:32:54 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 779364B74F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 06:32:53 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id 33so8297024wrl.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 03:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=dD+HnXjMAuT9iIEK7PkEi17VFy6Rjc2aSGW4eJxjMmM=;
 b=Fxm0HnjlRiCRvpWF4beee7iVOFjv2Qaw21ps+7x79tMQJfT6FNyrr/xGavtNXDvjzu
 51epSIouMwzseNia68qwSyOMPyRzHL19sFirCC43Fe46MjxglK6FJFd2wjudNtt66VqM
 fqRYVtTi1izaLS10Y7ZO7h9NUmWfNxugf1n4K4XyYxKI2IroTZspHZ1hPfaDveiwV3gm
 f7cvO8HiWxy9KjAjrDe1t3eEsZVK6myBeucm4XXZRqEt2JVMbmx9fVH2tOSCzu49n3b/
 3JpiFHlpxlH2iezie9R07ceB4ujU4fqscWcxxngFZE19BU6OFayYXr3n0Vc/3iiOSvgg
 A4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=dD+HnXjMAuT9iIEK7PkEi17VFy6Rjc2aSGW4eJxjMmM=;
 b=ZUBKcCG04AfIOH8q1bL2sikS8SDoWkOxc5zT5i0t3pndJZRdq7s9ZIS/Ci4GrtfoPb
 xJYSgb+TxISMxgq/w0ohyTxnQdojwPyAg8HVQDob2LhT7b+KV3gJhnAgZjmmS5mMBhqO
 ydRAGOe4MygipLkx5Uw0W+42lhwCdLzwYoZCqTJ5B4e0Dhqn+Sq3R7zwAtiTCi0IapUp
 Uv/gpKm6gWlCt0jVyqw105X6fWm3SkBdlaM+FHpERrbjUAYrZ36ZOFl+lnGM1lQsA8Hg
 auqO9K3sPWYlTi0Q2mS+4P+lyLDDDEvQTixjr6s06DYAUwZVOd9K11KBjXBE1nCYZ5VG
 lOnA==
X-Gm-Message-State: AOAM530cP1VUrxuWct1C3+Yh+++MRj8XacK59EpmwiLFaPhpnbAhd6NA
 W7tLv0uT0Q4Tw0bnsfP4kTLC+6XMja5ulm+u
X-Google-Smtp-Source: ABdhPJz41ehkFfXRIlLvAsM/Z4zHvUymv8X3f2L/Q8G9Xp+RnyzjpOnflk7vt/regvRGdeQ9p7LFgA==
X-Received: by 2002:adf:ea47:: with SMTP id j7mr17229972wrn.126.1604921572143; 
 Mon, 09 Nov 2020 03:32:52 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:209d:10b7:c480:3e1f])
 by smtp.gmail.com with ESMTPSA id p4sm12907274wrm.51.2020.11.09.03.32.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 09 Nov 2020 03:32:51 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 06/24] kvm: arm64: Support per_cpu_ptr in nVHE hyp code
Date: Mon,  9 Nov 2020 11:32:15 +0000
Message-Id: <20201109113233.9012-7-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
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
2.29.2.222.g5d2a92d10f8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
