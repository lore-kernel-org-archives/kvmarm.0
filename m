Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71934E0B7C;
	Wed, 30 Sep 2026 13:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776111; cv=none; b=M5ZwYWh/dMagQfXQpbSyi+p61ZJ1sN2J84KIWGyxqHS0dNRAaQeOBKuIrj/Wpr0ffqlq2ZReSvqhy3BH/Ny/dTjBE9KOSYBBX/QrPbrZLRgWryz9MIwWXYtdEOcdT73Y0/Bo2kIZmLj0ri51+Dd7f+9Tu5jS0cpgPF14kGtm/ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776111; c=relaxed/simple;
	bh=Dar8iWrwueb30Qw0DVgkCFG8Xw/Wi7e1xUK/b2vhgNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lc5lIOZjKLYcql6hSHP66y7C2S8XQfglxvvF/gp3H+NtMqdqKSf7vhVC5hHIy1gVDeVSbrx0L0S3WP3H39HJqrMCIyE/qVzyqvdPqmmZxnwr4hY4RptLiVCzlO7VZylK/y3ep4Hw+tb5BmVA9+3JEHnIkloPM9fGtjh2C8kSpaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=P/rjOi7t; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="P/rjOi7t"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 322B4497;
	Wed, 30 Sep 2026 06:48:10 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5536E3F86F;
	Wed, 30 Sep 2026 06:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790776093; bh=Dar8iWrwueb30Qw0DVgkCFG8Xw/Wi7e1xUK/b2vhgNY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P/rjOi7t+k/Vlmjdkbj8VZh103tFHBdnH29u8r/ktKUZE6HldY7ZSHosJFFxFw0R/
	 KZrYI8/RjFSujvEr/HTCwn+onttP+dtwZ7e2dy5Ia5zfZ0lZpzd+0zmGCkZx1URcHi
	 rcQaIElaifsQfE8cqNnmtnE1MhR9TJJyH+FS5QT8=
Message-ID: <10412ef0-94f1-4be8-8fd8-d1e5daaf421d@arm.com>
Date: Wed, 30 Sep 2026 14:48:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 4/9] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-5-suzuki.poulose@arm.com> <ar0LQwXM5MEvFUWa@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ar0LQwXM5MEvFUWa@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30/09/2026 14:15, Catalin Marinas wrote:
> On Tue, Sep 29, 2026 at 11:16:18PM +0100, Suzuki K Poulose wrote:
>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>> +				 unsigned long sro_handle,
>> +				 unsigned long donatereq,
>> +				 struct arm_smccc_1_2_regs *out_regs,
>> +				 gfp_t gfp)
>> +{
>> +	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
>> +	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
>> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
>> +	unsigned long state = RMI_DONATE_STATE(donatereq);
>> +	unsigned long size = block_size * count;
>> +	unsigned long addr_range;
>> +	unsigned long donated_size;
>> +	int ret;
>> +	void *virt;
>> +	phys_addr_t phys;
>> +
>> +	/*
>> +	 * The RMM specification requires contiguous allocations are always a
>> +	 * power of 2
>> +	 */
>> +	if (WARN_ON_ONCE(!is_power_of_2(size)))
>> +		return -EINVAL;
>> +	/*
>> +	 * RMM clamps the Maximum value of RmiOpMemDonateReq:count to prevent
>> +	 * overflow in the RMI_ADDR_RANGE_COUNT field.
>> +	 */
>> +	if (WARN_ON_ONCE(count > (BIT(PAGE_SHIFT - 2) - 1)))
>> +		return -EINVAL;
> 
> Nit: it might be easier to read as FIELD_MAX(RMI_ADDR_RANGE_COUNT_MASK)
> as that's what we want to limit it to.

Thanks, that is neat. I will update this.

> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> (Sashiko seems to have more findings but the rest looks alright to me)

I have updated the code to address the issues.

Thanks Catalin.

Suzuki

