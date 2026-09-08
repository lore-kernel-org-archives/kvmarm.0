Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648A833DEFE;
	Tue,  8 Sep 2026 16:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884571; cv=none; b=ZakN1niDUVvRBi6XcplWFZNdns6f71p6qztchjQsqUs8YTliMJzOIH3/8hGSLM4WKmeA7CY7cX2G1U61n0I1FD1m5VKFX4NfgjcTTDUSYdY8/qNR53Tw51RJhEq82P+WjK0tf6FSyMR5IbU9w9NCWYYM3mCPTErzFNteWudIOwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884571; c=relaxed/simple;
	bh=MicxkYdQIJvLlM2WnDXT+B4vDYwqYweRzRp+ztwb4gY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KIfYXT+q0TrkzTJe4n4tYWP44IgoXYmMrAOOdS5yntvPLK4d/1gRkjPYHr1GZuVj+LC6Ijf7itJg2VnnYsajrGY0NcdwqA4wp34jXD7T2mHqLLt+6dCbgtqJVRePW16bYD08LPYSQVpVHa6kf7SInXqGEmNvttmPY7QP3MtSFrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LynWZ9HX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LynWZ9HX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06E271477;
	Tue,  8 Sep 2026 09:22:45 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 639083F7B4;
	Tue,  8 Sep 2026 09:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884568; bh=MicxkYdQIJvLlM2WnDXT+B4vDYwqYweRzRp+ztwb4gY=;
	h=From:To:Cc:Subject:Date:From;
	b=LynWZ9HXpFCF7ZmiCj445U7s22J61VPliLR00ix8Lb4UiOvBVECOKxAFtLvKBdNMC
	 rBNFqsJfhR/C5fl3PGSrYHFISJ/Jmfxppj6UgkAn7VqAci+NGSTkwXkjfeCwvzSg2C
	 /KbizwECPFuTxNezEAQm5XH3RJbDZeyDgelwLrhw=
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
Subject: [PATCH v17 00/20] KVM: arm64: CCA: Add basic plumbing for Realms
Date: Tue,  8 Sep 2026 17:22:03 +0100
Message-ID: <20260908162223.1683432-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series is a trimmed down version of the Arm CCA KVM support, previously
posted here [0]. Since the last version, we have tried to split the entire
series into the following chunks, while also addressing the review comments on
that version.

 1) Base RMM RMI support under drivers/firmware/arm_rmm -> [1]
 2) Linux Host support for handling GPFs - [2]
 3) NEW: Enlighten KVM arm64 about the different VM types and use call backs for
   the VM type, rather than spilling the is_this_type_of_vm() everywhere. This is
   not complete yet, but it is largely functional. Adds VCPU and Stage2 MMU related
   callbacks with support for the existing VM types. There are other places where
   we may be able to abstract, but those need careful performance evaluations to
   make sure they are fit (e.g., vcpu_run)
   Also adds classification of "Confidential" VMs (which includes Protected VM
   and Realms), which allows us to handle common themes without having to do
   things like :
     if (kvm_vm_is_protected() || kvm_vm_is_realm()),
     instead:
     if (kvm_vm_is_confidential())
   The S2 MMU abstraction layer is kept at the end of this series. The Realm S2
   related implementations cannot be added meaningfully without the RMI commands.
 4) Bare minimal Realm VM support without the actual functionality to run a Realm.
   This would help the maintainers to review the series in smaller chunks. This
   doesn't depend on [1] and can be independently merged, without being "functional".
 5) Core implementation of the RMI driver for KVM and actual enablement of the
    Realm support. This depends on (1), (2) and the guest-memfd-in-place
    conversion series v12 from Ackerley. This is available here at the integration
    branch [3]

This series is comprised of (3) and (4) above.

The integration branch has been tested with the following components:
  tf-RMM:   main branch (commit 5e6e2acd) compliant to RMM-v2.0-beta3 [4]
  kvmtool: git@git.gitlab.arm.com:linux-arm/kvmtool-cca.git cca/kvm-v17

[0] Arm CCA KVM Support v16 : https://lore.kernel.org/all/20260803134403.80630-1-steven.price@arm.com
[1] Linux firmware RMI https://lore.kernel.org/all/20260907095942.1140734-1-suzuki.poulose@arm.com
[2] Linux GPF Host https://lore.kernel.org/all/20260907162204.1479401-1-suzuki.poulose@arm.com
[3] https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/kvm-v17/integration
[4] https://support.arm.com/documentation/den0137/2-0bet3/

Jean-Philippe Brucker (2):
  KVM: arm64: CCA: Provide register list for unfinalized RECs
  KVM: arm64: CCA: Provide an accurate register list

Steven Price (4):
  KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
  KVM: arm64: CCA: Introduce Realms
  KVM: arm64: CCA: Support timers in realm RECs
  KVM: arm64: CCA: WARN on injected undef exceptions

Suzuki K Poulose (14):
  KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  KVM: arm64: Track the type of VM in kvm_arch
  KVM: arm64: Refactor the vcpu_load to allow for VM specific callbacks
  KVM: arm64: Add vcpu load/put call backs for flavors
  KVM: arm64: CCA: Add a new mode for supporting Realm guests
  KVM: arm64: coco:  Add a helper to check if a VM is confidential
    compute guest
  KVM: arm64: coco: arch_timer: Prevent timer offset configuration
  KVM: arm64: coco: Disable Steal time accounting for coco guests
  KVM: arm64: coco: Don't handle MMIO with no ISV
  KVM: arm64: CCA: Add VCPU load/put for Realms
  KVM: arm64: CCA: Don't expose unsupported capabilities for realm
    guests
  KVM: arm64: Reuse kvm_stage2_unmap_range in kvm_unmap_gfn_range
  KVM: arm64: Add VM specific callback for S2 MMU operations
  KVM: arm64: Abstract out memory abort handling

 .../admin-guide/kernel-parameters.txt         |   3 +
 arch/arm64/include/asm/kvm_emulate.h          |  16 ++
 arch/arm64/include/asm/kvm_host.h             |  58 +++-
 arch/arm64/include/asm/kvm_pgtable.h          |   6 +-
 arch/arm64/include/asm/kvm_pkvm.h             |   2 +-
 arch/arm64/include/asm/kvm_rmi.h              |  61 ++++
 arch/arm64/include/asm/virt.h                 |   1 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arch_timer.c                   |  28 +-
 arch/arm64/kvm/arm.c                          | 267 +++++++++++++++---
 arch/arm64/kvm/guest.c                        |  16 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   1 +
 arch/arm64/kvm/hypercalls.c                   |   4 +-
 arch/arm64/kvm/inject_fault.c                 |   1 +
 arch/arm64/kvm/mmio.c                         |   4 +-
 arch/arm64/kvm/mmu.c                          | 173 +++++++++---
 arch/arm64/kvm/pkvm.c                         |   1 -
 arch/arm64/kvm/pvtime.c                       |  10 +-
 arch/arm64/kvm/rmi.c                          |  18 ++
 arch/arm64/kvm/sys_regs.c                     |  27 +-
 include/kvm/arm_psci.h                        |   2 +
 22 files changed, 581 insertions(+), 122 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h
 create mode 100644 arch/arm64/kvm/rmi.c

-- 
2.43.0

