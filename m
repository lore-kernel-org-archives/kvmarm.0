Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C5E38886F
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782224737; cv=none; b=SE2JoQ3jKKWRnK1A55DUbZ5MF8ID4OOFBx8x/iCQ93R87KKFuAiP9/oWMOsXEjq0XQDf2JTPGh5YAq+OIftqsEkAqjj6ILnQ1wdZC2oopYtf1uvtBPk3yLaEtZ7k9p8JKjB1m8qzutlihxTV+Bkbyv+myeFHeSaHQzlMxVDAm+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782224737; c=relaxed/simple;
	bh=UVDBB/PFZ+rCc87A5TGXQBbpqJel6EHhTHznacF/Mlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seTMWj1CV6GZSOiNRT+q+JxhSTuPC/NQnb4TglNUgGg+ldDlx4QdGnqcccXDehan5H7m8IkGjMDvbvqWLBkey7r6h+Xh+SS135n1VlYsal1kEclTKGpSJ/pqSdEokqmqLbfzmMEaYRcoo2ya1VJl7eFMoHz8c8vS2a1m/ghcPQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XR7Vk+/j; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XR7Vk+/j"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C72B72944;
	Tue, 23 Jun 2026 07:25:30 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80A613F632;
	Tue, 23 Jun 2026 07:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782224735; bh=UVDBB/PFZ+rCc87A5TGXQBbpqJel6EHhTHznacF/Mlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XR7Vk+/jaRs57jaTsA5HJYUNSnm30eHxNENAKEOuJz5zzvNClDqOXcoxJzWNYcTID
	 fmJwJ6HfJfJ4SJgbqGLbllC+FeO52BTK8VoBCVoRaNhyWsLmMZ34jFlHtf0XHzSoZy
	 SEiPB2P8Q6D1157qE4WCyB56Yd6Mm5VBi+rX/yO4=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 3/3] KVM: arm64: nv: Move to per nested mmu ptdump files
Date: Tue, 23 Jun 2026 15:24:43 +0100
Message-ID: <20260623142443.648972-4-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623142443.648972-1-weilin.chang@arm.com>
References: <20260623142443.648972-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous way of exposing shadow page tables was creating a debugfs
ptdump file whenever a nested mmu instance gets bound to a new context,
and deleting the debugfs file whose context was getting unbound.

This turned out to be buggy, as the instance<->context binding process
is done with the mmu_lock held, and debugfs creation/deletion can sleep.

Instead, create a debugfs file for each nested mmu instance, and show
different information based on what the nested mmu instance is holding
at the moment, which can be either invalid, or VTCR + VTTBR + whether s2
enabled + ptdump.

Fixes: 19e15dc73f0f ("KVM: arm64: nv: Expose shadow page tables in debugfs")
Reported-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Closes: https://lore.kernel.org/kvmarm/aiuF0KSvvv-ZozI1@sm-arm-grace07/
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/nested.c | 16 +++++++++++-----
 arch/arm64/kvm/ptdump.c |  9 +++------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index bdf12b2ae097..2aaf6c123a20 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -110,6 +110,11 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 
 		write_unlock(&kvm->mmu_lock);
 
+		for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
+			kvm_nested_s2_ptdump_remove_debugfs(&tmp[i]);
+			kvm_nested_s2_ptdump_create_debugfs(&kvm->arch.nested_mmus[i]);
+		}
+
 		kvfree(tmp);
 	}
 
@@ -126,6 +131,9 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 		return ret;
 	}
 
+	for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
+		kvm_nested_s2_ptdump_create_debugfs(&kvm->arch.nested_mmus[i]);
+
 	kvm->arch.nested_mmus_size = num_mmus;
 
 	return 0;
@@ -817,10 +825,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
 
 	/* Make sure we don't forget to do the laundry */
-	if (kvm_s2_mmu_valid(s2_mmu)) {
-		kvm_nested_s2_ptdump_remove_debugfs(s2_mmu);
+	if (kvm_s2_mmu_valid(s2_mmu))
 		s2_mmu->pending_unmap = true;
-	}
 
 	/*
 	 * The virtual VMID (modulo CnP) will be used as a key when matching
@@ -834,8 +840,6 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	s2_mmu->tlb_vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
 	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM;
 
-	kvm_nested_s2_ptdump_create_debugfs(s2_mmu);
-
 out:
 	atomic_inc(&s2_mmu->refcnt);
 
@@ -1275,6 +1279,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
+		kvm_nested_s2_ptdump_remove_debugfs(mmu);
+
 		if (!WARN_ON(atomic_read(&mmu->refcnt)))
 			kvm_free_stage2_pgd(mmu);
 	}
diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index a089e87ea366..2a1cbef2375b 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -17,7 +17,7 @@
 
 #define MARKERS_LEN		2
 #define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
-#define S2FNAMESZ		sizeof("0x0123456789abcdef-0x0123456789abcdef-s2-disabled")
+#define S2FNAMESZ		sizeof("nested_mmu_9999")
 
 /*
  * Nested mmus could be freed when .release() is called, so also keep the kvm
@@ -287,14 +287,11 @@ static const struct file_operations kvm_pgtable_levels_fops = {
 
 void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu)
 {
+	int idx = mmu - mmu->arch->nested_mmus;
 	struct dentry *dent;
 	char file_name[S2FNAMESZ];
 
-	snprintf(file_name, sizeof(file_name), "0x%016llx-0x%016llx-s2-%sabled",
-		 mmu->tlb_vttbr,
-		 mmu->tlb_vtcr,
-		 mmu->nested_stage2_enabled ? "en" : "dis");
-
+	snprintf(file_name, sizeof(file_name), "nested_mmu_%d", idx);
 	dent = debugfs_create_file(file_name, 0400,
 				   mmu->arch->debugfs_nv_dentry, mmu,
 				   &kvm_ptdump_guest_fops);
-- 
2.43.0

