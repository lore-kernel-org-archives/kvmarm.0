Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82602455613;
	Mon,  7 Sep 2026 09:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775202; cv=none; b=n9gu6xHzKCBza5Dpp2pCyg46EZ8poAknYVE9wCogTfRbeJKnyMmCY27sYVg4VS2j1wJUKaKo8KYoLTURvZApEfKZtWaR++hBPntyGsLjJMNoTw5WDCthDQNba3jQowZliUrFzbWM9bdji6xc9LfyGQbY398ckFgBVn85v5+6MmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775202; c=relaxed/simple;
	bh=KmMaMXcfwTD1uw/ZX1oD+IzGdx2wwUgc5E+inECDMNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ivfeKE5+BoYp9+xEL6ye4SUaWlJpy+A/xEww3iNp5ckqLEx9XchGxL/PxhezMKb1x+vFTJ9UtC/rZQBVYkpN/FgVdp7tl9q6lRxj7JXjhG02o08/6r8tmjQkKNqrt2jfgIcyzinwLU396XRRjb5n0A9XL2tGTroSN7AiNVOLbb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cm5PZxv9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cm5PZxv9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F3AC1476;
	Mon,  7 Sep 2026 02:59:55 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0A13F3F7B4;
	Mon,  7 Sep 2026 02:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788775198; bh=KmMaMXcfwTD1uw/ZX1oD+IzGdx2wwUgc5E+inECDMNc=;
	h=From:To:Cc:Subject:Date:From;
	b=cm5PZxv990H8BGNP0OfTXDtvAW1KHxnnVcsm99FIKeGdMRdSLBSP347xtDstvUzDJ
	 Pfaxm+qhl52HzmCTBD89wlMedknLopfALCJCcyfQbp6DrR9p4k5/i2gg5xP6GzeuXh
	 3bWP9JjSoacdERjSw9HgrOkyiBXd3rkjfNsLCloI=
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
Subject: [PATCH v17 0/7] firmware: arm_rmm: Add RMM v2.0 base RMI support
Date: Mon,  7 Sep 2026 10:59:34 +0100
Message-ID: <20260907095942.1140734-1-suzuki.poulose@arm.com>
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

This series applies on v7.3-rc1 and a branch is available at [2]. The KVM
CCA support that builds on this series is available at [3] as an integration
branch. The KVM support depends on guest-memfd-in-place conversion support v12
from Ackerley [4], we plan to split that into parts, which apply cleanly on
v7.3-rcx without any dependency and is in progress. This will be made available
as soon as it is ready. Until then [3] shows how this base series enables KVM
CCA support. You may find the tf-RMM [5] and kvmtool support [6] below.

[1] RMM spec : https://support.arm.com/documentation/den0137/2-0bet3/
[2] This series: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/fw_rmm/v17
[3] KVM CCA v17 integration branch: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/kvm-integration/v17
[4] Gmem inplace conversion https://github.com/googleprodkernel/linux-cc/tree/guest_memfd-inplace-conversion-v12
[5] TF-RMM https://git.trustedfirmware.org/TF-RMM/tf-rmm.git main (commit: 134266ae)
[6] kvmtool https://gitlab.arm.com/linux-arm/kvmtool-cca.git cca/kvm-v17

Known issues: RMMv2.0
 * RmiOpMemDonateReq:count (Uint14) is incompatible with RmiAddrRangeDesc4KB
  (Uint10) and RmiAddrRangeDesc16KB (Uint12). i.e., a larger contiguous request
  may not be satisfiable by the host. Arm is aware of this defect and a spec fix
  is in progress.


Steven Price (7):
  firmware: arm_rmm: Add SMC definitions for calling the RMM
  firmware: arm_rmm: Check for RMI support at init
  firmware: arm_rmm: Configure the RMM with the host's page size
  firmware: arm_rmm: Add support for SRO
  firmware: arm_rmm: Activate the RMM
  firmware: arm_rmm: Ensure the RMM has GPT entries for memory
  firmware: arm_rmm: Add wrappers for Realm related RMI commands

 arch/arm64/Kconfig                |   1 +
 arch/arm64/kernel/cpufeature.c    |   1 +
 drivers/firmware/Kconfig          |   1 +
 drivers/firmware/Makefile         |   1 +
 drivers/firmware/arm_rmm/Kconfig  |  26 +
 drivers/firmware/arm_rmm/Makefile |   2 +
 drivers/firmware/arm_rmm/rmi.c    | 819 ++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h      | 678 +++++++++++++++++++++++++
 include/linux/arm-smccc-rmi.h     | 494 ++++++++++++++++++
 9 files changed, 2023 insertions(+)
 create mode 100644 drivers/firmware/arm_rmm/Kconfig
 create mode 100644 drivers/firmware/arm_rmm/Makefile
 create mode 100644 drivers/firmware/arm_rmm/rmi.c
 create mode 100644 include/linux/arm-rmi-cmds.h
 create mode 100644 include/linux/arm-smccc-rmi.h

-- 
2.43.0

