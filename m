From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 02/11] ACPI / APEI: Generalise the estatus queue's
 add/remove and notify code
Date: Fri, 23 Feb 2018 18:21:31 +0000
Message-ID: <5A905BAB.2060007@arm.com>
References: <20180215185606.26736-1-james.morse@arm.com>	<20180215185606.26736-3-james.morse@arm.com>
 <87sh9vzfdn.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <87sh9vzfdn.fsf@e105922-lin.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, linux-arm-kernel@lists.infradead.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Punit,

On 20/02/18 18:26, Punit Agrawal wrote:
> James Morse <james.morse@arm.com> writes:
> 
>> To support asynchronous NMI-like notifications on arm64 we need to use
>> the estatus-queue. These patches refactor it to allow multiple APEI
>> notification types to use it.
>>
>> Refactor the estatus queue's pool grow/shrink code and notification
>> routine from NOTIFY_NMI's handlers. This will allow another notification
>> method to use the estatus queue without duplicating this code.
>>
>> This patch adds rcu_read_lock()/rcu_read_unlock() around the list
>> list_for_each_entry_rcu() walker. These aren't strictly necessary as
>> the whole nmi_enter/nmi_exit() window is a spooky RCU read-side
>> critical section.
>>
>> Keep the oops_begin() call for x86, arm64 doesn't have one of these,
>> and APEI is the only thing outside arch code calling this..
>>
>> The existing ghes_estatus_pool_shrink() is folded into the new
>> ghes_estatus_queue_shrink_pool() as only the queue uses it.
>>
>> _in_nmi_notify_one() is separate from the rcu-list walker for a later
>> caller that doesn't need to walk a list.

>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index e42b587c509b..d3cc5bd5b496 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -749,6 +749,54 @@ static void __process_error(struct ghes *ghes)
>>  #endif
>>  }
>>  
>> +static int _in_nmi_notify_one(struct ghes *ghes)
>> +{
>> +	int sev;
>> +	int ret = -ENOENT;
> 
> If ret is initialised to 0 ...
> 
>> +
>> +	if (ghes_read_estatus(ghes, 1)) {
>> +		ghes_clear_estatus(ghes);
>> +		return ret;
> 
> and return -ENOENT here...
> 
>> +	} else {
>> +		ret = 0;
>> +	}
> 
> ... then the else block can be dropped.


Good point, this happened because I was trying to keep the same shape as the
existing notify_nmi() code as far as possible.


>> +
>> +	sev = ghes_severity(ghes->estatus->error_severity);
>> +	if (sev >= GHES_SEV_PANIC) {
>> +#ifdef CONFIG_X86
>> +		oops_begin();
>> +#endif
> 
> Can you use IS_ENABLED() here as well?

I didn't think that would build without an empty declaration for arm64, I
assumed it would generate an implicit-declaration-of warning. But, I've tried
it, and evidently today's toolchain does dead-code elimination before generating
implicit-declaration-of warnings...
I'd prefer to leave this (ugly as it is), to avoid warnings on a different
version of the compiler.


Thanks,

James
