Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E4FC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Nov 2022 20:11:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 532A14B97E;
	Mon, 14 Nov 2022 15:11:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id puUL9xt0sxar; Mon, 14 Nov 2022 15:11:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C874B962;
	Mon, 14 Nov 2022 15:11:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32DD14B936
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 15:11:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pGsnlbhPHg0H for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Nov 2022 15:11:39 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC8084B8CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 15:11:39 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668456698;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=c7eJcRQB0lx33rMvbkdk1U8UPwvqiEcNke7dhs9bXxk=;
 b=AsNWEzgq6M5I0JGjE3dhOXIXHo/2w12Pduf1EO+Yld+orfYsqG1+y+cmisW/BFDIU7ILBd
 860xTFmL+rX+U6HWpuhbcvzXAw3C9eC6dlLZu9rfYXnO3kGsxYS+Al0h4l7x7NgDCe+Wv9
 cjAPYp4tuawq+rrX19NYZ3yQ3xeRHg0=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 0/1] KVM: arm64: Skip RCU protection for hyp stage-1
Date: Mon, 14 Nov 2022 20:11:26 +0000
Message-Id: <20221114201127.1814794-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org,
 Marek Szyprowski <m.szyprowski@samsung.com>
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

Whelp, that was quick.

Marek reports [1] that the parallel faults series leads to a kernel BUG
when initializing the hyp stage-1 page tables. Work around the issue by
never acquiring the RCU read lock when walking hyp stage-1. This is safe
because hyp stage-1 is protected by a spinlock (pKVM) or mutex (regular
nVHE).

The included patch applies to the parallel faults series. To avoid
breaking bisection, the patch should immediately precede commit
c3119ae45dfb ("KVM: arm64: Protect stage-2 traversal with RCU"). Or, if
preferred, I can respin the whole series in the correct order.

Tested with the pKVM isolated vCPU state series [2] merged on top, w/
kvm-arm.mode={nvhe,protected} on an Ampere Altra system.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>

[1]: https://lore.kernel.org/kvmarm/d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com/
[2]: https://lore.kernel.org/linux-arm-kernel/20221110190259.26861-1-will@kernel.org/

Oliver Upton (1):
  KVM: arm64: Use a separate function for hyp stage-1 walks

 arch/arm64/include/asm/kvm_pgtable.h | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c      |  2 +-
 arch/arm64/kvm/hyp/pgtable.c         | 18 +++++++++++++++---
 3 files changed, 40 insertions(+), 4 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
