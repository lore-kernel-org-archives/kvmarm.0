Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D29C433EA
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 08:23:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67CAA2075D
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 08:23:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhwUUQid"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67CAA2075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05D694B8D1;
	Tue, 28 Jul 2020 04:23:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xMskZbQ7qAcF; Tue, 28 Jul 2020 04:23:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D076F4B904;
	Tue, 28 Jul 2020 04:23:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5BE94B8D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 04:23:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AGtmM3AMyr7j for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 04:23:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AE9B4B858
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 04:23:25 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5E64A2075D;
 Tue, 28 Jul 2020 08:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595924604;
 bh=s+JcctlNG0hHX2xEwi6C3ENfXMCtVb68JpHdq0Skmw4=;
 h=From:To:Cc:Subject:Date:From;
 b=FhwUUQidy339zU5Wogz7l7ZnPOqzOczutbqIH2gK1BTX5z0NE9l7Ve489HTCVByJR
 5FoMU64OWFU+Dy1nx65lqauBVZMUso+rxZB+85ve4BCguqOnD/Wqy9eerAg2rICaOl
 8x8WSiJjUkToSjV+fWon8nmzf7GyS8B66OyclbPA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k0KtO-00FaXh-S3; Tue, 28 Jul 2020 09:23:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.8, take #4
Date: Tue, 28 Jul 2020 09:22:53 +0100
Message-Id: <20200728082255.3864378-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, natechancellor@gmail.com,
 ndesaulniers@google.com, qperret@google.com, will@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Nick Desaulniers <ndesaulniers@google.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, Will Deacon <will@kernel.org>,
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

Hi Paolo,

This is the last batch of fixes for 5.8. One fixes a long standing MMU
issue, while the other addresses a more recent brekage with out-of-line
helpers in the nVHE code.

Please pull,

	M.

The following changes since commit b9e10d4a6c9f5cbe6369ce2c17ebc67d2e5a4be5:

  KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART (2020-07-06 11:47:02 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-4

for you to fetch changes up to b757b47a2fcba584d4a32fd7ee68faca510ab96f:

  KVM: arm64: Don't inherit exec permission across page-table levels (2020-07-28 09:03:57 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for Linux 5.8, take #3

- Fix a corner case of a new mapping inheriting exec permission without
  and yet bypassing invalidation of the I-cache
- Make sure PtrAuth predicates oinly generate inline code for the
  non-VHE hypervisor code

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL functions

Will Deacon (1):
      KVM: arm64: Don't inherit exec permission across page-table levels

 arch/arm64/include/asm/kvm_host.h | 11 ++++++++---
 arch/arm64/kvm/mmu.c              | 11 ++++++-----
 2 files changed, 14 insertions(+), 8 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
