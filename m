Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD573C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 13:13:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DE2D4B9F1;
	Fri, 25 Feb 2022 08:13:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dKh1t52fHJRS; Fri, 25 Feb 2022 08:13:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBE2B4B9E5;
	Fri, 25 Feb 2022 08:13:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82EBF4B9E0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:13:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zkPHWE7Y8a+e for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 08:13:11 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 314E34B9DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:13:11 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0C5E561C27;
 Fri, 25 Feb 2022 13:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E594C340E7;
 Fri, 25 Feb 2022 13:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645794789;
 bh=4OBpMBBHbqfE56ZBzZuNT14cSYoLBRUNEKj3d9XwRKg=;
 h=From:To:Cc:Subject:Date:From;
 b=axHqA1NTSELIxujgopmdO7bncVhWMLiNBuyj43f35EQ8KGzPa/h0POOZjeTqrBUcy
 fPdHZHZU3+yzm58hkNeCRL1yq3mK5KqV6/1CK7jyxRu6L9Tl6kcvOIvNkASr8gV+6U
 t/IYR+ADu8JunosPGA7HzbCUOu+7YR1nq6vPZtJkMoPVRHMO5ZabYw0D6YwsHA7tvx
 zkdm2HSnjSu6xEq6a4/rDPIKlKBO1tbMA119S5b4djhcLxP9ljGvvt1g2ztXUUP3vQ
 7S0CJstba87RQIY8sJbxpih4Kq6tkBnS4VjBSCylvXN2RBQU9kAaWTLVYn1tN87vA/
 HpRVzbh3/wvWA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nNaPC-00AWbe-Tx; Fri, 25 Feb 2022 13:13:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.17, take #4
Date: Fri, 25 Feb 2022 13:13:02 +0000
Message-Id: <20220225131302.107215-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, drjones@redhat.com,
 broonie@kernel.org, oupton@google.com, ricarkol@google.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Only a couple of fixes this time around: one for the long standing
PSCI CPU_SUSPEND issue, and a selftest fix for systems that don't have
a GICv3.

Please pull,

	M.

The following changes since commit 5bfa685e62e9ba93c303a9a8db646c7228b9b570:

  KVM: arm64: vgic: Read HW interrupt pending state from the HW (2022-02-11 11:01:12 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-4

for you to fetch changes up to 456f89e0928ab938122a40e9f094a6524cc158b4:

  KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3 (2022-02-25 13:02:28 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.17, take #4

- Correctly synchronise PMR and co on PSCI CPU_SUSPEND

- Skip tests that depend on GICv3 when the HW isn't available

----------------------------------------------------------------
Mark Brown (1):
      KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3

Oliver Upton (1):
      KVM: arm64: Don't miss pending interrupts for suspended vCPU

 arch/arm64/kvm/psci.c                            | 3 +--
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 7 ++++++-
 tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 4 ++++
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   | 4 +++-
 4 files changed, 14 insertions(+), 4 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
