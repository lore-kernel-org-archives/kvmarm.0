Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42E423ED6A
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 16:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768234844; cv=none; b=Jown0A1BuDM+VCqnr39ZeLX7/2qz7GniKnGFhGABnja6uBoT8+aH2i++1lLMVquycNFvgX9mVFn0baquaIVtOUWz0+ZRVOsyeYASTda1zNOMcaVCG4j8emeKxnEkphqSQnPmocANQIsmY5kkjyJkV4XL2M7r51PlC/pctkdCFAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768234844; c=relaxed/simple;
	bh=xkLN2L7w4tHtwKB4bLNkl/wMzBWkg8HLsd0gtSWvvEM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LjvOOVu/KVbt3bdCW4OBa7bSVQkjN2kYbHwSnlYm8k/uV4biCZykQNFYA++/IbNohTFTVRESmB1tIpxwMD9okvgUN5oFN0qYyJRCiMjH7rIMobvVd1F9btXJUkG37lfIS0TMOqHxBITlPvBIT4yCw7jILXr3PKBI6TJWLiscdko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=sldR3HrT; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="sldR3HrT"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1d5Rc0+Kuv9IDFedTg1SjWNsjMqHZeOuT+hIBU9nhHY=;
	b=sldR3HrTIWAGi+oNR19/urwfy1QBClv9QNRlcVbqP29cpaiswwSW9ZC4CXihPgaFMeUhwCxc3
	jyIn6pnlee+VPYjZrB8HW3dTXRHDv3K5NCBUu7XOPHnPcGosi9HzIEKgI/ZFjUwLMlwjzcqKSh6
	b4vPozeIy6sr2mLMDUGLwNk=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dqcxW1FyGzMqh8;
	Tue, 13 Jan 2026 00:18:23 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqczl217mzHnGhV;
	Tue, 13 Jan 2026 00:20:19 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 8C42C40569;
	Tue, 13 Jan 2026 00:20:35 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 16:20:34 +0000
Date: Mon, 12 Jan 2026 16:20:33 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v3 24/36] KVM: arm64: gic-v5: Create, init vgic_v5
Message-ID: <20260112162033.000078d5@huawei.com>
In-Reply-To: <20260109170400.1585048-25-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-25-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 17:04:47 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Update kvm_vgic_create to create a vgic_v5 device. When creating a
> vgic, FEAT_GCIE in the ID_AA64PFR2 is only exposed to vgic_v5-based
> guests, and is hidden otherwise. GIC in ~ID_AA64PFR0_EL1 is never
> exposed for a vgic_v5 guest.
> 
> When initialising a vgic_v5, skip kvm_vgic_dist_init as GICv5 doesn't
> support one. The current vgic_v5 implementation only supports PPIs, so
> no SPIs are initialised either.
> 
> The current vgic_v5 support doesn't extend to nested guests. Therefore,
> the init of vgic_v5 for a nested guest is failed in vgic_v5_init.
> 
> As the current vgic_v5 doesn't require any resources to be mapped,
> vgic_v5_map_resources is simply used to check that the vgic has indeed
> been initialised. Again, this will change as more GICv5 support is
> merged in.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Minor patch break up comment below. No need to change unless
maintainers ask for it I think.

Jonathan


> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 60 +++++++++++++++++++++------------
>  arch/arm64/kvm/vgic/vgic-v5.c   | 26 ++++++++++++++
>  arch/arm64/kvm/vgic/vgic.h      |  2 ++
>  include/kvm/arm_vgic.h          |  1 +
>  4 files changed, 68 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 973bbbe56062c..bde5544b58b09 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c

> @@ -418,22 +425,28 @@ int vgic_init(struct kvm *kvm)
>  	if (kvm->created_vcpus != atomic_read(&kvm->online_vcpus))
>  		return -EBUSY;
>  
> -	/* freeze the number of spis */
> -	if (!dist->nr_spis)
> -		dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
> +	if (!vgic_is_v5(kvm)) {
> +		/* freeze the number of spis */
> +		if (!dist->nr_spis)
> +			dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
>  
> -	ret = kvm_vgic_dist_init(kvm, dist->nr_spis);
> -	if (ret)
> -		goto out;
> +		ret = kvm_vgic_dist_init(kvm, dist->nr_spis);
> +		if (ret)
> +			return ret;
>  
> -	/*
> -	 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
> -	 * vLPIs) is supported.
> -	 */
> -	if (vgic_supports_direct_irqs(kvm)) {
> -		ret = vgic_v4_init(kvm);
> +		/*
> +		 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
> +		 * vLPIs) is supported.
> +		 */
> +		if (vgic_supports_direct_irqs(kvm)) {
> +			ret = vgic_v4_init(kvm);
> +			if (ret)
> +				return ret;
> +		}
> +	} else {
> +		ret = vgic_v5_init(kvm);
>  		if (ret)
> -			goto out;
> +			return ret;
>  	}
>  
>  	kvm_for_each_vcpu(idx, vcpu, kvm)
> @@ -441,11 +454,11 @@ int vgic_init(struct kvm *kvm)
>  
>  	ret = kvm_vgic_setup_default_irq_routing(kvm);
>  	if (ret)
> -		goto out;
> +		return ret;
>  
>  	vgic_debug_init(kvm);
>  	dist->initialized = true;
> -out:

It is a bit marginal on whether it is worth the effort but I think
this would been slightly clearer if a precursor patch had dealt with the
early returns.

> +
>  	return ret;

return 0;

Always nice to be explicit when it is a good exit path.

>  }
>  


