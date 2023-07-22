Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20EC6AA9
	for <kvmarm@lists.linux.dev>; Sat, 22 Jul 2023 02:23:06 +0000 (UTC)
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-565cd3f645bso4118998eaf.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 19:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689992586; x=1690597386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t6IhHBctPmj0Hd53w4ZNc/Re4kwSrUfdnR+nipXWIaQ=;
        b=XM2WvQ2J6mE1rfTmtu+H3ixFfDqyyOigJ/cXxpZjzgxUeTEvruySCAG/rKQGRMkMXD
         07rrVwzG0IXIfadckFTDSzoIT6JBfxBjNKBOeSU/6MBVc1LmSKHsji/nuGGmGQPIKW9Z
         8e7BSL6ztWh3Jw6Z6PGETSGeZe5ZaSFMswnjP4AvGCsDJMra7BRdKmnFvYajNsuV/JMY
         bITmLvO3fa24IoVT1k5ocCvwVwzy0L2JEzDhQGC+xQG5l7KYRVRGLld5r1cQJkxXDbfN
         F/fdZbbGBuGYNfoaMNU2jMex6wIQ2ZaUo1INEFODeKlvJppQiagrfGq9lolGYB2gzo7l
         nv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689992586; x=1690597386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t6IhHBctPmj0Hd53w4ZNc/Re4kwSrUfdnR+nipXWIaQ=;
        b=PnFUeXw4lwlyCueR1MDduPd9c8qsI4obgBtT9IuO553QBAp0kr+9aNDWXrlfG6B7L2
         K4yPd5nrcpmnrTf/kANqHPujVbU5H59QNArh9z6G8aY1t6tsaBi18yCQDsNEP/SQUqHk
         V4+6/4xzWTskHZP/s7laxmQDybbgmELnXtsHRd7P+kTs0nT0A9NvYqlF10mRsrXAwWT/
         MEBkaOC/9XppKSM5GKCKzZnARZHMrJxo6An+JWfcjTNEfyeiIom8yMkbDiZ/d37UR2Vl
         ZePVf0r4uZ9LZeTvJoiZL8tyukQDdaodgk+tZmexkSHk42SBIDtjvsjeoqry/lPVr/8K
         fFmg==
X-Gm-Message-State: ABy/qLZkunCqvIGUYbW6Y9jGZEW1/TvMzCDxE9Oh+VJ2ZuDl9BQ9+k7W
	rawAgFYTkdKLAMVUMJLd9rlk1WYiLdAY
X-Google-Smtp-Source: APBJJlFmDJaT04gilXUKF4ITcHc4g3ZgKVKs4LBErP5xQ6ZXCTsrqhRw0GlVaRy9+yiIaqdevGRTlG/Ko5mu
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a4a:4fc3:0:b0:564:360c:2895 with SMTP id
 c186-20020a4a4fc3000000b00564360c2895mr5302803oob.1.1689992585914; Fri, 21
 Jul 2023 19:23:05 -0700 (PDT)
Date: Sat, 22 Jul 2023 02:22:50 +0000
In-Reply-To: <20230722022251.3446223-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722022251.3446223-12-rananta@google.com>
Subject: [PATCH v7 11/12] KVM: arm64: Invalidate the table entries upon a range
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

Currently, during the operations such as a hugepage collapse,
KVM would flush the entire VM's context using 'vmalls12e1is'
TLBI operation. Specifically, if the VM is faulting on many
hugepages (say after dirty-logging), it creates a performance
penalty for the guest whose pages have already been faulted
earlier as they would have to refill their TLBs again.

Instead, leverage kvm_tlb_flush_vmid_range() for table entries.
If the system supports it, only the required range will be
flushed. Else, it'll fallback to the previous mechanism.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5d14d5d5819a..5ef098af1736 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -806,7 +806,8 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 		 * evicted pte value (if any).
 		 */
 		if (kvm_pte_table(ctx->old, ctx->level))
-			kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+			kvm_tlb_flush_vmid_range(mmu, ctx->addr,
+						kvm_granule_size(ctx->level));
 		else if (kvm_pte_valid(ctx->old))
 			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
 				     ctx->addr, ctx->level);
-- 
2.41.0.487.g6d72f3e995-goog

