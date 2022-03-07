Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88038C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 18:50:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B2C34B102;
	Mon,  7 Mar 2022 13:50:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 41bixfwgFqm1; Mon,  7 Mar 2022 13:50:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAEF74B0B8;
	Mon,  7 Mar 2022 13:50:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98BC04B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:50:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QfW0MXYHkSJt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 13:50:48 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62FE64A5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 13:50:48 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 190-20020a2505c7000000b00629283fec72so4708341ybf.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Mar 2022 10:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=QBbWsCMipbp44l60Hdnv4XMYOtaR1GdEoMf3jzNsWgs=;
 b=gM0pv/8FCbYZxhqR275beD5eFCkqcNqsMmJ/PCIO9/74PJRIq4bvKL+TExhgPsSV9H
 8IZ+Lx+fTJxGshS8UCfhsyQH8OHdgtqaelSPoEUQ/ZZgA5JZ2XXIk2wDBkSsS09ci/Vm
 nc14x3Fm7A06nDWxKHmLzedW5ynRc/Fk8ZUlE3hox6qPSjvxPdxrqiYDWcslJKOvGQeA
 OLEi1Q/pjI0xTGX5fvu9dT3uMRuEvspchfT3X08k4XOIdO31s3fgNXbgWMurSlR1u5Kp
 TvjBEZJQrm+rwVWO0Is4qUz55KsBhuIJ6FUZJDI0qGpEwtwoJlvpoRx3mLo1+HYZSXBn
 46LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=QBbWsCMipbp44l60Hdnv4XMYOtaR1GdEoMf3jzNsWgs=;
 b=F21+ZzHjdvbra+TurzMfuTAbIw9W2abEAHbENV2bDqANBugWzJR/B1clkQTJ/GhjvC
 7+4261nVtBE/JtKrZVw6HJpEeO+3BXLek+LrWz1wGvWDSUianJxwIBmcOA7JotOvnGFr
 ZQ+aPYE1zUsuqHgldXjf3UeQwDqO+MVFgVZGx5GMB9W6QdeAHJGoRNfQJn2XqXgggGJG
 fTIct+RsYt6VBLBS0/YB31eZsbA3JgtcDZfv7mZ5VVUT3WFLCaHDxeCcrA/l4LJYD0Ia
 9uN9YSs1JJ58pxtYMDAIeTXCP8qC2rzuzb1b/R3wPh0VRZfp91nH3GwaOQyNjHu4KR4A
 GBaw==
X-Gm-Message-State: AOAM533xNgLe+K39DofbvgqicX6Hes7voRtvnuT6VsG3Qj08ehAdkFcx
 tCRLbPPDdE4t62nFIaQOFVdKGiML7+1AmLY7kw==
X-Google-Smtp-Source: ABdhPJxC3SgNVhIeELDphJF5+sDCMc2sK08i+u2Eh85wtEFHg9LLbSQ7mTnrKZENjGb8LjSuT4xNjhZG48kUobrwoQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:dd66:1e7d:1858:4587])
 (user=kaleshsingh job=sendgmr) by 2002:a25:e7c4:0:b0:629:415b:40b5 with SMTP
 id e187-20020a25e7c4000000b00629415b40b5mr4859841ybh.315.1646679047782; Mon,
 07 Mar 2022 10:50:47 -0800 (PST)
Date: Mon,  7 Mar 2022 10:49:00 -0800
In-Reply-To: <20220307184935.1704614-1-kaleshsingh@google.com>
Message-Id: <20220307184935.1704614-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220307184935.1704614-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH v5 2/8] KVM: arm64: Introduce pkvm_alloc_private_va_range()
From: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 surenb@google.com
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

pkvm_hyp_alloc_private_va_range() can be used to reserve private VA ranges
in the pKVM nVHE hypervisor. Allocations are aligned based on the order of
the requested size.

This will be used to implement stack guard pages for pKVM nVHE hypervisor
(in a subsequent patch in the series).

Credits to Quentin Perret <qperret@google.com> for the idea of moving
private VA allocation out of __pkvm_create_private_mapping()

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v5:
  - Align private allocations based on the order of their size, per Marc

Changes in v4:
  - Handle null ptr in pkvm_alloc_private_va_range() and replace
    IS_ERR_OR_NULL checks in callers with IS_ERR checks, per Fuad
  - Fix kernel-doc comments format, per Fuad
  - Format __pkvm_create_private_mapping() prototype args (< 80 col), per Fuad

Changes in v3:
  - Handle null ptr in IS_ERR_OR_NULL checks, per Mark

Changes in v2:
  - Allow specifying an alignment for the private VA allocations, per Marc


 arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mm.c         | 56 ++++++++++++++++++----------
 2 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 2d08510c6cc1..4489c3c849de 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -21,6 +21,7 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 					    enum kvm_pgtable_prot prot);
+unsigned long pkvm_alloc_private_va_range(size_t size);
 
 static inline void hyp_vmemmap_range(phys_addr_t phys, unsigned long size,
 				     unsigned long *start, unsigned long *end)
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 526a7d6fa86f..c0943e541a8d 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -37,38 +37,54 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 	return err;
 }
 
-unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
-					    enum kvm_pgtable_prot prot)
+/**
+ * pkvm_alloc_private_va_range - Allocates a private VA range.
+ * @size:	The size of the VA range to reserve.
+ *
+ * The private VA range is allocated above __io_map_base and
+ * aligned based on the order of @size.
+ */
+unsigned long pkvm_alloc_private_va_range(size_t size)
 {
-	unsigned long addr;
-	int err;
+	unsigned long base, addr;
 
 	hyp_spin_lock(&pkvm_pgd_lock);
 
-	size = PAGE_ALIGN(size + offset_in_page(phys));
-	addr = __io_map_base;
-	__io_map_base += size;
+	/* Align the allocation based on the order of its size */
+	addr = ALIGN(__io_map_base, PAGE_SIZE << get_order(size));
+
+	/* The allocated size is always a multiple of PAGE_SIZE */
+	base = addr + PAGE_ALIGN(size);
 
 	/* Are we overflowing on the vmemmap ? */
-	if (__io_map_base > __hyp_vmemmap) {
-		__io_map_base -= size;
+	if (!addr || base > __hyp_vmemmap)
 		addr = (unsigned long)ERR_PTR(-ENOMEM);
-		goto out;
-	}
+	else
+		__io_map_base = base;
 
-	err = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, prot);
-	if (err) {
-		addr = (unsigned long)ERR_PTR(err);
-		goto out;
-	}
-
-	addr = addr + offset_in_page(phys);
-out:
 	hyp_spin_unlock(&pkvm_pgd_lock);
 
 	return addr;
 }
 
+unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
+					    enum kvm_pgtable_prot prot)
+{
+	unsigned long addr;
+	int err;
+
+	size += offset_in_page(phys);
+	addr = pkvm_alloc_private_va_range(size);
+	if (IS_ERR((void *)addr))
+		return addr;
+
+	err = __pkvm_create_mappings(addr, size, phys, prot);
+	if (err)
+		return (unsigned long)ERR_PTR(err);
+
+	return addr + offset_in_page(phys);
+}
+
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot)
 {
 	unsigned long start = (unsigned long)from;
@@ -155,7 +171,7 @@ int hyp_map_vectors(void)
 	bp_base = (void *)__pkvm_create_private_mapping(phys,
 							__BP_HARDEN_HYP_VECS_SZ,
 							PAGE_HYP_EXEC);
-	if (IS_ERR_OR_NULL(bp_base))
+	if (IS_ERR(bp_base))
 		return PTR_ERR(bp_base);
 
 	__hyp_bp_vect_base = bp_base;
-- 
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
