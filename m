From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v2 0/3] Support Common Not Private translations
Date: Wed, 11 Oct 2017 13:19:52 +0100
Message-ID: <1507724395-13735-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85DB249D6F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 08:19:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pQ7UNoU739aI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 08:19:30 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59C1449D39
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 08:19:29 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, kbuild-all@01.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Common Not Private (CNP) translations is a feature of ARMv8.2
extension which allows translation table entries to be shared between
different PEs in the same inner shareable domain, so the hardware can
use this fact to optimise the caching of such entries in the TLB.

This patch set is an attempt to bring CNP support into Linux. It was
tested on a v8.2 Fast Model with exploring traces and checking that
TTBRx_ELy and VTTBR_EL2 have CnP bit set where appropriate.

Changelog:
	v1 -> v2
            - handle cpuilde case (per James)
	    - use lm_allias with swapper_pg_dir (per James)
            - rule out ARM64_SW_TTBR0_PAN case (per Catalin)
	    - s/BUG_ON/WARN_ON/ (per Catalin)
	    - comment and commit message updates (per Catalin)
	    - TTBR_CNP_BIT moved to asm/pgtable-hwdef.h (per Catalin)
	    - has_useable_cnp() simplified (per Julien)

	RFC -> v1
            - dropped RFC tag
            - rebased on 4.14-rc4

Thanks!

Vladimir Murzin (3):
  arm64: mm: Support Common Not Private translations
  arm64: KVM: Support Common Not Private translations
  arm64: Introduce command line parameter to disable CNP

 Documentation/admin-guide/kernel-parameters.txt |  4 +++
 arch/arm64/Kconfig                              | 14 +++++++++++
 arch/arm64/include/asm/cpucaps.h                |  3 ++-
 arch/arm64/include/asm/cpufeature.h             |  6 +++++
 arch/arm64/include/asm/mmu_context.h            | 12 +++++++++
 arch/arm64/include/asm/pgtable-hwdef.h          |  2 ++
 arch/arm64/kernel/cpufeature.c                  | 33 +++++++++++++++++++++++++
 arch/arm64/kernel/hibernate.c                   |  2 +-
 arch/arm64/kernel/suspend.c                     |  3 +++
 arch/arm64/kvm/hyp-init.S                       |  4 +++
 arch/arm64/kvm/hyp/switch.c                     |  6 ++++-
 arch/arm64/mm/proc.S                            |  5 ++++
 12 files changed, 91 insertions(+), 3 deletions(-)

-- 
2.0.0
