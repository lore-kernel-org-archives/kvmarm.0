Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDE233F8CA
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 05:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780638439; cv=none; b=ngcY76lxu5fhZ/td5seFtS0/k9HWiKeaKSJvqH5rIXiT69NR372e0UTepxPz7KAq+KUP9j9jL1663OcI6R03A6xz77Tls8ODACY8Uc3/R5XT4KHopcUddCXYmt5m5Qz5sSGZ+Ow4wxMASz1ucEGn+i3PQP0Mpqq3dPAEG/HVCE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780638439; c=relaxed/simple;
	bh=EJrWTMTlsBTrzc/8HP5yI+8h9GS5GJiDrpoNxIqHDhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4Gqip6CIgniJkcv30Lm9iR9B8eyisUghxoMI/Epf/3UftPyReDUrdHFaeIzszCS8DJWUcyMn5k3MyHkmzw8zcmgZiTyFs7PtlPp8CsStQqe+sG1l4OIwpiOHlrJUzLAliwXZwpL1CA18J/Cc7MvxZyxluxz5MziXpEUpNCRJiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AuFBoRhv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AuFBoRhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8E51F00893;
	Fri,  5 Jun 2026 05:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780638438;
	bh=YBECq8hGxMiV5GYg2WTDDiWKh1Mo7xpX+0dBxRDeeog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AuFBoRhvZTNxqylPupLSly+NZx6fTXPJhZtnYyqt5unN6Ce0v/3LWIW0q04ulhi0q
	 Dt32z6uFfQFoMfrQ6YNixc1QPXkLoquxLizfYsJLfY2OvKNXaj5WTxPfTM5wOZGZjp
	 qAMHdCXPo4BEMbnyDT3S95IhLjJQpojvXKKlHPdVz7B0DDdh8/etQtKZU65bcmw4RO
	 HcTbcnTPzE0Mrs5I1JdJHXFn9i0nx8cpAAt+gHRwYpjOuRUTEBAUYsaYitFsPvTzAG
	 F8uwlHktChpsWXICPZcv4wKuIblID/krLGGqZmFdmUrGy1eHTxzUU0N1LCzuZy2Rb4
	 yC/P/HHg1lJWQ==
Date: Thu, 4 Jun 2026 22:47:17 -0700
From: Oliver Upton <oupton@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: maz@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, Sascha.Bischoff@arm.com,
	jic23@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: vgic: Use list_del_rcu() when flushing
 pending LPIs
Message-ID: <aiJi5a3JJ-TbWL-s@kernel.org>
References: <aiHrGM1f8czcUby4@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiHrGM1f8czcUby4@v4bel>

Hi Hyunwoo,

On Fri, Jun 05, 2026 at 06:16:08AM +0900, Hyunwoo Kim wrote:
> vgic_v3_fold_lr_state() walks the ap_list from last_lr_irq without holding
> the ap_list_lock, relying on vgic_irq being freed via kfree_rcu() and on
> interrupts being disabled. vgic_flush_pending_lpis() removes entries with
> list_del(), which clobbers a node's next pointer, so when another vCPU
> disables LPIs via GICR_CTLR the walk can follow the clobbered next pointer
> from a removed node, or from the node that last_lr_irq points to.
> 
> Remove entries with list_del_rcu() so that the next pointer stays valid
> until the walk completes.
> 
> Fixes: 3cfd59f81e0f ("KVM: arm64: GICv3: Handle LR overflow when EOImode==0")
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>

Changing only one of the writer paths to use the rculist helpers does
not make the ap_list an rculist. Insertions are not RCU-safe, nor are
deleations from vgic_prune_ap_list().

And TBH, the real bug here is the fact that vgic_v3_fold_lr_state() isn't
taking the ap_list_lock.

Thanks,
Oliver

> ---
>  arch/arm64/kvm/vgic/vgic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 1e9fe8764584d..73efc0f95bfb1 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -204,7 +204,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
>  	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
>  		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
>  			raw_spin_lock(&irq->irq_lock);
> -			list_del(&irq->ap_list);
> +			list_del_rcu(&irq->ap_list);
>  			irq->vcpu = NULL;
>  			raw_spin_unlock(&irq->irq_lock);
>  			deleted |= vgic_put_irq_norelease(vcpu->kvm, irq);
> -- 
> 2.43.0
> 
