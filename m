From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH 2/2] arm64: timer: Add TVAL timeout IRQ trigger
 test
Date: Mon, 16 Jul 2018 16:14:38 +0100
Message-ID: <20180716151438.9877-3-andre.przywara@arm.com>
References: <20180716151438.9877-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE5D94A149
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 11:01:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jhMedmhM3bnM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 11:01:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC8184A168
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 11:01:45 -0400 (EDT)
In-Reply-To: <20180716151438.9877-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

So far we were only testing the CVAL register. Add a test which programs
a (relative) TVAL value to check this functionality as well.
Also we go into WFI and wait for the interrupt to release us from it.
The timer tests are run with a 2 second timeout on the host side, so
that any failure in coming back would be covered.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/timer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index 1c9ef44..275d049 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -211,6 +211,7 @@ static void test_timer(struct timer_info *info)
 	u64 now = info->read_counter();
 	u64 time_10s = read_sysreg(cntfrq_el0) * 10;
 	u64 later = now + time_10s;
+	s32 left;
 
 	/* We don't want the irq handler to fire because that will change the
 	 * timer state and we want to test the timer output signal.  We can
@@ -236,6 +237,15 @@ static void test_timer(struct timer_info *info)
 
 	/* Disable the timer again */
 	info->write_ctl(0);
+
+	/* Test TVAL and IRQ trigger */
+	info->irq_received = false;
+	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
+	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
+	wfi();
+	left = info->read_tval();
+	report("interrupt received after TVAL/WFI", info->irq_received);
+	report("timer has expired (%d)", left < 0, left);
 }
 
 static void test_vtimer(void)
-- 
2.14.4
