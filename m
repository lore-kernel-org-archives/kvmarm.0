Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E709C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 16:37:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1150622CB2
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 16:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1150622CB2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 430564B333;
	Tue,  5 Jan 2021 11:37:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1iZlBeli62Tv; Tue,  5 Jan 2021 11:37:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9FA64B31F;
	Tue,  5 Jan 2021 11:37:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E45AD4B241
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 11:37:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1V+kIoSi8YDW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 11:36:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7459B4B2F8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 11:36:59 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1533A1FB;
 Tue,  5 Jan 2021 08:36:59 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 321C63F70D;
 Tue,  5 Jan 2021 08:36:57 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v5 0/5] ARM: arm64: Add SMCCC TRNG entropy service
Date: Tue,  5 Jan 2021 16:36:47 +0000
Message-Id: <20210105163652.23646-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Theodore Ts'o <tytso@mit.edu>, Linus Walleij <linus.walleij@linaro.org>,
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

a small update to v4, also observing the priority of SMCCC vs. RNDR in
the early version of the function (as reported by broonie).
Plus adding review tags and rebasing on v5.11-rc2. Changelog below.

Will, Catalin: it would be much appreciated if you could consider taking
patch 1/5. This contains the common definitions, and is a prerequisite
for every other patch, although they are somewhat independent and likely
will need to go through different subsystems.

Cheers,
Andre
==============================

The ARM architected TRNG firmware interface, described in ARM spec
DEN0098[1], defines an ARM SMCCC based interface to a true random number
generator, provided by firmware.

This series collects all the patches implementing this in various
places: as a user feeding into the ARCH_RANDOM pool, both for ARM and
arm64, and as a service provider for KVM guests.

Patch 1 introduces the interface definition used by all three entities.
Patch 2 prepares the Arm SMCCC firmware driver to probe for the
interface. This patch is needed to avoid a later dependency on *two*
patches (there might be a better solution to this problem).

Patch 3 implements the ARM part, patch 4 is the arm64 version.
The final patch 5 adds support to provide random numbers to KVM guests.

This was tested on:
- QEMU -kernel (no SMCCC, regression test)
- Juno w/ prototype of the h/w Trusted RNG support
- mainline KVM (SMCCC, but no TRNG: regression test)
- ARM and arm64 KVM guests, using the KVM service in patch 5/5

Based on v5.11-rc2, please let me know if I should rebase it on
something else. A git repo is accessible at:
https://gitlab.arm.com/linux-arm/linux-ap/-/commits/smccc-trng/v5/

Cheers,
Andre

[1] https://developer.arm.com/documentation/den0098/latest/

Changelog v4 ... v5:
- change order of SMCCC call vs. RNDR call in arch_get_random_seed_long_early
- adding Sudeep's R-b: tags

Changelog v3 ... v4:
- include cache.h to always have __ro_after_init defined
- change order of SMCCC call vs. RNDR call in arm64's archrandom.h
- adding LinusW's R-b: tags

Changelog v2 ... v3:
- ARM: fix compilation with randconfig
- arm64: use SMCCC call also in arch_get_random_seed_long_early()
- KVM: comment on return value usage
- KVM: use more interesting UUID (enjoy, Marc!)
- KVM: use bitmaps instead of open coded long arrays
- KVM: drop direct usage of arch_get_random() interface

Changelog "v1" ... v2:
- trigger ARCH_RANDOM initialisation from the SMCCC firmware driver
- use a single bool in smccc.c to hold the initialisation state for arm64
- handle endianess correctly in the KVM provider

Andre Przywara (2):
  firmware: smccc: Introduce SMCCC TRNG framework
  arm64: Add support for SMCCC TRNG entropy source

Ard Biesheuvel (3):
  firmware: smccc: Add SMCCC TRNG function call IDs
  ARM: implement support for SMCCC TRNG entropy source
  KVM: arm64: implement the TRNG hypervisor call

 arch/arm/Kconfig                    |  4 ++
 arch/arm/include/asm/archrandom.h   | 74 +++++++++++++++++++++++++
 arch/arm64/include/asm/archrandom.h | 82 ++++++++++++++++++++++++----
 arch/arm64/include/asm/kvm_host.h   |  2 +
 arch/arm64/kvm/Makefile             |  2 +-
 arch/arm64/kvm/hypercalls.c         |  6 ++
 arch/arm64/kvm/trng.c               | 85 +++++++++++++++++++++++++++++
 drivers/firmware/smccc/smccc.c      |  6 ++
 include/linux/arm-smccc.h           | 31 +++++++++++
 9 files changed, 281 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm/include/asm/archrandom.h
 create mode 100644 arch/arm64/kvm/trng.c

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
