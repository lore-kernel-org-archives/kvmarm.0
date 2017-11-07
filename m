From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 01/26] arm64: Implement arch_counter_get_cntpct to read the
 physical counter
Date: Tue,  7 Nov 2017 11:47:34 +0100
Message-ID: <20171107104800.30021-2-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4250B49D6B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BvZtNVRzk8HH for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 05:46:17 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E64949D19
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:17 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id r196so2752003wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Nov 2017 02:48:11 -0800 (PST)
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to use the physical counter on arm64 systems that have
KVM support, implement arch_counter_get_cntpct() and the associated
errata workaround functionality for stable timer reads.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
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
