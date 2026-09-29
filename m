Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A633713FEE;
	Tue, 29 Sep 2026 22:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790720201; cv=none; b=kf4NUA5b9JfECjMIWeMWq3/BXq2UKVFlS7KWEsJ5KS8aBnUMPPv6PnFr2a7lGEo0H/6kbY4YScDgfl4PlKwV4ncFupHQBwSUDcNIKJ5gIZJvFdpMGMIiFiT+r97tr+c6HTXIRuMRDH4+sQskgJYi+J2s6I2L5YFy3VRVugYjaYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790720201; c=relaxed/simple;
	bh=1NT+wfwfNpVcFzjc6PeZ85Jz2K91YU1fR6/05gtWZGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bXH7QtQEYZo2XemiyZktoWVfUVZOXJTI32BaLXNTI1+EiZXJiU7z7dHptL8Q9kWPdNl3sWZJB+INlteWpOP5+NxkjjJ2PJqe4bZOz25IXZyB8yDGM6xrPVkjU4eml7e+yyIRRILz6Tp+E/oOS99COPdqRi/GuOFryDwW6JqZ144=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OGIHiMQi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OGIHiMQi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61C831477;
	Tue, 29 Sep 2026 15:16:34 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3C1C73F85F;
	Tue, 29 Sep 2026 15:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790720197; bh=1NT+wfwfNpVcFzjc6PeZ85Jz2K91YU1fR6/05gtWZGE=;
	h=From:To:Cc:Subject:Date:From;
	b=OGIHiMQisZDZhWt1prJPC3NgAe/eKDAcWfRt35iNiYlrAin18Z8p8K1LJ+SeJ3qDJ
	 JqIhrGRO3ZbivEhd4G6zzhesGjOqbsK2amXJ5lko2N6gifeVRv8zxda2GkeR3abtkb
	 gzmlP4Evd0gNCpJqPPQ3x9Ne7RTcYxjE+MjIXN3U=
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
Subject: [PATCH v20 0/9] firmware: arm_rmm: Add RMM v2.0 base RMI support
Date: Tue, 29 Sep 2026 23:16:14 +0100
Message-ID: <20260929221623.1342076-1-suzuki.poulose@arm.com>
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
[2] This series: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/fw_rmm/v20
[3] KVM CCA v21 integration branch: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca/cca-host/kvm-v21/integration
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

Changes since v18:
 - Use _ULL version for masks spanning beyond 32bits
 - Add GENMASK, FIELD_* friends for RMI_ABI_VERSION_*
 - Consistent naming for masks and order the fields by MSB to LSB (missed out
   ones.
 - Rename RMI_RETURN_ => RMI_RESULT, RMI_RETURN_INDEX => RMI_RESULT_DATA_LEVEL
   and add relevant Rmi types for clear indication on what they represent.
 - Read and cache all implemented RmiFeatureRegisters (5), use ARRAY_SIZE()
   droping the macro for the number of registers.
 - Fold sinlge caller rmi calls to the caller (rmi_features)
 - Drop "default y" from Kconfig
 - Don't loop forever with RMI_BLOCKED, instead retry once and return to the
   caller.
 - Move rmi_config_set closer to rmi_configure.
 - Use __free() cleanup for rmm_config object
 - SRO: Clamp the mem donate request count to RMI_MAX_ADDR_LIST (the max we can
   hold in the struct sro, to prevent overflows in handling non_contig requests
 - Donate gathered memory when sro list runs out of space for non_contig case
   and donate the rest in the next iteration
 - Fix handling of buggy RMM for rmi_delegate_range()
 - Add comments for the exported interfaces rmi_delegate_range(), rmi_undelegate_range()
 - Move rmi_granule_{,un}delegate_range() closer to their callers
 - Clarify the requirements for rmi_granule_delegate_range()
 - Fix return result to -ENXIO if the MEM_OP is unknown
 - Handle unsupported RMI_OP_MEM_CONDITIONAL, bail out early
 - Rename "out" lable to mem_donate, where the actual donation happens
 - Switch to use readable loop construct in donate_noncontig, add comments
   to explain what we do.
 - Add comment, make the code reader friendly for caching the entries not
   consumed by RMM.
 - Add documentatoin for rmi_sro_execute()
 - Avoid mixing gotos with __free cleanups for arm64_init_rmi()
 - Convert the remaining nested if for results to early return based.
 - Pass out_top for RMI_ERROR_RTT in rmi_rtt_destroy() [ This boosts the
   Realm tear down ]


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
 arch/arm64/kernel/hibernate.c     |    6 +
 arch/arm64/kernel/machine_kexec.c |   11 +
 arch/arm64/kvm/sys_regs.c         |    2 +
 drivers/firmware/Kconfig          |    1 +
 drivers/firmware/Makefile         |    1 +
 drivers/firmware/arm_rmm/Kconfig  |   25 +
 drivers/firmware/arm_rmm/Makefile |    1 +
 drivers/firmware/arm_rmm/rmi.c    | 1129 +++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h      |  567 +++++++++++++++
 include/linux/arm-smccc-rmi.h     |  516 +++++++++++++
 13 files changed, 2264 insertions(+)
 create mode 100644 drivers/firmware/arm_rmm/Kconfig
 create mode 100644 drivers/firmware/arm_rmm/Makefile
 create mode 100644 drivers/firmware/arm_rmm/rmi.c
 create mode 100644 include/linux/arm-rmi-cmds.h
 create mode 100644 include/linux/arm-smccc-rmi.h

-- 
2.43.0

