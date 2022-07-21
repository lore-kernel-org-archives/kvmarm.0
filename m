Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D5FC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:58:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DEF04DA33;
	Thu, 21 Jul 2022 01:58:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id euWZ9QZ3OOCH; Thu, 21 Jul 2022 01:58:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D0924DA89;
	Thu, 21 Jul 2022 01:58:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84F4B4DA7D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OsrTKY2EGzzC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:58:16 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02B574DA79
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:16 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 u15-20020a25ab0f000000b0066e49f6c461so597170ybi.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=eY5/lFgLy/e/q0JCyLsG7Dq+dlCTuLB6RCoRX5a1q0g=;
 b=WMRHbze1UjE98lLidYWgTOC6PORIneSd6GV0ozEhz9vPbd9YOdu7j9Ryu+HJ4trz/J
 QRckppVKgo+ATqknDecnbXMNFaAhNymsEFAFGzocktzNwndsSyA8oxc0WeCOA36n4faE
 U1eO1R/yW1qyJZeqwVMLBEK8wlOeB/MOLmcGmUwoFu/ejt8IPrrrznyRtzlK1kFucm0m
 2LbPQ5kNE19uG8EbRX2/P8uEWit1VVLXUxE+Qisf8tule0DtgZai7yq9seEfR65ZG1IB
 J/h8ACRHJmOzCd8nRGtwjzD2eprVrkcjZHDiDDazJAwK0BnFXAApBjz4lW8Mq335iydt
 YGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=eY5/lFgLy/e/q0JCyLsG7Dq+dlCTuLB6RCoRX5a1q0g=;
 b=QZiRMYq9laSM2+HxIO5s90B+Pq9BzjiTXX4kKsEpy+YE65w1qBRbVLVvch4JJ6zoVE
 EG57CHoUb4LVv3Ip0vn8RElH9vtl25Sa9jX8qZB1r5V1jQhfFpdwtcxKSDwAsqEWVKNK
 vtEpfRNDoCzLhwZuUBW+AGmuDbv+0mHAKnKWRXmHFFe9U3f9sPpB3dXmKr6fPSHY6YD3
 Wcb+FndK6UOIACekFnHmVlNRYFyZBaPAkSxmdcqsc5k53nf7Iki7brqakgX7nAAqnWa2
 YGAT425bBX16TSV8tRafQdxjDKRtl4DUa3Aw6SuErYt/Yr2gtfeSrT2Fsv5w+BbJZg0R
 ZEfg==
X-Gm-Message-State: AJIora/fjVwEdK7ZMXvUjax3qMSWChSqlW6nx+ly8PeJKeFa7OfATgNE
 EmqGcblbosBlc2i2oHk1NUthMLTHOMGklcCyUQ==
X-Google-Smtp-Source: AGRyM1sBVPLMJaPOkAoWmG3Bd9FIx/vNpGbpXpxi987HJ+/EiD9zA+WxndpdbIc+7PEG26Pc7JjNZnzchEWAgAKDFw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:3c4:b0:670:6a54:dbc2 with
 SMTP id g4-20020a05690203c400b006706a54dbc2mr13483925ybs.576.1658383095838;
 Wed, 20 Jul 2022 22:58:15 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:28 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-18-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 17/17] KVM: arm64: Introduce hyp_dump_backtrace()
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

In non-protected nVHE mode, unwinds and dumps the hypervisor backtrace
from EL1. This is possible beacuase the host can directly access the
hypervisor stack pages in non-proteced mode.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Move code out from nvhe.h header to handle_exit.c, per Marc
  - Fix stacktrace symoblization when CONFIG_RAMDOMIZE_BASE is enabled,
    per Fuad
  - Use regular comments instead of doc comments, per Fuad

 arch/arm64/kvm/handle_exit.c | 65 +++++++++++++++++++++++++++++++-----
 1 file changed, 56 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index ad568da5c7d7..432b6b26f4ad 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -17,6 +17,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/debug-monitors.h>
+#include <asm/stacktrace/nvhe.h>
 #include <asm/traps.h>
 
 #include <kvm/arm_hypercalls.h>
@@ -318,6 +319,56 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
 
+/*
+ * kvm_nvhe_print_backtrace_entry - Symbolizes and prints the HYP stack address
+ */
+static void kvm_nvhe_print_backtrace_entry(unsigned long addr,
+						  unsigned long hyp_offset)
+{
+	unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
+
+	/* Mask tags and convert to kern addr */
+	addr = (addr & va_mask) + hyp_offset;
+	kvm_err(" [<%016lx>] %pB\n", addr, (void *)(addr + kaslr_offset()));
+}
+
+/*
+ * hyp_dump_backtrace_entry - Dump an entry of the non-protected nVHE HYP stacktrace
+ *
+ * @arg    : the hypervisor offset, used for address translation
+ * @where  : the program counter corresponding to the stack frame
+ */
+static bool hyp_dump_backtrace_entry(void *arg, unsigned long where)
+{
+	kvm_nvhe_print_backtrace_entry(where, (unsigned long)arg);
+
+	return true;
+}
+
+/*
+ * hyp_dump_backtrace - Dump the non-proteced nVHE HYP backtrace.
+ *
+ * @hyp_offset: hypervisor offset, used for address translation.
+ *
+ * The host can directly access HYP stack pages in non-protected
+ * mode, so the unwinding is done directly from EL1. This removes
+ * the need for shared buffers between host and hypervisor for
+ * the stacktrace.
+ */
+static void hyp_dump_backtrace(unsigned long hyp_offset)
+{
+	struct kvm_nvhe_stacktrace_info *stacktrace_info;
+	struct unwind_state state;
+
+	stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
+
+	kvm_nvhe_unwind_init(&state, stacktrace_info->fp, stacktrace_info->pc);
+
+	kvm_err("Non-protected nVHE HYP call trace:\n");
+	unwind(&state, hyp_dump_backtrace_entry, (void *)hyp_offset);
+	kvm_err("---- End of Non-protected nVHE HYP call trace ----\n");
+}
+
 #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
 DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
 			 pkvm_stacktrace);
@@ -336,18 +387,12 @@ static void pkvm_dump_backtrace(unsigned long hyp_offset)
 {
 	unsigned long *stacktrace_entry
 		= (unsigned long *)this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
-	unsigned long va_mask, pc;
-
-	va_mask = GENMASK_ULL(vabits_actual - 1, 0);
 
 	kvm_err("Protected nVHE HYP call trace:\n");
 
-	/* The stack trace is terminated by a null entry */
-	for (; *stacktrace_entry; stacktrace_entry++) {
-		/* Mask tags and convert to kern addr */
-		pc = (*stacktrace_entry & va_mask) + hyp_offset;
-		kvm_err(" [<%016lx>] %pB\n", pc, (void *)(pc + kaslr_offset()));
-	}
+	/* The saved stacktrace is terminated by a null entry */
+	for (; *stacktrace_entry; stacktrace_entry++)
+		kvm_nvhe_print_backtrace_entry(*stacktrace_entry, hyp_offset);
 
 	kvm_err("---- End of Protected nVHE HYP call trace ----\n");
 }
@@ -367,6 +412,8 @@ static void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
 {
 	if (is_protected_kvm_enabled())
 		pkvm_dump_backtrace(hyp_offset);
+	else
+		hyp_dump_backtrace(hyp_offset);
 }
 
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
