Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D25C19F28
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 14:29:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9994C7F4;
	Wed, 27 Jul 2022 10:29:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0G2hMtmpbWVw; Wed, 27 Jul 2022 10:29:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4CB4C823;
	Wed, 27 Jul 2022 10:29:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9DE94C7C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 10:29:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wod2bC3wiZYw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 10:29:29 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE32C4C7B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 10:29:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id DE719B8218C;
 Wed, 27 Jul 2022 14:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392D3C43140;
 Wed, 27 Jul 2022 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658932166;
 bh=wvQcYBDMZgGC7R1FOa29dKIsNXbtHBpMnjlFhjIm9vk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=UgZNHlgB582XRBn7Ey7Kho+/sBrG8lYhfh7kb+D4mL49XF0k7j9j8LRGwfe7CxeqC
 Mq5yGqBM0kjg7GsHZAJ6AiVFbeLhVRMf66qBNZCaGW1/za31bT+0eWh+wljcV46LJv
 erhaGIxvMuJtF1QHVeU7ImkosUKqTgzJELeo7+knxFM4r6Z7GBceptEE5sjlVJ8mzc
 IPVP6bioBKAV4CVQWqipSq3IPyxN2A+NnqgDTPT6DyOiYY8WBLWPBSuFlr7dYAxRIC
 xq5cQ12NhJ/5wmJiH+hS5wJUFjQglKbBIpBv7xeJL5/K1QxRkUev1nWXrRIPgOVuRI
 T3Ac90p6eS9Rw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oGi2O-00APjL-7y;
 Wed, 27 Jul 2022 15:29:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 4/6] KVM: arm64: Move nVHE-only helpers into kvm/stacktrace.c
Date: Wed, 27 Jul 2022 15:29:04 +0100
Message-Id: <20220727142906.1856759-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com,
 broonie@kernel.org, madvenka@linux.microsoft.com, tabba@google.com,
 oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com,
 james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, andreyknvl@gmail.com, vincenzo.frascino@arm.com,
 mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
 elver@google.com, keirf@google.com, yuzenghui@huawei.com, ardb@kernel.org,
 oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, madvenka@linux.microsoft.com,
 kernel-team@android.com, elver@google.com, broonie@kernel.org,
 andreyknvl@gmail.com, mhiramat@kernel.org
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

kvm_nvhe_stack_kern_va() only makes sense as part of the nVHE
unwinder, so simply move it there.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/stacktrace/nvhe.h | 41 ------------------------
 arch/arm64/kvm/stacktrace.c              | 41 ++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index a096216d8970..d5527b600390 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -49,47 +49,6 @@ DECLARE_KVM_NVHE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overf
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
 DECLARE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
-/*
- * kvm_nvhe_stack_kern_va - Convert KVM nVHE HYP stack addresses to a kernel VAs
- *
- * The nVHE hypervisor stack is mapped in the flexible 'private' VA range, to
- * allow for guard pages below the stack. Consequently, the fixed offset address
- * translation macros won't work here.
- *
- * The kernel VA is calculated as an offset from the kernel VA of the hypervisor
- * stack base.
- *
- * Returns true on success and updates @addr to its corresponding kernel VA;
- * otherwise returns false.
- */
-static inline bool kvm_nvhe_stack_kern_va(unsigned long *addr,
-					  enum stack_type type)
-{
-	struct kvm_nvhe_stacktrace_info *stacktrace_info;
-	unsigned long hyp_base, kern_base, hyp_offset;
-
-	stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
-
-	switch (type) {
-	case STACK_TYPE_HYP:
-		kern_base = (unsigned long)*this_cpu_ptr(&kvm_arm_hyp_stack_page);
-		hyp_base = (unsigned long)stacktrace_info->stack_base;
-		break;
-	case STACK_TYPE_OVERFLOW:
-		kern_base = (unsigned long)this_cpu_ptr_nvhe_sym(overflow_stack);
-		hyp_base = (unsigned long)stacktrace_info->overflow_stack_base;
-		break;
-	default:
-		return false;
-	}
-
-	hyp_offset = *addr - hyp_base;
-
-	*addr = kern_base + hyp_offset;
-
-	return true;
-}
-
 void kvm_nvhe_dump_backtrace(unsigned long hyp_offset);
 
 #endif	/* __KVM_NVHE_HYPERVISOR__ */
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index 4d5fec3175ff..417665854f86 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -21,6 +21,47 @@
 
 #include <asm/stacktrace/nvhe.h>
 
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
+static bool kvm_nvhe_stack_kern_va(unsigned long *addr,
+				   enum stack_type type)
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
 static bool on_overflow_stack(unsigned long sp, unsigned long size,
 			      struct stack_info *info)
 {
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
