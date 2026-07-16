Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8283264EF;
	Thu, 16 Jul 2026 15:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784216504; cv=none; b=XG44uJPXAFLbw0wfnt2vRBg6Wa1i8K4aNta80VWuqKcJ9uW7kUzTwFRgWe6NiW488T2t2Ghi1/wV8Gb9WPkI6dG48mIAoUb1YJlU+wf5ROSlO+0WwzC6Ctl3ezDcOIRDrj5OXodeMq0u+z3jrTTyneKlpzwk4q+UktsU5OoJIw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784216504; c=relaxed/simple;
	bh=94RGRdEYqLxWTR/qNw7RW0jWuRssx8EWadWOUPz8xWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LDdkpEM01TyWw2ZBkRo6zphemrBS/pMyeetH/As/U/Hvk0+ozopQ0LLMw4rHSl77Jz162TpQpRQdzNHlORXWZaAYnPB+0llkgHi/4ijZXYzRSVyzrYmMhllgFjcDW5dH5trbPCURYU8C1ZSNjKkJBRAcgdiRKHdifollugmbG7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qe2rBSUG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qe2rBSUG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61C722B;
	Thu, 16 Jul 2026 08:41:36 -0700 (PDT)
Received: from [10.1.25.27] (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CDF03F66F;
	Thu, 16 Jul 2026 08:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784216500; bh=94RGRdEYqLxWTR/qNw7RW0jWuRssx8EWadWOUPz8xWw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qe2rBSUG2XlWx7aqp/91UgrwTpklVL5jajjQkyhG4MV6xrsVSLdf/B+5TAqHznr+U
	 NJY3TxzbaEMlz/1FhDbM9His1yccfUP4DMKOuBLzSQb4V1EmHFi/MbX3CULic3wd/0
	 ako5C5rXbF4TRotxNgLwTsPPIRIfrC88r8bwokUE=
Message-ID: <0119c198-3272-4245-afbe-755f8ee47c9a@arm.com>
Date: Thu, 16 Jul 2026 16:41:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] firmware: arm_rmm: Configure the RMM with the host's
 page size
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-5-steven.price@arm.com>
 <20260715151849.4CFC11F00A3D@smtp.kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260715151849.4CFC11F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/07/2026 16:18, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Missing validation of RMM granule size against cached feature registers.
> --
> 
> --- Patch [4]: [PATCH 4/6] firmware: arm_rmm: Configure the RMM with the host's page size ---
> commit db91734b5b3e860f7a56847c4c9ab7f969eaf312
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Configure the RMM with the host's page size
> 
> This commit introduces a function to configure the RMM's granule size to match
> the host's page size. It allocates a configuration page, populates the
> rmi_granule_size according to PAGE_SIZE, and calls rmi_rmm_config_set() to
> apply the settings.
> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index c4850976544ff..e7ab4a7df3ca8 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> [ ... ]
>> @@ -76,6 +76,45 @@ static int rmi_read_features(void)
>>  	return 0;
>>  }
>>  
>> +static int rmi_configure(void)
>> +{
>> +	unsigned long ret;
>> +	struct rmm_config *config __free(free_page) = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
>> +
>> +	if (!config)
>> +		return -ENOMEM;
>> +
>> +	switch (PAGE_SIZE) {
> 
> [Severity: Medium]
> The commit message states "Check the feature registers and configure the
> RMM so that it matches the host's page size."
> 
> Does rmi_configure() actually verify the host's PAGE_SIZE against the
> cached RMM feature registers before proceeding?
> 
> It appears to unconditionally assign the configuration based on PAGE_SIZE.
> If the RMM does not support the host's page size, the driver will blindly
> send an unsupported configuration to the RMM firmware.
> 
> Should there be a validation check here using the features read in
> rmi_read_features() before configuring the granule size?

The commit message is a bit misleading. In practise the RMM will reject
an attempt to set a granule size that it doesn't support. And size Linux
requires the granule size to match PAGE_SIZE either the RMM supports the
granule size we request or we fail and don't use the RMM. So the feature
check in itself doesn't help.

But we can have a more helpful error message so I'll fix this up to
actually check the feature bits and produce an appropriate error message
if the RMM doesn't support the required granule size.

Steve

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
>> +		BUILD_BUG();
>> +	}
> 

