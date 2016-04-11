From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v6 01/10] clocksource: arm_arch_timer: Gather KVM specific
 information in a structure
Date: Mon, 11 Apr 2016 16:32:51 +0100
Message-ID: <1460388780-914-2-git-send-email-julien.grall@arm.com>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D703540BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:31:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SIf7-Z5DB69e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 11:31:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E56640B40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:31:35 -0400 (EDT)
In-Reply-To: <1460388780-914-1-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, marc.zyngier@arm.com, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Introduce a structure which are filled up by the arch timer driver and
used by the virtual timer in KVM.

The first member of this structure will be the timecounter. More members
will be added later.

A stub for the new helper isn't introduced because KVM requires the arch
timer for both ARM64 and ARM32.

The function arch_timer_get_timecounter is kept for the time being and
will be dropped in a subsequent patch.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

---
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>

    Changes in v6:
        - Add Christoffer's acked-by

    Changes in v3:
        - Rename the patch
        - Move the KVM changes and removal of arch_timer_get_timecounter
        in separate patches.
---
 drivers/clocksource/arm_arch_timer.c | 12 +++++++++---
 include/clocksource/arm_arch_timer.h |  5 +++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5152b38..62bdfe7 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -468,11 +468,16 @@ static struct cyclecounter cyclecounter = {
 	.mask	= CLOCKSOURCE_MASK(56),
 };
 
-static struct timecounter timecounter;
+static struct arch_timer_kvm_info arch_timer_kvm_info;
+
+struct arch_timer_kvm_info *arch_timer_get_kvm_info(void)
+{
+	return &arch_timer_kvm_info;
+}
 
 struct timecounter *arch_timer_get_timecounter(void)
 {
-	return &timecounter;
+	return &arch_timer_kvm_info.timecounter;
 }
 
 static void __init arch_counter_register(unsigned type)
@@ -500,7 +505,8 @@ static void __init arch_counter_register(unsigned type)
 	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
 	cyclecounter.mult = clocksource_counter.mult;
 	cyclecounter.shift = clocksource_counter.shift;
-	timecounter_init(&timecounter, &cyclecounter, start_count);
+	timecounter_init(&arch_timer_kvm_info.timecounter,
+			 &cyclecounter, start_count);
 
 	/* 56 bits minimum, so we assume worst case rollover */
 	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 25d0914..9101ed6b 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -49,11 +49,16 @@ enum arch_timer_reg {
 
 #define ARCH_TIMER_EVT_STREAM_FREQ	10000	/* 100us */
 
+struct arch_timer_kvm_info {
+	struct timecounter timecounter;
+};
+
 #ifdef CONFIG_ARM_ARCH_TIMER
 
 extern u32 arch_timer_get_rate(void);
 extern u64 (*arch_timer_read_counter)(void);
 extern struct timecounter *arch_timer_get_timecounter(void);
+extern struct arch_timer_kvm_info *arch_timer_get_kvm_info(void);
 
 #else
 
-- 
1.9.1
