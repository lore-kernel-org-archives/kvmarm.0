Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE2793806D9;
	Wed, 15 Jul 2026 14:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125676; cv=none; b=mWMptcs7Rd9KKHKVNwV73ruxy6Lxb0ekjnTpj0ERiZ6qGK8M5oSQXe+XPfJqK5LupybP9lNvczGXS/EWp5jsXq+9tvToI964E1Y+LT8V/ldP911YRI971kllBpyPTampTdVMK9uOkDUqzCTEbiSERYDpZw02c8/IRx3v6/9kja4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125676; c=relaxed/simple;
	bh=agx27SYEr3SHHoleH5Fvz+cQz0XAcVmLenbj3oTpFHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sZQ+r7jxewpAjWJy/wuzb+oPaHc8/+dmTIA75cN+pgNgcYyHrJnTOubjYfgnT+YrENpCyIfpsrkaUOPEt5r6IqzqnPrg61ZPfCAPn7fZPyJu3zlzZe/wXihE/seecc695RwIaznVYRJBZ6u5C6pqIc1+UKDdAJ6fNuvdXDBsezE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j97V5XqG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j97V5XqG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D061152B;
	Wed, 15 Jul 2026 07:27:49 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A7693F7B4;
	Wed, 15 Jul 2026 07:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125673; bh=agx27SYEr3SHHoleH5Fvz+cQz0XAcVmLenbj3oTpFHU=;
	h=From:To:Cc:Subject:Date:From;
	b=j97V5XqGlfq4mWKOiZ9ORX3T4VRdaM3f0smUQ0IM8xReqAvG3EcRvSXeN4EoDS76K
	 d/9yTVPrcFfJZQurYsfD0C8/HHBzCPU3EJ0rl7AtYD/m0Q8Wat9sd5DJ1gSRW9K3US
	 6+24dp/jKRPQzH67bpgGQe1OHOsjbHCNyJVPRkX0=
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 0/6] firmware: arm_rmm: Add RMM v2.0 support
Date: Wed, 15 Jul 2026 15:27:31 +0100
Message-ID: <20260715142739.80398-1-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds the generic firmware layer for talking to the Realm
Management Monitor (RMM), as specified by the RMM v2.0-bet2
specification[1]. It is the first part of the Arm CCA host support that
was previously posted as part of the larger KVM series.

The split allows this RMM support to be used as a base for other work,
including Aneesh's changes, without depending on the KVM Realm support
that follows in the second series.

The series adds:

 * The RMI SMC definitions and direct-call wrappers.

 * RMM discovery and version checks during firmware init.

 * RMM host configuration, including the host page size.

 * Stateful RMI Operation (SRO) infrastructure for commands which the RMM
   can complete across multiple SMC calls while requesting or returning
   memory to the host.

 * GPT setup so that the RMM has entries for host memory.

The RMM v2.0 spec introduces Stateful RMI Operations (SROs), which allow
the RMM to complete an operation over several SMC calls while requesting
or returning memory to the host. This allows interrupts to be handled in
the middle of an operation and lets the RMM dynamically allocate memory
for internal tracking purposes. For example, RMI_REC_CREATE no longer
needs auxiliary granules to be provided up front, and can instead
request memory during the operation.

This series is based on v7.2-rc1 and Ackerley's guest_memfd in-place
series[2]. It is also available as a git repository along with the KVM
host support:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v15

The TF-RMM has now merged most of the RMM v2.0 support needed by this
series. The remaining PSCI changes have not yet merged; for testing those
changes are available in the following TF-RMM branch:

https://git.trustedfirmware.org/TF-RMM/tf-rmm.git topics/rmm-v2.0-poc_3

[1] https://developer.arm.com/documentation/den0137/2-0bet2/
Note that one bet2 change, which moves metadata out of the individual
address range descriptors, has intentionally not been implemented
because that part of the spec is expected to be reverted.

[2] https://lore.kernel.org/r/20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com
with Suzuki's fix on top:
https://lore.kernel.org/all/114e2488-97ed-4740-a8e8-1edd991f26c5@arm.com/

Steven Price (6):
  firmware: arm_rmm: Add SMC definitions for calling the RMM
  firmware: arm_rmm: Add wrappers for direct RMI calls
  firmware: arm_rmm: Check for RMI support at init
  firmware: arm_rmm: Configure the RMM with the host's page size
  firmware: arm_rmm: Add support for SRO
  firmware: arm_rmm: Ensure the RMM has GPT entries for memory

 arch/arm64/Kconfig                |   1 +
 arch/arm64/include/asm/rmi_cmds.h | 459 +++++++++++++++++++
 arch/arm64/kernel/cpufeature.c    |   1 +
 drivers/firmware/Kconfig          |   1 +
 drivers/firmware/Makefile         |   1 +
 drivers/firmware/arm_rmm/Kconfig  |  22 +
 drivers/firmware/arm_rmm/Makefile |   2 +
 drivers/firmware/arm_rmm/rmi.c    | 724 ++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h      | 205 +++++++++
 include/linux/arm-smccc-rmi.h     | 499 ++++++++++++++++++++
 10 files changed, 1915 insertions(+)
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 drivers/firmware/arm_rmm/Kconfig
 create mode 100644 drivers/firmware/arm_rmm/Makefile
 create mode 100644 drivers/firmware/arm_rmm/rmi.c
 create mode 100644 include/linux/arm-rmi-cmds.h
 create mode 100644 include/linux/arm-smccc-rmi.h

-- 
2.43.0

