Return-Path: <SRS0=kGQk=ZD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA95C43331
	for <kvmarm@archiver.kernel.org>; Mon, 11 Nov 2019 14:12:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FEEF21925
	for <kvmarm@archiver.kernel.org>; Mon, 11 Nov 2019 14:12:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FEEF21925
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC94A4B0D5;
	Mon, 11 Nov 2019 09:12:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vuj+8iefq6SP; Mon, 11 Nov 2019 09:12:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3E854B0CF;
	Mon, 11 Nov 2019 09:12:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B0A24B0CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Nov 2019 09:12:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GjZ2NyvykUq1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Nov 2019 09:12:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FBD14B0CA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Nov 2019 09:12:23 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4EB831B;
 Mon, 11 Nov 2019 06:12:22 -0800 (PST)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com
 [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DDD83F534;
 Mon, 11 Nov 2019 06:12:21 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH 0/2] arm64: Workaround for Cortex-A55 erratum 1530923
Date: Mon, 11 Nov 2019 14:11:55 +0000
Message-Id: <20191111141157.55062-1-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, Steven Price <steven.price@arm.com>,
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

This series enables a workaround for Cortex-A55 erratum 1530923. The
erratum potentially allows TLB entries to be allocated as a result of a
speculative AT instruction. This may happen in the middle of a guest
world switch while the relevant VMSA configuration is in an inconsistent
state, leading to erroneous content being allocated into TLBs.

The existing workaround for Cortex-A76 erratum 1165522 is the same, so
the first patch renames this workaround to a generic name
(SPECULATIVE_AT), the second patch then adds the detection for the
Cortex-A55 erratum 1530923.

Steven Price (2):
  arm64: Rename WORKAROUND_1165522 to SPECULATIVE_AT
  arm64: Workaround for Cortex-A55 erratum 1530923

 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 17 +++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  2 +-
 arch/arm64/include/asm/kvm_host.h      |  2 +-
 arch/arm64/include/asm/kvm_hyp.h       |  7 +++----
 arch/arm64/kernel/cpu_errata.c         | 23 ++++++++++++++++++-----
 arch/arm64/kvm/hyp/switch.c            |  6 +++---
 arch/arm64/kvm/hyp/tlb.c               |  8 ++++----
 8 files changed, 49 insertions(+), 18 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
