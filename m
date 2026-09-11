Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781AB39EF35;
	Fri, 11 Sep 2026 15:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789140564; cv=none; b=UV3MCCqZiX5aOvD9IGtkS3xLRo+jlJo/brmSMIZ1dXhQEU9MIS8kJcudrKXqmyzleW/JEIRLI62Ry8L8fETgy0aiHNf5Vr+gLv0sTEwoH10RmzExAE1BKKHCuu79HqhaUvTqVYbXGSor65kumGITjnQ+8gKiOia7g+dvUyLZ0LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789140564; c=relaxed/simple;
	bh=/xb0Nb16G9yyks+ml9kb/BhM51LigV9IcfIjYK9Rc4E=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=fBsQwNhuQ+UQqRPXJU0q38EOAz0I9r3Hi7Es4H64OxOa+rmicrdIsnEN21OdZQt8ssWj35Yv1sEG2n/Bisw2v4POeYcdv6LsvxnoG26v6TqOpU/AJEFMx9lNFA+J52cgjRJ7ykhL3xKM1q1T+o1frZSNQec4bq2fxJMPkwrAfN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p3fqa3Vd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p3fqa3Vd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30BB516A3;
	Fri, 11 Sep 2026 08:29:18 -0700 (PDT)
Received: from [10.0.129.245] (unknown [10.0.129.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E56723F8C6;
	Fri, 11 Sep 2026 08:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789140561; bh=/xb0Nb16G9yyks+ml9kb/BhM51LigV9IcfIjYK9Rc4E=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=p3fqa3VdOpYwaS6o072jyxRYETcjmQ17Q9gq4SbokoxOYB4jszQP5QyKIJNk9qBUf
	 N7TzV2DrG9fefESFhJVXKTizxlIGa7ubjd7dXFEs5w/ZSuhRionnydRPs08XlUjDEY
	 94VHRvvW3Xm9TflxDf6eS8Hz6n50gvndA0MZoJAU=
Message-ID: <89da8c52-9dd5-4ca3-81c6-1bf390029dc4@arm.com>
Date: Fri, 11 Sep 2026 16:29:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-5-suzuki.poulose@arm.com>
 <50d19bb3-6a08-462a-9c01-2eac8a8e286e@redhat.com>
 <603b2de8-7636-4eb8-a378-21be986f4e44@arm.com>
In-Reply-To: <603b2de8-7636-4eb8-a378-21be986f4e44@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/09/2026 10:51, Suzuki K Poulose wrote:
> Hi Gavin
> 
> Thank you for the the review, much appreciated. Responses inline.
> 
> 
> On 09/09/2026 05:10, Gavin Shan wrote:
>> Hi Suzuki,
>
>>
>>> +
>>> +    sro->addr_count = 0;
>>> +}
>>> +EXPORT_SYMBOL_GPL(rmi_sro_free);
>>> +
>>> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
>>> +{
>>> +    unsigned long sro_handle;
>>> +    struct arm_smccc_1_2_regs *regs = &sro->regs;
>>> +    bool cancelled = false;
>>> +
>>> +    rmi_smccc_invoke(regs, regs);
>>> +
>>> +    sro_handle = regs->a1;
>>> +
>>> +    while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
>>> +        bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
>>> +        int ret = 0;
>>> +
>>
>> Strictly speaking, we need to refresh the SRO handle after every RMI 
>> call.
>>
>>          bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0);
>>          unsigned long sro_handle = regs->a1;
>>          int ret = 0;
>>
> 
> Ack for both instances

This is not correct. e.g., after RMI_OP_MEM_DONATE and 
RMI_OP_MEM_RECLAIM, the regs->a1 is the number of granules consumed or 
reclaimed. The SRO handle once provided by an SRO triggering operation,
is invalidated by the RMI_OP_CONTINUE() running to completion.
i.e., RMI_OP_CONTINUE either completes with RMI_SUCCESS

OR

completes with a status other than RMI_BUSY or RMI_INCOMPLETE.

Thanks
Suzuki
