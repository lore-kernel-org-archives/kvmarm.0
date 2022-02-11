Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0109C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 11:11:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1996A49F0A;
	Fri, 11 Feb 2022 06:11:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uT7BrnmIC8+P; Fri, 11 Feb 2022 06:11:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 526E649F58;
	Fri, 11 Feb 2022 06:11:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C33A49F53
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 06:11:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uvVu1v5bGUgO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Feb 2022 06:11:40 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 985CC49F4C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 06:11:40 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 287C1CE28EE;
 Fri, 11 Feb 2022 11:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE00C340E9;
 Fri, 11 Feb 2022 11:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644577894;
 bh=XcXopvQueCV0LSDmB58A44DQ/iBicjp0IvAb57hZnvQ=;
 h=From:To:Cc:Subject:Date:From;
 b=ONspbpiEBIBYIIHqwLaIhxvCBiTEOSvWECoAhAyBJO9ub6Di8pnDcH+NwBjwimWqb
 4uIawp9P78OeMPYKeDVL0Ilsiw/M1EEd+YwxMERcZj/cWKpegmKfs1wTlSvWGNcUh5
 lAd47lzfGbtQodVIj+uqAWJVF3TWHv+my0NMrQfD3Eb3aP87ps5iLP5OhxzVWa+J4r
 +PHY+mqni4tcTVce+4v579ukOcF+kCh08kkKRpDiGhjGr0Zy2pO344xngKquCkeNvr
 TsuDt3jLMvAz+XjEiOhAi3wSwhft0Cnfj417fcS0u3kqwiNVLYkVNnoCcSlAX7TXBd
 8qXHaHJlgui4A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nITps-0079Ec-Hw; Fri, 11 Feb 2022 11:11:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.17, take #3
Date: Fri, 11 Feb 2022 11:11:29 +0000
Message-Id: <20220211111129.1180161-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ricarkol@google.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Here's a single fix for 5.7, addressing a minor defect affecting HW
how the pending state of HW interrupts is reported via the MMIO
interface of the GIC.

Please pull,

	M.

The following changes since commit 1dd498e5e26ad71e3e9130daf72cfb6a693fee03:

  KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata (2022-02-03 09:22:30 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-3

for you to fetch changes up to 5bfa685e62e9ba93c303a9a8db646c7228b9b570:

  KVM: arm64: vgic: Read HW interrupt pending state from the HW (2022-02-11 11:01:12 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.17, take #3

- Fix pending state read of a HW interrupt

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: vgic: Read HW interrupt pending state from the HW

 arch/arm64/kvm/vgic/vgic-mmio.c | 2 ++
 1 file changed, 2 insertions(+)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
