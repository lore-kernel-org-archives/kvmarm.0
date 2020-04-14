Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC333C2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 09:48:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E7AD2064A
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 09:48:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E7AD2064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A664B142;
	Tue, 14 Apr 2020 05:48:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HmxU2VKMcs6c; Tue, 14 Apr 2020 05:48:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 823254B156;
	Tue, 14 Apr 2020 05:48:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C87CA4B142
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 05:48:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mMEepwLo7NZA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 05:48:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5247D4B140
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 05:48:48 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8A331FB;
 Tue, 14 Apr 2020 02:48:47 -0700 (PDT)
Received: from p8cg001049571a15.arm.com (unknown [10.163.1.49])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 26F5A3F6C4;
 Tue, 14 Apr 2020 02:48:43 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH V2 00/16] arm64/cpufeature: Introduce ID_PFR2, ID_DFR1,
 ID_MMFR5 and other changes
Date: Tue, 14 Apr 2020 15:18:14 +0530
Message-Id: <1586857710-17154-1-git-send-email-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.7.4
Cc: catalin.marinas@arm.com, Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

This series is primarily motivated from an adhoc list from Mark Rutland
during our previous ID_ISAR6 discussion [1]. The current proposal also
accommodates some more suggestions from Will and Suzuki.

This series adds missing 32 bit system registers (ID_PFR2, ID_DFR1 and
ID_MMFR5), adds missing features bits on all existing system registers
(32 and 64 bit) and some other miscellaneous changes. While here it also
includes a patch which does macro replacement for various open bits shift
encodings for various CPU ID registers. There is a slight re-order of the
patches here as compared to the previous version (V1).

This series is based on v5.7-rc1. All feature bits enabled here can be
referred in ARM DDI 0487F.a specification. Though I have tried to select
appropriate values for each new feature being added here, there might be
some inconsistencies (or mistakes). In which case, please do let me know
if anything needs to change. Thank you.

[1] https://patchwork.kernel.org/patch/11287805/

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com> 
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Changes in V2:

- Added Suggested-by tag from Mark Rutland for all changes he had proposed
- Added comment for SpecSEI feature on why it is HIGHER_SAFE per Suzuki
- Added a patch which makes ID_AA64DFR0_DOUBLELOCK a signed feature per Suzuki
- Added ID_DFR1 and ID_MMFR5 system register definitions per Will
- Added remaining features bits for relevant 64 bit system registers per Will
- Changed commit message on [PATCH 5/7] regarding TraceFilt feature per Suzuki
- Changed ID_PFR2.CSV3 (FTR_STRICT -> FTR_NONSTRICT) as 64 bit registers per Will
- Changed ID_PFR0.CSV2 (FTR_STRICT -> FTR_NONSTRICT) as 64 bit registers per Will 
- Changed some commit messages

Changes in V1: (https://patchwork.kernel.org/project/linux-arm-kernel/list/?series=234093)

Anshuman Khandual (16):
  arm64/cpufeature: Add explicit ftr_id_isar0[] for ID_ISAR0 register
  arm64/cpufeature: Drop TraceFilt feature exposure from ID_DFR0 register
  arm64/cpufeature: Make doublelock a signed feature in ID_AA64DFR0
  arm64/cpufeature: Introduce ID_PFR2 CPU register
  arm64/cpufeature: Introduce ID_DFR1 CPU register
  arm64/cpufeature: Introduce ID_MMFR5 CPU register
  arm64/cpufeature: Add remaining feature bits in ID_PFR0 register
  arm64/cpufeature: Add remaining feature bits in ID_MMFR4 register
  arm64/cpufeature: Add remaining feature bits in ID_AA64ISAR0 register
  arm64/cpufeature: Add remaining feature bits in ID_AA64PFR0 register
  arm64/cpufeature: Add remaining feature bits in ID_AA64PFR1 register
  arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR0 register
  arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR1 register
  arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR2 register
  arm64/cpufeature: Add remaining feature bits in ID_AA64DFR0 register
  arm64/cpufeature: Replace all open bits shift encodings with macros

 arch/arm64/include/asm/cpu.h    |   3 +
 arch/arm64/include/asm/sysreg.h |  90 ++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c  | 141 +++++++++++++++++++++++++-------
 arch/arm64/kernel/cpuinfo.c     |   3 +
 arch/arm64/kvm/sys_regs.c       |   6 +-
 5 files changed, 211 insertions(+), 32 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
