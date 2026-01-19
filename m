Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20242FF66A
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768820217; cv=none; b=L7wHglMTRTEO//n/+nrgh82iSseZ3kg+TwKVoJQNIDYv/7K0WJUDhEInI+kvMRuAAPr+/ALmxN5IBEm0fdNSAeVFGhRR5esYzErDolfEpfFiH2RowYLemNaF8g9XttP7xqSh+DkALO5yzyIsPiYNaRD6KKUJg/WK2syjx0qMENY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768820217; c=relaxed/simple;
	bh=6Rc/EPRN8QwqVJ8wI+PIZHJXX/E5p4bCZQ/EQLewt1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP5uJnlAvcL2GLHZg0vnDiYo3smVhDh9Umqr3dPM8FLhcFSHE8EqrOSTcE6G9bLTv5ZfJ6ksx2HuOkoi2/cIcu/4sKCbBAp7yri5AugvzU9PD03twjf0+gNrUOFpgsE/1uXpQsKHnozWoWlJ6pZnSlP9qQv9kSpUP7CQwbJmhn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQf6LQQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQf6LQQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4987C116C6;
	Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768820217;
	bh=6Rc/EPRN8QwqVJ8wI+PIZHJXX/E5p4bCZQ/EQLewt1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQf6LQQLaH9Gl1wOUT9xouTaeXbzRJr9FHhuFl6A53fXnldlqv4e+SUibkes+bIJc
	 t1DdueONzcA16h/TX1F2X5HWLO2J0ZxYaec0FkwSzsJdyXNozGrjP9Ag/OFBxafz4o
	 mns0xHuXa7waNR74my852EK0RqWj9Ybd9i/QEu68wJqbXf4jzTRinlpdAkD+bvaJlz
	 8atrTJmQmnHk/ABDOJm7KSrQ5IZ4IS7C5IpRORdAN+/lq1tec/LIOAzg6+/fqpvCIw
	 gwK45cdndTGIvh0cDRpGsM63bcarFIudHm7hAPS7UB0ITBfoCxAAsnbFJVa+2k39Ea
	 YLh0MYk/gNTCg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vhmwJ-00000003YVK-3Vi1;
	Mon, 19 Jan 2026 10:56:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 5/6] KVM: arm64: Kill KVM_PGTABLE_S2_NOFWB
Date: Mon, 19 Jan 2026 10:56:50 +0000
Message-ID: <20260119105651.255693-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119105651.255693-1-maz@kernel.org>
References: <20260119105651.255693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Nobody is using this flag anymore, so remove it. This allows
some cleanup for stage2_has_fwb(), whic doesn't need to take the
pgt as a parameter anymore.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h |  7 ++-----
 arch/arm64/kvm/hyp/pgtable.c         | 17 +++++++----------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 9ce51a637da0a..2198b62428832 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -229,15 +229,12 @@ struct kvm_pgtable_mm_ops {
 
 /**
  * enum kvm_pgtable_stage2_flags - Stage-2 page-table flags.
- * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
- *				ARM64_HAS_STAGE2_FWB.
  * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
  * @KVM_PGTABLE_S2_AS_S1:	Final memory attributes are that of Stage-1.
  */
 enum kvm_pgtable_stage2_flags {
-	KVM_PGTABLE_S2_NOFWB			= BIT(0),
-	KVM_PGTABLE_S2_IDMAP			= BIT(1),
-	KVM_PGTABLE_S2_AS_S1			= BIT(2),
+	KVM_PGTABLE_S2_IDMAP			= BIT(0),
+	KVM_PGTABLE_S2_AS_S1			= BIT(1),
 };
 
 /**
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 07561a227f75e..3c2f7967fdc03 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -631,12 +631,9 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	return vtcr;
 }
 
-static bool stage2_has_fwb(struct kvm_pgtable *pgt)
+static bool stage2_has_fwb(void)
 {
-	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
-		return false;
-
-	return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
+	return cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);
 }
 
 void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
@@ -664,10 +661,10 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 		kvm_pte_t __attr;					\
 		if((pgt)->flags & KVM_PGTABLE_S2_AS_S1)			\
 			__attr = PAGE_S2_MEMATTR(AS_S1,			\
-						 stage2_has_fwb(pgt));	\
+						 stage2_has_fwb());	\
 		else							\
 			__attr = PAGE_S2_MEMATTR(attr,			\
-						 stage2_has_fwb(pgt));	\
+						 stage2_has_fwb());	\
 									\
 		__attr;							\
 	})
@@ -879,7 +876,7 @@ static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
 	 * system supporting FWB as the optimization is entirely
 	 * pointless when the unmap walker needs to perform CMOs.
 	 */
-	return system_supports_tlb_range() && stage2_has_fwb(pgt);
+	return system_supports_tlb_range() && stage2_has_fwb();
 }
 
 static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
@@ -1167,7 +1164,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 		if (mm_ops->page_count(childp) != 1)
 			return 0;
 	} else if (stage2_pte_cacheable(pgt, ctx->old)) {
-		need_flush = !stage2_has_fwb(pgt);
+		need_flush = !stage2_has_fwb();
 	}
 
 	/*
@@ -1397,7 +1394,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 		.arg	= pgt,
 	};
 
-	if (stage2_has_fwb(pgt))
+	if (stage2_has_fwb())
 		return 0;
 
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
-- 
2.47.3

