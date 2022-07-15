Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794D9C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 221B64BDCA;
	Fri, 15 Jul 2022 02:11:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id of2qcDK+Y5Xu; Fri, 15 Jul 2022 02:11:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 116344BDFC;
	Fri, 15 Jul 2022 02:11:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50F8F4BC46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ynqZbBPyoiUI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:35 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1242E4BC5A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:35 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 a8-20020a25a188000000b0066839c45fe8so3273820ybi.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Re0lyq5fdLMfXjdX0x8O/EyKsShey1DPNrXl83M7ib4=;
 b=HJIzfLUePWb4mdMt5PQiB2FXqWysXIomBQwWmZmU4WV/QUZbp4L9o9VFKSwOJZifTZ
 Fa6IQbg+cMKv/7h9KJH2UcxrcTFfMTgmjaYMPU0KzatCgfcvq9kQCjl1mCU5KlP2UZvf
 saRXkT4Vpy7oTR0HAdiDDzqWQMS48FOJSp9QhUQNl4JGkHfW+2NCOJZCmji58ttWfn1x
 SowNG0vi9kC6tGLLFApmgH3fS6+ugyOaFaW5AYdpvJmFjuofxYo9juDxrUY5GGOH6GWX
 TK67Y6CrAXSsgi0VARxmXTim/P0MFuM9aFY5sRAknI9mcAvSqGV9gdOD4phpS9MBGRLP
 UbdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Re0lyq5fdLMfXjdX0x8O/EyKsShey1DPNrXl83M7ib4=;
 b=ouwFRpn8juVGEqzOgmGJ4+WiwD+PAEzJOHAMejThMKCRH3owuTIIudFlvNoUicFvRp
 M57tb+51a4sTUmeDI7/mWUlUeffnW6vBQOU8ZzaAH+cCkOYe43knN1lElBm9F7cjcVmX
 AioHHBU+DmV18rtcXtPOuL6Mt1GyOXc7hCoF9tTrkMIkXLOv6OIJjycmIPz672mcDoQP
 5mCTVT9zXgAnQ4o5ENcB2Y01sU5OkizIhz6LFU9lUMYibw1kjlIoMOiUC+mMCXZVEHfC
 NrVqW2LKUsNR3ZaaeiK6KSHAQNQ0RAFULwBVjOfps2sBD7aCV/YCfK0vnHnlCovvqFap
 bOFw==
X-Gm-Message-State: AJIora+YuQDnQXBDyziyWUXwUfNyDTIFFJKHx4Cfmj6BQykYi/TOU32x
 HeG1wztNHOs9KPC5GOQoB3517QP7u6dxKHh9Xw==
X-Google-Smtp-Source: AGRyM1sW1Rib3u02KM7AZyrfjLA2iwFLsV4nlOryhWe/xB4UcHZVdSrw+Q6l4PSjRDA2LJVX/SPqSYka+ic+lQq4/w==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a0d:d747:0:b0:31c:8947:7851 with SMTP
 id z68-20020a0dd747000000b0031c89477851mr14136383ywd.142.1657865494699; Thu,
 14 Jul 2022 23:11:34 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:21 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-13-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 12/18] KVM: arm64: Save protected-nVHE (pKVM) hyp stacktrace
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

In protected nVHE mode, the host cannot access private owned hypervisor
memory. Also the hypervisor aims to remains simple to reduce the attack
surface and does not provide any printk support.

For the above reasons, the approach taken to provide hypervisor stacktraces
in protected mode is:
   1) Unwind and save the hyp stack addresses in EL2 to a shared buffer
      with the host (done in this patch).
   2) Delegate the dumping and symbolization of the addresses to the
      host in EL1 (later patch in the series).

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace/nvhe.h | 18 ++++++
 arch/arm64/kvm/hyp/nvhe/stacktrace.c     | 70 ++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 36cf7858ddd8..456a6ae08433 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -21,6 +21,22 @@
 
 #include <asm/stacktrace/common.h>
 
+/**
+ * kvm_nvhe_unwind_init - Start an unwind from the given nVHE HYP fp and pc
+ *
+ * @fp : frame pointer at which to start the unwinding.
+ * @pc : program counter at which to start the unwinding.
+ */
+static __always_inline void kvm_nvhe_unwind_init(struct unwind_state *state,
+						 unsigned long fp,
+						 unsigned long pc)
+{
+	unwind_init_common(state, NULL);
+
+	state->fp = fp;
+	state->pc = pc;
+}
+
 static inline bool on_accessible_stack(const struct task_struct *tsk,
 				       unsigned long sp, unsigned long size,
 				       struct stack_info *info)
@@ -33,6 +49,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
  */
 #ifdef __KVM_NVHE_HYPERVISOR__
 
+extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
+
 #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
 static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 				     struct stack_info *info)
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index 96c8b93320eb..832a536e440f 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -11,4 +11,74 @@ DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
 
 #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
 DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
+
+/**
+ * pkvm_save_backtrace_entry - Saves a protected nVHE HYP stacktrace entry
+ *
+ * @arg    : the position of the entry in the stacktrace buffer
+ * @where  : the program counter corresponding to the stack frame
+ *
+ * Save the return address of a stack frame to the shared stacktrace buffer.
+ * The host can access this shared buffer from EL1 to dump the backtrace.
+ */
+static bool pkvm_save_backtrace_entry(void *arg, unsigned long where)
+{
+	unsigned long **stacktrace_pos = (unsigned long **)arg;
+	unsigned long stacktrace_start, stacktrace_end;
+
+	stacktrace_start = (unsigned long)this_cpu_ptr(pkvm_stacktrace);
+	stacktrace_end = stacktrace_start + NVHE_STACKTRACE_SIZE - (2 * sizeof(long));
+
+	if ((unsigned long) *stacktrace_pos > stacktrace_end)
+		return false;
+
+	/* Save the entry to the current pos in stacktrace buffer */
+	**stacktrace_pos = where;
+
+	/* A zero entry delimits the end of the stacktrace. */
+	*(*stacktrace_pos + 1) = 0UL;
+
+	/* Increment the current pos */
+	++*stacktrace_pos;
+
+	return true;
+}
+
+/**
+ * pkvm_save_backtrace - Saves the protected nVHE HYP stacktrace
+ *
+ * @fp : frame pointer at which to start the unwinding.
+ * @pc : program counter at which to start the unwinding.
+ *
+ * Save the unwinded stack addresses to the shared stacktrace buffer.
+ * The host can access this shared buffer from EL1 to dump the backtrace.
+ */
+static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
+{
+	void *stacktrace_start = (void *)this_cpu_ptr(pkvm_stacktrace);
+	struct unwind_state state;
+
+	kvm_nvhe_unwind_init(&state, fp, pc);
+
+	unwind(&state, pkvm_save_backtrace_entry, &stacktrace_start);
+}
+#else /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
+static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
+{
+}
 #endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
+
+/**
+ * kvm_nvhe_prepare_backtrace - prepare to dump the nVHE backtrace
+ *
+ * @fp : frame pointer at which to start the unwinding.
+ * @pc : program counter at which to start the unwinding.
+ *
+ * Saves the information needed by the host to dump the nVHE hypervisor
+ * backtrace.
+ */
+void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)
+{
+	if (is_protected_kvm_enabled())
+		pkvm_save_backtrace(fp, pc);
+}
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
