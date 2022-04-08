Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1FCC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 20:05:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6608B4B236;
	Fri,  8 Apr 2022 16:05:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ol-6lhlbwX4U; Fri,  8 Apr 2022 16:05:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F7FA4B224;
	Fri,  8 Apr 2022 16:05:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 951CC4B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:05:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V6IaSz120Z1w for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 16:05:02 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5835E4B215
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:05:02 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 d5-20020a258245000000b0063e76f34cbeso3682457ybn.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 13:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=esUaOXgWpneeDOe1nHSsJFtoUVHLKNAUZwk+yTUnDdM=;
 b=IHzrsZW7/q3+tEZC29qIaCKrteJifI3LPzC8FMKtlG6sg3D3XkHzpF5KGjv+e5/NhV
 6lEaVR8Crd2tdksjW6hvrrrKyMMVfPZh0oV1fWsNdjpTlEX4KRQBfVIMRjCSEctPpt4K
 WUdqmieif6ozxcp6hvhIBN4d+lNvCAXGaecrB9GfIU/1ASsl7wODGe4dCpXGnAqq7gck
 8IA54iJ5GFDM6mT6yvePQuM1mBUG1OwobOsI3rPtiQndmcU/8PqOT3D31ke4tkcsZpU1
 K6Fb8dK4Uz1h9V4cdBubVhxnYNx5LgNgykvPYiiuhjvIONbDP7586D+liVFRDOhBGiAc
 nnLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=esUaOXgWpneeDOe1nHSsJFtoUVHLKNAUZwk+yTUnDdM=;
 b=xwIvMVQktEkzKaJ47idWk6ZkvvPjR974hxlkqDhPotpUP+oJBPk6G15+W0dfnxfHgy
 3QXrRRMjH1BcmAnYNmn7g/pQytg40hzqHgD6HgxsfDw93nmGvkDmKJCzf4+Bf0twRdlK
 dZwWF02MnHgSjmGSzPEr6IXXRmRpdAaAgXJq3ylQz89s3tW3sOdJq2O0uMEL+80iG77h
 NZS1AmmBCsq/UKKgR0OWRspKztRFlyQO3aQ4TPS6Ic8LiNY0KqKlVr618u428LoHUGnV
 QOTnNLzB94ILM9O7iwVoiZ0hzOIR+YE4nBShKvYPTzEjWrkDqVZF37VuZj2hG5/wtq/B
 iVlQ==
X-Gm-Message-State: AOAM533g+0oG3Ml/+/auKOxcJqzyOdzq6Y5g0LJ4qb9sUC6Yz5/myS1O
 AbAjnZgGMrcmB3Sa9LN326KOsrxFojH6YDfRUw==
X-Google-Smtp-Source: ABdhPJz/3Xcw9SE5/vQgYOnTDGnnPlY2m9VAKUmssImoSjztfyhXAryYWgmW8RSAso7gPCjapDD1N/7fFM1zmonZTg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f0ed:c8a:dab7:ecc2])
 (user=kaleshsingh job=sendgmr) by 2002:a25:8e90:0:b0:637:3d1f:cc39 with SMTP
 id q16-20020a258e90000000b006373d1fcc39mr15648078ybl.321.1649448301801; Fri,
 08 Apr 2022 13:05:01 -0700 (PDT)
Date: Fri,  8 Apr 2022 13:03:25 -0700
In-Reply-To: <20220408200349.1529080-1-kaleshsingh@google.com>
Message-Id: <20220408200349.1529080-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220408200349.1529080-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v7 2/6] KVM: arm64: Introduce pkvm_alloc_private_va_range()
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org, maz@kernel.org,
 Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Changbin Du <changbin.du@intel.com>,
 linux-arm-kernel@lists.infradead.org, surenb@google.com
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
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---

Changes in v7:
  - Add Fuad's Reviewed-by and Tested-by tags.

Changes in v6:
  - Update kernel-doc for pkvm_alloc_private_va_range() and add
    return description, per Stephen
  - Update pkvm_alloc_private_va_range() to return an int error code,
    per Stephen
  - Update __pkvm_create_private_mapping to return an in error code,
    per Quentin
  - Update callers of __pkvm_create_private_mapping() to handle new
    return value and params.

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


 arch/arm64/kvm/hyp/include/nvhe/mm.h |  6 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 18 ++++++-
 arch/arm64/kvm/hyp/nvhe/mm.c         | 78 ++++++++++++++++++----------
 3 files changed, 72 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 2d08510c6cc1..42d8eb9bfe72 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -19,8 +19,10 @@ int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
-unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
-					    enum kvm_pgtable_prot prot);
+int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
+				  enum kvm_pgtable_prot prot,
+				  unsigned long *haddr);
+int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
 
 static inline void hyp_vmemmap_range(phys_addr_t phys, unsigned long size,
 				     unsigned long *start, unsigned long *end)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5e2197db0d32..3cea4b6ac23e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -160,7 +160,23 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
 	DECLARE_REG(size_t, size, host_ctxt, 2);
 	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
 
-	cpu_reg(host_ctxt, 1) = __pkvm_create_private_mapping(phys, size, prot);
+	/*
+	 * __pkvm_create_private_mapping() populates a pointer with the
+	 * hypervisor start address of the allocation.
+	 *
+	 * However, handle___pkvm_create_private_mapping() hypercall crosses the
+	 * EL1/EL2 boundary so the pointer would not be valid in this context.
+	 *
+	 * Instead pass the allocation address as the return value (or return
+	 * ERR_PTR() on failure).
+	 */
+	unsigned long haddr;
+	int err = __pkvm_create_private_mapping(phys, size, prot, &haddr);
+
+	if (err)
+		haddr = (unsigned long)ERR_PTR(err);
+
+	cpu_reg(host_ctxt, 1) = haddr;
 }
 
 static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index cdbe8e246418..670f11349070 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -37,36 +37,60 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 	return err;
 }
 
-unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
-					    enum kvm_pgtable_prot prot)
+/**
+ * pkvm_alloc_private_va_range - Allocates a private VA range.
+ * @size:	The size of the VA range to reserve.
+ * @haddr:	The hypervisor virtual start address of the allocation.
+ *
+ * The private virtual address (VA) range is allocated above __io_map_base
+ * and aligned based on the order of @size.
+ *
+ * Return: 0 on success or negative error code on failure.
+ */
+int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
 {
-	unsigned long addr;
-	int err;
+	unsigned long base, addr;
+	int ret = 0;
 
 	hyp_spin_lock(&pkvm_pgd_lock);
 
-	size = PAGE_ALIGN(size + offset_in_page(phys));
-	addr = __io_map_base;
-	__io_map_base += size;
+	/* Align the allocation based on the order of its size */
+	addr = ALIGN(__io_map_base, PAGE_SIZE << get_order(size));
 
-	/* Are we overflowing on the vmemmap ? */
-	if (__io_map_base > __hyp_vmemmap) {
-		__io_map_base -= size;
-		addr = (unsigned long)ERR_PTR(-ENOMEM);
-		goto out;
-	}
+	/* The allocated size is always a multiple of PAGE_SIZE */
+	base = addr + PAGE_ALIGN(size);
 
-	err = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, prot);
-	if (err) {
-		addr = (unsigned long)ERR_PTR(err);
-		goto out;
+	/* Are we overflowing on the vmemmap ? */
+	if (!addr || base > __hyp_vmemmap)
+		ret = -ENOMEM;
+	else {
+		__io_map_base = base;
+		*haddr = addr;
 	}
 
-	addr = addr + offset_in_page(phys);
-out:
 	hyp_spin_unlock(&pkvm_pgd_lock);
 
-	return addr;
+	return ret;
+}
+
+int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
+				  enum kvm_pgtable_prot prot,
+				  unsigned long *haddr)
+{
+	unsigned long addr;
+	int err;
+
+	size += offset_in_page(phys);
+	err = pkvm_alloc_private_va_range(size, &addr);
+	if (err)
+		return err;
+
+	err = __pkvm_create_mappings(addr, size, phys, prot);
+	if (err)
+		return err;
+
+	*haddr = addr + offset_in_page(phys);
+	return err;
 }
 
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot)
@@ -146,7 +170,8 @@ int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot)
 int hyp_map_vectors(void)
 {
 	phys_addr_t phys;
-	void *bp_base;
+	unsigned long bp_base;
+	int ret;
 
 	if (!kvm_system_needs_idmapped_vectors()) {
 		__hyp_bp_vect_base = __bp_harden_hyp_vecs;
@@ -154,13 +179,12 @@ int hyp_map_vectors(void)
 	}
 
 	phys = __hyp_pa(__bp_harden_hyp_vecs);
-	bp_base = (void *)__pkvm_create_private_mapping(phys,
-							__BP_HARDEN_HYP_VECS_SZ,
-							PAGE_HYP_EXEC);
-	if (IS_ERR_OR_NULL(bp_base))
-		return PTR_ERR(bp_base);
+	ret = __pkvm_create_private_mapping(phys, __BP_HARDEN_HYP_VECS_SZ,
+					    PAGE_HYP_EXEC, &bp_base);
+	if (ret)
+		return ret;
 
-	__hyp_bp_vect_base = bp_base;
+	__hyp_bp_vect_base = (void *)bp_base;
 
 	return 0;
 }
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
