Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 589AD2DEA61;
	Thu, 21 May 2026 22:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779403013; cv=none; b=sUhQ4JFtXFnlEB0pINCHA1XxsmsLv/CHzr0RWMOABWSWAK1MQ70aJVs1jxp7I/WZBxVDg+HvEA6Bz+wY1/E7TGn4GrxebvmVvDnn6ZeAbGR2r0DjGa8CL2puxveamwLCvgfdEoMW6B5Uj517cDHSq3CqvwKNgODgB4sKUI1puLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779403013; c=relaxed/simple;
	bh=iWi+rVGWRaT+t7ioXWfrl6ICbml7cqaQG7eYSudc3vY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CpwPG1tUSOoKwm4O/sqO8bn/dhKRWDaUXensquilK///zGWi1VlUT0SB0VTCzLd+rBSA20QqvL9LLmmkIK6DOWJO9rW4MpPeNggWJQAHbVqx3SheEMlMpFPZ7ALzRu5SApOb1q2hM+O8HymnSOqjICofVnUV3i2SDwzD+EULpH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W+Ic6z9S; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W+Ic6z9S"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28EA32A31;
	Thu, 21 May 2026 15:36:43 -0700 (PDT)
Received: from [10.57.22.108] (unknown [10.57.22.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 987C33F85F;
	Thu, 21 May 2026 15:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779403008; bh=iWi+rVGWRaT+t7ioXWfrl6ICbml7cqaQG7eYSudc3vY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W+Ic6z9S90OLpjZazd5fKEp50HHCNAKpeQz+VTrRIXEpk4ThW57c4RECTEvQzpM0L
	 /7385wq1ns9VH98WBApu5y2aaAivObGeC6hPIhcsCe3/bkbQemX93kPACTaB1UyWRj
	 Kzn8TtmAYaIsSEdZDnTq4ji6CZ4a9xbP1tUw8Tsc=
Message-ID: <2f5fec66-979a-4302-aa39-03ee8d9c82da@arm.com>
Date: Thu, 21 May 2026 23:36:38 +0100
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
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-8-steven.price@arm.com>
 <45a953a8-6edc-45c3-b5bd-17f14397ab89@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <45a953a8-6edc-45c3-b5bd-17f14397ab89@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/05/2026 01:51, Gavin Shan wrote:
> Hi Steven,
> 
> On 5/13/26 11:17 PM, Steven Price wrote:
>> RMM v2.0 brings the ability to set the RMM's granule size. Check the
>> feature registers and configure the RMM so that it matches the host's
>> page size. This means that operations can be done with a granulatity
>> equal to PAGE_SIZE.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v13:
>>   * Moved out of KVM.
>> ---
>>   arch/arm64/kernel/rmi.c | 42 +++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
>> index 99c1ccc35c11..a14ead5dedda 100644
>> --- a/arch/arm64/kernel/rmi.c
>> +++ b/arch/arm64/kernel/rmi.c
>> @@ -49,6 +49,45 @@ static int rmi_check_version(void)
>>       return 0;
>>   }
>> +static int rmi_configure(void)
>> +{
>> +    struct rmm_config *config __free(free_page) = NULL;
>> +    unsigned long ret;
>> +
>> +    config = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
>> +    if (!config)
>> +        return -ENOMEM;
>> +
>> +    switch (PAGE_SIZE) {
>> +    case SZ_4K:
>> +        config->rmi_granule_size = RMI_GRANULE_SIZE_4KB;
>> +        break;
>> +    case SZ_16K:
>> +        config->rmi_granule_size = RMI_GRANULE_SIZE_16KB;
>> +        break;
>> +    case SZ_64K:
>> +        config->rmi_granule_size = RMI_GRANULE_SIZE_64KB;
>> +        break;
>> +    default:
>> +        pr_err("Unsupported PAGE_SIZE for RMM\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    ret = rmi_rmm_config_set(virt_to_phys(config));
>> +    if (ret) {
>> +        pr_err("RMM config set failed\n");
>> +        return -EINVAL;
>> +    }
>> +
> 
> Looking at branch 'topics/rmm-v2.0-poc_2' of RMM implementation, the 
> granule size
> is fixed to be 4KB at present. I'm not sure if I have looked into 
> correct RMM
> implementation, but 'topics/rmm-v2.0-poc_2' is recommended one in the cover
> letter.
> 

You are right. The tf-RMM only supports 4KB. The policy at the KVM host
is to set the Linux PAGE_SIZE for the GRANULE_SIZE (at least for now).
If the RMM doesn't support the PAGE_SIZE, we don't support the RMM.


> Besides, there has checks in the handler of the RMI command to make sure 
> that
> struct rmm_config::tracking_region_size to be 1GB, indicated by zero. It 
> maybe
> worthy to set it before call to rmi_rmm_config_set().
> 
>      config.tracking_region_size = 0; /* 1GB */

Thanks, this explicit initialisation is missing, though in effect the
value is 0'd. Also, we can't really say 1GB here, because the driver 
should work for an RMM capable of 64K. So, instead, may be we could :

	/* See the definition of RMM_GRANULE_TRACKING_SIZE */
	config.tracking_region_size = 0;

Suzuki


>      ret = rmi_rmm_config_set(virt_to_phys(config));
> 
> 
>> +    ret = rmi_rmm_activate();
>> +    if (ret) {
>> +        pr_err("RMM activate failed\n");
>> +        return -ENXIO;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static int __init arm64_init_rmi(void)
>>   {
>>       /* Continue without realm support if we can't agree on a version */
>> @@ -60,6 +99,9 @@ static int __init arm64_init_rmi(void)
>>       if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
>>           return 0;
>> +    if (rmi_configure())
>> +        return 0;
>> +
>>       return 0;
>>   }
>>   subsys_initcall(arm64_init_rmi);
> 
> Thanks,
> Gavin
> 

