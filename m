Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25229A923
	for <kvmarm@lists.linux.dev>; Thu,  9 Feb 2023 17:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDA5C433EF;
	Thu,  9 Feb 2023 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675965527;
	bh=r49zp+dn08PoQrKCNbLc4PnieVVwSCiFAzzhPsgCeCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pn6uUrZumnrFuZnsK7uy5ZMaPywUoQUlS42kNXY1Dt66ehcTf1veEtmhqCosGRxlr
	 kwhFMtBNqUjHM/SUh4ZbzG6S+IgA8D2c2PsNVyVC8z+/U6VIAD2d2iRLMCr5QbnXbC
	 kIkvj34bwpRzjE2HItZ5utyfQo9GLpYZs7DzMEswftzaZu8kou+UjFhHkiHx/jAoWF
	 Le0FO0QMOnAaD8ZFUBkz4kZW2iF1DATGK80iUmK4uAuZaj2t2TjRhIKXjxLwtPgFsq
	 Prqe59n6IYu6agmFWHAqSx9E0d9tPh/Sk5A45HO9ouIgjwVFSUIBfv8rusupR5D9W5
	 W/qQ9rvtZSBKg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pQBC2-0093r7-1D;
	Thu, 09 Feb 2023 17:58:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 02/18] KVM: arm64: Use the S2 MMU context to iterate over S2 table
Date: Thu,  9 Feb 2023 17:58:04 +0000
Message-Id: <20230209175820.1939006-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Most of our S2 helpers take a kvm_s2_mmu pointer, but quickly
revert back to using the kvm structure. By doing so, we lose
track of which S2 MMU context we were initially using, and fallback
to the "canonical" context.

If we were trying to unmap a S2 context managed by a guest hypervisor,
we end-up parsing the wrong set of page tables, and bad stuff happens
(as this is often happening on the back of a trapped TLBI from the
guest hypervisor).

Instead, make sure we always use the provided MMU context all the way.
This has no impact on non-NV, as we always pass the canonical MMU
context.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a3ee3b605c9b..892d6a5fb2f5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -46,16 +46,17 @@ static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
  * long will also starve other vCPUs. We have to also make sure that the page
  * tables are not freed while we released the lock.
  */
-static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
+static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
 			      phys_addr_t end,
 			      int (*fn)(struct kvm_pgtable *, u64, u64),
 			      bool resched)
 {
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	int ret;
 	u64 next;
 
 	do {
-		struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+		struct kvm_pgtable *pgt = mmu->pgt;
 		if (!pgt)
 			return -EINVAL;
 
@@ -71,8 +72,8 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
 	return ret;
 }
 
-#define stage2_apply_range_resched(kvm, addr, end, fn)			\
-	stage2_apply_range(kvm, addr, end, fn, true)
+#define stage2_apply_range_resched(mmu, addr, end, fn)			\
+	stage2_apply_range(mmu, addr, end, fn, true)
 
 static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 {
@@ -235,7 +236,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
-	WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
+	WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
 				   may_block));
 }
 
@@ -250,7 +251,7 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
 
-	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_flush);
+	stage2_apply_range_resched(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_flush);
 }
 
 /**
@@ -934,8 +935,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
  */
 static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
-	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
-	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_wrprotect);
+	stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_wrprotect);
 }
 
 /**
-- 
2.34.1

