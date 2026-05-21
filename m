Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B473367283;
	Thu, 21 May 2026 16:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779379306; cv=none; b=eLt55jIZGh5W8oDmbWOmq0bJEmGrW/0mQCvhgBf/2rGWO73zChTJWh4E2yzOOmoURRUkBng5wJrDCvFaQvahnOOHG7jMlaAx6CQyzxywjBXpvem9oDclAHu0O3lzKbuvqLjOY18rzBMxnIisSTSswrEVy1jYzloVgOUlX6MQf90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779379306; c=relaxed/simple;
	bh=C2XTErJ4Ho5VJBYfNuKsd2pdN6y06CRfbrg4qfvDAz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BXYHbx4Anz7n6GpCh9LpZSxztPF2zXWK5qVdn5L0bR1VPn27/NPFJMjdR4ObLX8LmLyiJXFf2yWbJzgy34HWhG0MNDIK+dYfQdiTHLruFnJR5u8dNZK68EhSwIcEhHNfJSPjOVY1MiVk7Ll7Kgq9T3LcdiFJQEQfKYQy/hmxTrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=McqcDVXe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="McqcDVXe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A3C24A0B;
	Thu, 21 May 2026 09:01:38 -0700 (PDT)
Received: from [10.57.22.108] (unknown [10.57.22.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F5EE3F632;
	Thu, 21 May 2026 09:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779379303; bh=C2XTErJ4Ho5VJBYfNuKsd2pdN6y06CRfbrg4qfvDAz8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=McqcDVXe4IqzgUYd4mxIG/hYeLAE3i7TYhvxyEIollCwXRYESsG2LiwTNqbyaijA2
	 KaH8ngphdfSCUdD6gmOOb7cw/upUDzgNlOu5NhKShrCTrapTXfvvcYpug7sDh9RDfw
	 +wsaMVm9eJLG34qTaFiKmXEGweOC+75P3zDrLZSk=
Message-ID: <a81c3688-30f1-43e4-8d57-1d08a6e563af@arm.com>
Date: Thu, 21 May 2026 17:01:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 09/44] arm64: RMI: Provide functions to
 delegate/undelegate ranges of memory
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-10-steven.price@arm.com>
 <867bowx3qx.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <867bowx3qx.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/05/2026 14:59, Marc Zyngier wrote:
> On Wed, 13 May 2026 14:17:17 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The RMM requires memory is 'delegated' to it so that it can be used
>> either for a realm guest or for various tracking purposes within the RMM
>> (e.g. for metadata or page tables). Memory that has been delegated
>> cannot be accessed by the host (it will result in a Granule Protection
>> Fault).
>>
>> Undelegation may fail if the memory is still in use by the RMM. This
>> shouldn't happen (Linux should ensure it has destroyed the RMM objects
>> before attempting to undelegate). In the event that it does happen this
>> points to a programming bug and the only reasonable approach is for the
>> physical pages to be leaked - it is up to the caller of
>> rmi_undelegate_range() to handle this.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> v14:
>>   * Split into separate patch and moved out of KVM
>> ---
>>   arch/arm64/include/asm/rmi_cmds.h | 13 +++++++++++
>>   arch/arm64/kernel/rmi.c           | 36 +++++++++++++++++++++++++++++++
>>   2 files changed, 49 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
>> index 9078a2920a7c..eb213c8e6f26 100644
>> --- a/arch/arm64/include/asm/rmi_cmds.h
>> +++ b/arch/arm64/include/asm/rmi_cmds.h
>> @@ -33,6 +33,19 @@ struct rmi_sro_state {
>>   } while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY ||			\
>>   	 RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
>>   
>> +int rmi_delegate_range(phys_addr_t phys, unsigned long size);
>> +int rmi_undelegate_range(phys_addr_t phys, unsigned long size);
>> +
>> +static inline int rmi_delegate_page(phys_addr_t phys)
>> +{
>> +	return rmi_delegate_range(phys, PAGE_SIZE);
>> +}
>> +
>> +static inline int rmi_undelegate_page(phys_addr_t phys)
>> +{
>> +	return rmi_undelegate_range(phys, PAGE_SIZE);
>> +}
>> +
>>   bool rmi_is_available(void);
>>   
>>   unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp);
>> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
>> index 52a415e99500..08cef54acadb 100644
>> --- a/arch/arm64/kernel/rmi.c
>> +++ b/arch/arm64/kernel/rmi.c
>> @@ -12,6 +12,42 @@ static bool arm64_rmi_is_available;
>>   unsigned long rmm_feat_reg0;
>>   unsigned long rmm_feat_reg1;
>>   
>> +int rmi_delegate_range(phys_addr_t phys, unsigned long size)
>> +{
>> +	unsigned long ret = 0;
>> +	unsigned long top = phys + size;
>> +	unsigned long out_top;
>> +
>> +	while (phys < top) {
>> +		ret = rmi_granule_range_delegate(phys, top, &out_top);
>> +		if (ret == RMI_SUCCESS)
>> +			phys = out_top;
>> +		else if (ret != RMI_BUSY && ret != RMI_BLOCKED)
>> +			return ret;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +int rmi_undelegate_range(phys_addr_t phys, unsigned long size)
>> +{
>> +	unsigned long ret = 0;
>> +	unsigned long top = phys + size;
>> +	unsigned long out_top;
>> +
>> +	WARN_ON(size == 0);
> 
> I find it odd to warn on size = 0. After all, free(NULL) is not an
> error. But even then, you continue feeding this to the RMM.
> 
> You also don't seem to be bothered with that on the delegation side...
> 
>> +
>> +	while (phys < top) {
>> +		ret = rmi_granule_range_undelegate(phys, top, &out_top);
>> +		if (ret == RMI_SUCCESS)
>> +			phys = out_top;
> 
> and size==0 doesn't violate any of the failure conditions listed in
> B4.5.18.2 (beta2). Will you end-up looping around forever?

That is not true ? It triggers, top_bound error condition, for both.


pre: UInt(top) <= UInt(base)
post: result.status == RMI_ERROR_INPUT


Suzuki
> 
> Same questions for the delegation, obviously.
> 
> 	M.
> 

