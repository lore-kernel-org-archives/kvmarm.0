From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 02/20] arm64: Implement arch_counter_get_cntpct to read the
 physical counter
Date: Fri, 20 Oct 2017 13:49:21 +0200
Message-ID: <20171020114939.12554-3-christoffer.dall@linaro.org>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE5FF49D1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:48:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lR70O30dBG-l for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 07:48:40 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37AF949D20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:48:39 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id l68so21954411wmd.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 04:49:45 -0700 (PDT)
In-Reply-To: <20171020114939.12554-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to use the physical counter on arm64 systems that have
KVM support, implement arch_counter_get_cntpct() and the associated
errata workaround functionality for stable timer reads.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v3:
     - Factored out this change into a separate patch

 arch/arm64/include/asm/arch_timer.h  |  8 +++-----
 drivers/clocksource/arm_arch_timer.c | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index a652ce0a5cb2..04275de614db 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -52,6 +52,7 @@ struct arch_timer_erratum_workaround {
 	const char *desc;
 	u32 (*read_cntp_tval_el0)(void);
 	u32 (*read_cntv_tval_el0)(void);
+	u64 (*read_cntpct_el0)(void);
 	u64 (*read_cntvct_el0)(void);
 	int (*set_next_event_phys)(unsigned long, struct clock_event_device *);
 	int (*set_next_event_virt)(unsigned long, struct clock_event_device *);
@@ -148,11 +149,8 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 
 static inline u64 arch_counter_get_cntpct(void)
 {
-	/*
-	 * AArch64 kernel and user space mandate the use of CNTVCT.
-	 */
-	BUG();
-	return 0;
+	isb();
+	return arch_timer_reg_read_stable(cntpct_el0);
 }
 
 static inline u64 arch_counter_get_cntvct(void)
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index fd4b7f684bd0..ff8f8a177156 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -217,6 +217,11 @@ static u32 notrace fsl_a008585_read_cntv_tval_el0(void)
 	return __fsl_a008585_read_reg(cntv_tval_el0);
 }
 
+static u64 notrace fsl_a008585_read_cntpct_el0(void)
+{
+	return __fsl_a008585_read_reg(cntpct_el0);
+}
+
 static u64 notrace fsl_a008585_read_cntvct_el0(void)
 {
 	return __fsl_a008585_read_reg(cntvct_el0);
@@ -258,6 +263,11 @@ static u32 notrace hisi_161010101_read_cntv_tval_el0(void)
 	return __hisi_161010101_read_reg(cntv_tval_el0);
 }
 
+static u64 notrace hisi_161010101_read_cntpct_el0(void)
+{
+	return __hisi_161010101_read_reg(cntpct_el0);
+}
+
 static u64 notrace hisi_161010101_read_cntvct_el0(void)
 {
 	return __hisi_161010101_read_reg(cntvct_el0);
@@ -288,6 +298,15 @@ static struct ate_acpi_oem_info hisi_161010101_oem_info[] = {
 #endif
 
 #ifdef CONFIG_ARM64_ERRATUM_858921
+static u64 notrace arm64_858921_read_cntpct_el0(void)
+{
+	u64 old, new;
+
+	old = read_sysreg(cntpct_el0);
+	new = read_sysreg(cntpct_el0);
+	return (((old ^ new) >> 32) & 1) ? old : new;
+}
+
 static u64 notrace arm64_858921_read_cntvct_el0(void)
 {
 	u64 old, new;
@@ -346,6 +365,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.desc = "Freescale erratum a005858",
 		.read_cntp_tval_el0 = fsl_a008585_read_cntp_tval_el0,
 		.read_cntv_tval_el0 = fsl_a008585_read_cntv_tval_el0,
+		.read_cntpct_el0 = fsl_a008585_read_cntpct_el0,
 		.read_cntvct_el0 = fsl_a008585_read_cntvct_el0,
 		.set_next_event_phys = erratum_set_next_event_tval_phys,
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
@@ -358,6 +378,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.desc = "HiSilicon erratum 161010101",
 		.read_cntp_tval_el0 = hisi_161010101_read_cntp_tval_el0,
 		.read_cntv_tval_el0 = hisi_161010101_read_cntv_tval_el0,
+		.read_cntpct_el0 = hisi_161010101_read_cntpct_el0,
 		.read_cntvct_el0 = hisi_161010101_read_cntvct_el0,
 		.set_next_event_phys = erratum_set_next_event_tval_phys,
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
@@ -368,6 +389,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.desc = "HiSilicon erratum 161010101",
 		.read_cntp_tval_el0 = hisi_161010101_read_cntp_tval_el0,
 		.read_cntv_tval_el0 = hisi_161010101_read_cntv_tval_el0,
+		.read_cntpct_el0 = hisi_161010101_read_cntpct_el0,
 		.read_cntvct_el0 = hisi_161010101_read_cntvct_el0,
 		.set_next_event_phys = erratum_set_next_event_tval_phys,
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
@@ -378,6 +400,7 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.match_type = ate_match_local_cap_id,
 		.id = (void *)ARM64_WORKAROUND_858921,
 		.desc = "ARM erratum 858921",
+		.read_cntpct_el0 = arm64_858921_read_cntpct_el0,
 		.read_cntvct_el0 = arm64_858921_read_cntvct_el0,
 	},
 #endif
-- 
2.14.2
