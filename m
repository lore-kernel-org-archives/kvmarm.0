Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096A2C43334
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 07:42:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71A9D4B3C0;
	Thu, 23 Jun 2022 03:42:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dL63uSgBN9aQ; Thu, 23 Jun 2022 03:42:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA3E4B3EF;
	Thu, 23 Jun 2022 03:42:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 047DB4B35D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 03:42:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1MGhpasHWVNm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 03:42:09 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7ABA4B2A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 03:42:09 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id BCB05619EC;
 Thu, 23 Jun 2022 07:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6E8C3411B;
 Thu, 23 Jun 2022 07:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655970128;
 bh=WML9r1cd5wF+m6iAIdB7bqD8vB6+5Fw1VRXN0c4B/rg=;
 h=From:To:Cc:Subject:Date:From;
 b=Y4SlPpdJ166I/PwZ//gpYEgSmN23VZGi5nLRncVg1iYd48LBXZW/JIzklAy6pBQvb
 Klmt3aI0DpKlV1j22lKbtNUVLnol6ebXN+BHlF8z/IWlloT5R65Xr1bJbaSpqzOyei
 cSx6WwGJI75qd1WyRgBDwOV8gxGm5b4rME1zcBOeK8qgeSb5SEYtV65uTy0/nougwj
 5awBF/DPxeSeKfALwwzwl2Czgv9QKQ3lOH+Y68ah6ehJRi/J/wIKH3fzKweaDE97qI
 KnNA3AR/Ao3b50jAgKEuJDss7O1O2xfK62UQyZgH4n9seaiMszp5nAKTEGEUViG6TQ
 m4beyr0ibv6rQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o4HTY-002WLt-Hu;
 Thu, 23 Jun 2022 08:42:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.19, take #2
Date: Thu, 23 Jun 2022 08:41:58 +0100
Message-Id: <20220623074158.1429243-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com,
 rppt@kernel.org, oupton@google.com, qperret@google.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Mike Rapoport <rppt@kernel.org>
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

Only two minor items this time around: a fix for a kmemleak regression
courtesy of Quentin, and the addition of Oliver Upton as an official
reviewer for the arm64 side.

Please pull,

	M.


The following changes since commit bcbfb588cf323929ac46767dd14e392016bbce04:

  KVM: arm64: Drop stale comment (2022-06-09 13:24:02 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.19-2

for you to fetch changes up to cbc6d44867a24130ee528c20cffcbc28b3e09693:

  KVM: arm64: Add Oliver as a reviewer (2022-06-17 09:49:41 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.19, take #2

- Fix a regression with pKVM when kmemleak is enabled

- Add Oliver Upton as an official KVM/arm64 reviewer

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Add Oliver as a reviewer

Quentin Perret (1):
      KVM: arm64: Prevent kmemleak from accessing pKVM memory

 MAINTAINERS          | 1 +
 arch/arm64/kvm/arm.c | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
