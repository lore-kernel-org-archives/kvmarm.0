Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EF521255A
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 06:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777012387; cv=none; b=RnKazANmz8S+YqSGtBAOI+l3PZRJwF6WJWgn9CgCOze5PjZUfBiuSUZqLcJBX3VUVnIpdkDs8wyVik2XgfY6liQmcvgkUHZSh0w/j7D5wf1nU7cgAd298nOYBEL/Rbrp1qp3Grpanez8tywM+glR6bV55DK4+WRJ3chRB6DQI10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777012387; c=relaxed/simple;
	bh=VUti+d2oQSkK3/3QW2T0jSVT1cUqOwu5je1JaFoYl94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxcG1OcK2VJh8a3m9s+4UQ+87AvWWydrhIhbEvFKVU7eZMoM6Lln3XI4V2PCPTEJaGwxMDlXVPezoUa5SxeMqZ50PdbGPShJklx9NqO+nbizMcOyOelX0+kI83rfkGiaA+wXQHdU9YX1kYOG6FHWyq+ERwAtV0YqRz+M6Ibn0ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=of8YU6oj; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="of8YU6oj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777012383; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=8SDLGP7xfTuvBLKrkgTFGSV6/ELHlpEZ9aT6DGRWRtY=;
	b=of8YU6ojHLXJviM9o6fImiAopGof2pVIVKxai6fpj3a34HdJLOrO/6fw3jRL8EOATyFUNVbTXfNUeYlB5hJhpiZPe5Ur94t/jPf9qGxjUS3C2CdbsPMdoKXhSZ+GEnxlqypXNgqpFjswnD7iRasge0dzas2W3v/ZKZ1C0EERuis=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X1bjMlB_1777012382;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X1bjMlB_1777012382 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Apr 2026 14:33:02 +0800
Date: Fri, 24 Apr 2026 14:33:02 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Wake-up from WFI when iqrchip is in userspace
Message-ID: <uhqgyol622go4lm5btbk4jyieb3swhskpkyel4mnksfeki2mo2@ecnjvxwiqcfw>
References: <20260423163607.486345-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423163607.486345-1-maz@kernel.org>

On Thu, Apr 23, 2026 at 05:36:07PM +0800, Marc Zyngier wrote:
> It appears that there is nothing in the wake-up path that
> evaluates whether the in-kernel interrupts are pending unless
> we have a vgic.
>
> This means that the userspace irqchip support has been broken for
> about four years, and nobody noticed. It was also broken before
> as we wouldn't wake-up on a PMU interrupt, but hey, who cares...
>
> It is probably time to remove the feature altogether, because it
> was a terrible idea 10 years ago, and it still is.
>
> Fixes: b57de4ffd7c6d ("KVM: arm64: Simplify kvm_cpu_has_pending_timer()")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 176cbe8baad30..8bb2c7422cc8b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -824,6 +824,10 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
>  	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF | HCR_VSE);
>

Hi Marc,

> +	irq_lines |= (!irqchip_in_kernel(v->kvm) &&
> +		      (kvm_timer_should_notify_user(v) ||
> +		       kvm_pmu_should_notify_user(v)));

How about a new helper like 'kvm_should_notify_us_irqchip()' ?
We can replace the same part at beginning of kvm_vcpu_exit_request() and
here w/ unlikely().

> +
>  	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
>  		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
>  }
> --
> 2.47.3
>
