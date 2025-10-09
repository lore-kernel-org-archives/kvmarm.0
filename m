Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA632D6E7A
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 09:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760001091; cv=none; b=kNkVd4krbinF0TBATj8hn+7F/6iXKCxDVKA3xbD3EUmHChPR+NcRWFJjku3tRssTOViuw2fInGCN2H+onRJno7t6+oOhUOT8xc2hwX8SJZj4sSEVDhyIF7aZJ/+2LxmkbvA5HYH38ZrQK/PJ1A5eSf7VbywBPCE5kXxR6K4JzPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760001091; c=relaxed/simple;
	bh=R7FBKucmsLUy4WgR7TX/CxLpQ4WQjfM3OvcvioBvWBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sCl2OHqiY3KZ1PJ4WL+9YO4dIMwsvxnMktfA25bCkBytNz3Alj4TM4xzBxb/Tdkbq9Kxczv3s7HQvhr9RI0vINaS7bl1r1KIq3No1Wau0sBaLo6V8V+Onuqqpx4GPxQxx/zPVh+9IkhwI4vxQd9th/wLAqz9xSC0JDeMFEs/RVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 000CA176A;
	Thu,  9 Oct 2025 02:11:14 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 976E63F59E;
	Thu,  9 Oct 2025 02:11:21 -0700 (PDT)
Message-ID: <0b610239-6e90-464a-bf01-5332de62719f@arm.com>
Date: Thu, 9 Oct 2025 10:11:20 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Check cpu_has_spe() before initializing
 PMSCR_EL1 in VHE
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>, joey.gouly@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251007182356.2813920-1-mukesh.ojha@oss.qualcomm.com>
 <aOVckTSJET5ORY1n@linux.dev> <861pndzn4w.wl-maz@kernel.org>
 <aOasxgCMG0yS4t43@linux.dev>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aOasxgCMG0yS4t43@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/10/2025 19:26, Oliver Upton wrote:
> On Wed, Oct 08, 2025 at 11:46:55AM +0100, Marc Zyngier wrote:
>> On Tue, 07 Oct 2025 19:31:45 +0100,
>> Oliver Upton <oliver.upton@linux.dev> wrote:
>>>
>>> Hi Mukesh,
>>>
>>> I find it a bit odd to refer to cpu_has_spe() in the shortlog, which
>>> doesn't exist prior to this patch.
>>>
>>> On Tue, Oct 07, 2025 at 11:53:56PM +0530, Mukesh Ojha wrote:
>>>> commit efad60e46057 ("KVM: arm64: Initialize PMSCR_EL1 when in VHE")
>>>> initializes PMSCR_EL1 to 0 which is making the boot up stuck when KVM
>>>> runs in VHE mode and reverting the change is fixing the issue.
>>>>
>>>> [    2.967447] RPC: Registered tcp NFSv4.1 backchannel transport module.
>>>> [    2.974061] PCI: CLS 0 bytes, default 64
>>>> [    2.978171] Unpacking initramfs...
>>>> [    2.982889] kvm [1]: nv: 568 coarse grained trap handlers
>>>> [    2.988573] kvm [1]: IPA Size Limit: 40 bits
>>>>
>>>> Lets guard the change with cpu_has_spe() check so that it only affects
>>>> the cpu which has SPE feature supported.
>>>
>>> This could benefit from being spelled out a bit more. In both cases we
>>> check for the presence of FEAT_SPE, however I believe the issue you
>>> observe is EL3 hasn't delegated ownership of the Profiling Buffer to
>>> Non-secure nor does it reinject an UNDEF in response to the sysreg trap.
>>>
>>> I agree that the change is correct but the rationale needs to be clear.
>>
>> To me, this smells a lot more like some sort of papering over a
>> firmware bug. Why isn't SPE available the first place?
> 
> While I agree this points the finger at a half-assed EL3, the
> architecture explicitly allows this sort of crap and we cope with the
> accessibility of SPE in almost every other case.

One of the reasons behind this control is to work around errata, where
the higher EL could prevent the OS from using a broken implementation.
Also, for KVM could use the EL2 controls to disable SPE for Guest.

Suzuki

> 
> We should at least be consistent in how we handle an inaccessible SPE.
> 
> Thanks,
> Oliver

