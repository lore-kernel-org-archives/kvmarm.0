Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66223B19D8;
	Thu,  4 Jun 2026 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584238; cv=none; b=ttnDrcrGyO6nsFD4F8mincuiC+XMYYwrOLZ/vvS6tW6iM4daUlUIMmjOeDk1e6+3cmCGQJ6wTx60NbO+kCs1GLfs5PwCWHKcL9J7Rhq7LOFO3vR1HBIchQ6snJndoUp5XtF/pDG1cVhh9qG5DOaMORU42nudQXOHoB8xSABauDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584238; c=relaxed/simple;
	bh=b/UDPb8ZwzcbmTijGa9ghHw1SVkFtR2lx41scNsuBjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7tAJAe6liVW+zt/A7sjpNzG5MY6PzblcgCo2RSeu9V0QurbiUA90TPthLjXFedvql2ANb825ErivsPt0+DKXAMExgbZM4RLKLe7recsrRrjCBRD0WxmdzrydkGBgzwcMRQX1G+BA5GizM7o5zwZJ97qrdNmYsopVFonN3qSGL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Gn6z/d22; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Gn6z/d22"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1F783D4D;
	Thu,  4 Jun 2026 07:43:49 -0700 (PDT)
Received: from [10.1.34.54] (e122027.cambridge.arm.com [10.1.34.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE2373F7D8;
	Thu,  4 Jun 2026 07:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780584234; bh=b/UDPb8ZwzcbmTijGa9ghHw1SVkFtR2lx41scNsuBjo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gn6z/d22MGsutY4vrKsRLbGb1JtpNa5H68u4zp2JsNXjaVzof1wCdH042dXjksL32
	 3bQQkNGnNvI/E3bx/qFU+wirdXrg2s3UT8bnf/anDlnzOBsOrKTbQ0RD5hblrWE1yd
	 Xm4/PDVe6lFcK9jaluBGd8A0FpR/YMBGavFmftuY=
Message-ID: <fad5dc03-f7ce-4b15-bb73-e2dbd43810a6@arm.com>
Date: Thu, 4 Jun 2026 15:43:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 09/44] arm64: RMI: Provide functions to
 delegate/undelegate ranges of memory
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
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
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <867bowx3qx.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
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
>>  * Split into separate patch and moved out of KVM
>> ---
>>  arch/arm64/include/asm/rmi_cmds.h | 13 +++++++++++
>>  arch/arm64/kernel/rmi.c           | 36 +++++++++++++++++++++++++++++++
>>  2 files changed, 49 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
>> index 9078a2920a7c..eb213c8e6f26 100644
>> --- a/arch/arm64/include/asm/rmi_cmds.h
>> +++ b/arch/arm64/include/asm/rmi_cmds.h
>> @@ -33,6 +33,19 @@ struct rmi_sro_state {
>>  } while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY ||			\
>>  	 RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
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
>>  bool rmi_is_available(void);
>>  
>>  unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp);
>> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
>> index 52a415e99500..08cef54acadb 100644
>> --- a/arch/arm64/kernel/rmi.c
>> +++ b/arch/arm64/kernel/rmi.c
>> @@ -12,6 +12,42 @@ static bool arm64_rmi_is_available;
>>  unsigned long rmm_feat_reg0;
>>  unsigned long rmm_feat_reg1;
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

Ok, I'll admit that this is left over debugging - although this is a
condition that shouldn't happen.

Note that the while() condition prevents this from actually getting to
the RMM.

I'll drop the WARN_ON() since it's confusing.

Thanks,
Steve

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
> 
> Same questions for the delegation, obviously.
> 
> 	M.
> 

