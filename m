Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C45392C4B
	for <kvmarm@lists.linux.dev>; Wed,  3 Jun 2026 11:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780484765; cv=none; b=CKm3jQwAuHT6nWDzvW9ldKGt0nuU9onN3Sa122a9PPuE5Bsdzek2dwnhSKW7HLBH9dFZLO5CwEXvO8WNRuRoC/UCebQGe3rBDp15KOwDXsEGJYfSgA4lNteGuA00JbXKx1RSFI5hIB7Du8WT7JJ1IBQlULDrxARRE8zt20jZZ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780484765; c=relaxed/simple;
	bh=OnY6ClRqq2KKYJKV1nVgnAMR5D6LCHElve8USWjdEVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNu+cP0fiwiu4ksLHwzeYelvwUlVeO34fUOSxbwHoVYl2QPUUW1oIktXJvFWWqkOmSBNwAYJzNutzKAFmKcJWEHetLeeels5201OqaiO22iP+kWfeTTPr3ZEoTLi8hRtSXAB8jg+v1d17npP2pBky99su0ZIEvPHQqALtnwZL6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTgFSxLN; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTgFSxLN"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8423f420455so1575166b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 03 Jun 2026 04:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780484762; x=1781089562; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=spGZim1ZyhgHsaiJXpVGDnA2fCWowtbUu0fv4Gh0GyM=;
        b=JTgFSxLNXdk0W883OeP9W/EVmaAT9u/AOYo0Fx3adGJ1nuKSn2Vd7275Rl1pOPa0Yh
         zKza35l/CxjGPKHJgaHwQcoVmRoBuPjGE3AC4oYjOyCAxah3bJQYf4ZXmaB/FomoP2bA
         b1vvm518eTxESli8ExQCBnMk5MUF1WsH4Zh7dXDswf2Z0duh0PeYr6AUWWm0itx/lGVG
         MgoFPjDCbJRywlpatklw4pUOy5QIcdWktSljAfxD4MCNnIhvyi0EUHI264vtJMDbyslT
         L2Ladvz79FMUYG0bomsOIS2viUvU001bRy+Rwa3Vc6AdSxoBOtLiQiz6taWYyBj0W93h
         rsNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780484762; x=1781089562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=spGZim1ZyhgHsaiJXpVGDnA2fCWowtbUu0fv4Gh0GyM=;
        b=DiIV8109xPCWoQ+ygCC7nabQelsEvqdMwq0TMaUEhyr2PBqftl41fVdQwWoairXr4X
         +vHfMvE/UTL3gv4xQktO5gI7VROJdZJKlSzxw1E8e8H0aIquMqZ5CTPhvpaiw/mMh3GB
         Gxd6iIr447K8L8XZ6IBvpcSS+wwurLn8heGBAxLOjASzPQgv/8VfnIU21GJVcS7vEEdt
         SrS3nrO0Yb62Ik1zIbaToK5OQoMX/mQIp3Jt86pvbcZ6Uo+EwE3PYMNfwwdPEyxuVcES
         ZA2daUGXErHGSbCUiRcjCjTs+4nbDMwZ7jErWksThvkfeOibN93G7gMQum8d9+vPT2SB
         F9Lw==
X-Forwarded-Encrypted: i=1; AFNElJ/tQU+qBqEJvXARpVlFPLOOv7lAikQ3xM8R3legA96ViTciZmBsY+eqUeW5XbfMZGPD2BKLIz8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzrvh9/wcvQFxG6iknLbiN3LOzkvBVA7MXEt5aVyqCj/MZL8hHH
	qM+0RPqalWhR9ECwDwaWAVnkyD+5BX2pLKoExNUFY5t+LoMhFR/hUk/d
X-Gm-Gg: Acq92OGEVXbPzIlsaVTz6++IDLO2qPSlf3v7KNO4ozNz/pdNMyhU8TSGavopvwf12Kw
	kOFhx4aRJP2/X1XKVgnwVSZIlbD6C7gg1kUCEksxJCMZAuRsF052zXAUwd3Koe3pF0/Ilg7TSzu
	OL6oPTGf+sJ3UsngB8DMMT7Kw76jOAZcZahgoscMtlDYgRa8i+mNmPVXgTbvBs3m3zbsKZFzKOa
	IGEpRk3XDwI3HoO03Kdq6eCWULgzL4VJqFaoDUj1t5pv+4pjZ3W8jlTto/p2dXoMi8KxQGR8c9w
	4HPLFHJZAaDINvJ5nW/N+aOoJxQuEVlE1LiICUgAsfNza4qsABbluvCBmVD85MVCUSxwqdW8UBW
	q5z21uJWMQarb23JlZrS9SA7kSiD9ZF7V4N1Wn2byYuEWdBZIlL3eEUZpWPxXkU1YDsZfKHVAU7
	GN0ehZVVLrHCc+lVzHA3V2ok4CqzxNzy9p1jdJISL/uHvQAxt64nQpbQ==
X-Received: by 2002:a05:6a00:ad1:b0:841:d0a9:76e with SMTP id d2e1a72fcca58-84284df0234mr3088644b3a.5.1780484762139;
        Wed, 03 Jun 2026 04:06:02 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828d6bc5sm2583248b3a.43.2026.06.03.04.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 04:06:01 -0700 (PDT)
Date: Wed, 3 Jun 2026 20:05:57 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Oliver Upton <oupton@kernel.org>
Cc: maz@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	stable@vger.kernel.org, imv4bel@gmail.com
Subject: Re: [PATCH] KVM: arm64: Take the SRCU lock for page table walks in
 fault injection and AT emulation
Message-ID: <aiAKlchUO_TN4Q2u@v4bel>
References: <ah7_BAAzHggzdZeI@v4bel>
 <ah_Nal3ai65tgt-z@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah_Nal3ai65tgt-z@kernel.org>

On Tue, Jun 02, 2026 at 11:44:58PM -0700, Oliver Upton wrote:
> Hi Hyunwoo,
> 
> On Wed, Jun 03, 2026 at 01:04:20AM +0900, Hyunwoo Kim wrote:
> > inject_abt64() rewalks the guest stage-1 page tables via
> > __kvm_find_s1_desc_level() when injecting an abort for a failed S1PTW, and
> > __kvm_at_s12() calls kvm_walk_nested_s2() to perform the stage-2
> > translation. Both walks reference kvm->memslots through kvm_read_guest(),
> > which reads the descriptors, and __kvm_at_swap_desc(), which updates the
> > access flag, so they must run while holding the kvm->srcu read lock.
> > __kvm_at_swap_desc() asserts srcu_read_lock_held() on entry, and the other
> > callers of these walks, handle_at_slow(), kvm_translate_vncr() and
> > kvm_handle_guest_abort(), take the lock before calling them.
> > 
> > inject_abt64() is reached from the SEA and size fault injection paths,
> > which run before kvm_handle_guest_abort() takes the lock, and
> > __kvm_at_s12() does not hold the lock across the stage-2 walk. Take the
> > kvm->srcu read lock with guard(srcu) in both places so that it is held for
> > the duration of the walk.
> 
> Just state the expectation that srcu is held rather than giving the
> play by play. Perhaps:
> 
>   walk_s1() and kvm_walk_nested_s2() expect to be called while holding
>   kvm->srcu to guard against memslot changes. While this is generally
>   the case, __kvm_at_s12() and __kvm_find_s1_desc_level() call into the
>   respective walkers without taking kvm->srcu.
> 
>   Fix by acquiring kvm->srcu prior to the table walk in both instances.
> 
> > Cc: stable@vger.kernel.org
> > Fixes: 50f77dc87f13 ("KVM: arm64: Populate level on S1PTW SEA injection")
> > Fixes: be04cebf3e78 ("KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}")
> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> 
> I'd prefer if we scoped the critical section to only the relevant calls
> to the software table walk, like below.

Thanks for the review.

I agree this direction is the better patch. I'll do some more testing 
and then submit a v2.

> 
> -- 
> Thanks,
> Oliver
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 9f8f0ae8e86e..889c2c15d7bd 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1569,7 +1569,8 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	/* Do the stage-2 translation */
>  	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
>  	out.esr = 0;
> -	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
> +	scoped_guard(srcu, &vcpu->kvm->srcu)
> +		ret = kvm_walk_nested_s2(vcpu, ipa, &out);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -1665,7 +1666,8 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
>  	}
>  
>  	/* Walk the guest's PT, looking for a match along the way */
> -	ret = walk_s1(vcpu, &wi, &wr, va);
> +	scoped_guard(srcu, &vcpu->kvm->srcu)
> +		ret = walk_s1(vcpu, &wi, &wr, va);
>  	switch (ret) {
>  	case -EINTR:
>  		/* We interrupted the walk on a match, return the level */


Best regards,
Hyunwoo Kim
