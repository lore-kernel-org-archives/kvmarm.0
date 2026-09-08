Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B6B318ECD;
	Tue,  8 Sep 2026 09:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861534; cv=none; b=n7sEi4MuR/Gjlx93J816F84xV1wg7/BJcN6LfQ8EskRuXA/AzJUTlppBEIrgbzNO2xm36+cKgoXE0lMOPeljjLFh85J3a1Ql5yClCLq+5OZ4c3DRW3ri0PDB0KtfeK87PElH8wqaPsmvnBnD0Kdr5Dr47qDCqxBz6sIqmq99GfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861534; c=relaxed/simple;
	bh=jdnp6yNqPjuDCTZ+RGAlpGfNOV6nfvpIMc/1hdBGUQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lVTUkrTjmVIYGD6qaaE9PnXMc9l/NXnovGjUTfNmE7QHmDvjyU8VE6niPMu3db4Zp2iv5nTKYpUImFtVEusoTsC4b8Seaqj46Jm25F8B/aQtmutClrYo2X8Dn274Tg4NMloaA4+noW1p6ZxEBXrRaqUalDOdgtAkXN2S+DZV6r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DDvRzddx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DDvRzddx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F18351476;
	Tue,  8 Sep 2026 02:58:47 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B196C3F7B4;
	Tue,  8 Sep 2026 02:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788861531; bh=jdnp6yNqPjuDCTZ+RGAlpGfNOV6nfvpIMc/1hdBGUQw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DDvRzddxJnPw2f0IFLFoxSgXh24ClydmrJHFPyrh/cBNVdqciUx47xj3duG8dJxC1
	 FpeYXa6tw4fPaI6VUwJHlg6I2xijFxXC1vsj0zRlXgQ0Hpqa386Y6cLO3vE/lXgyOh
	 ycmYEUsOILGyM3onZ+KubYqEHq2d9AyTKTPmEEPg=
Message-ID: <958eee79-c776-4c63-92c5-743d9aa5ea52@arm.com>
Date: Tue, 8 Sep 2026 10:58:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 3/7] firmware: arm_rmm: Configure the RMM with the
 host's page size
To: Gavin Shan <gshan@redhat.com>, sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-4-suzuki.poulose@arm.com>
 <20260907101446.1DA321F00A3A@smtp.kernel.org>
 <bade4920-2db1-4a8a-99d1-ca2694647ec8@arm.com>
 <64533fd0-5fe7-4839-8302-c5b6674bcb5a@redhat.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <64533fd0-5fe7-4839-8302-c5b6674bcb5a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 07/09/2026 23:40, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 9/7/26 10:02 PM, Suzuki K Poulose wrote:
>> On 07/09/2026 11:14, sashiko-bot@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found 2 potential 
>>> issue(s) to consider:
>>> - [High] The SMC call leaves parameters X2-X7 uninitialized, 
>>> violating the RMM's RES0 requirement.
>>> - [High] The `struct rmm_config` fields are populated using native 
>>> endianness, which breaks on Big Endian kernels.
>>> -- 
>>>
>>> commit 1741e17729c2ff5e23bc8bfb00cc50a61f38ebb7
>>> Author: Steven Price <steven.price@arm.com>
>>> firmware: arm_rmm: Configure the RMM with the host's page size
>>>
>>> This commit adds support to configure the RMM's granule size to match 
>>> the
>>> host's page size during kernel initialization. It reads the feature
>>> registers to ensure the requested page size is supported and sends the
>>> configuration to the RMM via an SMC call.
>>>
>>>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ 
>>>> arm_rmm/rmi.c
>>>> index 008a783407b4e..76f91c145e1fd 100644
>>>> --- a/drivers/firmware/arm_rmm/rmi.c
>>>> +++ b/drivers/firmware/arm_rmm/rmi.c
>>>> @@ -77,6 +77,60 @@ static int rmi_read_features(void)
>>>>       return 0;
>>>>   }
>>>> +static int rmi_configure(void)
>>>> +{
>>>> +    unsigned long granule_feature;
>>>> +    unsigned long granule_size;
>>>> +    int ret = 0;
>>>> +    struct rmm_config *config;
>>>> +
>>>> +    switch (PAGE_SIZE) {
>>> [ ... ]
>>>> +
>>>> +    config = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
>>>> +    if (!config)
>>>> +        return -ENOMEM;
>>>> +
>>>> +    config->rmi_granule_size = granule_size;
>>>> +
>>>> +    /*
>>>> +     * For now we set the tracking_region_size to 0 which is the 
>>>> only option
>>>> +     * for 4KB PAGE_SIZE (1GB for 4KB PAGE_SIZE, 32MB/512MB for 
>>>> 16KB/64KB).
>>>> +     * TODO: Support other tracking sizes via Kconfig option for other
>>>> +     * PAGE_SIZES
>>>> +     */
>>>> +    config->tracking_region_size = 0;
>>>
>>> [Severity: High]
>>> Does this code handle endianness correctly?
>>>
>>> The struct rmm_config fields are populated using native u64 assignments.
>>> On an ARM64 kernel compiled with CONFIG_CPU_BIG_ENDIAN=y, this writes
>>> big-endian bytes into the shared memory. The RMM, which runs in 
>>> little-endian
>>> at EL2, will misinterpret these fields.
>>>
>>> Will this cause the RMM firmware to read invalid configuration values 
>>> (like a
>>> byte-swapped granule size) and fail to configure, breaking RMI 
>>> support on Big
>>> Endian systems?
>>>
>>
>> We don't plan to support RMM for Big Endian Linux. I have now made the 
>> ARCH_SUPPORTS_RMM to depend on !CPU_BIG_ENDIAN
>>
> 
> You probably need to avoid referring to CPU_BIG_ENDIAN as it's being 
> dropped
> by PATCH[v2 13/14] in Will's series to removed unused big-endian support on
> arm64 [1].
> 
> [1] [PATCH v2 00/14] arm64: Remove unused big-endian support
>      (https://lore.kernel.org/linux-arm-kernel/20260907163726.17104-14- 
> will@kernel.org/)

Thanks for the heads up, I will just ignore this one from Sashiko.

Cheers
Suzuki


> 
> Thanks,
> Gavin
> 
>>>> +
>>>> +    ret = rmi_rmm_config_set(virt_to_phys(config));
>>>> +    if (ret) {
>>>> +        pr_err("RMM config set failed\n");
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +
>>>> +    free_page((unsigned long)config);
>>>> +    return ret;
>>>> +}
>>> [ ... ]
>>>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi- 
>>>> cmds.h
>>>> index 2fb1f7f86d71e..9aa27697e2377 100644
>>>> --- a/include/linux/arm-rmi-cmds.h
>>>> +++ b/include/linux/arm-rmi-cmds.h
>>>> @@ -12,6 +12,23 @@
>>>>   unsigned long rmi_feat_reg(unsigned long id);
>>>> +/**
>>>> + * rmi_rmm_config_set() - Configure the RMM
>>>> + * @cfg_ptr: PA of a struct rmm_config
>>>> + *
>>>> + * Sets configuration options on the RMM.
>>>> + *
>>>> + * Return: RMI return code
>>>> + */
>>>> +static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
>>>> +{
>>>> +    struct arm_smccc_res res;
>>>> +
>>>> +    arm_smccc_1_1_invoke(SMC_RMI_RMM_CONFIG_SET, cfg_ptr, &res);
>>>
>>> [Severity: High]
>>> Does this SMC call leave parameters x2 through x7 uninitialized?
>>>
>>> The arm_smccc_1_1_invoke macro only generates inline assembly 
>>> constraints
>>> for the explicitly provided arguments. It does not zero-pad omitted 
>>> arguments,
>>> leaving registers x2 through x7 with whatever was previously in them.
>>>
>>> Since the RMM firmware expects unused SMC parameters to be zero (RES0),
>>> could passing uninitialized values cause the RMM to reject the command
>>> with an INVALID_PARAMETER error and sporadically break RMM 
>>> initialization?
>>
>> Correct, I have now moved all RMI calls to smccc_1_2, making sure that
>> all the undefined arguments are initialised to 0.
>>
>> Cheers
>> Suzuki
>>
>>
>>>
>>>> +
>>>> +    return res.a0;
>>>> +}
>>>
>>
>>
> 

