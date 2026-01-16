Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5641E346FC6
	for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 11:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768561476; cv=none; b=enCnL0lAyKuPcmB4iJ+wkMtMr4mZDOSuNMB1r+vk0XSYtja9iKNc4mSptl0t5vb+g2Egdc/F93+g5YFI1sFR66z54jCagPbjuyvwMB7gqhSOwZChnesZjH+2mbSHfXtUPXU9+D2vF67LFyzcBI5LT/XYeETGwwJks83w8ltdDRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768561476; c=relaxed/simple;
	bh=4l0FmMZtL1nzRzFcB12kJUY9J/80RhFDcGGqxCkD/XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EmZ6G89db/RKjE6m7XdnFNhlVLZi3dHWSpu8A1nAoBE/RWVRz+J0kAYnrQOl3OUnf274DIR0/I9aIutI2sqbBuxtRYZgP++sCMdDPvi8ubm/m29k38TIQ1BpMF0yiv6v9e8zQwaqV5KBDwJW2JjafYSfTUydo2IFdCMnOPodRiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2EF21515;
	Fri, 16 Jan 2026 03:04:23 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEF0E3F59E;
	Fri, 16 Jan 2026 03:04:25 -0800 (PST)
Message-ID: <2ef49c6c-9de8-4aca-9e78-726b8665cdeb@arm.com>
Date: Fri, 16 Jan 2026 11:04:24 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/47] arm_mpam: resctrl: Pre-allocate assignable
 monitors
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
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <TYCPR01MB88047C83A1CE49648667437B8B8DA@TYCPR01MB8804.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaopeng,

On 1/16/26 10:34, Shaopeng Tan (Fujitsu) wrote:
> Hello Ben,
> 
>> From: James Morse <james.morse@arm.com>
>>
>> When there are not enough monitors, MPAM is able to emulate ABMC by making
>> a smaller number of monitors assignable. These monitors still need to be
>> allocated from the driver, and mapped to whichever control/monitor group
>> resctrl wants to use them with.
>>
>> Add a second array to hold the monitor values indexed by resctrl's cntr_id.
>>
>> When CDP is in use, two monitors are needed so the available number of
>> counters halves. Platforms with one monitor will have zero monitors when
>> CDP is in use.
>>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
[...]
>> +bool resctrl_arch_mbm_cntr_assign_enabled(struct rdt_resource *r)
>> +{
>> +       if (r != &mpam_resctrl_controls[RDT_RESOURCE_L3].resctrl_res)
>> +               return false;
>> +
>> +       return mpam_resctrl_abmc_enabled();
>> +}
>> +
>> +int resctrl_arch_mbm_cntr_assign_set(struct rdt_resource *r, bool enable)
>> +{
>> +       return -EINVAL;
>> +}
> 
> $ echo "default" | sudo tee /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
> default
> tee: /sys/fs/resctrl/info/L3_MON/mbm_assign_mode:Invalid argument
> "return  -EOPNOTSUPP;" might be better.

I'll keep this as -EINVAL in the case when 'enable' matches the current mode
and change it to return 0 when there is nothing to change. This will match the 
behaviour once this is handled in resctrl. See the outcome of the discussion on
this resctrl patch [1] Note, that I haven't yet updated the patch to match the 
discussion. Any objection?

[1] https://lore.kernel.org/lkml/bf8bb682-6a4d-4f39-916c-952719fcf48d@arm.com/

Thanks,

Ben

