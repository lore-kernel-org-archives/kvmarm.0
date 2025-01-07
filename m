Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 319501E1C1A
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 09:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736243982; cv=none; b=SyfkO1W50ZMiTyiG8G+ruDlilL/HpoSpoApjUEb0Vz38EHTuIA5prY5Kw8y1eiVP6XmJgpsKJXDPcWx+OHWWju4egC34Kk42xsMnp4tzjz552rRwMyuA89wfMcymRtxT0kNLoaZnJZxUtiiYIw+zi4I2C+KATb9QDaqwr3cF3qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736243982; c=relaxed/simple;
	bh=jVL0On8ztBEsX+aNPk1z8t/2uAcpC1ayqn7io1VkbX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OTwAXkzseiJ8a+lUzWlzZ/owvE5A9QEEPnXnp5mCCjD8iaPfz+r+7rtqAD36XeSZO9CcpXxYU7Ul5s1F31vjmXcUcA/XslEgP/tgABRYcbRUt6Md59OhEOVKLeQo3BSHZ/wUI/s6j5rlYxL/xoYgJYH00v7OGKZ1zuGvUdzpYXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF5C4143D;
	Tue,  7 Jan 2025 02:00:06 -0800 (PST)
Received: from [10.1.33.173] (e121487-lin.cambridge.arm.com [10.1.33.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A9E73F673;
	Tue,  7 Jan 2025 01:59:37 -0800 (PST)
Message-ID: <870bf5b6-af03-46a6-b4f2-63832f0be5e3@arm.com>
Date: Tue, 7 Jan 2025 09:59:35 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Fix FEAT_MOPS in pKVM
To: Fuad Tabba <tabba@google.com>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, joey.gouly@arm.com
References: <20250106112329.64013-1-vladimir.murzin@arm.com>
 <Z3xlT51luMieOAab@linux.dev>
 <CA+EHjTwraTsHmLRbyYV1-u-FQ8dqFPL1E5z2DFOe4yFUbQYXQQ@mail.gmail.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <CA+EHjTwraTsHmLRbyYV1-u-FQ8dqFPL1E5z2DFOe4yFUbQYXQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/7/25 08:08, Fuad Tabba wrote:
> On Mon, 6 Jan 2025 at 23:20, Oliver Upton <oliver.upton@linux.dev> wrote:
>> +cc Fuad
>>
>> On Mon, Jan 06, 2025 at 11:23:29AM +0000, Vladimir Murzin wrote:
>>> Flush HCRX_EL2 when switching between the host and the guests.
>>>
>>> Fixes: 84de212d739e ("KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest")
>>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> We shouldn't be trusting the host's hcrx_el2 in this case and should
>> instead calculate it for the pVM similar to the other trap registers
>> (see pkvm_vcpu_init_traps() and friends).
>>
>> It is apparent, though, that we erroneously exposed MOPS before commit
>> 3d7ff00700d1 ("KVM: arm64: Rework specifying restricted features for protected VMs").
> Yeah, actually FEAT_MOPS needs a bit more work for it to work with
> pKVM. I have patches (downstream, Android) that add MOPS support for
> pKVM. If there's interest I can post them now, but since protected VMs
> aren't completely done upstream I thought I'd wait a bit.

Fair enough.

Vladimir

> 
> Cheers,
> /fuad
> 
>> --
>> Thanks,
>> Oliver

