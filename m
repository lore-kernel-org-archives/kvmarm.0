Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.68
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695667;
	b=MKM2gf69jfI+Isj/W2JNG+lHIkFO5ZbbywkFJjgvkeWC7dWf489eEMrbSgib4MWz+0Rb
	 +dzNf46jjGrEREM/A1yy2enkrWgtsMIvpTjvTU9pbvhj+393MoQqU55YAdh8X1JFSb+9x
	 YzMkIBicejy9ws7+4WfvD/yVtIqB4igjlsZtNenmXx9cS8g89FSAZBJfJHtyrpzKrOvlt
	 3LC3vyJIMQBnU42NEaAZZem0TZykoSfKGOM14JMgoQCzgMY8SUVkRWVGN+KWur8xreTnn
	 SNgL0rsPdYxfMeIQj2oAf4I3mHSpjpc3YBJPFM/ImhbXbsHRef+FHZ3ivqccw9+DmxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695667;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wgbqMxG+rMSoSEghwC8Ab1bjmOfWy1U7IH8igckfst0=;
	b=5bQ0I+6qRWJhfVuB7NwambPcHkWofO5Lsh8ebbWce6Hl3aP4bxNq9/CpUH8zHzMaVRVk
	 uCNOmrPPY9tvZ4YROkNEU2t0e+Gtd0+ThjcKQW3knjWoHGDXScQSZnPypWiItJIro92MI
	 xuXeT4y6ETCwWysiIZX2AUlfFIU5exC/pm2+kvDk3mfEnRkhM1Dp6M3RRaOY26KVbp+/g
	 GFXRJk7r/KVzdoeSc35dnyLLyvCjO9+64Vn7ZrxXXInhzUk+Ys2oedwY306fCfsKXOPYa
	 FnG0nbHx807HEmQOYDY/xYR7Y6RNBWt/nldMBPWFwzcVcYJkPOWmIEfmrQFQYmaLUAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LFAgAyuT;
	arc=none smtp.remote-ip=91.218.175.68
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ED2606A96B
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 08:47:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65ED2606A96B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LFAgAyuT
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=wk8krk/WXEgB1deJlYK3BeClqHTd5FTckwLdnXhB1Ik=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793695664; v=1; x=1794300464;
 b=LFAgAyuTgd/RSNGMFRU6qPs2/rSl9fS1OsnEtXMEewVzTod0YQ1gJNECV9IzMEp/mV2IpARu
 9ho6aIWx4q0MA81MiXb+fvHAB69OqTD3SU6twxzUEeIxTLnr/oYgpLRtJ8/AxluETx/K98iwLX6
 IxsKnyUNGKQfr1h/rn7q9gkE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e56060b775514378;
	Tue, 03 Nov 2026 08:47:44 +0000
X-Mizu-Trace-ID: e56060b775514378
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 3/3] KVM: arm64: Move stage-2 teardown into kvm_vm_s2_ops
Date: Tue,  3 Nov 2026 08:47:42 +0000
Message-ID: <20261103084742.1302597-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103084742.1302597-1-fuad.tabba@linux.dev>
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kvm_stage2_destroy()'s is_protected_kvm_enabled() and
KVM_PGT_FN() dispatch with a vm_stage2_destroy hook in kvm_vm_s2_ops,
like the other stage-2 operations. Both pKVM flavors share
pkvm_stage2_destroy(). Like kvm_vm_stage2_destroy(), it takes the range
from kvm_phys_size().

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/mmu.c              | 24 +++++++++++++-----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 97332ffcb1300..b36779bafae9b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -233,6 +233,7 @@ struct kvm_vcpu_ops {
 
 struct kvm_gfn_range;
 struct kvm_s2_fault_desc;
+struct kvm_pgtable;
 
 struct kvm_vm_s2_ops {
 	bool (*vm_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
@@ -243,6 +244,7 @@ struct kvm_vm_s2_ops {
 	void (*vm_stage2_unmap_range)(struct kvm_s2_mmu *mmu,
 				      phys_addr_t start, u64 size,
 				      bool may_block);
+	void (*vm_stage2_destroy)(struct kvm_pgtable *pgt);
 	int (*vm_mem_abort)(const struct kvm_s2_fault_desc *s2fd);
 };
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 10b425a0141be..9df3c80a5acd1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1029,17 +1029,16 @@ static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
 	} while (addr = next, addr != end);
 }
 
-static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
+static void kvm_vm_stage2_destroy(struct kvm_pgtable *pgt)
 {
-	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
+	stage2_destroy_range(pgt, 0, kvm_phys_size(pgt->mmu));
+	kvm_pgtable_stage2_destroy_pgd(pgt);
+}
 
-	/* pKVM walks its mapping tree, not the IPA space, and reschedules per mapping */
-	if (is_protected_kvm_enabled())
-		pkvm_pgtable_stage2_destroy_range(pgt, 0, BIT(ia_bits));
-	else
-		stage2_destroy_range(pgt, 0, BIT(ia_bits));
-
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
+static void pkvm_stage2_destroy(struct kvm_pgtable *pgt)
+{
+	pkvm_pgtable_stage2_destroy_range(pgt, 0, kvm_phys_size(pgt->mmu));
+	pkvm_pgtable_stage2_destroy_pgd(pgt);
 }
 
 /**
@@ -1126,7 +1125,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return 0;
 
 out_destroy_pgtable:
-	kvm_stage2_destroy(pgt);
+	kvm->arch.vm_s2_ops->vm_stage2_destroy(pgt);
 	mmu->pgt = NULL;
 out_free_pgtable:
 	kfree(pgt);
@@ -1246,7 +1245,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
-		kvm_stage2_destroy(pgt);
+		kvm->arch.vm_s2_ops->vm_stage2_destroy(pgt);
 		kfree(pgt);
 	}
 
@@ -3152,6 +3151,7 @@ static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
 	.vm_age_gfn			= no_age_gfn,
 	.vm_test_age_gfn		= no_age_gfn,
 	.vm_stage2_unmap_range		= no_stage2_unmap_range,
+	.vm_stage2_destroy		= pkvm_stage2_destroy,
 	.vm_mem_abort			= protected_pkvm_mem_abort,
 };
 
@@ -3161,6 +3161,7 @@ static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
 	.vm_age_gfn			= pkvm_age_gfn,
 	.vm_test_age_gfn		= pkvm_test_age_gfn,
 	.vm_stage2_unmap_range		= pkvm_stage2_unmap_range,
+	.vm_stage2_destroy		= pkvm_stage2_destroy,
 	.vm_mem_abort			= kvm_vm_mem_abort,
 };
 
@@ -3170,6 +3171,7 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
 	.vm_age_gfn			= kvm_vm_age_gfn,
 	.vm_test_age_gfn		= kvm_vm_test_age_gfn,
 	.vm_stage2_unmap_range		= kvm_vm_stage2_unmap_range,
+	.vm_stage2_destroy		= kvm_vm_stage2_destroy,
 	.vm_mem_abort			= kvm_vm_mem_abort,
 };
 
-- 
2.47.3

