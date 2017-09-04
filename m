From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 1/7] arm64: cpufeature: Detect CPU RAS Extentions
Date: Mon, 4 Sep 2017 19:20:26 +0800
Message-ID: <4271bbe8-fc99-c213-55b2-2171985a81dd@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-2-git-send-email-gengdongjiu@huawei.com>
 <59A84AF5.3000104@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <59A84AF5.3000104@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

James,

On 2017/9/1 1:44, James Morse wrote:
> Hi Dongjiu Geng,
> 
> On 28/08/17 11:38, Dongjiu Geng wrote:
>> From: Xie XiuQi <xiexiuqi@huawei.com>
>>
>> ARM's v8.2 Extentions add support for Reliability, Availability and
>> Serviceability (RAS). On CPUs with these extensions system software
>> can use additional barriers to isolate errors and determine if faults
>> are pending.
>>
>> Add cpufeature detection and a barrier in the context-switch code.
>> There is no need to use alternatives for this as CPUs that don't
>> support this feature will treat the instruction as a nop.
>>
>> Platform level RAS support may require additional firmware support.
>>
>> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
>> [Rebased, added esb and config option, reworded commit message]
>> Signed-off-by: James Morse <james.morse@arm.com>
> 
> Nit: when re-posting patches from the list you need to add your signed-off-by.
> See Documentation/process/submitting-patches.rst 'Developer's Certificate of
> Origin 1.1'
Ok, thanks for the your pointing out.

> 
> This goes for your patch 2 as well.
> 
> 
>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index c845c8c04d95..7a17b4a1bd9e 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -370,6 +370,9 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
>>  	 */
>>  	dsb(ish);
>>  
>> +	/* Deliver any pending SError from prev */
>> +	esb();
>> +
> 
> This patch was sitting on top of the SError rework. As the cover-letter
> describes that was all there to make sure SError is unmasked when we execute
> this esb(). Without it any pending SError will be deferred, its ESR is written
> to DISR_EL1, which this patch doesn't check.
> 
> On its own, this patch is actively harmful to systems that don't have
> firmware-first handling.
> 
> We probably need to produce a combined series...
OK, thanks for your reminder and detailed explanation.


> 
> 
> Thanks,
> 
> James
> 
> 
> .
> 

