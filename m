Return-Path: <SRS0=pAxc=S3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3A2C4321A
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:49:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3CED420717
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:49:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CED420717
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC77E4A485;
	Thu, 25 Apr 2019 09:49:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6924SCZ61FL8; Thu, 25 Apr 2019 09:49:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 121954A477;
	Thu, 25 Apr 2019 09:49:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 533484A46F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:49:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bnq5YDl225ct for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 09:49:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 119C64A36C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:49:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74A16A78;
 Thu, 25 Apr 2019 06:49:12 -0700 (PDT)
Received: from big-swifty.cambridge.arm.com (c02v53d0hv2r.cambridge.arm.com
 [10.1.37.80])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 891AB3F246;
 Thu, 25 Apr 2019 06:49:09 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 0/5] KVM/ARM updates for 5.1-rc7
Date: Thu, 25 Apr 2019 14:48:51 +0100
Message-Id: <20190425134857.26109-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Heyi Guo <guoheyi@huawei.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190425134851.oOojm06WAynTqzWjBMa2IRIIJCu2rM-rXSUAH_vv_lM@z>

Paolo, Radim,

Here's a bunch of late fixes for 5.1-rc7, which should hopefully be
the last drop for this cycle.

Please pull,

	M.

The following changes since commit 8324c3d518cfd69f2a17866b52c13bf56d3042d8:

  KVM: arm/arm64: Comments cleanup in mmu.c (2019-03-28 13:17:17 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.1-2

for you to fetch changes up to 6bc210003dff7b789efae5bb02a0320dc24dd416:

  KVM: arm/arm64: Don't emulate virtual timers on userspace ioctls (2019-04-25 14:13:31 +0100)

----------------------------------------------------------------
KVM/ARM fixes for 5.1, take #2:

- Don't try to emulate timers on userspace access
- Fix unaligned huge mappings, again
- Properly reset a vcpu that fails to reset(!)
- Properly retire pending LPIs on reset
- Fix computation of emulated CNTP_TVAL

----------------------------------------------------------------
Andrew Jones (1):
      KVM: arm/arm64: Ensure vcpu target is unset on reset failure

Christoffer Dall (1):
      KVM: arm/arm64: Don't emulate virtual timers on userspace ioctls

Marc Zyngier (1):
      KVM: arm/arm64: vgic-v3: Retire pending interrupts on disabling LPIs

Suzuki K Poulose (1):
      kvm: arm: Skip stage2 huge mappings for unaligned ipa backed by THP

Wei Huang (1):
      KVM: arm/arm64: arch_timer: Fix CNTP_TVAL calculation

 virt/kvm/arm/arch_timer.c        | 17 ++++++++++-------
 virt/kvm/arm/arm.c               | 11 ++++++++---
 virt/kvm/arm/mmu.c               |  6 +++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  3 +++
 virt/kvm/arm/vgic/vgic.c         | 21 +++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h         |  1 +
 6 files changed, 48 insertions(+), 11 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
