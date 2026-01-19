Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCCC3612EA
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768837754; cv=none; b=eWi2SNq9Ep2INM43rPP+nWslzp8YbQ1MtgeVnVrbVN2yEtLq7SraTBtPu9Q1cHaoDlf+KYC9lmlNdCsL014KEmzw0vKV+n7A3/if8tlbvC4gGP6l0qcGYKwA2Of+s1Ep7Qe0oGCzct3vKueFxxjUZGBix8rvlsVfeFfBMyIdx10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768837754; c=relaxed/simple;
	bh=VsMuGxZCEzmxbo4QGjmxWPDX3WL57Yk7hKYyVMqAt/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OyFdf3Loj5Q3ZGXxRfhZS/XPD/L5quQvwy5ur17FaZsQL+d1YdF6/bm7vw2ZKsvOcMrv7ST9xpii5hmB+QpSTsfdFeyUjo6WmjZ/8RtbaNu9bZU/3tSIPorSbaZyL4inm9uljF9R4tEQAWMGrZSgg94088SzDsIJ9jNi9Mz4Ktg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 322B1FEC;
	Mon, 19 Jan 2026 07:49:05 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2FA93F694;
	Mon, 19 Jan 2026 07:49:06 -0800 (PST)
Message-ID: <a48e749d-fdeb-4306-9324-0f62fc72b589@arm.com>
Date: Mon, 19 Jan 2026 15:49:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/47] arm64: mpam: Add helpers to change a task or
 cpu's MPAM PARTID/PMG values
To: Gavin Shan <gshan@redhat.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-12-ben.horgan@arm.com>
 <57a015c3-9a4b-478b-8cb6-6c61f84c0b74@redhat.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <57a015c3-9a4b-478b-8cb6-6c61f84c0b74@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 1/19/26 07:01, Gavin Shan wrote:
> Hi Ben,
> 
> On 1/13/26 12:58 AM, Ben Horgan wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> Care must be taken when modifying the PARTID and PMG of a task in any
>> per-task structure as writing these values may race with the task being
>> scheduled in, and reading the modified values.
>>
>> Add helpers to set the task properties, and the CPU default value.  These
>> use WRITE_ONCE() that pairs with the READ_ONCE() in mpam_get_regval() to
>> avoid causing torn values.
>>
>> CC: Dave Martin <Dave.Martin@arm.com>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since rfc:
>> Keep comment attached to mpam_get_regval()
>> Add internal helper, __mpam_regval() (Jonathan)
>> ---
>>   arch/arm64/include/asm/mpam.h | 28 ++++++++++++++++++++++++++++
>>   1 file changed, 28 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/
>> mpam.h
>> index 7b3d3abad162..c9b73f1af7ce 100644
>> --- a/arch/arm64/include/asm/mpam.h
>> +++ b/arch/arm64/include/asm/mpam.h
>> @@ -4,6 +4,7 @@
>>   #ifndef __ASM__MPAM_H
>>   #define __ASM__MPAM_H
>>   +#include <linux/bitfield.h>
>>   #include <linux/jump_label.h>
>>   #include <linux/percpu.h>
>>   #include <linux/sched.h>
>> @@ -22,6 +23,22 @@ DECLARE_PER_CPU(u64, arm64_mpam_current);
>>    */
>>   extern u64 arm64_mpam_global_default;
>>   +static inline u64 __mpam_regval(u16 partid_d, u16 partid_i, u8
>> pmg_d, u8 pmg_i)
>> +{
>> +    return FIELD_PREP(MPAM0_EL1_PARTID_D, partid_d) |
>> +        FIELD_PREP(MPAM0_EL1_PARTID_I, partid_i) |
>> +        FIELD_PREP(MPAM0_EL1_PMG_D, pmg_d) |
>> +        FIELD_PREP(MPAM0_EL1_PMG_I, pmg_i);
>> +}
> 
> Nitpick: Alignment issues in the lines for 2nd/3rd/4th FIELD_PREP().
> 
>     return FIELD_PREP(...) |
>            FIELD_PREP(...) |
>                FIELD_PREP(...) |
>                FIELD_PREP(...);

Sure, I'll align these.

> 
>> +
>> +static inline void mpam_set_cpu_defaults(int cpu, u16 partid_d, u16
>> partid_i,
>> +                     u8 pmg_d, u8 pmg_i)
>> +{
>> +    u64 default_val = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
>> +
>> +    WRITE_ONCE(per_cpu(arm64_mpam_default, cpu), default_val);
>> +}
>> +
> 
> per_cpu(arm64_mpam_default) won't be reachable until CONFIG_ARM64_MPAM
> is set.
> So I think both mpam_set_cpu_defaults() and __mpam_regval() need to be
> protected
> by '#ifdef CONFIG_ARM64_MPAM ... #endif'.

I'll move the #ifdef CONFIG_ARM64_MPAM up to cover these.

> 
>>   /*
>>    * The resctrl filesystem writes to the partid/pmg values for
>> threads and CPUs,
>>    * which may race with reads in mpam_thread_switch(). Ensure only
>> one of the old
>> @@ -36,6 +53,17 @@ static inline u64 mpam_get_regval(struct
>> task_struct *tsk)
>>       return READ_ONCE(task_thread_info(tsk)->mpam_partid_pmg);
>>   }
>>   +static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
>> +                        u16 partid_d, u16 partid_i,
>> +                        u8 pmg_d, u8 pmg_i)
>> +{
>> +#ifdef CONFIG_ARM64_MPAM
>> +    u64 regval = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
>> +
>> +    WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
>> +#endif
>> +}
>> +
>>   static inline void mpam_thread_switch(struct task_struct *tsk)
>>   {
>>       u64 oldregval;
> 
> Thanks,
> Gavin
> 

Thanks,

Ben

