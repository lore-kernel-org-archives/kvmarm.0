Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8E9C43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:58:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 531DA4D8AF;
	Thu, 21 Jul 2022 01:58:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MbcaPdZdQbRM; Thu, 21 Jul 2022 01:58:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 231954DA83;
	Thu, 21 Jul 2022 01:58:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E30B4DA58
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9tLbFhQA+WiM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:58:12 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C8584DA6E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:58:11 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-317f6128c86so6518307b3.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gR1/Z2EPI44f0egwGbpih9U0FfR3lyB8C+b1oQ7a3ho=;
 b=afa5tl3ErYehtuGRVn6Z2F3olzHm5mqok9Hqwl9tU/bS/EZvKNoimqQLe5oCqF/DMc
 TdBQTNmlNrru0i9aIep5zRlPuoHEjwccgz4Qgy87jnj5xkgYHR+W30Pr8KipWYI6LJe/
 JwvfS1kvj4dSVhZKIaHgofIjVXextnUms7EF/I0hZJtqp6bRCSsgSNsZvrl+NykLzrW1
 NCvGslXIrCznfDzAKgWB2mVXua6LAoU7aPHY2Kx2Our4OmdaDygrvEfqL0tqMqLYbbmK
 y5QbtzMDtm2Xy58L9Yy8pWaiIH22zGx35r4CZp5SCFxcx+InneYPmkR0G8Fd6lS+Z+wW
 lU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gR1/Z2EPI44f0egwGbpih9U0FfR3lyB8C+b1oQ7a3ho=;
 b=FGbYvKh1GyFHdbyWkFyFQg7bMZETNVFIP2c/zItZw9qju/tcJJKZODQfgCJkl0CQJW
 rlV7h5ZFB5xtvpJuQjU/TQ/Js9o8l4LaYreyBGYrY7STMtlacDOlXiKDlnHHwWVFp71K
 cb61ZZ7UpBTdTZrWVN/yRnd1loudmD0saMM+OfaHwlwFaNFXxcNnEp2kpa8J7UrbtBAd
 kIKhrGnDty7Ek90dwg2yMkcAr9o5B0Nd7cfwCh/1GcLSOECL68+5tndR0sTi1xBVXcnN
 W8ylTGJbqhkA1R7LP38Ojak27Ukl3Q9ZToI0K/NYHPxFXywIBN3eyuIfhmmvH2IuUgyP
 V3Zg==
X-Gm-Message-State: AJIora9JeaoWMM6NsTPS570ajbRNZZF9DFCT/NPYos+spsSBI9iZ+HJ5
 Wv5jj/CasRaMVhm55pGgYwewagg7YI1A7zwMvw==
X-Google-Smtp-Source: AGRyM1sVq2WV+efPOaHv/EvfJltNWnGlGgRuoca8wHJKHuJymzfLurD1omQOCDXP5YKLf76jV42DjWRXPQaey+SEtQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a81:98d2:0:b0:31e:5d41:7a3e with SMTP
 id p201-20020a8198d2000000b0031e5d417a3emr11327128ywg.520.1658383090977; Wed,
 20 Jul 2022 22:58:10 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:26 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-16-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 15/17] KVM: arm64: Implement non-protected nVHE hyp stack
 unwinder
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

Implements the common framework necessary for unwind() to work
for non-protected nVHE mode:
    - on_accessible_stack()
    - on_overflow_stack()
    - unwind_next()

Non-protected nVHE unwind() is used to unwind and dump the hypervisor
stacktrace by the host in EL1

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Use regular comments instead of doc comments, per Fuad

 arch/arm64/include/asm/stacktrace/nvhe.h | 67 +++++++++++++++++++++++-
 arch/arm64/kvm/arm.c                     |  2 +-
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index c3688e717136..7a6e761aa443 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -120,15 +120,78 @@ NOKPROBE_SYMBOL(unwind_next);
  * (by the host in EL1).
  */
 
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], overflow_stack);
+DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
+DECLARE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
+
+/*
+ * kvm_nvhe_stack_kern_va - Convert KVM nVHE HYP stack addresses to a kernel VAs
+ *
+ * The nVHE hypervisor stack is mapped in the flexible 'private' VA range, to
+ * allow for guard pages below the stack. Consequently, the fixed offset address
+ * translation macros won't work here.
+ *
+ * The kernel VA is calculated as an offset from the kernel VA of the hypervisor
+ * stack base.
+ *
+ * Returns true on success and updates @addr to its corresponding kernel VA;
+ * otherwise returns false.
+ */
+static inline bool kvm_nvhe_stack_kern_va(unsigned long *addr,
+					  enum stack_type type)
+{
+	struct kvm_nvhe_stacktrace_info *stacktrace_info;
+	unsigned long hyp_base, kern_base, hyp_offset;
+
+	stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
+
+	switch (type) {
+	case STACK_TYPE_HYP:
+		kern_base = (unsigned long)*this_cpu_ptr(&kvm_arm_hyp_stack_page);
+		hyp_base = (unsigned long)stacktrace_info->stack_base;
+		break;
+	case STACK_TYPE_OVERFLOW:
+		kern_base = (unsigned long)this_cpu_ptr_nvhe_sym(overflow_stack);
+		hyp_base = (unsigned long)stacktrace_info->overflow_stack_base;
+		break;
+	default:
+		return false;
+	}
+
+	hyp_offset = *addr - hyp_base;
+
+	*addr = kern_base + hyp_offset;
+
+	return true;
+}
+
 static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 				     struct stack_info *info)
 {
-	return false;
+	struct kvm_nvhe_stacktrace_info *stacktrace_info
+				= this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
+	unsigned long low = (unsigned long)stacktrace_info->overflow_stack_base;
+	unsigned long high = low + OVERFLOW_STACK_SIZE;
+
+	return on_stack(sp, size, low, high, STACK_TYPE_OVERFLOW, info);
+}
+
+static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
+				struct stack_info *info)
+{
+	struct kvm_nvhe_stacktrace_info *stacktrace_info
+				= this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
+	unsigned long low = (unsigned long)stacktrace_info->stack_base;
+	unsigned long high = low + PAGE_SIZE;
+
+	return on_stack(sp, size, low, high, STACK_TYPE_HYP, info);
 }
 
 static inline int notrace unwind_next(struct unwind_state *state)
 {
-	return 0;
+	struct stack_info info;
+
+	return unwind_next_common(state, &info, kvm_nvhe_stack_kern_va);
 }
 NOKPROBE_SYMBOL(unwind_next);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a0188144a122..6a64293108c5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -49,7 +49,7 @@ DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
-static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
+DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
