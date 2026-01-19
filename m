Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB492DB784
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 20:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768856068; cv=none; b=CQ9Nw1a2iY1OGroLWfiFrCeBtXWvJ8Z1B7uPAgFSoLOz/RRJ/BDqh6pGep2huHiCqOwa9+QxB9FovuCZQCm3tfZonxFGFj/CFEqjDyn1N6v3dPwbgmJBm1hATiFA/vceWjbWVh1WYZS+6j1GpWL/Mb0pzhEyburiIj9H/lsbFU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768856068; c=relaxed/simple;
	bh=zsWfuBGosH2/UFsLV672cXF9cvMaasLsusS+5/I1hsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=romM0JkPYdC9lUPuq5gfP7RCuCaSbqmdsFRHvdoIDOulujNz5cPfu//Z+z1gHOPROf39CHE+q14VxJ6wCh4AZft/InCAZLbk89sKKRosmepaQAkAuvyha/zAXhCUUfdyGLMXPPDvwCSCHD5LZFjZURFCEAzUuXiisUc4dX+U7yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D831497;
	Mon, 19 Jan 2026 12:54:19 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F46A3F632;
	Mon, 19 Jan 2026 12:54:21 -0800 (PST)
Message-ID: <bb2d36a3-1c0d-40ab-aa44-e94089ca141a@arm.com>
Date: Mon, 19 Jan 2026 20:54:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 44/47] arm_mpam: Add workaround for T241-MPAM-1
To: Gavin Shan <gshan@redhat.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-45-ben.horgan@arm.com>
 <598750f9-5df5-4f29-8912-2c20d929b82c@redhat.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <598750f9-5df5-4f29-8912-2c20d929b82c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 1/19/26 12:16, Gavin Shan wrote:
> On 1/13/26 12:59 AM, Ben Horgan wrote:

>>   +#define MPAM_IIDR_NVIDIA_T241   
>> FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0x241)    | \
>> +                FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)    | \
>> +                FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)    | \
>> +                FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x36b)
>> +
> 
> An error reported by checkpatch.pl as below.
> 
> ERROR: Macros with complex values should be enclosed in parentheses
> #205: FILE: drivers/resctrl/mpam_internal.h:247:
> +#define MPAM_IIDR_NVIDIA_T241   
> FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0x241)    | \
> +                FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0)    | \
> +                FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0)    | \
> +                FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0x36b)

Fixed
> 
> 
>>   /* The values for MSMON_CFG_MBWU_FLT.RWBW */
>>   enum mon_filter_options {
>>       COUNT_BOTH    = 0,
> 
> Thanks,
> Gavin
> 

Thanks,

Ben

