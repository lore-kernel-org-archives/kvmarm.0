Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ECA46A608
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 10:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210127; cv=none; b=bNdaF6zrEpQgNhkiGnDGCaheCJift0ajXAnxD2lECxd3ngM+k7l4MJnih7m5e6jqmT0sPmF6ZlB5iEtQqaeZCM+wxdcjgGDDrgmXnDlGRT6X2JMjf5NmRCqXrVhrCnU9l4lp2bpVauvzbsUrNZwk+xShg3j037NBHotKkMpsTyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210127; c=relaxed/simple;
	bh=Y6RkSHwU4esTV7q19aDOpZFBEQ61QO7wA8wsuNTOpYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpIeYynWiR7cAZzMd0MdPTKZ4j8jLqG26s+s75ojD8dnnFkHzLBBlZp+zHMhoIZFFf8/ZiNWba4UuJQ3POQ4D4UGJAnTPaBfZpqv7Dlh+lOMTLz7RyPhe0PRM9s8Ab5tR73j6qZcp0eo/T6qPSlxAZs3MH1ZFZfli9Fg/8UeoIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPQn6Hk6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPQn6Hk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1011F00893;
	Sat, 12 Sep 2026 10:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789210121;
	bh=lqHXjcVnGTBQ1bsrr/Fc3iQEP7fL/Kd/ZHlhsq2jKSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPQn6Hk6L3XaClKSjURgEoqrzMQxg8Ho2mk3WOjlxjxGmQ59sKFnZoJSjkHUd+jz8
	 9pdsbnlYCEb10NKeAGJT4kAaYB1RyP1qhbodrWOe3gedlMiUNDtIj8JiSYM9UW8n3K
	 nCmrXQcpm7hiNFMq50vduLY1Md3rfv3s+/nQIm0ycxexwlkOh1Ui17eLmrYzT6Ya/I
	 6Dla2iiHgt0QOp5QjKRdXphpfDtMo74GR+H6gnFrLAHDGp4isH/mSRq4m+HbU/Xj/W
	 e7houfmX///x78aoEotAVDauvlgq7ENdNeuSGZ4nsW/pM3PtH4MFVHzEMwzq1b6kqA
	 V43vbULHFVyuQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x5LHj-000000084hK-3oow;
	Sat, 12 Sep 2026 10:48:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Wei-Lin Chang <weilin.chang@arm.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 2/4] KVM: arm64: MMU: Add kvm_stage2_unmap_all() helper
Date: Sat, 12 Sep 2026 11:48:32 +0100
Message-ID: <20260912104834.3093878-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912104834.3093878-1-maz@kernel.org>
References: <20260912104834.3093878-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, weilin.chang@arm.com, wanghan@linux.alibaba.com, xueshuai@linux.alibaba.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Build on top of kvm_pgtable_stage2_unmap_notlbi() to provide a primitive
tearing down a whole Stage-2 MMU and invalidating the corresponding TLBs
by VMID, which is far more efficient than performing range invalidation
(or even worse, single mappings).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h |  1 +
 arch/arm64/kvm/mmu.c             | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6eae7e7e2a684..f450557d4b7b3 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -171,6 +171,7 @@ void __init free_hyp_pgds(void);
 
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 			    u64 size, bool may_block);
+void kvm_stage2_unmap_all(struct kvm_s2_mmu *mmu, bool may_block);
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4af..68bfd09870b76 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -346,6 +346,21 @@ void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 	__unmap_stage2_range(mmu, start, size, may_block);
 }
 
+void kvm_stage2_unmap_all(struct kvm_s2_mmu *mmu, bool may_block)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+
+	if (kvm_vm_is_protected(kvm))
+		return;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	WARN_ON(stage2_apply_range(mmu, 0, kvm_phys_size(mmu),
+				   KVM_PGT_FN(kvm_pgtable_stage2_unmap_notlbi),
+				   may_block));
+
+	kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+}
+
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
 	stage2_apply_range_resched(mmu, addr, end, KVM_PGT_FN(kvm_pgtable_stage2_flush));
-- 
2.47.3

