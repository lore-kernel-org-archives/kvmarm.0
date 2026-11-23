Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430568;
	b=kXxJ3rjrz+QyTOeOQlPqRkKlXZhT4ll2SPpMycDXveOiS3tHxcCo/pq61JYsUDskikWX
	 48vKcmW8It7q6Y5OW7IDL+JO2R0Zb6enIVAEnx7z/mfu+ns+czzv3Yv7Blr+J5Hsai+Wv
	 1yFAuLXkFg+sR1a/BUq2HZ5eAN/n1vBp19o995ZKJdB1Kk9abwmYqK7rZz0OAkUBOmzAd
	 OAsTs2GDyddD49+yVz184EfbY89oAD7mlKIzpYXmW/hR5g9wntemQ6k1ncWux0dknUkLN
	 JR+hvMbojhpyEWgWhNuohlZJ4owRVH18AduBn691RHGTbBJ2wlsNMcXMyxWt0CKgWdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430568;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Be/8xc5ORGOFPfFJHIrsM95JcXKu+UwLET9LQk3L8R0=;
	b=jI663lIsT73Qrqa5Kkj5/FQgeKma6DsRWb8DLMrtMNrmlwDV1p/QXMNIZplsHpji/A2V
	 NSR6cIypVMEfbqVK/nR9UV8W2CQpsNwVoko+dbMjpU0tkqZnsID3gYFnMAUdFw205+Siw
	 6e+N2Zc8tbXO2O/0EUFS0yxBVEF50nd8iq3x0VVs13eoMzUGnxOz2q5Z5PSv6eeFlhVLS
	 tFv9J2YMsVi8xdpYbgWy5a3PeMQL8r8/wtuyNebnDI6qUB4S0d5IXJap/8F1e8f6OTHj/
	 1L7h2mpSoARe6BUMNJ75dao4gMfBmTYmpUb0BOorU6ySgfq9AGGGOwATZ/8p/03TKHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dMpXN6Jk;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC35606A336;
	Mon, 23 Nov 2026 10:42:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFC35606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dMpXN6Jk
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34B5D175D;
	Mon, 23 Nov 2026 02:42:44 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CF3C3F632;
	Mon, 23 Nov 2026 02:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795430567; bh=6OOoc7VR1HsEaaNieiQpuBPH2IyUlBC3LPyM0eQOoUE=;
	h=From:To:Cc:Subject:Date:From;
	b=dMpXN6Jk6PaxuEz6PytQ5F57ADGDhjyFXPrjYMqRSTAui9cUTO5hbHLgaDY4/kjH8
	 MBArU3H5JOUAILQ4JTvpeuq65gngelUudGofuSJJ3bTFQuJDZmEsDB1ym/b4qFzh6W
	 Owq/mj4aFDUAykFvQc/iN6ynR6YRd22E26as7rNQ=
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
Subject: [PATCH v4 00/11] KVM: arm64: CCA: Prepare Realm memory management
Date: Mon, 23 Nov 2026 10:42:20 +0000
Message-ID: <20261123104233.95710-1-steven.price@arm.com>
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
basic RMM support [1]. Thanks to everyone who reviewed and tested the
earlier versions.

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

Changes since v3:
- Keep pKVM-specific protected VM handling in the nVHE path and move
  stage-2 destruction dispatch before basic Realm infrastructure.
- Derive the Realm RTT start level from VTCR, matching KVM's minimum
  two-level stage-2 layout for narrow IPAs on 64K-page hosts.
- Split Realm guest_memfd and userspace-backed faults into dedicated
  paths, leaving the native fault handlers unchanged.
- Unmap earlier shared mappings when a later RMI map call fails.
- Clarify the early memslot validation rationale and the arm64-wide
  effect of in-place guest_memfd conversion.

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
    branch: cca-host-mm/v4/integration
[3] https://gitlab.arm.com/linux-arm/linux-cca
    branch: cca-host-mm/v4/mm

Steven Price (6):
  KVM: arm64: guest_memfd: Check mmap support when preparing memslot
  KVM: arm64: Dispatch stage-2 destruction by VM flavor
  KVM: arm64: CCA: Add basic infrastructure for creating a realm
  KVM: arm64: CCA: Destroy RTTs
  KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers
  KVM: arm64: CCA: Support runtime faulting of memory

Suzuki K Poulose (5):
  KVM: arm64: CCA: Introduce Realms
  KVM: arm64: Pass range filter to stage2_unmap_range
  KVM: Allow architectures to reject memslot changes before invalidation
  KVM: arm64: CCA: Prevent memslot modifications after Realm creation
  KVM: arm64: CCA: Add Realm stage-2 MMU operations

 arch/arm64/include/asm/kvm_emulate.h |  29 +
 arch/arm64/include/asm/kvm_host.h    |  27 +-
 arch/arm64/include/asm/kvm_mmu.h     |   4 +-
 arch/arm64/include/asm/kvm_rmi.h     | 105 +++
 arch/arm64/kvm/Kconfig               |   1 +
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/arm.c                 |  13 +-
 arch/arm64/kvm/mmu.c                 | 368 +++++++++--
 arch/arm64/kvm/pkvm.c                |   4 +-
 arch/arm64/kvm/psci.c                |   3 +-
 arch/arm64/kvm/rmi.c                 | 930 +++++++++++++++++++++++++++
 drivers/firmware/arm_rmm/rmi.c       |  10 -
 include/linux/arm-rmi-cmds.h         |   8 +
 include/linux/kvm_host.h             |   5 +
 virt/kvm/guest_memfd.c               |   6 +
 virt/kvm/kvm_main.c                  |  33 +-
 16 files changed, 1471 insertions(+), 77 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h
 create mode 100644 arch/arm64/kvm/rmi.c

-- 
2.43.0

