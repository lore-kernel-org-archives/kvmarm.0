Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B29DC433E2
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 11:05:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDC9020702
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 11:05:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nb5VlpUd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDC9020702
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CCE94B3DF;
	Mon,  6 Jul 2020 07:05:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bCftGllFcsBo; Mon,  6 Jul 2020 07:05:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F9A34B3BF;
	Mon,  6 Jul 2020 07:05:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D51BB4B3B3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 07:05:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hucvVZ+4OyXy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2020 07:05:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D20DE4B231
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 07:05:34 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A2B4720702;
 Mon,  6 Jul 2020 11:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594033533;
 bh=9kr+e0WqelRZAHC+EjyVK5a1yKFu0am5W9PV61qCJ/M=;
 h=From:To:Cc:Subject:Date:From;
 b=nb5VlpUdrMtbaFj/LREbkP6egDcLJFXP6Sff1ggM3a5LaJ6WtxR3pOoeSivdGX45A
 THNSajLGhpHwtoQpmKVvTmTJG8PrwvUYuOVrU2CjnDVhF+2k6zyWCkPmyhOyRVvk34
 +PVzJu27gPv5R1w3nDuxuNY+DqDC4bLlHIUcMVco=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jsOwF-009Qgb-WF; Mon, 06 Jul 2020 12:05:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/2] KVM/arm64 fixes for 5.8, take #3
Date: Mon,  6 Jul 2020 12:05:19 +0100
Message-Id: <20200706110521.1615794-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ascull@google.com,
 amurray@thegoodpenguin.co.uk, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Murray <amurray@thegoodpenguin.co.uk>
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

Yet another small batch of fixes for 5.8. One is a long standing
preemption issue that got uncovered by another fix that went in
5.8. The other one is a fix for an issue potentially affecting kexec.

Please pull,

	M.

The following changes since commit a3f574cd65487cd993f79ab235d70229d9302c1e:

  KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell (2020-06-23 11:24:39 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-3

for you to fetch changes up to b9e10d4a6c9f5cbe6369ce2c17ebc67d2e5a4be5:

  KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART (2020-07-06 11:47:02 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.8, take #3

- Disable preemption on context-switching PMU EL0 state happening
  on system register trap
- Don't clobber X0 when tearing down KVM via a soft reset (kexec)

----------------------------------------------------------------
Andrew Scull (1):
      KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART

Marc Zyngier (1):
      KVM: arm64: PMU: Fix per-CPU access in preemptible context

 arch/arm64/kvm/hyp-init.S | 11 +++++++----
 arch/arm64/kvm/pmu.c      |  7 ++++++-
 2 files changed, 13 insertions(+), 5 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
