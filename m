Return-Path: <SRS0=WMPN=HA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96DEC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 29 Jan 2021 16:37:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 819F364DFF
	for <kvmarm@archiver.kernel.org>; Fri, 29 Jan 2021 16:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 819F364DFF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27D424B0E2;
	Fri, 29 Jan 2021 11:37:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xtd594XoXAkD; Fri, 29 Jan 2021 11:37:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DEF94B0D5;
	Fri, 29 Jan 2021 11:37:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C716F4B33E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2021 11:37:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7pD3LYbBf6LG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Jan 2021 11:37:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75AF14B343
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2021 11:37:17 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 244AE1596;
 Fri, 29 Jan 2021 08:37:17 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 485443F71B;
 Fri, 29 Jan 2021 08:37:16 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v3 07/11] arm/arm64: gic: Wait for writes to
 acked or spurious to complete
Date: Fri, 29 Jan 2021 16:36:43 +0000
Message-Id: <20210129163647.91564-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129163647.91564-1-alexandru.elisei@arm.com>
References: <20210129163647.91564-1-alexandru.elisei@arm.com>
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

The IPI test has two parts: in the first part, it tests that the sender CPU
can send an IPI to itself (ipi_test_self()), and in the second part it
sends interrupts to even-numbered CPUs (ipi_test_smp()). When acknowledging
an interrupt, if we read back a spurious interrupt ID (1023), the handler
increments the index in the static array spurious corresponding to the CPU
ID that the handler is running on; if we get the expected interrupt ID, we
increment the same index in the acked array.

Reads of the spurious and acked arrays are synchronized with writes
performed before sending the IPI. The synchronization is done either in the
IPI sender function (GICv3), either by creating a data dependency (GICv2).

At the end of the test, the sender CPU reads from the acked and spurious
arrays to check against the expected behaviour. We need to make sure the
that writes in ipi_handler() are observable by the sender CPU. Use a DSB
ISHST to make sure that the writes have completed.

One might rightfully argue that there are no guarantees regarding when the
DSB instruction completes, just like there are no guarantees regarding when
the value is observed by the other CPUs. However, let's do our best and
instruct the CPU to complete the memory access when we know that it will be
needed.

We still need to follow the message passing pattern for the acked,
respectively bad_irq and bad_sender, because DSB guarantees that all memory
accesses that come before the barrier have completed, not that they have
completed in program order.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 982c96681cf9..af4d4645c0ae 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -117,7 +117,6 @@ static void check_spurious(void)
 {
 	int cpu;
 
-	smp_rmb();
 	for_each_present_cpu(cpu) {
 		if (spurious[cpu])
 			report_info("WARN: cpu%d got %d spurious interrupts",
@@ -154,8 +153,10 @@ static void ipi_handler(struct pt_regs *regs __unused)
 		++acked[smp_processor_id()];
 	} else {
 		++spurious[smp_processor_id()];
-		smp_wmb();
 	}
+
+	/* Wait for writes to acked/spurious to complete */
+	dsb(ishst);
 }
 
 static void setup_irq(irq_handler_fn handler)
-- 
2.30.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
