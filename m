Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 694713DEAE3;
	Fri, 31 Jul 2026 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785504095; cv=none; b=mhLil6l5AeJw/wA07osmmdhgwJhSwRNEoML9OVNksZLnjSuZI3pl21UV49ge2W5LOz/xUKT2LNYS0Vzato9yTWBUm69OoiIDeFkd7Wx5hXuvWeF/e5hCgMhJ+YcTXVhJ/Es3ecyS0GvRwOoY1v7L4iT+K3GIwl8TSAxBg2YvRco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785504095; c=relaxed/simple;
	bh=a8R607Zd+Ysh0+DvB4Rv3NkQEdHP55J1eTeMHHcWJhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HI6I+5yQtKY5NQLuez5bYJdreh/pVj6aByehbH7J+ZkDFcPE7sZMN5kjnJyjeI/8tPjmRqYs9Nfi4iVvwPYjNE0unhfY9E/W1DQKUXasPXaNM/LRJnw7+if6bP0cwZ2WikQ8S18kD7c4z2saia/IweBUJNswxeufn5LncDbKlMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YytOMRlT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YytOMRlT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3FDA204C;
	Fri, 31 Jul 2026 06:21:27 -0700 (PDT)
Received: from [10.57.41.95] (unknown [10.57.41.95])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B00293F7B4;
	Fri, 31 Jul 2026 06:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785504091; bh=a8R607Zd+Ysh0+DvB4Rv3NkQEdHP55J1eTeMHHcWJhg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YytOMRlTwKYJZD2iEI7Yt++9iYWq34vkrxAyM2SHO0tciXiAdnkeGSTlPpqisIix4
	 rvsFviTayww6pLlFab1ELBOENLakfHh6A90OYDhojK1ph6Fj3je8EeB+/Z4767DF46
	 8lhqhiwIP4NMJkV9/nUUEyxwzUmXI9eSxWfmqpDk=
Message-ID: <d383d34e-f38d-4bd1-8221-09f5f0c7df7f@arm.com>
Date: Fri, 31 Jul 2026 14:21:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] firmware: arm_rmm: Configure the RMM with the host's
 page size
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-5-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260715142739.80398-5-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/07/2026 15:27, Steven Price wrote:
> RMM v2.0 brings the ability to set the RMM's granule size. Check the
> feature registers and configure the RMM so that it matches the host's
> page size. This means that operations can be done with a granularity
> equal to PAGE_SIZE.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v14:
>   * Move the implementation into drivers/firmware/arm_rmm.
> Changes since v13:
>   * Moved out of KVM.
> ---
>   drivers/firmware/arm_rmm/rmi.c | 43 ++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
> 
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index c4850976544f..e7ab4a7df3ca 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -76,6 +76,45 @@ static int rmi_read_features(void)
>   	return 0;
>   }
>   
> +static int rmi_configure(void)
> +{
> +	unsigned long ret;
> +	struct rmm_config *config __free(free_page) = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
> +
> +	if (!config)
> +		return -ENOMEM;
> +
> +	switch (PAGE_SIZE) {
> +	case SZ_4K:
> +		config->rmi_granule_size = RMI_GRANULE_SIZE_4KB;
> +		break;
> +	case SZ_16K:
> +		config->rmi_granule_size = RMI_GRANULE_SIZE_16KB;
> +		break;
> +	case SZ_64K:
> +		config->rmi_granule_size = RMI_GRANULE_SIZE_64KB;
> +		break;
> +	default:
> +		BUILD_BUG();
> +	}
> +
> +	/*
> +	 * For now we set the tracking_region_size to 0 which is the only option
> +	 * for 4KB PAGE_SIZE (1GB for 4KB PAGE_SIZE, 32MB/512MB for 16KB/64KB).
> +	 * TODO: Support other tracking sizes via Kconfig option for other
> +	 * PAGE_SIZES
> +	 */
> +	config->tracking_region_size = 0;
> +
> +	ret = rmi_rmm_config_set(virt_to_phys(config));
> +	if (ret) {
> +		pr_err("RMM config set failed\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>   static int __init arm64_init_rmi(void)
>   {
>   	int ret;
> @@ -89,6 +128,10 @@ static int __init arm64_init_rmi(void)
>   	if (ret)
>   		return ret;
>   
> +	ret = rmi_configure();
> +	if (ret)
> +		return ret;
> +

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


>   	return 0;
>   }
>   

