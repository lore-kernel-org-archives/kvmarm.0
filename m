Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37ADA44F54B
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790094684; cv=none; b=otxv7VYbM/wGN5hl8N9o0vKnFiMwQRsf55oyRQum9eqHOiHJczHoHk0I9QvN2bFUNRdfx2XQ32O5bMnIJxpGd/mHEcfz3CcBzFVhcfeesLlGLRhp4K3QhdW3AK+EORosvJs4kNL6r5Uuv3ZcyvIZdQZPDe7cMoFwXH3SdoMmRqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790094684; c=relaxed/simple;
	bh=XN0s95ypj8J5gPR1tswKVOKPD7UVx6eRcPXxSlJNCFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Okyw5f76jPxnG4kCAs6hkHT9qBHsSQyHnSeqJsCukXfQCQjw9GsRvYlbwIcp0IxbqdlK3CUERlv3zzf6bkshVVsxzm4s/teLj8uSsXqOncLov5+qbw3yrWHXTLyQ3KYQTtC1C2qNjfrKtTcMdvAlGMV+T+kGvJ1yXZ9hot32jjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jxRwCwJu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jxRwCwJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CF21F000FF;
	Tue, 22 Sep 2026 16:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790094676;
	bh=dMhHdlDHVweaqwGCHyW6aVpgCIq4u/jNK61gKZglJYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jxRwCwJu198opJ9FV7TuRu/EDlnGbc3kSavRHQyurtAwyaSsc10ACv1ZPUL2VLH3q
	 8lRCkJuskb+VHWXUhwQnHOG/4VUWgjQIChk9BBkMTGM5OLbVcyYF/JHOc/Wl/WdmbD
	 nJpXRcKZsPZ+2D9ugjDdrTEaSuZbnxaBpZ/thGqza2m0BQi92H6f1EWRbMCR7g/C5e
	 H1i+q8mwel78zyJORL/VVsq35rCfXBZoO3S6dM43U3fJkStz3c011WCUZO8j0YbcDq
	 5zgeGLUYX+hn/kX/OHWqo7iwcTd4gCk637rAlOtjLz1nOUItRbSiy8VQhdOaR+AgpO
	 75CwTfOTwfj7w==
Date: Tue, 22 Sep 2026 09:31:15 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 06/22] KVM: arm64: nv: Use a helper for stage-2
 descriptor updates
Message-ID: <arKtU9KVmyDmWYyL@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-7-oupton@kernel.org>
 <arKpWwN_KrcPtSpx@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arKpWwN_KrcPtSpx@LeoBrasDK>

On Tue, Sep 22, 2026 at 05:14:19PM +0100, Leonardo Bras wrote:
> > @@ -386,21 +403,9 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
> >  		return 1;
> >  	}
> >  
> > -	if (wi->ha)
> > -		new_desc |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> > -
> > -	if (new_desc != ws.desc) {
> > -		ret = swap_guest_s2_desc(vcpu, ws.desc_pa, ws.desc, new_desc, wi);
> > -		if (ret == -EAGAIN)
> > -			return ret;
> > -		if (ret) {
> > -			out->esr = ESR_ELx_FSC_SEA_TTW(ws.level);
> > -			out->desc = ws.desc;
> > -			return 1;
> > -		}
> > -
> > -		ws.desc = new_desc;
> > -	}
> > +	ret = handle_desc_update(vcpu, wi, &ws, out, access);
> > +	if (ret)
> > +		return ret;
> >  
> >  	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
> >  		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ACCESS);
> > -- 
> > 2.47.3
> > 
> 
> IIUC, you pulled stuff around swap_guest_s2_desc() and put it inside it, 
> while changing the function name to handle_desc_update(), so it should be 
> the same logic.
> 
> It looks much better this way, and most things seem to have the same efect.
> 
> The only thing that I notice was "ws->desc = new":
> The previous version would do that only after running __kvm_at_swap_desc() 
> and only when the return value is zero. 
> 
> The new version does that every time "old != new", and before running 
> __kvm_at_swap_desc() and does not take into account it's return value.
> 
> This means that on this new version if __kvm_at_swap_desc() returns 1:
> 	ws->desc = new;
> 	ret = 1;
> 	out->desc = ws->desc; //(i.e. new)
> 
> And in the previous version, it would make out->desc = ws->desc, that being 
> the original value, not the new one.
> 
> Is this ok? 
> (I am commenting because it could be unintentional)

Yes, this is ok.

If __kvm_at_swap_desc() returns -EAGAIN we replay the faulting
instruction. No consumption of the walk result.

If __kvm_at_swap_desc() returns anything else we return an SEA TTW
fault via the walk result struct. Notice that it is a union, and
readers are expected to dereference the right sub-struct based on
s1_walk_result::failed.

Thanks,
Oliver
