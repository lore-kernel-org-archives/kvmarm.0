Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5E8125CC
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 19:29:09 +0000 (UTC)
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-7775a282e25so448941739f.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 12:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686079748; x=1688671748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mSh72g4ZHJDv4/8vl2ojF6XiepiDvTufhm8MWFlXvRw=;
        b=DgqodgA0VlUZWQrMG4GP7C/weUqyJOTcJeeBU+QJtyx73nrL97iFH09J3NN1a3ZqZp
         HnGGp8mag6nk53M7ixB65x5AD6Ms56KjI1ef3YbrAECkzd/sBiP49ZaRawRDGSG6W/48
         zpTIZ9xiNUakwan9Sah7O3FQZq8hbYO+vJYMpPhkX+vPtaFLwYWWIJatBbkiuWPko3KK
         xLOP8K2IyKlFQWL5H/yaFnL404Xk/QQOl56Czr3QPqSe5ks+kz2URjUEHgddpbJaiPlb
         GYXlIgD7DvVtN5XvZx5Rt/1wo3vRwOLcLfUaazlKhmWPNVBuGWB5FFLS01Y/RwmF7Ac/
         NxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686079748; x=1688671748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mSh72g4ZHJDv4/8vl2ojF6XiepiDvTufhm8MWFlXvRw=;
        b=UZuSDiO4rH0JfVaR9YtaM+q3BiN9WJLJ5itnn68aW0fAsL9lIshRsOErpW3qJcEvxx
         vbOhEytscbV/6QJk3tsGYg3pXgwunbLXX4EumicL+eIjPf6Q/1S2Y0JJodls95KYKYSk
         ROj0mgugNeyUzgXS3jRRO/1xeVKmGMK72+kmYXXX58twbmtpC9/OWH5s4gRmr2SxIDgG
         HIora13eRNh3Azg/EP4Rwu/YTpcUUOhMme9fteQ3qZudvHaIjF0cpES+77iTDCSppezk
         FnAB53fP7a5C7UPmb1OC7q4S35EkjCm8W6HKTeyHJtqa7X6sH4BVf582mdlNxpQ1oxDK
         WZMw==
X-Gm-Message-State: AC+VfDy5QOpQpMJV77jkVzs+pjWJGJQ5VGlZs1vWizfeO57uuUh75W76
	1wOsCMfLs6NJHt3EPQeZ1vETjR+YavGr
X-Google-Smtp-Source: ACHHUZ7CbVG1v9+02j/lP6GitPjQFKqy8MFcVF4f6QKfj749lOkIhDCulQsPILWvgJRfRfbdJbdIHNk5CYhj
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:85e6:0:b0:416:7e77:bb5f with SMTP id
 d93-20020a0285e6000000b004167e77bb5fmr1392579jai.0.1686079748520; Tue, 06 Jun
 2023 12:29:08 -0700 (PDT)
Date: Tue,  6 Jun 2023 19:28:57 +0000
In-Reply-To: <20230606192858.3600174-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230606192858.3600174-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606192858.3600174-7-rananta@google.com>
Subject: [PATCH v5 6/7] KVM: arm64: Invalidate the table entries upon a range
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index df8ac14d9d3d4..50ef7623c54db 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -766,7 +766,8 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	 * value (if any).
 	 */
 	if (kvm_pte_table(ctx->old, ctx->level))
-		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+		kvm_tlb_flush_vmid_range(mmu, ctx->addr,
+					kvm_granule_size(ctx->level));
 	else if (kvm_pte_valid(ctx->old))
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

