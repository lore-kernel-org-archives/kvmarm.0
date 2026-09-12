Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0393414A17;
	Sat, 12 Sep 2026 08:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202207; cv=none; b=lK3X+gnnSM8TDhZsBCgVSFykep1QKdqdMAINXgaqEkyvRHws88hhKdV7DfQ79pi7LcRx2YBM36OPKrS3rnHgVtgDgpQOLdHHLChOBpQtiw1sbK9+78Sbt4DqLYY9rAf6aVEfIvB0D4VwGWSyd3D4h1S4HludoxtKSL2vPGHhlkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202207; c=relaxed/simple;
	bh=Madfil37iklqBWwDwN+tF7ssMu/O5QIcTM98UxdRCGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X1jeAoBWe72V06XkKCR+6oQH08267GYUxfkgCp4Y+BeKFLvsoSjJHzXdyvcoldUCkxkGwJ/mkUr1W9z+Hp8BNkkhPDLG7EoqGQPgPdy1f6yEOpjrucgl4rVn/JOPS0CjvPn2pNAuQEsW1va4B+x4ceCdEUQyYWDP5oNHXulP3ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UjPXWtGm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UjPXWtGm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E3911713;
	Sat, 12 Sep 2026 01:36:36 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 83BF63F7B4;
	Sat, 12 Sep 2026 01:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789202200; bh=Madfil37iklqBWwDwN+tF7ssMu/O5QIcTM98UxdRCGA=;
	h=From:To:Cc:Subject:Date:From;
	b=UjPXWtGmZNTQkURBTvsFkcW0halVDPz/n/I6K4oJPn7IE8YY3VBRSx38PVHphxVwj
	 qITrHGwMhv8ri7ktDp8ITAYzY69+giFmK+eZTY4KWk2Cz5lvYfbV1FdzprbYNE8L66
	 PegAhaXQtpNaK+UrfI9TWhE3J3UF25tXT4VEgiRs=
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
Subject: [PATCH v18 0/7] firmware: arm_rmm: Add RMM v2.0 base RMI support
Date: Sat, 12 Sep 2026 09:36:03 +0100
Message-ID: <20260912083611.2513845-1-suzuki.poulose@arm.com>
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

[1] RMM spec : https://support.arm.com/documentation/den0137/2-0bet3/
[2] This series: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/fw_rmm/v18
[3] KVM CCA v17 integration branch: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca/cca-host/kvm-v17/integration-v2
[4] Gmem inplace conversion https://github.com/googleprodkernel/linux-cc/tree/guest_memfd-inplace-conversion-v13
[5] TF-RMM https://git.trustedfirmware.org/TF-RMM/tf-rmm.git main (commit: 134266ae)
[6] kvmtool https://gitlab.arm.com/linux-arm/kvmtool-cca.git cca/kvm-v17-integration-v2

Known issues: RMMv2.0 spec.
 * RmiOpMemDonateReq:count (Uint14) is incompatible with RmiAddrRangeDesc4KB
  (Uint10) and RmiAddrRangeDesc16KB (Uint12). i.e., a larger contiguous request
  may not be satisfiable by the host. This is resolved in the RMM spec, by clamping
  the upper limit on the number to match the RmiAddrRangeDesc* and will be published
  in the next release.

Changes since v17:
 - All RMIs are now issued using smccc-v1.2 helpers as mandated by the RMM
 - Add a helper function to reclaim an RmiAddrRange entry, which may be partially
   consumed. Used by rmi_sro_free and by rmi_sro_donate_*contig to reclaim
   partially consumed granules.
 - Move all RMI wrappers that are used only by rmi.c out of the arm-rmi-cmds.h
 - Rename macros, varibles to match RMM spec
 - Handle buggy RMM cases and sanitise the output values
 - Change sro_state.addr_count to int, giving us better handling of overflows
   and RMM bugs.
 - Avoid splling literal pools on stack for sro initialisation.
 - Print error messages for critical failures during RMM init
 - Use scope based cleanup for SRO object
 - Prevent overflow for donated_granules output from buggy RMM
 - Handle corrupted addr_count in the sro
 - Handle buggy RMM when the out_top is not changed with RMI_SUCCESS
   for delegate/undelegate range calls
 - Rename free_delegated_page => rmi_free_delegated_page
 - Rename donate_req_to_unit_size => donate_req_to_block_size
 - Introduce rmi_addr_block_size_to_bytes() helper to convert a RmiAddrBlockSize
   encoding used in RMI_DONATE_REQ and RMI_ADDR_RANGE Descriptors, replaces
   donate_req_to_unit_size(). Matches the RMM spec.
 - Rename unit_size => block_size_fld, unit_size_bytes => block_size etc.
 - Explicitly check for MEM_CONTIG/CAN_CANCEL fields to match the RMM spec values.
 - Rename free_delegated_page => rmi_free_delegated_page()
 - Drop RMI_BUSY, RMI_BLOCKED checks from rmi_*delegate_range as they are already
   handled by the rmi_smccc_invoke() used by the SRO.
 - Ensure RMI_OP_RECLAIM output is valid before consumption
 - Use GENMASK()/BIT() for masks consistently for RMI SMCCC defintions
 - Rename RMI_{ADDR_RANGE, DONATE}_SIZE => RMI_{*}_BLOCK_SIZE
 - Reorder the definitions for MSB to LSB
 - Add definions for RMI_OP_MEM_*CONTIG and RMI_OP_CAN*_CANCEL


Steven Price (6):
  firmware: arm_rmm: Add SMC definitions for calling the RMM
  firmware: arm_rmm: Check for RMI support at init
  firmware: arm_rmm: Configure the RMM with the host's page size
  firmware: arm_rmm: Activate the RMM
  firmware: arm_rmm: Ensure the RMM has GPT entries for memory
  firmware: arm_rmm: Add wrappers for Realm related RMI commands

Suzuki K Poulose (1):
  firmware: arm_rmm: Add support for SRO

 arch/arm64/Kconfig                |   1 +
 arch/arm64/kernel/cpufeature.c    |   1 +
 drivers/firmware/Kconfig          |   1 +
 drivers/firmware/Makefile         |   1 +
 drivers/firmware/arm_rmm/Kconfig  |  26 +
 drivers/firmware/arm_rmm/Makefile |   2 +
 drivers/firmware/arm_rmm/rmi.c    | 999 ++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h      | 540 ++++++++++++++++
 include/linux/arm-smccc-rmi.h     | 497 +++++++++++++++
 9 files changed, 2068 insertions(+)
 create mode 100644 drivers/firmware/arm_rmm/Kconfig
 create mode 100644 drivers/firmware/arm_rmm/Makefile
 create mode 100644 drivers/firmware/arm_rmm/rmi.c
 create mode 100644 include/linux/arm-rmi-cmds.h
 create mode 100644 include/linux/arm-smccc-rmi.h

-- 
2.43.0

