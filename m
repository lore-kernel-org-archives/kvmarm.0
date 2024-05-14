Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20AA66E2BE;
	Tue, 14 May 2024 10:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682106; cv=none; b=pvPCHRDaGxDtOMvTdz/1Lq3hMNGMpPFvtEUMJmyGvFWdsSOfXHPDKJtdxyRdDZhDZJ2oQ6Y7lgHY0N/R2GHmxzYp2NNwk8ajb8h2RGP61hzO7Ab7uSQbR1p89duVJ6NnnbnIsd6+tBHDtmaCFIaXsgRUCe2yu6aoQzF4gvO78Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682106; c=relaxed/simple;
	bh=cfXngHl7xisjDpCrf/BadTTuQnGlonr0VClHLZYx6B4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NqakqzEnBSeq0zXOpD5o6de6/46Vvol1/HmI24v74wBXDc3QgDDdpth+hAa0Ybw9DUULgLbijJkAKV01ryp/8sIYt3QCcuY9Mcy44cU7VpIPfrd/9B9PrI/F+J0TxK7NCIxDnyAHf43vxWwGpPtnE2Pjpt+2BJtXBwVWSQnOjf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D3BD1007;
	Tue, 14 May 2024 03:22:09 -0700 (PDT)
Received: from [10.57.81.220] (unknown [10.57.81.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EA773F762;
	Tue, 14 May 2024 03:21:42 -0700 (PDT)
Message-ID: <6ba1fd72-3bad-44ca-810d-572b70050772@arm.com>
Date: Tue, 14 May 2024 11:21:40 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/14] arm64: Override set_fixmap_io
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-7-steven.price@arm.com> <ZkI8TZmEKwrEKhe_@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ZkI8TZmEKwrEKhe_@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/05/2024 17:14, Catalin Marinas wrote:
> On Fri, Apr 12, 2024 at 09:42:05AM +0100, Steven Price wrote:
>> Override the set_fixmap_io to set shared permission for the host
>> in case of a CC guest. For now we mark it shared unconditionally.
>> Future changes could filter the physical address and make the
>> decision accordingly.
> [...]
>> +void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
>> +{
>> +	pgprot_t prot = FIXMAP_PAGE_IO;
>> +
>> +	/*
>> +	 * For now we consider all I/O as non-secure. For future
>> +	 * filter the I/O base for setting appropriate permissions.
>> +	 */
>> +	prot = __pgprot(pgprot_val(prot) | PROT_NS_SHARED);
>> +
>> +	return __set_fixmap(idx, phys, prot);
>> +}
> 
> I looked through the patches and could not find any place where this
> function does anything different as per the commit log suggestion. Can
> we just update FIXMAP_PAGE_IO for now until you have a clear use-case?
> 

This gets used by the earlycon mapping. The commit description could be
made clear.

We may have to revisit this code to optionally apply the PROT_NS_SHARED
attribute, depending on whether this is a "protected MMIO" or not.


Suzuki
