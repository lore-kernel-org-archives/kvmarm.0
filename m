From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH 1/2] arm64: timer: add TVAL accessors
Date: Mon, 16 Jul 2018 16:14:37 +0100
Message-ID: <20180716151438.9877-2-andre.przywara@arm.com>
References: <20180716151438.9877-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E8664A129
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 11:01:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ZWjz7ojxKkS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 11:01:44 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2134A128
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 11:01:44 -0400 (EDT)
In-Reply-To: <20180716151438.9877-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The ARM arch timer features the CVAL register, which holds an absolute
value that is compared against the counter value.
But there is also the TVAL register, which is defined as (CVAL - counter),
and can be used to program or read relative timeouts.

Add accessors for the TVAL register, to be able to read and write them
easily later.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/timer.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index 5f3135f..1c9ef44 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -40,6 +40,16 @@ static void write_vtimer_cval(u64 val)
 	write_sysreg(val, cntv_cval_el0);
 }
 
+static s32 read_vtimer_tval(void)
+{
+	return read_sysreg(cntv_tval_el0);
+}
+
+static void write_vtimer_tval(s32 val)
+{
+	write_sysreg(val, cntv_tval_el0);
+}
+
 static u64 read_vtimer_ctl(void)
 {
 	return read_sysreg(cntv_ctl_el0);
@@ -65,6 +75,16 @@ static void write_ptimer_cval(u64 val)
 	write_sysreg(val, cntp_cval_el0);
 }
 
+static s32 read_ptimer_tval(void)
+{
+	return read_sysreg(cntp_tval_el0);
+}
+
+static void write_ptimer_tval(s32 val)
+{
+	write_sysreg(val, cntp_tval_el0);
+}
+
 static u64 read_ptimer_ctl(void)
 {
 	return read_sysreg(cntp_ctl_el0);
@@ -82,6 +102,8 @@ struct timer_info {
 	u64 (*read_counter)(void);
 	u64 (*read_cval)(void);
 	void (*write_cval)(u64);
+	s32 (*read_tval)(void);
+	void (*write_tval)(s32);
 	u64 (*read_ctl)(void);
 	void (*write_ctl)(u64);
 };
@@ -91,6 +113,8 @@ static struct timer_info vtimer_info = {
 	.read_counter = read_vtimer_counter,
 	.read_cval = read_vtimer_cval,
 	.write_cval = write_vtimer_cval,
+	.read_tval = read_vtimer_tval,
+	.write_tval = write_vtimer_tval,
 	.read_ctl = read_vtimer_ctl,
 	.write_ctl = write_vtimer_ctl,
 };
@@ -100,6 +124,8 @@ static struct timer_info ptimer_info = {
 	.read_counter = read_ptimer_counter,
 	.read_cval = read_ptimer_cval,
 	.write_cval = write_ptimer_cval,
+	.read_tval = read_ptimer_tval,
+	.write_tval = write_ptimer_tval,
 	.read_ctl = read_ptimer_ctl,
 	.write_ctl = write_ptimer_ctl,
 };
-- 
2.14.4
