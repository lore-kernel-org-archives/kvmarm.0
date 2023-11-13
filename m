Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C6722EFB
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsyVobhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49390C433C8;
	Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699897424;
	bh=LZot5LSLKGFVViUkzTbvPTqxVYnoVhynEFbi3MG5bh4=;
	h=From:To:Cc:Subject:Date:From;
	b=WsyVobhVKnOB58EtnEkk4bQ1P8KaProQABFa9I+QovXTY9bDQJpZwIYFdh6pm/pOe
	 QnC89GSG6b0ejw79cSzxzvwPKJsdbQPx+fDjy5zMkc+AWIFactlsszVyZ8Vp/FIrjk
	 Xb0hXEJkZZJTaR0i/vZkZl5hEXRuwImwDAvETKk7iWQaE3DNqqZj71RXHV0SimZodl
	 OnBgqf9RbFWtPbtBkf7lzRMB+oZnStc2qi3R0/bZ4YqcT7ADCNE0brfb95lCQ2vxfz
	 dPFjc9b1nd7OYnPgZ5wNcEpUZFh+WrOi1lSMpe/oT649V0SimFEZxZFdvp8mrtC70y
	 2yNcDaRDZp+jQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r2ayK-00CkQ4-WE;
	Mon, 13 Nov 2023 17:43:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 00/12] arm64: Add support for FEAT_E2H0, or lack thereof
Date: Mon, 13 Nov 2023 17:42:32 +0000
Message-Id: <20231113174244.3026520-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

This series is a prefix for the next drop of NV support.

Marc Zyngier (12):
  arm64: cpufeatures: Correctly handle signed values
  arm64: cpufeature: Correctly display signed override values
  arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
  arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling
  arm64: cpufeature: Detect E2H0 not being implemented
  arm64: cpufeature: Detect HCR_EL2.NV1 being RES0
  arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is
    non-zero
  arm64: Add override for ID_AA64MMFR4_EL1.E2H0
  arm64: Add MIDR-based override infrastructure
  arm64: Add MIDR-based overrides for ID_AA64MMFR4_EL1.E2H0
  KVM: arm64: Expose ID_AA64MMFR4_EL1 to guests
  KVM: arm64: Force guest's HCR_EL2.E2H RES1 when NV1 is not implemented

 arch/arm64/include/asm/cpu.h         |  1 +
 arch/arm64/include/asm/cpufeature.h  |  2 +
 arch/arm64/include/asm/kvm_emulate.h |  3 +-
 arch/arm64/kernel/cpufeature.c       | 92 +++++++++++++++++++++++++---
 arch/arm64/kernel/cpuinfo.c          |  1 +
 arch/arm64/kernel/head.S             | 25 +++++---
 arch/arm64/kernel/idreg-override.c   | 65 ++++++++++++++++++++
 arch/arm64/kvm/nested.c              |  4 ++
 arch/arm64/kvm/sys_regs.c            | 14 ++++-
 arch/arm64/tools/cpucaps             |  2 +
 arch/arm64/tools/sysreg              | 37 +++++++++++
 11 files changed, 225 insertions(+), 21 deletions(-)

-- 
2.39.2

