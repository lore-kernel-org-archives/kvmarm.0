Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7327C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 29 Apr 2022 15:36:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E58F649F1D;
	Fri, 29 Apr 2022 11:36:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DtmeGh2cQV-s; Fri, 29 Apr 2022 11:36:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D888149F44;
	Fri, 29 Apr 2022 11:36:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4978F49F1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 11:36:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BKNv8L7vhQyN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2022 11:36:23 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D7C949EF8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 11:36:23 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DDB30621F9;
 Fri, 29 Apr 2022 15:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B66C385A7;
 Fri, 29 Apr 2022 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651246581;
 bh=BAgz6vYtSujJ/yUysgj+N8ugRgXzdEi+Mw7D0wyLeiY=;
 h=From:To:Cc:Subject:Date:From;
 b=iLgRz1NCf3HCJlCsT34FlyrY375tBr2mgNMV87dGuI0zj9N8pag/ky7noWuO6b6x9
 xfg5nx2D6jBBnNSHfO1KZw+w/qBVt1o7V5RQbtjpEgYfrrjohPZPr0MgfU6wyJPlxb
 0fPq3TUluj5H0pt72CyvpyD0xt+xKB7gWHxUDd58OC8gUgln/kuQmFdZcjDidOkH8K
 vSkCzVQjnZQFw2UMijH5XXtI6kxpTnjxmZxAPYWsj6J/lWECz+Fa1lEpisx4DyasJ6
 JBngxjusFW0I58PWnCzilB7GfTInrKxqQQhxQ0CQUguttLEiY4z1zElFpgKGroAer9
 lDSyN7igAf3oQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nkSfK-007ySy-OM; Fri, 29 Apr 2022 16:36:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.18, take #2
Date: Fri, 29 Apr 2022 16:36:15 +0100
Message-Id: <20220429153615.710743-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 christoffer.dall@arm.com, qperret@google.com, will@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, kernel-team@android.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Christoffer Dall <christoffer.dall@arm.com>, Will Deacon <will@kernel.org>,
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

Paolo,

Here's a trio of fixes for 5.18. Nothing terribly interesting, but
nonetheless important fixes (two of the bugs are related to AArch32).

Please pull,

	M.

The following changes since commit 21db83846683d3987666505a3ec38f367708199a:

  selftests: KVM: Free the GIC FD when cleaning up in arch_timer (2022-04-07 08:46:13 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.18-2

for you to fetch changes up to 85ea6b1ec915c9dd90caf3674b203999d8c7e062:

  KVM: arm64: Inject exception on out-of-IPA-range translation fault (2022-04-27 23:02:23 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.18, take #2

- Take care of faults occuring between the PARange and
  IPA range by injecting an exception

- Fix S2 faults taken from a host EL0 in protected mode

- Work around Oops caused by a PMU access from a 32bit
  guest when PMU has been created. This is a temporary
  bodge until we fix it for good.

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM/arm64: Don't emulate a PMU for 32-bit guests if feature not set

Marc Zyngier (1):
      KVM: arm64: Inject exception on out-of-IPA-range translation fault

Will Deacon (1):
      KVM: arm64: Handle host stage-2 faults from 32-bit EL0

 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/hyp/nvhe/host.S       | 18 +++++++++---------
 arch/arm64/kvm/inject_fault.c        | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                 | 19 +++++++++++++++++++
 arch/arm64/kvm/pmu-emul.c            | 23 ++++++++++++++++++++++-
 5 files changed, 79 insertions(+), 10 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
