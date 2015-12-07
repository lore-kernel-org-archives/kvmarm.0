From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 02/21] KVM: ARM64: Define PMU data structure for each
 vcpu
Date: Mon, 07 Dec 2015 16:42:59 +0000
Message-ID: <5665B713.3020900@arm.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com> <1449123091-20252-3-git-send-email-zhaoshenglong@huawei.com> <5665A026.8000802@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5665A026.8000802@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/15 15:05, Marc Zyngier wrote:
> On 03/12/15 06:11, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> Here we plan to support virtual PMU for guest by full software
>> emulation, so define some basic structs and functions preparing for
>> futher steps. Define struct kvm_pmc for performance monitor counter and
>> struct kvm_pmu for performance monitor unit for each vcpu. According to
>> ARMv8 spec, the PMU contains at most 32(ARMV8_MAX_COUNTERS) counters.
>>
>> Since this only supports ARM64 (or PMUv3), add a separate config symbol
>> for it.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>  arch/arm64/include/asm/kvm_host.h |  2 ++
>>  arch/arm64/kvm/Kconfig            |  8 ++++++++
>>  include/kvm/arm_pmu.h             | 41 +++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 51 insertions(+)
>>  create mode 100644 include/kvm/arm_pmu.h
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index a35ce72..42e15bb 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -37,6 +37,7 @@
>>  
>>  #include <kvm/arm_vgic.h>
>>  #include <kvm/arm_arch_timer.h>
>> +#include <kvm/arm_pmu.h>
>>  
>>  #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>>  
>> @@ -132,6 +133,7 @@ struct kvm_vcpu_arch {
>>  	/* VGIC state */
>>  	struct vgic_cpu vgic_cpu;
>>  	struct arch_timer_cpu timer_cpu;
>> +	struct kvm_pmu pmu;
>>  
>>  	/*
>>  	 * Anything that is not used directly from assembly code goes
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index a5272c0..66da9a2 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -36,6 +36,7 @@ config KVM
>>  	select HAVE_KVM_EVENTFD
>>  	select HAVE_KVM_IRQFD
>>  	select KVM_ARM_VGIC_V3
>> +	select KVM_ARM_PMU
>>  	---help---
>>  	  Support hosting virtualized guest machines.
>>  	  We don't support KVM with 16K page tables yet, due to the multiple
>> @@ -48,6 +49,13 @@ config KVM_ARM_HOST
>>  	---help---
>>  	  Provides host support for ARM processors.
>>  
>> +config KVM_ARM_PMU
>> +	bool
>> +	depends on KVM_ARM_HOST && HW_PERF_EVENTS
>> +	---help---
>> +	  Adds support for a virtual Performance Monitoring Unit (PMU) in
>> +	  virtual machines.
>> +
>>  source drivers/vhost/Kconfig
>>  
>>  endif # VIRTUALIZATION
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> new file mode 100644
>> index 0000000..0c13470
>> --- /dev/null
>> +++ b/include/kvm/arm_pmu.h
>> @@ -0,0 +1,41 @@
>> +/*
>> + * Copyright (C) 2015 Linaro Ltd.
>> + * Author: Shannon Zhao <shannon.zhao@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef __ASM_ARM_KVM_PMU_H
>> +#define __ASM_ARM_KVM_PMU_H
>> +
>> +#include <linux/perf_event.h>
>> +#ifdef CONFIG_KVM_ARM_PMU
>> +#include <asm/pmu.h>
>> +#endif
>> +
>> +struct kvm_pmc {
>> +	u8 idx;/* index into the pmu->pmc array */
>> +	struct perf_event *perf_event;
>> +	struct kvm_vcpu *vcpu;
> 
> Why do you need this? If you have the pointer to a kvm_pmc structure, it
> is very cheap to compute the address of the vcpu:
> 
> static inline kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> {
> 	struct kvm_pmu *pmu;
> 	pmc -= pmc->idx;
> 	pmu = container_of(pmc, struct kvm_pmu, pmc);
> 	return container_of(pmu, struct kvm_vcpu, pmu);
> }
> 
> All of which the compiler will happily optimize for you.

FWIW, actually compiling code looks something like this:

static inline struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
{
	struct kvm_pmu *pmu;
	struct kvm_vcpu_arch *vcpu_arch;

	pmc -= pmc->idx;
	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
	return container_of(vcpu_arch, struct kvm_vcpu, arch);
}

which amounts to 4 sub instructions.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
