Return-Path: <SRS0=nwVD=36=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41705C352A3
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 12:27:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C07A820873
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 12:27:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C07A820873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2592C4A5C3;
	Mon, 10 Feb 2020 07:27:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YeNINWP0JDPA; Mon, 10 Feb 2020 07:27:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14B934A944;
	Mon, 10 Feb 2020 07:27:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA00B4A65C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 07:27:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iaKZmizMBiPB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Feb 2020 07:27:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 992B44A4F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 07:27:22 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5FD51FB;
 Mon, 10 Feb 2020 04:27:21 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A71573F6CF;
 Mon, 10 Feb 2020 04:27:20 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] arm64: add finalized cap helper
Date: Mon, 10 Feb 2020 12:27:06 +0000
Message-Id: <20200210122708.38826-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
Cc: catalin.marinas@arm.com, maz@kernel.org, will@kernel.org,
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

Across arm64 we use cpus_have_const_cap() to check for a capability
without a runtime check. Prior to capabilities being finalized
cpus_have_const_cap() falls back to a runtime check of the cpu_hwcaps
array. In some cases we know that code is never invoked prior to the
capabilities being finalized, and the fallback code is redundant (and
unsound if ever executed in hyp context).

So that we can avoid the redundant code and detect when the caps are
unexpectedly checked too early, this series adds a new
cpus_have_final_cap() helper, and migrates the KVM hyp code over to it.

I'm hoping to use this as part of the entry.S -> entry-common.c
conversion, and there are other places in arm64 that could potentially
use this today.

Thanks,
Mark.

Mark Rutland (2):
  arm64: cpufeature: add cpus_have_final_cap()
  arm64: kvm: hyp: use cpus_have_final_cap()

 arch/arm64/include/asm/cpufeature.h | 47 +++++++++++++++++++++++++++++++++----
 arch/arm64/kvm/hyp/switch.c         | 14 +++++------
 arch/arm64/kvm/hyp/sysreg-sr.c      |  8 +++----
 arch/arm64/kvm/hyp/tlb.c            |  8 +++----
 4 files changed, 57 insertions(+), 20 deletions(-)

-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
