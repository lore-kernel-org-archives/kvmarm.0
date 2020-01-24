Return-Path: <SRS0=41R7=3N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865F5C32771
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jan 2020 14:25:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F3072075D
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jan 2020 14:25:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h2h5H9De"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F3072075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA5444AF2A;
	Fri, 24 Jan 2020 09:25:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M3R2wIW-jWAa; Fri, 24 Jan 2020 09:25:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0CEF4AF2C;
	Fri, 24 Jan 2020 09:25:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02EAD4AF08
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 09:25:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7CMNmtof6Qy7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jan 2020 09:25:52 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5D664AEED
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jan 2020 09:25:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579875952;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=gFUS+IYpTMcPpriTfqC+Rs1/QtFWk7pC2ooCgkxv0Po=;
 b=h2h5H9DeIDzjINWT/e0JWXgWUy2ktkehWp203Xf/NG7kwdZ5Z33MeBzxzP4Gc8p8BauYSR
 8YGHKDJ1Y+faQy/O76kN+rx7Ml9e0kJeYKdXyCz5KHtcsxVY9gLAJ0DJ/o3Hzr8y0O2bEj
 DWbG8h5SyrOsvLkcWDIkb/2NzNRGpA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-8HkIZKcTMhqYNkxhYA9nDw-1; Fri, 24 Jan 2020 09:25:45 -0500
X-MC-Unique: 8HkIZKcTMhqYNkxhYA9nDw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E23DB190D345;
 Fri, 24 Jan 2020 14:25:43 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTP id BFFEC3B0;
 Fri, 24 Jan 2020 14:25:38 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/4] KVM/ARM: Misc PMU fixes
Date: Fri, 24 Jan 2020 15:25:31 +0100
Message-Id: <20200124142535.29386-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: andrew.murray@arm.com
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

While writing new PMUv3 event counter kvm-unit-tests I found
some bugs related to the chained counter implementation:

- the enable state of the high counter is not taken into account,
- chain counters are not implemented along with SW_INCR type,
- SW_INCR does not take into account the global enable state

The last patch rather is an optimization that avoids manipulating
non supported counters.

Best Regards

Eric

This series can be found at:
https://github.com/eauger/linux/tree/v5.5-rc7-pmu-fixes-v1

Test:
Tested with kvm-unit-tests [1]: all tests now pass,
at the exception of one sub-test in pmu-chain-promotion
but this is a bug in test.

Other testing at higher level (perf) appreciated.

references:
[1] KVM: arm64: PMUv3 Event Counter Tests
(https://lore.kernel.org/kvmarm/c1831b6c-dc75-1bd3-6657-0375682c30af@redhat.com/T/)

History:

RFC -> v1:
- remove  [RFC 3/3] KVM: arm64: pmu: Enforce PMEVTYPER evtCount size
- add KVM: arm64: pmu: Only handle supported event counters
- Take into account the enable state of the CHAIN high counter
- revisit kvm_pmu_software_increment() implementation as suggested
  by Marc


Eric Auger (4):
  KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset
  KVM: arm64: pmu: Don't mark a counter as chained if the odd one is
    disabled
  KVM: arm64: pmu: Fix chained SW_INCR counters
  KVM: arm64: pmu: Only handle supported event counters

 virt/kvm/arm/pmu.c | 114 +++++++++++++++++++++++++++------------------
 1 file changed, 69 insertions(+), 45 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
