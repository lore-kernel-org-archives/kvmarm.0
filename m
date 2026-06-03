Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE033D88F9;
	Wed,  3 Jun 2026 15:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780501720; cv=none; b=mtXAKmcxCgjJ/seCwQNoIDwSf7bsVFh/X4vDGyZUpHD1/sHitxQrDvRdDTs932PxenEsQW8bRe0NhL8yjgLcm1Jbu+c3hTdNLkOahGPNv9Mupii0JAHAVdNjqD+vJnsBiCbArrahjtDrrVOdzPX8OoUd8aw4GmVvWG1qCErZgMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780501720; c=relaxed/simple;
	bh=ouNCmZE7oxdLfG4i6FQgbNqLCetP2ysLUrVM+nxytVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LshXRXMzOOViIGtCMEp7S9QM/0Bp1oFDQlYmcOSriX/O/suGTXTh+2jcGpwo82S0beVOEa4rDQyq9e4/lLG8z4OdpJ189Em83LYi+/RtKVhf0n0F2oehjBdtXZXLWbhPZc5rBQzLSQxnLi3PaDkBUPXTrY1jab8XhWEd5pHUsWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BZPVSxWC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BZPVSxWC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D89B13329;
	Wed,  3 Jun 2026 08:48:29 -0700 (PDT)
Received: from [10.57.26.22] (unknown [10.57.26.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3BF53F86F;
	Wed,  3 Jun 2026 08:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780501714; bh=ouNCmZE7oxdLfG4i6FQgbNqLCetP2ysLUrVM+nxytVc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BZPVSxWChcvpFStmpjWtyNPJrIiDIdtMGaliCHESVQgxKks3WhIwVurwh2M0vbBHe
	 c+oLB3bKYJLBZa25Gwo8Ti/3Xhg/aoZyl+vGG9BeO5d4ikeiVDAOzInvUPrXrCiAKz
	 ptKYlqrdFMdTA99NiEIX2Etg1etKPu/Qzn6HR3qc=
Message-ID: <9d29cec1-fc2c-4a99-9ec3-79f7574743e4@arm.com>
Date: Wed, 3 Jun 2026 16:48:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/44] arm64: RMI: Configure the RMM with the host's
 page size
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
 <20260513131757.116630-8-steven.price@arm.com> <86a4tsx536.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86a4tsx536.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
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
>>  * Moved out of KVM.
>> ---
>>  arch/arm64/kernel/rmi.c | 42 +++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 42 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
>> index 99c1ccc35c11..a14ead5dedda 100644
>> --- a/arch/arm64/kernel/rmi.c
>> +++ b/arch/arm64/kernel/rmi.c
>> @@ -49,6 +49,45 @@ static int rmi_check_version(void)
>>  	return 0;
>>  }
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

Good spot. I have to admit I'm still getting the hang of these cleanup
handlers.

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

No, but falling through is clearly wrong (and likely to trigger AI
review comments if nothing else) - BUILD_BUG() sounds like a good solution.

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

Yes, as Suzuki answered - it never leaves the NS PAS. The RMM just reads it.

Thanks,
Steve

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
>>  static int __init arm64_init_rmi(void)
>>  {
>>  	/* Continue without realm support if we can't agree on a version */
>> @@ -60,6 +99,9 @@ static int __init arm64_init_rmi(void)
>>  	if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
>>  		return 0;
>>  
>> +	if (rmi_configure())
>> +		return 0;
>> +
>>  	return 0;
>>  }
>>  subsys_initcall(arm64_init_rmi);
> 
> Thanks,
> 
> 	M.
> 

