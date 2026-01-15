Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC3F27A92D
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 16:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768492976; cv=none; b=U3tnsMZgfNS0Sw7hS4GTPGWAogXOJ5QqKbKG7NySg6YW0NBA4CicH6BnE7/b92/lBSOjP9qaTZxBAacjIyPjx7X0WmGUMIDt7UzT1cKV8HFhvv5AXS/GT1YsgRABbFbSpmv1GX4pt7GKvKHksZbIGk/pYyBPMXM6OntiIxP00Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768492976; c=relaxed/simple;
	bh=TxMNyNfGxrBeD+6PAEXVMMBQhhhXwTBE60B8VUXfbpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZ40aGuQnmZWVKIvyUjE1W3IiCxgTMCfpF7L/D2JWlA9EEZullKmcpbjS1tSnkGgpcGw/z8797yzUW8/lt6TvJ1q/+v75WcETLNT3qdoqHP/tCkLwy4hDsycFgmLeB1VhJ7djsgiGow9cNPJoyLKjowqGvwJ26/rWQGGMmaSOhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FB911515;
	Thu, 15 Jan 2026 08:02:47 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D44F3F632;
	Thu, 15 Jan 2026 08:02:49 -0800 (PST)
Message-ID: <2f53c085-6bc2-4b5f-936c-5ee0d3b0648d@arm.com>
Date: Thu, 15 Jan 2026 16:02:47 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 37/47] arm_mpam: resctrl: Update the rmid reallocation
 limit
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
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-38-ben.horgan@arm.com>
 <OSZPR01MB8798ED2AFBA3EDFA0D2AFB9B8B8CA@OSZPR01MB8798.jpnprd01.prod.outlook.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <OSZPR01MB8798ED2AFBA3EDFA0D2AFB9B8B8CA@OSZPR01MB8798.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaopeng,

On 1/15/26 10:05, Shaopeng Tan (Fujitsu) wrote:
> Hello Ben,
> 
>> From: James Morse <james.morse@arm.com>
>>
>> resctrl's limbo code needs to be told when the data left in a cache is
>> small enough for the partid+pmg value to be re-allocated.
>>
>> x86 uses the cache size divided by the number of rmid users the cache may
>> have. Do the same, but for the smallest cache, and with the number of
>> partid-and-pmg users.
>>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since v2:
>> Move waiting for cache info into it's own patch
>> ---
>>  drivers/resctrl/mpam_resctrl.c | 35 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index 5adc78f9c96f..a6be3ce84241 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -561,6 +561,38 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
>>          reset_mon_cdp_safe(mon, mon_comp, USE_PRE_ALLOCATED, closid, rmid);
>>  }
>>  
>> +/*
>> + * The rmid realloc threshold should be for the smallest cache exposed to
>> + * resctrl.
>> + */
>> +static int update_rmid_limits(struct mpam_class *class)
>> +{
>> +       u32 num_unique_pmg = resctrl_arch_system_num_rmid_idx();
>> +       struct mpam_props *cprops = &class->props;
>> +       struct cacheinfo *ci;
>> +
>> +       lockdep_assert_cpus_held();
>> +
>> +       /* Assume cache levels are the same size for all CPUs... */
>> +       ci = get_cpu_cacheinfo_level(smp_processor_id(), class->level);
>> +       if (!ci || ci->size == 0) {
>> +               pr_debug("Could not read cache size for class %u\n",
>> +                        class->level);
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (!mpam_has_feature(mpam_feat_msmon_csu, cprops))
>> +               return 0;
> 
> Shouldn't it be return -EOPNOTSUPP;?

The intent of returning 0 here is that if csu is not supported on this
class then there is nothing to do and hence no error.

> 
> However, before the function update_rmid_limits() is called, there is a check: if (cache_has_usable_csu(class) && topology_matches_l3(class)).
> cache_has_usable_csu(class) already contains an identical check. Therefore, I think it's safe to remove this redundant one.

Yes, the check is redundant and can be removed. (If it were to stay it
should be moved to be before call get_cpu_cacheinfo_level() call so that
wouldn't give spurious errors for non-cache cpus.)

Thanks,

Ben

