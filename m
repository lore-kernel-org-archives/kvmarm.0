Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3847CC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 16:57:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C414B8D1;
	Wed, 16 Nov 2022 11:57:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w6SF5mmMoKMR; Wed, 16 Nov 2022 11:57:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 895A34B8A4;
	Wed, 16 Nov 2022 11:57:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C0C4B890
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 11:57:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Q8FukjwlI2X for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 11:57:10 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5633D4B87E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 11:57:10 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668617829;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=TdFPell1GyLBX2SIEk5RntQAA4Vog6nIAXIY95c98cY=;
 b=SOKzPo9L8c2aAODZKx24AXi3Um/xxFEqfqF+qClyOQk8l/W5JKOLZSoadwrDaURh9kKj7g
 R1EvOLI2gkz/G1vwxqkqABx1MOHaD9pxY1A3tpAVN93p2TWFicEUs7mPkhMdgKji4JOrCH
 of38SMfEsMvBHuPjfeI5HhspUIrtvwE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 0/2] KVM: arm64: Fixes for parallel faults series
Date: Wed, 16 Nov 2022 16:56:53 +0000
Message-Id: <20221116165655.2649475-1-oliver.upton@linux.dev>
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

Tested on an Ampere Altra system with kvm-arm.mode={nvhe,protected}.
Applies to the parallel faults series picked up last week.

v2: https://lore.kernel.org/kvmarm/20221115225502.2240227-1-oliver.upton@linux.dev/

v2 -> v3:
 - Pass a pointer to the walker instead of a bool (Marc)
 - Apply the aforementioned change to kvm_dereference_pteref()

Oliver Upton (2):
  KVM: arm64: Take a pointer to walker data in kvm_dereference_pteref()
  KVM: arm64: Don't acquire RCU read lock for exclusive table walks

 arch/arm64/include/asm/kvm_pgtable.h | 154 +++++++++++++++------------
 arch/arm64/kvm/hyp/pgtable.c         |  10 +-
 2 files changed, 88 insertions(+), 76 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
