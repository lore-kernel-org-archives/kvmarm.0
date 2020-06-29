Return-Path: <SRS0=R6td=AK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD61DC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 16:25:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5874E25598
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 16:25:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ppSlbCZD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5874E25598
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C996F4B439;
	Mon, 29 Jun 2020 12:25:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qPyMIjRvghNT; Mon, 29 Jun 2020 12:25:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C653E4B448;
	Mon, 29 Jun 2020 12:25:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A79B04B443
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 12:25:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SXrSMI4LbIK1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 12:25:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABDB24B3E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 12:25:34 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 763CF25590;
 Mon, 29 Jun 2020 16:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593447933;
 bh=b7AT4TcF5146z4sJCRxR4jK16TDrwXxT+lOJTb6Ufpk=;
 h=From:To:Cc:Subject:Date:From;
 b=ppSlbCZD1v6btFHB3RK6H6kCie2cN7nclYGsybfoN/y6I9KItoVALr2CbZyQWsGII
 b2XcIwRt89lPrekX19kMY43+jEVICQV2z3kBm29DtIPUXuaw2GbDfm/dJ5tM7kDTQQ
 Q54rERPkFEYFqwuJiy+PdwgWDfTjqfZ84zlgNgI0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jpwb5-007M5T-RJ; Mon, 29 Jun 2020 17:25:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.8, take #2
Date: Mon, 29 Jun 2020 17:25:15 +0100
Message-Id: <20200629162519.825200-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 drjones@redhat.com, james.morse@arm.com, steven.price@arm.com,
 yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
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

Hi Paolo,

Here's another pull request for a handful of KVM/arm64 fixes. Nothing
absolutely critical (see the tag for the gory details), but I'd rather
get these merged as soon as possible.

Please pull,

	M.

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvmarm-fixes-5.8-2

for you to fetch changes up to a3f574cd65487cd993f79ab235d70229d9302c1e:

  KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell (2020-06-23 11:24:39 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.8, take #2

- Make sure a vcpu becoming non-resident doesn't race against the doorbell delivery
- Only advertise pvtime if accounting is enabled
- Return the correct error code if reset fails with SVE
- Make sure that pseudo-NMI functions are annotated as __always_inline

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: Annotate hyp NMI-related functions as __always_inline

Andrew Jones (1):
      KVM: arm64: pvtime: Ensure task delay accounting is enabled

Marc Zyngier (1):
      KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell

Steven Price (1):
      KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect with SVE

 arch/arm64/include/asm/arch_gicv3.h |  2 +-
 arch/arm64/include/asm/cpufeature.h |  2 +-
 arch/arm64/kvm/pvtime.c             | 15 ++++++++++++---
 arch/arm64/kvm/reset.c              | 10 +++++++---
 arch/arm64/kvm/vgic/vgic-v4.c       |  8 ++++++++
 drivers/irqchip/irq-gic-v3-its.c    |  8 ++++++++
 6 files changed, 37 insertions(+), 8 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
