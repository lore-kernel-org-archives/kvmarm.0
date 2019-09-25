Return-Path: <SRS0=kdt8=XU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311C0C432C1
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 11:20:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B2721214D9
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 11:19:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2721214D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3E9E4A6C0;
	Wed, 25 Sep 2019 07:19:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0hcw3SeJ4f+g; Wed, 25 Sep 2019 07:19:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D29924A662;
	Wed, 25 Sep 2019 07:19:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2294D4A64B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 07:19:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SUaxIE0rRdRz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Sep 2019 07:19:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C1B74A5BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 07:19:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 825A71570;
 Wed, 25 Sep 2019 04:19:55 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49A813F694;
 Wed, 25 Sep 2019 04:19:54 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 0/5] arm64: KVM: Add workaround for errata 1319367 and 1319537
Date: Wed, 25 Sep 2019 12:19:36 +0100
Message-Id: <20190925111941.88103-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Similarily to erratum 1165522 that affects Cortex-A76, our good old
friends A57 and A72 respectively suffer from errata 1319367 and
1319537, potentially resulting in TLB corruption if the CPU speculates
an AT instruction while switching guests.

The fix is slightly more involved since we don't have VHE to help us
here, but the idea is the same: When switching a guest in, we must
prevent any speculated AT from being able to parse the page tables
until S2 is up and running. Only at this stage can we allow AT to take
place.

For this, we always restore the guest sysregs first, except for its
SCTLR and TCR registers, which must be set with SCTLR.M=1 and
TCR.EPD{0,1} = {1, 1}, effectively disabling the PTW and TLB
allocation. Once S2 is setup, we restore the guest's SCTLR and
TCR. Similar things must be done on TLB invalidation... Fun.

This has been tested on an AMD Seattle box.

Marc Zyngier (5):
  arm64: Add ARM64_WORKAROUND_1319367 for all A57 and A72 versions
  arm64: KVM: Reorder system register restoration and stage-2 activation
  arm64: KVM: Disable EL1 PTW when invalidating S2 TLBs
  arm64: KVM: Prevent speculative S1 PTW when restoring vcpu context
  arm64: Enable and document ARM errata 1319367 and 1319537

 Documentation/arm64/silicon-errata.rst |  4 +++
 arch/arm64/Kconfig                     | 10 ++++++
 arch/arm64/include/asm/cpucaps.h       |  3 +-
 arch/arm64/kernel/cpu_errata.c         | 13 +++++--
 arch/arm64/kvm/hyp/switch.c            | 48 ++++++++++++++++++++++----
 arch/arm64/kvm/hyp/sysreg-sr.c         | 14 ++++++--
 arch/arm64/kvm/hyp/tlb.c               | 23 ++++++++++++
 7 files changed, 103 insertions(+), 12 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
