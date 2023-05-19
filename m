Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3897385
	for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 00:52:41 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ba2526a8918so4882116276.1
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 17:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684457561; x=1687049561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e6DsOoIF+x/A7ZYSTdRHf2cD4dqAihxaeRbkm/Wf8QE=;
        b=5jParhefjh0HI3DzorDBwf9sb8RHRycHwmfDukeUSFn84zbi/9wRDfQaKoBx20Z2pS
         jgAJQ4ttTjCt4O4bkCtGffdz6NOopVPRPNoSjGutVL/MA59xkj/2i64IMZ4xsfb5JZvo
         kQknAlNduF12wnSsQxHbve4iQrVfw5KgPyNjRsYycjJCm6HjknBcGXCHSIYIS5n8fG/P
         xg/hoe/5+I5sWP+59TvQr8H21v4IS7jO4EfQnXFGK7qjua8eIK0OYqkQwb0pnsQqec5q
         4KabcCQrLkUiQ1gkV268Wti7RamOnI6hXcNQ2d3KXg8+bwW6KOn9g17yKdwKwZ3kjqrY
         RESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684457561; x=1687049561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e6DsOoIF+x/A7ZYSTdRHf2cD4dqAihxaeRbkm/Wf8QE=;
        b=EhX01H57dqo4IlQ0r3mz8jdLwELgiUxC9dyLr4jQnIlqmJvZvUszvV0ZNVBmt05uB4
         tR8cRzzd1YUYjExv4s+I++Oru9U260BVld7Rv3Z5jRoaAlljfMEhIPRNVi14tvu5WwRY
         4jHp6qJBofy6DRybdiq50Wnr11KE7ZzFQQrbVlIjFRGBhdVdgCvf2Rus58s7pZW3XLey
         T8pyYJrGlGlOIU1uzEcdI5AWMvjG1Ajjtm3Zi6Es6ofecxQVmpJclfpi/QseFLLg1nMc
         7k9GCEJqRyp4Fx0NPdyFn3ltInTRpkQ3VO0UE7Cct42JVzY/oHOpFL8FPOsz9N+JuliD
         OuVA==
X-Gm-Message-State: AC+VfDys0zByCoeVSqc2QRHVpwkGG7/SjGS4415kzUVCTsvCMI0jTu1u
	c9QFLrPyqOdFhC6ZRavHBNeCK/R52gaa
X-Google-Smtp-Source: ACHHUZ4Lgs2jxcq+llYDlHCAR5udROfxgqvoQbhs56Qn9JKtSHbYquhrdkyDxuf1xI7e7oDzhrf6uwFOdXpl
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:b906:0:b0:ba8:9096:df50 with SMTP id
 x6-20020a25b906000000b00ba89096df50mr26549ybj.9.1684457560955; Thu, 18 May
 2023 17:52:40 -0700 (PDT)
Date: Fri, 19 May 2023 00:52:30 +0000
In-Reply-To: <20230519005231.3027912-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519005231.3027912-6-rananta@google.com>
Subject: [PATCH v4 5/6] KVM: arm64: Invalidate the table entries upon a range
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
2.40.1.698.g37aff9b760-goog

