Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FF0C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 18:50:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7A274B0CC;
	Mon,  7 Mar 2022 13:50:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P4a1+htXs161; Mon,  7 Mar 2022 13:50:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BFD24B08E;
	Mon,  7 Mar 2022 13:50:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDE714B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:50:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TbKhWtxU-Kms for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 13:50:15 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF92A4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:50:15 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d11b6259adso139849997b3.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Mar 2022 10:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=U0KXh0E1UfE42rPLXuz3Ms4NzPqEuYXKZZtL9fLcEYA=;
 b=nU4RTA3/xhDWfnM8dMSLJKKLbRrMNT3c0ORnHVae1dtm01ActWIdwKtb+4XdGdlWfL
 dy/1kzFpo7DIt5F3glPY4tvNFMHaZDbwC6PVk3ZAvatX334u4JalLNIq5m6iVWhtnW2x
 Yq0g1D3peSs9qAeVur7zzMcTc+qGYOmgoE8BSAckpbzGceepfCq0A/+HiyL+pWj7iiTH
 RJZrzy/96BWG6GCv4E/FRHkMnAQPrcnha/N52RvX5vzsYktYfTJyB7to6Xna/wvIyiJN
 XSayW5jkZJapoyll58iQBJPo9ZrZoBmxddKGdcAmUPZZVz2croqlDmZGSoFPcjUOlDNA
 Kabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=U0KXh0E1UfE42rPLXuz3Ms4NzPqEuYXKZZtL9fLcEYA=;
 b=GL8OPR2AqmB7nL19BQ6bFKrSfR1lL4SYZ3kEVWX6bVnLnCQbAZlffthzw/ivht2E9n
 aQ8sIASxzIjXlZidEc/ODgKtVd1VZ/fyFQGRATrdNAI+ipisoSL2nORCZEqjDwgB7Sf5
 +6lIlTrn4KbRITUYufBzoMxyC232A/CskEiR243kcXIgGWyAouPrF8Sc9nagEs3qoQlB
 uvNyxuqP1Yia/ZieoLIKWTot99z22ISpZC52eQFWrDZxsoANCQmbCjXcfpXZjrv8ARxO
 /6hMvRc1PmUfFDoFItsQR5uYYaMQb/aF3fga9DU56NL3Ojd61/P3FR03WQyHslDjEJm4
 dHuA==
X-Gm-Message-State: AOAM533I4DNDuBZEPBSzyTdCFayROiE8ywG4Y55lsviiyG7XmmmfS/X3
 99lzYi7/tZffWWvSKkpmolTykhePZiz8g9kt0A==
X-Google-Smtp-Source: ABdhPJz9iBWuUeegmCOa9Cbkl3sUJD62w7+nQrFfm6gUEqY19/bTdAmd6dRquKjJLU6HAR39kZtea75lirYYlPQxOw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:dd66:1e7d:1858:4587])
 (user=kaleshsingh job=sendgmr) by 2002:a05:690c:16:b0:2db:cfed:de0e with SMTP
 id bc22-20020a05690c001600b002dbcfedde0emr6331197ywb.271.1646679015317; Mon,
 07 Mar 2022 10:50:15 -0800 (PST)
Date: Mon,  7 Mar 2022 10:48:59 -0800
In-Reply-To: <20220307184935.1704614-1-kaleshsingh@google.com>
Message-Id: <20220307184935.1704614-2-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220307184935.1704614-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v5 1/8] KVM: arm64: Introduce hyp_alloc_private_va_range()
From: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 surenb@google.com, kvmarm@lists.cs.columbia.edu
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
in the nVHE hypervisor. Allocations are aligned based on the order of
the requested size.

This will be used to implement stack guard pages for KVM nVHE hypervisor
(nVHE Hyp mode / not pKVM), in a subsequent patch in the series.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Align private allocations based on the order of their size, per Marc

Changes in v4:
  - Handle null ptr in hyp_alloc_private_va_range() and replace
    IS_ERR_OR_NULL checks in callers with IS_ERR checks, per Fuad
  - Fix kernel-doc comments format, per Fuad

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark


 arch/arm64/include/asm/kvm_mmu.h |  1 +
 arch/arm64/kvm/mmu.c             | 63 +++++++++++++++++++++-----------
 2 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 81839e9a8a24..514cfee76597 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -153,6 +153,7 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 int kvm_share_hyp(void *from, void *to);
 void kvm_unshare_hyp(void *from, void *to);
 int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
+unsigned long hyp_alloc_private_va_range(size_t size);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
 			   void __iomem **haddr);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bc2aba953299..ccb2847ee2f4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -457,22 +457,17 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return 0;
 }
 
-static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
-					unsigned long *haddr,
-					enum kvm_pgtable_prot prot)
+
+/**
+ * hyp_alloc_private_va_range - Allocates a private VA range.
+ * @size:	The size of the VA range to reserve.
+ *
+ * The private VA range is allocated below io_map_base and
+ * aligned based on the order of @size.
+ */
+unsigned long hyp_alloc_private_va_range(size_t size)
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
 
@@ -484,29 +479,53 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	 *
 	 * The allocated size is always a multiple of PAGE_SIZE.
 	 */
-	size = PAGE_ALIGN(size + offset_in_page(phys_addr));
-	base = io_map_base - size;
+	base = io_map_base - PAGE_ALIGN(size);
+
+	/* Align the allocation based on the order of its size */
+	base = ALIGN_DOWN(base, PAGE_SIZE << get_order(size));
 
 	/*
 	 * Verify that BIT(VA_BITS - 1) hasn't been flipped by
 	 * allocating the new area, as it would indicate we've
 	 * overflowed the idmap/IO address range.
 	 */
-	if ((base ^ io_map_base) & BIT(VA_BITS - 1))
-		ret = -ENOMEM;
+	if (!base || (base ^ io_map_base) & BIT(VA_BITS - 1))
+		base = (unsigned long)ERR_PTR(-ENOMEM);
 	else
 		io_map_base = base;
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 
-	if (ret)
-		goto out;
+	return base;
+}
+
+static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
+					unsigned long *haddr,
+					enum kvm_pgtable_prot prot)
+{
+	unsigned long addr;
+	int ret = 0;
+
+	if (!kvm_host_owns_hyp_mappings()) {
+		addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
+					 phys_addr, size, prot);
+		if (IS_ERR((void *)addr))
+			return PTR_ERR((void *)addr);
+		*haddr = addr;
+
+		return 0;
+	}
+
+	size += offset_in_page(phys_addr);
+	addr = hyp_alloc_private_va_range(size);
+	if (IS_ERR((void *)addr))
+		return PTR_ERR((void *)addr);
 
-	ret = __create_hyp_mappings(base, size, phys_addr, prot);
+	ret = __create_hyp_mappings(addr, size, phys_addr, prot);
 	if (ret)
 		goto out;
 
-	*haddr = base + offset_in_page(phys_addr);
+	*haddr = addr + offset_in_page(phys_addr);
 out:
 	return ret;
 }
-- 
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
