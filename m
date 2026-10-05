Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A9842AF85;
	Mon,  5 Oct 2026 09:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191289; cv=none; b=EekRorF2qvkrBCREUAaerCVK8fU+anobN6IJL0z+uQiaqibra4LaHEWLSV35zxU9zeoCnY/Pjdd+KJKUO03wg1zH2iNTRrNHsOAiWjNW1J0wWV/IBNC+X9AXxRyWSbqCGVMowqaF3wJO2+z112gpgWoKQu2CsjE6jRns4GthWhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191289; c=relaxed/simple;
	bh=dXQ18aMobkg8vJ7RpOVIi1jqlWhubANiu7se/D4beaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fUm33t2Oq9xqeRlFBBkxZT5gaVmrs7pH1uXIWYXkijnJHJs50+ORzA1UEjr3iwyLPghPuoeTfvRa7urPaTQSy2wd0X3jiPBnNWAEx5FhvdQNhNbsXYaIDRf01gDWhEtcYHq53jS+rJT4TKNKS1mgLF0S6aXpojFk9tBLbM/ddYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=INet3jcp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="INet3jcp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CE90152B;
	Mon,  5 Oct 2026 02:08:03 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 777E53F66F;
	Mon,  5 Oct 2026 02:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191286; bh=dXQ18aMobkg8vJ7RpOVIi1jqlWhubANiu7se/D4beaQ=;
	h=From:To:Cc:Subject:Date:From;
	b=INet3jcpdIszjC2dHD2v/DYePPWtp8RGta2fNAlUC+nAebHLNbvjoojUh8T96Uvid
	 LoHdDSCdgL6gdr0cFQegwdI5s8vtBEDmzumsN7MlYPpkyl6r0J8rTTPqU1kxql+ouD
	 oP7EOeYMovvF67GjyRBbsqh4OsfKfRZeVwZoX7E0=
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
Subject: [PATCH v22 00/23] KVM: arm64: CCA: Add basic plumbing for Realms
Date: Mon,  5 Oct 2026 10:07:31 +0100
Message-ID: <20261005090754.2140522-1-suzuki.poulose@arm.com>
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

   With that in place we generalise the predicate "kvm_vm_is_protected()"
   to cover all  "Confidential" VMs (which includes Protected VM and Realms),
   allowing us to handle common themes without having to do things like :

     if (kvm_vm_is_protected() || kvm_vm_is_realm())

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
    RMI firmware library lands. Also covers the SET_ONE_REG/GET_ONE_REG

 5) Core implementation of the RMI driver for KVM and actual enablement of the
    Realm support. This depends on (1), (2) and the guest-memfd-in-place
    conversion series v12 from Ackerley. This is available here at the integration
    branch [3]


NOTE: There is a conflict with Fuad's patch to drop the WARN for unknown vm
ioctls, that is queued in ~fixes~ in v7.3-rc5. I have dropped the
WARN_ON_ONCE() to match the code after resolution.

  https://lore.kernel.org/all/20260914093838.1082637-1-fuad.tabba@linux.dev 

This series is comprised of (3) and (4) above.

The integration branch has been tested with the following components:

  tf-RMM:   main branch (commit 5e6e2acd) compliant to RMM-v2.0-beta3 [4]
  kvmtool: git@git.gitlab.arm.com:linux-arm/kvmtool-cca.git tag:cca-kvm-v20

[0] Arm CCA KVM Support v16 : https://lore.kernel.org/all/20260803134403.80630-1-steven.price@arm.com
[1] Linux firmware RMI v22 https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/fw_rmm/v22
[2] Linux GPF Host  https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/host-gpf/v19
[3] https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/kvm-v222integration
[4] https://support.arm.com/documentation/den0137/2-0bet3/

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

Changes since v20:
 https://lore.kernel.org/all/20260924160504.853911-1-suzuki.poulose@arm.com

 - Allow KVM_ARM_CAP_DEVICE_CTRL for Realms to allow SMCCC filtering
 - New patch: Deny vcpu features not compatible with protected VMs
 - Remove suprious ":w" in commit description (Thanks Catalin)

Changes since v19:
 https://lore.kernel.org/all/20260920212845.707-1-suzuki.poulose@arm.com

 - Collect Reviews from Jonathan, and Tested-by from Gavin - Thank you both!
 - Add a new patch prepare the the vcpu_set_pauth_traps for the addition of
   VCPU callbacks. Could have merged with the existing one, but that becomes
   quite too much to follow.
 - Add another new preparatory patch to replace vcpu->kvm => new local variable
   kvm in kvm_handle_guest_abort(), making it also easier for abstracting memory
   abort handling.
 - Fix vcpu_is_protected for nvhe hyp code, by using kern_hyp_va() for vcpu->kvm
 - Use READ_ONCE() to read the host kvm->arch.vm_flavor in EL2 pKVM code
 - Move the replacement of !kvm_vm_is_protected() in kvm_arch_vcpu_put() with
   kvm_vm_is_unprotected_pkvm() to this patch
 - Drop ',' after the end marker in vm_flavor enums
 - Wrap kvm_arm_vmid_clear_active() in 'vcpu_put_mmu()' to compliment the
   vcpu_prepare_mmu and call it conditional on !pKVM.
 - Update the time loading constraints comment to clarify that it only applies
   for VHE.
 - Sort the vcpu ops by vm_flavor enum value
 - Add blank line in kvm_arch_flush_remote_tlbs()
 - Drop local variable ret and directly return from if...else for kvm_vm_mem_abort

Changes since v18:
  https://lore.kernel.org/all/20260915160141.3543048-1-suzuki.poulose@arm.com

 - Patch count down by 3, after merging different patches together, see more below
 - Retain NULL vm_offset for pVMs and move the counter offset flag initialisation
   to kvm_timer_init_vm() - Marc
 - Merge widening the scope of kvm_vm_is_protected() to the patch where the
   flavors are introduced(Marc) and also dropped Fuad's reviewed-by, as the
   patch is now bigger.
 - Merge "Use kvm_vm_is_unprotected_pkvm" for !kvm_vm_is_protected to patch
   where flavor is introuced.
 - Merge "vgic-v3" mandate and preventing vgic-v2 mappings to a single patch,
   where kvm_vm_hyp_is_distrusting() introduced - Fuad
 - Drop kvm_vm_hyp_is_pkvm(), reverting to is_protected_kvm_enabled()
 - Use is_protected_kvm_enabeld() for pKVM guest flavor checks.
 - s/PKVM/pKVM for commit descriptions too
 - Make sure the vm_mem_abort callback is !NULL at init time.
 - Bail out early for !pKVM && !Realm VMs in kvm_vm_ioctl_allowed(). Use
   kvm_vm_hyp_is_distrusting()
 - WARN_ON_ONCE(!kvm) for kvm_vm_ioctl_allowed() as it must be only called with
   a valid kvm instance and only from kvm_arch_vm_ioctl()
 - Rename kvm_arch_vm_{ext,ioctl}_allowed => kvm_vm_{ext,ioctl}_allowed - Fuad
 - Move kvm_realm_ext_allowed() to asm/kvm_rmi.h - Fuad
 - Don't expose PMCR_EL0 to the userspace until we support PMU


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

Steven Price (4):
  KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
  KVM: arm64: CCA: Introduce Realms
  KVM: arm64: CCA: WARN on injected undef exceptions
  KVM: arm64: CCA: Support timers in realm RECs

Suzuki K Poulose (17):
  KVM: arm64: protected VM: Handle user writes to CNTVCT_EL0/CNTPCT_EL0
  KVM: arm64: Disable Steal time accounting for protected guests
  KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  KVM: arm64: Track the type of VM in kvm_arch
  KVM: arm64: Don't call vcpu_set_pauth_traps for pKVM host
  KVM: arm64: Refactor the vcpu_load to allow for VM specific callbacks
  KVM: arm64: Add vcpu load/put call backs for flavors
  KVM: arm64: Prevent unsupported vcpu features for VM types
  KVM: arm64: Consolidate stage2 unmap range into kvm_stage2_unmap_range
  KVM: arm64: Add VM specific callback for S2 MMU operations
  KVM: arm64: Use a local kvm pointer in kvm_handle_guest_abort()
  KVM: arm64: Abstract out memory abort handling
  KVM: arm64: Mandate VGIC v3 for pKVM VMs and Realms
  KVM: arm64: CCA: Add a new mode for supporting Realm guests
  KVM: arm64: CCA: Add VCPU load/put for Realms
  KVM: arm64: CCA: Add bare minimal S2 operations for Realm
  KVM: arm64: CCA: Don't expose unsupported capabilities for realm
    guests

 .../admin-guide/kernel-parameters.txt         |   3 +
 arch/arm64/include/asm/kvm_emulate.h          |  16 +
 arch/arm64/include/asm/kvm_host.h             |  90 ++++-
 arch/arm64/include/asm/kvm_pgtable.h          |  10 +-
 arch/arm64/include/asm/kvm_pkvm.h             |  25 +-
 arch/arm64/include/asm/kvm_rmi.h              |  85 ++++
 arch/arm64/include/asm/virt.h                 |   1 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arch_timer.c                   |  34 +-
 arch/arm64/kvm/arm.c                          | 367 ++++++++++++++----
 arch/arm64/kvm/guest.c                        |  73 +++-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |   6 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   4 +-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   1 +
 arch/arm64/kvm/hypercalls.c                   |   4 +-
 arch/arm64/kvm/inject_fault.c                 |   1 +
 arch/arm64/kvm/mmio.c                         |   1 +
 arch/arm64/kvm/mmu.c                          | 273 +++++++++----
 arch/arm64/kvm/pkvm.c                         |   6 +-
 arch/arm64/kvm/pvtime.c                       |  14 +-
 arch/arm64/kvm/rmi.c                          |  18 +
 arch/arm64/kvm/sys_regs.c                     |  28 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   2 +
 include/kvm/arm_psci.h                        |   2 +
 26 files changed, 858 insertions(+), 212 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h
 create mode 100644 arch/arm64/kvm/rmi.c

-- 
2.43.0

