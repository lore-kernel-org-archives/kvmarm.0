Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8F5387575
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 15:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768835330; cv=none; b=FlVjCwlt2PqDgCsIlyUgPS/eSv1GDtXMmnPlIiWhAa7E84rB1325/8lhD34rZfTqrMbd9qItaaSJPu4ghMrWzdv0rvXnlzl+j/vzGZ06cBIrlPPlpnw/tWEPwly5i2xVHZhsKlrYh9oU/YeIEgLjd7eSagRqxA4Yszcshk5MCWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768835330; c=relaxed/simple;
	bh=xugPr6e+WZrQiUS8zZy97VjXXVu+D+zkl4XKFVu7PEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UM1HmTqvo8+8nMjJVhNmJIEnNtopN9nbwsu3J6rI1o1pbE5vbS91+x2VAoLA8kggy4rTxnr8KJktdt38ynTflK5osrVFztCtzTchX7itoALtqYzRnasu9Kx2/j4uvio7Gxj8s79JoVDGopw9TqOejPHm5WDG3GV8f1Vg7MiHJJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E5C8497;
	Mon, 19 Jan 2026 07:08:39 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CACF3F694;
	Mon, 19 Jan 2026 07:08:41 -0800 (PST)
Message-ID: <1389bd4b-494c-42da-84bf-89d0055e2d16@arm.com>
Date: Mon, 19 Jan 2026 15:08:39 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/47] arm64: mpam: Add cpu_pm notifier to restore MPAM
 sysregs
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
 <20260112165914.4086692-10-ben.horgan@arm.com>
 <5c79d642-cd95-4c6b-9eeb-bd055719ca91@redhat.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <5c79d642-cd95-4c6b-9eeb-bd055719ca91@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 1/19/26 06:50, Gavin Shan wrote:
> Hi Ben,
> 
> On 1/13/26 12:58 AM, Ben Horgan wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> The MPAM system registers will be lost if the CPU is reset during PSCI's
>> CPU_SUSPEND.
>>
>> Add a PM notifier to restore them.
>>
>> mpam_thread_switch(current) can't be used as this won't make any
>> changes if
>> the in-memory copy says the register already has the correct value. In
>> reality the system register is UNKNOWN out of reset.
>>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>>   arch/arm64/kernel/mpam.c | 30 ++++++++++++++++++++++++++++++
>>   1 file changed, 30 insertions(+)
>>
> 
> One question below...
> 
>> diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
>> index e6feff2324ac..dbe0a2d05abb 100644
>> --- a/arch/arm64/kernel/mpam.c
>> +++ b/arch/arm64/kernel/mpam.c
>> @@ -4,6 +4,7 @@
>>   #include <asm/mpam.h>
>>     #include <linux/arm_mpam.h>
>> +#include <linux/cpu_pm.h>
>>   #include <linux/jump_label.h>
>>   #include <linux/percpu.h>
>>   @@ -13,12 +14,41 @@ DEFINE_PER_CPU(u64, arm64_mpam_current);
>>     u64 arm64_mpam_global_default;
>>   +static int mpam_pm_notifier(struct notifier_block *self,
>> +                unsigned long cmd, void *v)
>> +{
>> +    u64 regval;
>> +    int cpu = smp_processor_id();
>> +
>> +    switch (cmd) {
>> +    case CPU_PM_EXIT:
>> +        /*
>> +         * Don't use mpam_thread_switch() as the system register
>> +         * value has changed under our feet.
>> +         */
>> +        regval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
>> +        write_sysreg_s(regval, SYS_MPAM1_EL1);
>> +        isb();
>> +
>> +        write_sysreg_s(regval, SYS_MPAM0_EL1);
>> +
>> +        return NOTIFY_OK;
>> +    default:
>> +        return NOTIFY_DONE;
>> +    }
>> +}
>> +
>> +static struct notifier_block mpam_pm_nb = {
>> +    .notifier_call = mpam_pm_notifier,
>> +};
>> +
>>   static int __init arm64_mpam_register_cpus(void)
>>   {
>>       u64 mpamidr = read_sanitised_ftr_reg(SYS_MPAMIDR_EL1);
>>       u16 partid_max = FIELD_GET(MPAMIDR_EL1_PARTID_MAX, mpamidr);
>>       u8 pmg_max = FIELD_GET(MPAMIDR_EL1_PMG_MAX, mpamidr);
>>   +    cpu_pm_register_notifier(&mpam_pm_nb);
> 
> Need we ensure MPAM capability exists in the hardware before the
> notifier is registerred?
> Otherwise, mpam_pm_notifier() can accesses SYS_MPAM0_EL1 and
> SYS_MPAM1_EL1 system registers
> which may not supported by the hardware.

Ah yes, I'll add a system_supports_mpam() check here.

> 
>>       return mpam_register_requestor(partid_max, pmg_max);
>>   }
>>   /* Must occur before mpam_msc_driver_init() from subsys_initcall() */
> 
> Thanks,
> Gavin
> 

Thanks,

Ben

