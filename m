Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41BD34F461
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 09:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772617353; cv=none; b=YBEYuCTFXr82lh8WmAthu3AcqB7Ccd0ddd96fsNfl/+9+2HRyiNbHHwJNO42tLSzyTipXBiFu/B90FcXE4WW6VfXmFfRkZCsC1ewCrxFmJ3j2WIPzR4QzO70D4lNAbQzmthH7KQnJMlym33yi0cETjHZnHObRK87s1POxi8zwBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772617353; c=relaxed/simple;
	bh=9mhfdJo0bDUC45KIo47E4QnPpQe8tEohErhoklbBl8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RpkMs5ASxjBTJJEjqWPXsyBxZLGY8Gkk62kmiv166k02kSAAFIHLAgfz8aRuVUvJS9R6MeN/fMx2MWojKN6mCh7kcX8IkO/JN+/tyEOmSYjZM9B3Svnhjz1hIM81WuDio6qy5Ehw8hF0O76E6nLRUlbO+pw27ADuGfbUudnIvCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05F4A339;
	Wed,  4 Mar 2026 01:42:25 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9E153F694;
	Wed,  4 Mar 2026 01:42:26 -0800 (PST)
Message-ID: <6259fddb-62f3-4874-8188-6ca82e3586a8@arm.com>
Date: Wed, 4 Mar 2026 09:42:25 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
To: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, quic_jiles@quicinc.com, reinette.chatre@intel.com,
 rohit.mathew@arm.com, scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <87y0k8r7j1.fsf@stealth>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <87y0k8r7j1.fsf@stealth>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Punit,

On 3/3/26 20:18, Punit Agrawal wrote:
> Hi Ben,
> 
> Ben Horgan <ben.horgan@arm.com> writes:
> 
>> The main change in this version of the mpam missing pieces series is to
>> update the cdp emulation to match the resctrl interface. L2 and L3
>> resources can now enable cdp separately. Cdp can't be hidden correctly for
>> memory bandwidth allocation, as max per partid can't be emulated with more
>> partids, and so we hide this completely when cdp is enabled. There is a little
>> restructuring and a few smaller changes.
>>
>> Changelogs in patches
>>
>> It would be great to get this series merged this cycle. For that we'll need
>> more testing and reviewing. Thanks!
>>
>> From James' cover letter:
>>
>> This is the missing piece to make MPAM usable resctrl in user-space. This has
>> shed its debugfs code and the read/write 'event configuration' for the monitors
>> to make the series smaller.
>>
>> This adds the arch code and KVM support first. I anticipate the whole thing
>> going via arm64, but if goes via tip instead, the an immutable branch with those
>> patches should be easy to do.
>>
>> Generally the resctrl glue code works by picking what MPAM features it can expose
>> from the MPAM drive, then configuring the structs that back the resctrl helpers.
>> If your platform is sufficiently Xeon shaped, you should be able to get L2/L3 CPOR
>> bitmaps exposed via resctrl. CSU counters work if they are on/after the L3. MBWU
>> counters are considerably more hairy, and depend on hueristics around the topology,
>> and a bunch of stuff trying to emulate ABMC.
>> If it didn't pick what you wanted it to, please share the debug messages produced
>> when enabling dynamic debug and booting with:
>> | dyndbg="file mpam_resctrl.c +pl"
>>
>> I've not found a platform that can test all the behaviours around the monitors,
>> so this is where I'd expect the most bugs.
>>
>> The MPAM spec that describes all the system and MMIO registers can be found here:
>> https://developer.arm.com/documentation/ddi0598/db/?lang=en
>> (Ignored the 'RETIRED' warning - that is just arm moving the documentation around.
>>  This document has the best overview)
>>
>>
>> Based on v7.0-rc1
>>
>> The series can be retrieved from:
>> https://gitlab.arm.com/linux-arm/linux-bh.git mpam_resctrl_glue_v5
> 
> I booted with the series applied on an MPAM capable platform. The driver
> is able to probe the L2 attached MSCs.
> 
> In terms of features, bit-mapped based cache portion partitioning works
> as expected. The platform also supports additional controls (cache
> capacity and priority partitioning) and monitors (memory bandwidth and
> cache storage). The ones supported in MPAM driver probe OK but don't
> seem to be exposed. E.g.,
> 
>     mpam:mpam_resctrl_pick_counters: class 2 is a cache but not the L3
>     
> 
> It looks like some of it is due to an impedance mismatch with resctrl

Yes, what you describe is expected behaviour. There is no support yet
for cache capacity (CMAX) or bandwidth priority partitioning and
monitors are only exposed on the L3.

> expectations but hopefully we can get to it with the basics in-place.

I hope so. The CMAX and the bandwidth priority partitioning should be
easy to add once there is a generic way of adding new schema. There is a
plan/discussion here [1] and I don't expect adding monitoring on L2 to
be hard.

[1] https://lore.kernel.org/lkml/aPtfMFfLV1l%2FRB0L@e133380.arm.com/

> 
> Feel free to add
> 
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>

Thanks for testing!

> 
> Thanks,
> Punit
> 

Thanks,

Ben

