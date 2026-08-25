Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788403EEAF4
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649496; cv=none; b=LBTadrlp/1Xme4MGg/2oi+8ER2cnJdIKYR6kUQYgveFz1H+plF3159PQ97YMK2W8A78lm63NtgrnXFU6azEnfyTYnYFIw++K8XTOzZ6I5Zu1AW4CHmA6YW5aRxmQIRFPt45hsPowslaSJhO3YcT1MNZNUkY0ZcdgEvezxq/t+CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649496; c=relaxed/simple;
	bh=BeImJihPuVNllTgMeRpZ2GjjBarQYcejPbBvtEonBcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJp8klbrvnVK9pJB+0emgLqAriKqhDIoKYDDSREJNibjvTiB7AUkwVgH/WVK0/tA7R65kMcdg2nVRKtjOmiuguCXNTaQf3tHbAQbsWltmIpcQAxP28V16+5aKlY3ygd1KMvkd4Q/Op2ssEVxuozNruybB19+LN7ShvbYPFFePfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=N3FW+FpL; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="N3FW+FpL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787649485; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=OIgiI942Y5HV5POfQbnbT8C1D3nW7BAdr8oB7jvmliU=;
	b=N3FW+FpLRTwOyVf25bsnDsP4c06dtbVyNFJqj25BvpKOnOqRiNFQdYGK8RMCytD8tkYR1L8tCyhbBzJEeEcZOg56HNd4b9ugCWRYAv03AGTXffIa+sG5H/3U3cDZMSK4F75EsuYK7kfe7KFxoOqV0g7fYrQCkNUPbQn/NL2LypY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X9dItck_1787649483;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X9dItck_1787649483 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Aug 2026 17:18:04 +0800
Date: Tue, 25 Aug 2026 17:18:02 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Eric Auger <eauger@redhat.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: arm64: vgic: Tear down what vgic_init()
 created when it fails
Message-ID: <te43gnvb2v2zlt3m5gwn2qvden5x3vp23o2qo27uif3ebdrodg@grrfqge2htia>
References: <20260824074245.710955-1-fuad.tabba@linux.dev>
 <20260824074245.710955-4-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824074245.710955-4-fuad.tabba@linux.dev>

On Mon, Aug 24, 2026 at 08:42:44AM +0800, Fuad Tabba wrote:
> Once kvm_vgic_dist_init() has succeeded, every later failure in
> vgic_init() returns with the SPI array still allocated. A failure after
> vgic_v4_init() has also succeeded, which today means only
> kvm_vgic_setup_default_irq_routing(), leaves the vPE array behind as
> well.
>
> A failed vgic_init() leaves kvm_arch_vcpu_precreate() admitting new
> vCPUs, so a retry of KVM_DEV_ARM_VGIC_CTRL_INIT reaches
> vgic_v4_init()'s early return with an array that no longer covers every
> vCPU, and vgic_v3_load()'s WARN_ON(vgic_v4_load()) fires on the first
> one it misses.
>
> Release both on the two paths that can reach them, so the ioctl is all
> or nothing and a retry starts from scratch. dist->nr_spis stays frozen,
> since the SPI count cannot change once vgic_init() has supplied it.
>
> Fixes: 180ae7b11823 ("KVM: arm/arm64: Enable irqchip routing")
> Fixes: 74fe55dc9ab7 ("KVM: arm/arm64: GICv4: Add init/teardown of the per-VM vPE irq domain")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/20260807105558.73D701F000E9@smtp.kernel.org/
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 4012df6002ea6..7493fded53acc 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -462,7 +462,7 @@ int vgic_init(struct kvm *kvm)
>  		if (vgic_supports_direct_irqs(kvm)) {
>  			ret = vgic_v4_init(kvm);
>  			if (ret)

Hi Tabba,

> -				return ret;
> +				goto out_teardown;

The vigc_v4_init already called vgic_v4_teardown() in error path,
thus I think just free dist->spis is enough yet ?

>  		}
>  	} else {
>  		ret = vgic_v5_init(kvm);
> @@ -475,12 +475,19 @@ int vgic_init(struct kvm *kvm)
>
>  	ret = kvm_vgic_setup_default_irq_routing(kvm);
>  	if (ret)
> -		return ret;
> +		goto out_teardown;
>
>  	vgic_debug_init(kvm);
>  	dist->initialized = true;
>
>  	return 0;
> +
> +out_teardown:
> +	vgic_v4_teardown(kvm);
> +	kfree(dist->spis);
> +	dist->spis = NULL;
> +
> +	return ret;
>  }
>
>  static void kvm_vgic_dist_destroy(struct kvm *kvm)
> --
> 2.39.5
>
