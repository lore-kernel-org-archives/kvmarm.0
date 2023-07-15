Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E043EA6
	for <kvmarm@lists.linux.dev>; Sat, 15 Jul 2023 00:54:18 +0000 (UTC)
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-3a1e6022b60so4155271b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 17:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689382458; x=1689987258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U4OZjoW9BqjNxcy4RlxY9pkc5PoIDGveDxU+kXtMBcc=;
        b=KKRWmCcpJXud3QITKn5f94EERCBvnHfPo2Jd+ekvTDvit1ZKtL2At/rqLvkk4EbxYh
         bmv7L5z/I6o+5NvucbGQ3K/kzCTqCMksln5zbsw+MH51Mq23uoECcPykuMVuXgs/PZud
         5lgv/htkcYPoczACz2XxnIE0lYxBwMph7p2vFFTX1Bbj2MJhQ9+vg3FCoV+ZWqWxc0Fs
         8w/rrCxOr/GEutoHZlF+pVrS1gEqAxig3LcGCszVXObyi6SOjyH9F0QOp4wPuHsmLJot
         viR1y/i87qN0pJZ1fI3ZxyhwcGyqozylSHVo1vzB+ZQbxgU2/o0DLNIpJ0px4eAfctld
         qWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689382458; x=1689987258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U4OZjoW9BqjNxcy4RlxY9pkc5PoIDGveDxU+kXtMBcc=;
        b=Og3vEWO203vxvYWYQmisQWAYMUryI+X5edwkghs/1WVuMywPy9M5fTF6M92xfTZq9+
         v3HV98rFBUZGpl6kBbC38ys39+KDG7JcZFiDEluP4tU5w0ch6IcP0u4OLhe5kXDX24w8
         eI6ZhRMJqbXnzHmuM89xF+IU4pb8SUaUKrDN1XIsQceKbRwwtJwDkdq7HaUnBgi5KM1t
         U2SlkFQR5RkmDLMk3vAE33veJIREAONPbj9YY+PKZ6EAaIxh2SFahwlZOk/iTgMcMDpp
         VFe6HdPOJJHXnpHfxaT+2FV4ShN8qkcICZYZ+OYLk0tE4uxs5Bw2boO/ZvkoMFaRuQ+J
         O/YA==
X-Gm-Message-State: ABy/qLZnni6w40TDFZk60+EFjJG4wxj6w1UdM9n7WcOhKH9PySzjOjwM
	55XPA/ew9JE0cIQf9f7NtWsBJQ5bBKex
X-Google-Smtp-Source: APBJJlHuS8cIctisxFR2eCx11We7uRlijX+IqW5kBp1R23rbpuDDG4OLeHpdRXsyz6OpKgpcWVQKaGIlx/8R
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6808:d4f:b0:3a4:26e5:8b24 with SMTP id
 w15-20020a0568080d4f00b003a426e58b24mr7748513oik.9.1689382458208; Fri, 14 Jul
 2023 17:54:18 -0700 (PDT)
Date: Sat, 15 Jul 2023 00:54:01 +0000
In-Reply-To: <20230715005405.3689586-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230715005405.3689586-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.455.g037347b96a-goog
Message-ID: <20230715005405.3689586-8-rananta@google.com>
Subject: [PATCH v6 07/11] KVM: arm64: Define kvm_tlb_flush_vmid_range()
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
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Implement the helper kvm_tlb_flush_vmid_range() that acts
as a wrapper for range-based TLB invalidations. For the
given VMID, use the range-based TLBI instructions to do
the job or fallback to invalidating all the TLB entries.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
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
2.41.0.455.g037347b96a-goog

