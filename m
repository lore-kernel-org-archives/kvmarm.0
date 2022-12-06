Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A0C08485
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 14:00:12 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC13E1424;
	Tue,  6 Dec 2022 06:00:18 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.159])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 637E93F73D;
	Tue,  6 Dec 2022 06:00:10 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 05/12] KVM: arm64: Maintain page-table format info in struct kvm_pgtable
Date: Tue,  6 Dec 2022 13:59:23 +0000
Message-ID: <20221206135930.3277585-6-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221206135930.3277585-1-ryan.roberts@arm.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221206135923.2VIvDp17MQ0Es3n88PgRX4nmDTFOc_x9Vfq4dSqDYJ0@z>

As the next step on the journey to supporting FEAT_LPA2 in KVM, add a
flag to struct kvm_pgtable, which functions can then use to select the
approprate behavior for either the `classic` or `lpa2` page-table
formats. For now, all page-tables remain in the `classic` format.

No functional changes are intended.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 2 ++
 arch/arm64/kvm/mmu.c                 | 1 +
 3 files changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2247ed74871a..744e224d964b 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -157,6 +157,7 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  * @start_level:	Level at which the page-table walk starts.
  * @pgd:		Pointer to the first top-level entry of the page-table.
  * @mm_ops:		Memory management callbacks.
+ * @lpa2_ena:		Format used for page-table; false->classic, true->lpa2.
  * @mmu:		Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
  * @flags:		Stage-2 page-table flags.
  * @force_pte_cb:	Function that returns true if page level mappings must
@@ -167,6 +168,7 @@ struct kvm_pgtable {
 	u32					start_level;
 	kvm_pte_t				*pgd;
 	struct kvm_pgtable_mm_ops		*mm_ops;
+	bool					lpa2_ena;
 
 	/* Stage-2 only */
 	struct kvm_s2_mmu			*mmu;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 221e0dafb149..c7799cd50af8 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -530,6 +530,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 	pgt->ia_bits		= va_bits;
 	pgt->start_level	= KVM_PGTABLE_MAX_LEVELS - levels;
 	pgt->mm_ops		= mm_ops;
+	pgt->lpa2_ena		= false;
 	pgt->mmu		= NULL;
 	pgt->force_pte_cb	= NULL;
 
@@ -1190,6 +1191,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	pgt->ia_bits		= ia_bits;
 	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
+	pgt->lpa2_ena		= false;
 	pgt->mmu		= mmu;
 	pgt->flags		= flags;
 	pgt->force_pte_cb	= force_pte_cb;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1ef0704420d9..e3fe3e194fd1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -645,6 +645,7 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
 				   CONFIG_PGTABLE_LEVELS),
 		.mm_ops		= &kvm_user_mm_ops,
+		.lpa2_ena	= lpa2_is_enabled(),
 	};
 	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
 	u32 level = ~0;
-- 
2.25.1

