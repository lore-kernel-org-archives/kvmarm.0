From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v2 1/6] KVM: arm/arm64: arch_timer: Gather KVM specific
 information in a structure
Date: Thu, 11 Feb 2016 15:33:19 +0000
Message-ID: <1455204804-31830-2-git-send-email-julien.grall@arm.com>
References: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC56249BE5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 10:27:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SqfOOkfp3Oxr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 10:27:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 911E449BBF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 10:27:38 -0500 (EST)
In-Reply-To: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
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
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, fu.wei@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Introduce a structure which are filled up by the arch timer driver and
used by the virtual timer in KVM.

The first member of this structure will be the timecounter. More members
will be added later.

This is also dropping arch_timer_get_timecounter as it was only used by
the KVM code. Furthermore, a stub for the new helper hasn't been
introduced because KVM is requiring the arch timer for both ARM64 and
ARM32.

Signed-off-by: Julien Grall <julien.grall@arm.com>

---
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/clocksource/arm_arch_timer.c |  9 +++++----
 include/clocksource/arm_arch_timer.h | 12 ++++++------
 virt/kvm/arm/arch_timer.c            |  6 +++---
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index c64d543..6eb2c5d 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -447,11 +447,11 @@ static struct cyclecounter cyclecounter = {
 	.mask	= CLOCKSOURCE_MASK(56),
 };
 
-static struct timecounter timecounter;
+static struct arch_timer_kvm_info arch_timer_kvm_info;
 
-struct timecounter *arch_timer_get_timecounter(void)
+struct arch_timer_kvm_info *arch_timer_get_kvm_info(void)
 {
-	return &timecounter;
+	return &arch_timer_kvm_info;
 }
 
 static void __init arch_counter_register(unsigned type)
@@ -479,7 +479,8 @@ static void __init arch_counter_register(unsigned type)
 	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
 	cyclecounter.mult = clocksource_counter.mult;
 	cyclecounter.shift = clocksource_counter.shift;
-	timecounter_init(&timecounter, &cyclecounter, start_count);
+	timecounter_init(&arch_timer_kvm_info.timecounter,
+			 &cyclecounter, start_count);
 
 	/* 56 bits minimum, so we assume worst case rollover */
 	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 25d0914..4d487f8 100644
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
-extern struct timecounter *arch_timer_get_timecounter(void);
+
+extern struct arch_timer_kvm_info *arch_timer_get_kvm_info(void);
 
 #else
 
@@ -67,11 +72,6 @@ static inline u64 arch_timer_read_counter(void)
 	return 0;
 }
 
-static inline struct timecounter *arch_timer_get_timecounter(void)
-{
-	return NULL;
-}
-
 #endif
 
 #endif
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 69bca18..a669c6a 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -385,11 +385,11 @@ int kvm_timer_hyp_init(void)
 {
 	struct device_node *np;
 	unsigned int ppi;
+	struct arch_timer_kvm_info *info;
 	int err;
 
-	timecounter = arch_timer_get_timecounter();
-	if (!timecounter)
-		return -ENODEV;
+	info = arch_timer_get_kvm_info();
+	timecounter = &info->timecounter;
 
 	np = of_find_matching_node(NULL, arch_timer_of_match);
 	if (!np) {
-- 
1.9.1
