Return-Path: <SRS0=ArS2=HK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BCBC433E6
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 09:58:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB64E64E9D
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 09:57:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB64E64E9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40D8C4B40B;
	Mon,  8 Feb 2021 04:57:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BAcbmH0092zk; Mon,  8 Feb 2021 04:57:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5C274B3B2;
	Mon,  8 Feb 2021 04:57:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7ACE4B3B2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 04:57:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TW0moYKQKyUB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 04:57:54 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 221AF4B19C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 04:57:54 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CF7D764E54;
 Mon,  8 Feb 2021 09:57:52 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l93Ik-00Ck14-CI; Mon, 08 Feb 2021 09:57:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: [PATCH v7 00/23] arm64: Early CPU feature override,
 and applications to VHE, BTI and PAuth
Date: Mon,  8 Feb 2021 09:57:09 +0000
Message-Id: <20210208095732.3267263-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, ardb@kernel.org,
 jingzhangos@google.com, pajay@qti.qualcomm.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, marcan@marcan.st, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 Ajay Patil <pajay@qti.qualcomm.com>, kernel-team@android.com,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

It recently came to light that there is a need to be able to override
some CPU features very early on, before the kernel is fully up and
running. The reasons for this range from specific feature support
(such as using Protected KVM on VHE HW, which is the main motivation
for this work) to errata workaround (a feature is broken on a CPU and
needs to be turned off, or rather not enabled).

This series tries to offer a limited framework for this kind of
problems, by allowing a set of options to be passed on the
command-line and altering the feature set that the cpufeature
subsystem exposes to the rest of the kernel. Note that this doesn't
change anything for code that directly uses the CPU ID registers.

The series completely changes the way a VHE-capable system boots, by
*always* booting non-VHE first, and then upgrading to VHE when deemed
capable. Although it sounds scary, this is actually simple to
implement (and I wish I had done that five years ago). The "upgrade to
VHE" path is then conditioned on the VHE feature not being disabled
from the command-line.

Said command-line parsing borrows a lot from the kaslr code, and
subsequently allows the "nokaslr" option to be moved to the new
infrastructure (though it all looks a bit... odd).

Further patches now add support for disabling BTI and PAuth, the
latter being based on an initial series by Srinivas Ramana[0]. There
is some ongoing discussions about being able to disable MTE, but no
clear resolution on that subject yet

WARNING: this series breaks Apple M1 badly, as it is stuck in VHE
mode. The last patch in this series papers over the problem, but it
*isn't* a candidate for merging yet.

This has been tested on multiple VHE and non-VHE systems.

Branch available at [7].

* From v6 [6]:
  - Greatly simplify SPE setup with VHE
  - Simplify option parsing by reusing some of the helpers user by
    parse_args(). The whole function cannot be used though, as it
    does things that can't be done at the point where we parse the
    overrides.
  - Add a patch allowing M1 CPUs to boot. This patch shouldn't be
    merged until we decide to support this non-architectural behaviour.

* From v5 [5]:
  - Turn most __initdata into __initconst
  - Ensure that all strings are part of the __initconst section.
    This is a bit ugly, but saves memory once up and running
  - Make overrides __ro_after_init
  - Change the command-line parsing so that the same feature can
    be overridden multiple times, with the expected left-to-right
    parsing order being respected
  - Handle all space-like characters as option delimiters
  - Collected Acks, RBs and TBs

* From v4 [4]:
  - Documentation fixes
  - Moved the val/mask pair into a arm64_ftr_override structure,
    leading to simpler code
  - All arm64_ftr_reg now have a default override, which simplifies
    the code a bit further
  - Dropped some of the "const" attributes
  - Renamed init_shadow_regs() to init_feature_override()
  - Renamed struct reg_desc to struct ftr_set_desc
  - Refactored command-line parsing
  - Simplified handling of VHE being disabled on the cmdline
  - Turn EL1 S1 MMU off on switch to VHE
  - HVC_VHE_RESTART now returns an error code on failure
  - Added missing asmlinkage and dummy prototypes
  - Collected Acks and RBs from David, Catalin and Suzuki

* From v3 [3]:
  - Fixed the VHE_RESTART stub (duh!)
  - Switched to using arm64_ftr_safe_value() instead of the user
    provided value
  - Per-feature override warning

* From v2 [2]:
  - Simplify the VHE_RESTART stub
  - Fixed a number of spelling mistakes, and hopefully introduced a
    few more
  - Override features in __read_sysreg_by_encoding()
  - Allow both BTI and PAuth to be overridden on the command line
  - Rebased on -rc3

* From v1 [1]:
  - Fix SPE init on VHE when EL2 doesn't own SPE
  - Fix re-init when KASLR is used
  - Handle the resume path
  - Rebased to 5.11-rc2

[0] https://lore.kernel.org/r/1610152163-16554-1-git-send-email-sramana@codeaurora.org
[1] https://lore.kernel.org/r/20201228104958.1848833-1-maz@kernel.org
[2] https://lore.kernel.org/r/20210104135011.2063104-1-maz@kernel.org
[3] https://lore.kernel.org/r/20210111132811.2455113-1-maz@kernel.org
[4] https://lore.kernel.org/r/20210118094533.2874082-1-maz@kernel.org
[5] https://lore.kernel.org/r/20210125105019.2946057-1-maz@kernel.org
[6] https://lore.kernel.org/r/20210201115637.3123740-1-maz@kernel.org
[7] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=hack/arm64-early-cpufeature

Marc Zyngier (22):
  arm64: Fix labels in el2_setup macros
  arm64: Fix outdated TCR setup comment
  arm64: Turn the MMU-on sequence into a macro
  arm64: Provide an 'upgrade to VHE' stub hypercall
  arm64: Initialise as nVHE before switching to VHE
  arm64: Drop early setting of MDSCR_EL2.TPMS
  arm64: Move VHE-specific SPE setup to mutate_to_vhe()
  arm64: Simplify init_el2_state to be non-VHE only
  arm64: Move SCTLR_EL1 initialisation to EL-agnostic code
  arm64: cpufeature: Add global feature override facility
  arm64: cpufeature: Use IDreg override in __read_sysreg_by_encoding()
  arm64: Extract early FDT mapping from kaslr_early_init()
  arm64: cpufeature: Add an early command-line cpufeature override
    facility
  arm64: Allow ID_AA64MMFR1_EL1.VH to be overridden from the command
    line
  arm64: Honor VHE being disabled from the command-line
  arm64: Add an aliasing facility for the idreg override
  arm64: Make kvm-arm.mode={nvhe, protected} an alias of
    id_aa64mmfr1.vh=0
  KVM: arm64: Document HVC_VHE_RESTART stub hypercall
  arm64: Move "nokaslr" over to the early cpufeature infrastructure
  arm64: cpufeatures: Allow disabling of BTI from the command-line
  arm64: cpufeatures: Allow disabling of Pointer Auth from the
    command-line
  [DO NOT MERGE] arm64: Cope with CPUs stuck in VHE mode

Srinivas Ramana (1):
  arm64: Defer enabling pointer authentication on boot core

 .../admin-guide/kernel-parameters.txt         |   9 +
 Documentation/virt/kvm/arm/hyp-abi.rst        |   9 +
 arch/arm64/include/asm/assembler.h            |  17 ++
 arch/arm64/include/asm/cpufeature.h           |  11 +
 arch/arm64/include/asm/el2_setup.h            |  60 ++---
 arch/arm64/include/asm/pointer_auth.h         |  10 +
 arch/arm64/include/asm/setup.h                |  11 +
 arch/arm64/include/asm/stackprotector.h       |   1 +
 arch/arm64/include/asm/virt.h                 |   7 +-
 arch/arm64/kernel/Makefile                    |   2 +-
 arch/arm64/kernel/asm-offsets.c               |   3 +
 arch/arm64/kernel/cpufeature.c                |  73 +++++-
 arch/arm64/kernel/head.S                      |  94 +++-----
 arch/arm64/kernel/hyp-stub.S                  | 141 +++++++++++-
 arch/arm64/kernel/idreg-override.c            | 216 ++++++++++++++++++
 arch/arm64/kernel/kaslr.c                     |  43 +---
 arch/arm64/kernel/setup.c                     |  15 ++
 arch/arm64/kernel/sleep.S                     |   1 +
 arch/arm64/kvm/arm.c                          |   3 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S            |   2 +-
 arch/arm64/mm/mmu.c                           |   2 +-
 arch/arm64/mm/proc.S                          |  16 +-
 22 files changed, 576 insertions(+), 170 deletions(-)
 create mode 100644 arch/arm64/include/asm/setup.h
 create mode 100644 arch/arm64/kernel/idreg-override.c

-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
