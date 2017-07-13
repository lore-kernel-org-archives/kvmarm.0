From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH kvm-unit-tests 2/3] arm64: timer: Fix test on APM X-Gene
Date: Thu, 13 Jul 2017 21:20:08 +0200
Message-ID: <20170713192009.10069-3-cdall@linaro.org>
References: <20170713192009.10069-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9F440D17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jul 2017 15:19:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KyXPuhh1a+fb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jul 2017 15:19:44 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F08A040D25
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jul 2017 15:19:43 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id i127so2203879wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jul 2017 12:20:23 -0700 (PDT)
In-Reply-To: <20170713192009.10069-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <cdall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

When running the vtimer test on an APM X-Gene, setting the timer value
to (2^64 - 1) apparently results in the timer always firing, even
thought the counter is mich lower than the cval.

Since the idea of the code is to set everything up and schedule the
timer for some time very far in the future, take a pragmatic approach
and just add 10s worth of delay instead.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arm/timer.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 02d9e0a..77d257c 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -70,10 +70,14 @@ static bool test_cval_10msec(void)
 
 static void test_vtimer(void)
 {
+	u64 now = read_sysreg(cntvct_el0);
+	u64 time_10s = read_sysreg(cntfrq_el0) * 10;
+	u64 later = now + time_10s;
+
 	report_prefix_push("vtimer-busy-loop");
 
-	/* Enable the timer */
-	write_sysreg(~0, cntv_cval_el0);
+	/* Enable the timer, but schedule it for much later*/
+	write_sysreg(later, cntv_cval_el0);
 	isb();
 	write_sysreg(CNTV_CTL_ENABLE, cntv_ctl_el0);
 
-- 
2.9.0
