Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928E821767A
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508824; cv=none; b=lDf+vvnt44arxC8jLVhnU2bohpyDt7CjlnLSRZG04WdrLe8GClqMJmRxhkZ1t1O78GOeFD7nuCe7T7gDWT+CVwLkf60W73d/GfM6Ux0wgGBEtN/wlg2xiBAmo9e3//aYE+Ch8umhtsqiHgy50cfhHgvgBxcsp76LX6UX/j6Qr/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508824; c=relaxed/simple;
	bh=87KbeUDC086xK3vwBHs6OA0WyR0B/Lbo3zUF1nkQT+s=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gZbA8HIxxUCTtL4LGR1TG5p+P1K9aDavq1lQxHlJa0eQk7Pxwt/cbV3QRRRmNh+5YdRsfmZbG6Osco3P6fJHTeEW8140WLiuvYoaVEjm1hsQfnM8XafZYLTaeCGataTKjzODq4jyti3oKB+a9tGK+hArv6gMhGvB1f6EMjwT5UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=08TkMe4/; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="08TkMe4/"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7ViXpDmjjn84t/fsQSR4CUyAyQ/ZlPBnvISMyPLIwoY=;
	b=08TkMe4/5IVB0NR7PsszyZwlGmmNCNMGJx4bAlxq/L1hRawfrJZ9qezhq6gbQfv2N4k86APCX
	tlBJi85SjJeOZ8UmB/Nu1xSa9SDMUGpVnccII1eeTrDFYbHX6tCVJNnlyv6g4vdk+WPQEJl+qxw
	W3LyVWW9HY45BJnaPA3hG1I=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4d2vLt0p10z1T4G5;
	Fri,  7 Nov 2025 17:45:42 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 75274180B65;
	Fri,  7 Nov 2025 17:46:58 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 7 Nov 2025 17:46:57 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Reinstate IRQ lock ordering for LPI
 xarray
To: Oliver Upton <oupton@kernel.org>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20251107012944.1708811-1-oupton@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d0853e82-7d95-5025-7abf-c6f1e0cdf7b5@huawei.com>
Date: Fri, 7 Nov 2025 17:46:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251107012944.1708811-1-oupton@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200017.china.huawei.com (7.202.194.83)

Hi Oliver,

On 2025/11/7 9:29, Oliver Upton wrote:
> Zenghui reports that running a KVM guest with an assigned device and
> lockdep enabled produces an unfriendly splat due to an inconsistent irq
> context when taking the lpi_xa's spinlock.
> 
> This is no good as in rare cases the last reference to an LPI can get
> dropped after injection of a cached LPI translation. In this case,
> vgic_put_irq() will release the IRQ struct and take the lpi_xa's
> spinlock to erase it from the xarray.
> 
> Reinstate the IRQ ordering and update the lockdep hint accordingly. Note
> that there is no irqsave equivalent of might_lock(), so just explictly
> grab and release the spinlock on lockdep kernels.
> 
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Closes: https://lore.kernel.org/kvmarm/b4d7cb0f-f007-0b81-46d1-998b15cc14bc@huawei.com/
> Fixes: 982f31bbb5b0 ("KVM: arm64: vgic-v3: Don't require IRQs be disabled for LPI xarray lock")
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c |  2 +-
>  arch/arm64/kvm/vgic/vgic-its.c  |  7 ++++---
>  arch/arm64/kvm/vgic/vgic.c      | 23 +++++++++++++++--------
>  3 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 1796b1a22a72..7208776ba4bf 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -53,7 +53,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  
> -	xa_init(&dist->lpi_xa);
> +	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
>  }
>  
>  /* CREATION */
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index ce3e3ed3f29f..f162206adb48 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -78,6 +78,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  	struct vgic_irq *irq = vgic_get_irq(kvm, intid), *oldirq;
> +	unsigned long flags;
>  	int ret;
>  
>  	/* In this case there is no put, since we keep the reference. */
> @@ -88,7 +89,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>  	if (!irq)
>  		return ERR_PTR(-ENOMEM);
>  
> -	ret = xa_reserve(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
> +	ret = xa_reserve_irq(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
>  	if (ret) {
>  		kfree(irq);
>  		return ERR_PTR(ret);
> @@ -103,7 +104,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>  	irq->target_vcpu = vcpu;
>  	irq->group = 1;
>  
> -	xa_lock(&dist->lpi_xa);
> +	xa_lock_irqsave(&dist->lpi_xa, flags);
>  
>  	/*
>  	 * There could be a race with another vgic_add_lpi(), so we need to
> @@ -125,7 +126,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>  	}
>  
>  out_unlock:
> -	xa_unlock(&dist->lpi_xa);
> +	xa_unlock_irqrestore(&dist->lpi_xa, flags);
>  
>  	if (ret)
>  		return ERR_PTR(ret);
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 6dd5a10081e2..8d20c53faef0 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -28,7 +28,7 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
>   *     kvm->arch.config_lock (mutex)
>   *       its->cmd_lock (mutex)
>   *         its->its_lock (mutex)
> - *           vgic_dist->lpi_xa.xa_lock
> + *           vgic_dist->lpi_xa.xa_lock		must be taken with IRQs disabled
>   *             vgic_cpu->ap_list_lock		must be taken with IRQs disabled
>   *               vgic_irq->irq_lock		must be taken with IRQs disabled

There are still some places where lpi_xa.xa_lock is taken with IRQs
enabled:

	iter_mark_lpis()/xa_set_mark()
	iter_unmark_lpis()/xa_clear_mark()

Another point (unrelated to this patch) is that the error path in
vgic_add_lpi() would probably result in bad thing:

|	xa_lock_irqsave(&dist->lpi_xa, flags);
|
|	[ trimmed ]
|	if (ret) {
|		xa_release(&dist->lpi_xa, intid);

... as xa_release() takes the xa_lock again.

Thanks,
Zenghui
