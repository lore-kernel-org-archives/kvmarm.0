From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: unregister notifiers in hyp mode teardown path
Date: Wed, 6 Apr 2016 13:52:50 +0200
Message-ID: <20160406115250.GC16355@cbox>
References: <1459777611-22592-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41AE6407A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 07:51:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TITXV+U7xfSV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2016 07:51:20 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A953940402
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 07:51:20 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id n3so59417478wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2016 04:52:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459777611-22592-1-git-send-email-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Sudeep,


On Mon, Apr 04, 2016 at 02:46:51PM +0100, Sudeep Holla wrote:
> Commit 1e947bad0b63 ("arm64: KVM: Skip HYP setup when already running
> in HYP") re-organized the hyp init code and ended up leaving the CPU
> hotplug and PM notifier even if hyp mode initialization fails.
> 
> Since KVM is not yet supported with ACPI, the above mentioned commit
> breaks CPU hotplug in ACPI boot.
> 
> This patch fixes teardown_hyp_mode to properly unregister both CPU
> hotplug and PM notifiers in the teardown path.
> 
> Fixes: 1e947bad0b63 ("arm64: KVM: Skip HYP setup when already running in HYP")
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>

I fixed up your patch to apply after James' patch:
5f5560b (arm64: KVM: Register CPU notifiers when the kernel runs at HYP, 2016-03-30)

My only concern with this approach is that we're not checking the return
values from the cpu_pm_register_notifier calls, and we're potentially
calling unregister_cpu_notifier even if the original registration
failed.

I know this can't happen given current implementations, but if any of
these functions ever start returning error values, then we're silently
ignoring them.  What is our policy on these things?

Let me know if the following revised version of your patch looks ok to
you (against kvmarm/master):

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index b538431..dded1b7 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1112,10 +1112,17 @@ static void __init hyp_cpu_pm_init(void)
 {
 	cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
 }
+static void __init hyp_cpu_pm_exit(void)
+{
+	cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
+}
 #else
 static inline void hyp_cpu_pm_init(void)
 {
 }
+static inline void hyp_cpu_pm_exit(void)
+{
+}
 #endif
 
 static void teardown_common_resources(void)
@@ -1141,9 +1148,7 @@ static int init_subsystems(void)
 	/*
 	 * Register CPU Hotplug notifier
 	 */
-	cpu_notifier_register_begin();
-	err = __register_cpu_notifier(&hyp_init_cpu_nb);
-	cpu_notifier_register_done();
+	err = register_cpu_notifier(&hyp_init_cpu_nb);
 	if (err) {
 		kvm_err("Cannot register KVM init CPU notifier (%d)\n", err);
 		return err;
@@ -1193,6 +1198,8 @@ static void teardown_hyp_mode(void)
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu)
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+	unregister_cpu_notifier(&hyp_init_cpu_nb);
+	hyp_cpu_pm_exit();
 }
 
 static int init_vhe_mode(void)

Thanks,
-Christoffer
