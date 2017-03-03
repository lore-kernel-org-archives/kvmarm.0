From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 1/2] arm/arm64: Add PSCI tests
Date: Fri, 3 Mar 2017 15:19:12 +0100
Message-ID: <20170303141911.GA23831@potion>
References: <20170227173208.14854-1-drjones@redhat.com>
 <20170227173208.14854-2-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E48240A74
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Mar 2017 09:18:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0w6PNV8DcjuJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Mar 2017 09:18:02 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23B3E40A63
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Mar 2017 09:18:01 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170227173208.14854-2-drjones@redhat.com>
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
Cc: Levente Kurusa <lkurusa@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

2017-02-27 18:32+0100, Andrew Jones:
> From: Levente Kurusa <lkurusa@redhat.com>
> 
> The cpu_on test exposed two races in KVM's PSCI emulation.
> 
> Signed-off-by: Levente Kurusa <lkurusa@redhat.com>
> [Rewrote the cpu_on test to improve the chance of hitting the race.
>  Also added affinity-info tests and made some minor cleanups. -drew]
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/Makefile.common |   1 +
>  arm/psci.c          | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg   |   6 +++
>  3 files changed, 119 insertions(+)
>  create mode 100644 arm/psci.c
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index f7193c3e6d64..74c7394eb7c1 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -14,6 +14,7 @@ tests-common += $(TEST_DIR)/spinlock-test.flat
>  tests-common += $(TEST_DIR)/pci-test.flat
>  tests-common += $(TEST_DIR)/pmu.flat
>  tests-common += $(TEST_DIR)/gic.flat
> +tests-common += $(TEST_DIR)/psci.flat
>  
>  tests-all = $(tests-common) $(tests)
>  all: $(tests-all)
> diff --git a/arm/psci.c b/arm/psci.c
> new file mode 100644
> index 000000000000..e571afb92c7e
> --- /dev/null
> +++ b/arm/psci.c
> @@ -0,0 +1,112 @@
> +/*
> + * PSCI tests
> + *
> + * Copyright (C) 2017, Red Hat, Inc.
> + * Author: Levente Kurusa <lkurusa@redhat.com>
> + * Author: Andrew Jones <drjones@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <libcflat.h>
> +#include <asm/smp.h>
> +#include <asm/psci.h>
> +
> +static bool psci_invalid_function(void)
> +{
> +	return psci_invoke(1337, 0, 0, 0) == PSCI_RET_NOT_SUPPORTED;
> +}
> +
> +static int psci_affinity_info(unsigned long target_affinity, uint32_t lowest_affinity_level)
> +{
> +#ifdef __arm__
> +	return psci_invoke(PSCI_0_2_FN_AFFINITY_INFO, target_affinity, lowest_affinity_level, 0);
> +#else
> +	return psci_invoke(PSCI_0_2_FN64_AFFINITY_INFO, target_affinity, lowest_affinity_level, 0);
> +#endif
> +}
> +
> +static bool psci_affinity_info_on(void)
> +{
> +	return psci_affinity_info(cpus[0], 0) == PSCI_0_2_AFFINITY_LEVEL_ON;
> +}
> +
> +static bool psci_affinity_info_off(void)
> +{
> +	return psci_affinity_info(cpus[1], 0) == PSCI_0_2_AFFINITY_LEVEL_OFF;

Please check that smp > 1 here

> +}
> +
> +static int cpu_on_ret[NR_CPUS];
> +static cpumask_t cpu_on_ready, cpu_on_done;
> +static volatile int cpu_on_start;
> +
> +static void cpu_on_secondary_entry(void)
> +{
> +	int cpu = smp_processor_id();
> +
> +	cpumask_set_cpu(cpu, &cpu_on_ready);
> +	while (!cpu_on_start)
> +		cpu_relax();
> +	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(halt));
> +	cpumask_set_cpu(cpu, &cpu_on_done);
> +	halt();
> +}
> +
> +static bool psci_cpu_on_test(void)
> +{
> +	bool failed = false;
> +	int cpu;

and here too.

Thanks.
