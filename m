Return-Path: <SRS0=GAmw=2G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1041C2D0BF
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 11:56:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17A962072B
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 11:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17A962072B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E9724A586;
	Mon, 16 Dec 2019 06:56:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LwfdeNRkNzgn; Mon, 16 Dec 2019 06:56:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 602C84A59B;
	Mon, 16 Dec 2019 06:56:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D57FE4A586
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 06:56:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 83NsxnrQnw-B for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Dec 2019 06:56:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 966474A4BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 06:56:43 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E680F1FB;
 Mon, 16 Dec 2019 03:56:42 -0800 (PST)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com
 [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E41E13F719;
 Mon, 16 Dec 2019 03:56:41 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v5 0/3] arm64: Workaround for Cortex-A55 erratum 1530923
Date: Mon, 16 Dec 2019 11:56:28 +0000
Message-Id: <20191216115631.17804-1-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Steven Price <steven.price@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Version 5 is a rebasing of version 4 (no changes).

This series enables a workaround for Cortex-A55 erratum 1530923. The
erratum potentially allows TLB entries to be allocated as a result of a
speculative AT instruction. This may happen in the middle of a guest
world switch while the relevant VMSA configuration is in an inconsistent
state, leading to erroneous content being allocated into TLBs.

There are existing workarounds for similar issues, 1165522 is
effectively the same, and 1319367/1319537 is similar but without VHE
support.  Rather than add to the selection of errata, the first patch
renames 1165522 to WORKAROUND_SPECULATIVE_AT which can be reused (in the
final patch) for 1530923.

The workaround for errata 1319367 and 1319537 although similar cannot
use VHE (not available on those CPUs) so cannot share the workaround.
However, to keep some sense of symmetry the workaround is renamed to
SPECULATIVE_AT_NVHE.

Changes since v4:
 * Rebased to v5.5-rc1

Changes since v3:
 * Added Suzuki's reviewed-bys - thanks!
 * Corrected ARM64_WORKAROUND_SPECULATIVE_AT to
   ARM64_WORKAROUND_SPECULATIVE_AT_VHE in the final patch

Changes since v2:
 * Split 1319367/1319537 back into their own workaround, but rename it
   for symmetry with the VHE workaround.

Changes since v1:
 * Combine 1319367/1319537 into the same 'SPECULATIVE_AT' workaround.

Steven Price (3):
  arm64: Rename WORKAROUND_1165522 to SPECULATIVE_AT_VHE
  arm64: Rename WORKAROUND_1319367 to SPECULATIVE_AT_NVHE
  arm64: Workaround for Cortex-A55 erratum 1530923

 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 21 +++++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  4 ++--
 arch/arm64/include/asm/kvm_host.h      |  2 +-
 arch/arm64/include/asm/kvm_hyp.h       |  6 +++---
 arch/arm64/kernel/cpu_errata.c         | 25 +++++++++++++++++++------
 arch/arm64/kvm/hyp/switch.c            | 10 +++++-----
 arch/arm64/kvm/hyp/sysreg-sr.c         |  4 ++--
 arch/arm64/kvm/hyp/tlb.c               | 12 ++++++------
 9 files changed, 61 insertions(+), 25 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
