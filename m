From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v12 07/21] KVM: ARM64: PMU: Add perf event map and introduce
 perf event creating function
Date: Wed, 24 Feb 2016 09:27:43 +0800
Message-ID: <56CD070F.7070603@huawei.com>
References: <1456133877-9584-1-git-send-email-zhaoshenglong@huawei.com> <1456133877-9584-8-git-send-email-zhaoshenglong@huawei.com> <56CC9A12.6040001@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56CC9A12.6040001@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/2/24 1:42, Marc Zyngier wrote:
> Hi Shannon,
> 
> Still picking up on details...
> 
> On 22/02/16 09:37, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> When we use tools like perf on host, perf passes the event type and the
>> id of this event type category to kernel, then kernel will map them to
>> hardware event number and write this number to PMU PMEVTYPER<n>_EL0
>> register. When getting the event number in KVM, directly use raw event
>> type to create a perf_event for it.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/perf_event.h |   2 +
>>  arch/arm64/kvm/Makefile             |   1 +
>>  include/kvm/arm_pmu.h               |  12 ++++
>>  virt/kvm/arm/pmu.c                  | 122 ++++++++++++++++++++++++++++++++++++
>>  4 files changed, 137 insertions(+)
>>  create mode 100644 virt/kvm/arm/pmu.c
>>
>> diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
>> index 5c77ef8..867140d 100644
>> --- a/arch/arm64/include/asm/perf_event.h
>> +++ b/arch/arm64/include/asm/perf_event.h
>> @@ -29,6 +29,8 @@
>>  #define ARMV8_PMU_PMCR_D	(1 << 3) /* CCNT counts every 64th cpu cycle */
>>  #define ARMV8_PMU_PMCR_X	(1 << 4) /* Export to ETM */
>>  #define ARMV8_PMU_PMCR_DP	(1 << 5) /* Disable CCNT if non-invasive debug*/
>> +/* Determines which bit of PMCCNTR_EL0 generates an overflow */
>> +#define ARMV8_PMU_PMCR_LC	(1 << 6)
> 
> nit: this #define is only being used in patch #14. Consider moving it
> there...
> 
Sure, thanks!

-- 
Shannon

