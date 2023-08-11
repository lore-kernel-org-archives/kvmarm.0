Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F40D10F1
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 04:51:46 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-589c2516024so3299087b3.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 21:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729506; x=1692334306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CwKTqZRHBF6wuN1C9cAW2HapO35gWwZnaXscRj6lwnc=;
        b=siKzlnyeJYxNxz3Le8APQ8uLcQDtQqwiSQdt6bti4OnKCrnHioFgjEot+EwjAKZlZk
         P9katyZ2JtDsI8FPdIPMQYuckWNVQ5RfjwpRdQhAMFEwhgD7E0eUrp3A0uStx/N0UzhL
         4Ib4FS/HKhPlrslYEhf4bRkLeti0q5O+S43TqWtGnA5mbcXMOQ0sOHExR4e18KudVMIM
         +gsKAXATZIeVV6zWjmXpe2nel8pvZAoV6Cdm7wSDFmb+FgKWoTaCWMpAZi1va3S+D+BS
         4KbaNzlRFGZu0d060Mbd+mqHAW0BvsFI1Oql8h2q/mQt8DVk9UFWyigyB13jSZ+L3pM7
         Nm/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729506; x=1692334306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwKTqZRHBF6wuN1C9cAW2HapO35gWwZnaXscRj6lwnc=;
        b=SK9u1g7CT3HYcI55x/sHOICQm6s1k9FskGH35oL3/HSp7QSavi5un+/3fD7JLolz3d
         SKPLVP6kWl732cElq5tmsk4UL+3JfUkQd2P6R93LBGOMQQbEfvtpo4HoJgI3agc7M9U9
         T8f44ZVmEyyttX9ue75TcUiRgNO1Ig/sU8CThd4aN6nx9d9Z59ViJPrltyWsAppRgQak
         XPpP3bud8eVjy87LXaVgnlf5KaY+8046ehpLvhyNkc4CX3wdwRRXuCdyseQl8lmjHkxn
         /GuapSemVQlSP2+Xqzqx1ApZ+CgCf3NF/LWlhaJpttoDg5Vs9LML7WrlZ8DIFtRA6arw
         U4bA==
X-Gm-Message-State: AOJu0YwdIpuWaKfpi/jVN0Wsz8YitqQUjH30Nnv38gQzLcyYbZauekxG
	qZ0/Fwfy38fo6pexDkYyVS0WHx84tOwP
X-Google-Smtp-Source: AGHT+IEoLRdyr3lsTK4vKyN6f7vXGgpqz2mVAAYTzW+KAu5EcGudZd07SchN8aesdD/7sDPFXHJ3RHFbNwel
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:8185:0:b0:d63:1d2b:624e with SMTP id
 p5-20020a258185000000b00d631d2b624emr9342ybk.0.1691729505983; Thu, 10 Aug
 2023 21:51:45 -0700 (PDT)
Date: Fri, 11 Aug 2023 04:51:23 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-11-rananta@google.com>
Subject: [PATCH v9 10/14] KVM: arm64: Define kvm_tlb_flush_vmid_range()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
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
index 8294a9a7e566d..5e8b1ff07854b 100644
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
index aa740a974e024..5d14d5d5819a1 100644
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
2.41.0.640.ga95def55d0-goog

