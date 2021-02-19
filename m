Return-Path: <SRS0=3b8a=HV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A0AC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:13:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7790B64EC7
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 12:13:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7790B64EC7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 184DE4B2CD;
	Fri, 19 Feb 2021 07:13:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 11+k4ptBpBYy; Fri, 19 Feb 2021 07:13:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1B454B2CA;
	Fri, 19 Feb 2021 07:13:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A129C4B2D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:13:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lftq43KxFi-c for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2021 07:13:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47BF44B2E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 07:13:39 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0979B142F;
 Fri, 19 Feb 2021 04:13:39 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C3FB3F73B;
 Fri, 19 Feb 2021 04:13:38 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v4 05/11] arm/arm64: gic: Use correct memory
 ordering for the IPI test
Date: Fri, 19 Feb 2021 12:13:31 +0000
Message-Id: <20210219121337.76533-6-alexandru.elisei@arm.com>
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

The IPI test works by sending IPIs to even numbered CPUs from the
IPI_SENDER CPU (CPU1), and then checking that the other CPUs received the
interrupts as expected. The check is done in check_acked() by the
IPI_SENDER CPU with the help of three arrays:

- acked, where acked[i] == 1 means that CPU i received the interrupt.
- bad_irq, where bad_irq[i] == -1 means that the interrupt received by CPU
  i had the expected interrupt number (IPI_IRQ).
- bad_sender, where bad_sender[i] == -1 means that the interrupt received
  by CPU i was from the expected sender (IPI_SENDER, GICv2 only).

The assumption made by check_acked() is that if a CPU acked an interrupt,
then bad_sender and bad_irq have also been updated. This is a common
inter-thread communication pattern called message passing.  For message
passing to work correctly on weakly consistent memory model architectures,
like arm and arm64, barriers or address dependencies are required. This is
described in ARM DDI 0487F.b, in "Armv7 compatible approaches for ordering,
using DMB and DSB barriers" (page K11-7993), in the section with a single
observer, which is in our case the IPI_SENDER CPU.

The IPI test attempts to enforce the correct ordering using memory
barriers, but it's not enough. For example, the program execution below is
valid from an architectural point of view:

3 online CPUs, initial state (from stats_reset()):

acked[2] = 0;
bad_sender[2] = -1;
bad_irq[2] = -1;

CPU1 (in check_acked())		| CPU2 (in ipi_handler())
				|
smp_rmb() // DMB ISHLD		| acked[2]++;
read 1 from acked[2]		|
nr_pass++ // nr_pass = 3	|
read -1 from bad_sender[2]	|
read -1 from bad_irq[2]		|
				| // in check_ipi_sender()
				| bad_sender[2] = <bad ipi sender>
				| // in check_irqnr()
				| bad_irq[2] = <bad irq number>
				| smp_wmb() // DMB ISHST
nr_pass == nr_cpus, return	|

In this scenario, CPU1 will read the updated acked value, but it will read
the initial bad_sender and bad_irq values. This is permitted because the
memory barriers do not create a data dependency between the value read from
acked and the values read from bad_rq and bad_sender on CPU1, respectively
between the values written to acked, bad_sender and bad_irq on CPU2.

To avoid this situation, let's reorder the barriers and accesses to the
arrays to create the needed dependencies that ensure that message passing
behaves as expected.

In the interrupt handler, the writes to bad_sender and bad_irq are
reordered before the write to acked and a smp_wmb() barrier is added. This
ensures that if other PEs observe the write to acked, then they will also
observe the writes to the other two arrays.

In check_acked(), put the smp_rmb() barrier after the read from acked to
ensure that the subsequent reads from bad_sender, respectively bad_irq,
aren't reordered locally by the PE.

With these changes, the expected ordering of accesses is respected and we
end up with the pattern described in the Arm ARM and also in the Linux
litmus test MP+fencewmbonceonce+fencermbonceonce.litmus from
tools/memory-model/litmus-tests. More examples and explanations can be
found in the Linux source tree, in Documentation/memory-barriers.txt, in
the sections "SMP BARRIER PAIRING" and "READ MEMORY BARRIERS VS LOAD
SPECULATION".

For consistency with ipi_handler(), the array accesses in
ipi_clear_active_handler() have also been reordered. This shouldn't affect
the functionality of that test.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index db1417ae1ca1..c1b6c94a5f5e 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -72,9 +72,9 @@ static void check_acked(const char *testname, cpumask_t *mask)
 		mdelay(100);
 		nr_pass = 0;
 		for_each_present_cpu(cpu) {
-			smp_rmb();
 			nr_pass += cpumask_test_cpu(cpu, mask) ?
 				acked[cpu] == 1 : acked[cpu] == 0;
+			smp_rmb(); /* pairs with smp_wmb in ipi_handler */
 
 			if (bad_sender[cpu] != -1) {
 				printf("cpu%d received IPI from wrong sender %d\n",
@@ -148,10 +148,10 @@ static void ipi_handler(struct pt_regs *regs __unused)
 
 	if (irqnr != GICC_INT_SPURIOUS) {
 		gic_write_eoir(irqstat);
-		++acked[smp_processor_id()];
 		check_ipi_sender(irqstat);
 		check_irqnr(irqnr);
-		smp_wmb(); /* pairs with rmb in check_acked */
+		smp_wmb(); /* pairs with smp_rmb in check_acked */
+		++acked[smp_processor_id()];
 	} else {
 		++spurious[smp_processor_id()];
 		smp_wmb();
@@ -382,8 +382,8 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 
 		writel(val, base + GICD_ICACTIVER);
 
-		++acked[smp_processor_id()];
 		check_irqnr(irqnr);
+		++acked[smp_processor_id()];
 	} else {
 		++spurious[smp_processor_id()];
 	}
-- 
2.30.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
