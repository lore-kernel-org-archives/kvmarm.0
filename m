Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8A6C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 15:08:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94BB749E43;
	Fri,  8 Apr 2022 11:07:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VIAnEhjIQN9c; Fri,  8 Apr 2022 11:07:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67C2849DF6;
	Fri,  8 Apr 2022 11:07:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE40449B07
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 11:07:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z37r4xKDxuGI for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 11:07:55 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5195411BD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 11:07:55 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 81B6A61EA5;
 Fri,  8 Apr 2022 15:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD969C385A3;
 Fri,  8 Apr 2022 15:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649430473;
 bh=5j8bxG+Xf5JcARca/W0PU8fTbYvFa41eJ4g77CdktOU=;
 h=From:To:Cc:Subject:Date:From;
 b=OwUH05q+9KXFfOSC4yZMPKORuPjU2H+csDTW56fdTil9Rcr3EV6aFZ81NwQs2NcHw
 jgUkyvGNLZA/DrjBi3v+MPfPAToU+tXsQxN+D0krBSo31CprBCbej/u5sNdDMz+IRG
 pmLOnIsm+7z3hB29qdYykcPmUH5UEh1zdXAljBGhp8qewIqpOnj2eRaCcpjDYL4muA
 xa//E8oFKVOJ9pHjhoIDT8GDblUy5WJ1TPbN709l7HohctsAZNu2FTnLcJZhbwrTHR
 GeeV2lYcIwAeKX9ky1WOAi0OTJF8Z/ip7SI43EY8esIeUvM8hdQUmgmVt6f4Cs/c7v
 bjGtVHB7xj/VQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1ncqDH-002o1A-Bu; Fri, 08 Apr 2022 16:07:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.18, take #1
Date: Fri,  8 Apr 2022 16:07:46 +0100
Message-Id: <20220408150746.260017-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com,
 jingzhangos@google.com, oupton@google.com, reijiw@google.com, will@kernel.org,
 yuzhe@nfschina.com, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Paolo,

Here's the first batches of fixes for 5.18 (most of it courtesy of
Oliver). The two important items here are a MMU rwlock fix when
splitting block mappings, and a debugfs registration issue resulting
in a potentially spectacular outcome.

Please pull,

	M.

The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:

  Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.18-1

for you to fetch changes up to 21db83846683d3987666505a3ec38f367708199a:

  selftests: KVM: Free the GIC FD when cleaning up in arch_timer (2022-04-07 08:46:13 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.18, take #1

- Some PSCI fixes after introducing PSCIv1.1 and SYSTEM_RESET2

- Fix the MMU write-lock not being taken on THP split

- Fix mixed-width VM handling

- Fix potential UAF when debugfs registration fails

- Various selftest updates for all of the above

----------------------------------------------------------------
Andrew Jones (1):
      KVM: selftests: get-reg-list: Add KVM_REG_ARM_FW_REG(3)

Oliver Upton (7):
      KVM: arm64: Generally disallow SMC64 for AArch32 guests
      KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32
      KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler
      KVM: arm64: Don't split hugepages outside of MMU write lock
      KVM: Don't create VM debugfs files outside of the VM directory
      selftests: KVM: Don't leak GIC FD across dirty log test iterations
      selftests: KVM: Free the GIC FD when cleaning up in arch_timer

Reiji Watanabe (2):
      KVM: arm64: mixed-width check should be skipped for uninitialized vCPUs
      KVM: arm64: selftests: Introduce vcpu_width_config

Yu Zhe (1):
      KVM: arm64: vgic: Remove unnecessary type castings

 arch/arm64/include/asm/kvm_emulate.h               |  27 +++--
 arch/arm64/include/asm/kvm_host.h                  |  10 ++
 arch/arm64/kvm/mmu.c                               |  11 +-
 arch/arm64/kvm/psci.c                              |  31 +++---
 arch/arm64/kvm/reset.c                             |  65 +++++++----
 arch/arm64/kvm/vgic/vgic-debug.c                   |  10 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |   2 +-
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |  15 ++-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |  14 ++-
 .../selftests/kvm/aarch64/vcpu_width_config.c      | 122 +++++++++++++++++++++
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  34 +++++-
 virt/kvm/kvm_main.c                                |  10 +-
 14 files changed, 285 insertions(+), 68 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
