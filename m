Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC703793D2;
	Mon, 21 Sep 2026 09:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983088; cv=none; b=aCbZMqsq8gdY0WGbrwPoXdFgBMAk0x96cXbMRpWXruJPaUnn8YUuFq0SSQMdg95BlOyyWucKUop5JPmIVOvG0heTxhHj98zKUdfHb8roC48XDN67b47pwhI43TJWcPqxdRU69/MrbltYdt5IKGd4ywixsguje201r9YPD9sYn4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983088; c=relaxed/simple;
	bh=24Mm5RiGha3l54zH1CVhHiOwalFID0+iPqIF5C+fNUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dbbC5vR2ESleq49V0wpGR8YS5rdGYFzezsvsbGH6+asB5dB/MKMSDmnsl4K8aT0H9Ip9/99POqAEGNJISVMy5vBqU2tCohwpx/jAAynILpGCcHZkDOpOzMA/0h7osDS9+Im+Citu235m7KaHEh9g3GaLonHK6pLdG5B5o04+cac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NlPTk3IO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NlPTk3IO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA1671476;
	Mon, 21 Sep 2026 02:31:21 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 212273F86F;
	Mon, 21 Sep 2026 02:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789983085; bh=24Mm5RiGha3l54zH1CVhHiOwalFID0+iPqIF5C+fNUI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NlPTk3IOOSsU1M/dT49gvNYmCWXKsvQ/WcsM659NIijSSpRguujMnVpDoOuq6shKE
	 7DxMyAxCc5D5YQFjP7czzHDDYXW7THjKQTx6S8nzWP7dGNXhgrEvbqOjRS9cMUTu5z
	 uVZnNOzinMOlHUVdslBh/XV4hQOVfTeDE9Qi7OTo=
Message-ID: <b84f786e-69d8-4e03-a1ad-15b697bbaab1@arm.com>
Date: Mon, 21 Sep 2026 10:31:20 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 3/7] firmware: arm_rmm: Configure the RMM with the
 host's page size
Content-Language: en-GB
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-4-suzuki.poulose@arm.com>
 <178978126541.2352296.3884730681319176394.b4-review@b4>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <178978126541.2352296.3884730681319176394.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/09/2026 02:27, Jonathan Cameron wrote:
>> RMM v2.0 brings the ability to set the RMM's granule size. Check the
>> feature registers and configure the RMM so that it matches the host's
>> page size. This means that operations can be done with a granularity
>> equal to PAGE_SIZE.
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> One trivial but looks like it is getting quite a few changes from
> Gavin's comments so no tags yet.

...

>> +
>> +	config = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
>> +	if (!config) {
>> +		pr_err("Unable to allocate memory for RMM config\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	config->rmi_granule_size = granule_size;
>> +
>> +	/*
>> +	 * For now we set the tracking_region_size to 0 which is the only option
>> +	 * for 4KB PAGE_SIZE (1GB for 4KB PAGE_SIZE, 32MB/512MB for 16KB/64KB).
>> +	 * TODO: Support other tracking sizes via Kconfig option for other
>> +	 * PAGE_SIZES
>> +	 */
>> +	config->tracking_region_size = 0;
>> +
>> +	ret = rmi_rmm_config_set(virt_to_phys(config));
>> +	if (ret) {
>> +		pr_err("RMM config set failed (%d)\n", ret);
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	free_page((unsigned long)config);
> 
> Maybe some __free() magic is applicable here - would let you just
> return in the error path above making for tidier flow and get
> rid of need to assign ret above.

Ack

Cheers
Suzuki>

