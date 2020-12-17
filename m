Return-Path: <SRS0=/4+A=FV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23961C2BB9A
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 14:14:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F7852360D
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 14:14:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F7852360D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 425194B20F;
	Thu, 17 Dec 2020 09:14:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qThm-3qKrXEf; Thu, 17 Dec 2020 09:14:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D35F74B225;
	Thu, 17 Dec 2020 09:14:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A8CE4B211
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 09:14:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ozayp1idk+Z for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Dec 2020 09:14:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1493A4B20B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 09:14:22 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA4211435;
 Thu, 17 Dec 2020 06:14:21 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC9083F66B;
 Thu, 17 Dec 2020 06:14:20 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 11/12] lib: arm64: gic-v3-its: Add wmb()
 barrier before INT command
Date: Thu, 17 Dec 2020 14:13:59 +0000
Message-Id: <20201217141400.106137-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217141400.106137-1-alexandru.elisei@arm.com>
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
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

The ITS tests use the INT command like an SGI. The its_send_int() function
kicks a CPU and then the test checks that the interrupt was observed as
expected in check_lpi_stats(). This is done by using lpi_stats.observed and
lpi_stats.expected, where the target CPU only writes to lpi_stats.observed,
and the source CPU reads it and compares the values with
lpi_stats.expected.

The fact that the target CPU doesn't read data written by the source CPU
means that we don't need to do inter-processor memory synchronization
for that between the two at the moment.

The acked array is used by its-pending-migration test, but the reset value
for acked (zero) is the same as the initialization value for static
variables, so memory synchronization is again not needed.

However, that is all about to change when we modify all ITS tests to use
the same functions as the IPI tests. Add a write memory barrier to
its_send_int(), similar to the gicv3_ipi_send_mask(), which has similar
semantics.

Suggested-by: Auger Eric <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/gic-v3-its-cmd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/arm64/gic-v3-its-cmd.c b/lib/arm64/gic-v3-its-cmd.c
index 34574f71d171..32703147ee85 100644
--- a/lib/arm64/gic-v3-its-cmd.c
+++ b/lib/arm64/gic-v3-its-cmd.c
@@ -385,6 +385,12 @@ void __its_send_int(struct its_device *dev, u32 event_id, bool verbose)
 {
 	struct its_cmd_desc desc;
 
+	/*
+	 * The INT command is used by tests as an IPI. Ensure stores to Normal
+	 * memory are visible to other CPUs before sending the LPI.
+	 */
+	wmb();
+
 	desc.its_int_cmd.dev = dev;
 	desc.its_int_cmd.event_id = event_id;
 	desc.verbose = verbose;
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
