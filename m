Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35FBB322B8D
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 11:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767698380; cv=none; b=rg7ZRAzeMVs9MAXfWAt4Vc5aQ3wM5KA2oR1bSYv+gxpAM/dsxQ/hEjzFS1TW15ebg2qjSPFMpQmelvIJ44loDwiiJ45UMMwkPmGijqr34NuT7u1xYYkAg/m8TYssEA9ulRCW+qom8LC85buUR3k8DP1pY5IpJ7MsKeN5gfcHRd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767698380; c=relaxed/simple;
	bh=JXUPter/7kmKN9sEHb7kZeGpweKHPB9k5Gghk0xdGD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LbIUjl34afieZirZ14djhH6y5Hpc+EaCJ26qXznoaZ2Hdnc1PkDv0Ohf8SCQV0zhCfoLrKFxXbPnQZ82kafONVS9aHJ2O1pN3HMHIz98uYfCzlpyuSCyLV4gnlyi0FDEX5qGBJvhqpMNpmrFgBiW6L4jvnVJ8apoF4kZWKPH1eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E01A91595;
	Tue,  6 Jan 2026 03:19:31 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC3AE3F5A1;
	Tue,  6 Jan 2026 03:19:33 -0800 (PST)
Message-ID: <4152d2bb-098c-48db-94f0-a90306700266@arm.com>
Date: Tue, 6 Jan 2026 11:19:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/45] arm_mpam: resctrl: Implement
 resctrl_arch_reset_all_ctrls()
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-19-ben.horgan@arm.com>
 <20260105175154.00002041@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260105175154.00002041@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/5/26 17:51, Jonathan Cameron wrote:
> On Fri, 19 Dec 2025 18:11:20 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> From: James Morse <james.morse@arm.com>
>>
>> We already have a helper for resetting an mpam class and component.  Hook
>> it up to resctrl_arch_reset_all_ctrls() and the domain offline path.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> I left all the context as my one comment on this is I don't see a reason
> to expose mpam_reset_class()  Only the _locked() variant ever seems to be
> used outside of mpam_devices.c
> 
>> ---

>> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
>> index 554e4887ba81..b9a739abb101 100644
>> --- a/drivers/resctrl/mpam_internal.h
>> +++ b/drivers/resctrl/mpam_internal.h
>> @@ -389,6 +389,13 @@ extern u8 mpam_pmg_max;
>>  void mpam_enable(struct work_struct *work);
>>  void mpam_disable(struct work_struct *work);
>>  
>> +/* Reset all the RIS in a class, optionally while holding cpus_read_lock() */
>> +void mpam_reset_class_locked(struct mpam_class *class);
>> +void mpam_reset_class(struct mpam_class *class);
> 
> Not clear from this patch why we need to expose mpam_reset_class()

Good spot. That's not required in this series, so I will stop exposing it.


Thanks,

Ben

