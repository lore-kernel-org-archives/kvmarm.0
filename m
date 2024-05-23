Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7955C13CFB7;
	Thu, 23 May 2024 09:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716458267; cv=none; b=EYSQ8e+lytSu33/uF0ci6I7lPD2/VqY8+hQ7UF1+u7oY6a8n8q6MKeke82Xr2R/VigAiMzyVRnmTbdpBubXhbubh6ryF1I0tOJLHoqOZCOdnL9xgFK3EmNVmZSEPHQI6IjufvqaQt2SKWqNhLP3L5s2zo1dO7OKjftEiumhPr+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716458267; c=relaxed/simple;
	bh=pJ+B3e29HJAbTyYyZa4HUjzMSv5Rh0HroDPaliFp3ZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eXFVU5K9KDFkK2uxiLoyfulhGR1yiYYDvuRafnnx86SzK0hL+aiMrrDiFlT2jFUzMUzxoL/NpHx/evNDpH0SqTOBNw3QutqG37TYuZAZhDTLXh5qNkUEaVWpzDx45ZEAYMfaOn4GgQ8B6Od++27yXZtFYbXo0HEGoLW3s/2XxNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A3C82F4;
	Thu, 23 May 2024 02:58:06 -0700 (PDT)
Received: from [10.1.30.34] (e122027.cambridge.arm.com [10.1.30.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF8003F766;
	Thu, 23 May 2024 02:57:39 -0700 (PDT)
Message-ID: <c329ae18-2b61-4851-8d6a-9e691a2007c8@arm.com>
Date: Thu, 23 May 2024 10:57:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-13-steven.price@arm.com> <ZkSV7Z8QFQYLETzD@arm.com>
 <74011ac1-34e0-4ee3-a00d-f78ad334fce2@arm.com> <Zk4l2xFBDW_3ImFD@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <Zk4l2xFBDW_3ImFD@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/05/2024 18:05, Catalin Marinas wrote:
> On Wed, May 22, 2024 at 04:52:45PM +0100, Steven Price wrote:
>> On 15/05/2024 12:01, Catalin Marinas wrote:
>>> On Fri, Apr 12, 2024 at 09:42:11AM +0100, Steven Price wrote:
>>>> @@ -3432,7 +3468,16 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
>>>>  	nr_ites = max(2, nvecs);
>>>>  	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
>>>>  	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
>>>> -	itt = kzalloc_node(sz, GFP_KERNEL, its->numa_node);
>>>> +	itt_order = get_order(sz);
>>>> +	page = its_alloc_shared_pages_node(its->numa_node,
>>>> +					   GFP_KERNEL | __GFP_ZERO,
>>>> +					   itt_order);
>>>
>>> How much do we waste by going for a full page always if this is going to
>>> be used on the host?
>>
>> sz is a minimum of ITS_ITT_ALIGN*2-1 - which is 511 bytes. So
>> potentially PAGE_SIZE-512 bytes could be wasted here (minus kmalloc
>> overhead).
> 
> That I figured out as well but how many times is this path called with a
> size smaller than a page?
> 

That presumably depends on the number of devices in the guest. For my
test guest setup (using kvmtool) this is called 3 times each with sz=511.

Steve

