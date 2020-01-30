Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C9DC33C9E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 11:25:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF064206D3
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 11:25:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TW7uZIfh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF064206D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 555A34A830;
	Thu, 30 Jan 2020 06:25:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xVYWpH5lAFKq; Thu, 30 Jan 2020 06:25:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 441D34A8E8;
	Thu, 30 Jan 2020 06:25:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 272D04A598
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 06:25:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WOLRWwdo3Ap5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 06:25:28 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E7BC4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 06:25:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580383527;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=RD3+Ld7Dxp10D8lHwl6kiXjd9vd6HKHz9XGO3ilgvRk=;
 b=TW7uZIfh8x7YozKJ/q2QERwpQ0NiE+LIF72kO8rJI8JasWJ+OtCt2hnjIv5N3EuCGvCQG5
 5s0ACZamqFe9S/Hhm3AfsoU4gFJJHLKhX3o9sr9SePHrrmbVfsCHFUHTl3munfHwnx1da7
 xD21hF/ucjVVrqEsMzdX3Q4o7RiW+8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-Z7hfLdmJPPalT3OyO1uCZg-1; Thu, 30 Jan 2020 06:25:23 -0500
X-MC-Unique: Z7hfLdmJPPalT3OyO1uCZg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB762100551B;
 Thu, 30 Jan 2020 11:25:21 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 02B211001B05;
 Thu, 30 Jan 2020 11:25:13 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v2 0/9] KVM: arm64: PMUv3 Event Counter Tests
Date: Thu, 30 Jan 2020 12:25:01 +0100
Message-Id: <20200130112510.15154-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
of odd and event counters (See [1]).

Overflow interrupt testing relies of one patch from Andre
("arm: gic: Provide per-IRQ helper functions") to enable the
PPI 23, coming from "arm: gic: Test SPIs and interrupt groups"
(https://patchwork.kernel.org/cover/11234975/). Drew kindly
provided "arm64: Provide read/write_sysreg_s".

All PMU tests can be launched with:
./run_tests.sh -g pmu
Tests also can be launched individually. For example:
./arm-run arm/pmu.flat -append 'chained-sw-incr'

With KVM:
- chain-promotion and chained-sw-incr are known to be failing.
  [1] proposed a fix.
- On TX2, I have some random failures due to MEM_ACCESS event
  measured with a great disparity. This is not observed on
  other machines I have access to.
With TCG:
- all new tests are skipped

The series can be found at:
https://github.com/eauger/kut/tree/pmu_event_counters_v2

References:
[1] [PATCH 0/4] KVM/ARM: Misc PMU fixes
(https://www.spinics.net/lists/kvm-arm/msg38886.html)

History:
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

Andre Przywara (1):
  arm: gic: Provide per-IRQ helper functions

Andrew Jones (1):
  arm64: Provide read/write_sysreg_s

Eric Auger (7):
  arm: pmu: Let pmu tests take a sub-test parameter
  arm: pmu: Add a pmu struct
  arm: pmu: Check Required Event Support
  arm: pmu: Basic event counter Tests
  arm: pmu: Test chained counter
  arm: pmu: test 32-bit <-> 64-bit transitions
  arm: pmu: Test overflow interrupts

 arm/pmu.c              | 786 ++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg      |  55 ++-
 lib/arm/asm/gic-v3.h   |   2 +
 lib/arm/asm/gic.h      |   9 +
 lib/arm/gic.c          |  90 +++++
 lib/arm64/asm/sysreg.h |  11 +
 6 files changed, 936 insertions(+), 17 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
