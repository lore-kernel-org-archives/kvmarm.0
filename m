Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4DEC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E12344BC63;
	Fri, 15 Jul 2022 02:11:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3-VAEVi1uRuz; Fri, 15 Jul 2022 02:11:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D4A34BDFB;
	Fri, 15 Jul 2022 02:11:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D71C74BC63
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HXkNTVyBK577 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:42 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6031E4BAF7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:42 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 j2-20020a2597c2000000b0064b3e54191aso3332860ybo.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Yscefk8aqX/qdzK+Mn8nR6R0Ne1QrKgVF2VH9wy9A6w=;
 b=gv8BYhdodgL9+KafTVNOZjz5a9ojmWAVs0iVsXZHqPY5+FXfoUxXyL+7W//GXGAx1+
 GWhjgBEinl4Ot8YYyKKG/7Bk46KUu8Ok+8EKMIIoR9EidKiHtVQmXHelmZn9AWEcMea6
 f0CQVkWUuIxVTljmFpp1n+/TtD/gJbBTPESj736nhIIeHrxbpNyR6DM4lO7c99QH/HO/
 jaqtU/5X1c+nMAkIvMwWGQvkwHfMJ46xTmLmlNzvdZL8+Q7InCnnhZyvIKukmWSuvNET
 IRx7f6rM02ueatKa2ZXmKEvt5OTDqVrxZZaE4e9W4zkPuZyUJ8R/+ZFf4erB2GVZSL6m
 bgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Yscefk8aqX/qdzK+Mn8nR6R0Ne1QrKgVF2VH9wy9A6w=;
 b=0pVAXybJghUdunF6YpGmEmoTSUYPmpPf6H6JgzNxvNZDTlKCtovuReuIMvOdiWzORs
 V/VnSWaI9hi2p+NyA/gRGqwHTDfUBsDvDTBPOXDfpxGrJjarxxfwsC1bwnT6Fez1Dc4Z
 KHKax4zJJK7uTnSsAgHwoFZB58dJDkCWcDGT4d+wJWbYCpHZ5EqzkXQy8bv+kE8/v1Yp
 tIdZFk5Ep9OLDH5uvj674aQtw+8CtvUIRO6A/liA/B1UKMT3ZI/aOqZYM7fBuvvfXXCt
 Llv9TagLfgFLGDBtCxxp+r4npUuZ40lrbqj6p3N5hGqAE4WSnDtGVtzSItc44aJ8QJYp
 MUtA==
X-Gm-Message-State: AJIora8lTV+xhMKKbs8iWiofDMBN3l9Ur5gfou/W27i09yJi5GZFSrYF
 vIy5RrvUEPUUFQYNUXIrCabdGpdROwoS2A0mIQ==
X-Google-Smtp-Source: AGRyM1tRMPbG6Ei2Eu+kI5Lon9y9EMop8Zm7qoPDrJSeiS/nQi/8XRoWwEQLM653jgtPu4ikjQxVi7km3j09d4mA7g==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a0d:e243:0:b0:31c:9d96:8b1b with SMTP
 id l64-20020a0de243000000b0031c9d968b1bmr14189640ywe.222.1657865501975; Thu,
 14 Jul 2022 23:11:41 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:24 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-16-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 15/18] KVM: arm64: Implement non-protected nVHE hyp stack
 unwinder
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

Implements the common framework necessary for unwind() to work
for non-protected nVHE mode:
    - on_accessible_stack()
    - on_overflow_stack()
    - unwind_next()

Non-protected nVHE unwind() is used to unwind and dump the hypervisor
stacktrace by the host in EL1

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/include/asm/stacktrace/nvhe.h | 67 +++++++++++++++++++++++-
 arch/arm64/kvm/arm.c                     |  2 +-
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index c7c8ac889ec1..c3f94b10f8f0 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -115,15 +115,78 @@ NOKPROBE_SYMBOL(unwind_next);
  * Non-protected nVHE HYP stack unwinder
  */
 #else	/* !__KVM_NVHE_HYPERVISOR__ */
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], overflow_stack);
+DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
+DECLARE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
+
+/**
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
 
 static int notrace unwind_next(struct unwind_state *state)
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
