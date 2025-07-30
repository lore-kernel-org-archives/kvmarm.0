Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF472343C7;
	Wed, 30 Jul 2025 14:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753886119; cv=none; b=bGN3J9aih8uWBdhTOYKs9XFQ2wOqaRo64ZlbQSFAiuMUWgUsVi0yqoZJlPAtBQpF6pGAH++QiYK+j7RNITwYetGOAprNfH40G+wc51fiRDjCSdeEv36JPJt1jCsQ/g5/JtR1bV7nCEczwjCliKWhy1EwsTTTep3qsCJsyZyfkU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753886119; c=relaxed/simple;
	bh=KX9gky5b66eICbQ0UiZw3jTma9kJ/uimQoSGy09Y554=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tSVPUqpvRDKCFdf10YyCP31W+ingi/GjTyDjNKUdpwb1aEYDQo7sDLM9JgblOBcz4xBItTHnL8u3NJCcM4B6dwXL3BgH6FulAsTbyBxWpAymJbplXQNkVd7M1DfObMh7JwlGYT5zTjdRCeiqgb3c0DYE/gwrZhiSvepihEIrQlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=HKBSTtuz; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="HKBSTtuz"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=V4VzUm4zcB95VkurnMS1za6yWaYSay+dQ+3Hi8qJDuM=;
	b=HKBSTtuzFdIanTfuhOsFeGOSLmYVsWUE41QHkn8zXLZs/UdFZieK/WTSKGhb/KngdNlsDOo/2
	v90rSbM2uhWR9+cJygGBmHFgIZKlfNZ46XqWq/s5dk+4tsMpKe57zvxKi6+LAT2Coh2p8jDjq5G
	fFMairtdXGK12fYQJwH4Ilg=
Received: from frasgout.his.huawei.com (unknown [172.18.146.37])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4bsZTT4vDSz1P7Hb;
	Wed, 30 Jul 2025 22:33:49 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bsZQ82bphz6GD84;
	Wed, 30 Jul 2025 22:30:56 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 77D00140393;
	Wed, 30 Jul 2025 22:35:09 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 30 Jul
 2025 16:35:08 +0200
Date: Wed, 30 Jul 2025 15:35:06 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
CC: <linux-coco@lists.linux.dev>, <kvmarm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <aik@amd.com>,
	<lukas@wunner.de>, Samuel Ortiz <sameo@rivosinc.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Suzuki K
 Poulose" <Suzuki.Poulose@arm.com>, Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 26/38] KVM: arm64: Add exit handler related to
 device assignment
Message-ID: <20250730153506.00006280@huawei.com>
In-Reply-To: <20250728135216.48084-27-aneesh.kumar@kernel.org>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
	<20250728135216.48084-27-aneesh.kumar@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Mon, 28 Jul 2025 19:22:03 +0530
"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:

> Different RSI calls related to DA result in REC exits. Add a facility to
> register handlers for handling these REC exits.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>


> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
> index c6e16ab608e1..a5ef68b62bc0 100644
> --- a/arch/arm64/include/asm/rmi_smc.h
> +++ b/arch/arm64/include/asm/rmi_smc.h

> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
> index 1a8ca7526863..25948207fc5b 100644
> --- a/arch/arm64/kvm/rme-exit.c
> +++ b/arch/arm64/kvm/rme-exit.c


> +static int rec_exit_dev_mem_map(struct kvm_vcpu *vcpu)
> +{
> +	int ret;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	if (realm_exit_dev_mem_map_handler) {
> +		ret = (*realm_exit_dev_mem_map_handler)(rec);
> +	} else {
> +		kvm_pr_unimpl("Unsupported exit reason: %u\n",
> +			      rec->run->exit.exit_reason);
> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		ret = 0;

I guess maybe this gets more complex later, but right now
		return 0;

And maybe return in the if branch as well.
Same for other similar code in this patch.

> +	}
> +	return ret;
> +}
> +
>  static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>  {
>  	struct realm_rec *rec = &vcpu->arch.rec;
> @@ -198,6 +252,12 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
>  		return rec_exit_ripas_change(vcpu);
>  	case RMI_EXIT_HOST_CALL:
>  		return rec_exit_host_call(vcpu);
> +	case RMI_EXIT_VDEV_REQUEST:
> +		return rec_exit_vdev_request(vcpu);
> +	case RMI_EXIT_VDEV_COMM:
> +		return rec_exit_vdev_communication(vcpu);
> +	case RMI_EXIT_DEV_MEM_MAP:
> +		return rec_exit_dev_mem_map(vcpu);
>  	}
>  
>  	kvm_pr_unimpl("Unsupported exit reason: %u\n",

