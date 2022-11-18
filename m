Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3E4C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 18:22:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44AA84B9BE;
	Fri, 18 Nov 2022 13:22:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3SCeCVKWAT4h; Fri, 18 Nov 2022 13:22:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 282AB4B9F8;
	Fri, 18 Nov 2022 13:22:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68B6A4B9E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 13:22:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id syiYz1oC-tv3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 13:22:34 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EFEE4B9BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 13:22:34 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668795752;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=X3QgCq9Cs1WQYoJL0dvRfozZCN58kkuvkY3dlbpQxA0=;
 b=lNR7BG2xlqj9DA3KvAaQJbfmbXR8ph56cTV2x9m89DaPyumgHHR9/DGSNBKAvckoa0b6Pp
 UuDMc2gPhsNp+XbYnttyuhGhZMPnLOYzmcYsbalOM2noVK3bZ7f0fHCPves1FwYShNimdp
 tFDjE/qc/9BtPLR32uCBbZu2VNneSdg=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v4 0/3] KVM: arm64: Fixes for parallel faults series
Date: Fri, 18 Nov 2022 18:22:19 +0000
Message-Id: <20221118182222.3932898-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Small set of fixes for the parallel faults series. Most importantly,
stop taking the RCU read lock for walking hyp stage-1. For the sake of
consistency, take a pointer to kvm_pgtable_walker in
kvm_dereference_pteref() as well.

Tested on an Ampere Altra system with kvm-arm.mode={nvhe,protected} and
lockdep. Applies on top of the parallel faults series picked up last
week.

v3: https://lore.kernel.org/kvmarm/20221116165655.2649475-1-oliver.upton@linux.dev/

v3 -> v4:
 - Return an error instead of WARN() in hyp for shared walks (Will)

Oliver Upton (3):
  KVM: arm64: Take a pointer to walker data in kvm_dereference_pteref()
  KVM: arm64: Don't acquire RCU read lock for exclusive table walks
  KVM: arm64: Reject shared table walks in the hyp code

 arch/arm64/include/asm/kvm_pgtable.h | 159 +++++++++++++++------------
 arch/arm64/kvm/hyp/pgtable.c         |  13 ++-
 2 files changed, 96 insertions(+), 76 deletions(-)

-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
