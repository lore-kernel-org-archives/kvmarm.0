Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6873EA967
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 08:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789114629; cv=none; b=BqhASCj7OaNhlnPV3Mg+ZjQ87xHNRQ7XNM/GuSRnzK4Ac/W7XUkwQVr6m1x/QTYcibKMvIWQX0yHLaNiVz0sUqDRfhCcAuETBx4bHEK+MRoRV/vo6kiFI8BYUhgjNzobgtBhfWb7rpH8TKjadUppbTILkzvgpd+ol6H0Lt+l7ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789114629; c=relaxed/simple;
	bh=TPsGC4LYcFPbDZQDuzzjee885teUbGy2eenjNKg1Wwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X66H4yYgSluYzLFETOt27NDpkHGHJ0lr57poPxdWFLpjB4WM6J5/yxYXS0DuDcATiX4eI7esYI6bjK6ZlFooGNqjhk+eKokmAAM4FGVV3Nw3JwlcYklo8s9jU3+TuO5ntr6yN136sT7ngO7tef10ywYQro9BCynFb/0lYMEWTwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NvrLUj+M; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NvrLUj+M"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E2BB16A3;
	Fri, 11 Sep 2026 01:17:00 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 856213F7B4;
	Fri, 11 Sep 2026 01:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789114624; bh=TPsGC4LYcFPbDZQDuzzjee885teUbGy2eenjNKg1Wwk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NvrLUj+Mtl4RA3Ci+dQCi4Gu3PXOmCVqm7akSjQwrC1/trQKc6gx45SUUy+CNd310
	 +qNENUqr/roCWCUblLUjNKqP4qjFFk5o9CwjIyqxXUZJek54f9iqQ9P8w0hgZ6YiNk
	 6CJsKjn5GPbcZlawTAoAOw52b3Bp0nI+y83w+6i4=
Message-ID: <1cd6fa61-df0d-4743-8f68-84cdf7f8722c@arm.com>
Date: Fri, 11 Sep 2026 09:16:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/40] arm_mpam: Reset when feature configuration bit
 unset
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-3-ben.horgan@arm.com>
 <7500ec7f-5e65-408c-a4ed-3f7af161219b@huawei.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <7500ec7f-5e65-408c-a4ed-3f7af161219b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Jinjie,

On 11/09/2026 07:44, Jinjie Ruan wrote:
> 
> 
> 在 2026/3/13 22:45, Ben Horgan 写道:
>> To indicate that the configuration, of the controls used by resctrl, in a
>> RIS need resetting to driver defaults the reset flags in mpam_config are
>> set. However, these flags are only ever set temporarily at RIS scope in
>> mpam_reset_ris() and hence mpam_cpu_online() will never reset these
>> controls to default. As the hardware reset is unknown this leads to unknown
>> configuration when the control values haven't been configured away from the
>> defaults.
>>
>> Use the policy that an unset feature configuration bit means reset. In this
>> way the mpam_config in the component can encode that it should be in reset
>> state and mpam_reprogram_msc() will reset controls as needed.
>>
>> Fixes: 09b89d2a72f3 ("arm_mpam: Allow configuration to be applied and restored during cpu online")
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> This goes back to the initial feature configuration policy that James
>> used in the MPAM base driver rfc but I unfortunately
>> suggested him to change it.
>> ---
>>  drivers/resctrl/mpam_devices.c | 40 ++++++++++------------------------
>>  1 file changed, 12 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
>> index 0fd6590a9b5c..ff861291bd4e 100644
>> --- a/drivers/resctrl/mpam_devices.c
>> +++ b/drivers/resctrl/mpam_devices.c
>> @@ -1364,17 +1364,15 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
>>  		__mpam_intpart_sel(ris->ris_idx, partid, msc);
>>  	}
>>  
>> -	if (mpam_has_feature(mpam_feat_cpor_part, rprops) &&
>> -	    mpam_has_feature(mpam_feat_cpor_part, cfg)) {
>> -		if (cfg->reset_cpbm)
>> -			mpam_reset_msc_bitmap(msc, MPAMCFG_CPBM, rprops->cpbm_wd);
>> -		else
>> +	if (mpam_has_feature(mpam_feat_cpor_part, rprops)) {
>> +		if (mpam_has_feature(mpam_feat_cpor_part, cfg))
>>  			mpam_write_partsel_reg(msc, CPBM, cfg->cpbm);
>> +		else
>> +			mpam_reset_msc_bitmap(msc, MPAMCFG_CPBM, rprops->cpbm_wd);
>>  	}
>>  
>> -	if (mpam_has_feature(mpam_feat_mbw_part, rprops) &&
>> -	    mpam_has_feature(mpam_feat_mbw_part, cfg)) {
>> -		if (cfg->reset_mbw_pbm)
>> +	if (mpam_has_feature(mpam_feat_mbw_part, rprops)) {
>> +		if (mpam_has_feature(mpam_feat_mbw_part, cfg))
>>  			mpam_reset_msc_bitmap(msc, MPAMCFG_MBW_PBM, rprops->mbw_pbm_bits);
> 
> This condition is written backwards, but it looks like it has already
> been fixed later.
> 
> Otherwise, LGTM
> Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>


Thanks for your reviews. As you hint at this has already been merged and so it's too late to apply
any tags. Good to know that the code survives being looked at by an extra pair of eyes. :)

Ben

> 
>>  		else
>>  			mpam_write_partsel_reg(msc, MBW_PBM, cfg->mbw_pbm);
>> @@ -1384,16 +1382,14 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
>>  	    mpam_has_feature(mpam_feat_mbw_min, cfg))
>>  		mpam_write_partsel_reg(msc, MBW_MIN, 0);
>>  
>> -	if (mpam_has_feature(mpam_feat_mbw_max, rprops) &&
>> -	    mpam_has_feature(mpam_feat_mbw_max, cfg)) {
>> -		if (cfg->reset_mbw_max)
>> -			mpam_write_partsel_reg(msc, MBW_MAX, MPAMCFG_MBW_MAX_MAX);
>> -		else
>> +	if (mpam_has_feature(mpam_feat_mbw_max, rprops)) {
>> +		if (mpam_has_feature(mpam_feat_mbw_max, cfg))
>>  			mpam_write_partsel_reg(msc, MBW_MAX, cfg->mbw_max);
>> +		else
>> +			mpam_write_partsel_reg(msc, MBW_MAX, MPAMCFG_MBW_MAX_MAX);
>>  	}
>>  
>> -	if (mpam_has_feature(mpam_feat_mbw_prop, rprops) &&
>> -	    mpam_has_feature(mpam_feat_mbw_prop, cfg))
>> +	if (mpam_has_feature(mpam_feat_mbw_prop, rprops))
>>  		mpam_write_partsel_reg(msc, MBW_PROP, 0);
>>  
>>  	if (mpam_has_feature(mpam_feat_cmax_cmax, rprops))
>> @@ -1491,16 +1487,6 @@ static int mpam_save_mbwu_state(void *arg)
>>  	return 0;
>>  }
>>  
>> -static void mpam_init_reset_cfg(struct mpam_config *reset_cfg)
>> -{
>> -	*reset_cfg = (struct mpam_config) {
>> -		.reset_cpbm = true,
>> -		.reset_mbw_pbm = true,
>> -		.reset_mbw_max = true,
>> -	};
>> -	bitmap_fill(reset_cfg->features, MPAM_FEATURE_LAST);
>> -}
>> -
>>  /*
>>   * Called via smp_call_on_cpu() to prevent migration, while still being
>>   * pre-emptible. Caller must hold mpam_srcu.
>> @@ -1508,14 +1494,12 @@ static void mpam_init_reset_cfg(struct mpam_config *reset_cfg)
>>  static int mpam_reset_ris(void *arg)
>>  {
>>  	u16 partid, partid_max;
>> -	struct mpam_config reset_cfg;
>> +	struct mpam_config reset_cfg = {};
>>  	struct mpam_msc_ris *ris = arg;
>>  
>>  	if (ris->in_reset_state)
>>  		return 0;
>>  
>> -	mpam_init_reset_cfg(&reset_cfg);
>> -
>>  	spin_lock(&partid_max_lock);
>>  	partid_max = mpam_partid_max;
>>  	spin_unlock(&partid_max_lock);
> 

