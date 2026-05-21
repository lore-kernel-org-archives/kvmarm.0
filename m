Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9384A349CD1;
	Thu, 21 May 2026 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375201; cv=none; b=LgpyWykb3gqeoFAK3tbJNtj1N/U2ultPHqhxfptx6EKSai8ioeuxzHY0AA5/WkLKO/I/HkXkrN03Bfp6WtG8H02btjLpxhHFp93el5KoB+ZSvrXB8Kf8BPtflHIIRas5RUWM6P6G2SVDEif8TmnE3eUJ5dgBEz6UOGwTB/Gta2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375201; c=relaxed/simple;
	bh=3Z31DGiiKxp5n0Ca0LQiOFBY3d8tuirIjtCjZrB4whg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AT9kdoSHBwmKRpAKaB7C5H7VAdxDp+1My41Tq6z0bsC9VEYQaVgb93kVURTIS/SKGHsr6gjMT5V7ZawtpYx+wdRLUX4dmRkyeYQc/SIwCRoEHupRwPCMh58Lk1PUP0IDueN8LlK7rPSuHnJUWuNdP9hKzgUlaOLg2K7bbgxYXp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p2hKMPO2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p2hKMPO2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1B0B3AEC;
	Thu, 21 May 2026 07:53:14 -0700 (PDT)
Received: from [10.57.22.108] (unknown [10.57.22.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5E9B3F85F;
	Thu, 21 May 2026 07:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779375200; bh=3Z31DGiiKxp5n0Ca0LQiOFBY3d8tuirIjtCjZrB4whg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p2hKMPO2BFpLvMd5O6Z2ApC9Y/J7Rjghz9A1PMS3sklCCxLKzm/F3xmW9mqzqVA2Q
	 DlBijEnuK1PG3+xt0m3TohT84x2FZ/NKtJ9jqA5QikxWGuUDZDVfgNno1MRtjgl37h
	 R+p/IOEzU9BnKAmmL3ouK8VbMWX2cUkA8tnJ4lYw=
Message-ID: <318df626-9af1-4db2-90db-d7e0aef4c7ff@arm.com>
Date: Thu, 21 May 2026 15:53:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/44] arm64: RMI: Configure the RMM with the host's
 page size
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
 <20260513131757.116630-8-steven.price@arm.com> <86a4tsx536.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86a4tsx536.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/05/2026 14:30, Marc Zyngier wrote:
> On Wed, 13 May 2026 14:17:15 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> RMM v2.0 brings the ability to set the RMM's granule size. Check the
>> feature registers and configure the RMM so that it matches the host's
>> page size. This means that operations can be done with a granulatity
>> equal to PAGE_SIZE.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v13:
>>   * Moved out of KVM.
>> ---
>>   arch/arm64/kernel/rmi.c | 42 +++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
>> index 99c1ccc35c11..a14ead5dedda 100644
>> --- a/arch/arm64/kernel/rmi.c
>> +++ b/arch/arm64/kernel/rmi.c
>> @@ -49,6 +49,45 @@ static int rmi_check_version(void)
>>   	return 0;
>>   }
>>   
>> +static int rmi_configure(void)
>> +{
>> +	struct rmm_config *config __free(free_page) = NULL;
>> +	unsigned long ret;
>> +
>> +	config = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
>> +	if (!config)
>> +		return -ENOMEM;
> 
> This is the sort of buggy construct that is highlighted in
> include/linux/cleanup.h: initialising the object for cleanup with
> NULL, and only later assigning the expected value.
> 
> It may not matter here, but it will catch you (or more probably me) in
> the future.
> 
>> +
>> +	switch (PAGE_SIZE) {
>> +	case SZ_4K:
>> +		config->rmi_granule_size = RMI_GRANULE_SIZE_4KB;
>> +		break;
>> +	case SZ_16K:
>> +		config->rmi_granule_size = RMI_GRANULE_SIZE_16KB;
>> +		break;
>> +	case SZ_64K:
>> +		config->rmi_granule_size = RMI_GRANULE_SIZE_64KB;
>> +		break;
>> +	default:
>> +		pr_err("Unsupported PAGE_SIZE for RMM\n");
> 
> Do you really anticipate PAGE_SIZE being any other value? This is 100%
> dead code. If you want to be extra cautious, have a BUILD_BUg_ON().
> 
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = rmi_rmm_config_set(virt_to_phys(config));
>> +	if (ret) {
>> +		pr_err("RMM config set failed\n");
>> +		return -EINVAL;
>> +	}
> 
> What is the live cycle of the page when the call succeeds? Is it
> switched back to the NS PAS and allowed to be freed?

It always remains in the NS world. We relay some information in the
NS PAS page, which the RMM consumes. The checks are performed on
the values consumed by the RMM.

Kind regards
Suzuki

> 
>> +
>> +	ret = rmi_rmm_activate();
>> +	if (ret) {
>> +		pr_err("RMM activate failed\n");
>> +		return -ENXIO;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int __init arm64_init_rmi(void)
>>   {
>>   	/* Continue without realm support if we can't agree on a version */
>> @@ -60,6 +99,9 @@ static int __init arm64_init_rmi(void)
>>   	if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
>>   		return 0;
>>   
>> +	if (rmi_configure())
>> +		return 0;
>> +
>>   	return 0;
>>   }
>>   subsys_initcall(arm64_init_rmi);
> 
> Thanks,
> 
> 	M.
> 

