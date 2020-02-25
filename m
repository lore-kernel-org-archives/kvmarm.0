Return-Path: <SRS0=K0wf=4N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD029C4BA09
	for <kvmarm@archiver.kernel.org>; Tue, 25 Feb 2020 23:52:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A46524656
	for <kvmarm@archiver.kernel.org>; Tue, 25 Feb 2020 23:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjnL35vs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A46524656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4BF24AFC0;
	Tue, 25 Feb 2020 18:52:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PnpvtS2mWudC; Tue, 25 Feb 2020 18:52:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 411994AFBB;
	Tue, 25 Feb 2020 18:52:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21E134AFC0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Feb 2020 18:52:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id naHtcEtarmzJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Feb 2020 18:52:44 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 174784AFBB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Feb 2020 18:52:44 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C2A972176D;
 Tue, 25 Feb 2020 23:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582674762;
 bh=JAt+10w4pTyb4WokWSXrkj9e3fSa/lhHsi0hfJmHzm4=;
 h=From:To:Cc:Subject:Date:From;
 b=NjnL35vslyxSCJUxthm5XL7N4rxz1Bcbz4GG7ueerJlpLMMVellcTFHHVM9CYy4UF
 FezQFKCvMqN6Gko5oGLbxDnPFk4AVuLnRq85o05SS1Kwb+fhs1poi8wIVFf5ORUAPg
 FR36RKugApWByKPyix1o4ozVHaRYxW7iVpTBWm8I=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j6k0G-007xuY-S4; Tue, 25 Feb 2020 23:52:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm fixes for 5.6
Date: Tue, 25 Feb 2020 23:52:18 +0000
Message-Id: <20200225235223.12839-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, james.morse@arm.com, jcline@redhat.com,
 mark.rutland@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

This is a small update containing a number of fixes, the most important ones
making sure we force the inlining of any helper that gets used by the EL2 code
(James identified that some bad things happen with CLang and the Shadow Call
Stack extention).

Please pull,

	M.

The following changes since commit 4a267aa707953a9a73d1f5dc7f894dd9024a92be:

  KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer (2020-01-28 13:09:31 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.6-1

for you to fetch changes up to e43f1331e2ef913b8c566920c9af75e0ccdd1d3f:

  arm64: Ask the compiler to __always_inline functions used by KVM at HYP (2020-02-22 11:01:47 +0000)

----------------------------------------------------------------
KVM/arm fixes for 5.6, take #1

- Fix compilation on 32bit
- Move  VHE guest entry/exit into the VHE-specific entry code
- Make sure all functions called by the non-VHE HYP code is tagged as __always_inline

----------------------------------------------------------------
James Morse (3):
      KVM: arm64: Ask the compiler to __always_inline functions used at HYP
      KVM: arm64: Define our own swab32() to avoid a uapi static inline
      arm64: Ask the compiler to __always_inline functions used by KVM at HYP

Jeremy Cline (1):
      KVM: arm/arm64: Fix up includes for trace.h

Mark Rutland (1):
      kvm: arm/arm64: Fold VHE entry/exit work into kvm_vcpu_run_vhe()

 arch/arm/include/asm/kvm_host.h          |  3 --
 arch/arm64/include/asm/arch_gicv3.h      |  2 +-
 arch/arm64/include/asm/cache.h           |  2 +-
 arch/arm64/include/asm/cacheflush.h      |  2 +-
 arch/arm64/include/asm/cpufeature.h      | 10 +++----
 arch/arm64/include/asm/io.h              |  4 +--
 arch/arm64/include/asm/kvm_emulate.h     | 48 ++++++++++++++++----------------
 arch/arm64/include/asm/kvm_host.h        | 32 ---------------------
 arch/arm64/include/asm/kvm_hyp.h         |  7 +++++
 arch/arm64/include/asm/kvm_mmu.h         |  3 +-
 arch/arm64/include/asm/virt.h            |  2 +-
 arch/arm64/kvm/hyp/switch.c              | 39 ++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  4 +--
 virt/kvm/arm/arm.c                       |  2 --
 virt/kvm/arm/trace.h                     |  1 +
 15 files changed, 84 insertions(+), 77 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
