Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2414C19E4A
	for <kvmarm@lists.linux.dev>; Wed, 21 Jun 2023 17:50:29 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bfe702f99b8so1479527276.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Jun 2023 10:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687369828; x=1689961828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j157PG4NSYE82v2fAItKFhVfRcmmpeiCHUTGpM3SOrs=;
        b=Gl6wq+mEywBMdam4XfA6Jx3xs02PqlG2630KExwZ+IZ1eaEu2M8C4gqV/l7wcdwgF3
         /D1SpZQ0iJjXckKesr45c+8QYgxKeaJkXk4CzLhdqEna8C9zX/I5d6oFGpNmP8iq6sY5
         AD2tneZCrgHa95MtCXOU6/zAbzMhBOWLtGo2xx45SVnmLsd1KeV2yL43QUWZzbPYsRE5
         0KFNo+sYozd7eoDI93xm/37wexRwY8LUWph38U1kdZ/ZPiRwyt7W5rsyP0dZypbTXy1d
         v4IZ0o/cb4ZauS58uWHhZOddMD4erO5Pva1AdW/HnuLgUZTI3rDNpeArz5G2OY0RmC2L
         7aKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687369828; x=1689961828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j157PG4NSYE82v2fAItKFhVfRcmmpeiCHUTGpM3SOrs=;
        b=IRgx4T+4dZRNTVvjV6gy5fxuSDxYWTup8YSKuzqC71KQhM4EmGWhj0a+9PR9WKrv/Q
         T3fI1B6w5IfGOwuSq1cTrw77gDKctBzLKWcGlNuHy//2q03EXzrQjotHLkijuJnRMe/b
         0heEjf2uiRSZE5FAD/7NzIq24wSfePnBzr3vpqaIP8mRCbo2XOA39lY6y4kd4rqPWfQf
         62gQ3A21Z1JbZ+QeJpfZpqaH6dtBz3XkMnBqfVxVyge8RxHwGP59cXB5eyxdhe5w5MOY
         4vjtNz9uqFu8uFI07+yHCjprYdFyvrIB49Lmjr0EA99JbWffqScWgzc3byxv7iM+bU/U
         S3/Q==
X-Gm-Message-State: AC+VfDyXR9fQwlDKF0b13erDSkbgeckWzqSKZPch+hJyK8mbEGyA25N6
	I58c10eTZU2B2MRwOzH0jUwJohVxLsEC
X-Google-Smtp-Source: ACHHUZ6Ys0yNXltl/QNiOKpOLzit3oOUcal/03jYF6PfCeI/5MRSrcuUGPtaAxFV3KRRmbIadAvYp5jsj7ao
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:74c9:0:b0:ba8:4ff5:3217 with SMTP id
 p192-20020a2574c9000000b00ba84ff53217mr2202294ybc.3.1687369828056; Wed, 21
 Jun 2023 10:50:28 -0700 (PDT)
Date: Wed, 21 Jun 2023 17:49:58 +0000
In-Reply-To: <20230621175002.2832640-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230621175002.2832640-8-rananta@google.com>
Subject: [RESEND PATCH v5 07/11] KVM: arm64: Define kvm_tlb_flush_vmid_range()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, David Matlack <dmatlack@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Implement the helper kvm_tlb_flush_vmid_range() that acts
as a wrapper for range-based TLB invalidations. For the
given VMID, use the range-based TLBI instructions to do
the job or fallback to invalidating all the TLB entries.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4cd6762bda805..1b12295a83595 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -682,4 +682,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
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
index 3d61bd3e591d2..df8ac14d9d3d4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -631,6 +631,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt)
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
2.41.0.162.gfafddb0af9-goog

