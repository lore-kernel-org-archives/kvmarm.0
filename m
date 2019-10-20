Return-Path: <SRS0=jJ2v=YN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E66CA9EA9
	for <kvmarm@archiver.kernel.org>; Sun, 20 Oct 2019 10:11:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F29B8222C3
	for <kvmarm@archiver.kernel.org>; Sun, 20 Oct 2019 10:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wZl1P5TR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F29B8222C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F5BA4AC0E;
	Sun, 20 Oct 2019 06:11:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MHCnLIayU6oW; Sun, 20 Oct 2019 06:11:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 938E14AC06;
	Sun, 20 Oct 2019 06:11:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4A674A9FB
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Oct 2019 06:11:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VNXUkIj3Ykjz for <kvmarm@lists.cs.columbia.edu>;
 Sun, 20 Oct 2019 06:11:35 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B8DAF4A99A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Oct 2019 06:11:35 -0400 (EDT)
Received: from big-swifty.lan (78.163-31-62.static.virginmediabusiness.co.uk
 [62.31.163.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 89A342190F;
 Sun, 20 Oct 2019 10:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1571566294;
 bh=R9nxM6A3Yhddcl9A7C/26LLhq+KqjO+NyOwb1yqAA94=;
 h=From:To:Cc:Subject:Date:From;
 b=wZl1P5TR+YzkoKz8Z0Krfdf4skT5kHoKhxSmiYkJoZu/u3uDDGVRFMn0t4GTos/u9
 +masS9rK4tdB5WNUk7ko/gKMJTmaJTpuqTCTETNz91MjZ+XPLk1mF3T/760PDMMKB5
 cAFy5HjwCjjvImUIHXutqDnA9xTObx4YpNbz5uQk=
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [GIT PULL] KVM/arm fixes for 5.4-rc5
Date: Sun, 20 Oct 2019 11:11:25 +0100
Message-Id: <20191020101129.2612-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

Paolo, Radim,

Here's the latest (and hopefully last) set of KVM/arm fixes for
5.4. 4 patches exclusively covering our PMU emulation, which exhibited
several different flavours of brokenness.

Please pull,

	M.

The following changes since commit da0c9ea146cbe92b832f1b0f694840ea8eb33cce:

  Linux 5.4-rc2 (2019-10-06 14:27:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.4-2

for you to fetch changes up to 8c3252c06516eac22c4f8e2506122171abedcc09:

  KVM: arm64: pmu: Reset sample period on overflow handling (2019-10-20 10:47:07 +0100)

----------------------------------------------------------------
KVM/arm fixes for 5.4, take #2

Special PMU edition:

- Fix cycle counter truncation
- Fix cycle counter overflow limit on pure 64bit system
- Allow chained events to be actually functional
- Correct sample period after overflow

----------------------------------------------------------------
Marc Zyngier (4):
      KVM: arm64: pmu: Fix cycle counter truncation
      arm64: KVM: Handle PMCR_EL0.LC as RES1 on pure AArch64 systems
      KVM: arm64: pmu: Set the CHAINED attribute before creating the in-kernel event
      KVM: arm64: pmu: Reset sample period on overflow handling

 arch/arm64/kvm/sys_regs.c |  4 ++++
 virt/kvm/arm/pmu.c        | 48 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 39 insertions(+), 13 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
