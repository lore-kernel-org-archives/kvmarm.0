Received: from out-161.mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC9F110C
	for <kvmarm@lists.linux.dev>; Fri,  2 Dec 2022 18:57:49 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670007134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HSI8GaEsrat3YCFbYitHgJjBxasqUXZCSku/OSEtqlI=;
	b=rn85i92GvmxIPofIBwzmf1lgVTJuWw0qPq1mAfrFEoJGvXJqdyrlRYn1kHDeuX+rlP4Vx/
	tmJ5gmeMa66ZXMnADmpVdaE5YinkQjY/RVPLx5K/leof84T2RL7O+6UkRik8oNep32Mcye
	z1yTKtG3yErw1oBHC6vUD1maCGLrZ00=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] KVM: arm64: Use KVM's pte type/helpers in handle_access_fault()
Date: Fri,  2 Dec 2022 18:51:51 +0000
Message-ID: <20221202185156.696189-2-oliver.upton@linux.dev>
In-Reply-To: <20221202185156.696189-1-oliver.upton@linux.dev>
References: <20221202185156.696189-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221202185151.7NrPCz6QLOVKGJhOHdlBoGIQyFMwhxmQYZNhaKwHQmQ@z>

Consistently use KVM's own pte types and helpers in
handle_access_fault().

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
 arch/arm64/kvm/mmu.c                 | 10 ++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 63f81b27a4e3..192f33b88dc1 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -71,6 +71,11 @@ static inline kvm_pte_t kvm_phys_to_pte(u64 pa)
 	return pte;
 }
 
+static inline kvm_pfn_t kvm_pte_to_pfn(kvm_pte_t pte)
+{
+	return __phys_to_pfn(kvm_pte_to_phys(pte));
+}
+
 static inline u64 kvm_granule_shift(u32 level)
 {
 	/* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a3c71b5172cd..886ad5ee767a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1399,20 +1399,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
-	pte_t pte;
-	kvm_pte_t kpte;
+	kvm_pte_t pte;
 	struct kvm_s2_mmu *mmu;
 
 	trace_kvm_access_fault(fault_ipa);
 
 	write_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
-	kpte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
+	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
 	write_unlock(&vcpu->kvm->mmu_lock);
 
-	pte = __pte(kpte);
-	if (pte_valid(pte))
-		kvm_set_pfn_accessed(pte_pfn(pte));
+	if (kvm_pte_valid(pte))
+		kvm_set_pfn_accessed(kvm_pte_to_pfn(pte));
 }
 
 /**
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

