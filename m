Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D74233D4FD
	for <kvmarm@lists.linux.dev>; Sat, 28 Mar 2026 14:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774709724; cv=none; b=ntIAKGzF/T7TOv4DovqzuZM6+watEKPAPG9pzrGg56PPawVPgaV/npz/jQ5ViIcm0WsnuPCSnlwBPJhEsA57euuKaXb4N6XyJlob33VZiDJbpLEdpLI567dW4M04z1wbVy7Qe4BfPfb/xzI6S1vEabdXfY3J4fdoMQYXrjF0fgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774709724; c=relaxed/simple;
	bh=AYLvh7lUWIwSy3ntEJvqDbumamhIKM4p9dd0UtbiXN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLoW9EOA9e0lnkjll1jyRr5rliU56uwl4QiEAfbTlzjYPJAOZnXjZso2I34lgTmy6egkdihAHEELKcHQNMZSOx+KoQlFVIUXuHSMJdRMxJhzyYNLbpCFxXSNTROGrMxEnwGQOwFM0wKVpoSCHFtRwIdEuC02cokzJN2BamGLtWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TxoJpyNF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TxoJpyNF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5382464D;
	Sat, 28 Mar 2026 07:55:14 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5725B3FA1F;
	Sat, 28 Mar 2026 07:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774709720; bh=AYLvh7lUWIwSy3ntEJvqDbumamhIKM4p9dd0UtbiXN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxoJpyNFMkbnYoMDQ/5NIz1+TEmHMgFZPsCTSFKGTLNblbhUClxaXI32bVhKBn9se
	 hiHhwSGqXxjTDfs4T4jwGjr1tzrPGDbQF/z6R2MAJtoNkM+kLYNCcKWJcUklsDBSV8
	 HN3WsNKdj3a8atvkr6z7DIdslhhCnO6RNvUwb+Jk=
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
Subject: [PATCH 2/2] KVM: arm64: Refactor stage2 mmu tear down functions
Date: Sat, 28 Mar 2026 14:54:39 +0000
Message-ID: <20260328145439.2501562-3-weilin.chang@arm.com>
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

With NV, "stage2 mmu" becomes ambiguous, it could refer to the canonical
one or one of the nested ones. Modify kvm_uninit_stage2_mmu() so that it
can uninitialize both the canonical s2 mmu and nested s2 mmus.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 2 +-
 arch/arm64/kvm/mmu.c             | 8 +++++---
 arch/arm64/kvm/nested.c          | 4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 960b6aed4ffa..4b49aabecbf3 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -176,7 +176,7 @@ void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t e
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
-void kvm_uninit_stage2_mmu(struct kvm *kvm);
+void kvm_uninit_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
 void kvm_free_stage2(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b19b9a9b3c27..a2affd70eca6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1018,10 +1018,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return err;
 }
 
-void kvm_uninit_stage2_mmu(struct kvm *kvm)
+void kvm_uninit_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 {
-	kvm_free_stage2(&kvm->arch.mmu);
-	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
+	kvm_free_stage2(mmu);
+
+	if (!kvm_is_nested_s2_mmu(kvm, mmu))
+		kvm_mmu_free_memory_cache(&mmu->split_page_cache);
 }
 
 static void stage2_unmap_memslot(struct kvm *kvm,
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 772d922cf0ee..5eba94d6cc67 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1194,12 +1194,12 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
 		if (!WARN_ON(atomic_read(&mmu->refcnt)))
-			kvm_free_stage2(mmu);
+			kvm_uninit_stage2_mmu(kvm, mmu);
 	}
 	kvfree(kvm->arch.nested_mmus);
 	kvm->arch.nested_mmus = NULL;
 	kvm->arch.nested_mmus_size = 0;
-	kvm_uninit_stage2_mmu(kvm);
+	kvm_uninit_stage2_mmu(kvm, &kvm->arch.mmu);
 }
 
 /*
-- 
2.43.0

