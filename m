Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B745C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 18:52:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 209574A0D8;
	Fri,  2 Dec 2022 13:52:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j3lXgLbmN4J8; Fri,  2 Dec 2022 13:52:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 951B04B282;
	Fri,  2 Dec 2022 13:52:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABC364A0D8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 13:52:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MCQhS9EXYCnQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 13:52:15 -0500 (EST)
Received: from out-235.mta0.migadu.com (out-235.mta0.migadu.com
 [91.218.175.235])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6254240EB6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 13:52:15 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
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
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v2 1/6] KVM: arm64: Use KVM's pte type/helpers in
 handle_access_fault()
Date: Fri,  2 Dec 2022 18:51:51 +0000
Message-Id: <20221202185156.696189-2-oliver.upton@linux.dev>
In-Reply-To: <20221202185156.696189-1-oliver.upton@linux.dev>
References: <20221202185156.696189-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
