Return-Path: <SRS0=Zhuu=CJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EADCC433E2
	for <kvmarm@archiver.kernel.org>; Mon, 31 Aug 2020 19:34:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADDD120EDD
	for <kvmarm@archiver.kernel.org>; Mon, 31 Aug 2020 19:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9aOyu3f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADDD120EDD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC0A94B318;
	Mon, 31 Aug 2020 15:34:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ul-n9IgmvzpE; Mon, 31 Aug 2020 15:34:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A0D4B253;
	Mon, 31 Aug 2020 15:34:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92E3F4B261
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Aug 2020 15:34:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IQlNPun117h7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Aug 2020 15:34:27 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE2474B24B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Aug 2020 15:34:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1598902467;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=YQWthbnL/F8A9JG87S9VWHvNqxsIM98exPrIcod4sws=;
 b=T9aOyu3fQqH4pxh02B3U6HPr7uEhqdaIEsPnWyY0FZG347GH/d1IV9GqcV0LnH4GPFom6z
 dL1U8Fsm5zsgLtgayVQJDrBUOVENJQOL5n3FxN1fMAza0aWIa9464L513xqvjuRzaU6ouX
 eRnfaMWUbHOGQi3yOLZ3uEVbqm+Dklw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-ei-P5MgSPnS9WN3J5PB5aA-1; Mon, 31 Aug 2020 15:34:25 -0400
X-MC-Unique: ei-P5MgSPnS9WN3J5PB5aA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84DCE18A2243;
 Mon, 31 Aug 2020 19:34:22 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-112.ams2.redhat.com [10.36.112.112])
 by smtp.corp.redhat.com (Postfix) with ESMTP id DE3F37EB7B;
 Mon, 31 Aug 2020 19:34:16 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, drjones@redhat.com,
 andrew.murray@arm.com, sudeep.holla@arm.com, maz@kernel.org,
 will@kernel.org, haibo.xu@linaro.org
Subject: [kvm-unit-tests RFC 0/4] KVM: arm64: Statistical Profiling Extension
 Tests
Date: Mon, 31 Aug 2020 21:34:10 +0200
Message-Id: <20200831193414.6951-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

This series implements tests exercising the Statistical Profiling
Extensions.

This was tested with associated unmerged kernel [1] and QEMU [2]
series.

Depending on the comments, I can easily add other tests checking
more configs, additional events and testing migration too. I hope
this can be useful when respinning both series.

All SPE tests can be launched with:
./run_tests.sh -g spe
Tests also can be launched individually. For example:
./arm-run arm/spe.flat -append 'spe-buffer'

The series can be found at:
https://github.com/eauger/kut/tree/spe_rfc

References:
[1] [PATCH v2 00/18] arm64: KVM: add SPE profiling support
[2] [PATCH 0/7] target/arm: Add vSPE support to KVM guest

Eric Auger (4):
  arm64: Move get_id_aa64dfr0() in processor.h
  spe: Probing and Introspection Test
  spe: Add profiling buffer test
  spe: Test Profiling Buffer Events

 arm/Makefile.common       |   1 +
 arm/pmu.c                 |   1 -
 arm/spe.c                 | 463 ++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg         |  24 ++
 lib/arm64/asm/barrier.h   |   1 +
 lib/arm64/asm/processor.h |   5 +
 6 files changed, 494 insertions(+), 1 deletion(-)
 create mode 100644 arm/spe.c

-- 
2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
