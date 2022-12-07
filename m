Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BB0C4708D
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 21:48:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0EF44B83A;
	Wed,  7 Dec 2022 16:48:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xe44cnA4pljv; Wed,  7 Dec 2022 16:48:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D2DE4B837;
	Wed,  7 Dec 2022 16:48:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13F334B835
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 16:48:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cClKEcAnDC4q for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 16:48:22 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C08A84B834
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 16:48:22 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670449701;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=16LMNcduUmJXQJNzhs+CPaMIYUMzlfOKY+rOo3K6LbQ=;
 b=u63UBWyhpAxMlem/etDv9iTa0u6y7HKmhxIez0MD8dedIZiU5ViY2yr9IXP3CuYiD3RfWe
 J/6c2HMI5Lq/sZ/WcKkd8IWu6JHyh4J0YjR4lmfLolPHXcfudpJ5PoxihxSG4TSDFBnt8l
 PNKkzvRIBpGlvjTvrx90ImyS1fcbAwg=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 0/4] KVM: selftests: Fixes for ucall pool + page_fault_test
Date: Wed,  7 Dec 2022 21:48:04 +0000
Message-Id: <20221207214809.489070-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

The combination of the pool-based ucall implementation + page_fault_test
resulted in some 'fun' bugs, not the least of which is that our handling
of the VA space on arm64 is completely wrong.

Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
be squashed into Paolo's merge resolution, if desired.

Mark Brown (1):
  KVM: selftests: Fix build due to ucall_uninit() removal

Oliver Upton (3):
  KVM: selftests: Setup ucall after loading program into guest memory
  KVM: arm64: selftests: Align VA space allocator with TTBR0
  KVM: selftests: Allocate ucall pool from MEM_REGION_DATA

 .../selftests/kvm/aarch64/page_fault_test.c       |  9 +++++++--
 .../testing/selftests/kvm/include/kvm_util_base.h |  1 +
 .../testing/selftests/kvm/lib/aarch64/processor.c | 10 ++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c        | 15 ++++++++++-----
 tools/testing/selftests/kvm/lib/ucall_common.c    |  2 +-
 5 files changed, 29 insertions(+), 8 deletions(-)

-- 
2.39.0.rc0.267.gcb52ba06e7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
