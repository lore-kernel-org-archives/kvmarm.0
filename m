Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE4A82AE78
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 10:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773829365; cv=none; b=aFl9dIZoPn5uMeBmq174bAykUjaKXFCvjYaHzzT946aYDYMXxl3wsOAhBeuqYXTSaGz9bpHc2pX/QZNmA6c/proZaEACyCYyZRTiRODyyRKx7EiuI0sImJ7udB7AtvTJHG6EXswfUxAzJ8uvF2AWCq+sI4u0glSU/gDVJsvrb7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773829365; c=relaxed/simple;
	bh=AWNoVGlTeHh0vTJZXksAKLtoa+rNN0yOAW8HDTelPtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FSM+0L+Xt7U65Tsajd5EbvXMrA8OJiHOMrlPgwy0LaRIgAlhrFmP33u+8sMFP4rCY7V1TVzYX1zV3H1O1OImDsqi+KtH0Jk2F6NS2l2NSk8JdJmKi6Q/gCZh29921B3S/aR71YPaF5CmQCw0dvQrZeNC5YDnFDGyOwT8fHxIp6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5FC81E2F;
	Wed, 18 Mar 2026 03:22:35 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BEF93F778;
	Wed, 18 Mar 2026 03:22:38 -0700 (PDT)
Message-ID: <967c7d65-6ffe-4eb9-817c-2eb1f9b510b1@arm.com>
Date: Wed, 18 Mar 2026 10:22:36 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
To: Jesse Chick <jessechick@os.amperecomputing.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <a8d31059-f821-48ac-b6bb-7e8d38fac7b6@os.amperecomputing.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <a8d31059-f821-48ac-b6bb-7e8d38fac7b6@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jesse,

On 3/17/26 00:25, Jesse Chick wrote:
> Hi Ben,
> 
> 
>> Thanks for all the reviewing and testing so far. Just a bit more to get this
>> over the line.
> 
> 
> I tested this patch series, specifically L3 CPOR, on an Ampere
> implementation with common benchmarking tools (lmbench, multichase).
> 
> 
>> Generally the resctrl glue code works by picking what MPAM features it can expose
>> from the MPAM drive, then configuring the structs that back the resctrl helpers.
>> If your platform is sufficiently Xeon shaped, you should be able to get L2/L3 CPOR
>> bitmaps exposed via resctrl. CSU counters work if they are on/after the L3. MBWU
>> counters are considerably more hairy, and depend on hueristics around the topology,
>> and a bunch of stuff trying to emulate ABMC.
> 
> 
> The observed latency in increasingly large R/W operations scaled as
> expected across various numbers of competing processes and cache
> portions. The distinct jumps in latency as successive cache level
> capacities were exceeded indicates that (a) L3 CPOR is configurable from
> user space via the resctrl interface as described in this series and (b)
> that the feature itself is working correctly.
> 
> For the series:
> 
> Tested-by: Jesse Chick <jessechick@os.amperecomputing.com>

Thanks for the testing and description.

Ben

> 
> Thanks,
> Jesse
> 
> 

