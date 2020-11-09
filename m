Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8FFC2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 17:59:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0DF520781
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 17:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1WyyWxd6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0DF520781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 195944B977;
	Mon,  9 Nov 2020 12:59:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id suZNWiYEsOa3; Mon,  9 Nov 2020 12:59:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AAAB4B9A4;
	Mon,  9 Nov 2020 12:59:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D186C4B902
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 12:59:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cUB5drjERuR2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 12:59:30 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B605D4B4B7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 12:59:30 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 47E8920665;
 Mon,  9 Nov 2020 17:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604944769;
 bh=VB4W1R6Xidy63HPldBkvYgNymeTHvz90LHtlTza6wcQ=;
 h=From:To:Cc:Subject:Date:From;
 b=1WyyWxd6omZIqHS646zTRLqZpPKC0zBMKlpQ++0dgOSQlhLk+b4uq2Q45g3bt7jFP
 oWSo3EUsYmCs6w/muSDYPFB5Kmg2A1XuCLYVpmszzmdd08s+bMofK656RIoxq+7/VC
 mvacaEITP9Jz8ni9pNyFrBepc5qQ6ujtFysiCDvM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcBRv-009BQs-17; Mon, 09 Nov 2020 17:59:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 0/5] KVM: arm64: Host EL2 entry improvements
Date: Mon,  9 Nov 2020 17:59:18 +0000
Message-Id: <20201109175923.445945-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, ascull@google.com, will@kernel.org,
 qperret@google.com, ndesaulniers@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 ndesaulniers@google.com
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

This small series reworks various bits of the host EL2 entry after
Andrew's extensive rework to move from direct function calls to a
SMCCC implementation.

The first 2 patches allow the use of direct function pointers at EL2,
something that we can't do at the moment (other than PC-relative
addressing). This requires a helper to translate pointers at runtime,
but the result is neat enough. This allows the rewrite of the host HVC
handling in a more maintainable way.

Note that this version now includes the result of a discussion with
Nick, providing some funky pointer mangling in order to make the use
of these pointers vaguely safer (no, they are not safe at all).

Another patch removes the direct use of kimage_voffset, which we won't
be able to trust for much longer.

The last two patches are just cleanups and optimisations.

* From v1 [1]:
  - Merged the 3 first patches as fixes
  - Added pointer mangling for function calls
  - Moved EL2 entry ldp a couple of instructions later (as suggested
    by Alex)
  - Rebased on top of -rc3

[1] https://lore.kernel.org/r/20201026095116.72051-1-maz@kernel.org

Marc Zyngier (5):
  KVM: arm64: Add kimg_hyp_va() helper
  KVM: arm64: Turn host HVC handling into a dispatch table
  KVM: arm64: Patch kimage_voffset instead of loading the EL1 value
  KVM: arm64: Simplify __kvm_enable_ssbs()
  KVM: arm64: Avoid repetitive stack access on host EL1 to EL2 exception

 arch/arm64/include/asm/kvm_asm.h    |   2 -
 arch/arm64/include/asm/kvm_mmu.h    |  40 +++++
 arch/arm64/include/asm/sysreg.h     |   1 +
 arch/arm64/kernel/image-vars.h      |   5 +-
 arch/arm64/kvm/hyp/nvhe/host.S      |  11 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c  | 232 +++++++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c |  11 --
 arch/arm64/kvm/va_layout.c          |  56 +++++++
 8 files changed, 241 insertions(+), 117 deletions(-)

-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
