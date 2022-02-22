Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565A7C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7744C459;
	Wed, 23 Feb 2022 06:02:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aNBRs-Sj7WsC; Wed, 23 Feb 2022 06:02:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08A0E4C47F;
	Wed, 23 Feb 2022 06:02:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD44049EE4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:54:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bXpdeUvTHpBB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 11:54:57 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69CEA49EC0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 11:54:57 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 k7-20020a255607000000b00621afc793b8so24924221ybb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 08:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=ZlyAAqqDhAE4WxbyZ31+jkqH/YpnLCKmJnh7POCxqTo=;
 b=TIooTTyH5x1F5nebrNIhkxrh2HuWrtPHN3fTIyBzs1a6KH6OGiKUp1PWOlO6NXsbQT
 k7h9zWn15cvo5sZhfXstOZ7RpAD+Gat9qLxoStKOCv0K160fImoXF6iu00kBuJnVyT6n
 YeThCRS0IPdnxIFck9JWsb0bj7sYMYA9LYn4MWVPyD2giNP+0cLZ8uSvz0IwXqXOXaOu
 G/dlwHj4gGGF4Y6nSgBvhRU/4Yq7YkrEaClamVuzK+tUFIXdOsSYoS/NWO0g8LCGrMsX
 It+EBn3ntQqg8tQNu7EC0xgAKjXEbbsSJs8P+w445Q4D6gLEB+GMhwcdWzAmnJsKbA4J
 Pgrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=ZlyAAqqDhAE4WxbyZ31+jkqH/YpnLCKmJnh7POCxqTo=;
 b=gTahh2rKw/vnsNgZO5KcXFeCOyKRjELENfh6xD+SUTwnasaubaXNwkwnw030mb5dCB
 qQEqvxEt0WN28NJQVGSNfKRXBaznJ8JV5MbMOzEuZ6ylHaTt1aRbhJlwnmtyBOh5gU6x
 boUf6riuicz/8vcZpJoQCQ1ib2EnPMdm9XG3swdrXC7hIAmpjnDdJU3Ct8kMdEKKB9As
 dRRgRq3+Xg8e+lKsqDxsCCL9/RlP4dg+Z8lPN4kG7gaROdxDLOzoAwVkn+dalP6MWo5F
 ta4A9dW5wrxdFAoMq00OhP9fs4mDjyopPp8/cdtn1G+kxPKJrn8FhL5AIkJm4zsZIJ2+
 X4Qg==
X-Gm-Message-State: AOAM530TmvxOYrWw1WedyZ4CUHEFO9+HzwGCSvXxGjGrOrOo5gI6SHhx
 s2Q808Wv3jum57roSFxUEQCim71YhYyNbeK2Sg==
X-Google-Smtp-Source: ABdhPJwTHC6zcsc1CP1g9QcEYL9chbpjl/nOUt74qFxAcpxZyUBNLrnrRhwJaWgirDTS7AoSkxlDAybxGjmkVJWUJw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5db7:1235:b3dd:cfcb])
 (user=kaleshsingh job=sendgmr) by 2002:a81:911:0:b0:2d2:c5c6:b4a1 with SMTP
 id 17-20020a810911000000b002d2c5c6b4a1mr24349571ywj.48.1645548896812; Tue, 22
 Feb 2022 08:54:56 -0800 (PST)
Date: Tue, 22 Feb 2022 08:51:03 -0800
In-Reply-To: <20220222165212.2005066-1-kaleshsingh@google.com>
Message-Id: <20220222165212.2005066-3-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220222165212.2005066-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v2 2/9] KVM: arm64: Introduce pkvm_alloc_private_va_range()
From: Kalesh Singh <kaleshsingh@google.com>
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Kalesh Singh <kaleshsingh@google.com>,
 surenb@google.com, linux-arm-kernel@lists.infradead.org
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
in the pKVM nVHE hypervisor (). Also update __pkvm_create_private_mapping()
to allow specifying an alignment for the private VA mapping.

These will be used to implement stack guard pages for pKVM nVHE hypervisor
(in a subsequent patch in the series).

Credits to Quentin Perret <qperret@google.com> for the idea of moving
private VA allocation out of __pkvm_create_private_mapping()

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v2:
  - Allow specifying an alignment for the private VA allocations, per Marc

 arch/arm64/kvm/hyp/include/nvhe/mm.h |  3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  5 +--
 arch/arm64/kvm/hyp/nvhe/mm.c         | 49 +++++++++++++++++++---------
 arch/arm64/kvm/mmu.c                 |  2 +-
 4 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 2d08510c6cc1..05d06ad00347 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -20,7 +20,8 @@ int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
-					    enum kvm_pgtable_prot prot);
+					size_t align, enum kvm_pgtable_prot prot);
+unsigned long pkvm_alloc_private_va_range(size_t size, size_t align);
 
 static inline void hyp_vmemmap_range(phys_addr_t phys, unsigned long size,
 				     unsigned long *start, unsigned long *end)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5e2197db0d32..96b2312a0f1d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -158,9 +158,10 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
 {
 	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
 	DECLARE_REG(size_t, size, host_ctxt, 2);
-	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
+	DECLARE_REG(size_t, align, host_ctxt, 3);
+	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 4);
 
-	cpu_reg(host_ctxt, 1) = __pkvm_create_private_mapping(phys, size, prot);
+	cpu_reg(host_ctxt, 1) = __pkvm_create_private_mapping(phys, size, align, prot);
 }
 
 static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 526a7d6fa86f..298fbbe4651d 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -37,26 +37,46 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 	return err;
 }
 
-unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
-					    enum kvm_pgtable_prot prot)
+/*
+ * Allocates a private VA range above __io_map_base.
+ *
+ * @size:	The size of the VA range to reserve.
+ * @align:	The required alignment for the allocation.
+ */
+unsigned long pkvm_alloc_private_va_range(size_t size, size_t align)
 {
-	unsigned long addr;
-	int err;
+	unsigned long base, addr;
 
 	hyp_spin_lock(&pkvm_pgd_lock);
 
-	size = PAGE_ALIGN(size + offset_in_page(phys));
-	addr = __io_map_base;
-	__io_map_base += size;
+	addr = ALIGN(__io_map_base, align);
+
+	/* The allocated size is always a multiple of PAGE_SIZE */
+	base = addr + PAGE_ALIGN(size);
 
 	/* Are we overflowing on the vmemmap ? */
-	if (__io_map_base > __hyp_vmemmap) {
-		__io_map_base -= size;
+	if (base > __hyp_vmemmap)
 		addr = (unsigned long)ERR_PTR(-ENOMEM);
+	else
+		__io_map_base = base;
+
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	return addr;
+}
+
+unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
+					size_t align, enum kvm_pgtable_prot prot)
+{
+	unsigned long addr;
+	int err;
+
+	size += offset_in_page(phys);
+	addr = pkvm_alloc_private_va_range(size, align);
+	if (IS_ERR((void *)addr))
 		goto out;
-	}
 
-	err = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, prot);
+	err = __pkvm_create_mappings(addr, size, phys, prot);
 	if (err) {
 		addr = (unsigned long)ERR_PTR(err);
 		goto out;
@@ -64,8 +84,6 @@ unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 
 	addr = addr + offset_in_page(phys);
 out:
-	hyp_spin_unlock(&pkvm_pgd_lock);
-
 	return addr;
 }
 
@@ -152,9 +170,8 @@ int hyp_map_vectors(void)
 		return 0;
 
 	phys = __hyp_pa(__bp_harden_hyp_vecs);
-	bp_base = (void *)__pkvm_create_private_mapping(phys,
-							__BP_HARDEN_HYP_VECS_SZ,
-							PAGE_HYP_EXEC);
+	bp_base = (void *)__pkvm_create_private_mapping(phys, __BP_HARDEN_HYP_VECS_SZ,
+							PAGE_SIZE, PAGE_HYP_EXEC);
 	if (IS_ERR_OR_NULL(bp_base))
 		return PTR_ERR(bp_base);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e5abcce44ad0..18a711d6a52f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -505,7 +505,7 @@ int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 
 	if (!kvm_host_owns_hyp_mappings()) {
 		addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
-					 phys_addr, size, prot);
+					 phys_addr, size, align, prot);
 		if (IS_ERR_OR_NULL((void *)addr))
 			return PTR_ERR((void *)addr);
 		*haddr = addr;
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
