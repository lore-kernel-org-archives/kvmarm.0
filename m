From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 20/23] arm64: perf: Count EL2 events if the kernel is
 running in HYP
Date: Fri, 5 Feb 2016 09:02:39 +0000
Message-ID: <56B4652F.4030407@arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-21-git-send-email-marc.zyngier@arm.com>
 <20160204192301.GG13974@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3F014965E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 03:57:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i6IYaoTjgt74 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2016 03:57:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE4BA48529
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 03:57:10 -0500 (EST)
In-Reply-To: <20160204192301.GG13974@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/02/16 19:23, Christoffer Dall wrote:
> On Wed, Feb 03, 2016 at 06:00:13PM +0000, Marc Zyngier wrote:
>> When the kernel is running in HYP (with VHE), it is necessary to
>> include EL2 events if the user requests counting kernel or
>> hypervisor events.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kernel/perf_event.c | 14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
>> index f7ab14c..6013a38 100644
>> --- a/arch/arm64/kernel/perf_event.c
>> +++ b/arch/arm64/kernel/perf_event.c
>> @@ -20,6 +20,7 @@
>>   */
>>  
>>  #include <asm/irq_regs.h>
>> +#include <asm/virt.h>
>>  
>>  #include <linux/of.h>
>>  #include <linux/perf/arm_pmu.h>
>> @@ -693,10 +694,15 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>>  		return -EPERM;
>>  	if (attr->exclude_user)
>>  		config_base |= ARMV8_EXCLUDE_EL0;
>> -	if (attr->exclude_kernel)
>> -		config_base |= ARMV8_EXCLUDE_EL1;
>> -	if (!attr->exclude_hv)
>> -		config_base |= ARMV8_INCLUDE_EL2;
>> +	if (is_kernel_in_hyp_mode()) {
>> +		if (!attr->exclude_kernel || !attr->exclude_hv)
>> +			config_base |= ARMV8_INCLUDE_EL2;
> 
> is exclude_hv a perf generic construct?

Yes. It seems to be universally used on all architectures.

> is it really correct to count everything the host kernel does (even
> unrelated to running VMs) when counting hypervisor events?

With VHE, the roles are blurred, and the PMU can only count events
occurring when at a given exception level. It has no notion of context.

> Other than my ignorance in this area, this patch looks fine to me.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
