Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EA85208D3
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 21:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790805012; cv=none; b=MHGdIME/FpYrD6NVWDfBvi2IKb8MJ+C/gkd1YVysfG3MrjctJsVF693nVj1X/+E/T7vpZcQnOaH9r1hIWhDtyHGcAuNFKrJnbrmgItDmF0T/AY/OnBglUg/bmnVIyWViD1T58cpUPWaPO2Nf36+l6H9mMAEX+jD6Ov9SmPAo5so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790805012; c=relaxed/simple;
	bh=HWSx/0kmFmqBiVkMXRBDxizL6eAdA8rFiTz4r3GckCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asw+jze6bc5RcXx4HBPwJerOrqyvKklvp1JnLCN5wZQexdpI9V/5vyV1wp5ZwA9MMgjkf+4xq+N/mP/BDUF0gjxWvy1C4CMfHgicpQ7cTmU8X4k4WHhIn5Yp9ubC7fxd7RGHQjHNguRnPBDvqwReObpIddEaeXZIiBeue2msEjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltVqwy9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltVqwy9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2D11F000FF;
	Wed, 30 Sep 2026 21:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790805011;
	bh=2GsP3pJyvB400e7ZuwPUUZ06KcLsJW0RexifZoiUaus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ltVqwy9b35hsVvROVrS324uFsXsn2Mt5XOOe6r2dPdofA/eXJa2ICmgrr1dU+y3w8
	 q24UxxjzO6LdTEzTexA0fTXX+60DciZrvA9YtnpGCfXQO01RtMIHwc7P78RmQTDd9N
	 S+yeJd5+5G2bDOnCE9PsSeIS8/uLCWM9Mzf7INYMZiYFVfE6CMyAyBMYti3xauQ1JJ
	 X9EDKMhd4zFDXOjK8cvzcsJYgdp94XUsYYNYBH4foAx6HLP4pFWzgqrEGnHFQ0nSqH
	 rZ+fo+12Tf2hz4T8Xw/tGsy+NNzPPIjqolW5JGVFhcQwKPQDpZAoUymKK1FFyzeBUb
	 UVZh08AHhg8gQ==
Date: Wed, 30 Sep 2026 14:50:09 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 2/4] KVM: arm64: vgic: Move IRQ migrations out of
 vgic_prune_ap_list()
Message-ID: <ar2EETL_kXHwFx_L@kernel.org>
References: <20260929212925.31775-1-oupton@kernel.org>
 <20260929212925.31775-3-oupton@kernel.org>
 <CA+EHjTxu=rQ1Wz8QpGpMsMyw0NGU35qw6J12ZH07XeCwae5e9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxu=rQ1Wz8QpGpMsMyw0NGU35qw6J12ZH07XeCwae5e9Q@mail.gmail.com>

Hi Fuad,

thanks for the review

On Wed, Sep 30, 2026 at 02:55:04PM +0100, Fuad Tabba wrote:
> Hi Oliver,
> 
> On Tue, 29 Sep 2026 22:29:23 +0100, Oliver Upton <oupton@kernel.org> wrote:
> [...]
> > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> [...]
> > +void __vgic_update_irq_affinity(struct kvm *kvm, struct vgic_irq *irq,
> > +                                struct kvm_vcpu *old, struct kvm_vcpu *new,
> > +                                u32 data)
> [...]
> > +        /* Fire! */
> > +        kvm_pause_vcpu(tmp);
> > +
> > +        scoped_guard(raw_spinlock_irqsave, &tmp->arch.vgic_cpu.ap_list_lock) {
> > +                scoped_guard(raw_spinlock, &irq->irq_lock) {
> > +                        /*
> > +                         * The IRQ could've been moved to another AP list after
> > +                         * dropping the irq_lock. Make sure it's where we expect
> > +                         * it to be, remove from the list and retain the implied
> > +                         * reference until we queue it on the new vCPU.
> > +                         */
> > +                        if (irq->vcpu == tmp) {
> > +                                list_del(&irq->ap_list);
> > +                                irq->vcpu = NULL;
> > +                                irq->target_vcpu = new;
> > +                                if (vgic_is_v2(kvm))
> > +                                        irq->targets = data;
> > +                                else
> > +                                        irq->mpidr = data;
> > +                                pruned = true;
> > +                        }
> 
> Could an active IRQ stay on its current vCPU until it's deactivated?
> With irq->vcpu cleared, the oracle returns target_vcpu for it, so with
> EOImode 0 the old vCPU's EOI finds no LR and the SPI stays active on
> the new vCPU. A scratch test moving the IROUTER of an active edge SPI
> loses it with this patch, but not on Marc's branch.

Ugh. Well spotted, of course. Too much time dealing with LPIs :)

Let me have a think about this. Ultimately the goal is to prevent the
guest from queueing up an unbounded amount of work in a context where
we can't schedule, but deactivation still requires some work to be done
locally on the vCPU.

We already have some infrastructure for async processing of the AP list
for EOImode=1, perhaps there's a chance for reusing that here with some
additional guardrails.

> Could this also make sure the IRQ isn't still in the old vCPU's LRs? A
> vCPU between the vgic flush and the IN_GUEST_MODE store is
> OUTSIDE_GUEST_MODE, so even kvm_arm_halt_guest() wouldn't wait for it.

So we set the request on the vCPU, which means we're guaranteed to sync
the LRs and recompute before entering the VM. This wouldn't affect
affinity changes but there's a chance of a stale LR overwriting the
current active/pending state. So yet another bug, ugh.

Thanks,
Oliver
