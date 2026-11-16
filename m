Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847458;
	b=YYF/8AluZJrEVXdWS0A9M4TiH2HUOnkaEaxNISWvYLROLv/2Y1nky2oDmBfFSvIeFRv8
	 lsbCBw3benhvIw3TpDqHYpx1JJV/WXyFd2P30CIaCJwAH6wqrexngLwD1VLIS4xdUTJ3O
	 3B2sZDnM4qKq94zyEOHUfiljpD1GxCTybWn8GOcWzHBoALDR0nhzQ/jCDyHxw6As1YmiX
	 xJXJ9dN8DkZZV7lyDGlAR4YugmBxlgnCP5hJZdt6XT54fbVa4Kz6gJOM3MRqmO4tpDvak
	 kdrnzvAS2kket962+TOhbVSJkJHzOc/okRHag9S3+iVOmXOvL9/5XM4fqDkjE7o4FPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847458;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=lT/WoOwTXjSmqC7OxU/dYF1bOEnGV2dmhj4zMjvVhqg=;
	b=s8rQNX0/FvNA8ojY+eitwIom57ZVbNEudvzg9o1vNaE+1dPQU1k9rKEpuNq1R+032gG5
	 iJTygibyXFHtYjIrVzT/5xoayayQ9FD+HeAmg0LTtJ6br/CU1qCu3JxZD/Dp7YdNFfj2b
	 6kl7OrumkxLIi+ppYlrzo30FxI6RRmO3FfFxQGVwI2bzlrKp/PKGbXxKjh7ey+vN0a37G
	 PbOWQDD2ecJLMxhwmFwGdIkjEn526qiWW71iPeW5c0nkY1uS+B2pFpeTaD3929ytEgxKw
	 YpFqbc1X096VI9orHpOqneNWC2XjqVO7X3C4/0SX3dZnzULkW4T1WWYZmZk9sL2YDCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fdJOCw9N;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A232F606A880;
	Mon, 16 Nov 2026 16:44:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A232F606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fdJOCw9N
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C230F143D;
	Mon, 16 Nov 2026 08:44:11 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FA343F763;
	Mon, 16 Nov 2026 08:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794847454; bh=LlgfU4eYhLtDCANkzWhzPmjCfDSk0a/FrbhPtr5bzfs=;
	h=From:To:Cc:Subject:Date:From;
	b=fdJOCw9N+/+3ztqVeQDCce4ONdqa5gkbEnNlsLvHJOL7u6+t1NV4joLj2UyXxy7FY
	 /sPaijSipnPwH/AcptFR+HmU/iysk2mMjy+XZLVLsn013aPN2dUjrm9fCdZfhWuode
	 IYusjEW/8lc3aMQEvnrzvRJf7R6aZXb+QGgYU5cE=
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Kohei Enju <enju.kohei@fujitsu.com>
Subject: [PATCH v3 00/11] KVM: arm64: CCA: Prepare Realm memory management
Date: Mon, 16 Nov 2026 16:43:46 +0000
Message-ID: <20261116164358.142785-1-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds the memory management plumbing for CCA, building on the
basic RMM support [1]. Thanks to everyone who reviewed and tested v2.

The patches introduce internal Realm VM state, prepare Realm stage-2
setup and teardown, and provide RTT mapping and invalidation helpers.
Realm memslots are restricted to the lower half of the IPA space because
the protected and shared halves alias each other. The final patch
connects the helpers to KVM's stage-2 MMU operations.

This is the memory management portion of the larger Realm host series.
Realm descriptor creation, REC entry and exit, activation, and the new
uAPI follow in the integration stack. This series alone does not enable
Realm creation.

The integration branch [2] includes Realm creation, REC entry and exit,
and the remaining host support on top of this series. The MM branch [3]
contains just this series.

Changes since v2:
- Move RMM mode reservation and RMI availability and feature checks to
  the integration stack.
- Require mmap-capable guest_memfd backing for all arm64 VMs and route
  all guest_memfd faults through gmem_abort().
- Store the Realm Descriptor physical address from initial Realm setup,
  and improve SRO cleanup and RTT teardown error handling.
- Use a local MMU cache for RTT invalidation, handle failed splits, and
  validate returned RTT levels.
- Bound protected RMI mapping calls to the encoded range and tighten
  RTT creation, retry, and error handling.
- Split common stage-2 destruction dispatch into its own patch before
  registering the Realm stage-2 MMU operations.

Changes since v1:
- Add a guest_memfd prerequisite patch that checks whether the backing
  file supports mmap when preparing an arm64 memslot.
- Combine the RMI availability and feature checks into one patch, and
  move Realm vCPU feature restrictions to the integration stack.
- Correct Realm IPA sizing and RTT teardown, including teardown before
  activation, RTT accounting, and handling of missing or folded RTTs.
- Rework RTT mapping to respect IPA and physical alignment, handle
  partial RMI progress, and retry interrupted operations.
- Preserve private mappings when a Realm guest_memfd memslot deletion is
  rejected, and tighten Realm fault handling and stage-2 destruction.

[1] https://lore.kernel.org/all/20261007073537.2454351-1-suzuki.poulose@arm.com/
[2] https://gitlab.arm.com/linux-arm/linux-cca
    branch: cca-host-mm/v3/integration
[3] https://gitlab.arm.com/linux-arm/linux-cca
    branch: cca-host-mm/v3/mm

Steven Price (6):
  KVM: arm64: guest_memfd: Check mmap support when preparing memslot
  KVM: arm64: CCA: Add basic infrastructure for creating a realm
  KVM: arm64: CCA: Tear down RTTs
  KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers
  KVM: arm64: CCA: Support runtime faulting of memory
  KVM: arm64: Dispatch stage-2 destruction by VM flavor

Suzuki K Poulose (5):
  KVM: arm64: CCA: Introduce Realms
  KVM: arm64: Handle attributes in stage2_unmap_range
  KVM: Allow architectures to reject memslot changes before invalidation
  KVM: arm64: CCA: Prevent memslot modifications after Realm creation
  KVM: arm64: CCA: Add Realm stage-2 MMU operations

 arch/arm64/include/asm/kvm_emulate.h   |  29 +
 arch/arm64/include/asm/kvm_host.h      |  52 +-
 arch/arm64/include/asm/kvm_mmu.h       |   4 +-
 arch/arm64/include/asm/kvm_rmi.h       | 103 +++
 arch/arm64/kvm/Kconfig                 |   1 +
 arch/arm64/kvm/Makefile                |   2 +-
 arch/arm64/kvm/arm.c                   |  16 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |   2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c       |   4 +-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c     |   2 +-
 arch/arm64/kvm/mmu.c                   | 291 ++++++--
 arch/arm64/kvm/pkvm.c                  |   4 +-
 arch/arm64/kvm/psci.c                  |   2 +-
 arch/arm64/kvm/rmi.c                   | 928 +++++++++++++++++++++++++
 drivers/firmware/arm_rmm/rmi.c         |  10 -
 include/linux/arm-rmi-cmds.h           |   8 +
 include/linux/kvm_host.h               |   5 +
 virt/kvm/guest_memfd.c                 |   6 +
 virt/kvm/kvm_main.c                    |  33 +-
 19 files changed, 1404 insertions(+), 98 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h
 create mode 100644 arch/arm64/kvm/rmi.c

-- 
2.43.0

