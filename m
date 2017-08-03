From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH kvm-unit-tests] arm64: timer: Use correct counter for !pending_before
Date: Thu,  3 Aug 2017 08:25:45 +0200
Message-ID: <20170803062545.17533-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We were using the virtual counter to calculate a timer cval which is 10
seconds in the future, but this obviously doesn't work for the physical
timer which is bases on the physical counter.

Make sure we use a properly paired timer/counter pair.

Reported-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arm/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index e824338..4cdca9e 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -174,7 +174,7 @@ static bool test_cval_10msec(struct timer_info *info)
 
 static void test_timer(struct timer_info *info)
 {
-	u64 now = read_sysreg(cntvct_el0);
+	u64 now = info->read_counter();
 	u64 time_10s = read_sysreg(cntfrq_el0) * 10;
 	u64 later = now + time_10s;
 
-- 
2.9.0
