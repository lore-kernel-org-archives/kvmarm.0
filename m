Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3644153BA
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 17:23:54 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id i8-20020a6b7908000000b007132e024fb5so7356315iop.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 09:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HD8UYRMgXgvHWUmdjVGh+ElciOrAtTAu4jFhw/x/rRQ=;
        b=nQ6CtqXZSzQGxB//GpjWfquAmvGTR5dWwlYFGiU/5px0GC3rJpOWnKhEsOUDQTahXm
         LPHYdrgMYTG/S8ZnZDRPwovCgJrDRFpIoyJEBvuXv3U7ZaE6HAEnMmjwkf2qSDmf6E75
         iaVBiXApoWChsBVG+b6ZNyvbAfbeiKBN9u8AXLWxmyVllftR4WlPwwovRShcouDAwv/Y
         nO9eHoBL6tOog9VaS7KtVRKW1ZIZSspm4oiic72yxChlIsLTGUo7X8+UbVSEgwWiW77h
         nJHjFwiQJZCRAb1AA1Z5dHfFui2O2vsWrGPgJUAEEpRsoPLNefaDZ5xzuND0Tp33Os5W
         gTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HD8UYRMgXgvHWUmdjVGh+ElciOrAtTAu4jFhw/x/rRQ=;
        b=IFsJ6lMJZPNhWDxod9s53Zu5f2rRlH5yc+mfldEhB70Hnfvl/2FDyrJZKe9HadcSH1
         zGXlAFUCuxIHOFeZDSBn4miLZyw5tt26hwsmMJsDQaGz/qI61BHrVYOId4vkHzBDpGwa
         pAn5MpR7DAb17jMwuXfryUhejXnYbFrCUbmMluNw/P2X/m5rbbXAW/erSJVYOsmjQWDF
         Gm8MdFA43ouanP390MLHumuzIxXJuswqwWH3gysNF5Pwu9N9AOO3fHvntpBlCTMSXuJK
         Ot5eTypda0+dtfEgti15crVs5jdbeatPi/DYYvuQqRdrDGZh1JhkNDYKId264zmyw3tk
         BCkA==
X-Gm-Message-State: AO0yUKXrJjjn9QXnY0mC6v5vf8NeEaREFsSwztnhALPIxrTRjqsehk9c
	+3fYCD2OKKZPa6iduWuQxT7eDjsrOJf+
X-Google-Smtp-Source: AK7set8+L6PzdEluzAA7EliIwZ6FnESXn+a+MIRyEkM0BR9u+V5qGwhqAUgQH+Hx7Flqnt0qmwXo/Xhbh14F
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6638:4c:b0:3ae:b0c1:72fe with SMTP id
 a12-20020a056638004c00b003aeb0c172femr51327jap.2.1675704233397; Mon, 06 Feb
 2023 09:23:53 -0800 (PST)
Date: Mon,  6 Feb 2023 17:23:39 +0000
In-Reply-To: <20230206172340.2639971-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206172340.2639971-7-rananta@google.com>
Subject: [PATCH v2 6/7] KVM: arm64: Break the table entries using TLBI range instructions
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

Currently, when breaking up the stage-2 table entries, KVM
would flush the entire VM's context using 'vmalls12e1is'
TLBI operation. One of the problematic situation is collapsing
table entries into a hugepage, specifically if the VM is
faulting on many hugepages (say after dirty-logging). This
creates a performance penality for the guest whose pages have
already been faulted earlier as they would have to refill their
TLBs again.

Hence, if the system supports it, use __kvm_tlb_flush_range_vmid_ipa()
to flush only the range of pages governed by the table entry,
while leaving other TLB entries alone. An upcoming patch also
takes advantage of this when breaking up table entries during
the unmap operation.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b11cf2c618a6c..0858d1fa85d6b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -686,6 +686,20 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
 	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
 }
 
+static void kvm_pgtable_stage2_flush_range(struct kvm_s2_mmu *mmu, u64 start, u64 end,
+						u32 level, u32 tlb_level)
+{
+	if (system_supports_tlb_range())
+		kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, mmu, start, end, level, tlb_level);
+	else
+		/*
+		 * Invalidate the whole stage-2, as we may have numerous leaf
+		 * entries below us which would otherwise need invalidating
+		 * individually.
+		 */
+		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+}
+
 /**
  * stage2_try_break_pte() - Invalidates a pte according to the
  *			    'break-before-make' requirements of the
@@ -721,10 +735,13 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	 * Perform the appropriate TLB invalidation based on the evicted pte
 	 * value (if any).
 	 */
-	if (kvm_pte_table(ctx->old, ctx->level))
-		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
-	else if (kvm_pte_valid(ctx->old))
+	if (kvm_pte_table(ctx->old, ctx->level)) {
+		u64 end = ctx->addr + kvm_granule_size(ctx->level);
+
+		kvm_pgtable_stage2_flush_range(mmu, ctx->addr, end, ctx->level, 0);
+	} else if (kvm_pte_valid(ctx->old)) {
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
+	}
 
 	if (stage2_pte_is_counted(ctx->old))
 		mm_ops->put_page(ctx->ptep);
-- 
2.39.1.519.gcb327c4b5f-goog

