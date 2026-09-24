Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DF04B7167;
	Thu, 24 Sep 2026 16:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265980; cv=none; b=RXMeht6QmMfCIJ2iaorHCKXHkCNaUfWbd3kJLrUwfEvjYQEUupaXRNz3m8MDw36yyWmn3nAYwWGAsqnWdVFDayRzwGVH4oh0aTF6BRmfUfmAFIpldUsY5qUdja/PBeWRzL5s/cd6gzwoS5Xobcbjyy31kcZg5Sq/UDrQyeWIdYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265980; c=relaxed/simple;
	bh=aUMJm4MmfVPuRwP9cR6se83O2r8UV6BA2hVIN/OMalE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgYbH9aPSvDCTD67UAZUwSXK7lqP1iRbSp/mTOgH+I2bRVbLyPLHQPwodpem8iAKHPdxDRA7afKjK0atEypB2IrESF3qyFIzQ/etd0v3LvKW74Kr3ynvCDNdt0IL8mLjzv14GUgTvbx96rcJkWoBel/6hBQD5e+n/J2WhY0TnlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ifI8ensj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ifI8ensj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53F101E7D;
	Thu, 24 Sep 2026 09:06:14 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9EAAC3F86C;
	Thu, 24 Sep 2026 09:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790265977; bh=aUMJm4MmfVPuRwP9cR6se83O2r8UV6BA2hVIN/OMalE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifI8ensjRQ0Jh5Jlv4SVCgwkex5CCuJrDuIQwOvtZq11ce8a9HIBAE307eQbW/JZJ
	 ijd1prqvCUMtGpwgSZpllG0yq2lkwZwM1HWV4QZVRiNHFlEs0mYbsdif0SEXWhbV8S
	 NJysNL94iId7dPQv/LH+4R7bNAt4602XrvBJk0Zo=
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
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v20 13/22] KVM: arm64: Mandate VGIC v3 for pKVM VMs and Realms
Date: Thu, 24 Sep 2026 17:04:55 +0100
Message-ID: <20260924160504.853911-14-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924160504.853911-1-suzuki.poulose@arm.com>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pKVM does not trust the host. Realm VMs follow a similar trust model, with
the Realm Management Monitor owning the protected state instead of the host.
Add a helper to identify VMs that run under a host-distrusting hypervisor.

Use this for blocking ioremap of vgic-v2 into stage2 and prevent creation of
VGIC other than v3.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v18:
 - Cover pKVM guests for VGIC v3 mandate.
 - Merge the VGIC mandate check in here.
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/mmu.c              | 2 +-
 arch/arm64/kvm/vgic/vgic-init.c   | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 871f503e9f164..4d75b8e6797bb 100644
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
@@ -1575,6 +1577,7 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define kvm_vm_is_unprotected_pkvm(kvm)		\
 	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PKVM))
 
+#define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
 
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8e092efdf0825..8f21652d3625c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1252,7 +1252,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 				     KVM_PGTABLE_PROT_R |
 				     (writable ? KVM_PGTABLE_PROT_W : 0);
 
-	if (is_protected_kvm_enabled())
+	if (kvm_vm_hyp_is_distrusting(kvm))
 		return -EPERM;
 
 	size += offset_in_page(guest_ipa);
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 4012df6002ea6..874025513afcc 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -84,6 +84,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		!kvm_vgic_global_state.can_emulate_gicv2)
 		return -ENODEV;
 
+	if (kvm_vm_hyp_is_distrusting(kvm) && type != KVM_DEV_TYPE_ARM_VGIC_V3)
+		return -ENODEV;
 	/*
 	 * Ensure mutual exclusion with vCPU creation and any vCPU ioctls by:
 	 *
-- 
2.43.0

