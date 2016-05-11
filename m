From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 28/29] clocksource: arm_arch_timer: Remove
 arch_timer_get_timecounter
Date: Wed, 11 May 2016 15:30:21 +0200
Message-ID: <1462973422-10021-29-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9A6F49B51
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xDud4WpqGsgI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:29:30 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C13149B70
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:20 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id g17so82956720wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:32:18 -0700 (PDT)
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Julien Grall <julien.grall@arm.com>

The only call of arch_timer_get_timecounter (in KVM) has been removed.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
2.1.2.330.g565301e.dirty
