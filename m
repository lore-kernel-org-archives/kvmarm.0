Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C172C1975A
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 15:43:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C848F20724
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 15:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HAfy9Mzx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C848F20724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22D254A4BE;
	Thu, 12 Mar 2020 11:43:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1KVE5V5E2uyA; Thu, 12 Mar 2020 11:43:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A89D4A4C0;
	Thu, 12 Mar 2020 11:43:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13C554A4A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 11:43:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lRWUB9MFJgcm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 11:43:16 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11F5C4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 11:43:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584027795;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=k8jp38U+HDvwVpi2WnHkpfG6zGk4onx+M144s/vtKiI=;
 b=HAfy9MzxKauY4RuHEKot7hKbLsRUNjljvI3l8Gj53+elXx2NnFtDaRN4losK1pxJ8RRnoW
 5VylXORJ6SqnZ7q2CDm2sWG/y7Qz9tqWsfVt33r89uqCjjg6GKQ8sJCIrBAepJ3pC9WWh8
 Uz/4ADPsr6byFcJP3zuXorz3gos8VRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-AgtgHoGHMx-x1j5WkGYSMg-1; Thu, 12 Mar 2020 11:43:13 -0400
X-MC-Unique: AgtgHoGHMx-x1j5WkGYSMg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F68A1005509;
 Thu, 12 Mar 2020 15:43:12 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 264325C1B5;
 Thu, 12 Mar 2020 15:43:03 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v3 00/12] KVM: arm64: PMUv3 Event Counter Tests
Date: Thu, 12 Mar 2020 16:42:49 +0100
Message-Id: <20200312154301.9130-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: andrew.murray@arm.com, andre.przywara@arm.com
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

This series implements tests exercising the PMUv3 event counters.
It tests both the 32-bit and 64-bit versions. Overflow interrupts
also are checked. Those tests only are written for arm64.

It allowed to reveal some issues related to SW_INCR implementation
(esp. related to 64-bit implementation), some problems related to
32-bit <-> 64-bit transitions and consistency of enabled states
of odd and event counters. Fixes now are upstream.

Drew kindly provided "arm64: Provide read/write_sysreg_s".

All PMU tests can be launched with:
./run_tests.sh -g pmu
Tests also can be launched individually. For example:
./arm-run arm/pmu.flat -append 'pmu-chained-sw-incr'

With KVM:
- On TX2, I have some random failures due to MEM_ACCESS event
  measured with a great disparity. This is not observed on
  other machines I have access to.

The series can be found at:
https://github.com/eauger/kut/tree/pmu_event_counters_v3

History:

v2 -> v3:
- Took into account numerous comments from Drew
- Applied Andre's R-b when code has not changed too much
- Don't check PMCR.IMP anymore
- better handling of version
- put simple SW_INCR tests for easier TCG testing

v1 -> v2:
- Took into account Andre's comments except I did not
  use cnbz in the mem_access_loop() and I did not use
  @loop directly. Those changes had side effects I
  cannot explain on the tests. Anyway I think this can
  be improved later on.
- removed [kvm-unit-tests PATCH 09/10] arm/arm64: gic:
  Introduce setup_irq() helper

RFC -> v1:
- Use new report() proto
- Style cleanup
- do not warn about ARM spec recommendations
- add a comment about PMCEID0/1 splits

Andrew Jones (1):
  arm64: Provide read/write_sysreg_s

Eric Auger (11):
  arm: pmu: Let pmu tests take a sub-test parameter
  arm: pmu: Don't check PMCR.IMP anymore
  arm: pmu: Add a pmu struct
  arm: pmu: Introduce defines for PMU versions
  arm: pmu: Check Required Event Support
  arm: pmu: Basic event counter Tests
  arm: pmu: Test SW_INCR event count
  arm: pmu: Test chained counters
  arm: pmu: test 32-bit <-> 64-bit transitions
  arm: gic: Introduce gic_irq_set_clr_enable() helper
  arm: pmu: Test overflow interrupts

 arm/pmu.c              | 839 +++++++++++++++++++++++++++++++++++++++--
 arm/unittests.cfg      |  61 ++-
 lib/arm/asm/gic.h      |   4 +
 lib/arm/gic.c          |  31 ++
 lib/arm64/asm/sysreg.h |  17 +
 lib/bitops.h           |   3 +
 6 files changed, 918 insertions(+), 37 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
