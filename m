Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B131D184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06BBC433D7;
	Sat, 12 Nov 2022 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266262;
	bh=GZjmzw1ibtw+B1iJxghd/S9qEjIWCljoh1tIsGJiPRk=;
	h=From:To:Cc:Subject:Date:From;
	b=b33EE4eLSu+McltJdb63p/3NYU4XYT9FjxR7nVYNGChjxbr5dn3yMraSpkYrV3QaA
	 EOAtaIlTw/+/hbq15G7fiuCuDapdcV8GZedmXcWgtiPKfo2gl1dVxfVerLFWoX+jQu
	 SjtE3v9wvBD+air4azfMv0f5cHAkUFKZAt1S9DM2vLadsQrRXjnCySMJWOYFwhC0ip
	 dQ3I5g8ssP9yy/qZWmKlsTB8RlKMkzxd9gBAeUeHmaS07ezUVX5RDg8NF9k/HrxYbK
	 EnoBmSP08adi6uaEp/WZvpZeVa8fAlQ4HUhSMeaj1ORPAqXiVdy6LnMq/P/GhiUoHr
	 mShrQ85R6lbWQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 00/14] arm64/nmi: Support for FEAT_NMI
Date: Sat, 12 Nov 2022 15:16:54 +0000
Message-Id: <20221112151708.175147-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4827; i=broonie@kernel.org; h=from:subject; bh=GZjmzw1ibtw+B1iJxghd/S9qEjIWCljoh1tIsGJiPRk=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7jlx1y/HRMDRo/yF3+EqIKhRHaWx2CWb/PPPRq5 NRhMhZeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+45QAKCRAk1otyXVSH0CSKB/ 4j6xhXAoZXhm2SDJo2w9XGgOYaW3q1oqzlkieSFStGs2w/a4qYVp1TU/NALROrhfXYcbOvITbCz3Nc gDo5leZss2o/3jVfXJJf7iGC4sH6+V9qZhR1IKdUtuEd2wdM/mGu0pW4eCocuPcCUudEl0oPyi2E8U tMi06PT+f+QovJHBB8NGtsUZdqyeQ1jS+X6C/gLOVN3bpt450s/G1MhuHd2bxM3kt4WnshiBhwgzCv 85Rwgew7d1jeqnLi8nrVUm/vbZ4gelljPiQoFi7g7jn7nli/JFvc+3obLOZ4E1mSSv/VZ8iPa2sPri cMBhoR+wmF2ztrX8imwKr4gHPT3n+k
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

This series enables the architecture and GIC support for the arm64
FEAT_NMI and FEAT_GICv3_NMI extensions in host kernels. These introduce
support for a new category of interrupts in the architecture code which
we can use to provide NMI like functionality, though the interrupts are
in fact maskable as the name would not imply. The GIC support was done
by Loreozo Pieralisi.

There are two modes for using this FEAT_NMI, the one we use is the one
where SCTLR_EL1.SPINTMASK is set which means that any entry to ELn
causes all interrupts including those with superpriority to be masked by
a new mask bit PSTATE.ALLINT on entry to ELn until the mask is
explicitly removed by software. PSTATE.ALLINT can be managed by software
using the new register control ALLINT.ALLINT.  Independent controls are
provided for this feature at each EL, usage at EL1 should not disrupt
EL2 or EL3.

To simplify integration we manage masking for superpriority interrupts
along with our masking for DAIF, much as is done for psedo NMIs. This
means that superpriority interrupts are unmasked whenever DAIF.A is
unmasked. This should ensure that no additional code can be preempted
when using the architected feature. The separate mask in the architected
feature means that we require management of this in the assembly code as
well as C code, masking DAIF is not sufficient to mask superpriority
interrupts.

In order to ensure that we do not have both pseudo NMIs and architected
NMIs simultaneously enabled we disable the architected NMIs if pseudo
NMI support is enabled in the kernel and has been requested on the
command line. This avoids any potential confusion or conflict between
the two mechanisms. Since pseudo NMIs require explicit enablement it
seemed most sensible to trust that the user preferred them for some
reason. A feature override is also provided for FEAT_NMI, allowing it to
be directly disabled in case of problems.

Using this feature in KVM guests will require the implementation of vGIC
support which is not present in this series, this is due to my and
Lorenzo's schedules not lining up perfectly and wanting to get the
review of the architecture side started.  The architecture code should
be fine when running in guests but doesn't accomplish anything and can't
be meaningfully tested without an interrupt controller.  As a result the
feature is not exposed to guests and we enable traps for writes to
ALLINT when running guests, detecting any guests that attempt to use the
feature.  The vGIC support should follow soon.  There is no other usage
of the feature in the hypervisor.  

v2:
 - Change approach to mask NMIs along with DAIF, masking whenever
   asynchronous exceptins are masked.
 - Trap writes to ALLINT while running KVM guests.

Lorenzo Pieralisi (1):
  irqchip/gic-v3: Implement FEAT_GICv3_NMI support

Mark Brown (13):
  arm64/booting: Document boot requirements for FEAT_NMI
  arm64/sysreg: Add definition for ICC_NMIAR1_EL1
  arm64/sysreg: Add definition of ISR_EL1
  arm64/sysreg: Add definitions for immediate versions of MSR ALLINT
  arm64/asm: Introduce assembly macros for managing ALLINT
  arm64/hyp-stub: Enable access to ALLINT
  arm64/idreg: Add an override for FEAT_NMI
  arm64/cpufeature: Detect PE support for FEAT_NMI
  KVM: arm64: Hide FEAT_NMI from guests
  arm64/nmi: Manage masking for superpriority interrupts along with DAIF
  arm64/irq: Document handling of FEAT_NMI in irqflags.h
  arm64/nmi: Add handling of superpriority interrupts as NMIs
  arm64/nmi: Add Kconfig for NMI

 Documentation/arm64/booting.rst         |   6 +
 arch/arm64/Kconfig                      |  17 +++
 arch/arm64/include/asm/assembler.h      |  27 +++++
 arch/arm64/include/asm/cpufeature.h     |   6 +
 arch/arm64/include/asm/daifflags.h      |  19 ++++
 arch/arm64/include/asm/irq.h            |   2 +
 arch/arm64/include/asm/irqflags.h       |  10 ++
 arch/arm64/include/asm/nmi.h            |  18 +++
 arch/arm64/include/asm/sysreg.h         |   2 +
 arch/arm64/kernel/cpufeature.c          |  55 ++++++++-
 arch/arm64/kernel/entry-common.c        |  55 +++++++--
 arch/arm64/kernel/hyp-stub.S            |  12 ++
 arch/arm64/kernel/idreg-override.c      |   1 +
 arch/arm64/kernel/irq.c                 |  32 ++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |   6 +
 arch/arm64/kvm/sys_regs.c               |   1 +
 arch/arm64/tools/cpucaps                |   1 +
 arch/arm64/tools/sysreg                 |  15 +++
 drivers/irqchip/irq-gic-v3.c            | 143 ++++++++++++++++++++----
 include/linux/irqchip/arm-gic-v3.h      |   4 +
 20 files changed, 401 insertions(+), 31 deletions(-)
 create mode 100644 arch/arm64/include/asm/nmi.h


base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
2.30.2

