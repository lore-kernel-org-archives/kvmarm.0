Return-Path: <SRS0=R6td=AK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0959FC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 09:19:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 740EE233A2
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 09:19:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AlfuRkgw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 740EE233A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7ED74B40D;
	Mon, 29 Jun 2020 05:19:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6FKKYfyYpptL; Mon, 29 Jun 2020 05:19:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F16C74B410;
	Mon, 29 Jun 2020 05:19:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9754B3AA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 05:19:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZivEGCQABL2d for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 05:19:01 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD784B38E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 05:19:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593422341;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=ZZZna6SmL1tj42pOCXx23N1r7dPwCtIyv84ZAB8SCao=;
 b=AlfuRkgw1gpuLkcyCMtZQW3vmenwNKctLcvoep0dLvEtdUaAtNyfL4mhoigmgdXooJZBFK
 HG0tmjQzD8paWhktF7xoALoOsN1z/GVF9RAcW491ehHu60v/vYP0YiRrDD28RDspzqDPQi
 QYRxpShHRwdqe8tUVK09WdvhaDF+a6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-PZ7n9OsxO6GPYS9r9dH8qw-1; Mon, 29 Jun 2020 05:18:58 -0400
X-MC-Unique: PZ7n9OsxO6GPYS9r9dH8qw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23A661005513;
 Mon, 29 Jun 2020 09:18:57 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-102.bne.redhat.com
 [10.64.54.102])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 4DAC910013C1;
 Mon, 29 Jun 2020 09:18:53 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/2] Refactor ESR related functions
Date: Mon, 29 Jun 2020 19:18:39 +1000
Message-Id: <20200629091841.88198-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: catalin.marinas@arm.com, will@kernel.org,
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

This series bases on kvm/arm64 ("next") tree as below. It's preparatory
work for async page fault where the ESR is specified instead of fetching
from vCPU struct. Besides, HSR isn't meaningful since kvm/arm32 support
has been dropped. This refactors ESR related functions to serve them.

   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
   ("next" branch)

Gavin Shan (2):
  kvm/arm64: Rename HSR to ESR
  kvm/arm64: Detach ESR operator from vCPU struct

 arch/arm64/include/asm/esr.h         | 32 ++++++++++++++++++++
 arch/arm64/include/asm/kvm_emulate.h | 45 +++++++++++++---------------
 arch/arm64/include/uapi/asm/kvm.h    |  2 +-
 arch/arm64/kvm/handle_exit.c         | 32 ++++++++++----------
 arch/arm64/kvm/hyp/aarch32.c         |  2 +-
 arch/arm64/kvm/hyp/switch.c          | 14 ++++-----
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |  4 +--
 arch/arm64/kvm/mmu.c                 |  6 ++--
 arch/arm64/kvm/sys_regs.c            | 28 ++++++++---------
 arch/arm64/kvm/trace_arm.h           | 14 ++++-----
 arch/arm64/kvm/trace_handle_exit.h   | 10 +++----
 11 files changed, 108 insertions(+), 81 deletions(-)

-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
