Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49137C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:58:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F22D44DA66;
	Thu, 21 Jul 2022 01:58:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wfaWhO+WF7Vk; Thu, 21 Jul 2022 01:58:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 971B44DA73;
	Thu, 21 Jul 2022 01:58:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD2484DA66
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dhFaOf+7fzrE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:58:04 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD0694DA61
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:03 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2dc7bdd666fso6636767b3.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Y/Pw0ypxhYsMQBExEbEI8CQLolbPSquDAaPdcdOBW14=;
 b=A/U8SrJzEd19IiEgaaJV++dSW6MCKuGc9oV8dKjIC/h7jPSi7IiCj6jW0cejmtzRAa
 Zf9wrfNf5GCwUiqePPhAmUXpEtrMneI/UCVtSFNjsR0ydcms46cmShP+bnOiWhMzXi+J
 zyWJwjV17gr7AmrmF+I8yRon//wfjILaZKNcrvJiXTb5kcdRvRWVJuqMoMgXEPBz5ktK
 51dt3WQ9mIvuwCpxuyEDmr0ORgf+zAF68CvtcCYk2tgtS3oVyM37QfaZbEpu0uf/4L/v
 I2+GiOj7LtsYO83KQnzkWaOPY3AIEPkQ07kCpZvupdpPiTalml7fysnqQVnpWg2SQmq6
 /1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Y/Pw0ypxhYsMQBExEbEI8CQLolbPSquDAaPdcdOBW14=;
 b=2cXFj20cONCBSO6a5PkMavkzV+KL7n4o2eWmxKQ6kOHq+p4vEFf++JSuspt/XnR2TO
 DksyZ+NWv1E1vulYqXFdP95rHTrZ01ykDvfLw4KbnhPP66rwGVF92Nx8bv/+/P4fzTMR
 mkI89AZN5jedLdTk0IEUaxxCT3o9FS1ytS8B9q6jJIGJ3y0Zq9b3pTQkB5cnUz92L6IF
 TixGeMcAWdoAeSUI87R5BBMG2QlGTQK3ez1aINmU13X4mLOr7CnPKLb30QRzkeI8qDml
 9uLTvWQtTeOIEcMg6ZzgotM4sUycrz29aEV0v6EhBHVj1N4T0gOhks9ITziNe3YTTfAO
 oFbA==
X-Gm-Message-State: AJIora+UE//mZvgBBsvFHvxtfXB9jIL60SrpA5u5CzSv51hyLn/IWIec
 15KjxHLZ8E9OJQQkPno32rBFkC9omelRKO/zqA==
X-Google-Smtp-Source: AGRyM1srLRo8p6y9NLZdlgVwRZ5a/iwYm2zsx+W1hx/uDBK5IsQu2g57V7urVDMFs6RLHuP/ncA1Oq6BUI0cEVvi7A==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a81:74c2:0:b0:31e:7916:a556 with SMTP
 id p185-20020a8174c2000000b0031e7916a556mr3292762ywc.28.1658383083351; Wed,
 20 Jul 2022 22:58:03 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:23 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-13-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 12/17] KVM: arm64: Save protected-nVHE (pKVM) hyp stacktrace
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

In protected nVHE mode, the host cannot access private owned hypervisor
memory. Also the hypervisor aims to remains simple to reduce the attack
surface and does not provide any printk support.

For the above reasons, the approach taken to provide hypervisor stacktraces
in protected mode is:
   1) Unwind and save the hyp stack addresses in EL2 to a shared buffer
      with the host (done in this patch).
   2) Delegate the dumping and symbolization of the addresses to the
      host in EL1 (later patch in the series).

On hyp_panic(), the hypervisor prepares the stacktrace before returning to
the host.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Comment/clarify pkvm_save_backtrace_entry(), per Fuad
  - kvm_nvhe_unwind_init(), doesn't need to be always inline, make it
    inline instead to avoid linking issues, per Marc
  - Use regular comments instead of doc comments, per Fuad

 arch/arm64/include/asm/stacktrace/nvhe.h | 17 ++++++
 arch/arm64/kvm/hyp/nvhe/stacktrace.c     | 78 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c         |  6 ++
 3 files changed, 101 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 3078501f8e22..05d7e03e0a8c 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -21,6 +21,23 @@
 
 #include <asm/stacktrace/common.h>
 
+/*
+ * kvm_nvhe_unwind_init - Start an unwind from the given nVHE HYP fp and pc
+ *
+ * @state : unwind_state to initialize
+ * @fp    : frame pointer at which to start the unwinding.
+ * @pc    : program counter at which to start the unwinding.
+ */
+static inline void kvm_nvhe_unwind_init(struct unwind_state *state,
+					unsigned long fp,
+					unsigned long pc)
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
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index 96c8b93320eb..60461c033a04 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -11,4 +11,82 @@ DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
 
 #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
 DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
+
+/*
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
+	unsigned long **stacktrace_entry = (unsigned long **)arg;
+	int nr_entries = NVHE_STACKTRACE_SIZE / sizeof(long);
+	unsigned long *stacktrace_start, *stacktrace_end;
+
+	stacktrace_start = (unsigned long *)this_cpu_ptr(pkvm_stacktrace);
+	stacktrace_end = stacktrace_start + nr_entries;
+
+	/*
+	 * Need 2 free slots: 1 for current entry and 1 for the
+	 * trailing zero entry delimiter.
+	 */
+	if (*stacktrace_entry > stacktrace_end - 2)
+		return false;
+
+	/* Save the current entry */
+	**stacktrace_entry = where;
+
+	/* Add trailing zero entry delimiter */
+	*(*stacktrace_entry + 1) = 0UL;
+
+	/*
+	 * Increment the current entry position. The zero entry
+	 * will be overwritten by the next backtrace entry (if any)
+	 */
+	++*stacktrace_entry;
+
+	return true;
+}
+
+/*
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
+	void *stacktrace_entry = (void *)this_cpu_ptr(pkvm_stacktrace);
+	struct unwind_state state;
+
+	kvm_nvhe_unwind_init(&state, fp, pc);
+
+	unwind(&state, pkvm_save_backtrace_entry, &stacktrace_entry);
+}
+#else /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
+static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
+{
+}
 #endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
+
+/*
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
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6db801db8f27..64e13445d0d9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -34,6 +34,8 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
@@ -375,6 +377,10 @@ asmlinkage void __noreturn hyp_panic(void)
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
+	/* Prepare to dump kvm nvhe hyp stacktrace */
+	kvm_nvhe_prepare_backtrace((unsigned long)__builtin_frame_address(0),
+				   _THIS_IP_);
+
 	__hyp_do_panic(host_ctxt, spsr, elr, par);
 	unreachable();
 }
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
