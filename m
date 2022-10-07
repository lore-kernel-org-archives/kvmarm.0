Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D4CC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  7 Oct 2022 23:42:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03B9040178;
	Fri,  7 Oct 2022 19:42:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0AZfSkNuRnbi; Fri,  7 Oct 2022 19:42:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1E64410AD;
	Fri,  7 Oct 2022 19:42:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ED9C40BDC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 19:42:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2I7MWW8+yqMl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Oct 2022 19:42:04 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 527DE40178
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 19:42:04 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1665186123;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=8gk76JRqjPqMzkfoKmXkwFy1NQbQ1ICsFcGyhsYU5J0=;
 b=v/KiVBTDrWvVn+101zSX+yMTklfcDfKoScD2vAnF13qg7YbpUTAe7yBbTpCiXRoBauVVq6
 u4QQyKsJyiZHkTVlzpoDMQoMyEwou6RWbcC1OnniQKHbu1HXKUNwF+xXqNFfUlc4wCga/N
 PJeClBh18muHjmvswN/3a9VXwgI940o=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 0/2] KVM: arm64: Limit stage2_apply_range() batch size to
 largest block
Date: Fri,  7 Oct 2022 23:41:49 +0000
Message-Id: <20221007234151.461779-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
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

Continuing with MMU patches to post, a small series fixing some soft
lockups caused by stage2_apply_range(). Depending on the paging setup,
we could walk a very large amount of memory before dropping the lock and
rescheduling.

Applies to kvmarm-6.1. Tested with KVM selftests and kvm-unit-tests with
all supported page sizes (4K, 16K, 64K). Additionally, I no longer saw
soft lockups with the following:

  ./dirty_log_perf_test -m -2 -s anonymous_thp -b 4G -v 48

v2: https://lore.kernel.org/kvmarm/20220926222146.661633-1-oliver.upton@linux.dev/

v2 -> v3:
 - Just use the largest block size as the batch size (Marc)

Oliver Upton (2):
  KVM: arm64: Work out supported block level at compile time
  KVM: arm64: Limit stage2_apply_range() batch size to largest block

 arch/arm64/include/asm/kvm_pgtable.h    | 18 +++++++++++++-----
 arch/arm64/include/asm/stage2_pgtable.h | 20 --------------------
 arch/arm64/kvm/mmu.c                    |  9 ++++++++-
 3 files changed, 21 insertions(+), 26 deletions(-)


base-commit: b302ca52ba8235ff0e18c0fa1fa92b51784aef6a
-- 
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
