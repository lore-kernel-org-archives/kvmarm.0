Return-Path: <SRS0=ZPOc=UJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B34C31E40
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 16:24:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58B9D20859
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 16:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58B9D20859
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFCA74A520;
	Mon, 10 Jun 2019 12:24:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ywje7KWgeK1g; Mon, 10 Jun 2019 12:24:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 745824A4F7;
	Mon, 10 Jun 2019 12:24:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02E0D4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 12:24:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Iq5pMifBUG-g for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jun 2019 12:24:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F9344A509
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 12:24:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10BDA337;
 Mon, 10 Jun 2019 09:24:37 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5C183F246;
 Mon, 10 Jun 2019 09:24:35 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/6] KVM: arm64: Account host/guest SError more precisely
 (Neoverse-N1 #1349291)
Date: Mon, 10 Jun 2019 17:24:21 +0100
Message-Id: <20190610162427.115910-1-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
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

Hello,

This series started as a workaround for Neoverse-N1 #1349291, but has
become an improvement in RAS error accounting for KVM on arm64.

Neoverse-N1 affected by #1349291 may report an Uncontained RAS Errors
as Unrecoverable. [0] This is the difference between killing the thread and
killing the machine.
The workaround is to treat all Unrecoverable SError as Uncontained.
The arch code's SError handling already does this, due to its nascent
kernel-first support.

So only KVM needs some work as it has its own SError handling as we want
KVM to handle guest:SError and the host to handle host:SError.

Instead of working around the errata in KVM, we account SError as precisely
as we can instead. This means moving the ESB-instruction into the guest-exit
vectors, and deferring guest-entry if there is an SError pending. (so that the
host's existing handling takes it).


Changes since v1:
 * Squashed v1:patch5 into v2:patch4. v1:patch6 to be posted separately.
 * Dropped all the performance numbers.
 * Added patch1, making the ESB macro emit a nop if the kconfig feature
   is disabled.
 * Tried to formalise the indirect vectors preamble a little more to
   make changes easier to review
 * Added preamble size checks to the invalid vector entries.
 * Pulled the size check out as a macro now there are two invocations.

Thanks,

James

[0] account-required: https://developer.arm.com/docs/sden885747/latest/arm-neoverse-n1-mp050-software-developer-errata-notice

[v1] https://lore.kernel.org/linux-arm-kernel/20190604144551.188107-1-james.morse@arm.com/

James Morse (6):
  arm64: assember: Switch ESB-instruction with a vanilla nop if
    !ARM64_HAS_RAS
  KVM: arm64: Abstract the size of the HYP vectors pre-amble
  KVM: arm64: Make indirect vectors preamble behaviour symmetric
  KVM: arm64: Consume pending SError as early as possible
  KVM: arm64: Defer guest entry when an asynchronous exception is
    pending
  arm64: Update silicon-errata.txt for Neoverse-N1 #1349291

 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/include/asm/assembler.h     |  4 ++++
 arch/arm64/include/asm/kvm_asm.h       |  6 ++++++
 arch/arm64/kernel/traps.c              |  4 ++++
 arch/arm64/kvm/hyp/entry.S             | 19 +++++++++++++---
 arch/arm64/kvm/hyp/hyp-entry.S         | 30 +++++++++++++++++++++-----
 arch/arm64/kvm/va_layout.c             |  7 +++---
 7 files changed, 59 insertions(+), 12 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
