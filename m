Return-Path: <SRS0=bs2E=2C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1E8C43603
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 17:28:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05E0F2173E
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 17:28:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05E0F2173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 715F44AEC5;
	Thu, 12 Dec 2019 12:28:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l9mGSngTI45z; Thu, 12 Dec 2019 12:28:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D7724AE99;
	Thu, 12 Dec 2019 12:28:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C836A4ACFA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 12:28:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Byh90-E-MKFS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Dec 2019 12:28:46 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1F9B4A541
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 12:28:46 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ifSGU-00069s-N1; Thu, 12 Dec 2019 18:28:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [GIT PULL] KVM/arm updates for 5.5-rc2
Date: Thu, 12 Dec 2019 17:28:16 +0000
Message-Id: <20191212172824.11523-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com,
 alexandru.elisei@arm.com, ard.biesheuvel@linaro.org, christoffer.dall@arm.com,
 eric.auger@redhat.com, james.morse@arm.com, justin.he@arm.com,
 mark.rutland@arm.com, linmiaohe@huawei.com, steven.price@arm.com,
 will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will@kernel.org>,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
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

This is the first set of fixes for 5.5-rc2. This time around,
a couple of MM fixes, a ONE_REG fix for an issue detected by
GCC-10, and a handful of cleanups.

Please pull,

	M.

The following changes since commit cd7056ae34af0e9424da97bbc7d2b38246ba8a2c:

  Merge remote-tracking branch 'kvmarm/misc-5.5' into kvmarm/next (2019-11-08 11:27:29 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.5-1

for you to fetch changes up to 6d674e28f642e3ff676fbae2d8d1b872814d32b6:

  KVM: arm/arm64: Properly handle faulting of device mappings (2019-12-12 16:22:40 +0000)

----------------------------------------------------------------
KVM/arm fixes for .5.5, take #1

- Fix uninitialised sysreg accessor
- Fix handling of demand-paged device mappings
- Stop spamming the console on IMPDEF sysregs
- Relax mappings of writable memslots
- Assorted cleanups

----------------------------------------------------------------
Jia He (1):
      KVM: arm/arm64: Remove excessive permission check in kvm_arch_prepare_memory_region

Marc Zyngier (1):
      KVM: arm/arm64: Properly handle faulting of device mappings

Mark Rutland (2):
      KVM: arm64: Sanely ratelimit sysreg messages
      KVM: arm64: Don't log IMP DEF sysreg traps

Miaohe Lin (3):
      KVM: arm/arm64: Get rid of unused arg in cpu_init_hyp_mode()
      KVM: arm/arm64: vgic: Fix potential double free dist->spis in __kvm_vgic_destroy()
      KVM: arm/arm64: vgic: Use wrapper function to lock/unlock all vcpus in kvm_vgic_create()

Will Deacon (1):
      KVM: arm64: Ensure 'params' is initialised when looking up sys register

 arch/arm64/kvm/sys_regs.c     | 25 ++++++++++++++++++-------
 arch/arm64/kvm/sys_regs.h     | 17 +++++++++++++++--
 virt/kvm/arm/arm.c            |  4 ++--
 virt/kvm/arm/mmu.c            | 30 +++++++++++++++++-------------
 virt/kvm/arm/vgic/vgic-init.c | 20 +++++---------------
 5 files changed, 57 insertions(+), 39 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
