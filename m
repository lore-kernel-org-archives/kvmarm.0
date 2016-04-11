From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v6 10/10] clocksource: arm_arch_timer: Remove
 arch_timer_get_timecounter
Date: Mon, 11 Apr 2016 16:33:00 +0100
Message-ID: <1460388780-914-11-git-send-email-julien.grall@arm.com>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E17CC409A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:31:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fLdbHxL8YEZP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 11:31:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C19C40C9A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:31:58 -0400 (EDT)
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

The only call of arch_timer_get_timecounter (in KVM) has been removed.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

---
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>

    Changes in v4:
        - Add Christoffer's acked-by

    Changes in v3:
        - Patch added
---
 drivers/clocksource/arm_arch_timer.c | 5 -----
 include/clocksource/arm_arch_timer.h | 6 ------
 2 files changed, 11 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index bb58224..4814446 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -475,11 +475,6 @@ struct arch_timer_kvm_info *arch_timer_get_kvm_info(void)
 	return &arch_timer_kvm_info;
 }
 
-struct timecounter *arch_timer_get_timecounter(void)
-{
-	return &arch_timer_kvm_info.timecounter;
-}
-
 static void __init arch_counter_register(unsigned type)
 {
 	u64 start_count;
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 9dd996a..caedb74 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -58,7 +58,6 @@ struct arch_timer_kvm_info {
 
 extern u32 arch_timer_get_rate(void);
 extern u64 (*arch_timer_read_counter)(void);
-extern struct timecounter *arch_timer_get_timecounter(void);
 extern struct arch_timer_kvm_info *arch_timer_get_kvm_info(void);
 
 #else
@@ -73,11 +72,6 @@ static inline u64 arch_timer_read_counter(void)
 	return 0;
 }
 
-static inline struct timecounter *arch_timer_get_timecounter(void)
-{
-	return NULL;
-}
-
 #endif
 
 #endif
-- 
1.9.1
