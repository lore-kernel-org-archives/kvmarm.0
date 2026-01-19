Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051D926C3A2
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 20:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854856; cv=none; b=usttl4J2DiLIrOttsgy7yd60jFQdcSYsT1lw5SNT/aCfsIXsjuqHmOhfxjn8//8I5h6xDKlJT19kC9W5Oqq1JyjqKVWlXZS79Pw+2IE3O5ql1jmqKxIvtnlnMgiFXFEaih5Xjz6oZdkCiAAggW0ohIXUSFj/FlDdxW1KGFwiAs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854856; c=relaxed/simple;
	bh=94Y5vWiz5zMutkZCx3w7uEnUEufnOcufbG+WS4nRn84=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=B9IRRIjCFhPAZBguzXWhN/omo0pNy6xwHGlOonQjNjYSi9Mya3N1RuJD14u8YHxZ+lCXYvNHtL2X6zp8Gf+2QV+IPyIBLlPKF1hJ8XWFsRr03N35aUaqS85CR7FpOjXTXEjTXtjiObGFYep6E6vzavQ9VMJzWxh1/eULafY5Ojc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8015497;
	Mon, 19 Jan 2026 12:34:06 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 891903F694;
	Mon, 19 Jan 2026 12:34:08 -0800 (PST)
Message-ID: <efd5ee5b-f5f5-4efc-abbc-0213b8c60b14@arm.com>
Date: Mon, 19 Jan 2026 20:34:06 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/47] arm_mpam: resctrl: Pre-allocate assignable
 monitors
From: Ben Horgan <ben.horgan@arm.com>
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
 <20260112165914.4086692-32-ben.horgan@arm.com>
 <TYCPR01MB88047C83A1CE49648667437B8B8DA@TYCPR01MB8804.jpnprd01.prod.outlook.com>
 <2ef49c6c-9de8-4aca-9e78-726b8665cdeb@arm.com>
Content-Language: en-US
In-Reply-To: <2ef49c6c-9de8-4aca-9e78-726b8665cdeb@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaopeng,

On 1/16/26 11:04, Ben Horgan wrote:
> Hi Shaopeng,
> 
> On 1/16/26 10:34, Shaopeng Tan (Fujitsu) wrote:
>> Hello Ben,
>>
>>> From: James Morse <james.morse@arm.com>
>>>
>>> When there are not enough monitors, MPAM is able to emulate ABMC by making
>>> a smaller number of monitors assignable. These monitors still need to be
>>> allocated from the driver, and mapped to whichever control/monitor group
>>> resctrl wants to use them with.
>>>
>>> Add a second array to hold the monitor values indexed by resctrl's cntr_id.
>>>
>>> When CDP is in use, two monitors are needed so the available number of
>>> counters halves. Platforms with one monitor will have zero monitors when
>>> CDP is in use.
>>>
>>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>>> Signed-off-by: James Morse <james.morse@arm.com>
>>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> [...]
>>> +bool resctrl_arch_mbm_cntr_assign_enabled(struct rdt_resource *r)
>>> +{
>>> +       if (r != &mpam_resctrl_controls[RDT_RESOURCE_L3].resctrl_res)
>>> +               return false;
>>> +
>>> +       return mpam_resctrl_abmc_enabled();
>>> +}
>>> +
>>> +int resctrl_arch_mbm_cntr_assign_set(struct rdt_resource *r, bool enable)
>>> +{
>>> +       return -EINVAL;
>>> +}
>>
>> $ echo "default" | sudo tee /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
>> default
>> tee: /sys/fs/resctrl/info/L3_MON/mbm_assign_mode:Invalid argument
>> "return  -EOPNOTSUPP;" might be better.
> 
> I'll keep this as -EINVAL in the case when 'enable' matches the current mode
> and change it to return 0 when there is nothing to change. This will match the 

Actually, resctl_arch_cntr_assign_set() only gets called on an attempt
to change the value so I'll keep it as is.

> behaviour once this is handled in resctrl. See the outcome of the discussion on
> this resctrl patch [1] Note, that I haven't yet updated the patch to match the 
> discussion. Any objection?
> 
> [1] https://lore.kernel.org/lkml/bf8bb682-6a4d-4f39-916c-952719fcf48d@arm.com/
> 
> Thanks,
> 
> Ben
> 
> 

Thanks,

Ben

