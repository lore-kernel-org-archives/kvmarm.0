Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C764EC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83D394C547;
	Tue, 26 Jul 2022 03:38:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ckcGm8uwiDwb; Tue, 26 Jul 2022 03:38:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F05B24C562;
	Tue, 26 Jul 2022 03:38:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD2E44C53A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1NfBTEpRoynh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:32 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DD8F4C54E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:32 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 m5-20020a2598c5000000b0066faab590c5so10337410ybo.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xzH/6M+SU0X5hOX4FZRvYLC0KzgDSzoTGm2ET8Rq+o0=;
 b=DETaP7rF9wWbO6Msex1IjbIPOs5qcFopnknde2KDuKfQtGfBHQQZeSttvtn1M31WnG
 YP9SmoTcjSiBVkQMa36IbuQEGimRV0R+nOmXct3SY4oULsKy7C54mnSHLgxbuyhdBcn5
 kc9VIPOtYstVwH+wHBNdY1bHzvfVqak5AfqO5t5aHq6xwBNPcc5ZWHhSUSXM+E5dhfkf
 Ig+GVFWSBaY3UZVU8Po82d30sbS/TuoWAuUoCDKCXCNT+IUA8CjzhJO0oTyEwNNyc6RG
 MBN6CwskgCB1Yhqk5Ni52rnn47r/JS90lh+HxJt3TannLGJVTmQaK1SXj7Iua9xSEMdz
 Suzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xzH/6M+SU0X5hOX4FZRvYLC0KzgDSzoTGm2ET8Rq+o0=;
 b=23UUnKBF62cc4oBPR38eblT/pB63TPPMxqkPRazJdt8E8mDg5eotwFDKXt0IHbJwBo
 qHD8F5O5CfNNszlamrbISalOR8aJmBDXVF6gFvKue+aK3EUoSvHVQWk67TKVuH8KrmeW
 qIuwyKV0H5bMf0hY/zt1cQnwi3jlVQQa1Q+/ciosi4thbLW+KmRhhKLKKQXfGhXnPU1B
 tTRm5yGGK0nhXtCSQ6rRxhUGftAMm53ryQBviygzI0vWYE5llBQorOwKfC8cqLrB5F/9
 AZypyCIwTCQsSJ29bJwsNpEKxdVcRMj75jwkQNkwfRhfqraKVP4BN3q2EvBoavAnxdYt
 GO1Q==
X-Gm-Message-State: AJIora/QZE+rRWWztPWYW3tus9e/t56AScy8sS5As1bZCo4m+756P/nE
 RIUvyirW8I1/CrUIVtKvcDIOHXvDxlW3IhLBkQ==
X-Google-Smtp-Source: AGRyM1s9MRRJnFJpaGAtK6mRh1YvUHLp08b9Vp1bPDczimM0hZ7elFoj8DoT6FWrVuc+bm+K4KVS8zylnMHhGD9GeQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:f41:0:b0:671:6ce6:f71 with SMTP id
 y1-20020a5b0f41000000b006716ce60f71mr2391473ybr.506.1658821112045; Tue, 26
 Jul 2022 00:38:32 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:48 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-16-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 15/17] KVM: arm64: Save protected-nVHE (pKVM) hyp stacktrace
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, elver@google.com,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
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

Changes in v6:
  - Simplify pkvm_save_backtrace_entry() using array semantics instead
    of the pointer arithmetic, per Oliver.

Changes in v5:
  - Comment/clarify pkvm_save_backtrace_entry(), per Fuad
  - kvm_nvhe_unwind_init(), doesn't need to be always inline, make it
    inline instead to avoid linking issues, per Marc
  - Use regular comments instead of doc comments, per Fuad

 arch/arm64/kvm/hyp/nvhe/stacktrace.c | 55 +++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index e2edda92a108..900324b7a08f 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -35,7 +35,60 @@ static void hyp_prepare_backtrace(unsigned long fp, unsigned long pc)
 }
 
 #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
+#include <asm/stacktrace/nvhe.h>
+
 DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
+
+/*
+ * pkvm_save_backtrace_entry - Saves a protected nVHE HYP stacktrace entry
+ *
+ * @arg    : index of the entry in the stacktrace buffer
+ * @where  : the program counter corresponding to the stack frame
+ *
+ * Save the return address of a stack frame to the shared stacktrace buffer.
+ * The host can access this shared buffer from EL1 to dump the backtrace.
+ */
+static bool pkvm_save_backtrace_entry(void *arg, unsigned long where)
+{
+	unsigned long *stacktrace = this_cpu_ptr(pkvm_stacktrace);
+	int size = NVHE_STACKTRACE_SIZE / sizeof(long);
+	int *idx = (int *)arg;
+
+	/*
+	 * Need 2 free slots: 1 for current entry and 1 for the
+	 * delimiter.
+	 */
+	if (*idx > size - 2)
+		return false;
+
+	stacktrace[*idx] = where;
+	stacktrace[++*idx] = 0UL;
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
+	struct unwind_state state;
+	int idx = 0;
+
+	kvm_nvhe_unwind_init(&state, fp, pc);
+
+	unwind(&state, pkvm_save_backtrace_entry, &idx);
+}
+#else /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
+static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
+{
+}
 #endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
 
 /*
@@ -50,7 +103,7 @@ DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrac
 void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)
 {
 	if (is_protected_kvm_enabled())
-		return;
+		pkvm_save_backtrace(fp, pc);
 	else
 		hyp_prepare_backtrace(fp, pc);
 }
-- 
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
