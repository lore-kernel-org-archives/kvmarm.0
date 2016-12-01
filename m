From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 2/4] arm: Add PMU test
Date: Thu, 1 Dec 2016 11:28:47 +0000
Message-ID: <369668b9-d158-45dd-562d-cf25cdaaa749@arm.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-3-git-send-email-wei@redhat.com>
 <20161201090303.6vdo7iqlj2lfqqvv@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161201090303.6vdo7iqlj2lfqqvv@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>
Cc: cov@codeaurora.org, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 01/12/16 09:03, Andrew Jones wrote:
> On Wed, Nov 30, 2016 at 11:16:40PM -0600, Wei Huang wrote:
>> From: Christopher Covington <cov@codeaurora.org>
>>
>> Beginning with a simple sanity check of the control register, add
>> a unit test for the ARM Performance Monitors Unit (PMU). PMU register
>> was read using the newly defined macros.
>>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>> Signed-off-by: Wei Huang <wei@redhat.com>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>> ---
>>  arm/Makefile.common |  3 ++-
>>  arm/pmu.c           | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg   |  5 +++++
>>  3 files changed, 69 insertions(+), 1 deletion(-)
>>  create mode 100644 arm/pmu.c
>>
>> diff --git a/arm/Makefile.common b/arm/Makefile.common
>> index f37b5c2..5da2fdd 100644
>> --- a/arm/Makefile.common
>> +++ b/arm/Makefile.common
>> @@ -12,7 +12,8 @@ endif
>>  tests-common = \
>>  	$(TEST_DIR)/selftest.flat \
>>  	$(TEST_DIR)/spinlock-test.flat \
>> -	$(TEST_DIR)/pci-test.flat
>> +	$(TEST_DIR)/pci-test.flat \
>> +	$(TEST_DIR)/pmu.flat
>>  
>>  all: test_cases
>>  
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> new file mode 100644
>> index 0000000..1fe2b1a
>> --- /dev/null
>> +++ b/arm/pmu.c
>> @@ -0,0 +1,62 @@
>> +/*
>> + * Test the ARM Performance Monitors Unit (PMU).
>> + *
>> + * Copyright (c) 2015-2016, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU Lesser General Public License version 2.1 and
>> + * only version 2.1 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
>> + * for more details.
>> + */
>> +#include "libcflat.h"
>> +#include "asm/barrier.h"
>> +#include "asm/processor.h"
>> +
>> +#define PMU_PMCR_N_SHIFT   11
>> +#define PMU_PMCR_N_MASK    0x1f
>> +#define PMU_PMCR_ID_SHIFT  16
>> +#define PMU_PMCR_ID_MASK   0xff
>> +#define PMU_PMCR_IMP_SHIFT 24
>> +#define PMU_PMCR_IMP_MASK  0xff
>> +
>> +#if defined(__arm__)
>> +DEFINE_GET_SYSREG32(pmcr, 0, c9, c12, 0)
>> +#elif defined(__aarch64__)
>> +DEFINE_GET_SYSREG32(pmcr, el0)
>> +#endif
>> +
>> +/*
>> + * As a simple sanity check on the PMCR_EL0, ensure the implementer field isn't
>> + * null. Also print out a couple other interesting fields for diagnostic
>> + * purposes. For example, as of fall 2016, QEMU TCG mode doesn't implement
>> + * event counters and therefore reports zero event counters, but hopefully
>> + * support for at least the instructions event will be added in the future and
>> + * the reported number of event counters will become nonzero.
>> + */
>> +static bool check_pmcr(void)
>> +{
>> +	uint32_t pmcr;
> 
> So based on my comments from the previous patch, pmcr should be
> 'unsigned int'

I don't think so. At least here as a _variable_ type uint32_t is
probably the right one, as the ARMv8 ARM explicitly says that PMCR is a
32-bit register, for both bitnesses. I find it only natural to express
it here accordingly.
I believe this is a different (though related) discussion from the
return type of the accessor functions.

Cheers,
Andre.

>> +
>> +	pmcr = get_pmcr();
>> +
>> +	report_info("PMU implementer/ID code/counters: 0x%x(\"%c\")/0x%x/%d",
>> +		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
>> +		    ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
>> +		    (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK,
>> +		    (pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK);
>> +
>> +	return ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) != 0;
>> +}
>> +
>> +int main(void)
>> +{
>> +	report_prefix_push("pmu");
>> +
>> +	report("Control register", check_pmcr());
>> +
>> +	return report_summary();
>> +}
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index ae32a42..816f494 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -58,3 +58,8 @@ groups = selftest
>>  [pci-test]
>>  file = pci-test.flat
>>  groups = pci
>> +
>> +# Test PMU support
>> +[pmu]
>> +file = pmu.flat
>> +groups = pmu
>> -- 
>> 1.8.3.1
>>
>>
> 
> drew 
> 
