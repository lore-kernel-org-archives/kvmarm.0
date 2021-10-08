Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5DCC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:58:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37E2461073
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 37E2461073
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B84654B156;
	Fri,  8 Oct 2021 09:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b+vW3RVTtrTx; Fri,  8 Oct 2021 09:58:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16A724B10E;
	Fri,  8 Oct 2021 09:58:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E43E54B0FB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:58:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zKzZW8O3nXgo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 09:58:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C004C4B089
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:58:50 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D01560FD8;
 Fri,  8 Oct 2021 13:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633701529;
 bh=qt4qPRpZDqP972BpcROFKMWTXqqtdlBS+kVAYhW5nnY=;
 h=From:To:Cc:Subject:Date:From;
 b=EkDiypqvcaB7DkOBZOcY+S4dX2SGaQSl6JIsiPx3b+pNCHmM+nQTKasmFVczJWcm1
 S0blUSmZ8teMSON1g0eluYDf1eEY7d2DWd48JCJd3HOahk6sGvx6bAuUBdP82leL2E
 T8hYr+z6765nE69dixOa+1ns41Pr0EbzjqLXayo4JhjfYikVUdQ/FVaPGCjueCliMn
 tjMJPmvXGhr/1Yn+naxdECb/bHP0wg8fXyM5mVwXg1ESdIOL4NFWBRlgvntHrRewUC
 Y9jCao85pLV6UisBtYWfZf9A4Gyggy3M+GQDGGSFh8vc0q0SQsotQiiRg5oXOD9hMW
 vQzDVpQfFuzPQ==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/6] KVM: arm64: Restrict host hypercalls when pKVM is
 enabled
Date: Fri,  8 Oct 2021 14:58:33 +0100
Message-Id: <20211008135839.1193-1-will@kernel.org>
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

Hi again folks,

This is version three of the patches I previously posted here:

  v1: https://lore.kernel.org/r/20210923112256.15767-1-will@kernel.org
  v2: https://lore.kernel.org/r/20211005113721.29441-1-will@kernel.org

Changes since v3 are:

  - Included proposed cleanup (using an enum) from Marc
  - Rebased onto -rc4

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

Marc Zyngier (1):
  KVM: arm64: Turn __KVM_HOST_SMCCC_FUNC_* into an enum (mostly)

Will Deacon (5):
  arm64: Prevent kexec and hibernation if is_protected_kvm_enabled()
  KVM: arm64: Reject stub hypercalls after pKVM has been initialised
  KVM: arm64: Propagate errors from __pkvm_prot_finalize hypercall
  KVM: arm64: Prevent re-finalisation of pKVM for a given CPU
  KVM: arm64: Disable privileged hypercalls after pKVM finalisation

 arch/arm64/include/asm/kvm_asm.h      | 47 ++++++++++++---------
 arch/arm64/kernel/smp.c               |  3 +-
 arch/arm64/kvm/arm.c                  | 61 ++++++++++++++++++---------
 arch/arm64/kvm/hyp/nvhe/host.S        | 26 ++++++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c    | 37 +++++++++++-----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  3 ++
 6 files changed, 117 insertions(+), 60 deletions(-)

-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
