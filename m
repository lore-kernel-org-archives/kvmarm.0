Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC55C433DF
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 03:52:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96A1120A8B
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 03:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96A1120A8B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D825C4B251;
	Thu,  2 Jul 2020 23:52:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mZYoHjFPLzyc; Thu,  2 Jul 2020 23:52:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9BA24B24C;
	Thu,  2 Jul 2020 23:52:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2237A4B24C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 23:52:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7mQrWFQ1RHlI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 23:52:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3110B4B246
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 23:52:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91CF431B;
 Thu,  2 Jul 2020 20:52:08 -0700 (PDT)
Received: from p8cg001049571a15.arm.com (unknown [10.163.85.168])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3C6E13F71E;
 Thu,  2 Jul 2020 20:52:04 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH V5 (RESEND) 0/4] arm64/cpufeature: Introduce ID_PFR2, ID_DFR1,
 ID_MMFR5 and other changes
Date: Fri,  3 Jul 2020 09:21:33 +0530
Message-Id: <1593748297-1965-1-git-send-email-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.7.4
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
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

These are remaining patches from V4 series which had some pending reviews
from Suzuki (https://patchwork.kernel.org/cover/11557333/). Also dropped
[PATCH 15/17] as that will need some more investigation and rework.

This series applies on 5.8-rc3.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com> 
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Changes in V5: (https://patchwork.kernel.org/project/linux-arm-kernel/list/?series=293885)

- Dropped TGRAN features along with it's macros from ID_AA64MMFR0 per Suzuki
- Replaced with FTR_HIGHER_SAFE for SpecSEI feature in ID_AA64MMFR1 per Suzuki
- Dropped patch "arm64/cpufeature: Add remaining feature bits in ID_AA64DFR0 register"

Changes in V4: (https://patchwork.kernel.org/project/linux-arm-kernel/list/?series=290085)

- Updated ftr_id_dfr0[] with a documentation for now missing [31:28] Tracfilt per Will
- Fixed erroneous bit width value from 28 to 4 for double lock feature per Will
- Replaced ID_SANITIZED() with ID_HIDDEN() for SYS_ID_DFR1_EL1 per Suzuki
- Fixed positions for register definitions as per new name based grouping per Will
- Replaced FTR_VISIBLE with FTR_HIDDEN for TLB feature in ID_AA64ISAR0 per Suzuki
- Replaced FTR_VISIBLE with FTR_HIDDEN for MPAM and SEL2 in ID_AA64PFR0 per Suzuki
- Replaced FTR_VISIBLE with FTR_HIDDEN for MPAMFRAC and RASFRAC in ID_AA64PFR1 per Suzuki
- Dropped both MTE and BT features from ftr_id_aa64pfr1[] to be added later per Suzuki
- Added ID_MMFR4_EL1 into the cpuinfo_arm64 context per Will

Changes in V3: (https://patchwork.kernel.org/project/linux-arm-kernel/list/?series=281211)

- Rebased on git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git (for-next/cpufeature)

Changes in V2: (https://patchwork.kernel.org/project/linux-arm-kernel/list/?series=270605)

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


Anshuman Khandual (4):
  arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR0 register
  arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR1 register
  arm64/cpufeature: Add remaining feature bits in ID_AA64MMFR2 register
  arm64/cpufeature: Replace all open bits shift encodings with macros

 arch/arm64/include/asm/sysreg.h | 42 +++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c  | 67 ++++++++++++++++++++-------------
 2 files changed, 83 insertions(+), 26 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
