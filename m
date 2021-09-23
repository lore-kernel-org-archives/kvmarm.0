Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4E2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 11:23:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05CE16121F
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 11:23:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 05CE16121F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86DC34B101;
	Thu, 23 Sep 2021 07:23:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ysv0-R3+HloM; Thu, 23 Sep 2021 07:23:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E6D4B102;
	Thu, 23 Sep 2021 07:23:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C06CB4A19A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 07:23:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l9P6R86-KmeZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 07:23:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C399F4079A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 07:23:03 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33FF860EC0;
 Thu, 23 Sep 2021 11:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1632396182;
 bh=Lf3j0RI6dBAAadEUBstWTKcsG6r3BLFrYbLMIIdq9rI=;
 h=From:To:Cc:Subject:Date:From;
 b=nX69TkQH8ABpT3mauT5UkvOP0zX03qI6KiAt1zfmGl2dsK10sAfCojDPznQwCx0Y8
 nv+kBGyFQGzlfJQhPCEYLw7WRHhHNEZ669mpf4DvLA0BYw2YRYWRH1FRtdeQ9QLP8H
 py84L6nM+XyN6orHFTyWxaf1tL9A+8AvK0MFizcX3VpEnXgVSyf1TvATTPnUHMUXRL
 W3DeXBS+jD/jlDJFQEyCmx2Ge9U/jsw+Da8OV7oDTWfo/ots072ukRZpjl/ZbxKwd+
 kt8QmM5H2iOCRhACtfQ1s+KoLJ4ngLbd8FpDNyB01FX4m3za/guuqFCcWdcPAa7bZF
 yhqd1oNjQDwHg==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/5] KVM: arm64: Restrict host hypercalls when pKVM is enabled
Date: Thu, 23 Sep 2021 12:22:51 +0100
Message-Id: <20210923112256.15767-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hi folks,

This series restricts the hypercalls available to the KVM host on arm64
when pKVM is enabled so that it is not possible for the host to use them
to replace the EL2 component with something else.

This occurs in two stages: when switching to the pKVM vectors, the stub
hypercalls are removed and then later when pKVM is finalised, the pKVM
init hypercalls are removed.

There are still a few dubious calls remaining in terms of protecting the
guest (e.g. __kvm_adjust_pc) but these will be dealt with later when we
have more VM state at EL2 to play with.

Patches based on -rc2. Feedback welcome.

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu

--->8

Will Deacon (5):
  arm64: Prevent kexec and hibernation if is_protected_kvm_enabled()
  KVM: arm64: Reject stub hypercalls after pKVM has been initialised
  KVM: arm64: Propagate errors from __pkvm_prot_finalize hypercall
  KVM: arm64: Prevent re-finalisation of pKVM for a given CPU
  KVM: arm64: Disable privileged hypercalls after pKVM finalisation

 arch/arm64/include/asm/kvm_asm.h      | 43 ++++++++++---------
 arch/arm64/kernel/smp.c               |  3 +-
 arch/arm64/kvm/arm.c                  | 61 ++++++++++++++++++---------
 arch/arm64/kvm/hyp/nvhe/host.S        | 26 ++++++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c    | 26 +++++++-----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  3 ++
 6 files changed, 103 insertions(+), 59 deletions(-)

-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
