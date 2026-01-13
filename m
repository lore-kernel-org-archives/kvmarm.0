Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23FE343D78
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 17:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768324710; cv=none; b=sQbaAcVJE3maHrpIT/wzvGOehv4AOozA28SAdhpVKhwwDg4aFIjOO3Z1T7jKyOUxXB33IzsbwdYdd1FTkH5Safwn+B+C7BOfuLul1T1iB+B6DR+1Iuap6+05v6mNp0eW2u4lwVN+zeZiKJstxBU7Z5VpSIr8w0ap6Sd3otadrHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768324710; c=relaxed/simple;
	bh=1Uz18wbSQv5iZ/v00qK/QlkUmmmGMwN+5i3nVQwPZ5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TrmfHtJcsXP1MsxsAmdo4aL2QaAh5JbyG73FpdaGanng1QBWT4x/pclJ116mJmCMqWrCW7Bs3igbkZGHPBvDQvf/suHZhDpRyvjL98QoHsypjN3lswuz3ledUlyZmEmqfFGIj8HTykTkPNBQwdtOOcrs8kaZa5a9WIdwCoLfFFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57B24497;
	Tue, 13 Jan 2026 09:18:19 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1E963F632;
	Tue, 13 Jan 2026 09:18:20 -0800 (PST)
Message-ID: <f4e77744-cb32-4cea-a23f-3cd1a2ae9d79@arm.com>
Date: Tue, 13 Jan 2026 17:18:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/45] arm_mpam: resctrl: Implement
 resctrl_arch_reset_all_ctrls()
To: Zeng Heng <zengheng4@huawei.com>, jonathan.cameron@huawei.com
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 catalin.marinas@arm.com, corbet@lwn.net, dave.martin@arm.com,
 david@kernel.org, dfustini@baylibre.com, fenghuay@nvidia.com,
 gshan@redhat.com, james.morse@arm.com, joey.gouly@arm.com, kobak@nvidia.com,
 kvmarm@lists.linux.dev, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 maz@kernel.org, oupton@kernel.org, peternewman@google.com,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 suzuki.poulose@arm.com, tan.shaopeng@fujitsu.com, will@kernel.org,
 xhao@linux.alibaba.com, wangkefeng.wang@huawei.com
References: <20260105175154.00002041@huawei.com>
 <20260109034506.1176234-1-zengheng4@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260109034506.1176234-1-zengheng4@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Zeng,

On 1/9/26 03:45, Zeng Heng wrote:
>> From: James Morse <james.morse@arm.com>
>> Date: Fri, 5 Dec 2025 21:58:32 +0000
>> Subject: [PATCH v2 18/45] arm_mpam: resctrl: Implement resctrl_arch_reset_all_ctrls()
>>
>> We already have a helper for resetting an mpam class and component.  Hook
>> it up to resctrl_arch_reset_all_ctrls() and the domain offline path.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>>  drivers/resctrl/mpam_devices.c  |  6 +++---
>>  drivers/resctrl/mpam_internal.h |  7 +++++++
>>  drivers/resctrl/mpam_resctrl.c  | 15 +++++++++++++++
>>  3 files changed, 25 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index bc4f1c80eab..d32e8700245 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -353,6 +366,8 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
>>
>>  		ctrl_dom_empty = true;
>>  		if (exposed_alloc_capable) {
>> +			mpam_reset_component_locked(dom->ctrl_comp);
>> +
>>  			ctrl_d = &dom->resctrl_ctrl_dom;
>>  			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
>>  			if (ctrl_dom_empty)
> 
> mpam_cpu_offline() already directly calls mpam_reset_ris() to reset the
> MPAM MSC that is about to go offline. So why here still need
> mpam_resctrl_offline_cpu() to invoke mpam_reset_component_locked(),
> which ends up calling mpam_reset_ris() again?
> 
> Please point it out if I might have overlooked anything, thank you.

Yeah, this doesn't look right. A component will usually have affinity
with more than one cpu and if we weren't doing the reset elsewhere we
should only be doing the component level reset when the last of those
cpus goes offline. I'll give this cpu offline/online code another look over.

> 
> 
> Best Regards,
> Zeng Heng
> 

Thanks,

Ben

