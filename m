Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5D231E85D
	for <kvmarm@lists.linux.dev>; Sat, 28 Mar 2026 14:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774709716; cv=none; b=mGEg4xtHq99a8syTY47w2+R3ObNQ/7SEee6cH4IYd+ZCwRh36d3xB2z5wcYICbr4twbogG2gzEgBaRNye2VnmsdWdrlaaQGNyGy6f3n/V0XlZPXuyk/q2mKGA0XfA+4f22+f6+N90+4wrMk2OOph2w8+n31ufKQvXNgk8qEQ7pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774709716; c=relaxed/simple;
	bh=WiaT6yqhX7+O5GUFv1mPhJKhjKsn3CHDlnrK3rSI1jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDZvtwIFWULuHZd8ReYURjNgOkYutkOY2RywJiGrPJRqE7qBUeA5nU0gfUDs3H5ESCFSHhBcFPWvFC+X31zEEFBaXGkr9+nmBU8Ew3dn8Ymv3Lg90NVOssTvLYxF9f2f7GCvtXEsDpzSrgK3ZYaWgN7pA4M7j5d92oNxkyDCblA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b1HZkWkx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b1HZkWkx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 983954649;
	Sat, 28 Mar 2026 07:55:08 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AF383F905;
	Sat, 28 Mar 2026 07:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774709714; bh=WiaT6yqhX7+O5GUFv1mPhJKhjKsn3CHDlnrK3rSI1jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1HZkWkxfqqsJc8uQT/Szy40g32f/TZ/Of6P21T3Ww0Dd2z7OP0VNST0WxSacZdr8
	 9jRXVOgd6r+pr5N5UC4r/HnfLJ1MV3PgIxj/EkpD3EI2GXG3GHKBOGJP/r8Wcavicd
	 m40RRqy2nJ+d6MNIWYyzZk9SMdbSTmRrv1Ac32Ck=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 1/2] KVM: arm64: Rename kvm_free_stage2_pgd()
Date: Sat, 28 Mar 2026 14:54:38 +0000
Message-ID: <20260328145439.2501562-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260328145439.2501562-1-weilin.chang@arm.com>
References: <20260328145439.2501562-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_free_stage2_pgd() reads like it is only freeing the top level page
tables (pgd), but it frees every level in kvm_stage2_destroy().

Rename it to kvm_free_stage2() instead.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 2 +-
 arch/arm64/kvm/mmu.c             | 4 ++--
 arch/arm64/kvm/nested.c          | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 01e9c72d6aa7..960b6aed4ffa 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -177,7 +177,7 @@ void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t e
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
 void kvm_uninit_stage2_mmu(struct kvm *kvm);
-void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
+void kvm_free_stage2(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 17d64a1e11e5..b19b9a9b3c27 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1020,7 +1020,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 void kvm_uninit_stage2_mmu(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_free_stage2(&kvm->arch.mmu);
 	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 }
 
@@ -1094,7 +1094,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
+void kvm_free_stage2(struct kvm_s2_mmu *mmu)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 883b6c1008fb..772d922cf0ee 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -110,7 +110,7 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 
 	if (ret) {
 		for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
-			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
+			kvm_free_stage2(&kvm->arch.nested_mmus[i]);
 
 		free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 		vcpu->arch.ctxt.vncr_array = NULL;
@@ -1194,7 +1194,7 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
 		if (!WARN_ON(atomic_read(&mmu->refcnt)))
-			kvm_free_stage2_pgd(mmu);
+			kvm_free_stage2(mmu);
 	}
 	kvfree(kvm->arch.nested_mmus);
 	kvm->arch.nested_mmus = NULL;
-- 
2.43.0

