Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C61B541E69;
	Thu, 15 Oct 2026 16:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792083091; cv=none; b=XEykL1y0eDKIZOIjt1MDo596qHaDu9MFPyCuQxWc9EzHicIZXVIyqg84/tUy8cpAOjOcMfAYAHCrSTV+HNbAYfhj3wMDZFXCDH8yqTSQVUlJbzo+Y3RkRK8PWEe8NPU9zUIUEMed2SMhXc6/b1WOFdgKqrD72+yGpZCh4RP6AVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792083091; c=relaxed/simple;
	bh=HqHAKSUflfJEuWDf3yfMWcVi+U+gd9V1CDIxtFqq64g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NWgWBqqF6wnPrbUSGiRbopTtjddqjJLgN/sWVffUsftdOIHu1f4bt5GkxmO5ytkDzPQMjNrV+PSxAf1bLD2Y8x7xd/jFvrF27WAvG3fnIMiQn/nmzwM9/10WJAS/BXIHUBYM93vVqeJvosT7TnH6a+4vr8vOgGBdFvlFP0JuyAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=al6Y5sUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="al6Y5sUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB301F000C4;
	Thu, 15 Oct 2026 16:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792083069;
	bh=Lxxs/l5FI+u++wAMNQ2C0hH42rvX2oaiszt8AMAtoAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=al6Y5sUteWg7nKjtYumnCaEp7yxwUz08QBxSgIqmF2qdXLDHBbz6iRZzEpZqNedey
	 XLeaPRJj4fvAsbm2AgFeu9oJM6AytbwGYXyG92aczhT/YHwpRwaguUdP9EwB7fW016
	 x3G0QnGd0Zv9cUra5EgykP8fDO3PWz046AUPfWdSTG+ihOcSx2qfkMmF4SUozc+Xmk
	 WOYi8+cS9pMc35j/I3xtbwtehDK2S7rBk0u1FPfilTXrxYzgEJDYTQuEmX/U9abkIx
	 kk2//vMNApRWuEvlq4YlAMtRmNR4SlPIIPoKIl9qF5wXQs4wK8b0Kg61tLkZcd4bjr
	 iFdz374dNvEWA==
Date: Thu, 15 Oct 2026 17:51:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 06/28] KVM: arm64: Add KVM_CAP_ARM_SPE capability
Message-ID: <atDtheEuNRs7v3Gx@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-7-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-7-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:01PM +0100, Alexandru Elisei wrote:
> Add the SPE capability that will be used by userspace to test if KVM
> supports SPE virtualization.

You are also adding spe.c too right? Which is adding functionality for the
perf driver to call into? Probably worth mentioning that you're adding the
foundations of this stuff in the commit message also.

>
> The SPE driver supports heterogenous systems. Keep track of all the
> available Statistical Profiling Units (SPUs) in the system, because KVM
> will require the user to associate a VM with exactly one SPU.

I guess questions more for my understanding here :)

Is it one SPU per core, or is it some property of heterogenous systems,
i.e. 1 per big/LITTLE etc.?

How can a user decide which? Do you actually expose the ability to select a
named SPU, or is it automatically determined based upon which CPUs are used
by the VM?

What if a VM spans both 'big' and 'LITTLE' cores?

>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  Documentation/virt/kvm/api.rst   | 10 ++++++
>  arch/arm64/include/asm/kvm_spe.h | 18 ++++++++++
>  arch/arm64/kvm/Makefile          |  1 +
>  arch/arm64/kvm/arm.c             |  4 +++
>  arch/arm64/kvm/spe.c             | 56 ++++++++++++++++++++++++++++++++
>  drivers/perf/arm_spe_pmu.c       |  4 +++
>  include/linux/perf/arm_spe_pmu.h | 12 +++++++

The KVM arm MAINTAINERS entry has:

F:	arch/arm64/kvm/
F:	include/kvm/arm_*

So arch/arm64/kvm/spe.c and include/linux/perf/arm_spe_pmu.h don't need any
updates there.

>  include/uapi/linux/kvm.h         |  1 +
>  8 files changed, 106 insertions(+)
>  create mode 100644 arch/arm64/include/asm/kvm_spe.h
>  create mode 100644 arch/arm64/kvm/spe.c
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index e0430cc750c9..1ed5c389c7a4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -9600,6 +9600,16 @@ take care to differentiate between these cases.
>  The presence of this capability indicates that the nested KVM guest can
>  start in ESA mode.
>
> +8.48 KVM_CAP_ARM_SPE
> +--------------------
> +
> +:Capability: KVM_CAP_ARM_SPE
> +:Architectures: arm64
> +:Type: vm
> +
> +This capability indicates that Statistical Profiling Extension (SPE)
> +virtualization is available in KVM.

Is it worth adding something here about the perf driver? As this seems key
to the thing. Or is that too much of an implementation detail?

> +
>  9. Known KVM API problems
>  =========================
>
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> new file mode 100644
> index 000000000000..f05e6d3f5705
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2021 - ARM Ltd
> + */
> +
> +#ifndef __ARM64_KVM_SPE_H__
> +#define __ARM64_KVM_SPE_H__
> +
> +#ifdef CONFIG_KVM_ARM_SPE
> +bool kvm_supports_spe(void);
> +#else
> +static __always_inline bool kvm_supports_spe(void)

Very nitty, but not sure if __always_inline is strictly necessary, you'd hope
that the compiler would naturally inline a false on optimisation :)

> +{
> +	return false;
> +}
> +#endif /* CONFIG_KVM_ARM_SPE */
> +
> +#endif /* __ARM64_KVM_SPE_H__ */
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 59612d2f277c..9ee271f713cd 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -29,6 +29,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>  kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
>  kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
> +kvm-$(CONFIG_KVM_ARM_SPE)     += spe.o
>
>  kvm-$(CONFIG_NVHE_EL2_TRACING) += hyp_trace.o
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90..eca1184ef9dd 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -42,6 +42,7 @@
>  #include <asm/kvm_nested.h>
>  #include <asm/kvm_pkvm.h>
>  #include <asm/kvm_ptrauth.h>
> +#include <asm/kvm_spe.h>
>  #include <asm/sections.h>
>  #include <asm/stacktrace/nvhe.h>
>
> @@ -468,6 +469,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_PMU_V3_STRICT:
>  		r = kvm_supports_guest_pmuv3();
>  		break;
> +	case KVM_CAP_ARM_SPE:
> +		r = kvm_supports_spe();
> +		break;
>  	case KVM_CAP_ARM_INJECT_SERROR_ESR:
>  		r = cpus_have_final_cap(ARM64_HAS_RAS_EXTN);
>  		break;
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> new file mode 100644
> index 000000000000..646806a60d66
> --- /dev/null
> +++ b/arch/arm64/kvm/spe.c
> @@ -0,0 +1,56 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021 - ARM Ltd
> + */
> +
> +#include <linux/cpumask.h>
> +#include <linux/kvm_host.h>
> +#include <linux/perf/arm_spe_pmu.h>
> +
> +#include <asm/kvm_spe.h>
> +#include <asm/sysreg.h>

NIT: include <linux/cleanup.h> for guard(mutex)() etc.?

> +
> +static LIST_HEAD(spe_pmus);
> +static DEFINE_MUTEX(spe_pmus_lock);
> +
> +struct spe_pmu_entry {
> +	struct list_head link;
> +	struct arm_spe_pmu *spe_pmu;
> +};

This seems like an odd way of making this into a list, can't you just embed
list_head in arm_spe_pmu?

Then adding becomes:

list_add_tail(&spe_pmu->link, &spu_pmus);

And removing:

list_del(&spe_pmu->link);

And you can avoid the alloc below too.


> +
> +void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu)

Hmm I'm guessing this is per-SPU but no mention of SPU in the function
name? Is an 'SPE instance' equivalent?

If so, maybe worth referencing SPE instances rather than SPUs in the commit
message, or at least say something like 'otherwise known as SPE instances'.

> +{
> +	struct spe_pmu_entry *entry;
> +
> +	guard(mutex)(&spe_pmus_lock);
> +
> +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);

The convention is kmalloc_obj() now. Which also lets you elide GFP_KERNEL
so this can be:

	entry = kmalloc_obj(*entry);

> +	if (!entry)
> +		return;

Hmm, shouldn't failing to allocate here be an error, or at least a warning?

> +
> +	entry->spe_pmu = spe_pmu;
> +	list_add_tail(&entry->link, &spe_pmus);
> +}
> +EXPORT_SYMBOL_FOR_MODULES(kvm_spe_add_instance, "arm_spe_pmu");
> +
> +void kvm_spe_remove_instance(struct arm_spe_pmu *spe_pmu)
> +{
> +	struct spe_pmu_entry *entry, *tmp;
> +
> +	guard(mutex)(&spe_pmus_lock);
> +
> +	list_for_each_entry_safe(entry, tmp, &spe_pmus, link) {

You break once you find the entry, so doesn't have to be the _safe variant.

But can avoid all the complexity with an embedded list_head in the spe_pmu
type if it's possible to put it there!

> +		if (entry->spe_pmu == spe_pmu) {
> +			list_del(&entry->link);
> +			kfree(entry);
> +			break;
> +		}
> +	}
> +}
> +EXPORT_SYMBOL_FOR_MODULES(kvm_spe_remove_instance, "arm_spe_pmu");
> +
> +bool kvm_supports_spe(void)
> +{
> +	guard(mutex)(&spe_pmus_lock);
> +	return !list_empty(&spe_pmus);
> +}
> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> index 42ba0924bd02..f24b122a087c 100644
> --- a/drivers/perf/arm_spe_pmu.c
> +++ b/drivers/perf/arm_spe_pmu.c
> @@ -1370,6 +1370,8 @@ static int arm_spe_pmu_device_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto out_teardown_dev;
>
> +	kvm_spe_add_instance(spe_pmu);
> +
>  	return 0;
>
>  out_teardown_dev:
> @@ -1383,6 +1385,8 @@ static void arm_spe_pmu_device_remove(struct platform_device *pdev)
>  {
>  	struct arm_spe_pmu *spe_pmu = platform_get_drvdata(pdev);
>
> +	kvm_spe_remove_instance(spe_pmu);
> +
>  	arm_spe_pmu_perf_destroy(spe_pmu);
>  	arm_spe_pmu_dev_teardown(spe_pmu);
>  	free_percpu(spe_pmu->handle);
> diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
> index 97b14e236fcd..bdb703558a87 100644
> --- a/include/linux/perf/arm_spe_pmu.h
> +++ b/include/linux/perf/arm_spe_pmu.h
> @@ -49,4 +49,16 @@ struct arm_spe_pmu {
>
>  #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
>
> +#ifdef CONFIG_KVM_ARM_SPE
> +void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu);
> +void kvm_spe_remove_instance(struct arm_spe_pmu *spe_pmu);
> +#else
> +static inline void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu)
> +{
> +}
> +static inline void kvm_spe_remove_instance(struct arm_spe_pmu *spe_pmu)
> +{
> +}
> +#endif /* CONFIG_KVM_ARM_SPE */
> +
>  #endif /* __PERF_ARM_SPE_PMU_H__ */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ac2d77d14963..1565a609890b 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -999,6 +999,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_S390_HPAGE_2G 249
>  #define KVM_CAP_PPC_COMPAT_CAPS 250
>  #define KVM_CAP_ARM_PMU_V3_STRICT 251
> +#define KVM_CAP_ARM_SPE 252
>
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
