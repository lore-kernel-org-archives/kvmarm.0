Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDD92C859;
	Mon,  1 Jul 2024 09:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719827722; cv=none; b=TQlln4LiYdPffPsoCPlAguacH4Bp0dJVZEeTjXBUSO7uVqhsNH0q7x3ewwz01mF/8/qrPM33HGHPltHVu3t+mWvkSYld1aqu9cSrc22gy2JKcOLoBOTlKtRpfsxzavffirfD1Dqgxj7wE61KdMtNDLgp1CuPJEfg64KRMUrH6LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719827722; c=relaxed/simple;
	bh=OggWIOikETqCuIyJ9gVeBHTVrbKuXcdJ+5yR+9XEoSs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TpiMcTKxPmd4i0y1bB3Ti0GCwLEW3k7Rs1Ry92ZWQRHqhDCuCmFUu8gFaLc8ekGIL0IcuWgeKL9c0iekdRnfxNTQn3pTv2yIqGRPXxiKVNAbSHYHK7iv9LM/6oErflS/GSB1y2cXkSbeEHpC8B1n92PhbjyTivzyJfW7rS98QPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C585339;
	Mon,  1 Jul 2024 02:55:43 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.44.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08CAC3F762;
	Mon,  1 Jul 2024 02:55:14 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v4 00/15] arm64: Support for running as a guest in Arm CCA
Date: Mon,  1 Jul 2024 10:54:50 +0100
Message-Id: <20240701095505.165383-1-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for running Linux in a protected VM under the
Arm Confidential Compute Architecture (CCA). This has been updated
following the feedback from the v3 posting[1]. Thanks for the feedback!
Individual patches have a change log. But things to highlight:

 * a new patch ("firmware/psci: Add psci_early_test_conduit()") to
   prevent SMC calls being made on systems which don't support them -
   i.e. systems without EL2/EL3 - thanks Jean-Philippe!

 * two patches dropped (overriding set_fixmap_io). Instead
   FIXMAP_PAGE_IO is modified to include PROT_NS_SHARED. When support
   for assigning hardware devices to a realm guest is added this will
   need to be brought back in some form. But for now it's just adding
   complixity and confusion for no gain.

 * a new patch ("arm64: mm: Avoid TLBI when marking pages as valid")
   which avoids doing an extra TLBI when doing the break-before-make.
   Note that this changes the behaviour in other cases when making
   memory valid. This should be safe (and saves a TLBI for those cases),
   but it's a separate patch in case of regressions.

 * GIC ITT allocation now uses a custom genpool-based allocator. I
   expect this will be replaced with a generic way of allocating
   decrypted memory (see [4]), but for now this gets things working
   without wasting too much memory.

The ABI to the RMM from a realm (the RSI) is based on the final RMM v1.0
(EAC 5) specification[2]. Future RMM specifications will be backwards
compatible so a guest using the v1.0 specification (i.e. this series)
will be able to run on future versions of the RMM without modification.

This series is based on v6.10-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v4

This series (the guest side) should be in a good state so please review
with the intention that this could be merged soon. The host side will
require more iteration so the versioning of the series will diverge -
so for now continue to use v3 for the host support.

Introduction (unchanged from v2 posting)
============
A more general introduction to Arm CCA is available on the Arm
website[3], and links to the other components involved are available in
the overall cover letter.

Arm Confidential Compute Architecture adds two new 'worlds' to the
architecture: Root and Realm. A new software component known as the RMM
(Realm Management Monitor) runs in Realm EL2 and is trusted by both the
Normal World and VMs running within Realms. This enables mutual
distrust between the Realm VMs and the Normal World.

Virtual machines running within a Realm can decide on a (4k)
page-by-page granularity whether to share a page with the (Normal World)
host or to keep it private (protected). This protection is provided by
the hardware and attempts to access a page which isn't shared by the
Normal World will trigger a Granule Protection Fault.

Realm VMs can communicate with the RMM via another SMC interface known
as RSI (Realm Services Interface). This series adds wrappers for the
full set of RSI commands and uses them to manage the Realm IPA State
(RIPAS) and to discover the configuration of the realm.

The VM running within the Realm needs to ensure that memory that is
going to use is marked as 'RIPAS_RAM' (i.e. protected memory accessible
only to the guest). This could be provided by the VMM (and subject to
measurement to ensure it is setup correctly) or the VM can set it
itself.  This series includes a patch which will iterate over all
described RAM and set the RIPAS. This is a relatively cheap operation,
and doesn't require memory donation from the host. Instead, memory can
be dynamically provided by the host on fault. An alternative would be to
update booting.rst and state this as a requirement, but this would
reduce the flexibility of the VMM to manage the available memory to the
guest (as the initial RIPAS state is part of the guest's measurement).

Within the Realm the most-significant active bit of the IPA is used to
select whether the access is to protected memory or to memory shared
with the host. This series treats this bit as if it is attribute bit in
the page tables and will modify it when sharing/unsharing memory with
the host.

This top bit usage also necessitates that the IPA width is made more
dynamic in the guest. The VMM will choose a width (and therefore which
bit controls the shared flag) and the guest must be able to identify
this bit to mask it out when necessary. PHYS_MASK_SHIFT/PHYS_MASK are
therefore made dynamic.

To allow virtio to communicate with the host the shared buffers must be
placed in memory which has this top IPA bit set. This is achieved by
implementing the set_memory_{encrypted,decrypted} APIs for arm64 and
forcing the use of bounce buffers. For now all device access is
considered to required the memory to be shared, at this stage there is
no support for real devices to be assigned to a realm guest - obviously
if device assignment is added this will have to change.

Finally the GIC is (largely) emulated by the (untrusted) host. The RMM
provides some management (including register save/restore) but the
ITS buffers must be placed into shared memory for the host to emulate.
There is likely to be future work to harden the GIC driver against a
malicious host (along with any other drivers used within a Realm guest).

[1] https://lore.kernel.org/lkml/20240605093006.145492-1-steven.price%40arm.com
[2] https://developer.arm.com/documentation/den0137/1-0eac5/
[3] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
[4] https://lore.kernel.org/lkml/ZmNJdSxSz-sYpVgI%40arm.com

Jean-Philippe Brucker (1):
  firmware/psci: Add psci_early_test_conduit()

Sami Mujawar (2):
  arm64: rsi: Interfaces to query attestation token
  virt: arm-cca-guest: TSM_REPORT support for realms

Steven Price (7):
  arm64: realm: Query IPA size from the RMM
  arm64: Mark all I/O as non-secure shared
  arm64: Make the PHYS_MASK_SHIFT dynamic
  arm64: Enforce bounce buffers for realm DMA
  arm64: mm: Avoid TLBI when marking pages as valid
  irqchip/gic-v3-its: Share ITS tables with a non-trusted hypervisor
  irqchip/gic-v3-its: Rely on genpool alignment

Suzuki K Poulose (5):
  arm64: rsi: Add RSI definitions
  arm64: Detect if in a realm and set RIPAS RAM
  arm64: Enable memory encrypt for Realms
  arm64: Force device mappings to be non-secure shared
  efi: arm64: Map Device with Prot Shared

 arch/arm64/Kconfig                            |   3 +
 arch/arm64/include/asm/fixmap.h               |   2 +-
 arch/arm64/include/asm/io.h                   |   8 +-
 arch/arm64/include/asm/mem_encrypt.h          |  17 ++
 arch/arm64/include/asm/pgtable-hwdef.h        |   6 -
 arch/arm64/include/asm/pgtable-prot.h         |   3 +
 arch/arm64/include/asm/pgtable.h              |  13 +-
 arch/arm64/include/asm/rsi.h                  |  64 ++++++
 arch/arm64/include/asm/rsi_cmds.h             | 134 +++++++++++
 arch/arm64/include/asm/rsi_smc.h              | 142 ++++++++++++
 arch/arm64/include/asm/set_memory.h           |   3 +
 arch/arm64/kernel/Makefile                    |   3 +-
 arch/arm64/kernel/efi.c                       |   2 +-
 arch/arm64/kernel/rsi.c                       | 104 +++++++++
 arch/arm64/kernel/setup.c                     |   8 +
 arch/arm64/mm/init.c                          |  10 +-
 arch/arm64/mm/pageattr.c                      |  76 ++++++-
 drivers/firmware/psci/psci.c                  |  25 +++
 drivers/irqchip/irq-gic-v3-its.c              | 142 +++++++++---
 drivers/virt/coco/Kconfig                     |   2 +
 drivers/virt/coco/Makefile                    |   1 +
 drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
 drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
 .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
 include/linux/psci.h                          |   5 +
 25 files changed, 953 insertions(+), 44 deletions(-)
 create mode 100644 arch/arm64/include/asm/mem_encrypt.h
 create mode 100644 arch/arm64/include/asm/rsi.h
 create mode 100644 arch/arm64/include/asm/rsi_cmds.h
 create mode 100644 arch/arm64/include/asm/rsi_smc.h
 create mode 100644 arch/arm64/kernel/rsi.c
 create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c

-- 
2.34.1

