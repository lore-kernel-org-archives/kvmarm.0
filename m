Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842A5358D14
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 10:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770027697; cv=none; b=o3xXbtmmoMHeqjlbP/GrjhuSEXJhTyjwannJsqVExb8kevsBQqinq0eRTS5b48i97Q5V1gQ56DvzWhen60jTfQ9xRJvLJNQeclXP9aTY/8F8hgd34mOAO1mE4qSaVKbGj3+8oMWr0s/YzcwghSaU5xPv4P7peKPYrvUpmY/XKx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770027697; c=relaxed/simple;
	bh=VMlZ/UOu1AFfPXpsSMFSWV+9VebetIrfvX/v7GCCL/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SbBilRQv2dGQ7IzD99Q/1hqWvBVs9voyR8Y6/WEcbR+Lp0rmWaLMUYU/QT+zo11nay+V+CQ+UMcW8hVboaLMU2rCWS5ilZIa1SBrRWtTPArnMawmhyG4P4NW3mSydi9mUiuuOREoDAs5227QvkWWJOpgQRk8NXppgsOaXYCueUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B9D2339;
	Mon,  2 Feb 2026 02:21:28 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A381C3F740;
	Mon,  2 Feb 2026 02:21:29 -0800 (PST)
Message-ID: <3ae02b5b-22ab-4778-a29d-709ca3163f58@arm.com>
Date: Mon, 2 Feb 2026 10:21:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 41/47] arm_mpam: Generate a configuration for min
 controls
To: Shanker Donthineni <sdonthineni@nvidia.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 "fenghuay@nvidia.com" <fenghuay@nvidia.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 gshan@redhat.com, james.morse@arm.com, kobak@nvidia.com,
 lcherian@marvell.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, peternewman@google.com,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, tan.shaopeng@fujitsu.com,
 xhao@linux.alibaba.com, catalin.marinas@arm.com, will@kernel.org,
 corbet@lwn.net, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 Zeng Heng <zengheng4@huawei.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-42-ben.horgan@arm.com>
 <20260113153938.00007d6e@huawei.com>
 <80db7035-07d3-4fb4-a228-f9c67d2df1f4@arm.com>
 <9e01328f-7f28-4b43-aaf4-59d3ce80c268@nvidia.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <9e01328f-7f28-4b43-aaf4-59d3ce80c268@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Shanker,

On 1/31/26 02:30, Shanker Donthineni wrote:
> Hi Ben,
> 
> On 1/30/2026 8:17 AM, Ben Horgan wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> Hi Fenghua, Jonathan,
>>
>> On 1/13/26 15:39, Jonathan Cameron wrote:
>>> On Mon, 12 Jan 2026 16:59:08 +0000
>>> Ben Horgan <ben.horgan@arm.com> wrote:
>>>
>>>> From: James Morse <james.morse@arm.com>
>>>>
>>>> MPAM supports a minimum and maximum control for memory bandwidth. The
>>>> purpose of the minimum control is to give priority to tasks that are
>>>> below
>>>> their minimum value. Resctrl only provides one value for the bandwidth
>>>> configuration, which is used for the maximum.
>>>>
>>>>
>>>> Hence, I'll drop this patch, and update the mbw_min default to be
>>>> 0xFFFF
>>>> and for the value not to change even if mbw_max changes. I think this
>>>> leaves us in the best position going forward without any heuristics
>>>> that
>>>> may come back to bite us later when proper support for a schema
>>>> supporting mbw_min is added to resctrl.
> 
> Background: I previouslyshared original fix(seecodesnippet below) with
> James Morse
> ~2 years ago to address the errata, which explicitly recommends usinga
> 5% gap for
> mitigation of the Hardware issue (the problem described in commit text
> of T241-MPAM-4)
> 
> For some reason theoriginalimplementationwas splitinto two patches:
>   - Generic change applicable toall chips
>   - Specific fixfor Graceerrata T241-MPAM-4
> >
> Issue: Dropping this patch impacts[PATCH v3 45/47] forthe errata fix. If
> removalis
> necessary, please mergethis changeinto the T241-MPAM-4-specific patch.


What's the behaviour on T241 when MBW_MIN is always 0xFFFF?

I'm worried if we make a policy decision of how to set MBW_MIN based on
MBW_MAX for this platform then we won't be able to support a
configurable MBW_MIN in the future for this platform. As when MBW_MIN
support is added in resctrl the user's configuration for this platform
would change meaning on kernel upgrade.

> 
> --- a/drivers/platform/mpam/mpam_devices.c
> +++ b/drivers/platform/mpam/mpam_devices.c
> @@ -1190,8 +1190,12 @@ static void mpam_reprogram_ris_partid(struct
> mpam_msc_ris *ris, u16 partid, rprops->mbw_pbm_bits);
>          }
> -       if (mpam_has_feature(mpam_feat_mbw_min, rprops))
> -               mpam_write_partsel_reg(msc, MBW_MIN, 0);
> +       if (mpam_has_feature(mpam_feat_mbw_min, rprops)) {
> +               if (mpam_has_feature(mpam_feat_mbw_max, cfg))
> +                       mpam_write_partsel_reg(msc, MBW_MIN, cfg->mbw_min);
> +               else
> +                       mpam_write_partsel_reg(msc, MBW_MIN, 0);
> +       }
>         if (mpam_has_feature(mpam_feat_mbw_max, rprops)) {
>                 if (mpam_has_feature(mpam_feat_mbw_max, cfg)) @@
> -2332,6 +2336,31 @@ static int __write_config(void *arg)
>          return 0;
>   }
> +static void mpam_extend_config(struct mpam_class *class, struct
> mpam_config *cfg)
> +{
> +       struct mpam_props *cprops = &class->props;
> +       u32 min, delta;
> +
> +       /*
> +        * MAX and MIN should be set together. If only one is provided,
> +        * generate a configuration for the other. If only one control
> +        * type is supported, the other value will be ignored.
> +        *
> +        * Resctrl can only configure the MAX.
> +        *
> +        * Parts affected by Nvidia's T241-MPAM-4 depend on this occurring,
> +        * and recommend a 5% difference.
> +        */
> +       if (mpam_has_feature(mpam_feat_mbw_max, cfg) &&
> +           !mpam_has_feature(mpam_feat_mbw_min, cfg)){
> +               delta = ((5 * MPAMCFG_MBW_MAX_MAX) / 100) - 1;
> +               min = max_t(s32, cfg->mbw_max - delta, BIT(cprops-
>>bwa_wd));
> +
> +               cfg->mbw_min = max_t(s32, cfg->mbw_max - delta, BIT(16 -
> cprops->bwa_wd));
> +               mpam_set_feature(mpam_feat_mbw_min, cfg);
> +       }
> +}
> 
> Shanker
> 

Thanks,

Ben

