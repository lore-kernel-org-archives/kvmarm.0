Return-Path: <SRS0=vR/6=4E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852AEC7619B
	for <kvmarm@archiver.kernel.org>; Sun, 16 Feb 2020 18:53:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08F5920857
	for <kvmarm@archiver.kernel.org>; Sun, 16 Feb 2020 18:53:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcLuvQ6t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08F5920857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 921B94AF29;
	Sun, 16 Feb 2020 13:53:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d+7FOsxB9Vb7; Sun, 16 Feb 2020 13:53:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CDFF4AF07;
	Sun, 16 Feb 2020 13:53:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 540364AF20
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Feb 2020 13:53:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ClPt-o9PFJZZ for <kvmarm@lists.cs.columbia.edu>;
 Sun, 16 Feb 2020 13:53:41 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 048284AF18
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Feb 2020 13:53:41 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A672E20857;
 Sun, 16 Feb 2020 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581879219;
 bh=CDMcIuGZauuEKnBrc2rOLv93aehoxJbaP6h3f0RnX18=;
 h=From:To:Cc:Subject:Date:From;
 b=hcLuvQ6t0pWiScsDk331LZ8xUf9I4J6C+AiHvBLI3vBXX3yrK/XbyHYS20LSJm7YS
 X6PJnMmZQk1psVCfFEa5F8a92HT7yAYyrI5or5hNtb/dYcsUpg9QytOly26kPX5D2n
 0ayVE3bL7IL1dSbRJJwUUkf/Vakab8Ine9qDJ0Wc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j3P2v-005iWD-O3; Sun, 16 Feb 2020 18:53:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 0/5] Random debug/PMU fixes for 5.6
Date: Sun, 16 Feb 2020 18:53:19 +0000
Message-Id: <20200216185324.32596-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, peter.maydell@linaro.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

Here's a few cleanups and fixes for 5.6, all around our debug and
PMU ID register emulation:

1) Missing RES1 bit in DBGDIDR
2) Limiting PMU version to v8.1
3) Limiting debug version to ARMv8.0
4) Support for ARMv8.4-PMU

(1) was reported by Peter, (2) had a patch from Andrew Murray on the
list, but it's been a while since he was going to rebase and fix it,
so I did bite the bullet. (3) is needed until we implement the right
thing with NV. (4) was too easy not to be done right away.

Patch #2 is a cleanup that helps the following patches.

Unless someone objects, I'd like to take this into 5.6 (except maybe
for the last patch).

Marc Zyngier (5):
  KVM: arm64: Fix missing RES1 in emulation of DBGBIDR
  KVM: arm64: Refactor filtering of ID registers
  kvm: arm64: Limit PMU version to ARMv8.1
  KVM: arm64: Limit the debug architecture to ARMv8.0
  KVM: arm64: Upgrade PMU support to ARMv8.4

 arch/arm64/include/asm/sysreg.h |  2 ++
 arch/arm64/kvm/sys_regs.c       | 35 +++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 8 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
