Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65110325486
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 11:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767699233; cv=none; b=Mh0cOyVliggBMhN97UHtlGnBBV1Y0Y40L42i7DdHvZkPbrs4T/FrUyGCkRoSt0O+6863uDMbxyHERSxd/hV6tY7hh4KUGqDdw5siqCm1VPAXBZa+akd89O+Kha3yRE7hJ/Ddc5YtI8uQK2f9hejEleTvwzEK6TnuzzjmEVWn+ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767699233; c=relaxed/simple;
	bh=G2XXRGjhwUhj7uKDeVyJc97ff9kBPoqZDL9T+lDTp04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MOr6+JDQ6NxK7AYNFgbE2RplIn0dvKwkIcegWULjEGl8VhY8WO91jaQvceWVih7XbzrPMedrfdN5TeIxWSr13f42poAe0eE8V5zWYbTmezejlSryDVzM27J2Q1OqkV12VIkxecu+BW2K1lIIh70uGSIxMwGTkDUpo/nwJ7066zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3717497;
	Tue,  6 Jan 2026 03:33:43 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D26E33F5A1;
	Tue,  6 Jan 2026 03:33:45 -0800 (PST)
Message-ID: <316c5635-75af-4ebb-ad2c-fab0742beb20@arm.com>
Date: Tue, 6 Jan 2026 11:33:44 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/45] arm_mpam: resctrl: Add rmid index helpers
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
 <20251219181147.3404071-24-ben.horgan@arm.com>
 <20260106112115.00000201@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260106112115.00000201@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/6/26 11:21, Jonathan Cameron wrote:
> On Fri, 19 Dec 2025 18:11:25 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> From: James Morse <james.morse@arm.com>
>>
>> Because MPAM's pmg aren't identical to RDT's rmid, resctrl handles some
>> data structures by index. This allows x86 to map indexes to RMID, and MPAM
>> to map them to partid-and-pmg.
>>
>> Add the helpers to do this.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> one comment inline.
> I messed around with GENMASK + field_prep()/field_get() - new
> versions of these with no need for runtime constant masks, but
> it ended up as not that much more readable than what you have here.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> ---
>> Changes since rfc:
>> Use ~0U instead of ~0 in lhs of left shift
>> ---
>>  drivers/resctrl/mpam_resctrl.c | 28 ++++++++++++++++++++++++++++
>>  include/linux/arm_mpam.h       |  3 +++
>>  2 files changed, 31 insertions(+)
>>
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index 4275b1a85887..bdbc5504964b 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -120,6 +120,34 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
>>  	return mpam_partid_max + 1;
>>  }
>>  
>> +u32 resctrl_arch_system_num_rmid_idx(void)
>> +{
>> +	u8 closid_shift = fls(mpam_pmg_max);
>> +	u32 num_partid = resctrl_arch_get_num_closid(NULL);
>> +
>> +	return num_partid << closid_shift;
> 
> Given I think you restrict mpam_pmg_max to be power of 2 elsewhere,
> doesn't this end up the same as something like
> 	return mpam_pmg_max * resctrl_arch_get_num_closid(NULL);
> Maybe its worth keeping it in the form you have here as
> it sort of provides documentation for how you pack those IDs

We only warn if (mpam_pmg_max + 1) is a power of 2 and so I'll keep this
as it is, although yours is equivalent in the expected case.

> 
>> +}
> 

Thanks,

Ben

