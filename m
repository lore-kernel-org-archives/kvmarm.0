Return-Path: <SRS0=ZPfy=BI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7410BC433DF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jul 2020 10:28:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E29902083B
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jul 2020 10:28:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIS/Nmbf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E29902083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 618C74B53E;
	Wed, 29 Jul 2020 06:28:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rCC9pWleaRUc; Wed, 29 Jul 2020 06:28:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 954AA4B551;
	Wed, 29 Jul 2020 06:28:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14D3F4B549
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jul 2020 06:28:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vqkejcxHiXqy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jul 2020 06:28:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C9364B53C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jul 2020 06:28:27 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 084AE206D4;
 Wed, 29 Jul 2020 10:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596018506;
 bh=OV8Q9chiN1dhcOrS3acpO8IjQZ3jxCwC1wadS7xchSI=;
 h=From:To:Cc:Subject:Date:From;
 b=dIS/NmbfPix05mFEShDhJhFpvMqjnx8Xzl/GtokK8jy9ExXed7SdP0YtzhqUzzMfR
 5V4fepj3NuDFzO1ZATSR0ufc1STNSGUh3pavtpsvdHiedi+eYVstGLxQnGoVfPrN03
 Za61g1iNQIsqMTeZvemzKjPWGCXxOc7ex75u78mQ=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/4] KVM: arm64: Fixes to early stage-2 fault handling
Date: Wed, 29 Jul 2020 11:28:17 +0100
Message-Id: <20200729102821.23392-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
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

Hi all,

This is version two of the patches I posted last week:

  https://lore.kernel.org/r/20200724143506.17772-1-will@kernel.org

I got my brain in a twist with exactly what is reported in HPFAR for
a stage-2 abort on a stage-1 table walk, so I don't think any of these
are serious any more.

With these changes, the early stage-2 fault handling follows:

S2 instruction abort:
  * Not in memslot, or S2 fault on S1 walk for tables in R/O memslot:
	=> inject external iabt to guest

S2 data abort:
  * Not in memslot:
    - S2 fault on S1 walk:      inject external dabt to guest
    - Cache maintenance:        skip instr
    - Syndrome valid            EXIT_MMIO
    - Syndrome invalid          EXIT_NISV
  * Write fault in R/O memslot:
    - S2 fault on S1 walk:      inject external dabt to guest
    - Access is write:
      - Syndrome valid          EXIT_MMIO
      - Syndrome invalid        EXIT_NISV (includes cache maintenance)

Everything else gets handled by handle_access_fault()/user_mem_abort().

Will

Cc: James Morse <james.morse@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: kernel-team@android.com

--->8

Will Deacon (4):
  KVM: arm64: Rename kvm_vcpu_dabt_isextabt()
  KVM: arm64: Handle data and instruction external aborts the same way
  KVM: arm64: Don't skip cache maintenance for read-only memslots
  KVM: arm64: Move S1PTW S2 fault logic out of io_mem_abort()

 arch/arm64/include/asm/kvm_emulate.h |  2 +-
 arch/arm64/kvm/hyp/switch.c          |  2 +-
 arch/arm64/kvm/mmio.c                |  6 ------
 arch/arm64/kvm/mmu.c                 | 26 +++++++++++++++++---------
 4 files changed, 19 insertions(+), 17 deletions(-)

-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
