Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984BA38D3ED
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122504; cv=none; b=bysHnxGeK1n51zrQzz8dUMr7Em9qJCKuRsLIkRxGvRoglWFDYVS0XlurzeqYKxD2OZ2HPDiE8unyHgK3rnjjp75VUwxTzGVHsErT0kgsqwoj1vPvjdJ9ASlz3DuRlOWTfYqaEN9BgsyQFbwStn+qZMwQGGP4Fo3cLqPJVR1GauY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122504; c=relaxed/simple;
	bh=PEyv/ZNi02HaucwD0lzLJLCQOah9Kpc2cmwW88odXGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQD1Y5jChvP4HkdjJsNIG+ltd8ea+L3cncQyHL8J6zCgsVYHLR2FfbMMaG1HhNpEQelrJVVj3HvY+kxDolN4NzLOylFOHtVmmL8r+p22oTKpZDO2INv+sEKo+N3FF08kkfb3Sk152l9/Q55l7K9j7tVgCYr6iV0o4VEIhwt911k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QkFssbW3; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QkFssbW3"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4955de8797cso25660385e9.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 10:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786122501; x=1786727301; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iaOeMTZOYIaS16knxOG50vS1TNGyqbn7Zjc+qZ37u3k=;
        b=QkFssbW3S/mLgUXGqTFfBfIz0MdRIX9U6ndLYVXHVXw7RctxcPNqXBkP9VBMr3AMOO
         qqgSQQd52AL2ZBFl0eQrx5VC/eBRBuOI75OxAi4CecWCBm8tPhNrJIuZCVAUnNTOb9hi
         uTG9NIfTHxKHxmEGnHD/gK6y5HIO4goq9DC83W6ZGGcvPqRNQc63BtnVM5N3x25Swxig
         RYystAV8MG7xRc0m6tPYbZXwmCg+sPzFHYj0ECAk+jflkdWu8FCFqweRKkK+81Rgzwf3
         L+jwdmzohlrRqcum9u622squ6ThsAwL1bRh21G4JeWiTWeko1q7T/3zjISTqggnojy6D
         l4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786122501; x=1786727301;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iaOeMTZOYIaS16knxOG50vS1TNGyqbn7Zjc+qZ37u3k=;
        b=mIxKxB54pnuEoKyJWVZCEvi4l4dTOQDEX3Pg978XcrsbKOGQqkLaWMNnjYUZILDEKP
         CqLMjLdsX14k0Z1eJY6YJq7+4lRprSomfWfIqT810Y7budeaAaZ/2Evd2D7H7LKUsVfv
         xPYxgSs2aVwVBY03LMsJa4tmuKlknt6Mm0zirrH9QbI56QU6xyYVV/CvHiovZ1uTWPDI
         GYBbYI9N43HiY8lh0RdTnZwfnuBeJAtwMitxQF+iBrLDXkFsRjn7khSjB1nhMzf3ty37
         TXs8plI7UdtfEP0uaqFZSqujxKve8fqGmkIEOJVCnTYEXOzc79XEl+oGK7OAjRSG3zrp
         RbUA==
X-Forwarded-Encrypted: i=1; AHgh+RpX+ptLIYBO1Qx+PuE1OVXccp3Inw8NxHE8Dvf5gG+ZDFuhzsfPo45cJ91bX+OjZEaCkG7HE+U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3DtW238zdawaIn75yNvYympWf/Ak+nbY4aDChT6jJK4ozQZiT
	fwiLBagwJkWb6jzDhoNJgdfvB/moC+/FBC2nbxzJ3fFpWZKV+BtvwvrmgCy4mceG
X-Gm-Gg: AR+sD123X7Z5LKQLq9JEtt/8qx1EFIhGO5HpUR3LRQqjVyEpd77e+R5y2j6n6p54VLr
	s7VcsYCVDqOSttiN5f5xm/QrxweCDxhLMqUzsUmLlbNBQeA/zEEI35npeYiZEz+9BWCEbB7f28r
	mAMUfb0cR/zTDut0wrBeMARfkA0t8yB3NWK/S3Oh7WpT3DKwJLlFFbpNNN2Dud390gOgPtfcQ7j
	Ytjl0EM3qTgcY9UU+7bNqPBDJi9xP1WK4NhJr3WbwBmWZAcsDdTL4lmosmPoZqn93X9ZISAjEgR
	LThXTl2aJ6a8jADNM/VUQtS3nBgLBoWcEDxE/Hn3AZQnkvUq1ozfWxNQqLW7UoYVBsXaO382r5t
	vjzK0xItSfwlMo0pA/ADCo44beLdHVkA6DrVuylu3hGkFPQejePESJ40Q3ENSeG03CGixuk2bb9
	7Cv6gNINJ7r43GtD3jZjAYL9Skqn8e1rrQ5d+qUotFHjYs7I7bZLns1TJSptSTIKvWewhpFX4pe
	O/fIyPRPbJEIWFOVlBgdWqLWhLjuHayElBgtOevRbJU6a1oDGqF7qf41ySJiKR5RZq+EXU5fijF
	8XJDClB+JUofDwm5+AyTRJ51tfN8PUUTcYcfI6XAc6zC0/4aacdn/Q6UgQReVfNxJQ2VThUPO1/
	jaXNdfv8JrnLspd78hj4=
X-Received: by 2002:a05:600c:b85:b0:496:c93d:e2f with SMTP id 5b1f17b1804b1-4995e0dff0amr73285775e9.15.1786122500534;
        Fri, 07 Aug 2026 10:08:20 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-b105-e101-a437-493a-4de9-ee3e.310.pool.telefonica.de. [2a02:3100:b105:e101:a437:493a:4de9:ee3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995ea27ef0sm60747585e9.9.2026.08.07.10.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 10:08:19 -0700 (PDT)
Date: Fri, 7 Aug 2026 19:08:17 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: nv: Allocate the shadow S2 MMUs
 individually
Message-ID: <anYNTW2e3HalTqTk@gmail.com>
References: <20260803224405.41468-1-kmehltretter@gmail.com>
 <86mrv2arf2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mrv2arf2.wl-maz@kernel.org>

On Tue, Aug 04, 2026 at 03:31:13PM +0100, Marc Zyngier wrote:
> See the hack below that seems to work OK.
> 

Hi Marc,

Since error handling has come up again, I should clarify why
v2 did not use this sketch verbatim.

> -	kvm_init_nested(kvm);
> +	ret = kvm_init_nested(kvm);
> +	if (ret)
> +		return ret;
>  
>  	ret = kvm_share_hyp(kvm, kvm + 1);
>  	if (ret)

Once kvm_init_nested() has allocated the pointer table, failure in
kvm_share_hyp() or any subsequent VM initialisation step leaks that
table.

v2 therefore calls kvm_init_nested() after the earlier initialisation
steps have succeeded and frees the table if a later step in
kvm_arch_init_vm() fails.

> +		for (int i = 0; !ret && i < S2_MMU_PER_VCPU; i++)
> +			ret = init_nested_s2_mmu(kvm, &tmp[i]);

> +		if (ret) {
> +			for (int i = 0; i < S2_MMU_PER_VCPU; i++)
> +				kvm_free_stage2_pgd(&tmp[i]);

This cleanup includes the entry whose initialisation failed and any
entries whose initialisation was never attempted. An uninitialised
entry has no valid mmu->arch, but kvm_free_stage2_pgd() immediately
derives kvm from mmu->arch before checking mmu->pgt. It can therefore
dereference an invalid pointer.

This is why v2 tracks successfully initialised MMUs and frees only
those entries.

Thanks,
Karl
