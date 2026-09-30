Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD996470EA1;
	Wed, 30 Sep 2026 09:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759561; cv=none; b=eczlaus8A046XCKJq3LthUWhxLE7ndJt5lYzp3cuJ5kYYMLitNczjwyrloNt4l2XL9CU3/O6yukw5pcIhiCWKsqrod+6f9XvrhiDxA78Se/0yXQRhApEUqcCDnkNtAHO850itnoVhs0ebaRGJ1EdAGOrwXatddDBgMvYeeGcZeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759561; c=relaxed/simple;
	bh=5wUMLjbpUp7hbWm3itPpbabvQ22t6nYyy/JKeslxhqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bO5M4vY3PreXXSYLIv8UUpCiKiv8TzeSpntHXGhdhGI67ukOpyad1Khf7lDM8F/zXqr6/3H/mA5lGCDaoXwtjo0xqnc2DZrMLugKyYWsPYOfXPeGRv/CwNUh4/SmqMq/jgMTQLIaMJAx4voYHH8Q4iCSDjIXlblOcxDvoE7BEgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oC/hiUWT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oC/hiUWT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BE5A497;
	Wed, 30 Sep 2026 02:12:35 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D2423F86F;
	Wed, 30 Sep 2026 02:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790759559; bh=5wUMLjbpUp7hbWm3itPpbabvQ22t6nYyy/JKeslxhqc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oC/hiUWTuvNjj19hTmLuXbyubzGAMMjiF2MqLfmEGGUB42pJtNd/c8CU20jjE8Ken
	 JMXGNvdqqNw+68IE+U/D8SnF3qv+u/Qpz525D2SEDHBW2Zpx8yar53B23gKOM10yZB
	 cr3kvg5IQVlwnNl7cGDeNtyymCcw4b/mTbdtj52Y=
Message-ID: <8e02fe1d-2011-47f0-97a6-c34d730dee6c@arm.com>
Date: Wed, 30 Sep 2026 10:12:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 7/9] arm64: Block hibernate and kexec while RMM is
 active
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-8-suzuki.poulose@arm.com>
 <20260929222639.997731F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260929222639.997731F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/09/2026 23:26, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] arm64: hibernation resume blind copy triggers GPF when RMM is active
> --
> 
> commit cd33ba7dfabdc9882b5491e3f0d6693b247f8326
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> arm64: Block hibernate and kexec while RMM is active
> 
> RMM can be deactivated only after all delegated granules have been
> reclaimed. If a new kernel is entered while any granules remain in the
> Realm PAS, accesses to that memory can raise a Granule Protection Fault
> and be fatal to the new kernel.
> 
>> diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
>> index 424291c547f02..253f544a59731 100644
>> --- a/arch/arm64/kernel/hibernate.c
>> +++ b/arch/arm64/kernel/hibernate.c
> 
> [ ... ]
> 
>> @@ -341,6 +342,11 @@ int swsusp_arch_suspend(void)
>>   		return -EBUSY;
>>   	}
>>   
>> +	if (is_rmm_active()) {
>> +		pr_err("Can't hibernate: RMM is active.\n");
>> +		return -EBUSY;
>> +	}
>> +
> 
> [Severity: High]
> While this successfully prevents saving a hibernation image, is there a missing
> check in the resume path, specifically arch_hibernation_header_restore() in
> arch/arm64/kernel/hibernate.c?
> 
> If a hibernation image is present on disk (e.g., from a prior boot with RMM
> disabled, but with a matching uts_version), subsys_initcall(arm64_init_rmi)
> activates RMM and delegates memory to the Realm PAS early in boot.
> 
> Later, late_initcall_sync(software_resume_initcall) restores the image.
> Because arch_hibernation_header_restore() lacks an is_rmm_active() check,
> the image is accepted. The low-level resume path swsusp_arch_resume() then
> blindly overwrites physical memory with the saved image.
> 
> Without an upstream guard during resume, won't this overwrite newly delegated
> Realm PAS memory, triggering a fatal Granule Protection Fault?

That is a valid point, I have added a check there to bail out if the rmm
is active.

Suzuki

> 
>>   	flags = local_daif_save();
>>   
>>   	if (__cpu_suspend_enter(&state)) {
> 

