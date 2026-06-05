Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037C83A5E88
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 06:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780639240; cv=none; b=jloPmUIlpuWPP71xJAeoBwUAZ8MJeMMNkjKSg4B2HXidhT48PVKkzyloO7e/PaK5Q8lSdsEi1j6fM75p50GAcvJCmbuQ3gkpdUVmo1K3XD6D432UHnWuseayzryIPoNxmH6GdJPDHRqfLU1DwllGX1eSU5BCUZzq2LurMvNHWQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780639240; c=relaxed/simple;
	bh=fVwujMcYcmaLdm9Ue8iN6PqhjiKWWJjIod87RSxmz9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUBZSPdHUX7TcOqJ4rqmxPoyPZWtDOa2UyR1iZ67bRVof0r07ndK8UaQgAbiJaCvptok8DIrGG4PxQmMbzT+U55TVxfLv8UuIwAOXr8m/JJqAymfFeQkXnTnMqCpePeX/ZDX5wnVOdDTyWzMalsiYhu7W8e7zAdzeXgS0zIJBIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nKSoFLFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nKSoFLFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6386D1F00893;
	Fri,  5 Jun 2026 06:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780639238;
	bh=gaVHoAOUI9LUISZtbViLuvlWXQydHijJv4Tcvcf97rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nKSoFLFzxN7azm4Cn4DB97IsmJ329/dL9s6fwzI/OROBryOO4b9sSxhniPBS+r3tH
	 FI6ruK1wwV90ZNmCPSgMIO4Yj5fjDAGj+pAN/mJ6pWU7Chtn7WS8D6P9lkxoqryFfn
	 16KL+uGoht8P9hNHncLU28eYrctOiWHlnkC1WfHeJS4yEgePP/dy4h//500BKoTXKR
	 pOTx3HWlNXlQJj7dbcD9eDeubitAzbja40z4eU7arQJ37v6YdEYv7/rfbwNd/ywVCx
	 n6aOxaIsv+eW4Cl11ECaTz0FqA1PIdKj5EZgm+hibSgpWllBzu/EmfgKGhmkkMM1b7
	 LlRcJyf1o1N2w==
Date: Thu, 4 Jun 2026 23:00:37 -0700
From: Oliver Upton <oupton@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: maz@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, Sascha.Bischoff@arm.com,
	jic23@kernel.org, timothy.hayes@arm.com, eric.auger@linaro.org,
	christoffer.dall@linaro.org, andre.przywara@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: vgic: Check the interrupt is still ours
 before migrating it
Message-ID: <aiJmBfXAxcytfGha@kernel.org>
References: <aiHnI1mu6SGQrgnz@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiHnI1mu6SGQrgnz@v4bel>

On Fri, Jun 05, 2026 at 05:59:15AM +0900, Hyunwoo Kim wrote:
> vgic_prune_ap_list() drops both ap_list_lock and irq_lock while migrating
> an interrupt to another vCPU. After reacquiring the locks it only checks
> that the affinity is unchanged (target_vcpu == vgic_target_oracle(irq))
> before moving the interrupt, which assumes that an interrupt whose affinity
> is preserved is still queued on this vCPU's ap_list.
> 
> That assumption no longer holds if the interrupt is taken off the ap_list
> while the locks are dropped. vgic_flush_pending_lpis() removes the
> interrupt from the list and sets irq->vcpu to NULL, but leaves
> enabled/pending/target_vcpu untouched. As the interrupt is still enabled
> and pending, vgic_target_oracle() returns the same target_vcpu, so the
> affinity check passes and list_del() is run a second time on an entry that
> has already been removed.
> 
> Also check that the interrupt is still assigned to this vCPU
> (irq->vcpu == vcpu) before moving it.
> 
> Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>

Looking at this and the other VGIC patch you sent (which should've been
a combined series), are you trying to deal with a vCPU writing to
another vCPU's redistributor? I.e. vCPU B setting GICR_CTLR.EnableLPIs=0
behind the back of vCPU A?

That is extremely relevant information as the off-the-cuff reaction is
that no race exists. But since the GIC architecture is awesome and
allows for this sort of insanity, it obviously does....

Anyway, for LPIs resident on a particular RD, there's zero expectation
that the pending state is preserved when EnableLPIs=0. So I'd rather
vgic_flush_pending_lpis() just invalidate the pending state.

Beyond that, I see two other fixes for lifetime issues around the
vgic_irq in the middle of migration. I'd like to see explicit RCU
protection around the release && reacquire of the ap_list_lock rather
than depending on the precondition that IRQs are disabled.

Then vgic_flush_pending_lpis() should leave IRQs intact that are pending
a migration (e.g. irq->vcpu != vgic_target_oracle()) as the only expectation
we need to uphold is that LPIs resident on the RD have the pending state cleared.

Although I think we could benefit from the wetware implementation of the
GIC giving this a once over too. Any thoughts Marc?

Thanks,
Oliver

> ---
>  arch/arm64/kvm/vgic/vgic.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 1e9fe8764584..18b280de9a29 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -818,15 +818,16 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>  		raw_spin_lock(&irq->irq_lock);
>  
>  		/*
> -		 * If the affinity has been preserved, move the
> -		 * interrupt around. Otherwise, it means things have
> -		 * changed while the interrupt was unlocked, and we
> -		 * need to replay this.
> +		 * If the interrupt is still ours and its affinity has
> +		 * been preserved, move it around. Otherwise, it means
> +		 * things have changed while the interrupt was unlocked
> +		 * (it may even have been taken off the list with its
> +		 * affinity left untouched), and we need to replay this.
>  		 *
>  		 * In all cases, we cannot trust the list not to have
>  		 * changed, so we restart from the beginning.
>  		 */
> -		if (target_vcpu == vgic_target_oracle(irq)) {
> +		if (irq->vcpu == vcpu && target_vcpu == vgic_target_oracle(irq)) {
>  			struct vgic_cpu *new_cpu = &target_vcpu->arch.vgic_cpu;
>  
>  			list_del(&irq->ap_list);
> -- 
> 2.43.0
> 
