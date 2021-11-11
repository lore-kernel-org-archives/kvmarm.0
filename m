Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF048C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 21:12:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30B1C61037
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 21:12:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 30B1C61037
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4414B174;
	Thu, 11 Nov 2021 16:12:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GePWHzpKuf8h; Thu, 11 Nov 2021 16:12:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE9D04B1CB;
	Thu, 11 Nov 2021 16:12:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60DA84B20E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 16:12:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YDErPoEG-yeZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Nov 2021 16:12:19 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F5FA4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 16:12:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6483260EFD;
 Thu, 11 Nov 2021 21:12:17 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mlHMl-004tjr-7y; Thu, 11 Nov 2021 21:12:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/4] KVM/arm64 fixes for 5.16, take #1
Date: Thu, 11 Nov 2021 21:11:31 +0000
Message-Id: <20211111211135.3991240-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, tabba@google.com, james.morse@arm.com,
 mark.rutland@arm.com, qperret@google.com, rdunlap@infradead.org,
 suzuki.poulose@arm.com, will@kernel.org, yuehaibing@huawei.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, YueHaibing <yuehaibing@huawei.com>,
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

Paolo,

Here's the first set of fixes for 5.16. The main items are a fix for a
host S2 issue for protected VM, as well as a correctness fix when
extracting the exception class from assembly code. The rest is
strictly cosmetic.

Please pull,

	M.

The following changes since commit 5a2acbbb0179a7ffbb5440b9fa46689f619705ac:

  Merge branch kvm/selftests/memslot into kvmarm-master/next (2021-10-21 11:40:03 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.16-1

for you to fetch changes up to 50a8d3315960c74095c59e204db44abd937d4b5d:

  KVM: arm64: Fix host stage-2 finalization (2021-11-08 18:07:48 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.16, take #1

- Fix the host S2 finalization by solely iterating over the memblocks
  instead of the whole IPA space

- Tighten the return value of kvm_vcpu_preferred_target() now that
  32bit support is long gone

- Make sure the extraction of ESR_ELx.EC is limited to the architected
  bits

- Comment fixups

----------------------------------------------------------------
Mark Rutland (1):
      KVM: arm64: Extract ESR_ELx.EC only

Quentin Perret (1):
      KVM: arm64: Fix host stage-2 finalization

Randy Dunlap (1):
      KVM: arm64: nvhe: Fix a non-kernel-doc comment

YueHaibing (1):
      KVM: arm64: Change the return type of kvm_vcpu_preferred_target()

 arch/arm64/include/asm/esr.h       |  1 +
 arch/arm64/include/asm/kvm_host.h  |  2 +-
 arch/arm64/kvm/arm.c               |  5 +----
 arch/arm64/kvm/guest.c             |  7 +------
 arch/arm64/kvm/hyp/hyp-entry.S     |  2 +-
 arch/arm64/kvm/hyp/nvhe/host.S     |  2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c    | 14 ++++++++++++--
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  2 +-
 8 files changed, 19 insertions(+), 16 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
