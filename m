Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE3921CC74
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 05:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750917298; cv=none; b=UfpznHOwMvwJ2WZGsFJ3R5dYns/6IMvYNdGV6HXnPaaTNX9XENHmoMGqwR6zniLunJ40zjbFJPbwNUAdvvEZspIelJfabIwVJhGKDUzf1yy825fg1waxK3iLnwvBFprk7bGN2zHDzJgg2WSYV+R3RksOgcyuyTIqG68jdvUHxdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750917298; c=relaxed/simple;
	bh=31M3xpw7EncWsxNC4fymQYCkV2uAZxtqDe3BzGziPDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6feHj1K5T00jtXAHpMUSxo+qK6wpMGOdgG3lmfq6JO1dZsMjiQKue16FAhWBnIyQhSVBRvrzaNxZMBUQq1vNhwDtxOjSpKhQxAKu9cBxmEQud+P+GqkW0fvv/Q24z1USEkKaHubHzbRDgljN/pJgEnrSzkaTwdgJDucWLI8L+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=kNn/bcj9; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="kNn/bcj9"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-234b9dfb842so6376635ad.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 22:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1750917295; x=1751522095; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rm0OfZ7AaG27+skvHa9GB/aO3szvxFuyhu1AGBEZrgc=;
        b=kNn/bcj9UoFgyIAV5pI3cMWZqj4I/elt0JtkxUde5AKp4ZhwrkStIArM4CNiKYS7m6
         KQL7w7DJqclfiOSj9VhDJTPDYY0qFeibA0hxEnrQjWOSpmkHTF+1e3xyvCwPQssajkpC
         3rWPSOSipk7pTW2/pF4C7imK/WMaxo3Lmudjl6scwEwLauRIO4wUxgjR/iUGg8PZ1Ke7
         hQSnCovFlgECg0rK9r3wVyupd0PttDEM0/IeC7GhNefJwaKawj1lgIV8LZZtrgFzQfxu
         FnkldPoXlVBRzwWBa/9iA1td6/AKtxAY4E/h2V+Df74Zbgrl99qecQLLCsjEmynqH8mw
         /xWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750917295; x=1751522095;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rm0OfZ7AaG27+skvHa9GB/aO3szvxFuyhu1AGBEZrgc=;
        b=Cyc1xVjTNm8Bttb73GTJNfoFcVsZKyyNPCFCXm6vRA3p5ws+YtWxZ+yytRKZFx4Zv4
         FPy9ZqHmjaCunRdWtY/82K0scwR/svp4+loH35RcKHt31EHS2RRbnnvG0RYx6ELstWrG
         12Uy0OOv9DyYsyrqd6NUV5pcRBvm3+SONT+mhQyVkZS0SGDVFZLpSiz3FuxIWnMz1qvO
         AT5EwCfVfXSAa9lmG1xcBoSVhxVbG/ECmnfBrF11IoUJ9uUfmqjEyAEYg6uwI7liSA3G
         Gg1a6kOdVXwXKCohp87oUUiwVGp4qPwZqDxQ1H+1TBZOu4RGbZWqve6qnSRPy0tPn6ZJ
         TMcg==
X-Forwarded-Encrypted: i=1; AJvYcCX+SJjg5eEvZ4xY0cgksggbF9YNOr0X6ddb8HPFQskNVNMo+6E4rFqVh131+zSKLnO54IMuDNY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyuen9IvtgcnfFK/PavbCeEZjwOvWmIxdVCTg4v44DMu/vspUr8
	G+ZE7A9dvBgaCn/ZzlujnhLOPDP9v4FBijRcVVG2eAyt5wRAQM9CBbYpwHdvO/YTIg5F+V9Lpqh
	UqoL9R8Q/pGS/5UtnPTT8kCR2bwsKQEa2sKV0B/+XvZPjBy71z9g=
X-Gm-Gg: ASbGnctsd+Dm185ICGqmPeory5p1Kf0i5za4bImLps0m+6/89MYhAYN3hyWqlstGNdl
	LSv9F85pUIB5rcjbEa16oMBqeWcHUd/3WTGNY16C4IsDZJL/jyBnxIHJzc/gBDwnhLje2hhmcOP
	XCuseadctN1G5SNnL8WMWo0mwCZeErWWALZVCFOozuCVmasm9bJvHVLfv9FbTVwtOB7d40GAd4Z
	d3d31aNFYQr05upKz1oX27DnPFx6L4ZmpCg7ESStKS9R9BS+q26DH+jm9kMzwM7TsKIKiO37CVk
	iXskLY/Kfz2XXhN6+nNRDfvWGCAg3TijYW99uWZoEOl+KPH9jPme0UV+kqdF7Z1fMMwOZqQyjAc
	Wtz3by+8w4cnHt2T6PA73dV9+
X-Google-Smtp-Source: AGHT+IErD6u0GnnyBjjoDbBvoZW5tms9xrqBq7DEY79r1vA3q8cM8NFq9ggAKD/BsmxJillbjalycg==
X-Received: by 2002:a17:903:41c1:b0:234:c8ec:51b5 with SMTP id d9443c01a7336-2382409b0eemr108270405ad.53.1750917294720;
        Wed, 25 Jun 2025 22:54:54 -0700 (PDT)
Received: from zenbook (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d87182c8sm152907285ad.232.2025.06.25.22.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 22:54:54 -0700 (PDT)
Date: Thu, 26 Jun 2025 13:57:17 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Jintack Lim <jintack@cs.columbia.edu>, 
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix MI line level calculation in
 vgic_v3_nested_update_mi()
Message-ID: <w6yfzeynleghp7sxwscbrq6ko4244c5iphtqw6e4ar5dndqs3m@37jouplavkpw>
References: <20250625084709.3968844-1-r09922117@csie.ntu.edu.tw>
 <864iw3db3h.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864iw3db3h.wl-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Wed, Jun 25, 2025 at 05:45:06PM +0100, Marc Zyngier wrote:
> On Wed, 25 Jun 2025 09:47:09 +0100,
> Wei-Lin Chang <r09922117@csie.ntu.edu.tw> wrote:
> > 
> > The state of the vcpu's MI line should be asserted when its
> > ICH_HCR_EL2.En is set and ICH_MISR_EL2 is non-zero. Using bitwise AND
> > (&=) directly for this calculation will not give us the correct result
> > when the LSB of the vcpu's ICH_MISR_EL2 isn't set. Correct this by first
> > adjusting the return value of vgic_v3_get_misr() into 1 if it is
> > non-zero.
> > 
> > Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
> > ---
> >  arch/arm64/kvm/vgic/vgic-v3-nested.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > index 4f6954c30674..ebffad632fd2 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > @@ -400,7 +400,7 @@ void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu)
> >  
> >  	level  = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_EL2_En;
> >  	if (level)
> > -		level &= vgic_v3_get_misr(vcpu);
> > +		level &= !!vgic_v3_get_misr(vcpu);
> >  	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
> >  			    vcpu->kvm->arch.vgic.mi_intid, level, vcpu);
> >  }
> 
> Very well spotted, once more. Where were you when I posted all these
> patches? ;-)

Thanks ;)

> 
> We could make it even clearer with this:
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> index a50fb7e6841f7..679aafe77de2e 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> @@ -401,9 +401,7 @@ void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu)
>  {
>  	bool level;
>  
> -	level  = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_EL2_En;
> -	if (level)
> -		level &= vgic_v3_get_misr(vcpu);
> +	level = (__vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_EL2_En) && vgic_v3_get_misr(vcpu);
>  	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
>  			    vcpu->kvm->arch.vgic.mi_intid, level, vcpu);
>  }
> 
> If you're OK with it, I'll use this, keeping your authorship of
> course.

Yes this is more straightforward, with this the commit message should be
rephrased too. I'm ok with keeping my authorship but really feel free to
adjust if you think some other credit is more appropriate.
I'm just glad that I'm able to help a little :)

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
