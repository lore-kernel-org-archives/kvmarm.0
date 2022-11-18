Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4717CC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 21:15:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA1614B91C;
	Fri, 18 Nov 2022 16:15:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4p1+7kq4H4Lb; Fri, 18 Nov 2022 16:15:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F5A4B9F3;
	Fri, 18 Nov 2022 16:15:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08E674B9A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 16:15:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1W0mJPKOkwrp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 16:15:21 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0F4D4B91C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 16:15:21 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668806120;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=IBgRCeErwQCUyfW70Ze08m0oR+9ioab9xsEyeSrJGBc=;
 b=CJghzJslYjDa3bJIZ+4nUqnhQoU1COpSvTrvrZ9QPdkAQXdgD6FGprBEqLng210wqHRQrU
 pHEelwRlJn5H8tm2S+pEYnwbonN0rzdRa3lGPTKZXVwE5HiK9U7rEh7zw3HOrm6sxG5LAY
 Wl0+VVZPUmT/5IgoYWiJHxSEF4XC5DQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 0/2] KVM: selftests: Enable access_tracking_perf_test for
 arm64
Date: Fri, 18 Nov 2022 21:15:01 +0000
Message-Id: <20221118211503.4049023-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

Small series to add support for arm64 to access_tracking_perf_test and
correct a couple bugs along the way.

Tested on Ampere Altra w/ all supported guest modes.

v1 -> v2:
 - Have perf_test_util indicate when to stop vCPU threads (Sean)
 - Collect Gavin's R-b on the second patch. I left off Gavin's R-b on
   the first patch as it was retooled.

v1: https://lore.kernel.org/kvmarm/20221111231946.944807-1-oliver.upton@linux.dev/

Oliver Upton (2):
  KVM: selftests: Have perf_test_util signal when to stop vCPUs
  KVM: selftests: Build access_tracking_perf_test for arm64

 tools/testing/selftests/kvm/Makefile                      | 1 +
 tools/testing/selftests/kvm/access_tracking_perf_test.c   | 8 +-------
 tools/testing/selftests/kvm/include/perf_test_util.h      | 3 +++
 tools/testing/selftests/kvm/lib/perf_test_util.c          | 3 +++
 .../selftests/kvm/memslot_modification_stress_test.c      | 6 +-----
 5 files changed, 9 insertions(+), 12 deletions(-)


base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
