Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CD963A6
	for <kvmarm@lists.linux.dev>; Fri, 14 Apr 2023 17:29:31 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id i4-20020a056e020d8400b00325a80f683cso10926285ilj.22
        for <kvmarm@lists.linux.dev>; Fri, 14 Apr 2023 10:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681493371; x=1684085371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oKp1uqEVUDsYvqb7n0EE6E39VgTURLiqq4SIcHauWnY=;
        b=A4ww0TsBpNc8NyuHHycocTyIKbFT6p62k0/A8t5/ltX9KxG0M7SK44yK6ry6Z2mMF+
         jeqV8N1OxvCVX9VRDGFZjgankBqNIL3n4bQYbPNlur0Gt+i5wrEcpZtd0hABAsHIgk0I
         QQYcuZsYerlzIHJ/z/LzsZc/GTmGp4M7XXAI8JUUuj3h736xuhABjmEb6C0gPmwG/Lbv
         tnshnBhAnysXSf0cOeG/AmMed5U4ze4xTJmfqAReYTCUtmv8k1LurjOJXsjR04evZfNt
         855K7678/DIciNdxe2RQK1JEWX6ua6QX1paK8Ve8Ve8btXIDgE4M5fLPABa2fB1l2v8h
         VeTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681493371; x=1684085371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oKp1uqEVUDsYvqb7n0EE6E39VgTURLiqq4SIcHauWnY=;
        b=cruaPb8SbbSq/Omo46wE8WjoZ6U/RRCMXw+dvIlTgaAl+JU3ULOdKUST8FicrYsaOg
         JiaYOkOfIDnSgYG14Uh40TMJgI7NtnyhwQyER5e62AnfTqV0LuOTpr3eHr1cRgLI4i7n
         5Zg4UzR1t4GDvJ8je5lbMvPXqDTFve99/YaIcgNpd7m/JEEpKK9S/rXeGgnAbevvl/z1
         FbfbBDEZMW3Fc8fHzqk8T0GzDgZO3ugygHxyeaQ/Y9UM8O9c8kh+IEhocj5xXzVRULtj
         xDCH9ceV/w5ylmykUe61IgcNzbmz+fyKmthsMDcQgmbS4HwXMQ35RvypxZ5pfoQcTonE
         CmnQ==
X-Gm-Message-State: AAQBX9f9Syq5ocQFpmW8GzQHOq2R1xgh7QdzhsbiRHqWrOWsXtRTcABN
	mYrMY195ljeXhZb5SKvs3IG06gG5eF4f
X-Google-Smtp-Source: AKy350YdGpBiZBP25Vx/4WpYHfw47rqMyEvx05N69DBsQ4xqQZ/W+6ShMamGjXosvj+ntNMXpPu5TKlDemlu
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a6b:e60c:0:b0:758:b52c:ec8b with SMTP id
 g12-20020a6be60c000000b00758b52cec8bmr2589760ioh.3.1681493370852; Fri, 14 Apr
 2023 10:29:30 -0700 (PDT)
Date: Fri, 14 Apr 2023 17:29:20 +0000
In-Reply-To: <20230414172922.812640-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230414172922.812640-6-rananta@google.com>
Subject: [PATCH v3 5/7] KVM: arm64: Invalidate the table entries upon a range
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Ricardo Koller <ricarkol@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Currently, during the operations such as a hugepage collapse,
KVM would flush the entire VM's context using 'vmalls12e1is'
TLBI operation. Specifically, if the VM is faulting on many
hugepages (say after dirty-logging), it creates a performance
penalty for the guest whose pages have already been faulted
earlier as they would have to refill their TLBs again.

Instead, call __kvm_tlb_flush_vmid_range() for table entries.
If the system supports it, only the required range will be
flushed. Else, it'll fallback to the previous mechanism.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3d61bd3e591d2..b8f0dbd12f773 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -745,10 +745,13 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	 * Perform the appropriate TLB invalidation based on the evicted pte
 	 * value (if any).
 	 */
-	if (kvm_pte_table(ctx->old, ctx->level))
-		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
-	else if (kvm_pte_valid(ctx->old))
+	if (kvm_pte_table(ctx->old, ctx->level)) {
+		u64 end = ctx->addr + kvm_granule_size(ctx->level);
+
+		kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, ctx->addr, end);
+	} else if (kvm_pte_valid(ctx->old)) {
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
+	}
 
 	if (stage2_pte_is_counted(ctx->old))
 		mm_ops->put_page(ctx->ptep);
-- 
2.40.0.634.g4ca3ef3211-goog

