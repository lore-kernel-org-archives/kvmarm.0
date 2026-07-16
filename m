Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2EE1427F80;
	Thu, 16 Jul 2026 14:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212132; cv=none; b=mPvtZCXG3sENjwJHM7l7BcJ84SL5ZlqiNC0XOaLtBHngVF1cmidsfQplWLkV1gPOJIlKRpLiW7fR6/GnFd8ErdQHfWrR7dPbJ/v6VyxxI4NTfgLQFAtJ+Fftv2eI9jLjhUWUbeC1CwHoH4H/pc+ifpDF783MFtyuWgLmYpnwnOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212132; c=relaxed/simple;
	bh=v8OucCXbe06cck5NrQCH3E556ISbB8sQ0rcYir6JOJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TW6iw12Z1L60II5V/JUsd99RWuACWxmKT1/fhokf10W4Z2+U7ri0OEE+DfvlHULu8BLVhi5LbKz8hCzab6zJUSQt66KPSt0CelnVPcqaCMVEUm4XakyJeczElG+yHDYqv5wNe4aF9gl2T1kTT8mYwSjosrMXJ7ccALkBpyCisPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mHo7G56f; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mHo7G56f"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 325641476;
	Thu, 16 Jul 2026 07:28:46 -0700 (PDT)
Received: from [10.1.25.27] (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 460C53F7B4;
	Thu, 16 Jul 2026 07:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784212130; bh=v8OucCXbe06cck5NrQCH3E556ISbB8sQ0rcYir6JOJ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mHo7G56f/YGTBLp7X1UCnOsv+bJHW09K3xjG8VqYmQESA+ualloPAtIgPLsu+wxtK
	 A4moLlGpSll0JM2oDhoLyYgj01xQ89+QRot2TpSlmbLDd80bdIBYwfQM7C2atZQ8Ae
	 PzdVaY0Bhz8ci9Hd7LSoNGgrDkvt9fvnwgL60+KY=
Message-ID: <29ca4cae-c492-4e18-be63-0a8584ade1c7@arm.com>
Date: Thu, 16 Jul 2026 15:28:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] firmware: arm_rmm: Check for RMI support at init
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-4-steven.price@arm.com>
 <20260715150656.4D0A61F00A3A@smtp.kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260715150656.4D0A61F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/07/2026 16:06, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] The function `is_rmi_available()` is declared in the header but its implementation is missing.
> --
> 
> --- Patch [3]: [PATCH 3/6] firmware: arm_rmm: Check for RMI support at init ---
> commit 422535e6880c00ddffdc5f970e459e2cf571e957
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Check for RMI support at init
> 
> Query the RMI version number and check if it is a compatible version.
> The first two feature registers are read and exposed for future code to
> use.
> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> new file mode 100644
>> index 0000000000000..c4850976544ff
>> --- /dev/null
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> 
> [ ... ]
> 
>> +static int __init arm64_init_rmi(void)
>> +{
>> +	int ret;
>> +
>> +	/* Continue without realm support if we can't agree on a version */
>> +	ret = rmi_check_version();
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = rmi_read_features();
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Note arm64_init_rmi() must be called before kvm_init_rmi() otherwise KVM
>> + * will not support realm guests. subsys_initcall() is called before
>> + * module_init() (used for KVM) so this is OK.
>> + */
>> +subsys_initcall(arm64_init_rmi);
> 
> [Severity: Low]
> Is the implementation of is_rmi_available() missing here?

Short answer: no.

Long answer - the previous patch added the definition and the following
patch adds the implementation. That's clearly wrong and I'll fix it.

Steve

> It is declared for external callers in include/linux/arm-rmi-cmds.h:
> 
> bool is_rmi_available(void);
> 
> However, the corresponding definition appears to be missing from
> drivers/firmware/arm_rmm/rmi.c, which could lead to link-time undefined
> reference errors when another subsystem attempts to use it.
> 

