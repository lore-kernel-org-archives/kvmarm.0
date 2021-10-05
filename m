Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CA1C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 11:37:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 854A0610A2
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 11:37:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 854A0610A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1525C4B2E7;
	Tue,  5 Oct 2021 07:37:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oG+L2GgAr7ZP; Tue,  5 Oct 2021 07:37:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7894B2C8;
	Tue,  5 Oct 2021 07:37:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C72894B2C5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 07:37:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wSD0mMLpE1hO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 07:37:37 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFE794B2C4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 07:37:37 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58EF66137D;
 Tue,  5 Oct 2021 11:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633433855;
 bh=8rC7TkQRI4Ykl4Vk7FqeIKTuwSqHJtas0KsHtaKv2RA=;
 h=From:To:Cc:Subject:Date:From;
 b=qf3ONviZwH7xPPW+001QpT2TlJ1v5JzwF1oCV0QEtt9T/Ov4w9mgkl97k619XUpHE
 HOw/2B0nLLeXtxBst+tLtvRAuEiq1Y+/zR/HtpmLTXE3R6Q0pHowoaCPUdofzuj1hX
 5xepSnXlFJ8Oqm4uKmCWSv4uatwCn3RUEJ+XsXceFezs2gIu38adcqghmFvR0uT/xC
 JLRQu+uZenbpbwRYhenP6XfWk79/dVxdzCDI+Q1z8v+JcOhMtMOw566Mp0XbwUswPo
 3z3/giPvKcv5nkhenncAI8Un0cHwRuOfuwiacgRJUyhnTr/+nUoeT5XQK+rqUkSnRU
 4+tRLJcD32dtw==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/5] KVM: arm64: Restrict host hypercalls when pKVM is
 enabled
Date: Tue,  5 Oct 2021 12:37:16 +0100
Message-Id: <20211005113721.29441-1-will@kernel.org>
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

Hi all,

This is version two of the patches I previously posted here:

  https://lore.kernel.org/r/20210923112256.15767-1-will@kernel.org

Changes since v2 include:

  - Add a comment about pkvm_prot_finalize() returning -EPERM
  - Fixed ordering of hypercalls in 'host_hcall' array
  - Added reviewed-by tags

Patches based on -rc2. Feedback welcome.

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
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
 arch/arm64/kvm/hyp/nvhe/hyp-main.c    | 37 +++++++++++-----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  3 ++
 6 files changed, 113 insertions(+), 60 deletions(-)

-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
