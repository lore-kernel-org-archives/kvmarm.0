Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658642DCF61
	for <kvmarm@lists.linux.dev>; Wed,  2 Jul 2025 15:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751469569; cv=none; b=CwSZ8tNY6Nv1TyUWux+9D3Xc105aoCXMqCOo4DhuA+jjhKROPpmVmBTD6PLAhRFcmGuvuK8h4WdTZbhInlQ2JgiM9lqwPwKizn9cs6jtLIZ1aBAu6Wsphj/44JER4KHe4X9nOf6rwm2xeBPaKipdJ9ObsqUbPmrUfDeVminzJp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751469569; c=relaxed/simple;
	bh=t0o7OUBNqlm6Mo+ehNNH2G/mv5DjzKEZiM46/9AQDbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcGYc28BUOarlzPX2wxT0KhnOD4IwioHdEHX0TQRgfC5mZ4Hm8a6BBa7iy13S5j5MMXTTuvdJ7BT/cBeKHDdy5qVGYpkg4vj+zdxajT5o/KLoRK/8Pm7SIqolCbiqBtnwcRDVID8M9C95iYXRm2sSE0dI0RueGq5V3TgmBax/DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KdmgSKuu; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KdmgSKuu"
Date: Wed, 2 Jul 2025 08:19:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751469565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EKeTECN1ORQN6w4W35qnCpzz8J9VeyaIGJ8/T9u7m2U=;
	b=KdmgSKuuR/cGi1tIm6Z12BVNq71jsDBLAkDEjfw4y6U9xMZpR9V1E2LrTxWElChGWzBJY3
	HBHNvFdr0KBFW5PpKsOzby05VKenFT5wF2c4xLxJb/dqLS/8nnsTERxR3tgFXJFEVoIlm5
	HcUetfRPz8QmtmYf6T8S+a3iyTgdxKI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Steve Sistare <steven.sistare@oracle.com>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: preserve pending during kvm_irqfd_deassign
Message-ID: <aGVN8_hmeSKdHGfG@linux.dev>
References: <1751467297-201441-1-git-send-email-steven.sistare@oracle.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1751467297-201441-1-git-send-email-steven.sistare@oracle.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 02, 2025 at 07:41:37AM -0700, Steve Sistare wrote:
> When kvm_irqfd_deassign ... -> kvm_vgic_v4_unset_forwarding is called,
> if an interrupt is pending in irq->pending_latch, then transfer it to
> the producer's eventfd.  This way, if the KVM instance is subsequently
> destroyed, the interrupt is preserved in producer state.  If the irqfd
> is re-created in a new KVM instance, kvm_irqfd_assign finds the producer,
> polls the eventfd, finds the interrupt, and injects it into KVM.
> 
> QEMU live update does that: it passes the VFIO device descriptors to the
> new process, but destroys and recreates the KVM instance, without
> quiescing VFIO interrupts.

This *does not work*. Updates to the ITS mapping are non-atomic and a
poorly timed MSI will get dropped on the floor. Or generate an SError if
your system implementer has a sense of humor.

KVM already provides the SAVE_PENDING_TABLES ioctl for saving the
pending state of LPIs to memory which also retrieves the pending state
of vLPIs from hardware. The expectation for this ioctl is that userspace
has already quiesced the interrupt generator.

If userspace can't honor that I don't see a reason for KVM to go out of
the way to forward the pending state, especially considering the fact
that the architecture doesn't support this behavior.

A spurious interrupt doesn't seem that bad here.

> -int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
> +int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq, bool *pending)
>  {
>  	struct vgic_irq *irq;
>  	unsigned long flags;
>  	int ret = 0;
> +	bool direct_msi = vgic_supports_direct_msis(kvm);
>  
> -	if (!vgic_supports_direct_msis(kvm))
> +	if (!pending && !direct_msi)
>  		return 0;

You've broken the early return in case hardware doesn't support GICv4...

>  	irq = __vgic_host_irq_get_vlpi(kvm, host_irq);
> @@ -542,7 +543,13 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
>  
>  	raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  	WARN_ON(irq->hw && irq->host_irq != host_irq);
> -	if (irq->hw) {
> +
> +	if (pending) {
> +		*pending = irq->pending_latch;
> +		irq->pending_latch = false;
> +	}
> +

So this "works" for software-injected LPIs (notice that this function is
for handling *vLPIs*) as KVM's pending state is always the source of
truth. Is that why you're allowing GICv3 to get here now?

This (importantly) doesn't work for hardware vLPIs, as the pending state
is maintained in the vLPI pending table for the vPE.

Overall, I'm not convinced KVM needs to do anything here. We have state
save/restore mechanisms readily available, if userspace wants to go
off-label then it's up to userspace to figure that out.

Thanks,
Oliver
