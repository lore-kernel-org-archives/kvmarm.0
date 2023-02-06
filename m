Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493E753BD
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 17:23:50 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id s7-20020a257707000000b0085600c7c70cso12066803ybc.5
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 09:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BkWHRJ3DaV8HyItO3IxH/uOsr0AuzsEy+IWd0D6gRm0=;
        b=gDebpZOlByZMcipJS7iiuEaEoz2LNOZhbfjLuHHnTzbhZvH4gPrm4N5h+hXmgtUVft
         sBsxc7NH3DIOlVtD10BAJGlhmkwzLmogWYFoJs75t0sGYS78+904yzwoYUpRcqYIdZOC
         Izj40XAX4urHpYj2KXU9Uborl412/oBiHYOR+vPy/sQ+dwLzU2UsJo3sVKpTKOGZtBdr
         XYxW4tjeM7GYcDvx8ygtuvIjH4aCXWwWKx7PizQkoTYhJk5w3afxDp5BHjrSL9uL7X3a
         sPqadJaV7P2oGojYZ5LLqsjeGRZroWjZdrQRfrgtR2lF1mbNkF0I+xCdw2/zFn/VXQmr
         KDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BkWHRJ3DaV8HyItO3IxH/uOsr0AuzsEy+IWd0D6gRm0=;
        b=QldJ8g1jr3LuwM1RWx+8Kw+YeIGLQb5sIfbatttJUKy7HgyfiVkrziHJrd2X2U0kOP
         rAp7upmBpLiYDKiwlNyMZZEqW/eUvjN/i5XlShFMo1gPhPZLQRBToSfIQiEAX30KlLMg
         2mwtl5oxtQLYMe9Omw4H4o8XP4fLbS6Zc9BYipvXUxtSRvlzkwC++um0aYup1h8ZsUcu
         vgZz6P+RvxE2N5+BhiwyfmgUoGp82CrqRUsTlBc0OQjwGktTTQwP1hS/rwr3PHUnf6h5
         NtSnicgON/GKSgsnxuEa45PePTnYf55wTVmG6XtL/vqvIl1+VfxK8/k0Lt5ELu4mqCeP
         PB4A==
X-Gm-Message-State: AO0yUKXUKUFGx46A1DYjHJ+cBSaemYb/2Wu2DsJpLhFyWJ9yyZdv3M8d
	fRTO/Z0pHoLMdvfZG7GGiM4rWKkT5zdk
X-Google-Smtp-Source: AK7set+MnrswiwWWU7VjVXEwJFGUTZwq2+FDuhGHpgxo1swkM3BdaMOiSD9i23X6Wo2T0up/ZIHq2NMFv4Er
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:4e95:0:b0:527:b484:aa14 with SMTP id
 c143-20020a814e95000000b00527b484aa14mr602256ywb.263.1675704229352; Mon, 06
 Feb 2023 09:23:49 -0800 (PST)
Date: Mon,  6 Feb 2023 17:23:35 +0000
In-Reply-To: <20230206172340.2639971-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206172340.2639971-3-rananta@google.com>
Subject: [PATCH v2 2/7] KVM: arm64: Add FEAT_TLBIRANGE support
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, Reiji Watanabe <reijiw@google.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Define a generic function __kvm_tlb_flush_range() to
invalidate the TLBs over a range of addresses. The
implementation accepts 'op' as a generic TLBI operation.
Upcoming patches will use this to implement IPA based
TLB invalidations (ipas2e1is).

If the system doesn't support FEAT_TLBIRANGE, the
implementation falls back to flushing the pages one by one
for the range supplied.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 43c3bc0f9544d..995ff048e8851 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -221,6 +221,24 @@ DECLARE_KVM_NVHE_SYM(__per_cpu_end);
 DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
 #define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
 
+#define __kvm_tlb_flush_range(op, mmu, start, end, level, tlb_level) do {	\
+	unsigned long pages, stride;						\
+										\
+	stride = kvm_granule_size(level);					\
+	start = round_down(start, stride);					\
+	end = round_up(end, stride);						\
+	pages = (end - start) >> PAGE_SHIFT;					\
+										\
+	if ((!system_supports_tlb_range() &&					\
+	     (end - start) >= (MAX_TLBI_OPS * stride)) ||			\
+	    pages >= MAX_TLBI_RANGE_PAGES) {					\
+		__kvm_tlb_flush_vmid(mmu);					\
+		break;								\
+	}									\
+										\
+	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false);	\
+} while (0)
+
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
-- 
2.39.1.519.gcb327c4b5f-goog

