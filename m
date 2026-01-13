Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768292E2665
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768317351; cv=none; b=a3Qa/PlX01jeOy9DHQXYvZrU2LCIHYYtXXtZ8wxDbpTI5I8HwwbZ4PVeHtV0S11mo2ARWUDThg7Y+eP/q6ZAzgLAMWBqpuMsq3/xP6GyuJM1k0YvvLTLDVFOThUPfQGMhyG2iRjk9h6rwNWAGoFxS6IB8pYEynp3G5k3YjqP4wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768317351; c=relaxed/simple;
	bh=JVEfB+Xp7YTwjoOGKdBDPGEm0NcnZw5pNrlW8gTUk5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JW3xdB1Ss1YdKhjyfqeMR3N+h5pWFtF2DHLk/dWpnXvkjP9dHlVyg4exSYWh4T92RGJCrnVx5sCN+s5MoMrJ89x9P6Qq1mZzBxnqXPbq6HZcTnbwgIc3LB9UuBAGslM12nL9/LVb2lX0MzcGN0+/HjJY/8RHhKwmGm1+F5KA0J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19BDB497;
	Tue, 13 Jan 2026 07:15:43 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EFF8A3F632;
	Tue, 13 Jan 2026 07:15:44 -0800 (PST)
Message-ID: <5bd84ae7-b9ea-49a8-a2e7-1ccd09117126@arm.com>
Date: Tue, 13 Jan 2026 15:15:43 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/47] arm_mpam: resctrl: Wait for cacheinfo to be
 ready
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
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-27-ben.horgan@arm.com>
 <20260113150159.000053f7@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260113150159.000053f7@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/13/26 15:01, Jonathan Cameron wrote:
> On Mon, 12 Jan 2026 16:58:53 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> In order to calculate the rmid realloc threshold the size of the cache
>> needs to be known. Cache domains will also be named after the cache id. So
>> that this information can be extracted from cacheinfo we need to wait for
>> it to be ready. The cacheinfo information is populated in device_initcall()
>> so we wait for that.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> [horgan: split out from another patch]
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> This is moved into it's own patch to allow all uses of cacheinfo to be
>> valid when they are introduced.
> 
> I don't mind the patch but I'm not entirely following this comment. Is
> the point that previously there was a sneaky user before this was added in
> the series?

Yes, arm_mpam: resctrl: Add support for 'MB' resource, accesses
cacheinfo so wanted to order this patch before that.

> 
> Anyhow, that's not in the patch itself so
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Thanks,

Ben

