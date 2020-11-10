Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,RCVD_DOTEDU_SUSP,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29337C388F7
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 13:36:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9580E21D40
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 13:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HyF962h6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9580E21D40
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 030F54B997;
	Tue, 10 Nov 2020 08:36:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8e89vhAafTNO; Tue, 10 Nov 2020 08:36:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC33A4B98A;
	Tue, 10 Nov 2020 08:36:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5387C4B869
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 08:36:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vmn9x2NItOGJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 08:36:31 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23BCB4B767
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 08:36:31 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9C630206B6;
 Tue, 10 Nov 2020 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605015389;
 bh=lkIGiFv1b4/nNPUJbCd5QdY105G4U0sOjAEfhYSdOOg=;
 h=From:To:Cc:Subject:Date:From;
 b=HyF962h6OGyVJupnay/O799NbeCbLjWLLerrcTm01Bq3Ed3G1mELngwKqPdT/rzmi
 7s36TYAhcC7CMPWPKJR4tCOoiwt3fxA5pHxQXUzkKRuTL2bMD6hTInN861ZCJsfwfK
 ym6lKaCPjED6+ITuU66O4anrwC4m6gVRhYb5FrCs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcTox-009SZy-Cm; Tue, 10 Nov 2020 13:36:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/9] KVM: arm64: Kill the copro array
Date: Tue, 10 Nov 2020 13:36:10 +0000
Message-Id: <20201110133619.451157-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

Since the very beginning of KVM/arm64, we represented the system
register file using a dual view: on one side the AArch64 state, on the
other a bizarre mapping of the AArch32 state onto the Aarch64
registers.

It was nice at the time as it allowed us to share some code with the
32bit port, and to come up with some creative bugs. But is was always
a hack, and we are now in a position to simplify the whole thing.

This series goes through the whole of the AArch32 cp14/15 register
file, and point each of them directly at their 64bit equivalent. For
the few cases where two 32bit registers share a 64bit counterpart, we
define which half of the register they map.

Finally, we drop a large number of definitions and state that have
become useless.

This series applies on top of the exception injection rework
previously posted [2].

* From v1 [1]:
  - Added initial patch to deal with TTBCR2
  - Fixed TCR_EL1 handling in inject_abt32()
  - Optimise for 64bit handling of sysreg access
  - Make most 32bit cp14 registers access the full 64bit register

[1] https://lore.kernel.org/r/20201102191609.265711-1-maz@kernel.org
[2] https://lore.kernel.org/r/20201102164045.264512-1-maz@kernel.org

Marc Zyngier (9):
  KVM: arm64: Introduce handling of AArch32 TTBCR2 traps
  KVM: arm64: Move AArch32 exceptions over to AArch64 sysregs
  KVM: arm64: Add AArch32 mapping annotation
  KVM: arm64: Map AArch32 cp15 register to AArch64 sysregs
  KVM: arm64: Map AArch32 cp14 register to AArch64 sysregs
  KVM: arm64: Drop is_32bit trap attribute
  KVM: arm64: Drop is_aarch32 trap attribute
  KVM: arm64: Drop legacy copro shadow register
  KVM: arm64: Drop kvm_coproc.h

 arch/arm64/include/asm/kvm_coproc.h |  38 -----
 arch/arm64/include/asm/kvm_host.h   |  73 +++------
 arch/arm64/kvm/arm.c                |   3 +-
 arch/arm64/kvm/guest.c              |   1 -
 arch/arm64/kvm/handle_exit.c        |   1 -
 arch/arm64/kvm/inject_fault.c       |  62 +++-----
 arch/arm64/kvm/reset.c              |   1 -
 arch/arm64/kvm/sys_regs.c           | 233 +++++++++++++---------------
 arch/arm64/kvm/sys_regs.h           |   9 +-
 arch/arm64/kvm/vgic-sys-reg-v3.c    |   4 -
 10 files changed, 151 insertions(+), 274 deletions(-)
 delete mode 100644 arch/arm64/include/asm/kvm_coproc.h

-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
