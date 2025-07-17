Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0082BCF73;
	Thu, 17 Jul 2025 12:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752755001; cv=none; b=mRrmksUSxy5PUkkSYcOtp5v9DaVFVZj+PvW0ahcxCdygOWUYtfw7+LaS7o1blg1tcQjZVqFvv4F9wUgtBlbxiymFBSugCO9QaxFAHZs7NfRLisN+rCoqOH3RsimEuMK5zjRL0cDttK2wnLk3fELBV9G1EtT9lxFVtToTwTVKDWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752755001; c=relaxed/simple;
	bh=M53rRLCNKkngAVcTP3yYjTLxPORb3dP838zH8c0EAeo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BS//vzPgx97LPpYaxSKF9UFjX4IVN50q1IhBRKb061hr/33a+wy3/Q/8UVAbZS+48jQoIHdgUGdU//dXm/SHIfY27wXpznAQIVXC74cHQLZ4hzxOG+MjQQOIqH+NUBvGLgYWeFcALe0OuqGS8GFOfNLmoY2CGdo+QAGnBSjt+zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIvQ2uOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIvQ2uOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3341C4CEE3;
	Thu, 17 Jul 2025 12:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752754998;
	bh=M53rRLCNKkngAVcTP3yYjTLxPORb3dP838zH8c0EAeo=;
	h=From:To:Cc:Subject:Date:From;
	b=KIvQ2uOKfGL0kJgBh6WZe8351GfcqhX+SDK0dvb5rejhE1JIRzdyY5E5Eay5nEDpk
	 CMz/b0BBTYI69yYDIisErqoi5pxj+SNE/oop0dmaw4WPhN2DqIExZl53iPs0t0m4zR
	 hCtuT7MnE5ql5Qe7ajFPG0M9d/OZvW1Pkm6S/o8YqhMYKfymjdzd9SBgtIXCCSkzrT
	 4gdtKdhPycjFBYtefrbcN1qgUrwKa78vw3Cme0CSfzQNO+y6ccAcP571k9DCg3RS/Y
	 iBsWkA2NLV3qtxyvRVXf7c7aGU/0lwBKSOi5/GXa6PLLg1OInhNi+Ta3xDUhp7+Jal
	 a/9l4sTg3Dyxw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ucNdr-00Gbkc-CY;
	Thu, 17 Jul 2025 13:23:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Breno Leitao <leitao@debian.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Rob Herring <robh@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Timothy Hayes <timothy.hayes@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [GIT PULL] irqchip: Add GICv5 support
Date: Thu, 17 Jul 2025 13:23:06 +0100
Message-Id: <20250717122306.4043011-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: tglx@linutronix.de, leitao@debian.org, catalin.marinas@arm.com, conor+dt@kernel.org, Jonathan.Cameron@huawei.com, krzk+dt@kernel.org, lpieralisi@kernel.org, mark.rutland@arm.com, robh@kernel.org, sascha.bischoff@arm.com, timothy.hayes@arm.com, will@kernel.org, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Thomas,

After some time simmering in -next without much catching fire (only a
single regression has been reported, which was promptly fixed), here's
the pull request for the GICv5 core infrastructure.

There are still a couple of patches on the list (mostly addressing
error paths, and actively being reviewed), but I don't see anything
that would warrant holding this any longer, and these fixes can be
added down the line. If anything, this work has allowed us to
pipe-clean a number of issues in the tree.

Please note that the kvmarm tree also carries this branch, as this is
a dependency for enabling GICv3 compatibility for guests on a GICv5
host.

Please pull,

	M.

The following changes since commit 86731a2a651e58953fc949573895f2fa6d456841:

  Linux 6.16-rc3 (2025-06-22 13:30:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git tags/irqchip-gic-v5-host

for you to fetch changes up to 65a5520a27570787b17e6f0b093829fc7e0514e2:

  arm64: smp: Fix pNMI setup after GICv5 rework (2025-07-15 18:11:12 +0100)

----------------------------------------------------------------
GICv5 initial host support

Add host kernel support for the new arm64 GICv5 architecture, which is
quite a departure from the previous ones.

Include support for the full gamut of the architecture (interrupt
routing and delivery to CPUs, wired interrupts, MSIs, and interrupt
translation).

----------------------------------------------------------------
Lorenzo Pieralisi (30):
      dt-bindings: interrupt-controller: Add Arm GICv5
      arm64/sysreg: Add GCIE field to ID_AA64PFR2_EL1
      arm64/sysreg: Add ICC_PPI_PRIORITY<n>_EL1
      arm64/sysreg: Add ICC_ICSR_EL1
      arm64/sysreg: Add ICC_PPI_HMR<n>_EL1
      arm64/sysreg: Add ICC_PPI_ENABLER<n>_EL1
      arm64/sysreg: Add ICC_PPI_{C/S}ACTIVER<n>_EL1
      arm64/sysreg: Add ICC_PPI_{C/S}PENDR<n>_EL1
      arm64/sysreg: Add ICC_CR0_EL1
      arm64/sysreg: Add ICC_PCR_EL1
      arm64/sysreg: Add ICC_IDR0_EL1
      arm64/sysreg: Add ICH_HFGRTR_EL2
      arm64/sysreg: Add ICH_HFGWTR_EL2
      arm64/sysreg: Add ICH_HFGITR_EL2
      arm64: Disable GICv5 read/write/instruction traps
      arm64: cpucaps: Rename GICv3 CPU interface capability
      arm64: cpucaps: Add GICv5 CPU interface (GCIE) capability
      arm64: Add support for GICv5 GSB barriers
      irqchip/gic-v5: Add GICv5 PPI support
      irqchip/gic-v5: Add GICv5 IRS/SPI support
      irqchip/gic-v5: Add GICv5 LPI/IPI support
      irqchip/gic-v5: Enable GICv5 SMP booting
      of/irq: Add of_msi_xlate() helper function
      PCI/MSI: Add pci_msi_map_rid_ctlr_node() helper function
      irqchip/gic-v3: Rename GICv3 ITS MSI parent
      irqchip/msi-lib: Add IRQ_DOMAIN_FLAG_FWNODE_PARENT handling
      irqchip/gic-v5: Add GICv5 ITS support
      irqchip/gic-v5: Add GICv5 IWB support
      docs: arm64: gic-v5: Document booting requirements for GICv5
      arm64: Kconfig: Enable GICv5

Marc Zyngier (2):
      arm64: smp: Support non-SGIs for IPIs
      arm64: smp: Fix pNMI setup after GICv5 rework

 Documentation/arch/arm64/booting.rst               |   41 +
 .../interrupt-controller/arm,gic-v5-iwb.yaml       |   78 ++
 .../bindings/interrupt-controller/arm,gic-v5.yaml  |  267 +++++
 MAINTAINERS                                        |   10 +
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/include/asm/barrier.h                   |    3 +
 arch/arm64/include/asm/el2_setup.h                 |   45 +
 arch/arm64/include/asm/smp.h                       |   24 +-
 arch/arm64/include/asm/sysreg.h                    |   71 +-
 arch/arm64/kernel/cpufeature.c                     |   17 +-
 arch/arm64/kernel/smp.c                            |  142 ++-
 arch/arm64/tools/cpucaps                           |    3 +-
 arch/arm64/tools/sysreg                            |  495 +++++++-
 drivers/irqchip/Kconfig                            |   12 +
 drivers/irqchip/Makefile                           |    5 +-
 drivers/irqchip/irq-gic-common.h                   |    2 -
 ...3-its-msi-parent.c => irq-gic-its-msi-parent.c} |  168 ++-
 drivers/irqchip/irq-gic-its-msi-parent.h           |   12 +
 drivers/irqchip/irq-gic-v3-its.c                   |    1 +
 drivers/irqchip/irq-gic-v5-irs.c                   |  822 +++++++++++++
 drivers/irqchip/irq-gic-v5-its.c                   | 1228 ++++++++++++++++++++
 drivers/irqchip/irq-gic-v5-iwb.c                   |  284 +++++
 drivers/irqchip/irq-gic-v5.c                       | 1087 +++++++++++++++++
 drivers/irqchip/irq-gic.c                          |    2 +-
 drivers/irqchip/irq-msi-lib.c                      |    5 +-
 drivers/of/irq.c                                   |   22 +-
 drivers/pci/msi/irqdomain.c                        |   20 +
 include/asm-generic/msi.h                          |    1 +
 include/linux/irqchip/arm-gic-v5.h                 |  394 +++++++
 include/linux/irqdomain.h                          |    3 +
 include/linux/msi.h                                |    1 +
 include/linux/of_irq.h                             |    5 +
 32 files changed, 5199 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/arm,gic-v5-iwb.yaml
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/arm,gic-v5.yaml
 rename drivers/irqchip/{irq-gic-v3-its-msi-parent.c => irq-gic-its-msi-parent.c} (59%)
 create mode 100644 drivers/irqchip/irq-gic-its-msi-parent.h
 create mode 100644 drivers/irqchip/irq-gic-v5-irs.c
 create mode 100644 drivers/irqchip/irq-gic-v5-its.c
 create mode 100644 drivers/irqchip/irq-gic-v5-iwb.c
 create mode 100644 drivers/irqchip/irq-gic-v5.c
 create mode 100644 include/linux/irqchip/arm-gic-v5.h
