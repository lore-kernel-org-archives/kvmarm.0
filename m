Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512173590DC
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 09:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767951458; cv=none; b=ZfB5rzIMIze3db1ceVB33O3kDUQ0TZ6at/XdCsgHonMfxXuybTwEUbDI7P4sf8BCJCrel1C49lzIo5ju0NrvJqmae1ZbsbwwS2WuFN15/RLRv+zAj2Mxg9O3bIXMIv2fEeCEqbzK/6GuGRxD9p7/Ui0IZCSbE89uogGrNYDnbAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767951458; c=relaxed/simple;
	bh=5GwKXguCVQ5SO3AjXktjwV1RqhgrBo8UtTaYWHtVwys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IX56MQMpQ2QdgBmY2HqV7VpSYy2TujMeRI5rMuW2erc4Y+AztivpJKcDs3r6NfQYGLG/xctyZxT3n5k+V258CQBk34S7zPeuTg+soSfIjbCeOtQjQMtjrRMtXweMl11a+RxY1nTd8zLnKEn6xv4TQ9cl07GzdnvCFZ2Boabx6AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F223B497;
	Fri,  9 Jan 2026 01:37:29 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEC643F6A8;
	Fri,  9 Jan 2026 01:37:30 -0800 (PST)
Message-ID: <8929c30b-9220-42f9-9a04-db414919a36f@arm.com>
Date: Fri, 9 Jan 2026 09:37:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/45] arm64: mpam: Add helpers to change a task or
 cpu's MPAM PARTID/PMG values
To: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>
Cc: "amitsinght@marvell.com" <amitsinght@marvell.com>,
 "baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
 "dave.martin@arm.com" <dave.martin@arm.com>,
 "david@kernel.org" <david@kernel.org>,
 "dfustini@baylibre.com" <dfustini@baylibre.com>,
 "fenghuay@nvidia.com" <fenghuay@nvidia.com>,
 "gshan@redhat.com" <gshan@redhat.com>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
 "kobak@nvidia.com" <kobak@nvidia.com>,
 "lcherian@marvell.com" <lcherian@marvell.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "punit.agrawal@oss.qualcomm.com" <punit.agrawal@oss.qualcomm.com>,
 "quic_jiles@quicinc.com" <quic_jiles@quicinc.com>,
 "reinette.chatre@intel.com" <reinette.chatre@intel.com>,
 "rohit.mathew@arm.com" <rohit.mathew@arm.com>,
 "scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
 "sdonthineni@nvidia.com" <sdonthineni@nvidia.com>,
 "xhao@linux.alibaba.com" <xhao@linux.alibaba.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
 "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-13-ben.horgan@arm.com>
 <OSZPR01MB87982085E0E5B09D0FBB58208B85A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <OSZPR01MB87982085E0E5B09D0FBB58208B85A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaopeng,

On 1/8/26 10:18, Shaopeng Tan (Fujitsu) wrote:
> Hello  Ben,
> 
>> From: James Morse <james.morse@arm.com>
>>
>> Care must be taken when modifying the PARTID and PMG of a task in any
>> per-task structure as writing these values may race with the task being
>> scheduled in, and reading the modified values.
>>
>> Add helpers to set the task properties, and the CPU default value.  These
>> use WRITE_ONCE() that pairs with the READ_ONCE() in mpam_get_regval() to
>> avoid causing torn values.
>>
>> CC: Dave Martin <Dave.Martin@arm.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since rfc:
>> Keep comment attached to mpam_get_regval()
>> Add internal helper, __mpam_regval() (Jonathan)
>> ---
>>  arch/arm64/include/asm/mpam.h | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
>> index c4cb015e8d8f..a7fd0656bf90 100644
>> --- a/arch/arm64/include/asm/mpam.h
>> +++ b/arch/arm64/include/asm/mpam.h
>> @@ -4,6 +4,7 @@
>>  #ifndef __ASM__MPAM_H
>>  #define __ASM__MPAM_H
>>  
>> +#include <linux/bitfield.h>
>>  #include <linux/jump_label.h>
>>  #include <linux/percpu.h>
>>  #include <linux/sched.h>
>> @@ -22,6 +23,22 @@ DECLARE_PER_CPU(u64, arm64_mpam_current);
>>   */
>>  extern u64 arm64_mpam_global_default;
>>  
>> +static inline u64 __mpam_regval(u16 partid_d, u16 partid_i, u8 pmg_d, u8 pmg_i)
>> +{
>> +       return FIELD_PREP(MPAM0_EL1_PARTID_D, partid_d) |
>> +               FIELD_PREP(MPAM0_EL1_PARTID_I, partid_i) |
>> +               FIELD_PREP(MPAM0_EL1_PMG_D, pmg_d) |
>> +               FIELD_PREP(MPAM0_EL1_PMG_I, pmg_i);
>> +}
>> +
>> +static inline void mpam_set_cpu_defaults(int cpu, u16 partid_d, u16 partid_i,
>> +                                        u8 pmg_d, u8 pmg_i)
>> +{
>> +       u64 default_val = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
>> +
>> +       WRITE_ONCE(per_cpu(arm64_mpam_default, cpu), default_val);
>> +}
>> +
>>  /*
>>   * The resctrl filesystem writes to the partid/pmg values for threads and CPUs,
>>   * which may race with reads in mpam_thread_switch(). Ensure only one of the old
>> @@ -45,6 +62,17 @@ static inline u64 mpam_get_regval(struct task_struct *tsk)
>>  #endif
>>  }
>>  
>> +static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
>> +                                           u16 partid_d, u16 partid_i,
>> +                                           u8 pmg_d, u8 pmg_i)
>> +{
>> +#ifdef CONFIG_ARM64_MPAM
> 
> Since `mpam_set_task_partid_pmg()` is only called from MPAM, is this necessary?

Yes because mpam_partid_pmg only exists when CONFIG_ARM64_MPAM is enabled.

> 
> Best regards,
> Shaopeng TAN
> 
>> +       u64 regval = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
>> +
>> +       WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
>> +#endif
>> +}
>> +
>>  static inline void mpam_thread_switch(struct task_struct *tsk)
>>  {
>>          u64 oldregval;
>> --
>> 2.43.0

Thanks,

Ben

