Return-Path: <SRS0=3K2b=XE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE6DC4740A
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 13:48:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8856E20828
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 13:48:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8856E20828
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE0644A576;
	Mon,  9 Sep 2019 09:48:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bhmT38YRoahd; Mon,  9 Sep 2019 09:48:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 944DB4A51D;
	Mon,  9 Sep 2019 09:48:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12BAA4A4E8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 09:48:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lxfSDSswzwLk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Sep 2019 09:48:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFC144A4E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 09:48:50 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62C0228;
 Mon,  9 Sep 2019 06:48:50 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 257243F59C;
 Mon,  9 Sep 2019 06:48:47 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 00/17] KVM/arm updates for 5.4
Date: Mon,  9 Sep 2019 14:47:50 +0100
Message-Id: <20190909134807.27978-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Here is the KVM/arm updates for 5.4: a new ITS translation cache
improving performance for interrupt injection of of assigned devices,
a couple of fixes to allow up to 512 vcpus, and a number of fixes and
other cleanups.

Please pull,

	M.

The following changes since commit d45331b00ddb179e291766617259261c112db872:

  Linux 5.3-rc4 (2019-08-11 13:26:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.4

for you to fetch changes up to 92f35b751c71d14250a401246f2c792e3aa5b386:

  KVM: arm/arm64: vgic: Allow more than 256 vcpus for KVM_IRQ_LINE (2019-09-09 12:29:09 +0100)

----------------------------------------------------------------
KVM/arm updates for 5.4

- New ITS translation cache
- Allow up to 512 CPUs to be supported with GICv3 (for real this time)
- Now call kvm_arch_vcpu_blocking early in the blocking sequence
- Tidy-up device mappings in S2 when DIC is available
- Clean icache invalidation on VMID rollover
- General cleanup

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm/arm64: vgic: Make function comments match function declarations

Eric Auger (1):
      KVM: arm/arm64: vgic: Use a single IO device per redistributor

James Morse (1):
      arm64: KVM: Device mappings should be execute-never

Marc Zyngier (13):
      KVM: arm/arm64: vgic: Add LPI translation cache definition
      KVM: arm/arm64: vgic: Add __vgic_put_lpi_locked primitive
      KVM: arm/arm64: vgic-its: Add MSI-LPI translation cache invalidation
      KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on specific commands
      KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on disabling LPIs
      KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on ITS disable
      KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on vgic teardown
      KVM: arm/arm64: vgic-its: Cache successful MSI->LPI translation
      KVM: arm/arm64: vgic-its: Check the LPI translation cache on MSI injection
      KVM: arm/arm64: vgic-irqfd: Implement kvm_arch_set_irq_inatomic
      KVM: Call kvm_arch_vcpu_blocking early into the blocking sequence
      KVM: arm/arm64: vgic: Remove spurious semicolons
      KVM: arm/arm64: vgic: Allow more than 256 vcpus for KVM_IRQ_LINE

Mark Rutland (1):
      arm64/kvm: Remove VMID rollover I-cache maintenance

 Documentation/virt/kvm/api.txt        |  12 +-
 arch/arm/include/uapi/asm/kvm.h       |   4 +-
 arch/arm64/include/asm/pgtable-prot.h |   2 +-
 arch/arm64/include/uapi/asm/kvm.h     |   4 +-
 arch/arm64/kvm/hyp/tlb.c              |  14 ++-
 include/kvm/arm_vgic.h                |   4 +-
 include/uapi/linux/kvm.h              |   1 +
 virt/kvm/arm/arm.c                    |   2 +
 virt/kvm/arm/vgic/vgic-init.c         |   8 +-
 virt/kvm/arm/vgic/vgic-irqfd.c        |  36 +++++-
 virt/kvm/arm/vgic/vgic-its.c          | 207 ++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v3.c      |  85 +++++---------
 virt/kvm/arm/vgic/vgic-v2.c           |   7 +-
 virt/kvm/arm/vgic/vgic-v3.c           |   7 +-
 virt/kvm/arm/vgic/vgic.c              |  26 +++--
 virt/kvm/arm/vgic/vgic.h              |   5 +
 virt/kvm/kvm_main.c                   |   7 +-
 17 files changed, 339 insertions(+), 92 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
