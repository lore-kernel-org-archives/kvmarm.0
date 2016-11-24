From: Wei Huang <wei@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v11 1/3] arm: Add PMU test
Date: Wed, 23 Nov 2016 22:41:59 -0600
Message-ID: <6ab685c0-abee-bd61-70db-381591fee867@redhat.com>
References: <1479839354-22061-1-git-send-email-wei@redhat.com>
 <1479839354-22061-2-git-send-email-wei@redhat.com>
 <576a5d79-874a-e5fe-6a0d-7af2a3ea4d46@arm.com>
 <20161123171551.qfvdcxvys2pphzs3@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7111B40A1D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 23:41:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b5o4UbDo29lU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 23:41:25 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37D21409B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 23:41:24 -0500 (EST)
In-Reply-To: <20161123171551.qfvdcxvys2pphzs3@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Andre Przywara <andre.przywara@arm.com>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 11/23/2016 11:15 AM, Andrew Jones wrote:
> On Wed, Nov 23, 2016 at 01:16:08PM +0000, Andre Przywara wrote:
>> Hi,
>>
>> On 22/11/16 18:29, Wei Huang wrote:
>>> From: Christopher Covington <cov@codeaurora.org>
>>>
>>> Beginning with a simple sanity check of the control register, add
>>> a unit test for the ARM Performance Monitors Unit (PMU).
>>
>> Mmh, the output of this is a bit confusing. How about to join some
>> information? I changed it to give me:
>> INFO: pmu: PMU implementer/ID code:     "A"(0x41)/0x0
>> INFO: pmu: Event counters:      0
>> PASS: pmu: Control register
>>
>> ... by using the newly introduced report_info() to make it look nicer.
> 
> Agreed. That would look nicer and make good use of report_info. Let's
> do that.

I have adjusted v12 using report_info(), with all PMU PMCR fields
printed in the same line. Implementer info was printed with Hex first,
then ASCII representation, to match MIDR table in ARM manual:

INFO: pmu: PMU implementer/ID code/counters: 0x41("A")/0x1/6


> 
>>
>>>
>>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>>> Signed-off-by: Wei Huang <wei@redhat.com>
>>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>>> ---
>>>  arm/Makefile.common |  3 ++-
>>>  arm/pmu.c           | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  arm/unittests.cfg   |  5 ++++
>>>  3 files changed, 81 insertions(+), 1 deletion(-)
>>>  create mode 100644 arm/pmu.c
>>>
>>> diff --git a/arm/Makefile.common b/arm/Makefile.common
>>> index f37b5c2..5da2fdd 100644
>>> --- a/arm/Makefile.common
>>> +++ b/arm/Makefile.common
>>> @@ -12,7 +12,8 @@ endif
>>>  tests-common = \
>>>  	$(TEST_DIR)/selftest.flat \
>>>  	$(TEST_DIR)/spinlock-test.flat \
>>> -	$(TEST_DIR)/pci-test.flat
>>> +	$(TEST_DIR)/pci-test.flat \
>>> +	$(TEST_DIR)/pmu.flat
>>>  
>>>  all: test_cases
>>>  
>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>> new file mode 100644
>>> index 0000000..9d9c53b
>>> --- /dev/null
>>> +++ b/arm/pmu.c
>>> @@ -0,0 +1,74 @@
>>> +/*
>>> + * Test the ARM Performance Monitors Unit (PMU).
>>> + *
>>> + * Copyright (c) 2015-2016, The Linux Foundation. All rights reserved.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms of the GNU Lesser General Public License version 2.1 and
>>> + * only version 2.1 as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>>> + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
>>> + * for more details.
>>> + */
>>> +#include "libcflat.h"
>>> +#include "asm/barrier.h"
>>> +
>>> +#define PMU_PMCR_N_SHIFT   11
>>> +#define PMU_PMCR_N_MASK    0x1f
>>> +#define PMU_PMCR_ID_SHIFT  16
>>> +#define PMU_PMCR_ID_MASK   0xff
>>> +#define PMU_PMCR_IMP_SHIFT 24
>>> +#define PMU_PMCR_IMP_MASK  0xff
>>> +
>>> +#if defined(__arm__)
>>
>> I guess you should use the arch specific header files we have in place
>> for that (lib/arm{.64}/asm/processor.h). Also there are sysreg read
>> wrappers (at least for arm64) in there already, can't we base this
>> function on them: DEFINE_GET_SYSREG32(pmcr, el0)?
>> (Requires a small change to get rid of the forced "_el1" suffix)
>>
>> We should wait for the GIC series to be merged, as this contains some
>> changes in this area.
> 
> As this unit test is the only consumer of PMC registers so far, then
> I'd prefer the defines and accessors stay here for now. Once we see
> a use in other unit tests then we can move some of it out.

I left accessors in-place. We can always come back to refactor them later.

> 
>>
>>> +static inline uint32_t pmcr_read(void)
>>> +{
>>> +	uint32_t ret;
>>> +
>>> +	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
>>> +	return ret;
>>> +}
>>> +#elif defined(__aarch64__)
>>> +static inline uint32_t pmcr_read(void)
>>> +{
>>> +	uint32_t ret;
>>> +
>>> +	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
>>> +	return ret;
>>> +}
>>> +#endif
>>> +
>>> +/*
>>> + * As a simple sanity check on the PMCR_EL0, ensure the implementer field isn't
>>> + * null. Also print out a couple other interesting fields for diagnostic
>>> + * purposes. For example, as of fall 2016, QEMU TCG mode doesn't implement
>>> + * event counters and therefore reports zero event counters, but hopefully
>>> + * support for at least the instructions event will be added in the future and
>>> + * the reported number of event counters will become nonzero.
>>> + */
>>> +static bool check_pmcr(void)
>>> +{
>>> +	uint32_t pmcr;
>>> +
>>> +	pmcr = pmcr_read();
>>> +
>>> +	printf("PMU implementer:     %c\n",
>>> +	       (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK);
>>
>> If this register reads as zero, the output is mangled (since it cuts off
>> the string before the newline):
>> =====
>> PMU implementer:     Identification code: 0x0
>> =====
>>
>> I guess you need something like:
>> (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK ?: ' '
> 
> Good idea.

Done

> 
>>
>>> +	printf("Identification code: 0x%x\n",
>>> +	       (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK);
>>
>> As mentioned above this should use report_info() now, also it would be
>> nice to merge this with the message above into one line of output.
> 
> Agreed.

Done. I removed your name from Reviewed-by from Patch 1. You can ACK it
if ok.

> 
> Thanks,
> drew
> 
>>
>> Cheers,
>> Andre
>>
>>> +	printf("Event counters:      %d\n",
>>> +	       (pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK);
>>> +
>>> +	return ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) != 0;
>>> +}
>>> +
>>> +int main(void)
>>> +{
>>> +	report_prefix_push("pmu");
>>> +
>>> +	report("Control register", check_pmcr());
>>> +
>>> +	return report_summary();
>>> +}
>>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>>> index ae32a42..816f494 100644
>>> --- a/arm/unittests.cfg
>>> +++ b/arm/unittests.cfg
>>> @@ -58,3 +58,8 @@ groups = selftest
>>>  [pci-test]
>>>  file = pci-test.flat
>>>  groups = pci
>>> +
>>> +# Test PMU support
>>> +[pmu]
>>> +file = pmu.flat
>>> +groups = pmu
>>>
>>
