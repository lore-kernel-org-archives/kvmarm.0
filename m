Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05D7C433E4
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AAECC20672
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="lFI073O1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAECC20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 610594B1E1;
	Wed, 15 Jul 2020 14:45:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZZTY+Jw3pNMz; Wed, 15 Jul 2020 14:45:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4D3D4B3A0;
	Wed, 15 Jul 2020 14:45:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 587254B3C4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3ZBUr6+Lza7f for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:00 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C6664B367
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:00 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id e11so1966426wrs.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iL59/llhgx4ePlBR+XOWUtyD4lyYgd42fTs5cxiQgzc=;
 b=lFI073O1Em+eVRdeZ3mvVoerLeG7MXTl/0IPTTm9aZ0F6igiUf08mCUgJQiSApqmlF
 aCThDuAP4/HcjA6FWZl3mlU8fnh2KRb1UzqIjbuOxSx20mTCynISkhmG1w8qnGCBRxbh
 9IUwfiu6rDA24PyUkD22rsTBZwLJMSKp1gwS4D2RCaNbxM/m0x05aVT/H83yz8O0Q1Wv
 UD7ID/zcy2631ASywpA8NUALqO3tdkxtt9iPsME5lD73SFmudu1o95pTIFmPUhdLMTPq
 Jk2+CdzWIWGwNZGTgzi7iyxE4CGCPwAWnkx7rM56aESKC5pOypKNMNPEO8NwrQJLob1C
 xowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iL59/llhgx4ePlBR+XOWUtyD4lyYgd42fTs5cxiQgzc=;
 b=VgYPie6+31Jm1iRamItq+7p9CVbw2sCrl0jz2dQ3KbS6njy94RvyY15D/p3G1JIBsY
 YUE4Tbj+7FCppnQXvWSN6xh2/+Mubkifevq6/Vs4nAiBDU3U/GOzBv6IEmA7+RtNgr0K
 NWN+KR6NlPxcqbXw+lhC9wb4x6XUbByARZTZMdvvLPHquzPKyv/NqD8Ar/b1sPpBIs0X
 1VThfGcy5gQ64pymqhVvkoNm/ySfN2M/1SdWE6H/nfrm0E7lDkBXrsZtSx0LsNb6Kzo7
 1dfRFwxuavEE4rDJcinPQrFJLwXNeX3MwxstiMMoCAhymBC7jKEWAOJ+oLNhdiS7ZAu6
 sRqA==
X-Gm-Message-State: AOAM530uyWMR6OmIMcVP4ivqDMYz8UtYrrAYVBsvCpTqF3nigkuZ+Nxm
 05gNoYnRrdINpk+3lmoAnOV5UlS8OLl/JpNXp516+fU1a7qAVJzd0d0/T2Oe+zhkwyGr4Tyeg1d
 WdT50jTO8JfPtHGBsUl/uiJ+ZIUzXAhbtV93LMwjAoMiY9GlV/Sjl+bDObjCLo6V04G0FeQ==
X-Google-Smtp-Source: ABdhPJxXYtT8F6Y75B3cZ/xShhBqJVmuZOON1Y7qkjjqhhetpHd916TD7yiLP8vsi9pGQCOb0VKjZCeQCXY=
X-Received: by 2002:a7b:c185:: with SMTP id y5mr762974wmi.85.1594838699187;
 Wed, 15 Jul 2020 11:44:59 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:06 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-6-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 05/37] KVM: arm64: nVHE: Break out of the hyp-init idmap
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

The idmap is a restrictive context as it is located separately from the
rest of hyp. Extra care must be taken to avoid symbol references that
will not resolve correctly so, the less that has to be done in this
context, the better.

To overcome this, pass an pre-resolved pointer into hyp-init that it can
jump to and escape the idmap once it has installed the page table.

This patch just introduces the mechanism to break out of the idmap for
use in future changes.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/arm.c                |  7 ++++++-
 arch/arm64/kvm/hyp/nvhe/Makefile    |  3 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S  | 13 +++++++------
 arch/arm64/kvm/hyp/nvhe/hyp-start.S | 16 ++++++++++++++++
 4 files changed, 31 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-start.S

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index bf662c0dd409..52be6149fcbf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1257,9 +1257,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 static void cpu_init_hyp_mode(void)
 {
+	DECLARE_KVM_NVHE_SYM(__kvm_hyp_start);
+
 	phys_addr_t pgd_ptr;
 	unsigned long hyp_stack_ptr;
 	unsigned long vector_ptr;
+	unsigned long start_hyp;
 	unsigned long tpidr_el2;
 
 	/* Switch from the HYP stub to our own HYP init vector */
@@ -1277,6 +1280,7 @@ static void cpu_init_hyp_mode(void)
 	hyp_stack_ptr = __this_cpu_read(kvm_arm_hyp_stack_page) + PAGE_SIZE;
 	hyp_stack_ptr = kern_hyp_va(hyp_stack_ptr);
 	vector_ptr = (unsigned long)kvm_get_hyp_vector();
+	start_hyp = (unsigned long)kern_hyp_va(kvm_ksym_ref_nvhe(__kvm_hyp_start));
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
@@ -1285,7 +1289,8 @@ static void cpu_init_hyp_mode(void)
 	 * cpus_have_const_cap() wrapper.
 	 */
 	BUG_ON(!system_capabilities_finalized());
-	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2);
+	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, start_hyp,
+		       tpidr_el2);
 
 	/*
 	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 0b34414557d6..1f3a39efaa6e 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,8 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o \
+	 hyp-start.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index f80f169a8442..029c51365d03 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -46,13 +46,17 @@ __invalid:
 	 * x0: HYP pgd
 	 * x1: HYP stack
 	 * x2: HYP vectors
-	 * x3: per-CPU offset
+	 * x3: __kvm_hyp_start HYP address
+	 * x4: per-CPU offset
 	 */
 __do_hyp_init:
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.lo	__kvm_handle_stub_hvc
 
+	/* Set tpidr_el2 for use by HYP */
+	msr	tpidr_el2, x4
+
 	phys_to_ttbr x4, x0
 alternative_if ARM64_HAS_CNP
 	orr	x4, x4, #TTBR_CNP_BIT
@@ -116,11 +120,8 @@ alternative_else_nop_endif
 	mov	sp, x1
 	msr	vbar_el2, x2
 
-	/* Set tpidr_el2 for use by HYP */
-	msr	tpidr_el2, x3
-
-	/* Hello, World! */
-	eret
+	/* Leave the idmap posthaste and head over to __kvm_hyp_start */
+	br	x3
 SYM_CODE_END(__kvm_hyp_init)
 
 SYM_CODE_START(__kvm_handle_stub_hvc)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-start.S b/arch/arm64/kvm/hyp/nvhe/hyp-start.S
new file mode 100644
index 000000000000..5f7fbcb57fd5
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-start.S
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2020 - Google Inc
+ * Author: Andrew Scull <ascull@google.com>
+ */
+
+#include <linux/linkage.h>
+
+#include <asm/assembler.h>
+#include <asm/asm-offsets.h>
+#include <asm/kvm_asm.h>
+
+SYM_CODE_START(__kvm_hyp_start)
+	/* Hello, World! */
+	eret
+SYM_CODE_END(__kvm_hyp_start)
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
