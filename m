Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E62C4A5C4A;
	Thu,  1 Oct 2026 08:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844389; cv=none; b=gNSZEUMLKDyR+20VRjJbijlAtRVfKEjjL4tmd2J/Cr6FcFvlXO6y3UEYHUh2StKH00Q0s7LT49Rq3pCrhshNJ9lzvrhgeAtO7fA5E8php3LI/lzzhy3zMAVK3O+VMVhuGX3pkvGAVhBaSWSK8UpF6B/VSfYQy8C97B9tFjFMMfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844389; c=relaxed/simple;
	bh=IWn6X2ee4Ws5ZRmnpMPegABaKn2HtGw846vc6CMx/f4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u/FVi9EYtT5gfGRIluuEThilWri+Y0ffSf21zIqI38lzIwEL1uGSNeB9uFw1wYJleyxAmdyjqaQ6wpumHarHyHQTd5PoxdGIntitxjd4z3ibfnZp63hlXNuxkW4V42eC7Zq9aZPAaByHjqQsBmZgNTfWs5ivf/mX8c7GKHN2Pyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BOES6TJd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BOES6TJd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9392497;
	Thu,  1 Oct 2026 01:46:22 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 370F33F85F;
	Thu,  1 Oct 2026 01:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790844386; bh=IWn6X2ee4Ws5ZRmnpMPegABaKn2HtGw846vc6CMx/f4=;
	h=From:To:Cc:Subject:Date:From;
	b=BOES6TJdAgaxj9sgffC4/YFGo6K3J2xZwGfaNJXnxi9lbiKFjOtyUgGl97DbpU8Xk
	 Ve3Y+o2E/0qASYM5GacSPkRBhlsGN86c7AL1Bs3sGKkGm9DJXuttwGDF7ZiWfsYzDq
	 /8BnUMXDxSjxf33CmPUN3QDlnN+mL0TqgVPyN70Y=
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
Subject: [PATCH v21 0/9] firmware: arm_rmm: Add RMM v2.0 base RMI support
Date: Thu,  1 Oct 2026 09:45:46 +0100
Message-ID: <20261001084555.1456543-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds the generic firmware layer for talking to the Realm
Management Monitor (RMM), as specified by the RMM v2.0-bet3
specification[1]. It is the first part of the Arm CCA host support that
was previously posted as part of the larger KVM series.

The split allows this RMM support to be used as a base for other work,
including Aneesh's PCI IDE support with Arm CCA RMM as the TSM,
 without depending on the KVM Realm support that will follow as separate
 series. (See more on that below)

The series adds:

 * The RMI SMC definitions and direct-call wrappers.

 * RMM discovery and version checks during firmware init.

 * RMM host configuration, including the host page size.

 * Stateful RMI Operation (SRO) infrastructure for commands which the RMM
   can complete across multiple SMC calls while requesting or returning
   memory to the host.

 * Verification that granule tracking is available at fine granularity.
   Fine-grained tracking allows each granule in the system to be tracked
   independently, which is required before individual granules can be
   delegated. A future series will add support for dynamically supplying
   memory to the RMM for this tracking.

 * Support for fully firmware-managed systems, where the Granule Protection
   Tables for memory regions are allocated and managed by firmware. RMM v2.0
   also allows dynamic GPT creation on demand; support for that will be added
   in a later series.

 * Wrappers for the RMI commands that are used for managing the "Realm VM"
   lifecycle. This is added in to make it easier for the on-going KVM support
   to evolve in parallel pieces.

If the platform firmware cannot manage the granule tracking or the GPTs, we
bail out and deactivate the RMM, reclaiming any memory that we have donated.

The RMM v2.0 spec introduces Stateful RMI Operations (SROs), which allow
the RMM to complete an operation over several SMC calls while requesting
or returning memory to the host. This allows interrupts to be handled in
the middle of an operation and lets the RMM dynamically allocate memory
for internal tracking purposes. For example, RMI_REC_CREATE no longer
needs auxiliary granules to be provided up front, and can instead
request memory during the operation.

This series applies on v7.3-rc2 and a branch is available at [2]. The KVM
CCA support that builds on this series is available at [3] as an integration
branch. The KVM support depends on guest-memfd-in-place conversion support v13
from Ackerley [4], we plan to split that into parts, which apply cleanly on
v7.3-rcx without any dependency and is in progress. This will be made available
as soon as it is ready. Until then [3] shows how this base series enables KVM
CCA support. You may find the tf-RMM [5] and kvmtool support [6] below.
The kvm integration branch has been tested with kvm-unit-tests [7] and Linux
kernel booting with PCI device assigned as an untrusted device.

[1] RMM spec : https://support.arm.com/documentation/den0137/2-0bet3/
[2] This series: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/fw_rmm/v21
[3] KVM CCA v21 integration branch: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca/cca-host/kvm-v21/integration-v2
[4] Gmem inplace conversion https://github.com/googleprodkernel/linux-cc/tree/guest_memfd-inplace-conversion-v13
[5] TF-RMM https://git.trustedfirmware.org/TF-RMM/tf-rmm.git main (commit: 134266ae)
[6] kvmtool https://gitlab.arm.com/linux-arm/kvmtool-cca.git tag:cca-kvm-v20 (Also cca/kvm-v18)
[7] kvm-unit-tests https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca.git tag: cca-rmm-v2.0

Known issues: RMMv2.0 spec.
==========================
Here are some of the known issues affecting the code here. I have included the
ticket number associated with the issues, which will be available in the RMM
spec, when a public release is available. (So that it is easier to see if the
issues has been fixed in the spec and easily spot them)

 * RmiOpMemDonateReq:count (Uint14) is incompatible with RmiAddrRangeDesc4KB
  (Uint10) and RmiAddrRangeDesc16KB (Uint12). i.e., a larger contiguous request
  may not be satisfiable by the host. This is resolved in the RMM spec, by clamping
  the upper limit on the number to match the RmiAddrRangeDesc* and will be published
  in the next release. (FENIMORE-1744)
 * RMM to clarify the scenarios that triggers the RMI_BLOCKED and the
   recommendations to limit the cases. (FENIMORE-1783)
 * RMM to clarify the "PE bound" SRO context pool to really mean global pool
   (FENIMORE-1802)
 * Clarify RMI_RTT_DATA_UNMAP, output_count, output_range are only valid when
   result is RMI_SUCCESS (FENIMORE-1746)
 * Fix the top_bound condition for RMI_GPT_INFO, (top > pa_sz) (FENIMORE-1807)

Changes since v20:

 ** Patch: firmware: arm_rmm: Add support for SRO
  - Fix potential overflow of donated_size from a buggy RMM
  - Use FIELD_MAX() for the maximum count support for RMI_ADDR_RANGE
 ** Patch: arm64: Block hibernate and kexec while RMM is active
  - Block hibernate via a new hook "arch_hibernation_available()"
 ** Patch: firmware: arm_rmm: Add wrappers for Realm related RMI commands
  - Add a non-retrying rmi_smccc_invoke_once, use that for REC_ENTER. Will be
    useable by other DA related RMI calls. KVM integration branch also handles
    RMI_BUSY and treats it as ARM_EXCEPTION_IRQ
 ** Patch: firmware: arm_rmm: hotplug: Skip memory added to ZONE_MOVABLE
  - firmware: arm_rmm: hotplug: Skip memory added to ZONE_MOVABLE
 ** Collected Reviews, Ack with thanks

Changes since v19:
 https://lore.kernel.org/all/0260924135201.850038-1-suzuki.poulose@arm.com

 ** Patch 1 - RMI SMCCC definitions
  - Fold 'padding' only union in rec_exit to the previous group of fields
  - Add static_assert to make sure the struct field offsets match the spec
  - Rename 'padding' fields to 'sizer' which they really are
  - Add MAINTAINERS entry for the new header file under ARM64
 ** Patch 2 - firmware: arm_rmm: Check for RMI support at init
  - Fix comment : s/RmiFeatureRegister5/RmiFeatureRegister4/
  - rmi_feat_reg() s/unsigned long/unsigned int for index
  - linux/arm-rmi-cmds.h -> Mark the "#endif"
  - Use += rmi.o in Makefile
  - Mask the ID_AA64PFR0_EL1_RME field for KVM guests
  - Add MAINTAINERS entry for header file and arm_rmm directory
 ** Patch 3 - firmware: arm_rmm: Configure the RMM with the host's page size
  - Don't initialize 'ret' in rmi_configure, add explicit return 0/-EINVAL
 ** Patch 4 - firmware: arm_rmm: Add support for SRO
  - Fix typos s/-ECANCELLED/ECANCELED/ rmi_sro_execute()
  - Drop duplicate, incorrect assignment of sro_handle in rmi_sro_execute()
  - Drop int i, redeclartion in for() for rmi_sro_donate_noncontig()
  - Drop donated_granules for rmi_sro_donate_contig()
  - Drop "inline" and be consistent with the rest of the code
  - Avoid nesting if..else in rmi_*delegate_range by breaking out on error
  - Consistent styling in comments, wrap to 80space, spelling corrections
  - s/\*\*/\*/ for comment above functions
  - Reorder the functions to appear as rmi_*_delegate* followed by rmi_*_undelegate*
  - WARN_ON if the RMM MemDonateReq:count exceeds the RmiAddrRangeDesc:count
  - Reject requests larger than MAX_PAGE_ORDER
  - Reject "donate" requests with states other than DELEGATED or UNDELEGATED
 ** Patch 6 - firmware: arm_rmm: Ensure the RMM has GPT entries for memory
  - Wrap comments to 80spaces.
  - Add a comment on ALIGN_DOWN the end of memory range.
  - Add is_rmm_active() to report if the RMM is in ACTIVE state
  - Switch errors to -ENODEV from -ENOMEM when RMM doesn't manage the region
  - Print error messages when RMI_GPT_INFO/RMI_GRANULE_TRACKIN_GET fails
 ** Patch 7 : arm64: Block hibernate and kexec while RMM is active
  - New patch in v20.
 ** Patch 8 : firmware: arm_rmm: Add wrappers for Realm related RMI commands
  - Use rmi_sro_memxfr_command() for rec_create - Catalin
 ** Patch 9 : firmware: arm_rmm: hotplug: Skip memory added to ZONE_MOVABLE
  - New patch in v20, relax the memory hotplug checking

Steven Price (7):
  firmware: arm_rmm: Add SMC definitions for calling the RMM
  firmware: arm_rmm: Check for RMI support at init
  firmware: arm_rmm: Configure the RMM with the host's page size
  firmware: arm_rmm: Add support for SRO
  firmware: arm_rmm: Activate the RMM
  firmware: arm_rmm: Ensure the RMM has GPT entries for memory
  firmware: arm_rmm: Add wrappers for Realm related RMI commands

Suzuki K Poulose (2):
  arm64: Block hibernate and kexec while RMM is active
  firmware: arm_rmm: hotplug: Skip memory added to ZONE_MOVABLE

 MAINTAINERS                       |    3 +
 arch/arm64/Kconfig                |    1 +
 arch/arm64/kernel/cpufeature.c    |    1 +
 arch/arm64/kernel/hibernate.c     |   14 +
 arch/arm64/kernel/machine_kexec.c |   11 +
 arch/arm64/kvm/sys_regs.c         |    2 +
 drivers/firmware/Kconfig          |    1 +
 drivers/firmware/Makefile         |    1 +
 drivers/firmware/arm_rmm/Kconfig  |   25 +
 drivers/firmware/arm_rmm/Makefile |    1 +
 drivers/firmware/arm_rmm/rmi.c    | 1128 +++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h      |  578 +++++++++++++++
 include/linux/arm-smccc-rmi.h     |  516 +++++++++++++
 include/linux/suspend.h           |    1 +
 kernel/power/hibernate.c          |    8 +-
 15 files changed, 2290 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/arm_rmm/Kconfig
 create mode 100644 drivers/firmware/arm_rmm/Makefile
 create mode 100644 drivers/firmware/arm_rmm/rmi.c
 create mode 100644 include/linux/arm-rmi-cmds.h
 create mode 100644 include/linux/arm-smccc-rmi.h

-- 
2.43.0

