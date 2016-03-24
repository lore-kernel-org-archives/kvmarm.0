From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v4 2/9] clocksource: arm_arch_timer: Extend
 arch_timer_kvm_info to get the virtual IRQ
Date: Thu, 24 Mar 2016 17:53:36 +0000
Message-ID: <1458842023-31853-3-git-send-email-julien.grall@arm.com>
References: <1458842023-31853-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C896407AD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 13:53:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zOqY8JT72P4b for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 13:53:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 564B2412ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 13:53:17 -0400 (EDT)
In-Reply-To: <1458842023-31853-1-git-send-email-julien.grall@arm.com>
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
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Currently, the firmware table is parsed by the virtual timer code in
order to retrieve the virtual timer interrupt. However, this is already
done by the arch timer driver.

To avoid code duplication, extend arch_timer_kvm_info to get the virtual
IRQ.

Note that the KVM code will be modified in a subsequent patch.

Signed-off-by: Julien Grall <julien.grall@arm.com>

---
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>

    Changes in v4:
        - Move the initialization of the virtual_irq into
        arch_timer_init as KVM mandates the system registers timer.

    Changes in v3:
        - Move the KVM changes into a separate patch and rename the patch
        - Move the initialization of the virtual_irq into
        arch_timer_common_init
---
 drivers/clocksource/arm_arch_timer.c | 2 ++
 include/clocksource/arm_arch_timer.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 62bdfe7..bb58224 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -750,6 +750,8 @@ static void __init arch_timer_init(void)
 
 	arch_timer_register();
 	arch_timer_common_init();
+
+	arch_timer_kvm_info.virtual_irq = arch_timer_ppi[VIRT_PPI];
 }
 
 static void __init arch_timer_of_init(struct device_node *np)
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 9101ed6b..9dd996a 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -51,6 +51,7 @@ enum arch_timer_reg {
 
 struct arch_timer_kvm_info {
 	struct timecounter timecounter;
+	int virtual_irq;
 };
 
 #ifdef CONFIG_ARM_ARCH_TIMER
-- 
1.9.1
