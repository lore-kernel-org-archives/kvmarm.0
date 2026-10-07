Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1F033FE05;
	Wed,  7 Oct 2026 07:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791358551; cv=none; b=Lnpu/7VJgEBUCBXAcAl8IM2k3tvYE0a5ndukkZxMFVY8dv3b7PCfPAedLiNyTmc//1VBFNeBhbhQA3VbK+wt98br4Y4ro/WJlFNYX6u6aw0j8BcJjf7DjdsjJK0+ExBi4mP5kKcZ8vJJ4vYqq9Taaxe5sS7sw3JLYWTClj4nLP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791358551; c=relaxed/simple;
	bh=MwwwUevO7DSWHowBtjBnpSHhKsg5+nScre/xvZ4gWlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j6hvHEJkNCXunI5vIO/pDSezguD+9CO4Oci9AHa6Iuirf0S/LW321s7py7jJ9udgaL3X+mZtpE0DhB6kG/tivmE0nlBJqfNLKpc2PIdaZfMDHvvOktLPPeO15MlspLurchzn0mEebhSoOaBFFXlqPPCE3C5JcJ5F1+IB/umF8jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kaPb7Ojo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kaPb7Ojo"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8541C1477;
	Wed,  7 Oct 2026 00:35:45 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 530BB3F763;
	Wed,  7 Oct 2026 00:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791358548; bh=MwwwUevO7DSWHowBtjBnpSHhKsg5+nScre/xvZ4gWlk=;
	h=From:To:Cc:Subject:Date:From;
	b=kaPb7OjoXX1EbLl8pULSEA5tL2pkcyG+K2zzc1B3xAliR41eJymnvveOXszh9q0dM
	 bcIKmSZ35zosFZaXBFoW990DBdfhLQuRat01xJxTyXEpqVvfDC725CmcYqunj0fJbh
	 NEv14LCRX7b2CkDIz/BlYLYeL1UmTVeygAVflWLo=
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
Subject: [PATCH v23 00/14] KVM: arm64: CCA: Add basic plumbing for Realms
Date: Wed,  7 Oct 2026 08:35:23 +0100
Message-ID: <20261007073537.2454351-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is a trimmed down and updated version of the v22 of Arm CCA basic
plumbing series [0]. I have dropped the CCA specific bits for the sake keeping
them separate. This series now only contains the framework for handling
different VM types and lay down the path for adding Realm as one of the
protected VMs. The full support for running Realms under KVM is available as
an integration branch at [1].

The integration branch has been tested with the following components:

  tf-RMM:   main branch (commit 5e6e2acd) compliant to RMM-v2.0-beta3
  kvmtool: git@git.gitlab.arm.com:linux-arm/kvmtool-cca.git tag:cca-kvm-v20

[0] Arm CCA KVM basic plumbing v22
    https://lore.kernel.org/all/20261005090754.2140522-1-suzuki.poulose@arm.com
[1] https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/kvm-v23/integration

Changes since v22:
 https://lore.kernel.org/all/20261005090754.2140522-1-suzuki.poulose@arm.com
  - Drop the CCA specific patches for now, they are on the integration branch
  - system_supported_vcpu_features() - Start off with a base set of features for
    the type of VM
  - Add () around 'flavor' in KVM_VM_S2_OPS() macro
  - Drop BUILD_BUG_ON and redefine {kvm_vm,vcpu}_is_protected() for nVHE
  - Drop {kvm_vm,vcpu}_is_protected_pkvm() macros

Changes since v21:
 https://lore.kernel.org/all/20261001210703.1597150-1-suzuki.poulose@arm.com
 - Keep the kvm_arch struct packed, by moving psci_version, closer to vm_flavor and also moving the vm_s2_ops, closer to vm_flavor.
 - Drop the kern_hyp_va() for vcpu_is_protected() in nVHE, instead ban nVHE
   code from using vcpu_is_protected() (by using BUILD_BUG_ON()) and convert
   all users to vcpu_is_protected_pkvm()
 - Drop kvm_vm_is_unprotected_pkvm() in favor of open coded check against VM_PKVM
 - Drop WARN_ON_ONCE() in the kvm_vm_ioctl_allowed() to match Fuad's fix merged in v7.3-rc5
 - Move '&' to the KVM_*_OPS macros
 - Nuke __unmap_stage2_range() and define per-VM callback for stage2_unmap_range, removing the KVM_PGT_FN() hack for the call, and also for the others
 - Drop NULL check for vm_s2_ops callbacks and always define everything.
 - Add no_age_gfn() which plugs in for pVMs and Realms for the vm_age_*gfn callbacks

Steven Price (1):
  KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h

Suzuki K Poulose (13):
  KVM: arm64: protected VM: Handle user writes to CNTVCT_EL0/CNTPCT_EL0
  KVM: arm64: Disable Steal time accounting for protected guests
  KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  KVM: arm64: Track the type of VM in kvm_arch
  KVM: arm64: Don't call vcpu_set_pauth_traps for pKVM host
  KVM: arm64: Refactor the vcpu_load to allow for VM specific callbacks
  KVM: arm64: Add vcpu load/put call backs for flavors
  KVM: arm64: Consolidate stage2 unmap range into kvm_stage2_unmap_range
  KVM: arm64: Add VM specific callback for S2 MMU operations
  KVM: arm64: Use a local kvm pointer in kvm_handle_guest_abort()
  KVM: arm64: Abstract out memory abort handling
  KVM: arm64: Mandate VGIC v3 for pKVM VMs and Realms
  KVM: arm64: Prevent unsupported vcpu features for VM types

 arch/arm64/include/asm/kvm_host.h    |  73 ++++++-
 arch/arm64/include/asm/kvm_pgtable.h |  10 +-
 arch/arm64/include/asm/kvm_pkvm.h    |   6 +-
 arch/arm64/kvm/arch_timer.c          |  12 +-
 arch/arm64/kvm/arm.c                 | 275 ++++++++++++++++++++-------
 arch/arm64/kvm/hyp/nvhe/pkvm.c       |   6 +-
 arch/arm64/kvm/hyp/pgtable.c         |   1 +
 arch/arm64/kvm/mmio.c                |   1 +
 arch/arm64/kvm/mmu.c                 | 247 +++++++++++++++++-------
 arch/arm64/kvm/pkvm.c                |   6 +-
 arch/arm64/kvm/pvtime.c              |  14 +-
 arch/arm64/kvm/vgic/vgic-init.c      |   2 +
 include/kvm/arm_psci.h               |   2 +
 13 files changed, 493 insertions(+), 162 deletions(-)

-- 
2.43.0

