Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F78834CC8
	for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 14:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDD8C433C7;
	Wed, 12 Jul 2023 14:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689173929;
	bh=480Ex+I67BuLKPVUPyqtEP991jxIiG64Qxv2L2yhxp0=;
	h=From:To:Cc:Subject:Date:From;
	b=DhYM4TzFzxv4ERRk9y1z2+ObPM/+jMKtMU98agWcBDinklrO3yR/Qf6mOMZMrEeyj
	 ndwNOOM7HJgGxPZBxaIqaIMvO0pXS20DQgTZXjD2CcOnIeN+GRamEfSWuwYNFt13RJ
	 QvYFGBkGftGzZMw25duEaFFw4XEBbAU3PJT7R43jpIXpzTVW1AT8LA7nusWhJ2MhyJ
	 4O6tcvDO80C+aI6Adc4uu2Fqau+mMuOEAGgPHj5+tXGH4EkUEjPIDDlrjSA/hLGYLm
	 zmpsM3vW037NdMvvTWFJ6AWGQUBlzKbxCeFl/KrlgjpvULQIDXYSV+Om268csCVRFv
	 AWu5RuaBrdCJw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qJbIl-00CUNF-AW;
	Wed, 12 Jul 2023 15:58:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 00/27] KVM: arm64: NV trap forwarding infrastructure
Date: Wed, 12 Jul 2023 15:57:43 +0100
Message-Id: <20230712145810.3864793-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As people are getting tired of seeing the full NV series, I've
extracted some of the easy stuff which I'm targeting for 6.6.

This implements the so called "trap forwarding" infrastructure, which
gets used when we take a trap from an L2 guest and that the L1 guest
wants to see the trap for itself.

Most of the series is pretty boring stuff, mostly a long list of
encodings which are mapped to a set of trap bits. I swear they are
correct. Sort of.

The interesting bit is around how we compute the trap result, which is
pretty complex due to the layers of crap the architecture has piled
over the years (a single op can be trapped by multiple coarse grained
trap bits, or a fine grained trap bit, which may itself be conditioned
by another control bit -- madness).

This also results in some rework of both the FGT stuff (for which I
carry a patch from Mark) and newly introduced the HCRX support.

With that (and the rest of the NV series[1]), FGT gets exposed to guests
and the trapping seems to work as expected.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.6-WIP

Marc Zyngier (26):
  arm64: Add missing VA CMO encodings
  arm64: Add missing ERX*_EL1 encodings
  arm64: Add missing DC ZVA/GVA/GZVA encodings
  arm64: Add TLBI operation encodings
  arm64: Add AT operation encodings
  arm64: Add debug registers affected by HDFGxTR_EL2
  arm64: Add missing BRB/CFP/DVP/CPP instructions
  arm64: Fix HFGxTR_EL2 field naming
  arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
  KVM: arm64: Correctly handle ACCDATA_EL1 traps
  KVM: arm64: Add missing HCR_EL2 trap bits
  KVM: arm64: nv: Add FGT registers
  KVM: arm64: Restructure FGT register switching
  KVM: arm64: nv: Add trap forwarding infrastructure
  KVM: arm64: nv: Add trap forwarding for HCR_EL2
  KVM: arm64: nv: Expose FEAT_EVT to nested guests
  KVM: arm64: nv: Add trap forwarding for MDCR_EL2
  KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
  KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
  KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
  KVM: arm64: nv: Add trap forwarding for HDFGxTR_EL2
  KVM: arm64: nv: Add SVC trap forwarding
  KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
  KVM: arm64: nv: Expose FGT to nested guests
  KVM: arm64: Move HCRX_EL2 switch to load/put on VHE systems
  KVM: arm64: nv: Add support for HCRX_EL2

Mark Brown (1):
  arm64: Add feature detection for fine grained traps

 arch/arm64/include/asm/kvm_arm.h        |   50 +
 arch/arm64/include/asm/kvm_host.h       |    7 +
 arch/arm64/include/asm/kvm_nested.h     |    2 +
 arch/arm64/include/asm/sysreg.h         |  270 +++-
 arch/arm64/kernel/cpufeature.c          |   11 +
 arch/arm64/kvm/arm.c                    |    4 +
 arch/arm64/kvm/emulate-nested.c         | 1703 +++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c            |   12 +
 arch/arm64/kvm/hyp/include/hyp/switch.h |  126 +-
 arch/arm64/kvm/nested.c                 |   11 +-
 arch/arm64/kvm/sys_regs.c               |   15 +
 arch/arm64/kvm/trace_arm.h              |   19 +
 arch/arm64/tools/cpucaps                |    1 +
 arch/arm64/tools/sysreg                 |  141 +-
 14 files changed, 2326 insertions(+), 46 deletions(-)

-- 
2.34.1

