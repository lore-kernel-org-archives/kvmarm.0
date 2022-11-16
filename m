Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433D4C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 17:04:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EED3A4B916;
	Wed, 16 Nov 2022 12:04:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 85rhNBUmF7D2; Wed, 16 Nov 2022 12:04:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE61B4B8E8;
	Wed, 16 Nov 2022 12:04:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4607A4B885
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:04:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nopw0UmSwR5D for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 12:04:00 -0500 (EST)
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com
 [209.85.218.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47C654B8C9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:03:54 -0500 (EST)
Received: by mail-ej1-f73.google.com with SMTP id
 sh31-20020a1709076e9f00b007ae32b7eb51so10247319ejc.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 09:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=0LlpT1W08zY22OCiDAwClvJgtb8njE0sgiclRnNk7ts=;
 b=IwxAxakegBQOgyJGsYpp+ASfbDtVEt5WMACVRGDXdmLQXiC8ZToNpp61u1Rm/tFx+M
 KxKmHNKOzX2sToMMDg91OZstw/12M6mKO7AHGymmTVGeafUcUG9Z12Mhzt3AoltQvZ8v
 T4TOR3SmN6ZmJbNbqO4V6jU5wLIMvMPc9IfXOqN0M7UEXssEKMCgK/3KdXb376zsAIlO
 HyDjwIJQ3V8DkhaZwLec5MmHcq05/zwgtm3lAJHgWGa+ATdLeeZlRO47UrkIeWQcypSz
 zznJZ1VpqxZ0KtBLMdLbaVvlK1E9gyXEabCpWdwF6nt4YIppsiEDvYFphlS43wH9RDOc
 Ia5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=0LlpT1W08zY22OCiDAwClvJgtb8njE0sgiclRnNk7ts=;
 b=vSaELk8zNZ75WxLTn6UGx15/sNUqvW26PzIW5cAox/Zp+rIXwqS8Ny+St+YxAkKfLz
 MOhzO8VFCSngxffZEQCVwAmEok1XEw1ngZULJiI6L/iQ1XazgPt0r1wl0H4mQPgtFJmQ
 U3H4+Kyez7Fe7uJMgx1P3fVNymIDnL/o26WeXca1jKb4VA+jvCToD6E74g0jET8O5WkK
 lA0tO9+nLezyuHF7W+jB/9Z3Hz/XnDlAU9tKRSHEYyHqvqShQZO/4TyEwssft2grqI8W
 7yupUcsj2CzzF/GI5iyBuTR2R6kXNE+KxWZPSnvifJDAyI2xKe6QwKjNluQP/ks3ua+F
 TGwQ==
X-Gm-Message-State: ANoB5pkn5ADsX/e09t4PfK46whbOzUcUaV+UjQQetzzz/p977RHbzbdI
 fWICCIa0SbFiiSO7/OoG3bP3nc1UYjlO
X-Google-Smtp-Source: AA0mqf7LiyM1OOZAZnzmGJvXdG5RpxJwLRiG734YUmTJYGUEmVuB0iMzwkb6TaTUw12Rf5eWxXiepqlITevJ
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:907:cc8a:b0:7ae:f6e8:2502 with SMTP id
 up10-20020a170907cc8a00b007aef6e82502mr12271658ejc.157.1668618233461; Wed, 16
 Nov 2022 09:03:53 -0800 (PST)
Date: Wed, 16 Nov 2022 17:03:29 +0000
In-Reply-To: <20221116170335.2341003-1-qperret@google.com>
Mime-Version: 1.0
References: <20221116170335.2341003-1-qperret@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116170335.2341003-7-qperret@google.com>
Subject: [PATCH 06/12] KVM: arm64: Allocate pages for hypervisor FF-A mailboxes
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
 Andrew Walbran <qwandor@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Will Deacon <will@kernel.org>

The FF-A proxy code needs to allocate its own buffer pair for
communication with EL3 and for forwarding calls from the host at EL1.

Reserve a couple of pages for this purpose and use them to initialise
the hypervisor's FF-A buffer structure.

Co-developed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h     |  8 ++++++++
 arch/arm64/kvm/hyp/include/nvhe/ffa.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 24 +++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c       |  8 +++++++-
 arch/arm64/kvm/pkvm.c                 |  1 +
 5 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 01129b0d4c68..2b495ec59deb 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -106,4 +106,12 @@ static inline unsigned long host_s2_pgtable_pages(void)
 	return res;
 }
 
+#define KVM_FFA_MBOX_NR_PAGES	1
+
+static inline unsigned long hyp_ffa_proxy_pages(void)
+{
+	/* A page each for the hypervisor's RX and TX mailboxes. */
+	return 2 * KVM_FFA_MBOX_NR_PAGES;
+}
+
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/ffa.h b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
index 5c9b92430ff3..1becb10ecd80 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/ffa.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
@@ -11,7 +11,7 @@
 #define FFA_MIN_FUNC_NUM 0x60
 #define FFA_MAX_FUNC_NUM 0x7F
 
-int hyp_ffa_init(void);
+int hyp_ffa_init(void *pages);
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt);
 
 #endif /* __KVM_HYP_FFA_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index d199f868583e..7cb9095e00ff 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -28,8 +28,11 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/arm_ffa.h>
+#include <asm/kvm_pkvm.h>
+
 #include <nvhe/ffa.h>
 #include <nvhe/trap_handler.h>
+#include <nvhe/spinlock.h>
 
 /*
  * "ID value 0 must be returned at the Non-secure physical FF-A instance"
@@ -37,6 +40,19 @@
  */
 #define HOST_FFA_ID	0
 
+struct kvm_ffa_buffers {
+	hyp_spinlock_t lock;
+	void *tx;
+	void *rx;
+};
+
+/*
+ * Note that we don't currently lock these buffers explicitly, instead
+ * relying on the locking of the host FFA buffers as we only have one
+ * client.
+ */
+static struct kvm_ffa_buffers hyp_buffers;
+
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
 	*res = (struct arm_smccc_res) {
@@ -162,7 +178,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 	return true;
 }
 
-int hyp_ffa_init(void)
+int hyp_ffa_init(void *pages)
 {
 	struct arm_smccc_res res;
 
@@ -183,5 +199,11 @@ int hyp_ffa_init(void)
 	if (res.a2 != HOST_FFA_ID)
 		return -EINVAL;
 
+	hyp_buffers = (struct kvm_ffa_buffers) {
+		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
+		.tx	= pages,
+		.rx	= pages + (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE),
+	};
+
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index c4ca174a0592..bb98630dfeaf 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -29,6 +29,7 @@ static void *vmemmap_base;
 static void *vm_table_base;
 static void *hyp_pgt_base;
 static void *host_s2_pgt_base;
+static void *ffa_proxy_pages;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 static struct hyp_pool hpool;
 
@@ -58,6 +59,11 @@ static int divide_memory_pool(void *virt, unsigned long size)
 	if (!host_s2_pgt_base)
 		return -ENOMEM;
 
+	nr_pages = hyp_ffa_proxy_pages();
+	ffa_proxy_pages = hyp_early_alloc_contig(nr_pages);
+	if (!ffa_proxy_pages)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -315,7 +321,7 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = hyp_ffa_init();
+	ret = hyp_ffa_init(ffa_proxy_pages);
 	if (ret)
 		goto out;
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index cf56958b1492..bb405e274df6 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -74,6 +74,7 @@ void __init kvm_hyp_reserve(void)
 	hyp_mem_pages += host_s2_pgtable_pages();
 	hyp_mem_pages += hyp_vm_table_pages();
 	hyp_mem_pages += hyp_vmemmap_pages(STRUCT_HYP_PAGE_SIZE);
+	hyp_mem_pages += hyp_ffa_proxy_pages();
 
 	/*
 	 * Try to allocate a PMD-aligned region to reduce TLB pressure once
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
