Return-Path: <SRS0=uq+A=EM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	RCVD_DOTEDU_SUSP,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F9DC55ABD
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 16:44:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B8DF22227
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 16:44:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ks7WKJLl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B8DF22227
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90A134B8A6;
	Fri,  6 Nov 2020 11:44:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2EtZIW3sFqMG; Fri,  6 Nov 2020 11:44:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1613E4B8B3;
	Fri,  6 Nov 2020 11:44:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29C634B8B0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 11:44:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id athumGX32x5n for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2020 11:44:39 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B0E94B8A7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 11:44:39 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A6EC12151B;
 Fri,  6 Nov 2020 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604681077;
 bh=9iUTO9V9vPdMlxcyJuoPtkCPdy41zNPPUWFKgP7BkOw=;
 h=From:To:Cc:Subject:Date:From;
 b=Ks7WKJLle02cLYsQQgyk9w62RINaerwNRmf10+VjBh95ZlWfrm9S5PwzeMdxzqy6b
 MkiAzpGRo7AaPEc+d0tTlsaq5nniQCwhRlvZRK+H1ZqVn8LHC5NALxTs+qMSMA7kTl
 2QIL16ALCeSJKNm50eH6Dn714OpONcvRV/WdPuOw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kb4qp-008FYW-Fr; Fri, 06 Nov 2020 16:44:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.10, take #2
Date: Fri,  6 Nov 2020 16:44:11 +0000
Message-Id: <20201106164416.326787-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com,
 eric.auger@redhat.com, gshan@redhat.com, xu910121@sina.com,
 dave.martin@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 =?UTF-8?q?=E5=BC=A0=E4=B8=9C=E6=97=AD?= <xu910121@sina.com>,
 linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
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

Here's the second set of fixes for 5.10. A compilation fix for
non-48bit VA builds and a live migration regressions are on the menu
this time. I have another set of regression fixes brewing, but in the
meantime this will fit nicely in mainline.

Please pull,

	M.

The following changes since commit 22f553842b14a1289c088a79a67fb479d3fa2a4e:

  KVM: arm64: Handle Asymmetric AArch32 systems (2020-10-30 16:06:22 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-2

for you to fetch changes up to c512298eed0360923d0cbc4a1f30bc0509af0d50:

  KVM: arm64: Remove AA64ZFR0_EL1 accessors (2020-11-06 16:00:29 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for v5.10, take #2

- Fix compilation error when PMD and PUD are folded
- Fix regresssion of the RAZ behaviour of ID_AA64ZFR0_EL1

----------------------------------------------------------------
Andrew Jones (4):
      KVM: arm64: Don't hide ID registers from userspace
      KVM: arm64: Consolidate REG_HIDDEN_GUEST/USER
      KVM: arm64: Check RAZ visibility in ID register accessors
      KVM: arm64: Remove AA64ZFR0_EL1 accessors

Gavin Shan (1):
      KVM: arm64: Fix build error in user_mem_abort()

 arch/arm64/kvm/mmu.c      |   2 +
 arch/arm64/kvm/sys_regs.c | 108 ++++++++++++++--------------------------------
 arch/arm64/kvm/sys_regs.h |  16 +++----
 3 files changed, 43 insertions(+), 83 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
