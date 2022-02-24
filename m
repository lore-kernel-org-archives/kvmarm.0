Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2241C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 10:36:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 532C04BFB8;
	Thu, 24 Feb 2022 05:36:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nqIZWl6ijfsD; Thu, 24 Feb 2022 05:36:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 959254C021;
	Thu, 24 Feb 2022 05:36:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2DC14BD0D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:16:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TD6LxDAt4F0K for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 00:16:16 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5A214BCCC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 00:16:16 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2d07ae11462so11722197b3.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 21:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=mMupdIrbmOm80/sZrASEhygALQnDQAhlGvHAY7r7H5w=;
 b=X6XkcRUhmtAVIiQWY//3Gn68yYt9JlaMc47Vxfs+9cbIeqKDJtChfU2PP1IOBRmR1x
 ti8C4IVVDHdguNDBsD2+Zu2z/+0wf1X0jjy8HgGHG5uy+eXYp4j1Mytn6RWE7zYG3Pjh
 qcHknwrb+7+95GUvIDQnxRanAZSZWd6SqEFWEJJ9Xn2MnMnc1Ul9PgDZjLJvsIsLXGX7
 AsxVI1BhGqVIogXF3czePdz1Ax326NINXaOl1FH+v9tqYAT57vqsKVzzNH50KPCClXnd
 VHJRzl7HiQYfXLY0uKpfCjgyCDYQj9/O8D4qmTHjNwlFd2AqpCH4gs/GGlghND4EjnTW
 b0nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=mMupdIrbmOm80/sZrASEhygALQnDQAhlGvHAY7r7H5w=;
 b=vUEXSbx2Ucdj/+ZDlXg9IyLiGR+Xs27uTEHtn5R+C2CMyHOiU6jCPtvvWP7iB4ppe5
 igC2mhyagKKD0nwFH6dAeyaWUMGZ59aFDMgvRC+fVIT+6GVPJz8vxkEjbPhtlXNYRX1M
 WNwvWw4GRxJYub3Ab4yt0BtJy2rmUTSu0PAahQdtXasaxFSkNeSP7/SdVHZLGaI5NH+F
 aVjahbU2k0cx4ms+azlgAVhomQ7igau/kqCCOrgiq3hY0VZBZxiygwE08D1Hjml4nDQk
 QwRLAHK+vn/ff726DiTpfIQr6+19Y694bcTX3GpH/5FYr7zRpIv2O/ZLqv1yUKOq++OV
 fTrw==
X-Gm-Message-State: AOAM531MnSPiCCFjYEd2ReD7S7jk9B7PKjTSkdYV3Hd++SpvWhMmTy8U
 lAYyluIZNbHP2tWNrDzm1mUEVrOshW0Ji366Ww==
X-Google-Smtp-Source: ABdhPJwXwzSytvMwsjPP9WzSxgb1djKy65Lz6QLBpdS+tGwETD/J0V3ZhDRlutQHDIbQP4uTSJSAD6d/fMA2MaVCFQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:415c:9be0:c461:440a])
 (user=kaleshsingh job=sendgmr) by 2002:a81:1cd8:0:b0:2d6:b74b:5b55 with SMTP
 id c207-20020a811cd8000000b002d6b74b5b55mr908040ywc.149.1645679776175; Wed,
 23 Feb 2022 21:16:16 -0800 (PST)
Date: Wed, 23 Feb 2022 21:13:36 -0800
In-Reply-To: <20220224051439.640768-1-kaleshsingh@google.com>
Message-Id: <20220224051439.640768-2-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 1/8] KVM: arm64: Introduce hyp_alloc_private_va_range()
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Thu, 24 Feb 2022 05:36:21 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Kalesh Singh <kaleshsingh@google.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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

hyp_alloc_private_va_range() can be used to reserve private VA ranges
in the nVHE hypervisor. Also update  __create_hyp_private_mapping()
to allow specifying an alignment for the private VA mapping.

These will be used to implement stack guard pages for KVM nVHE hypervisor
(nVHE Hyp mode / not pKVM), in a subsequent patch in the series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark

 arch/arm64/include/asm/kvm_mmu.h |  4 +++
 arch/arm64/kvm/mmu.c             | 62 ++++++++++++++++++++------------
 2 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 81839e9a8a24..0b0c71302b92 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -153,6 +153,10 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 int kvm_share_hyp(void *from, void *to);
 void kvm_unshare_hyp(void *from, void *to);
 int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
+unsigned long hyp_alloc_private_va_range(size_t size, size_t align);
+int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
+				size_t align, unsigned long *haddr,
+				enum kvm_pgtable_prot prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
 			   void __iomem **haddr);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bc2aba953299..fc09536c8197 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -457,22 +457,16 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return 0;
 }
 
-static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
-					unsigned long *haddr,
-					enum kvm_pgtable_prot prot)
+
+/*
+ * Allocates a private VA range below io_map_base.
+ *
+ * @size:	The size of the VA range to reserve.
+ * @align:	The required alignment for the allocation.
+ */
+unsigned long hyp_alloc_private_va_range(size_t size, size_t align)
 {
 	unsigned long base;
-	int ret = 0;
-
-	if (!kvm_host_owns_hyp_mappings()) {
-		base = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
-					 phys_addr, size, prot);
-		if (IS_ERR_OR_NULL((void *)base))
-			return PTR_ERR((void *)base);
-		*haddr = base;
-
-		return 0;
-	}
 
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
@@ -484,8 +478,8 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	 *
 	 * The allocated size is always a multiple of PAGE_SIZE.
 	 */
-	size = PAGE_ALIGN(size + offset_in_page(phys_addr));
-	base = io_map_base - size;
+	base = io_map_base - PAGE_ALIGN(size);
+	base = ALIGN_DOWN(base, align);
 
 	/*
 	 * Verify that BIT(VA_BITS - 1) hasn't been flipped by
@@ -493,20 +487,42 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	 * overflowed the idmap/IO address range.
 	 */
 	if ((base ^ io_map_base) & BIT(VA_BITS - 1))
-		ret = -ENOMEM;
+		base = (unsigned long)ERR_PTR(-ENOMEM);
 	else
 		io_map_base = base;
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 
-	if (ret)
-		goto out;
+	return base;
+}
+
+int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
+				size_t align, unsigned long *haddr,
+				enum kvm_pgtable_prot prot)
+{
+	unsigned long addr;
+	int ret = 0;
+
+	if (!kvm_host_owns_hyp_mappings()) {
+		addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
+					 phys_addr, size, prot);
+		if (IS_ERR_OR_NULL((void *)addr))
+			return addr ? PTR_ERR((void *)addr) : -ENOMEM;
+		*haddr = addr;
+
+		return 0;
+	}
+
+	size += offset_in_page(phys_addr);
+	addr = hyp_alloc_private_va_range(size, align);
+	if (IS_ERR_OR_NULL((void *)addr))
+		return addr ? PTR_ERR((void *)addr) : -ENOMEM;
 
-	ret = __create_hyp_mappings(base, size, phys_addr, prot);
+	ret = __create_hyp_mappings(addr, size, phys_addr, prot);
 	if (ret)
 		goto out;
 
-	*haddr = base + offset_in_page(phys_addr);
+	*haddr = addr + offset_in_page(phys_addr);
 out:
 	return ret;
 }
@@ -537,7 +553,7 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 		return 0;
 	}
 
-	ret = __create_hyp_private_mapping(phys_addr, size,
+	ret = __create_hyp_private_mapping(phys_addr, size, PAGE_SIZE,
 					   &addr, PAGE_HYP_DEVICE);
 	if (ret) {
 		iounmap(*kaddr);
@@ -564,7 +580,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 
 	BUG_ON(is_kernel_in_hyp_mode());
 
-	ret = __create_hyp_private_mapping(phys_addr, size,
+	ret = __create_hyp_private_mapping(phys_addr, size, PAGE_SIZE,
 					   &addr, PAGE_HYP_EXEC);
 	if (ret) {
 		*haddr = NULL;
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
