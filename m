Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794497665;
	b=Lxk0L3HgQ86eYSmipA/nKpXDRAV1uQqDca57ToPgLBq12Vmoahzh7ilhaVsU54b6yuXL
	 A5BGTpFI/w6qOKIClWQSSYgueMU6yy0SbdtE+DAb4+F+Hl0KFdKvIo3CdsoPX9XKVqjPi
	 X8+kuOZQBBpAUWJOzk/HHEoeUxEbreB8zyACBzYjsuu30COVPpzcBW3dlO7Bs5LXDAKD1
	 MzlZer5OdIWmbnslGrUy9zMh9hHwvkPAblIlz/02OKsi1r/GewWDMl3fLM8+omu3JiefS
	 gnkznGmLr+LRjcAa/Sw+lCb6/M/Aw0lmqWKqZikfUSsJXmbG9+28y5ulZYZYaHRKbCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794497665;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=/J56hK+npGwUcYHlvvjnzB+Ql98rLiCDb+PVkIYFOG0=;
	b=jJiRoENkqVNL7Shm4TlIT2kTeOCI0LsLPNdVI/l3fw76VxfBhBZHFdAFpk3Zlcmc85/0
	 VTwR9ffzTLEglUoeDAnh9TGBF2JdrQ0mSygTnyPzOK551W3pA0BkZu6ANJ5py6Fuh1j5T
	 mSQ6AvTrXwh4K7Y6k2Nq1zAU6BOZqWOkDLlaLIBwBUhMubLJE9G5zPzftftwIIW+yJ7cp
	 q3Hazvo7q0e5n2ND/JdlxP30HME6dKGBqegD7+h81gGpAu4d6OOcWwudhgXIRwzkCHQGX
	 RAK2SwICpX276N0t+9h5TT7dlHWL+HOc5M2039Yt4DFVeqWtzmEg6/wlB7F0lj/MeXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CjiLcwNS;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43759606A333
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 15:34:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43759606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CjiLcwNS
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C3CB1516;
	Thu, 12 Nov 2026 07:34:20 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34E7E3F632;
	Thu, 12 Nov 2026 07:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794497663; bh=v/5ba4HhdEKibvPby5qRUyDyDF/hjUFrNiHj+mQAZkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CjiLcwNSF67aeSiSWGY8jDgobhA1YG49NCsh+PlIuuOlyspq9gf2vIK2Lfx6O58jl
	 7DXzsnZvyjV/uOHKovMgmrZFr3bo5JQQhpD5LoTfYwQEUKWEpqozc5DreMdXL06A7T
	 pANlEd4o5qvv6E5kQUvszpo9fc2drKpxqUvcApvY=
Date: Thu, 12 Nov 2026 15:34:15 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, will@kernel.org, mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org, catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: Re: [RFC PATCH v7 06/28] KVM: arm64: Add KVM_CAP_ARM_SPE capability
Message-ID: <avXcdwY89YPFGIlk@raptor>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-7-alexandru.elisei@arm.com>
 <atDtheEuNRs7v3Gx@gremlin>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atDtheEuNRs7v3Gx@gremlin>

Hi Lorenzo,

On Thu, Oct 15, 2026 at 05:51:03PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 03, 2026 at 05:06:01PM +0100, Alexandru Elisei wrote:
> > Add the SPE capability that will be used by userspace to test if KVM
> > supports SPE virtualization.
> 
> You are also adding spe.c too right? Which is adding functionality for the
> perf driver to call into? Probably worth mentioning that you're adding the
> foundations of this stuff in the commit message also.

Done.

> 
> >
> > The SPE driver supports heterogenous systems. Keep track of all the
> > available Statistical Profiling Units (SPUs) in the system, because KVM
> > will require the user to associate a VM with exactly one SPU.
> 
> I guess questions more for my understanding here :)
> 
> Is it one SPU per core, or is it some property of heterogenous systems,
> i.e. 1 per big/LITTLE etc.?

Usually one per CPU cluster/group: in a homogeneous CPU, one instance; in a
CPU with big cores and little cores, there would be two SPE instances; in a
CPU with big, medium and little, three instances. I'm sure it's possible to
come up with more exotic configurations.

The SPE driver supports this partitioning only with device tree, not with
ACPI (for now, there's a series on the mailing list to fix this) and it
looks at the ppi-partitions node to determine which CPUs are associated
with each SPE instance. The node is described in
Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml.

For example, look at arch/arm64/boot/dts/rockchip/rk3399-base.dtsi, at the
PMU (not SPE) nodes: there's pmu_a53, associated with ppi_cluster0, which
is interrupt-partition-0, and it includes CPUs cpu_l0 to cpu_l3 (I assume
'l' here stands for 'little'). Then there's also pmu_a72, associated with
ppi_cluster1, which includes CPUs cpu_b0 and cpu_b1 (where 'b' is probably
'big').

If SPE were supported by all the cores, there would have been two
instances: spe_a53, associated with ppi_cluster0, and spe_a72, associated
with ppi_cluster1. If SPE were supported only on the big cores, there would
have been one instance, spe_a72 associated with ppi_cluster1 (naming is
obviously not set in stone, that's just an example).

I think I know what you're going to say and you are right: yes, there are
no device tree files for heterogeneous systems with SPE. Supporting this
type of systems was requested by Will Deacon, the SPE driver maintainer,
because the SPE driver supports them.

> 
> How can a user decide which? Do you actually expose the ability to select a
> named SPU, or is it automatically determined based upon which CPUs are used
> by the VM?

All SPE instances are exposed in /sys/bus/event_source/devices. This is an
example for an Orion O6 board (with ACPI and the driver hacked to make it
probe successfully):

$ ls /sys/bus/event_source/devices/
total 0
lrwxrwxrwx 1 root root 0 Nov 12  2026 arm_spe_0 -> ../../../devices/platform/arm,spe-v1/arm_spe_0/
lrwxrwxrwx 1 root root 0 Nov 12  2026 armv8_pmuv3_0 -> ../../../devices/armv8_pmuv3_0/
lrwxrwxrwx 1 root root 0 Nov 12  2026 armv8_pmuv3_1 -> ../../../devices/armv8_pmuv3_1/
lrwxrwxrwx 1 root root 0 Nov 12  2026 breakpoint -> ../../../devices/breakpoint/
lrwxrwxrwx 1 root root 0 Nov 12  2026 kprobe -> ../../../devices/kprobe/
lrwxrwxrwx 1 root root 0 Nov 12  2026 software -> ../../../devices/software/
lrwxrwxrwx 1 root root 0 Nov 12  2026 tracepoint -> ../../../devices/tracepoint/
lrwxrwxrwx 1 root root 0 Nov 12  2026 uprobe -> ../../../devices/uprobe/

Notice how there are two PMU instances, but only one SPE instances, that's
because not all CPUs have SPE.

It's up to the user to configure which one the VM uses - see patch #13 in
the series, "KVM: arm64: Add SPE VCPU device attribute to set the SPE
device". As for an example implementation, the user specifies on which
physical CPUs the VM runs, and from there kvmtool finds the SPE instance
that includes those CPUs. See my kvmtool patches [0], namely
spe__init() -> find_pmu() [1] and what find_pmu() does [2].

Having KVM trying to guess what userspace wants sounds frought with danger
to me.

Two different SPE instances cannot be used interchangeably, because A. they
might be totally different implementations (different versions of SPE,
different implemented registers, different events, etc), and even if they
are in theory the same, the events they are recording might have different
semantics across different CPU clusters. For example, Cortex-A53 is in
in-order, Cortex-A72 is out-of-order. How is the guest going to make sense
of any record relating to speculation, and how is the guest going to know
which record was for an instruction sampled on which core?

[0] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/commit/d93b287acad184be48118448fa8b2c7ae6cae249
[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/blob/kvm-spe-v7/arm64/spe.c#L111
[2] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/blob/kvm-spe-v7/arm64/pmu.c#L195

> 
> What if a VM spans both 'big' and 'LITTLE' cores?

I think you might have answered that yourself, judging from your subsequent
comments :) Similar to the PMU, KVM will not allow that, and a VCPU will
exit with KVM_EXIT_FAIL_ENTRY if it's scheduled on a physical CPU that is
not part of the cluser that belongs to the SPE instance assigned to the VM.

In general, even if KVM might allow the user to create a VM with VCPUs with
mismatched features, this is not supported and it will almost definitely
blow up at some point. At least, that was the stance of the KVM maintainer
a few years ago, when KVM_ARM_VCPU_PMU_V3_SET_PMU was added.

> 
> >
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  Documentation/virt/kvm/api.rst   | 10 ++++++
> >  arch/arm64/include/asm/kvm_spe.h | 18 ++++++++++
> >  arch/arm64/kvm/Makefile          |  1 +
> >  arch/arm64/kvm/arm.c             |  4 +++
> >  arch/arm64/kvm/spe.c             | 56 ++++++++++++++++++++++++++++++++
> >  drivers/perf/arm_spe_pmu.c       |  4 +++
> >  include/linux/perf/arm_spe_pmu.h | 12 +++++++
> 
> The KVM arm MAINTAINERS entry has:
> 
> F:	arch/arm64/kvm/
> F:	include/kvm/arm_*
> 
> So arch/arm64/kvm/spe.c and include/linux/perf/arm_spe_pmu.h don't need any
> updates there.
> 
> >  include/uapi/linux/kvm.h         |  1 +
> >  8 files changed, 106 insertions(+)
> >  create mode 100644 arch/arm64/include/asm/kvm_spe.h
> >  create mode 100644 arch/arm64/kvm/spe.c
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index e0430cc750c9..1ed5c389c7a4 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -9600,6 +9600,16 @@ take care to differentiate between these cases.
> >  The presence of this capability indicates that the nested KVM guest can
> >  start in ESA mode.
> >
> > +8.48 KVM_CAP_ARM_SPE
> > +--------------------
> > +
> > +:Capability: KVM_CAP_ARM_SPE
> > +:Architectures: arm64
> > +:Type: vm
> > +
> > +This capability indicates that Statistical Profiling Extension (SPE)
> > +virtualization is available in KVM.
> 
> Is it worth adding something here about the perf driver? As this seems key
> to the thing. Or is that too much of an implementation detail?

I'll add something, because I don't think the dependency is obvious.

> 
> > +
> >  9. Known KVM API problems
> >  =========================
> >
> > diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> > new file mode 100644
> > index 000000000000..f05e6d3f5705
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/kvm_spe.h
> > @@ -0,0 +1,18 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright (C) 2021 - ARM Ltd
> > + */
> > +
> > +#ifndef __ARM64_KVM_SPE_H__
> > +#define __ARM64_KVM_SPE_H__
> > +
> > +#ifdef CONFIG_KVM_ARM_SPE
> > +bool kvm_supports_spe(void);
> > +#else
> > +static __always_inline bool kvm_supports_spe(void)
> 
> Very nitty, but not sure if __always_inline is strictly necessary, you'd hope
> that the compiler would naturally inline a false on optimisation :)

I think that's an artifact from an earlier iteration, when it was called
from the hyp object, which is a different namespace than the rest of the
kernel and the __always_inline was required to make sure the function was
copied at the call sites.

I'll remove.

> 
> > +{
> > +	return false;
> > +}
> > +#endif /* CONFIG_KVM_ARM_SPE */
> > +
> > +#endif /* __ARM64_KVM_SPE_H__ */
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index 59612d2f277c..9ee271f713cd 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -29,6 +29,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
> >  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
> >  kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
> >  kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
> > +kvm-$(CONFIG_KVM_ARM_SPE)     += spe.o
> >
> >  kvm-$(CONFIG_NVHE_EL2_TRACING) += hyp_trace.o
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 8b080804bc90..eca1184ef9dd 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -42,6 +42,7 @@
> >  #include <asm/kvm_nested.h>
> >  #include <asm/kvm_pkvm.h>
> >  #include <asm/kvm_ptrauth.h>
> > +#include <asm/kvm_spe.h>
> >  #include <asm/sections.h>
> >  #include <asm/stacktrace/nvhe.h>
> >
> > @@ -468,6 +469,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	case KVM_CAP_ARM_PMU_V3_STRICT:
> >  		r = kvm_supports_guest_pmuv3();
> >  		break;
> > +	case KVM_CAP_ARM_SPE:
> > +		r = kvm_supports_spe();
> > +		break;
> >  	case KVM_CAP_ARM_INJECT_SERROR_ESR:
> >  		r = cpus_have_final_cap(ARM64_HAS_RAS_EXTN);
> >  		break;
> > diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> > new file mode 100644
> > index 000000000000..646806a60d66
> > --- /dev/null
> > +++ b/arch/arm64/kvm/spe.c
> > @@ -0,0 +1,56 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2021 - ARM Ltd
> > + */
> > +
> > +#include <linux/cpumask.h>
> > +#include <linux/kvm_host.h>
> > +#include <linux/perf/arm_spe_pmu.h>
> > +
> > +#include <asm/kvm_spe.h>
> > +#include <asm/sysreg.h>
> 
> NIT: include <linux/cleanup.h> for guard(mutex)() etc.?

Ok.

> 
> > +
> > +static LIST_HEAD(spe_pmus);
> > +static DEFINE_MUTEX(spe_pmus_lock);
> > +
> > +struct spe_pmu_entry {
> > +	struct list_head link;
> > +	struct arm_spe_pmu *spe_pmu;
> > +};
> 
> This seems like an odd way of making this into a list, can't you just embed
> list_head in arm_spe_pmu?
> 
> Then adding becomes:
> 
> list_add_tail(&spe_pmu->link, &spu_pmus);
> 
> And removing:
> 
> list_del(&spe_pmu->link);
> 
> And you can avoid the alloc below too.

This is the same pattern used for the PMU. Seems like a small thing, so I
think consistency is better? I don't expect more than three SPE instances
in a system (little + medium + big), so the extra 3 * 8 bytes should not be
an issue?

On the other hand, it is indeed more common to embed list_head in struct
arm_spe_pmu. Up to you what you prefer.

> 
> 
> > +
> > +void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu)
> 
> Hmm I'm guessing this is per-SPU but no mention of SPU in the function
> name? Is an 'SPE instance' equivalent?

Yes, they are equivalent, my bad for not explaining it properly.

> 
> If so, maybe worth referencing SPE instances rather than SPUs in the commit
> message, or at least say something like 'otherwise known as SPE instances'.

Indeed, done.

> 
> > +{
> > +	struct spe_pmu_entry *entry;
> > +
> > +	guard(mutex)(&spe_pmus_lock);
> > +
> > +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> 
> The convention is kmalloc_obj() now. Which also lets you elide GFP_KERNEL
> so this can be:

Done.

> 
> 	entry = kmalloc_obj(*entry);
> 
> > +	if (!entry)
> > +		return;
> 
> Hmm, shouldn't failing to allocate here be an error, or at least a warning?

I don't think it's something that should cause the probe to fail. I could
add a warning, I guess, to let the user know why KVM_CAP_ARM_SPE is missing
even though the SPE module was loaded successfully.

> 
> > +
> > +	entry->spe_pmu = spe_pmu;
> > +	list_add_tail(&entry->link, &spe_pmus);
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(kvm_spe_add_instance, "arm_spe_pmu");
> > +
> > +void kvm_spe_remove_instance(struct arm_spe_pmu *spe_pmu)
> > +{
> > +	struct spe_pmu_entry *entry, *tmp;
> > +
> > +	guard(mutex)(&spe_pmus_lock);
> > +
> > +	list_for_each_entry_safe(entry, tmp, &spe_pmus, link) {
> 
> You break once you find the entry, so doesn't have to be the _safe variant.

Hmm... in my head, the _safe variant was always associated with deletion,
and not having the safe variant might cause a bug, if in the future, the
body of the loop is modified and the break removed.

Do you strongly oppose to keeping the safe variant?

Thanks,
Alex

> 
> But can avoid all the complexity with an embedded list_head in the spe_pmu
> type if it's possible to put it there!
> 
> > +		if (entry->spe_pmu == spe_pmu) {
> > +			list_del(&entry->link);
> > +			kfree(entry);
> > +			break;
> > +		}
> > +	}
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(kvm_spe_remove_instance, "arm_spe_pmu");
> > +
> > +bool kvm_supports_spe(void)
> > +{
> > +	guard(mutex)(&spe_pmus_lock);
> > +	return !list_empty(&spe_pmus);
> > +}
> > diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> > index 42ba0924bd02..f24b122a087c 100644
> > --- a/drivers/perf/arm_spe_pmu.c
> > +++ b/drivers/perf/arm_spe_pmu.c
> > @@ -1370,6 +1370,8 @@ static int arm_spe_pmu_device_probe(struct platform_device *pdev)
> >  	if (ret)
> >  		goto out_teardown_dev;
> >
> > +	kvm_spe_add_instance(spe_pmu);
> > +
> >  	return 0;
> >
> >  out_teardown_dev:
> > @@ -1383,6 +1385,8 @@ static void arm_spe_pmu_device_remove(struct platform_device *pdev)
> >  {
> >  	struct arm_spe_pmu *spe_pmu = platform_get_drvdata(pdev);
> >
> > +	kvm_spe_remove_instance(spe_pmu);
> > +
> >  	arm_spe_pmu_perf_destroy(spe_pmu);
> >  	arm_spe_pmu_dev_teardown(spe_pmu);
> >  	free_percpu(spe_pmu->handle);
> > diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
> > index 97b14e236fcd..bdb703558a87 100644
> > --- a/include/linux/perf/arm_spe_pmu.h
> > +++ b/include/linux/perf/arm_spe_pmu.h
> > @@ -49,4 +49,16 @@ struct arm_spe_pmu {
> >
> >  #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
> >
> > +#ifdef CONFIG_KVM_ARM_SPE
> > +void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu);
> > +void kvm_spe_remove_instance(struct arm_spe_pmu *spe_pmu);
> > +#else
> > +static inline void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu)
> > +{
> > +}
> > +static inline void kvm_spe_remove_instance(struct arm_spe_pmu *spe_pmu)
> > +{
> > +}
> > +#endif /* CONFIG_KVM_ARM_SPE */
> > +
> >  #endif /* __PERF_ARM_SPE_PMU_H__ */
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index ac2d77d14963..1565a609890b 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -999,6 +999,7 @@ struct kvm_enable_cap {
> >  #define KVM_CAP_S390_HPAGE_2G 249
> >  #define KVM_CAP_PPC_COMPAT_CAPS 250
> >  #define KVM_CAP_ARM_PMU_V3_STRICT 251
> > +#define KVM_CAP_ARM_SPE 252
> >
> >  struct kvm_irq_routing_irqchip {
> >  	__u32 irqchip;
> > --
> > 2.43.0
> >
> >
> 
> --
> Cheers, Lorenzo
