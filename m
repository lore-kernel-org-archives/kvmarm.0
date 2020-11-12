Return-Path: <SRS0=fMed=ES=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E561C2D0E4
	for <kvmarm@archiver.kernel.org>; Thu, 12 Nov 2020 22:22:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C193522201
	for <kvmarm@archiver.kernel.org>; Thu, 12 Nov 2020 22:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="PzAwW5y5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C193522201
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F34204BC9E;
	Thu, 12 Nov 2020 17:22:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JW1T31gqDrIZ; Thu, 12 Nov 2020 17:22:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D90604BCA1;
	Thu, 12 Nov 2020 17:22:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 850114BCA0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2020 17:22:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YlcFXjrzNGHt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Nov 2020 17:22:39 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E5EC4BCA5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2020 17:22:39 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DB7C9206C0;
 Thu, 12 Nov 2020 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605219758;
 bh=UQUwiBq8tWwyGEtWdZsI4uMA1qJTbHpjR+jMnbG5eV0=;
 h=From:To:Cc:Subject:Date:From;
 b=PzAwW5y5g8PIPo7brxJe6bZfQKtV0doSsNjkQ5xD82Gpf5Z9mCx5pDt7ErnHxy3T+
 YpMPKR7/PowNZS0MkKQV5FpyEUTPk86H4dcUFT9tL3xSVAFUeNfmUIkRY9AKnt+J1c
 SG1wrRYXJ8PO37cjjC0VfyRvgIN8R4teHCwlygos=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kdKzD-00ABHn-Np; Thu, 12 Nov 2020 22:22:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/3] KVM/arm64 fixes for 5.10, take #3
Date: Thu, 12 Nov 2020 22:21:36 +0000
Message-Id: <20201112222139.466204-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, liangpeng10@huawei.com, will@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
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

Here's another small set of fixes for 5.10, this time fixing some
corner cases of the Spectre mitigation rework. Note that I had to pull
5.10-rc1 into kvmarm/next in order to avoid some annoying conflicts.

Please pull,

	M.

The following changes since commit 4f6b838c378a52ea3ae0b15f12ca8a20849072fa:

  Merge tag 'v5.10-rc1' into kvmarm-master/next (2020-11-12 21:20:43 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-3

for you to fetch changes up to ed4ffaf49bf9ce1002b516d8c6aa04937b7950bc:

  KVM: arm64: Handle SCXTNUM_ELx traps (2020-11-12 21:22:46 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for v5.10, take #3

- Allow userspace to downgrade ID_AA64PFR0_EL1.CSV2
- Inject UNDEF on SCXTNUM_ELx access

----------------------------------------------------------------
Marc Zyngier (3):
      KVM: arm64: Allow setting of ID_AA64PFR0_EL1.CSV2 from userspace
      KVM: arm64: Unify trap handlers injecting an UNDEF
      KVM: arm64: Handle SCXTNUM_ELx traps

 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/asm/sysreg.h   |   4 ++
 arch/arm64/kvm/arm.c              |  16 ++++++
 arch/arm64/kvm/sys_regs.c         | 111 +++++++++++++++++++++++---------------
 4 files changed, 89 insertions(+), 44 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
