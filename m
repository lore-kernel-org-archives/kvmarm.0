Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595B5101F2
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGXXSVUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257EBC433C9;
	Mon, 27 Nov 2023 11:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701085566;
	bh=w8L+IJQpA1loI06yEzPvwyfTQ1MlGyeDSKazqeYg884=;
	h=From:To:Cc:Subject:Date:From;
	b=TGXXSVUNwfcZ9o8UWUEcaRxMLFuwuwQ9d8A2n0h30Y13kqI6m/vtloOKuPxz6Pl1l
	 79h61o3yH8g8ckYBr8sWB+ijjyUXtNd3fkYoXHrOM7ubASuUyeqzrxv+yOlp7WmGEs
	 +K0J1eh7IXGCxa1BtUnQtpzbzzcmURJV36Y1+yoqm5djBGnRo8EOwkQOWwA8W9Yzis
	 tlkb6MtBtysijl4d9m+LnmrBU4d0QRKStbemX4SKeH/mUiWkV6Lni8KkELxwQDOjl+
	 G9wKczHqDyKN3KmBDCd9EJ4Z0kTivd5PSbUKyZ9JNKKvVZP9I5k7YH7VXgW4NEZT+e
	 OadM7TRo1vX5g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7a3v-00GleL-TX;
	Mon, 27 Nov 2023 11:46:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 00/13] arm64: Add support for FEAT_E2H0, or lack thereof
Date: Mon, 27 Nov 2023 11:45:46 +0000
Message-Id: <20231127114559.990314-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since ARMv8.1, the architecture has grown the VHE feature, which makes
EL2 a superset of EL1. With ARMv9.5 (and retroactively allowed from
ARMv8.1), the architecture allows implementations to have VHE as the
*only* implemented behaviour, meaning that HCR_EL2.E2H can be
implemented as RES1. As a follow-up, HCR_EL2.NV1 can also be
implemented as RES0, making the VHE-ness of the architecture
recursive.

This has a number of consequences, both at boot time and for KVM,
though the changes at that level are pretty minor.

The real meat of this series is on the cpufeature front, as FEAT_E2H0
is a *negative* feature, where 0b1111 (-1) represents E2H being RES1
and 0b1110 (-2) additionally indicates that NV1 is RES0. Fun, isn't
it?

As a bonus, a popular crop of non-compliant HW gets promoted as the
first batch of non-zero E2H0 users, making things easy for KVM.

This series is a prefix for the NV support. It also conflicts badly
with Ard's pre-LVA2 rework. FWIW, I've pushed out a resolution of the
conflict at [3].

* From v2 [2]:
  - Moved some SYS_FIELD_VALUE() usage to the correct patch
  - Fixed a couple of spelling mistakes
  - Picked RBs from Suzuki (thanks!)

* From v1 [1]:
  - Added a SYS_FIELD_VALUE() helper to handle the concatenation
    of various fields
  - Only test for the top bit of ID_AA64MMFR4_EL1.E2H0 to decide
    whether HCR_EL2.E2H is RES1.
  - Picked RBs from Oliver (thanks!)
  - Rebased on 6.7-rc2

[1] https://lore.kernel.org/r/20231113174244.3026520-1-maz@kernel.org
[2] https://lore.kernel.org/r/20231120123721.851738-1-maz@kernel.org
[3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=arm64/pre-lva2

Marc Zyngier (13):
  arm64: Add macro to compose a sysreg field value
  arm64: cpufeatures: Correctly handle signed values
  arm64: cpufeature: Correctly display signed override values
  arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
  arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling
  arm64: cpufeature: Detect E2H0 not being implemented
  arm64: cpufeature: Detect HCR_EL2.NV1 being RES0
  arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is
    negative
  arm64: Add override for ID_AA64MMFR4_EL1.E2H0
  arm64: Add MIDR-based override infrastructure
  arm64: Add MIDR-based overrides for ID_AA64MMFR4_EL1.E2H0
  KVM: arm64: Expose ID_AA64MMFR4_EL1 to guests
  KVM: arm64: Force guest's HCR_EL2.E2H RES1 when NV1 is not implemented

 arch/arm64/include/asm/cpu.h         |  1 +
 arch/arm64/include/asm/cpufeature.h  |  2 +
 arch/arm64/include/asm/kvm_emulate.h |  3 +-
 arch/arm64/include/asm/sysreg.h      |  5 +-
 arch/arm64/kernel/cpufeature.c       | 91 +++++++++++++++++++++++++---
 arch/arm64/kernel/cpuinfo.c          |  1 +
 arch/arm64/kernel/head.S             | 23 ++++---
 arch/arm64/kernel/idreg-override.c   | 65 ++++++++++++++++++++
 arch/arm64/kvm/nested.c              |  4 ++
 arch/arm64/kvm/sys_regs.c            | 17 +++++-
 arch/arm64/tools/cpucaps             |  2 +
 arch/arm64/tools/sysreg              | 37 +++++++++++
 12 files changed, 228 insertions(+), 23 deletions(-)

-- 
2.39.2

