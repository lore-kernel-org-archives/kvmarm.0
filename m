Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0A538A706;
	Tue, 23 Jun 2026 20:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782245646; cv=none; b=Ija9bo2Wn1N5WkqmMBDlraIIQukZzBY5LSexMZKfciMLTQ0u2npBV3jKT4iuacSVWHAuDrCXIkmASSOLvx0RHoLOcwau/Wl1no4vD4FmeVb4kXIcaEqtVMeFyG65P6Rq5gH2lGZWC+P0yeJh8ebuCA6XA5buFj2n+6ynNbqiRCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782245646; c=relaxed/simple;
	bh=fnRRfcd5AiCVP4Duin2H0L5y02Z9RmVj83e1LsBn8/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D8W201TRGHXOCzwS7BDHlVC0Uhk4RxRrMM50KgROnLx7MwyJNAcsg3eKLntPniNkCKURUAxJ4YDZTON4KddqBjNt5h7vlHYIJSfoU4wYDi+1T3l+sfDDFH/+hn2D3iPCZqkM+hS/PLx7w3TcrhWYRe3uPqZ2JMLaY/BrX9XOmLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQcgC352; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQcgC352"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F811F000E9;
	Tue, 23 Jun 2026 20:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782245645;
	bh=6rY38a8GrRnjcBF1KezRygSLZFIJBO5beDzw2wlQp1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQcgC352zcbbTMd8i305NrRZphbBkQ2zb6DWNpMacoaH9ARqOKC6jXNlhPX52DsYd
	 X3Kfc1+4I9bz4wSBW5oI8aGvigeDR05PaLY61yNioLPYhyyObhmipdm60M68RuLHxR
	 ZU06xFSbuvG/UxRVMAG/lYWvAugtxgpXZYQRfxvLFL34HZu6VAFQRcEgOcvOxB9oP0
	 FPNKCcwsTIR3UsSNEzvUqGvsCRV458E0ZuqtEjIGobCXqMr4s+GbZ+ZMPcHalURlYA
	 6eNIzlJ18Vr6Y6QQYUr1UU4syJ+JVHfmiAnvOqhf7/fIEkX47X1tJxTQrC01y6eqBE
	 ekBsXG1OoZ7yw==
Date: Tue, 23 Jun 2026 13:14:03 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 18/22] KVM: arm64: nv: Set access flag on table
 descriptors at stage-2
Message-ID: <ajrpC9euW7e9kSdh@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-19-oupton@kernel.org>
 <20260623190518.CECD71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623190518.CECD71F000E9@smtp.kernel.org>

On Tue, Jun 23, 2026 at 07:05:18PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Stage-2 table descriptors fail to generate an Access Flag fault when VTCR_EL2.HAFT == 1, VTCR_EL2.HA == 0, and the descriptor's AF bit is 0.
> --
> 
> commit 7d14ee3ad8d74a4b9734d83c712bb19ae89c1090
> Author: Oliver Upton <oupton@kernel.org>
> 
> KVM: arm64: nv: Set access flag on table descriptors at stage-2
> 
> This commit implements access flag updates on stage-2 table descriptors for
> nested virtualization, as required by FEAT_HAFT.
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 2408d604a1e18..6f540d3481d5a 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> [ ... ]
> > @@ -424,6 +428,10 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
> >  			return 1;
> >  		}
> >  
> > +		ret = handle_desc_update(vcpu, wi, &ws, out, access);
> > +		if (ret)
> > +			return ret;
> > +
> 
> [Severity: High]
> When VTCR_EL2.HAFT == 1 but VTCR_EL2.HA == 0, and the table descriptor's AF
> bit is 0, will this silently bypass the required Access Flag fault?
> 
> If wi->haft evaluates to false (such as when HA == 0), handle_desc_update()
> returns 0 without updating the descriptor. The walk then proceeds to the next
> level without checking if the AF bit is 0, which misses the injection of the
> architectural fault.
> 
> Should there be an explicit check for the AF bit here similar to the one at
> the end of the walk for leaf entries, conditioned on VTCR_EL2.HAFT?

I_HZHJT, the table access flag never generates a fault.

Thanks,
Oliver
