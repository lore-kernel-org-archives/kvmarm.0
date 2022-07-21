Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EE8C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:58:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E1D74D8AF;
	Thu, 21 Jul 2022 01:58:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sBwyCv43jvKy; Thu, 21 Jul 2022 01:58:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5C314DA73;
	Thu, 21 Jul 2022 01:58:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B0E04D95B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c7v+e6ThaztO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:58:06 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E0684DA61
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:06 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31e5cc477dcso7021577b3.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Z7mVY9an7BKlr+DFm/CycdkNTS81eX0sj7VPn5GOYs4=;
 b=dTsslHtfVleq+Z/6WWji/9BuS9+0br4q7QTZcxrUN5Y9B4rlzmrmN32Bb1B5qyJ/U1
 qBpAZGUG2A62Hm2QuQFjTCti5rbkdpDyTAybiwdN4xKtXHzcxrROPg9V11lvHuN/twya
 a2UyEZ/owQaKO0PtjZowc5DbISURjVIpDe8dEi2N7GQOpy9pYT8mVWsgs4N9nBbqUvg2
 QH9mu9bYGpxdDj8JIvDwQld9c2w0EwXo08sJjQ+RmLN2wX01jPqMQrv+STC/QoW3bpXx
 mjKRNDCEFZxF3BqOf/VxGO2RpXhB+AoiIXZzPCTbceBAr/YG5qiWLsDGLe0S/hvlsMvl
 oT5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Z7mVY9an7BKlr+DFm/CycdkNTS81eX0sj7VPn5GOYs4=;
 b=imUb6XC3yC0mJ4wBFqHo/sCTDPJDWpIsVNYmiRd2/JObcI6sclMoz2w1XRY0KJ4dQV
 qQru6Mq8CU23gMh/4XhKOIXSuR/V/UAro+4y5lK99KNIAelFdsbsvkL0erAI8dkETJKW
 TsBFwryZy+9sDQmA7y6+UbDCDYQ2eNINaEbPON3bET5nnGZWL/AXVRqY6XGnTT/zKiKv
 1dZiGtrIqhw6WhoMow+F0OgtRp6XRLHrCJnhrRXiG2uZzgQVmvxVJTUBpryb7FUX1FV4
 3M2/Ynm9Mo73nL99LDUASIQ9v6XsQeGP0DjmDS7fWhueGztMTFq+xjl8ziK6YBr0upcL
 WcFA==
X-Gm-Message-State: AJIora+vGNVszP4lesRyJliWyu0KsBylXNBmuO0jagK2OVusI5RK3TSE
 JdhUo3SyDgi5IaFRfTiLmRx0e9Wja17jYg2vpw==
X-Google-Smtp-Source: AGRyM1t4hxWZlu80p3JVhXO15OVhTOsZC/c7QTwiHwbKpKmDeCswr0PSSvYfUF/aTjYWxM+ufbCB0TJqzm/vgw1mYQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:20a:b0:670:c563:9180 with
 SMTP id j10-20020a056902020a00b00670c5639180mr317132ybs.401.1658383085938;
 Wed, 20 Jul 2022 22:58:05 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:24 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-14-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 13/17] KVM: arm64: Prepare non-protected nVHE hypervisor
 stacktrace
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, drjones@redhat.com,
 ast@kernel.org, linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
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

Changes in v5:
  - Use regular comments instead of doc comments, per Fuad

 arch/arm64/include/asm/kvm_asm.h         | 16 ++++++++++++++++
 arch/arm64/include/asm/stacktrace/nvhe.h |  4 ++++
 arch/arm64/kvm/hyp/nvhe/stacktrace.c     | 24 ++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2e277f2ed671..53035763e48e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -176,6 +176,22 @@ struct kvm_nvhe_init_params {
 	unsigned long vtcr;
 };
 
+/*
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
index 05d7e03e0a8c..8f02803a005f 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -19,6 +19,7 @@
 #ifndef __ASM_STACKTRACE_NVHE_H
 #define __ASM_STACKTRACE_NVHE_H
 
+#include <asm/kvm_asm.h>
 #include <asm/stacktrace/common.h>
 
 /*
@@ -52,6 +53,9 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
  * In protected mode, the unwinding is done by the hypervisor in EL2.
  */
 
+DECLARE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
+DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+
 #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
 static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 				     struct stack_info *info)
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index 60461c033a04..cbd365f4f26a 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -9,6 +9,28 @@
 DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
 	__aligned(16);
 
+DEFINE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
+
+/*
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
 
@@ -89,4 +111,6 @@ void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)
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
