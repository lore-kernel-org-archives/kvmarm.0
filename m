Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8FD71D435F;
	Thu, 17 Oct 2024 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170892; cv=none; b=J3fYKn3wruHUZyV6VeqBit2gyME6/OZl1vurU4gkwmKHXe05oqEK9Deu20Bi5Bxpw32+GW0zVniFjA/CEMsFuXiAIWqGiS044b14mxPgbJhX/uahPf6SdFOE1iNXrmuEKMHW50AghU6FcxRI/AGJoeHlq80OUyWLo6YIp8WK0gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170892; c=relaxed/simple;
	bh=k1b4Z/arKRmCiQYswwQStzqw3B3x8CNEVrfSGrBQTmw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rzDELSnkoyArHPzYk33rqv7aJScmOex1byjFbGPXRNJUR5LrVSK7Aet8N4XbhF3i/63wg7nx7GA1iULvFRlGH7ULqPOKf6wvgpZBxG+HHmbnhwWAPjyIvV00SeVKpf9Rnad6vNKSI788b0ai7spidGwPH+mDxCUVsnzyPCqzMK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE1B8FEC;
	Thu, 17 Oct 2024 06:15:16 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D7C13F71E;
	Thu, 17 Oct 2024 06:14:42 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v7 00/11] arm64: Support for running as a guest in Arm CCA
Date: Thu, 17 Oct 2024 14:14:23 +0100
Message-Id: <20241017131434.40935-1-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for running Linux in a protected VM under the
Arm Confidential Compute Architecture (CCA). This is a minor update
following the feedback from the v6 posting[1]. Thanks for the feedback!

Individual patches have a change log. The biggest changes are in patch
10 where Gavin gave some great feedback to tidy things up a bit.

This series is based on v6.12-rc1.

Testing
=======

Since a couple of the patches have been merged separately, and there was
also a bug[2] in -rc1 which impacts 9p filesystems, I've provided the
below git tree with everything you need for a CCA guest:

https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v7

Back by popular demand is also a tree with both host and guest changes:

https://gitlab.arm.com/linux-arm/linux-cca cca-full/v5+v7

You will also need an up-to-date RMM - the necessary changes have been
merged into the 'main' branch of upstream:

https://git.trustedfirmware.org/TF-RMM/tf-rmm.git main

And you also need an updated kvmtool, there's a branch with the
necessary changes here:

https://git.gitlab.arm.com/linux-arm/kvmtool-cca.git cca/v3

earlycon
--------

If using 'earlycon' on the kernel command line it is now necessary to
pass the address of the serial port *in the unprotected IPA*. This is
because the fixmap changes were dropped (due to the late probing of the
RMM). E.g. for kvmtool you will need:

  earlycon=uart,mmio,0x101000000

This is the main drawback to late probing. One potential improvement
would be an option like "earlycon=realm" to identify that the earlycon
uart is in the unprotected space without having to know the actual IPA.
I've left this out for now as I'm not sure whether there is any actual
interest in this.

[1] https://lore.kernel.org/r/20241004144307.66199-1-steven.price%40arm.com
[2] https://lore.kernel.org/all/cbaf141ba6c0e2e209717d02746584072844841a.1727722269.git.osandov@fb.com/

Sami Mujawar (1):
  virt: arm-cca-guest: TSM_REPORT support for realms

Steven Price (4):
  arm64: realm: Query IPA size from the RMM
  arm64: Enforce bounce buffers for realm DMA
  arm64: mm: Avoid TLBI when marking pages as valid
  arm64: Document Arm Confidential Compute

Suzuki K Poulose (6):
  arm64: rsi: Add RSI definitions
  arm64: Detect if in a realm and set RIPAS RAM
  arm64: rsi: Add support for checking whether an MMIO is protected
  arm64: rsi: Map unprotected MMIO as decrypted
  efi: arm64: Map Device with Prot Shared
  arm64: Enable memory encrypt for Realms

 Documentation/arch/arm64/arm-cca.rst          |  69 ++++++
 Documentation/arch/arm64/booting.rst          |   3 +
 Documentation/arch/arm64/index.rst            |   1 +
 arch/arm64/Kconfig                            |   3 +
 arch/arm64/include/asm/io.h                   |   8 +
 arch/arm64/include/asm/mem_encrypt.h          |   9 +
 arch/arm64/include/asm/pgtable-prot.h         |   4 +
 arch/arm64/include/asm/pgtable.h              |   5 +
 arch/arm64/include/asm/rsi.h                  |  68 ++++++
 arch/arm64/include/asm/rsi_cmds.h             | 160 +++++++++++++
 arch/arm64/include/asm/rsi_smc.h              | 193 +++++++++++++++
 arch/arm64/include/asm/set_memory.h           |   3 +
 arch/arm64/kernel/Makefile                    |   3 +-
 arch/arm64/kernel/efi.c                       |  12 +-
 arch/arm64/kernel/rsi.c                       | 142 +++++++++++
 arch/arm64/kernel/setup.c                     |   3 +
 arch/arm64/mm/init.c                          |  10 +-
 arch/arm64/mm/pageattr.c                      |  98 +++++++-
 drivers/virt/coco/Kconfig                     |   2 +
 drivers/virt/coco/Makefile                    |   1 +
 drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
 drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
 .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 224 ++++++++++++++++++
 23 files changed, 1026 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/arch/arm64/arm-cca.rst
 create mode 100644 arch/arm64/include/asm/rsi.h
 create mode 100644 arch/arm64/include/asm/rsi_cmds.h
 create mode 100644 arch/arm64/include/asm/rsi_smc.h
 create mode 100644 arch/arm64/kernel/rsi.c
 create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c

-- 
2.34.1

