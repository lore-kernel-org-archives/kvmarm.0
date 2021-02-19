Return-Path: <SRS0=3b8a=HV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751A6C433E6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:13:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 135D464EC0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:13:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 135D464EC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A527D4B324;
	Fri, 19 Feb 2021 07:13:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TUsAgOdGMwCW; Fri, 19 Feb 2021 07:13:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AB154B353;
	Fri, 19 Feb 2021 07:13:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B5E14B1E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:13:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VDViXvFiaMK6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2021 07:13:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9A4E4B30C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:13:44 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B72A1474;
 Fri, 19 Feb 2021 04:13:44 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90F0C3F73B;
 Fri, 19 Feb 2021 04:13:43 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v4 10/11] arm64: gic: its-trigger: Don't
 trigger the LPI while it is pending
Date: Fri, 19 Feb 2021 12:13:36 +0000
Message-Id: <20210219121337.76533-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210219121337.76533-1-alexandru.elisei@arm.com>
References: <20210219121337.76533-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: andre.przywara@arm.com
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

The its-trigger test checks that LPI 8195 is not delivered to the CPU while
it is disabled at the ITS level. After that it is re-enabled and the test
checks that the interrupt is properly asserted. After it's re-enabled and
before the stats are examined, the test triggers the interrupt again, which
can lead to the same interrupt being delivered twice: once after the
configuration invalidation and before the INT command, and once after the
INT command.

Add an explicit check that the interrupt has fired after the invalidation.
Leave the check after the INT command to make sure the INT command still
works for the now re-enabled LPI.

CC: Auger Eric <eric.auger@redhat.com>
Suggested-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index af2c112336e7..8bc2a35908f2 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -802,6 +802,9 @@ static void test_its_trigger(void)
 
 	/* Now call the invall and check the LPI hits */
 	its_send_invall(col3);
+	lpi_stats_expect(3, 8195);
+	check_lpi_stats("dev2/eventid=20 pending LPI is received");
+
 	lpi_stats_expect(3, 8195);
 	its_send_int(dev2, 20);
 	check_lpi_stats("dev2/eventid=20 now triggers an LPI");
-- 
2.30.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
