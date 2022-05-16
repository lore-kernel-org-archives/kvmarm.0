Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC87C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 12:52:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21BE54B23A;
	Mon, 16 May 2022 08:52:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 07fb2rWsKY-F; Mon, 16 May 2022 08:52:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D32324B236;
	Mon, 16 May 2022 08:52:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1BD74B236
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 08:52:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o091khCiF079 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 08:52:11 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 977974B12E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 08:52:11 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 158756121E;
 Mon, 16 May 2022 12:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762ACC385AA;
 Mon, 16 May 2022 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652705529;
 bh=lMqrH8tUWPiPNpp7YGN4p4ypyHXlAjPKtD0Fl41tSJ4=;
 h=From:To:Cc:Subject:Date:From;
 b=gcqzLdfgWD+vGB1UXhXVa1Mdoe/NiQKF8S4HMwqLc05eiSy9OqShf6jLUYCEeylh7
 zpgiZlU1J5+YPeFL1U41HUfAVVikwHQubO0In05+n30tl55iYWVgXeIlxMpLrtW5UD
 NmIz314S5DVW8jwQY81kjsJaj/FI+AWNxKxZNNAFblZOK2UgwIDdNaDZ4PiWglOyZP
 jPu3G/sSzlhXCyRd/tjmfZrT2f7/nenTW3sexkyHYduXnRXVRXLoEwAZxLC0reo/0N
 VLSgG2uAEwYsuV9uDo1f09bWQ1Ke3YkJ6mdVmnSciqONmV2psqRRzFHYFGKGIsnlOe
 dG83F1+xVYZhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nqaCk-00Bc9J-FA; Mon, 16 May 2022 13:52:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.18, take #3
Date: Mon, 16 May 2022 13:51:51 +0100
Message-Id: <20220516125151.955808-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oupton@google.com,
 peter.maydell@linaro.org, qperret@google.com, will@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
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

Here's the third (and hopefully final) set of fixes for 5.18. Two
rather simple patches: one addressing a userspace-visible change in
behaviour with GICv3, and a fix for pKVM in combination with CPUs
affected by Spectre-v3a.

Please pull,

	M.

The following changes since commit 85ea6b1ec915c9dd90caf3674b203999d8c7e062:

  KVM: arm64: Inject exception on out-of-IPA-range translation fault (2022-04-27 23:02:23 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.18-3

for you to fetch changes up to 2e40316753ee552fb598e8da8ca0d20a04e67453:

  KVM: arm64: Don't hypercall before EL2 init (2022-05-15 12:14:14 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.18, take #3

- Correctly expose GICv3 support even if no irqchip is created
  so that userspace doesn't observe it changing pointlessly
  (fixing a regression with QEMU)

- Don't issue a hypercall to set the id-mapped vectors when
  protected mode is enabled

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: vgic-v3: Consistently populate ID_AA64PFR0_EL1.GIC

Quentin Perret (1):
      KVM: arm64: Don't hypercall before EL2 init

 arch/arm64/kvm/arm.c      | 3 ++-
 arch/arm64/kvm/sys_regs.c | 3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
