Return-Path: <SRS0=F0YX=TY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914BBC072B5
	for <kvmarm@archiver.kernel.org>; Fri, 24 May 2019 14:48:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3724E20862
	for <kvmarm@archiver.kernel.org>; Fri, 24 May 2019 14:48:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3724E20862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D55F4A4EA;
	Fri, 24 May 2019 10:48:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e-krM4fOXTUU; Fri, 24 May 2019 10:48:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94A204A4DF;
	Fri, 24 May 2019 10:48:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E5244A477
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 10:48:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HQf2fpnyLbCp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 May 2019 10:48:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 363AA4A420
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 10:48:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8594980D;
 Fri, 24 May 2019 07:47:59 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB7E23F575;
 Fri, 24 May 2019 07:47:57 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [GIT PULL] KVM/arm updates for 5.2-rc2
Date: Fri, 24 May 2019 15:47:42 +0100
Message-Id: <20190524144745.227242-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Paolo, Radim,

This is the first batch of KVM/arm fixes for 5.2. The biggest item on
the menu is Christoffer removing himself from the MAINTAINERS
file. He'll be missed. The rest is a set of fixes moving some code
around to prevent KASAN and co from crashing the kernel on non-VHE
systems.

Please pull,

	M.

The following changes since commit a188339ca5a396acc588e5851ed7e19f66b0ebd9:

  Linux 5.2-rc1 (2019-05-19 15:47:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.2

for you to fetch changes up to 623e1528d4090bd1abaf93ec46f047dee9a6fb32:

  KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation (2019-05-24 14:53:20 +0100)

----------------------------------------------------------------
KVM/arm updates for 5.2-rc2

- Correctly annotate HYP-callable code to be non-traceable
- Remove Christoffer from the MAINTAINERS file as his request

----------------------------------------------------------------
Christoffer Dall (1):
      MAINTAINERS: KVM: arm/arm64: Remove myself as maintainer

James Morse (2):
      KVM: arm64: Move pmu hyp code under hyp's Makefile to avoid instrumentation
      KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation

 MAINTAINERS                       |   2 -
 arch/arm/kvm/hyp/Makefile         |   1 +
 arch/arm64/include/asm/kvm_host.h |   3 -
 arch/arm64/kvm/hyp/Makefile       |   1 +
 arch/arm64/kvm/hyp/switch.c       |  39 +++++++++++
 arch/arm64/kvm/pmu.c              |  38 -----------
 virt/kvm/arm/aarch32.c            | 121 ---------------------------------
 virt/kvm/arm/hyp/aarch32.c        | 136 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 177 insertions(+), 164 deletions(-)
 create mode 100644 virt/kvm/arm/hyp/aarch32.c
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
