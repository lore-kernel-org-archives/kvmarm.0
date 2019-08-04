Return-Path: <SRS0=Parr=WA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3650C41517
	for <kvmarm@archiver.kernel.org>; Sun,  4 Aug 2019 09:54:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D1A8206C1
	for <kvmarm@archiver.kernel.org>; Sun,  4 Aug 2019 09:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D1A8206C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74F644A525;
	Sun,  4 Aug 2019 05:54:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VevrofOAIW5Q; Sun,  4 Aug 2019 05:54:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45C774A54D;
	Sun,  4 Aug 2019 05:54:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A100F4A563
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Aug 2019 05:54:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IH1wRrSBlzt9 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  4 Aug 2019 05:54:11 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19C0A4A525
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Aug 2019 05:54:11 -0400 (EDT)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why)
 by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
 (Exim 4.80) (envelope-from <maz@kernel.org>)
 id 1huDDA-0003Vy-Mt; Sun, 04 Aug 2019 11:53:59 +0200
Date: Sun, 4 Aug 2019 10:53:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH 9/9] arm64: Retrieve stolen time as paravirtualized guest
Message-ID: <20190804105353.5e9824dc@why>
In-Reply-To: <20190802145017.42543-10-steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-10-steven.price@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com,
 pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk,
 will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri,  2 Aug 2019 15:50:17 +0100
Steven Price <steven.price@arm.com> wrote:

> Enable paravirtualization features when running under a hypervisor
> supporting the PV_TIME_ST hypercall.
> 
> For each (v)CPU, we ask the hypervisor for the location of a shared
> page which the hypervisor will use to report stolen time to us. We set
> pv_time_ops to the stolen time function which simply reads the stolen
> value from the shared page for a VCPU. We guarantee single-copy
> atomicity using READ_ONCE which means we can also read the stolen
> time for another VCPU than the currently running one while it is
> potentially being updated by the hypervisor.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kernel/Makefile |   1 +
>  arch/arm64/kernel/kvm.c    | 155 +++++++++++++++++++++++++++++++++++++

nit: Why not using paravirt.c, which clearly states what it does? The
alternative would be to name it kvm-pv.c.

>  include/linux/cpuhotplug.h |   1 +
>  3 files changed, 157 insertions(+)
>  create mode 100644 arch/arm64/kernel/kvm.c
> 
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 478491f07b4f..eb36edf9b930 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -63,6 +63,7 @@ obj-$(CONFIG_CRASH_CORE)		+= crash_core.o
>  obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
>  obj-$(CONFIG_ARM64_SSBD)		+= ssbd.o
>  obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
> +obj-$(CONFIG_PARAVIRT)			+= kvm.o
>  
>  obj-y					+= vdso/ probes/
>  obj-$(CONFIG_COMPAT_VDSO)		+= vdso32/
> diff --git a/arch/arm64/kernel/kvm.c b/arch/arm64/kernel/kvm.c
> new file mode 100644
> index 000000000000..245398c79dae
> --- /dev/null
> +++ b/arch/arm64/kernel/kvm.c
> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2019 Arm Ltd.
> +
> +#define pr_fmt(fmt) "kvmarm-pv: " fmt
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/cpuhotplug.h>
> +#include <linux/io.h>
> +#include <linux/printk.h>
> +#include <linux/psci.h>
> +#include <linux/reboot.h>
> +#include <linux/slab.h>
> +
> +#include <asm/paravirt.h>
> +#include <asm/pvclock-abi.h>
> +#include <asm/smp_plat.h>
> +
> +struct kvmarm_stolen_time_region {
> +	struct pvclock_vcpu_stolen_time_info *kaddr;
> +};
> +
> +static DEFINE_PER_CPU(struct kvmarm_stolen_time_region, stolen_time_region);
> +
> +static bool steal_acc = true;
> +static int __init parse_no_stealacc(char *arg)
> +{
> +	steal_acc = false;
> +	return 0;
> +}
> +early_param("no-steal-acc", parse_no_stealacc);
> +
> +/* return stolen time in ns by asking the hypervisor */
> +static u64 kvm_steal_clock(int cpu)
> +{
> +	struct kvmarm_stolen_time_region *reg;
> +
> +	reg = per_cpu_ptr(&stolen_time_region, cpu);
> +	if (!reg->kaddr) {
> +		pr_warn_once("stolen time enabled but not configured for cpu %d\n",
> +			     cpu);
> +		return 0;
> +	}
> +
> +	return le64_to_cpu(READ_ONCE(reg->kaddr->stolen_time));
> +}
> +
> +static int disable_stolen_time_current_cpu(void)
> +{
> +	struct kvmarm_stolen_time_region *reg;
> +
> +	reg = this_cpu_ptr(&stolen_time_region);
> +	if (!reg->kaddr)
> +		return 0;
> +
> +	memunmap(reg->kaddr);
> +	memset(reg, 0, sizeof(*reg));
> +
> +	return 0;
> +}
> +
> +static int stolen_time_dying_cpu(unsigned int cpu)
> +{
> +	return disable_stolen_time_current_cpu();
> +}
> +
> +static int init_stolen_time_cpu(unsigned int cpu)
> +{
> +	struct kvmarm_stolen_time_region *reg;
> +	struct arm_smccc_res res;
> +
> +	reg = this_cpu_ptr(&stolen_time_region);
> +
> +	if (reg->kaddr)
> +		return 0;

Can this actually happen? It'd take two CPU_UP calls from the HP
notifiers to get in that situation...

> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_TIME_ST, &res);
> +
> +	if ((long)res.a0 < 0)
> +		return -EINVAL;
> +
> +	reg->kaddr = memremap(res.a0,
> +			sizeof(struct pvclock_vcpu_stolen_time_info),
> +			MEMREMAP_WB);
> +
> +	if (reg->kaddr == NULL) {
> +		pr_warn("Failed to map stolen time data structure\n");
> +		return -EINVAL;

-ENOMEM is the expected return code.

> +	}
> +
> +	if (le32_to_cpu(reg->kaddr->revision) != 0 ||
> +			le32_to_cpu(reg->kaddr->attributes) != 0) {
> +		pr_warn("Unexpected revision or attributes in stolen time data\n");
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int kvm_arm_init_stolen_time(void)
> +{
> +	int ret;
> +
> +	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVMPV_STARTING,
> +				"hypervisor/kvmarm/pv:starting",
> +				init_stolen_time_cpu, stolen_time_dying_cpu);
> +	if (ret < 0)
> +		return ret;
> +	return 0;
> +}
> +
> +static bool has_kvm_steal_clock(void)
> +{
> +	struct arm_smccc_res res;
> +
> +	/* To detect the presence of PV time support we require SMCCC 1.1+ */
> +	if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
> +		return false;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> +			     ARM_SMCCC_HV_PV_FEATURES, &res);
> +
> +	if (res.a0 != SMCCC_RET_SUCCESS)
> +		return false;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_FEATURES,
> +			     ARM_SMCCC_HV_PV_TIME_ST, &res);
> +
> +	if (res.a0 != SMCCC_RET_SUCCESS)
> +		return false;
> +
> +	return true;
> +}
> +
> +static int __init kvm_guest_init(void)
> +{
> +	int ret = 0;
> +
> +	if (!has_kvm_steal_clock())
> +		return 0;
> +
> +	ret = kvm_arm_init_stolen_time();
> +	if (ret)
> +		return ret;
> +
> +	pv_ops.time.steal_clock = kvm_steal_clock;
> +
> +	static_key_slow_inc(&paravirt_steal_enabled);
> +	if (steal_acc)
> +		static_key_slow_inc(&paravirt_steal_rq_enabled);
> +
> +	pr_info("using stolen time PV\n");
> +
> +	return 0;
> +}
> +early_initcall(kvm_guest_init);

Is there any reason why we wouldn't directly call into this rather than
using an initcall?

> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 068793a619ca..89d75edb5750 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -136,6 +136,7 @@ enum cpuhp_state {
>  	/* Must be the last timer callback */
>  	CPUHP_AP_DUMMY_TIMER_STARTING,
>  	CPUHP_AP_ARM_XEN_STARTING,
> +	CPUHP_AP_ARM_KVMPV_STARTING,
>  	CPUHP_AP_ARM_CORESIGHT_STARTING,
>  	CPUHP_AP_ARM64_ISNDEP_STARTING,
>  	CPUHP_AP_SMPCFD_DYING,


Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
