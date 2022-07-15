Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCA5C43334
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A596E4BC46;
	Fri, 15 Jul 2022 02:11:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 72P4V1G+m-TK; Fri, 15 Jul 2022 02:11:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46FE94BE02;
	Fri, 15 Jul 2022 02:11:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD8444BC0C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cixg6twGVmyA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:38 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2ADD4BC63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:37 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-317f6128c86so33582657b3.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=1fym5n3n0oRia5NvSUClhii6veVXNj9gblE/7wpke9c=;
 b=dc7YhQhB+Ip1RaWbAyXQxBj3/khXBkxGpkdHu1EkyjdG2Ntq0zGnQ7CI0vvsM5LoR7
 bOTy4YLobXsT1AI1ayobnaGn/U0oTuEsFJSaTZsf2SCqTuOq+dIW6cVLIxFgWB6yIgPP
 r1DS4gW5k/bjt5YkQKMECX5jYmBr8RBTdc4GxWb58awYhSWlNu2Q+r8O7bLGjuJh1CjS
 mjuFNlu6jjHmjla41cuWn3LyCeBjEnrvudkvWECk8mENYuC32iG1BnIHI1/gj9SbNJ6r
 vx96pOp6wqrGrASAADA9JpN5jp6DvbjDu9dI2PS2fMoqyh8HmLeAtNjThZMK1jc4pgPF
 LP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1fym5n3n0oRia5NvSUClhii6veVXNj9gblE/7wpke9c=;
 b=yo3xLYofvabVGl2o7cS+LD3m5RwfkKeo82DUNf4QA0B5kz86hAtk9biis8vRekzmDH
 fBWRq/OM/JgVfRpKr0G7xMPULsktE3mw93+hzNRRhG4CiWtwTe+B6JohdMYWYLmWqssZ
 qqZTU4qq1I+G8omQzKYMwtgm7cewsqjDFpovp5OkazSXFoyqVM/iCEgIgynV8QY6AWaR
 9G2ehvpzajo0om5c/pMjrZ9MkK1WQZLn9wr9YPGYe1YMwZYENspwUaj96nz9wXfADOVR
 imnUwQnLUYMCdAghuE5/Rd1ilQK+ansYHl1uuP6RZ3lYdzeuYBdNcj9kE6i+9JzQsL6V
 B2PQ==
X-Gm-Message-State: AJIora8TIYpXWuWkPXui6ICI69q3UUgffHU3aG+lzH0vXVyYO7kfTyN9
 OSawp6YJh1Ke1ekInABzeVs8Q6i1PQdAP/1hdg==
X-Google-Smtp-Source: AGRyM1u3qCw7t29vwofSuUW09s1Js0/b0NPwzvR/BwAcuU954cXttzvHa6Ek2lTeefUCsd1b3z2MavlgW2KJP5IGmg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:14f:0:b0:66a:bbd9:e502 with SMTP
 id c15-20020a5b014f000000b0066abbd9e502mr13149371ybp.278.1657865497089; Thu,
 14 Jul 2022 23:11:37 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:22 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-14-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 13/18] KVM: arm64: Prepare non-protected nVHE hypervisor
 stacktrace
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, android-mm@google.com, andreyknvl@gmail.com,
 kernel-team@android.com, drjones@redhat.com,
 linux-arm-kernel@lists.infradead.org, russell.king@oracle.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

In non-protected nVHE mode (non-pKVM) the host can directly access
hypervisor memory; and unwinding of the hypervisor stacktrace is
done from EL1 to save on memory for shared buffers.

To unwind the hypervisor stack from EL1 the host needs to know the
starting point for the unwind and information that will allow it to
translate hypervisor stack addresses to the corresponding kernel
addresses. This patch sets up this book keeping. It is made use of
later in the series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/kvm_asm.h         | 16 ++++++++++++++++
 arch/arm64/include/asm/stacktrace/nvhe.h |  4 ++++
 arch/arm64/kvm/hyp/nvhe/stacktrace.c     | 24 ++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2e277f2ed671..0ae9d12c2b5a 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -176,6 +176,22 @@ struct kvm_nvhe_init_params {
 	unsigned long vtcr;
 };
 
+/**
+ * Used by the host in EL1 to dump the nVHE hypervisor backtrace on
+ * hyp_panic() in non-protected mode.
+ *
+ * @stack_base:                 hyp VA of the hyp_stack base.
+ * @overflow_stack_base:        hyp VA of the hyp_overflow_stack base.
+ * @fp:                         hyp FP where the backtrace begins.
+ * @pc:                         hyp PC where the backtrace begins.
+ */
+struct kvm_nvhe_stacktrace_info {
+	unsigned long stack_base;
+	unsigned long overflow_stack_base;
+	unsigned long fp;
+	unsigned long pc;
+};
+
 /* Translate a kernel address @ptr into its equivalent linear mapping */
 #define kvm_ksym_ref(ptr)						\
 	({								\
diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 456a6ae08433..1aadfd8d7ac9 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -19,6 +19,7 @@
 #ifndef __ASM_STACKTRACE_NVHE_H
 #define __ASM_STACKTRACE_NVHE_H
 
+#include <asm/kvm_asm.h>
 #include <asm/stacktrace/common.h>
 
 /**
@@ -49,6 +50,9 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
  */
 #ifdef __KVM_NVHE_HYPERVISOR__
 
+DECLARE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
+DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
 
 #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index 832a536e440f..315eb41c37a2 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -9,6 +9,28 @@
 DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
 	__aligned(16);
 
+DEFINE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
+
+/**
+ * hyp_prepare_backtrace - Prepare non-protected nVHE backtrace.
+ *
+ * @fp : frame pointer at which to start the unwinding.
+ * @pc : program counter at which to start the unwinding.
+ *
+ * Save the information needed by the host to unwind the non-protected
+ * nVHE hypervisor stack in EL1.
+ */
+static void hyp_prepare_backtrace(unsigned long fp, unsigned long pc)
+{
+	struct kvm_nvhe_stacktrace_info *stacktrace_info = this_cpu_ptr(&kvm_stacktrace_info);
+	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
+
+	stacktrace_info->stack_base = (unsigned long)(params->stack_hyp_va - PAGE_SIZE);
+	stacktrace_info->overflow_stack_base = (unsigned long)this_cpu_ptr(overflow_stack);
+	stacktrace_info->fp = fp;
+	stacktrace_info->pc = pc;
+}
+
 #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
 DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
 
@@ -81,4 +103,6 @@ void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)
 {
 	if (is_protected_kvm_enabled())
 		pkvm_save_backtrace(fp, pc);
+	else
+		hyp_prepare_backtrace(fp, pc);
 }
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
