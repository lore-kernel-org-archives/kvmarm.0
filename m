From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/13] [HACK] gcc-4.5: avoid link errors for unused function
 pointers
Date: Fri, 16 Dec 2016 11:56:22 +0100
Message-ID: <20161216105634.235457-2-arnd@arndb.de>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94A76404AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S2Fp2RzgnK0T for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 05:55:39 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28CE1404BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:39 -0500 (EST)
In-Reply-To: <20161216105634.235457-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, kernel-build-reports@lists.linaro.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

gcc versions before 4.6 cannot do dead code elimination across
function pointers, e.g. with a construct like

static int f(void)
{
	return declared_extern_but_undefined_function();
}

static int g(void)
{
	if (0)
		reference_function(&f);
}

which we rely on in lots of places when registering functions,
it results in a link error for
declared_extern_but_undefined_function.

This patch is incomplete and introduces a few other problems
(at least warnings about unused functions), but it shows what
we would have to do in order to address this in the kernel.

The three options forward I see are:

- Declare gcc-4.5 (and prior version) fully supported and
  do proper fixes for the bugs we find.

- Officially declare gcc-4.6 the minimum required version
  for the kernel and remove all existing hacks we have for
  older versions.

- Do nothing: if you use an older gcc version and you run into
  this, you are on your own and can submit a patch for the
  specific problem you find.

At the moment, gcc-3.2 is in theory still supported, but I
found that even gcc-4.2 is almost completely useless these
days at least on ARM.

If we want to keep gcc-4.5 supported, then we can probably
have 4.3 as the minimum version without too many other
workarounds.

Do not apply but feel free to pick out parts of this
patch and submit them if you use old gcc versions and
run into the problems.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-imx/pm-imx5.c          | 20 ++++++++++++++++----
 arch/arm/mach-sa1100/pm.c            |  2 ++
 arch/arm/plat-samsung/pm.c           |  4 ++++
 drivers/dma/ti-dma-crossbar.c        |  4 ++++
 drivers/firmware/psci_checker.c      |  3 +++
 drivers/iio/adc/exynos_adc.c         |  3 +++
 drivers/net/ethernet/via/via-rhine.c |  6 ++++++
 7 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/pm-imx5.c b/arch/arm/mach-imx/pm-imx5.c
index 9424e7f808c7..de912b0a6451 100644
--- a/arch/arm/mach-imx/pm-imx5.c
+++ b/arch/arm/mach-imx/pm-imx5.c
@@ -78,6 +78,7 @@ struct imx5_pm_suspend_data {
 	int suspend_io_count;
 };
 
+#ifdef CONFIG_SOC_IMX53
 static const struct imx5_suspend_io_state imx53_suspend_io_config[] = {
 #define MX53_DSE_HIGHZ_MASK (0x7 << 19)
 	{.offset = 0x584, .clear = MX53_DSE_HIGHZ_MASK}, /* DQM0 */
@@ -104,13 +105,17 @@ static const struct imx5_suspend_io_state imx53_suspend_io_config[] = {
 	/* Controls the CKE signal which is required to leave self refresh */
 	{.offset = 0x720, .clear = MX53_DSE_HIGHZ_MASK, .set = 1 << 19}, /* CTLDS */
 };
+#endif
 
+#ifdef CONFIG_SOC_IMX51
 static const struct imx5_pm_data imx51_pm_data __initconst = {
 	.ccm_addr = 0x73fd4000,
 	.cortex_addr = 0x83fa0000,
 	.gpc_addr = 0x73fd8000,
 };
+#endif
 
+#if defined(CONFIG_SOC_IMX53) && defined(CONFIG_SUSPEND)
 static const struct imx5_pm_data imx53_pm_data __initconst = {
 	.ccm_addr = 0x53fd4000,
 	.cortex_addr = 0x63fa0000,
@@ -127,6 +132,9 @@ static const struct imx5_pm_suspend_data imx53_pm_suspend_data __initconst = {
 };
 
 #define MX5_MAX_SUSPEND_IOSTATE ARRAY_SIZE(imx53_suspend_io_config)
+#else
+#define MX5_MAX_SUSPEND_IOSTATE 0
+#endif
 
 /*
  * This structure is for passing necessary data for low level ocram
@@ -383,6 +391,7 @@ static int __init imx5_suspend_init(const struct imx5_pm_suspend_data *soc_data)
 	return ret;
 }
 
+#if defined(CONFIG_SUSPEND)
 static int __init imx5_pm_common_init(const struct imx5_pm_data *data,
 				      const struct imx5_pm_suspend_data *sdata)
 {
@@ -420,15 +429,18 @@ static int __init imx5_pm_common_init(const struct imx5_pm_data *data,
 
 	return 0;
 }
+#endif
 
 void __init imx51_pm_init(void)
 {
-	if (IS_ENABLED(CONFIG_SOC_IMX51))
-		imx5_pm_common_init(&imx51_pm_data, NULL);
+#if defined(CONFIG_SOC_IMX51) && defined(CONFIG_SUSPEND)
+	imx5_pm_common_init(&imx51_pm_data, NULL);
+#endif
 }
 
 void __init imx53_pm_init(void)
 {
-	if (IS_ENABLED(CONFIG_SOC_IMX53))
-		imx5_pm_common_init(&imx53_pm_data, &imx53_pm_suspend_data);
+#if defined(CONFIG_SOC_IMX53) && defined(CONFIG_SUSPEND)
+	imx5_pm_common_init(&imx53_pm_data, &imx53_pm_suspend_data);
+#endif
 }
diff --git a/arch/arm/mach-sa1100/pm.c b/arch/arm/mach-sa1100/pm.c
index 34853d5dfda2..cb896dc97030 100644
--- a/arch/arm/mach-sa1100/pm.c
+++ b/arch/arm/mach-sa1100/pm.c
@@ -121,6 +121,8 @@ static const struct platform_suspend_ops sa11x0_pm_ops = {
 
 int __init sa11x0_pm_init(void)
 {
+#ifdef CONFIG_SUSPEND
 	suspend_set_ops(&sa11x0_pm_ops);
+#endif
 	return 0;
 }
diff --git a/arch/arm/plat-samsung/pm.c b/arch/arm/plat-samsung/pm.c
index d7803b434732..264c538a3ab8 100644
--- a/arch/arm/plat-samsung/pm.c
+++ b/arch/arm/plat-samsung/pm.c
@@ -71,6 +71,7 @@ int (*pm_cpu_sleep)(unsigned long);
  * central control for sleep/resume process
 */
 
+#ifdef CONFIG_SUSPEND
 static int s3c_pm_enter(suspend_state_t state)
 {
 	int ret;
@@ -194,11 +195,14 @@ static const struct platform_suspend_ops s3c_pm_ops = {
  * from the board specific initialisation if the board supports
  * it.
 */
+#endif
 
 int __init s3c_pm_init(void)
 {
+#ifdef CONFIG_SUSPEND
 	printk("S3C Power Management, Copyright 2004 Simtec Electronics\n");
 
 	suspend_set_ops(&s3c_pm_ops);
+#endif
 	return 0;
 }
diff --git a/drivers/dma/ti-dma-crossbar.c b/drivers/dma/ti-dma-crossbar.c
index 3f24aeb48c0e..e9f0543cb30a 100644
--- a/drivers/dma/ti-dma-crossbar.c
+++ b/drivers/dma/ti-dma-crossbar.c
@@ -184,8 +184,10 @@ static int ti_am335x_xbar_probe(struct platform_device *pdev)
 	for (i = 0; i < xbar->dma_requests; i++)
 		ti_am335x_xbar_write(xbar->iomem, i, 0);
 
+#ifdef CONFIG_DMA_OF
 	ret = of_dma_router_register(node, ti_am335x_xbar_route_allocate,
 				     &xbar->dmarouter);
+#endif
 
 	return ret;
 }
@@ -414,8 +416,10 @@ static int ti_dra7_xbar_probe(struct platform_device *pdev)
 			ti_dra7_xbar_write(xbar->iomem, i, xbar->safe_val);
 	}
 
+#ifdef CONFIG_DMA_OF
 	ret = of_dma_router_register(node, ti_dra7_xbar_route_allocate,
 				     &xbar->dmarouter);
+#endif
 	if (ret) {
 		/* Restore the defaults for the crossbar */
 		for (i = 0; i < xbar->dma_requests; i++) {
diff --git a/drivers/firmware/psci_checker.c b/drivers/firmware/psci_checker.c
index 44bdb78f837b..37c5c873c5ec 100644
--- a/drivers/firmware/psci_checker.c
+++ b/drivers/firmware/psci_checker.c
@@ -273,6 +273,9 @@ static int suspend_test_thread(void *arg)
 	struct timer_list wakeup_timer =
 		TIMER_INITIALIZER(dummy_callback, 0, 0);
 
+	if (!IS_ENABLED(CONFIG_CPU_IDLE))
+		return -ENXIO;
+
 	/* Wait for the main thread to give the start signal. */
 	wait_for_completion(&suspend_threads_started);
 
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index c15756d7bf7f..b2a658aa9a83 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -615,6 +615,9 @@ static irqreturn_t exynos_ts_isr(int irq, void *dev_id)
 	bool pressed;
 	int ret;
 
+	if (!IS_REACHABLE(CONFIG_INPUT))
+		return IRQ_HANDLED;
+
 	while (info->input->users) {
 		ret = exynos_read_s3c64xx_ts(dev, &x, &y);
 		if (ret == -ETIMEDOUT)
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index ba5c54249055..6b45401ff149 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -2580,6 +2580,7 @@ static SIMPLE_DEV_PM_OPS(rhine_pm_ops, rhine_suspend, rhine_resume);
 
 #endif /* !CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PCI
 static struct pci_driver rhine_driver_pci = {
 	.name		= DRV_NAME,
 	.id_table	= rhine_pci_tbl,
@@ -2588,6 +2589,7 @@ static struct pci_driver rhine_driver_pci = {
 	.shutdown	= rhine_shutdown_pci,
 	.driver.pm	= RHINE_PM_OPS,
 };
+#endif
 
 static struct platform_driver rhine_driver_platform = {
 	.probe		= rhine_init_one_platform,
@@ -2633,7 +2635,9 @@ static int __init rhine_init(void)
 	else if (avoid_D3)
 		pr_info("avoid_D3 set\n");
 
+#ifdef CONFIG_PCI
 	ret_pci = pci_register_driver(&rhine_driver_pci);
+#endif
 	ret_platform = platform_driver_register(&rhine_driver_platform);
 	if ((ret_pci < 0) && (ret_platform < 0))
 		return ret_pci;
@@ -2645,7 +2649,9 @@ static int __init rhine_init(void)
 static void __exit rhine_cleanup(void)
 {
 	platform_driver_unregister(&rhine_driver_platform);
+#ifdef CONFIG_PCI
 	pci_unregister_driver(&rhine_driver_pci);
+#endif
 }
 
 
-- 
2.9.0
