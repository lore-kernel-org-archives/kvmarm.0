Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F28C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Dec 2021 15:47:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F2A44B120;
	Tue,  7 Dec 2021 10:47:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uFv-SPSdaxCX; Tue,  7 Dec 2021 10:47:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4285A4B159;
	Tue,  7 Dec 2021 10:47:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2C9D4B0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 10:47:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7FIgZPLOIGm4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Dec 2021 10:46:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEC074B106
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Dec 2021 10:46:58 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 999A911D4;
 Tue,  7 Dec 2021 07:46:58 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D99AB3F5A1;
 Tue,  7 Dec 2021 07:46:57 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 4/4] arm: timer: Take into account other
 wake-up events for the TVAL test
Date: Tue,  7 Dec 2021 15:46:41 +0000
Message-Id: <20211207154641.87740-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211207154641.87740-1-alexandru.elisei@arm.com>
References: <20211207154641.87740-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

The TVAL test programs the timer to fire into the future, waits for an
interrupt using the WFI instruction, and when the instruction completes it
checks that the timer interrupt has fired. According to ARM DDI 0487G.a
there are other wake-up events that can cause the WFI to complete (listed
on page D1-2520), among them interrupts routed to a higher exception level,
where the hypervisor is running (if running under virtualization) or
firmware (if running on baremetal).

In practice, this is unlikely to have caused a false test failure, because
for a GICv3 (which the author assumes is a lot more common than a GICv4+)
the WFI is trapped by KVM and the VCPU thread is resumed only after the
timer asserts the interrupt, as the test expects.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 7b2d82896c74..8a668e8adac8 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -278,17 +278,44 @@ static void test_timer_cval(struct timer_info *info)
 	disable_timer(info);
 }
 
-static void test_timer_tval(struct timer_info *info)
+static void timer_do_wfi(struct timer_info *info)
 {
-	s32 left;
-
-	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
 	local_irq_disable();
-	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
+	if (info->irq_received)
+		goto out;
 	report_info("waiting for interrupt...");
 	wfi();
+out:
 	local_irq_enable();
-	left = info->read_tval();
+}
+
+static void test_timer_tval(struct timer_info *info)
+{
+	u64 time_10ms = read_sysreg(cntfrq_el0) / 100;
+	s32 left;
+	int i;
+
+	info->write_tval(time_10ms);
+	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
+
+	for (;;) {
+		timer_do_wfi(info);
+		left = info->read_tval();
+		if (info->irq_received || left <= 0)
+			break;
+	}
+
+	/* Wait one second for the GIC to update the interrupt state. */
+	if (left <= 0 && !info->irq_received) {
+		for (i = 0; i < 10; i++) {
+			timer_do_wfi(info);
+			if (info->irq_received)
+				break;
+			mdelay(100);
+		}
+		left = info->read_tval();
+	}
+
 	report(info->irq_received, "interrupt received after TVAL/WFI");
 	report(left <= 0, "timer has expired");
 	report_info("TVAL is %d ticks", left);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
