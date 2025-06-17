Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9062114A09C
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 04:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750136017; cv=none; b=iyL4eclCB+Ojyo/i7lvA/51blUqp9qZTWoirX9LWQ+iHJQwRIxAivi2va0lEr6BHsRGhXxKFNRpkl3hrkyqi/Iq0IuyCWgRfgz2pklwRtjtycRl4DnNUuA53AisCZulflbw7jtLt5dSzROfoxZrAo9pk6wvd+B1yc1/7g66nDD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750136017; c=relaxed/simple;
	bh=6IyjReoCdm+T/kSV6sIzz7NWOV2ij316HTP5qWv5iRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pEN8uZoSRYJlQgttRN2MDpEE2PnVBrZD13v0OszTiBC0mqAH3CrCgra53U4Gh+OAJ8FRhYZjEKaZCjnRioUa2eLo5AHF7K+OngBrFWnGAlGApyrMdfj+NgfoJYNb80ME6SbF1/7V++JNxxmDi+XGZzfE1/PQ5iXBNPunsMsuayo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GdWv6waq; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GdWv6waq"
Date: Mon, 16 Jun 2025 21:53:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750136012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jfQt0Dij5bdaK/Ln/2PNF4m7CbwXt4vuxElA2oz6HGE=;
	b=GdWv6waq8gMoqhYgz1Ox/03WCWiGI51+/Ufw5GcNEbiisvJWm8mRugwaxcDZounToMDDPO
	yRTK/Iq9nqK78oyXKeFWMAwyFt9CV5twVoyjraVwgBOP8nK5rMbD8WWLq/1Va/y3ETkJzg
	2vmmdVlb9wF9ptv8EwI9Rhl6liwRyRs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix s_cpu_if->vgic_lr[] indexing in
 vgic_v3_put_nested()
Message-ID: <aFD0wHqZ-8CRWIW-@linux.dev>
References: <20250614145721.2504524-1-r09922117@csie.ntu.edu.tw>
 <86qzzkc5xa.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86qzzkc5xa.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 16, 2025 at 11:54:57AM +0100, Marc Zyngier wrote:
> On Sat, 14 Jun 2025 15:57:21 +0100,
> Wei-Lin Chang <r09922117@csie.ntu.edu.tw> wrote:
> > 
> > s_cpu_if->vgic_lr[] is filled continuously from index 0 to
> > s_cpu_if->used_lrs - 1, but vgic_v3_put_nested() is indexing it using
> > the positions of the set bits in shadow_if->lr_map. So correct it.
> > 
> > Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
> > ---
> >  arch/arm64/kvm/vgic/vgic-v3-nested.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > index 4f6954c30674..29741e3f077b 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > @@ -343,7 +343,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
> >  	struct shadow_if *shadow_if = get_shadow_if();
> >  	struct vgic_v3_cpu_if *s_cpu_if = &shadow_if->cpuif;
> >  	u64 val;
> > -	int i;
> > +	int i, index = 0;
> >  
> >  	__vgic_v3_save_vmcr_aprs(s_cpu_if);
> >  	__vgic_v3_deactivate_traps(s_cpu_if);
> > @@ -368,10 +368,11 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
> >  		val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
> >  
> >  		val &= ~ICH_LR_STATE;
> > -		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
> > +		val |= s_cpu_if->vgic_lr[index] & ICH_LR_STATE;
> >  
> >  		__vcpu_sys_reg(vcpu, ICH_LRN(i)) = val;
> > -		s_cpu_if->vgic_lr[i] = 0;
> > +		s_cpu_if->vgic_lr[index] = 0;
> > +		index++;
> >  	}
> >  
> >  	shadow_if->lr_map = 0;
> 
> Nice catch, thanks a lot for tracking it down.
> 
> However, I think we should get rid of this double-indexing altogether,
> or at least make it less error-prone. This thing is extremely fragile,
> and it isn't the first time we are getting bitten with it.
> 
> Looking at the code, it becomes pretty obvious that the shadow index
> is always the number of bits set in lr_map, and that we could
> completely drop the 'index' thing if we simply counted these bits
> (which isn't that expensive).
> 
> I came up with the (admittedly much bigger) following fix.
> 
> Thoughts?
> 
> 	M.
> 
> From 2484950b8fc3b36cca32bf5e86ffe7975a43e0e7 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Sun, 15 Jun 2025 16:11:38 +0100
> Subject: [PATCH] KVM: arm64: nv: Fix tracking of shadow list registers
> 
> Wei-Lin reports that the tracking of shadow list registers is
> majorly broken when resync'ing the L2 state after a run, as
> we confuse the guest's LR index with the host's, potentially
> losing the interrupt state.
> 
> While this could be fixed by adding yet another side index to
> track it (Wei-Lin's fix), it may be better to refactor this
> code to avoid having a side index altogether, limiting the
> risk to introduce this class of bugs.
> 
> A key observation is that the shadow index is always the number
> of bits in the lr_map bitmap. With that, the parallel indexing
> scheme can be completely dropped.
> 
> While doing this, introduce a couple of helpers that abstract
> the index conversion and some of the LR repainting, making the
> whole exercise much simpler.
> 
> Reported-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20250614145721.2504524-1-r09922117@csie.ntu.edu.tw

Besides Wei-Lin's comments, LGTM.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
