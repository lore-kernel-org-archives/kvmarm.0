Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B816AA2
	for <kvmarm@lists.linux.dev>; Sat, 22 Jul 2023 02:23:03 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d052f49702dso1013775276.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 19:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689992583; x=1690597383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E8R5tRLm4LxOnjTEGwM7a4ioC3VdBYtUr1OruyGFhsg=;
        b=cfBIBtaMGZEf4AhY6J0548A+CtaTY7s4VELnEIeFABxI92SvaWQW27WRnp+/q887jd
         b1TjIDORVqU07EPUQ/Q19Kx672JDaqfeiAMzany/gcKSRQRyhlDPKz73ZGnNHtbWJBcs
         UdVEkbrC7PTnQ3AO+JgNGaP9tE7X1Jr8LevbOQPisjvpV/1GUqvSezpBlGv+V1Pa8Bk/
         Dz7iMBvzxCmA92YdIR4l8vs0QhvpSPRaa9AWLGqWcLL0gam+6TRFZut+BKtU94QsycPh
         UUDfnGqhH3nalOxviTCBnCVfFkZB08T951R3KSDpXW/NULcZOSqnOMHnzE4x6FrSPe5l
         ug3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992583; x=1690597383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E8R5tRLm4LxOnjTEGwM7a4ioC3VdBYtUr1OruyGFhsg=;
        b=MOLTicX9tR74fMec9M0bMrERZIFhPbQ/Sh9c8ls9Imrhw2evF3omr2B+50TY9iuTZy
         xNxNuk+vZGg4EPCGKZWGhOZoH0Jyx9F2wrw7CAj/IL0el0qwv+RtMY5JrjdhOYDDk6je
         yLFoTU84HeYgwMNn0c07i0dR+wc4FPD8HP+EY0+73bKckGph1oLNp8CJIGVsm1txOmIQ
         0b88cHndCB2UcOB2WQBFTjSgOypuuh9wi/gzqWCP7eXv0ve3+jtliVDSEFSLF7IK9itI
         qumCbR2PFK8j0EG4kMfA0fdtXLun4CV3hATZ8NwEs2hTCp0ad2J5QurFoyXczfbDDkFi
         7rbg==
X-Gm-Message-State: ABy/qLaq8GDEum6D4tTCStn9vkKxxs0ccYeRlTlTyxayevVJdOJguUO3
	z3LxvsuSAeWkj6fTlIKuRWRVkpEeCMAG
X-Google-Smtp-Source: APBJJlHQt1NDcPAocmh72u+0bhsq/dtXjKO55NUZwrSeo0TWR6BjgNiz1KwqJUxErtKe8+mwZ90j9gI+Kx9y
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6902:102f:b0:c22:38c2:43de with SMTP
 id x15-20020a056902102f00b00c2238c243demr26408ybt.11.1689992582937; Fri, 21
 Jul 2023 19:23:02 -0700 (PDT)
Date: Sat, 22 Jul 2023 02:22:47 +0000
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722022251.3446223-9-rananta@google.com>
Subject: [PATCH v7 08/12] KVM: arm64: Define kvm_tlb_flush_vmid_range()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Implement the helper kvm_tlb_flush_vmid_range() that acts
as a wrapper for range-based TLB invalidations. For the
given VMID, use the range-based TLBI instructions to do
the job or fallback to invalidating all the TLB entries.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 8294a9a7e566..5e8b1ff07854 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -754,4 +754,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
  *	   kvm_pgtable_prot format.
  */
 enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
+
+/**
+ * kvm_tlb_flush_vmid_range() - Invalidate/flush a range of TLB entries
+ *
+ * @mmu:	Stage-2 KVM MMU struct
+ * @addr:	The base Intermediate physical address from which to invalidate
+ * @size:	Size of the range from the base to invalidate
+ */
+void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t addr, size_t size);
 #endif	/* __ARM64_KVM_PGTABLE_H__ */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index aa740a974e02..5d14d5d5819a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -670,6 +670,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt)
 	return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
 }
 
+void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t addr, size_t size)
+{
+	unsigned long pages, inval_pages;
+
+	if (!system_supports_tlb_range()) {
+		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+		return;
+	}
+
+	pages = size >> PAGE_SHIFT;
+	while (pages > 0) {
+		inval_pages = min(pages, MAX_TLBI_RANGE_PAGES);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, addr, inval_pages);
+
+		addr += inval_pages << PAGE_SHIFT;
+		pages -= inval_pages;
+	}
+}
+
 #define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
 
 static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
-- 
2.41.0.487.g6d72f3e995-goog

