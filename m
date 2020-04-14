Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFF4C2BB1D
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 21:31:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9259C2074D
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 21:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJNTUFI7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9259C2074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0CE4B21E;
	Tue, 14 Apr 2020 17:31:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WJIJWsvHAs8S; Tue, 14 Apr 2020 17:31:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27BA64B22C;
	Tue, 14 Apr 2020 17:31:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE7B4B21E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 17:31:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A+Wh8yMaPM5Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 17:31:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68AB74B213
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 17:31:25 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F369320644;
 Tue, 14 Apr 2020 21:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586899884;
 bh=qeG55Sjfpyu47bFN+MIW7aw5s10goy92+ZhxxXPxgLA=;
 h=From:To:Cc:Subject:Date:From;
 b=GJNTUFI7Ga6QB1tE8ADU5wTm6J3Znm9yDhnzk02eI1nHt2RXGL4ZBivouf8AzK+H+
 2r5KYB9HelKtM8LlTi5bi8/yFDKY3Jc0nUnhKXbOhKJDDy3xVyDIdguYTF0m7M0M8Z
 E6cmcsfaMMjenVFhUnJb+ao24FOPYE0P4rxLGmRE=
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/8] Relax sanity checking for mismatched AArch32 EL1
Date: Tue, 14 Apr 2020 22:31:06 +0100
Message-Id: <20200414213114.2378-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
 kernel-team@android.com, Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Doug Anderson <dianders@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

For better or worse, there are SoCs in production where some, but not
all of the CPUs, support AArch32 at EL1 and above. Right now, that
results in "SANITY CHECK" warnings during boot and an unconditional
kernel taint.

This patch series tries to do a bit better: the only time we care about
AArch32 at EL1 is for KVM, so rather than throw our toys out of the
pram, we can instead just disable support for 32-bit guests on these
systems. In the unlikely scenario of a late CPU hotplug being the first
time we notice that AArch32 is not available, then we fail the hotplug
(right now we let the thing come online, which leads to hilarious
results for any pre-existing 32-bit guests).

Feedback welcome,

Will

Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: kernel-team@android.com

--->8

Sai Prakash Ranjan (1):
  arm64: cpufeature: Relax check for IESB support

Will Deacon (7):
  arm64: cpufeature: Spell out register fields for ID_ISAR4 and ID_PFR1
  arm64: cpufeature: Add CPU capability for AArch32 EL1 support
  arm64: cpufeature: Remove redundant call to id_aa64pfr0_32bit_el0()
  arm64: cpufeature: Factor out checking of AArch32 features
  arm64: cpufeature: Relax AArch32 system checks if EL1 is 64-bit only
  arm64: cpufeature: Relax checks for AArch32 support at EL[0-2]
  arm64: cpufeature: Add an overview comment for the cpufeature
    framework

 arch/arm64/include/asm/cpucaps.h    |   3 +-
 arch/arm64/include/asm/cpufeature.h |   7 +
 arch/arm64/include/asm/sysreg.h     |  18 +++
 arch/arm64/kernel/cpufeature.c      | 236 +++++++++++++++++++++-------
 arch/arm64/kvm/reset.c              |  12 +-
 5 files changed, 206 insertions(+), 70 deletions(-)

-- 
2.26.0.110.g2183baf09c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
