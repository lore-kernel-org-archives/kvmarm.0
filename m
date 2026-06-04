Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D9430AD0B;
	Thu,  4 Jun 2026 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780586390; cv=none; b=mMQ7X+9CfUw287dM6Goo3BkvZGixCUqKFrR6EIaK2cC/qtNHfO5jt8w4KnZuKKSKnFpecPsntci+lxhWD5EIir6CinwxZo4L7XStOlscMqeWsZdwa7POfDQH0UfquQy2h9YXzoBpVt/5FH55jWQJNPd62Db5f/j8aj/NZ9KRxss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780586390; c=relaxed/simple;
	bh=mRslR92UBVFk9szOYwdXFeTxrFDO6f1XAumMp3y2mwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sBjC/tHJ7Eyz4Cj9Tn5Q+zhCmPzYfTjYwo2Om/wCJD7RJ55Ge+urG3w9nCgcH1+wJ8/M1afZFpprPU1M5poH+22oOUX408R6bBNNqYMX5yDiueLuAoKXxeh+r5N0J/Fhuavd/Z8v116vBorUfaFkWAuYlgrqfbOaWwPDsp+06n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mlzeQn6X; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mlzeQn6X"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C959F479C;
	Thu,  4 Jun 2026 08:19:42 -0700 (PDT)
Received: from [10.1.34.54] (e122027.cambridge.arm.com [10.1.34.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 703933F86F;
	Thu,  4 Jun 2026 08:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780586387; bh=mRslR92UBVFk9szOYwdXFeTxrFDO6f1XAumMp3y2mwA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mlzeQn6XiknQgV7rw+hr4FPslR3VC6bxMOsWhACn8Xe/OZcz1omXoL/Ol7ltEtEj5
	 Xnvm42I6VOmV47kV+GNbMfe8DNSfDxum0e9uP+P+VK65N6WwygdJzFIdANCh8w5Y0r
	 mz6AjznB8vDvmWWWHggva+c8RvrH5eafQcMYB5vk=
Message-ID: <83085359-c685-4d2c-9302-d3f31d5131b7@arm.com>
Date: Thu, 4 Jun 2026 16:19:38 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 10/44] arm64: RMI: Add support for SRO
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-11-steven.price@arm.com> <yq5a7bp0szrw.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5a7bp0szrw.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/05/2026 07:02, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> +static unsigned long donate_req_to_size(unsigned long donatereq)
>> +{
>> +	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
>> +
>> +	switch (unit_size) {
>> +	case 0:
>> +		return PAGE_SIZE;
>> +	case 1:
>> +		return PMD_SIZE;
>> +	case 2:
>> +		return PUD_SIZE;
>> +	case 3:
>> +		return P4D_SIZE;
>> +	}
>> +	unreachable();
>> +}
>>
>> +
>> +static void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs_in,
>> +			     struct arm_smccc_1_2_regs *regs_out)
>> +{
>> +	struct arm_smccc_1_2_regs regs = *regs_in;
>> +	unsigned long status;
>> +
>> +	do {
>> +		arm_smccc_1_2_invoke(&regs, regs_out);
>> +		status = RMI_RETURN_STATUS(regs_out->a0);
>> +	} while (status == RMI_BUSY || status == RMI_BLOCKED);
>> +}
>> +
>> +int free_delegated_page(phys_addr_t phys)
>> +{
>> +	if (WARN_ON(rmi_undelegate_page(phys))) {
>> +		/* Undelegate failed: leak the page */
>> +		return -EBUSY;
>> +	}
>> +
>> +	free_page((unsigned long)phys_to_virt(phys));
>> +
>> +	return 0;
>> +}
>> +
>> +static int rmi_sro_ensure_capacity(struct rmi_sro_state *sro,
>> +				   unsigned long count)
>> +{
>> +	if (WARN_ON_ONCE(sro->addr_count > RMI_MAX_ADDR_LIST))
>> +		return -EOVERFLOW;
>> +
>> +	if (count > RMI_MAX_ADDR_LIST - sro->addr_count)
>> +		return -ENOSPC;
>> +
>> +	return 0;
>> +}
>> +
>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>> +				 unsigned long sro_handle,
>> +				 unsigned long donatereq,
>> +				 struct arm_smccc_1_2_regs *out_regs,
>> +				 gfp_t gfp)
>> +{
>> +	unsigned long unit_size = RMI_DONATE_SIZE(donatereq);
>> +	unsigned long unit_size_bytes = donate_req_to_size(donatereq);
>> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
>> +	unsigned long state = RMI_DONATE_STATE(donatereq);
>> +	unsigned long size = unit_size_bytes * count;
>> +	unsigned long addr_range;
>>
> 
> Looking at above and the related code, I am wondering whether we should
> use u64 instead of unsigned long for everything that the specification
> defines as 64-bit.

I'm split on this. The kernel makes use of "(unsigned) long" for a
register sized value in quite a few places. Not least in struct
arm_smccc_1_2_regs which is ultimately where most of the values are read
from or written to.

I'm not a great fan of the kernel's approach to using long like this -
there's a good argument that uintptr_t is more correct. Equally when
we're in arch code for a 64 bit architecture (i.e. "arm64") then we know
the size is u64.

The disadvantage here is that if I use u64 then there's a bunch of
implicit conversions going on between unsigned long and u64 - which
might come back to bite if anything changes. Hence my current view that
"unsigned long" is the best option here in the kernel.

Anyone else have any view on the best type here?

Thanks,
Steve

