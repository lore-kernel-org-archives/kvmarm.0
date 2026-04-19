Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F69334C1C
	for <kvmarm@lists.linux.dev>; Sun, 19 Apr 2026 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776597173; cv=none; b=hO8cF75hZNW/uA9jtqBLwhYlmWrdxJREnCfs2pn6/KOjChxVibT+m4nmuo3J4qKDKFFrlKQKyLw0SodIhHjIWI3rXPSe9pKCzSvfHumiNc2cvmyTZXUl5yV/6XsNzy8ypXnr+kX0WuhsDU7c0R3/WPimoAUnfzey2E/2G7SGQuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776597173; c=relaxed/simple;
	bh=T+vbr4chV9cggPos+uUjAlusV7otX0Vrov18mP9n3X8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3FHghv+p3Es7BvS6U288hbr98Weg2lajUjLV9Nbuy7WlLwS7gFEzPDTYDDnw2zOKcIKE7hdXUAiR9cDdbns2RUt9dKnHGqOp09O9S6xpq3qQeh+FuF0UDkLsE6oULrwQxTh7p+54GdJBfr4HyLRBt3qNQW1xpBt9nG+4+Xbpso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fMHsKQdM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fMHsKQdM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D53D1758;
	Sun, 19 Apr 2026 04:12:44 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0153D3F7D8;
	Sun, 19 Apr 2026 04:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776597170; bh=T+vbr4chV9cggPos+uUjAlusV7otX0Vrov18mP9n3X8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fMHsKQdMYihhxfL83zudG/gJAAj0LtCF8cJcMRlcMw9st9x2BMpOcmjgu5y51B8J3
	 90mGwLOuDAbBvPt6Q5LMD4sD6ReM2doB753cyJ2Y6Z2EvH7s48ObMURMzx6gaNmKTB
	 I6NC27LPfOhvw98rmpXpt9arUsO8N4OhGOFoufXg=
Date: Sun, 19 Apr 2026 12:12:44 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca,
	sudeep.holla@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [RFC PATCH 4/4] firmware: arm_ffa: check pkvm initailised when
 initailise ffa driver
Message-ID: <aeS4rAeVQ0yJIPYw@e129823.arm.com>
References: <20260417175759.3191279-1-yeoreum.yun@arm.com>
 <20260417175759.3191279-5-yeoreum.yun@arm.com>
 <87se8sbozv.wl-maz@kernel.org>
 <aeNeNjfO7i128TIP@e129823.arm.com>
 <87pl3vb5bm.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pl3vb5bm.wl-maz@kernel.org>

Hi Marc,

> On Sat, 18 Apr 2026 11:34:30 +0100,
> Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> >
> > > > @@ -2035,6 +2037,16 @@ static int __init ffa_init(void)
> > > >  	u32 buf_sz;
> > > >  	size_t rxtx_bufsz = SZ_4K;
> > > >
> > > > +	/*
> > > > +	 * When pKVM is enabled, the FF-A driver must be initialized
> > > > +	 * after pKVM initialization. Otherwise, pKVM cannot negotiate
> > > > +	 * the FF-A version or obtain RX/TX buffer information,
> > > > +	 * which leads to failures in FF-A calls.
> > > > +	 */
> > > > +	if (IS_ENABLED(CONFIG_KVM) && is_protected_kvm_enabled() &&
> > > > +	    !is_kvm_arm_initialised())
> > > > +		return -EPROBE_DEFER;
> > > > +
> > >
> > > That's still fundamentally wrong: pkvm is not ready until
> > > finalize_pkvm() has finished, and that's not indicated by
> > > is_kvm_arm_initialised().
> >
> > Thanks. I miss the TSC bit set in here.
>
> That's the least of the problems. None of the infrastructure is in
> place at this stage...
>
> > IMHO, I'd like to make an new state check function --
> > is_pkvm_arm_initialised() so that ff-a driver to know whether
> > pkvm is initialised.
>
> Doesn't sound great, TBH.
>
> > or any other suggestion?
>
> Instead of adding more esoteric predicates, I'd rather you build on an
> existing infrastructure. You have a dependency on KVM, use something
> that is designed to enforce dependencies. Device links spring to mind
> as something designed for that.
>
> Can you look into enabling this for KVM? If that's possible, then it
> should be easy enough to delay the actual KVM registration after pKVM
> is finalised.

or what about some event notifier? Just like:

----------&<-----------

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index b51ab6840f9c..ad038a3b8727 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -68,6 +68,8 @@
 #include <asm/sysreg.h>
 #include <asm/cpufeature.h>

+struct notifier_block;
+
 /*
  * __boot_cpu_mode records what mode CPUs were booted in.
  * A correctly-implemented bootloader must start all CPUs in the same mode:
@@ -166,6 +168,15 @@ static inline bool is_hyp_nvhe(void)
 	return is_hyp_mode_available() && !is_kernel_in_hyp_mode();
 }

+enum kvm_arm_event {
+	PKVM_INITIALISED,
+	KVM_ARM_EVENT_MAX,
+};
+
+extern int kvm_arm_event_notifier_call_chain(enum kvm_arm_event event, void *data);
+extern int kvm_arm_event_notifier_register(struct notifier_block *nb);
+extern int kvm_arm_event_notifier_unregister(struct notifier_block *nb);
+
 #endif /* __ASSEMBLER__ */

 #endif /* ! __ASM__VIRT_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 410ffd41fd73..8da10049ab65 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -14,6 +14,7 @@
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 #include <linux/mman.h>
+#include <linux/notifier.h>
 #include <linux/sched.h>
 #include <linux/kvm.h>
 #include <linux/kvm_irqfd.h>
@@ -111,6 +112,8 @@ DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);

 DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);

+BLOCKING_NOTIFIER_HEAD(kvm_arm_event_notifier_head);
+
 static bool vgic_present, kvm_arm_initialised;

 static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
@@ -3064,4 +3067,22 @@ enum kvm_mode kvm_get_mode(void)
 	return kvm_mode;
 }

+int kvm_arm_event_notifier_call_chain(enum kvm_arm_event event, void *data)
+{
+	return blocking_notifier_call_chain(&kvm_arm_event_notifier_head,
+					    event, data);
+}
+
+int kvm_arm_event_notifier_register(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&kvm_arm_event_notifier_head, nb);
+}
+EXPORT_SYMBOL_GPL(kvm_arm_event_notifier_register);
+
+int kvm_arm_event_notifier_unregister(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&kvm_arm_event_notifier_head, nb);
+}
+EXPORT_SYMBOL_GPL(kvm_arm_event_notifier_unregister);
+
 module_init(kvm_arm_init);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d7a0f69a9982..e76562b0a45a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -280,6 +280,8 @@ static int __init finalize_pkvm(void)
 	ret = pkvm_drop_host_privileges();
 	if (ret)
 		pr_err("Failed to finalize Hyp protection: %d\n", ret);
+	else
+		kvm_arm_event_notifier_call_chain(PKVM_INITIALISED, NULL);

 	return ret;
 }
diff --git a/drivers/firmware/arm_ffa/common.h b/drivers/firmware/arm_ffa/common.h
index 9c6425a81d0d..5cdf4bd222c6 100644
--- a/drivers/firmware/arm_ffa/common.h
+++ b/drivers/firmware/arm_ffa/common.h
@@ -18,9 +18,9 @@ bool ffa_device_is_valid(struct ffa_device *ffa_dev);
 void ffa_device_match_uuid(struct ffa_device *ffa_dev, const uuid_t *uuid);

 #ifdef CONFIG_ARM_FFA_SMCCC
-int __init ffa_transport_init(ffa_fn **invoke_ffa_fn);
+int ffa_transport_init(ffa_fn **invoke_ffa_fn);
 #else
-static inline int __init ffa_transport_init(ffa_fn **invoke_ffa_fn)
+static inline int ffa_transport_init(ffa_fn **invoke_ffa_fn)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 02c76ac1570b..67df053e65b8 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/notifier.h>
 #include <linux/of_irq.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
@@ -42,6 +43,8 @@
 #include <linux/uuid.h>
 #include <linux/xarray.h>

+#include <asm/virt.h>
+
 #include "common.h"

 #define FFA_DRIVER_VERSION	FFA_VERSION_1_2
@@ -2029,7 +2032,7 @@ static void ffa_notifications_setup(void)
 	ffa_notifications_cleanup();
 }

-static int __init ffa_init(void)
+static int __ffa_init(void)
 {
 	int ret;
 	u32 buf_sz;
@@ -2105,11 +2108,42 @@ static int __init ffa_init(void)
 free_drv_info:
 	kfree(drv_info);
 	return ret;
+
+}
+
+static int ffa_kvm_arm_event_handler(struct notifier_block *nb,
+				     unsigned long event, void *unused)
+{
+	if (event == PKVM_INITIALISED)
+		__ffa_init();
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block ffa_kvm_arm_event_notifier = {
+	.notifier_call = ffa_kvm_arm_event_handler,
+};
+
+static int __init ffa_init(void)
+{
+	/*
+	 * When pKVM is enabled, the FF-A driver must be initialized
+	 * after pKVM initialization. Otherwise, pKVM cannot negotiate
+	 * the FF-A version or obtain RX/TX buffer information,
+	 * which leads to failures in FF-A calls.
+	 */
+	if (IS_ENABLED(CONFIG_KVM) && is_protected_kvm_enabled() &&
+	    !is_pkvm_initialized())
+		return kvm_arm_event_notifier_register(&ffa_kvm_arm_event_notifier);
+
+	return __ffa_init();
 }
 device_initcall(ffa_init);

 static void __exit ffa_exit(void)
 {
+	if (IS_ENABLED(CONFIG_KVM))
+		kvm_arm_event_notifier_unregister(&ffa_kvm_arm_event_notifier);
 	ffa_notifications_cleanup();
 	ffa_partitions_cleanup();
 	ffa_rxtx_unmap();
diff --git a/drivers/firmware/arm_ffa/smccc.c b/drivers/firmware/arm_ffa/smccc.c
index 4d85bfff0a4e..e6125dd9f58f 100644
--- a/drivers/firmware/arm_ffa/smccc.c
+++ b/drivers/firmware/arm_ffa/smccc.c
@@ -17,7 +17,7 @@ static void __arm_ffa_fn_hvc(ffa_value_t args, ffa_value_t *res)
 	arm_smccc_1_2_hvc(&args, res);
 }

-int __init ffa_transport_init(ffa_fn **invoke_ffa_fn)
+int ffa_transport_init(ffa_fn **invoke_ffa_fn)
 {
 	enum arm_smccc_conduit conduit;


> --
> Jazz isn't dead. It just smells funny.

--
Sincerely,
Yeoreum Yun
