From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests 0/2] arm64: add vtimer test
Date: Tue,  4 Jul 2017 15:58:36 +0200
Message-ID: <20170704135838.9061-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: agraf@suse.de, cdall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Add a test for the vtimer. I've tested on
 accel=tcg
 accel=kvm,kernel-irqchip=on  : on thunderx, seattle, and mustang
 accel=kvm,kernel-irqchip=off : on thunderx and mustang

It works everywhere without modification except on mustang. My mustang
seems to have a hardware problem requiring bit 31 of CNTV_CVAL_EL0
to be clear before attempting to enable (setting CNTV_CTL_EL0.ENABLE),
otherwise the VCPU hangs... My mustang's CNTV_CVAL_EL0 also has the
strange issue of not being able to set the upper 8 bits.  Well, fixing
hardware is outside my job description, so "oh, well..." If you hit
the same problem, try the hack below, which allows tests to run and
pass for me.

diff --git a/arm/timer.c b/arm/timer.c
index 89f4c9400ab69..18b8c4773c92f 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -73,7 +73,7 @@ static void test_vtimer(void)
 	report_prefix_push("vtimer-busy-loop");
 
 	/* Enable the timer */
-	write_sysreg(~0, cntv_cval_el0);
+	write_sysreg(~0 & ~(1<<31), cntv_cval_el0);
 	isb();
 	write_sysreg(CNTV_CTL_ENABLE, cntv_ctl_el0);
 

Alexander Graf (1):
  arm64: add vtimer test

Andrew Jones (1):
  arm64: timer: check for vtimer interrupt

 arm/Makefile.arm64 |   2 +-
 arm/timer.c        | 134 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |   6 +++
 lib/arm/asm/gic.h  |   4 ++
 4 files changed, 145 insertions(+), 1 deletion(-)
 create mode 100644 arm/timer.c

-- 
2.9.4
