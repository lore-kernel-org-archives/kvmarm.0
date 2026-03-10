Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A8D38945E
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 11:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141982; cv=none; b=m9vuo8DoXuUWB8flzpfzP25rzgC6q+Cg9vjm6Ib3dmyzWnDjtmLp/O4E0EifTUplk9c4jj3SIO2SnufKogODMo2EyAU6vTaMLHyen6dYnrqa2m8J8TfNiAa6De+7CNrLBQaxaf7BIVvpZU6hr5BpxYmV99HJfgzWj+G7XjsOA+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141982; c=relaxed/simple;
	bh=cuADWZqQKNvKseVwYL9JPBSsPsGhSnsfCdEinofgcFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sTC6SRSleuoNrrLrkJKdp56UpaRDF0Esn58RqRVz9mj5IfpUEK3PneVuNcGrFcyXHzUOKP5DMmHfW5bLU9FMSgiGR/XKXXf3WhnKAA3jtVQRFoAaX4o5ypaRVAOzqRqQ1/eJAYDjvicPFaGTr2IoXieybI7x2uEXpUcrI2nxuxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82D44152B;
	Tue, 10 Mar 2026 04:26:12 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB4E53F73B;
	Tue, 10 Mar 2026 04:26:14 -0700 (PDT)
Message-ID: <6519a56f-b6cf-43dc-b34a-42123f6356f6@arm.com>
Date: Tue, 10 Mar 2026 11:26:13 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v5 38/41] arm_mpam: Add workaround for T241-MPAM-4
To: Fenghua Yu <fenghuay@nvidia.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 gshan@redhat.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-39-ben.horgan@arm.com>
 <7e496cb6-ab31-4a89-9630-0fa2e6b3607b@nvidia.com>
 <3e26371d-21b5-435e-9f31-7187466c57a2@arm.com>
 <2aa90f15-f2f0-45d7-9161-2ab08b4d00d4@nvidia.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <2aa90f15-f2f0-45d7-9161-2ab08b4d00d4@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Fenghua,

On 3/9/26 17:39, Fenghua Yu wrote:
> Hi, Ben,
> 
> On 3/2/26 09:11, Ben Horgan wrote:
>> Hi Fenghua,
>>
>> On 3/1/26 17:28, Fenghua Yu wrote:
>>> Hi, Ben,
>>>
>>> On 2/24/26 09:57, Ben Horgan wrote:
>>>> From: Shanker Donthineni <sdonthineni@nvidia.com>
>>>>
>>>> In the T241 implementation of memory-bandwidth partitioning, in the
>>>> absence
>>>> of contention for bandwidth, the minimum bandwidth setting can
>>>> affect the
>>>> amount of achieved bandwidth. Specifically, the achieved bandwidth
>>>> in the
>>>> absence of contention can settle to any value between the values of
>>>> MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.  Also, if MPAMCFG_MBW_MIN is set
>>>> zero (below 0.78125%), once a core enters a throttled state, it will
>>>> never
>>>> leave that state.
>>>>
>>>> The first issue is not a concern if the MPAM software allows to program
>>>> MPAMCFG_MBW_MIN through the sysfs interface. This patch ensures program
>>>> MBW_MIN=1 (0.78125%) whenever MPAMCFG_MBW_MIN=0 is programmed.
>>>>
>>>> In the scenario where the resctrl doesn't support the MBW_MIN
>>>> interface via
>>>> sysfs, to achieve bandwidth closer to MBW_MAX in the absence of
>>>> contention,
>>>> software should configure a relatively narrow gap between MBW_MIN and
>>>> MBW_MAX. The recommendation is to use a 5% gap to mitigate the problem.
>>>>
>>>> Clear the feature MBW_MIN feature from the class to ensure we don't
>>>> accidentally change behaviour when resctrl adds support for a MBW_MIN
>>>> interface.
>>>>
>>>> Tested-by: Gavin Shan <gshan@redhat.com>
>>>> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>>>> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>>>> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
>>>> Signed-off-by: James Morse <james.morse@arm.com>
>>>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>>>
>>> Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
>>>
>>> This patch itself is good.
>>>
>>> Please check the following comments.
>>>
>>>> ---
>>>> [ morse: Added as second quirk, adapted to use the new intermediate
>>>> values
>>>> in mpam_extend_config() ]
>>>>
>>>> Changes since rfc:
>>>> MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
>>>> Handling when reset_mbw_min is set
>>>>
>>>> Changes since v3:
>>>> Move the 5% gap policy back here
>>>> Clear mbw_min feature in class
>>>> ---
>>>>    Documentation/arch/arm64/silicon-errata.rst |  2 +
>>>>    drivers/resctrl/mpam_devices.c              | 50 ++++++++++++++++
>>>> +++--
>>>>    drivers/resctrl/mpam_internal.h             |  1 +
>>>>    3 files changed, 50 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/
>>>> Documentation/arch/arm64/silicon-errata.rst
>>>> index a65620f98e3a..a4b246655e37 100644
>>>> --- a/Documentation/arch/arm64/silicon-errata.rst
>>>> +++ b/Documentation/arch/arm64/silicon-errata.rst
>>>> @@ -249,6 +249,8 @@ stable kernels.
>>>>    +----------------+-----------------+-----------------
>>>> +-----------------------------+
>>>>    | NVIDIA         | T241 MPAM       | T241-MPAM-1     | N/
>>>> A                         |
>>>>    +----------------+-----------------+-----------------
>>>> +-----------------------------+
>>>> +| NVIDIA         | T241 MPAM       | T241-MPAM-4     | N/
>>>> A                         |
>>>> ++----------------+-----------------+-----------------
>>>> +-----------------------------+
>>>>    +----------------+-----------------+-----------------
>>>> +-----------------------------+
>>>>    | Freescale/NXP  | LS2080A/LS1043A | A-008585        |
>>>> FSL_ERRATUM_A008585         |
>>>>    +----------------+-----------------+-----------------
>>>> +-----------------------------+
>>>> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/
>>>> mpam_devices.c
>>>> index 08cb080592d9..8f44e9dee207 100644
>>>> --- a/drivers/resctrl/mpam_devices.c
>>>> +++ b/drivers/resctrl/mpam_devices.c
>>>> @@ -679,6 +679,12 @@ static const struct mpam_quirk mpam_quirks[] = {
>>>>        .iidr_mask  = MPAM_IIDR_MATCH_ONE,
>>>>        .workaround = T241_SCRUB_SHADOW_REGS,
>>>>        },
>>>> +    {
>>>> +    /* NVIDIA t241 erratum T241-MPAM-4 */
>>>> +    .iidr       = MPAM_IIDR_NVIDIA_T241,
>>>> +    .iidr_mask  = MPAM_IIDR_MATCH_ONE,
>>>> +    .workaround = T241_FORCE_MBW_MIN_TO_ONE,
>>>> +    },
>>>>        { NULL } /* Sentinel */
>>>>    };
>>>>    @@ -1464,6 +1470,31 @@ static void
>>>> mpam_quirk_post_config_change(struct mpam_msc_ris *ris, u16 partid,
>>>>            mpam_apply_t241_erratum(ris, partid);
>>>>    }
>>>>    +static u16 mpam_wa_t241_force_mbw_min_to_one(struct mpam_props
>>>> *props)
>>>> +{
>>>> +    u16 max_hw_value, min_hw_granule, res0_bits;
>>>> +
>>>> +    res0_bits = 16 - props->bwa_wd;
>>>> +    max_hw_value = ((1 << props->bwa_wd) - 1) << res0_bits;
>>>> +    min_hw_granule = ~max_hw_value;
>>>> +
>>>> +    return min_hw_granule + 1;
>>>> +}
>>>> +
>>>> +static u16 mpam_wa_t241_calc_min_from_max(struct mpam_config *cfg)
>>>> +{
>>>> +    u16 val = 0;
>>>> +
>>>> +    if (mpam_has_feature(mpam_feat_mbw_max, cfg)) {
>>>
>>> But the problem is mpam_feat_mbw_max feature is NOT set in cfg.
>>>
>>>> +        u16 delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
>>>> +
>>>> +        if (cfg->mbw_max > delta)
>>>> +            val = cfg->mbw_max - delta;
>>>> +    }
>>>> +
>>>> +    return val;
>>>
>>> So 0 is always returned.
>>>
>>> The workaround will set mbw_min as 1% which is too small and will cause
>>> performance degradation, e.g. about 20% degradation on some benchmarks.
>>>
>>> This patch itself doesn't have any issue.
>>>
>>> The issue is the mbw_max feature bit in cfg is not set.
>>
>> This is intended behaviour as the reset is done independently
>> from the value set in the config. The value is there so that
>> resctrl can display the expected values.
>>
>>> This is a legacy issue, not introduced by this patch set.
>>>> Here is a fix patch for the issue:
>>> https://lore.kernel.org/lkml/20260301171829.1357886-1-
>>> fenghuay@nvidia.com/T/#u
>>
>> I've commented on that patch. I think it's best to fix it in the context
>> of the erratum.
>>
>> Does the below solve your performance problems?
>>
>> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/
>> mpam_devices.c
>> index 236f78ab9163..60d3d3e2193f 100644
>> --- a/drivers/resctrl/mpam_devices.c
>> +++ b/drivers/resctrl/mpam_devices.c
>> @@ -1515,16 +1515,20 @@ static u16
>> mpam_wa_t241_force_mbw_min_to_one(struct mpam_props *props)
>>          return min_hw_granule + 1;
>>   }
>>   -static u16 mpam_wa_t241_calc_min_from_max(struct mpam_config *cfg)
>> +static u16 mpam_wa_t241_calc_min_from_max(struct mpam_props *props,
>> +                                         struct mpam_config *cfg)
>>   {
>>          u16 val = 0;
>> +       u16 max;
>> +       u16 delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
>>   -       if (mpam_has_feature(mpam_feat_mbw_max, cfg)) {
>> -               u16 delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
>> +       if (mpam_has_feature(mpam_feat_mbw_max, cfg))
>> +               max = cfg->mbw_max;
>> +       else
>> +               max = GENMASK(15, 16 - cprops->bwa_wd);
>>   -               if (cfg->mbw_max > delta)
>> -                       val = cfg->mbw_max - delta;
>> -       }
> 
> Could you please add some comments on this piece of code? It's worth to
> comment on why there are different values on cfg and props.

Sure, how about this?

	} else {
		/* Resetting so use the ris specific default. */
		max = GENMASK(15, 16 - props->bwa_wd);
	}


>> +       if (max > delta)
>> +               val = max - delta;
>>            return val;
>>   }
>> @@ -1577,9 +1581,8 @@ static void mpam_reprogram_ris_partid(struct
>> mpam_msc_ris *ris, u16 partid,
>>                  if (mpam_has_quirk(T241_FORCE_MBW_MIN_TO_ONE, msc)) {
>>                          u16 min =
>> mpam_wa_t241_force_mbw_min_to_one(rprops);
>>   -                       val = mpam_wa_t241_calc_min_from_max(cfg);
>> -                       if (val < min)
>> -                               val = min;
>> +                       val = mpam_wa_t241_calc_min_from_max(rprops,
>> cfg);
>> +                       val = max(val, min);
>>                  }
>>                    mpam_write_partsel_reg(msc, MBW_MIN, val);
>>
> 
> Otherwise, this change looks good to me.

Did you get a chance to confirm if it behaves as expected on your harware?

> 
> Thanks.
> 
> -Fenghua

Thanks,

Ben

