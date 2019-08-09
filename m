Return-Path: <SRS0=zTnl=WF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E53C31E40
	for <kvmarm@archiver.kernel.org>; Fri,  9 Aug 2019 07:49:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2685E20B7C
	for <kvmarm@archiver.kernel.org>; Fri,  9 Aug 2019 07:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2685E20B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D77E4A568;
	Fri,  9 Aug 2019 03:49:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IUDwjjq1i6cT; Fri,  9 Aug 2019 03:49:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DE654A51E;
	Fri,  9 Aug 2019 03:49:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F37B4A4FE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Aug 2019 03:49:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wmAYhuE4v7gi for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Aug 2019 03:48:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EADD4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Aug 2019 03:48:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7897344;
 Fri,  9 Aug 2019 00:48:58 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 290EE3F706;
 Fri,  9 Aug 2019 00:48:57 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [GIT PULL] KVM/arm updates for 5.3-rc4
Date: Fri,  9 Aug 2019 08:48:28 +0100
Message-Id: <20190809074832.13283-1-maz@kernel.org>
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

Here's a set of update for -rc4. Yet another reset fix, and two subtle
VGIC fixes for issues that can be observed in interesting corner cases.

Note that this is on top of kvmarm-fixes-for-5.3[1], which hasn't been
pulled yet. Hopefully you can pull both at the same time!

Thanks,

	M.

[1] https://lore.kernel.org/kvmarm/20190731173650.12627-1-maz@kernel.org

The following changes since commit cdb2d3ee0436d74fa9092f2df46aaa6f9e03c969:

  arm64: KVM: hyp: debug-sr: Mark expected switch fall-through (2019-07-29 11:01:37 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.3-2

for you to fetch changes up to 16e604a437c89751dc626c9e90cf88ba93c5be64:

  KVM: arm/arm64: vgic: Reevaluate level sensitive interrupts on enable (2019-08-09 08:07:26 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.3, take #2

- Fix our system register reset so that we stop writing
  non-sensical values to them, and track which registers
  get reset instead.
- Sync VMCR back from the GIC on WFI so that KVM has an
  exact vue of PMR.
- Reevaluate state of HW-mapped, level triggered interrupts
  on enable.

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm/arm64: vgic: Reevaluate level sensitive interrupts on enable

Marc Zyngier (3):
      KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block
      KVM: arm64: Don't write junk to sysregs on reset
      KVM: arm: Don't write junk to CP15 registers on reset

 arch/arm/kvm/coproc.c         | 23 +++++++++++++++--------
 arch/arm64/kvm/sys_regs.c     | 32 ++++++++++++++++++--------------
 include/kvm/arm_vgic.h        |  1 +
 virt/kvm/arm/arm.c            | 11 +++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c | 16 ++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c   |  9 ++++++++-
 virt/kvm/arm/vgic/vgic-v3.c   |  7 ++++++-
 virt/kvm/arm/vgic/vgic.c      | 11 +++++++++++
 virt/kvm/arm/vgic/vgic.h      |  2 ++
 9 files changed, 88 insertions(+), 24 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
