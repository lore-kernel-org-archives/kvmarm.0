From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH kvm-unit-tests 1/3] arm64: timer: Fix vtimer interrupt test
Date: Thu, 13 Jul 2017 21:20:07 +0200
Message-ID: <20170713192009.10069-2-cdall@linaro.org>
References: <20170713192009.10069-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170713192009.10069-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Andrew Jones <drjones@redhat.com>, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The timer irq_handler is supposed to mask the timer signal, but unfortunately
also disables the timer at the same time, even though we loop and wait on
ISTATUS to become set.

According to the ARM ARM, "When the value of the ENABLE bit is 0, the
ISTATUS field is UNKNOWN."  This test happens to work on AMD Seattle, but
doesn't work on Mustang or on QEMU with TCG.

Fix the problem by preserving the enable bit in the irq handler.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arm/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index 89f4c94..02d9e0a 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -28,7 +28,7 @@ static void irq_handler(struct pt_regs *regs)
 		gic_write_eoir(irqstat);
 
 	if (irqnr == PPI(vtimer_irq)) {
-		write_sysreg(CNTV_CTL_IMASK, cntv_ctl_el0);
+		write_sysreg(CNTV_CTL_IMASK | CNTV_CTL_ENABLE, cntv_ctl_el0);
 		++vtimer_irq_received;
 	}
 }
-- 
2.9.0
