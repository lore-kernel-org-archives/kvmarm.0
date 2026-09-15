Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016843B05BD;
	Tue, 15 Sep 2026 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488154; cv=none; b=jGTrVdM6YZl5X4jH5AUHCJthzuBNth0c71OCmrg9fmRbUAmAlyoDTskk2dfTkpyK11+U1bjJoxbZT+d/CB7IYcyhJ4xXKqb63lNFh1HMFbs2GrGfbnTcXqroTj713ao5U+kqQ015FF/FLigfu/qqwj6xbCNJfOW0QuEJQGq9p3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488154; c=relaxed/simple;
	bh=j4bM4Le2AKal5yA6XAi5DmpI3S/KrZ5K/Wzmf15T0ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9p1llSpbf0ZeeyoBE45dPsUdJ9wyklfIe62EMEL/jIZMpxxikX0lBOgKG/IPjTxGEYnZnkSp+sjNCVfty9/bbkEiBGzYqf5T6bXq0boCOF/yg9asS3tVULxlcV8YGUo8FALiioER79s3dxuSoxnmDhJ9wfPAdMxMlfFJOZmYHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ClzThnsv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ClzThnsv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F36215A1;
	Tue, 15 Sep 2026 09:02:28 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 77E883F882;
	Tue, 15 Sep 2026 09:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789488152; bh=j4bM4Le2AKal5yA6XAi5DmpI3S/KrZ5K/Wzmf15T0ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClzThnsvV0+f2nZe1I9A9CL5T0IFtVNFtDYXmBqMUKy7p9ELACjh0Ha7pRHGIj4sQ
	 68my1T9P80v3Ia1OsjWhaWL7ckX5so/M5GWZSFkcr9JHRNhaf7wWuasgcuObUGbPVQ
	 PP/+qzn+CvhwZfT+DOXHMcbdyYCO42GZClAvvn3k=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v18 13/23] KVM: arm64: Add a helper for VMs running on hyp that don't trust the host
Date: Tue, 15 Sep 2026 17:01:31 +0100
Message-ID: <20260915160141.3543048-14-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915160141.3543048-1-suzuki.poulose@arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PKVM and RMM, both do not trust the host. Add a helper to detect the VMs
that have "distrusting" hyp. Use this for blocking ioremap of vgic-v2 into
stage2.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/mmu.c              | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1bb43c57fb0f0..09910b2c61bfb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -328,6 +328,8 @@ enum fgt_group_id {
 enum kvm_arm_vm_flavor {
 	VM_NVHE,
 	VM_VHE,
+	/* VMs running on a hyp that doesn't trust */
+	MARKER(__VM_DISTRUSTING_HYP),
 	VM_PKVM,		/* Normal guests on pKVM */
 	MARKER(__VM_PROTECTED),
 	VM_PROTECTED_PKVM,	/* Protected VM */
@@ -1540,6 +1542,7 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define kvm_vm_is_protected_pkvm(kvm)	((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
 #define kvm_vm_is_unprotected_pkvm(kvm)	((kvm)->arch.vm_flavor == VM_PKVM)
 
+#define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor > __VM_DISTRUSTING_HYP)
 #define kvm_vm_hyp_is_pkvm(kvm)		(is_protected_kvm_enabled())
 #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 38f3bf772278f..559a8286807cd 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1251,7 +1251,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 				     KVM_PGTABLE_PROT_R |
 				     (writable ? KVM_PGTABLE_PROT_W : 0);
 
-	if (is_protected_kvm_enabled())
+	if (kvm_vm_hyp_is_distrusting(kvm))
 		return -EPERM;
 
 	size += offset_in_page(guest_ipa);
-- 
2.43.0

