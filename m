Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789764078F5;
	Tue, 15 Sep 2026 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488116; cv=none; b=CXzGg/E6hCPqswjkB72TS1G3QLhvCJobigWlWqQ5o/elxx9Q4iGNXCCdrQCrBOXLy/omlfqeB8dZT0SioWx3+sUsi2+Y2JLYJ95hLIDMjqgOZQXePHuDfsuP1xHonHq5Rs4s61ylVmMUGD/SK3U3YJ/yKOZKe/h3x/xnit9qV+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488116; c=relaxed/simple;
	bh=g7JfusCOdHocTNV9z9cUpsA7H8ttkTMLI8K7q8fBkcU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GZ8ADrIyUInp555k6JFPl/2X6LxjXKdPB+sfUcsaLH29vzlqWDrinU/Pf7NS6A18Zi3PynY6WgNo+znVtKtU49hZffAhqTiPrnlNBbtoGPRBnMqOVMyXiUMt9/sE2Jct+Ui732dGoSlZcpfBFLodu5ad+PemaVlmIiezBbhThM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TwKixHvp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TwKixHvp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DB82152B;
	Tue, 15 Sep 2026 09:01:49 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 124083F882;
	Tue, 15 Sep 2026 09:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789488112; bh=g7JfusCOdHocTNV9z9cUpsA7H8ttkTMLI8K7q8fBkcU=;
	h=From:To:Cc:Subject:Date:From;
	b=TwKixHvp4vWjXKHjs3rLumSw12AfXUElMioVCow69W9anQzR75ByFjqMsa5x1nQAf
	 PhCzT/xrEZHpJ5WQwruxeYpmK66Y4QkDdGXIlqX7PE7v+y0gvfDYO2pvb+JOGn/M3D
	 26J9ozPDX6Z73Vt2IEYI1XtcJ1ixOBx9yvUmP/9I=
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
Subject: [PATCH v18 00/23] KVM: arm64: CCA: Add basic plumbing for Realms
Date: Tue, 15 Sep 2026 17:01:18 +0100
Message-ID: <20260915160141.3543048-1-suzuki.poulose@arm.com>
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
posted here [0]. Like in the v17, we have tried to split the entire series
into the following chunks.

 1) Base RMM RMI support under drivers/firmware/arm_rmm -> [1]
 2) Linux Host support for handling GPFs - [2]
 3) NEW: Enlighten KVM arm64 about the different VM types and use call
    backs for the VM type, rather than spilling the is_this_type_of_vm()
    everywhere. Adds VCPU and Stage2 MMU related callbacks with support
    for the existing VM types. There are other places where we may be
    able to abstract, but those need careful performance evaluations
    to make sure they are fit (e.g., vcpu_run)

   Later in the series, we generalise the predicate "kvm_vm_is_protected()"
   to cover all  "Confidential" VMs (which includes Protected VM and Realms),
   which allows us to handle common themes without having to do things like :
     if (kvm_vm_is_protected() || kvm_vm_is_realm()),
     instead:
     if (kvm_vm_is_confidential())
   Also replaces the code with precise check for a given VM type to
   avoiding combination of if (). e.g,, kvm_vm_is_unprotected_pkvm(kvm).
   The checks under arch/arm64/kvm/{nvhe,pkvm} still retain the vm_is_protected()
   check as pVMs are the only possible protected VMs there.
   
 4) Bare minimal Realm VM support without the actual functionality to
    run a Realm. This would help the maintainers to review the series in
    smaller chunks. This doesn't depend on [1] and can be independently
    merged, without being "functional".
    This series includes vcpu operations and the s2 vm operations, which
    do need the RMI driver backend to be meaningful. But the KVM handler
    is in the right shape. The remaining changes would be added once the
    RMI firmware library lands.
 5) Core implementation of the RMI driver for KVM and actual enablement of the
    Realm support. This depends on (1), (2) and the guest-memfd-in-place
    conversion series v12 from Ackerley. This is available here at the integration
    branch [3]

This series is comprised of (3) and (4) above.

The integration branch has been tested with the following components:
  tf-RMM:   main branch (commit 5e6e2acd) compliant to RMM-v2.0-beta3 [4]
  kvmtool: git@git.gitlab.arm.com:linux-arm/kvmtool-cca.git cca/kvm-v18

[0] Arm CCA KVM Support v16 : https://lore.kernel.org/all/20260803134403.80630-1-steven.price@arm.com
[1] Linux firmware RMI https://lore.kernel.org/all/20260912083611.2513845-1-suzuki.poulose@arm.com
[2] Linux GPF Host https://lore.kernel.org/all/20260913070459.2547407-1-suzuki.poulose@arm.com
[3] https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/kvm-v18/integration
[4] https://support.arm.com/documentation/den0137/2-0bet3/

Changes since v17:
https://lore.kernel.org/all/20260908162223.1683432-1-suzuki.poulose@arm.com 

 - Add a patch to fix pKVM handling of SYS_CNTVCT/CNTPCT to override the counter
   offset (Patch1)
 - Restrict Realms to VGIC v3 only - New patch
 - Add kvm_vm_is_unprotected() to replace is_protected_kvm_enabled() &&
   !kvm_vm_is_protected() - New patch
 - Use macro to initialize the per-flavor vcpu, s2_vm ops
 - Add a wrapper to initialise vcpu and s2_vm ops with a BUILD_BUG_ON()
   for the array size checks against VM flavour types
 - Drop forward decalaration of the vcpu, s2_vm operations that spoiled the
   fun ;-)
 - Remove irrelevant comment about the order of timer loading for !VHE
 - Use the explicti kvm_call_hyp_nvhe for pKVM specific ops
 - Don't call nvhe_vcpu_put from pkvm_vcpu_put, open code them
 - Drop cpu argument for vcpu_load() callback. We set the cpu
   before the callbacks are invoked
 - Drop kvm_vm_is_confidential(), instead widen the scope of kvm_vm_is_protected()
   to cover pVMs and Realms. Add an explicit helper kvm_vm_is_protected_pkvm()
   for the cases where we need to check for a "pVM on pKVM"
 - Add kvm_vm_hyp_is_pkvm() for checking if the VM is running on pKVM.
   covers both unprotected and pvms. But really uses is_protected_kvm_enabled()
   under the hood
 - Add kvm_vm_hyp_is_distrusting() to cover pKVM guests (both protected and
   unprotected) and Realms. Use this for preventing the vgic v2 mapping into
   Stage2 for a guest
 - Drop superfluous !kvm check from kvm_vm_ioctl_enable_cap() - Sashiko
 - Drop KVM_CAP_CREATE_IRQCHIP, as we don't support VGIC_V2 for Realms
 - Filter out the vm_ioctls that are based on blocked cap.
 - Repurpose the pkvm plumbing for filtering the caps and ioctl to generic
   and plumb the Realm support in
 - s/PKVM/pKVM for the comments
 - Drop type argument for pkvm_init_host_vm and also drop protected variable,
   now that we have the vm_flavor to check.
 - Use kvm_vm_hyp_is_pkvm() to replace is_protected_kvm_enabled() with valid
   kvm instance
 - CCA: Merge the GET/SET REG handling patches into a single patch
 - CCA: Reword the commit description for SVE VL access handling
 - Reordered the patches to group the Realm realted to changes to the rear end

Jean-Philippe Brucker (2):
  KVM: arm64: CCA: Expose SVE VL register before VCPU finalization
  KVM: arm64: CCA: Control user register access for Realms

Steven Price (3):
  KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
  KVM: arm64: CCA: Support timers in realm RECs
  KVM: arm64: CCA: WARN on injected undef exceptions

Suzuki K Poulose (18):
  KVM: arm64: protected VM: Handle set_one_reg CNTVCT_EL0/CNTPCT_EL0
  KVM: arm64: Disable Steal time accounting for protected guests
  KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  KVM: arm64: Track the type of VM in kvm_arch
  KVM: arm64: Refactor the vcpu_load to allow for VM specific callbacks
  KVM: arm64: Add vcpu load/put call backs for flavors
  KVM: arm64: Reuse kvm_stage2_unmap_range in kvm_unmap_gfn_range
  KVM: arm64: Add VM specific callback for S2 MMU operations
  KVM: arm64: Abstract out memory abort handling
  KVM: arm64: Use kvm_vm_is_unprotected() for !kvm_vm_is_protected()
  KVM: arm64: Widen the scope of "protected" VMs
  KVM: arm64: Add a helper for VMs running on hyp that don't trust the
    host
  KVM: arm64: CCA: Add a new mode for supporting Realm guests
  KVM: arm64: CCA: Add VCPU load/put for Realms
  KVM: arm64: CCA: Add bare minimal S2 operations for Realm
  KVM: arm64: CCA: Introduce Realms
  KVM: arm64: CCA: Mandate VGIC_V3 for Realms
  KVM: arm64: CCA: Don't expose unsupported capabilities for realm
    guests

 .../admin-guide/kernel-parameters.txt         |   3 +
 arch/arm64/include/asm/kvm_emulate.h          |  16 +
 arch/arm64/include/asm/kvm_host.h             |  63 +++-
 arch/arm64/include/asm/kvm_pgtable.h          |   6 +-
 arch/arm64/include/asm/kvm_pkvm.h             |  25 +-
 arch/arm64/include/asm/kvm_rmi.h              |  61 ++++
 arch/arm64/include/asm/virt.h                 |   1 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arch_timer.c                   |  37 +-
 arch/arm64/kvm/arm.c                          | 330 +++++++++++++++---
 arch/arm64/kvm/guest.c                        |  73 +++-
 arch/arm64/kvm/handle_exit.c                  |   2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  28 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   1 +
 arch/arm64/kvm/hypercalls.c                   |   4 +-
 arch/arm64/kvm/inject_fault.c                 |   1 +
 arch/arm64/kvm/mmu.c                          | 210 ++++++++---
 arch/arm64/kvm/pkvm.c                         |   6 +-
 arch/arm64/kvm/pvtime.c                       |  14 +-
 arch/arm64/kvm/rmi.c                          |  18 +
 arch/arm64/kvm/sys_regs.c                     |  29 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   3 +
 include/kvm/arm_arch_timer.h                  |   3 +-
 include/kvm/arm_psci.h                        |   2 +
 24 files changed, 758 insertions(+), 180 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h
 create mode 100644 arch/arm64/kvm/rmi.c

-- 
2.43.0

