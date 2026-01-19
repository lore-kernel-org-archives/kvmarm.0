Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 144FF2EFD89
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 20:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854478; cv=none; b=lWrDPNWsATAYiavGY9I5z3bWg3V2zFusHAZDq7JlPfzOOvUCMR/UK+wa7Sq5UFSigEJ4JxsFFYZUHWJurXJjiMQXCubfCKXCAfSwNF0Zl1/QHHJanlpYN/xWVJQaCk9CB7Pfsm7ZFh2O5qd4vchqx0sMAQ5Y2LNNzmDGi8zMZ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854478; c=relaxed/simple;
	bh=l7OGHgBqUdlJIIGBUaGoWwq4IP6XHtFwiItZKoV1VT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3UTn5q54i56+5TLACQTpLMa49zLqKosPzEY7Vj+mMnrbsMJ4wAjvL76C8My//te4IOZNY83QU4hN1eYzp4wufCZThnsrS1L2xkhO1vhhQl/sj16/T0ImOS8DjxDUKDI8RutK/N8PxSZrhQCIB4AxuqwRRD1WCSCqrvyN1p/pBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5D20497;
	Mon, 19 Jan 2026 12:27:48 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7690B3F694;
	Mon, 19 Jan 2026 12:27:50 -0800 (PST)
Message-ID: <a25b6768-2423-48d8-aabf-fc902199ffbc@arm.com>
Date: Mon, 19 Jan 2026 20:27:48 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/47] arm_mpam: resctrl: Pre-allocate free running
 monitors
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
 <20260112165914.4086692-31-ben.horgan@arm.com>
 <5e20890a-f1f0-4a54-894b-a0e170a8a5f8@redhat.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <5e20890a-f1f0-4a54-894b-a0e170a8a5f8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 1/19/26 11:57, Gavin Shan wrote:
> Hi Ben,
> 
> On 1/13/26 12:58 AM, Ben Horgan wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> When there are enough monitors, the resctrl mbm local and total files can
>> be exposed. These need all the monitors that resctrl may use to be
>> allocated up front.
>>
>> Add helpers to do this.
>>
>> If a different candidate class is discovered, the old array should be
>> free'd and the allocated monitors returned to the driver.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

>> +
>> +static int *__alloc_mbwu_array(struct mpam_class *class, u16
>> num_mbwu_mon)
>> +{
>> +    int err;
>> +    size_t array_size = num_mbwu_mon * sizeof(int);
>> +    int *array __free(kfree) = kmalloc(array_size, GFP_KERNEL);
>> +
> 
> A warning reported by checkpatch.pl as below.
> 
> WARNING: Missing a blank line after declarations
> #84: FILE: drivers/resctrl/mpam_resctrl.c:607:
> +    size_t array_size = num_mbwu_mon * sizeof(int);
> +    int *array __free(kfree) = kmalloc(array_size, GFP_KERNEL);
> 

Similarly to the other blank line checkpatch.pl warning I expect this is
to do with how it handles the __free() annotation. I'm not intending to
change this code unless there is some style guideline that I've missed
or other reason to do so.

Thanks,

Ben

