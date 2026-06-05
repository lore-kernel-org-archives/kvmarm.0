Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0F0375F8B
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 05:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780637726; cv=none; b=QV+WP+InXrlv1gYUbDye44soQ7MH//Wp21GI9T6iUTgJ5X05zCOi2Ney4po2824FKkcGhwOFBa50C11s1zUMk04OpK+ntCh5GMIFYdFO29ZI+SIRopF7rbJoPjakSaPRDHtI7hdZT0QKT3svPxkkCPajFRRVAytta/aBPif4YwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780637726; c=relaxed/simple;
	bh=3wnZFlZ5JxUZ+O2rYlUMKN4w8WjTn07tFXZ00TYz8j8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fV1uyG7d5l/hUFVx0+bhdoWgBFUiLoWA/XIF1O5jaKTHwJ+eQziN9RqfedXJZenS9wdrnrO3gD8ZQ0opHaKPuEsuTPi0XQuJ3Wmkdox0CY5iHyCJmKM6uX52WLI/3pwx/CJaQtOlULUPl+MDohvQt/zr5w8DRn+rWeNKerWnLLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mDIKUI43; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mDIKUI43"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-842848fd613so1146970b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 22:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780637724; x=1781242524; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZA27BTaDBEKi8r/WSFiJ0hysZrsoBQk8soZX6m2DKXU=;
        b=mDIKUI43yotkbVTxr6I4D4Hri7CZ7h0LNrIH9Jc2gS0aOlMmIU2PPWtAuvFDKIBlhK
         xAaldAzp/htHF7gsKWU2qdeQwPDIdOaVAjTn8sLIbYM2UB57+mZQ4n/nq0ajVA4IZYyc
         uBXiV5zXgeRWXXN5po+RZ+BQ3ZEi2UCKc+VvKvWgN2+umeZ78Te1QCaLf98JTAsKgc22
         1Zn+mDtZmE/NAfYWbTwu+6vSDfVPuShhz237XxTO5lYGg5SKw9Tj5+bQ2Zs8IUhua9UD
         y7L1s1EARIlwWSzYwO7PxNqHXj0CEQMozaIiuKRI9VP9HvG5xb+i7/D+bQhXUiKyhZRl
         +n2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780637724; x=1781242524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZA27BTaDBEKi8r/WSFiJ0hysZrsoBQk8soZX6m2DKXU=;
        b=tPM+Smelw3jLYAfXlb0DyjnR5busDadKT0A14t4/hCCBZ9ZauJDlwXeYpu/HikU0UH
         fL/0ve01gc3dcP4TOT7FS4zmng1SGonlP2VfE0xpXQqW5llunEN9sO4MKKIY+lwBssse
         mcDn89gONJ/15JRvwNOmBY1pWoqOm7BC8NxZ4Nn27eogP4un0/9pbplCiARCNCi5AsGp
         N78EwTdsgHBMIHTgdrpVekCGCBkTzbgrlijvth5pwO+wlcrhzzHykRxODXPfSfoWTnfj
         fpsKdSFl1ZEbd7u/FZyQXna6P69lf5cTo/YHZMen/ggk3/hKZfWmsT/dOI7ZXkdGRmDP
         Kezg==
X-Forwarded-Encrypted: i=1; AFNElJ9k0BZuBEV9d9L+4dNVdxRfxQnGwp7gmMI3hDAFGrbaDsLHKlicnOVszkWQYvt9PYaASwILw2k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxX8spZltOQFZuza644vzHmLWPGVbN1OZzE8fHhSLGi4fC4CflD
	PbDdZtVNN0FWYsBXwWAhMfie19BA+iAALuEWGZDOAziJIXgcCScUU/d5
X-Gm-Gg: Acq92OEQOgAxzcUbZeeh1UhIyRY//HUuWcpT4U589/bctA+u3k0zuwIvGG4Bs2I5lQn
	pRD8ZRDhLZW4/qLNDX90cl2soL8RLUHmAwy1W5DxQJq3mvhQOA7Ky6h0K9EGWWYGZqqKE4FSy/w
	HUjp3BRWyQ9Ph038S9g8l1ldsp/YMGOm7sjyJSDSMnAkksuOvWZ8iC/P+AXGif+vFX5jjV8X7LN
	LWPtFKYSbjgdLm+7TOLUXl0JVWFoCa0NCSXg/BM2g4vW0PmPo6r8WqvIHIUlEUApPMUFFEN/mki
	s17+2lnWirP6mSV4vc5YPPNkiiyT5QJ4INzSuyYGqO44e7lf/rznm2OrGYVYPyWvcPqdb6xX0va
	LjFB8OIYyj90MnJUjPczRBfgeSeYNmF6/OfUdhxC3mToegTJZZ87hkKtL7noSxUW0p8C5Qv0fo4
	oV8FBx+K9N2YMWrcot0pKV99SuXLOTWblCo3oWn46wWA5U5EsrCQiNUg==
X-Received: by 2002:a05:6a00:4512:b0:842:3be7:4d51 with SMTP id d2e1a72fcca58-842b0efa1damr1778931b3a.15.1780637724503;
        Thu, 04 Jun 2026 22:35:24 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428288217bsm9336558b3a.37.2026.06.04.22.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 22:35:23 -0700 (PDT)
Date: Fri, 5 Jun 2026 14:35:20 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Oliver Upton <oupton@kernel.org>
Cc: maz@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, christoffer.dall@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: Re: [PATCH] KVM: arm64: Reallocate the nested_mmus array under the
 mmu_lock
Message-ID: <aiJgGBv3OCPNJJPc@v4bel>
References: <aiHEKOeZMVwsRlvP@v4bel>
 <aiH7xKnprU9bUap5@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiH7xKnprU9bUap5@kernel.org>

On Thu, Jun 04, 2026 at 03:27:16PM -0700, Oliver Upton wrote:
> Hi,
> 
> The shortlog is very confusing, since "allocate behind $LOCK" is usually
> something alarming. Maybe instead:
> 
>   KVM: arm64: Reassign nested_mmus array behind mmu_lock

heh, that's confusing indeed. I'll change it that way.

> 
> On Fri, Jun 05, 2026 at 03:30:00AM +0900, Hyunwoo Kim wrote:
> > Code that walks kvm->arch.nested_mmus[] holds kvm->mmu_lock. By contrast,
> > kvm_vcpu_init_nested() reallocates the array and frees the old buffer while
> > holding only kvm->arch.config_lock, so a walker can reference the freed
> > array.
> 
> It wouldn't hurt to share slightly more information here. Are you
> dealing with a concurrent MMU notifier?

Yes. The MMU notifier path also walks nested_mmus[] under mmu_lock.
kvm_vcpu_init_nested() holds only config_lock, so if a notifier fires
during vCPU init, it races with the array realloc and free.

Here's the reworked changelog. Should I send v2?

  kvm->arch.nested_mmus[] is walked under kvm->mmu_lock, including from the
  MMU notifier path (kvm_unmap_gfn_range() -> kvm_nested_s2_unmap()), which
  can run at any time. kvm_vcpu_init_nested() reallocates the array and frees
  the old buffer while holding only kvm->arch.config_lock, so such a walker
  can reference the freed array.

  Allocate the new array outside of mmu_lock, as the allocation can sleep.
  Under the lock, copy the existing entries, fix up the back pointers and
  reassign the array. Free the old buffer after dropping the lock, as
  kvfree() can sleep as well.

> 
> > Allocate the new array outside the lock, as the allocation can sleep, and
> > do only the copy and the pointer swap under the mmu_lock. After the swap no
> > walker can reach the old buffer, so free it once the lock has been
> > released.
> > 
> > Fixes: 4f128f8e1aaac ("KVM: arm64: nv: Support multiple nested Stage-2 mmu structures")
> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> 
> The diff itself LGTM
> 
> Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks for the review.

> 
> Thanks,
> Oliver
> 
> > ---
> >  arch/arm64/kvm/nested.c | 33 ++++++++++++++++++++-------------
> >  1 file changed, 20 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 38f672e940878..6f7bc9a9992e0 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -89,21 +89,28 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
> >  	 * again, and there is no reason to affect the whole VM for this.
> >  	 */
> >  	num_mmus = atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
> > -	tmp = kvrealloc(kvm->arch.nested_mmus,
> > -			size_mul(sizeof(*kvm->arch.nested_mmus), num_mmus),
> > -			GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > -	if (!tmp)
> > -		return -ENOMEM;
> >  
> > -	swap(kvm->arch.nested_mmus, tmp);
> > +	if (num_mmus > kvm->arch.nested_mmus_size) {
> > +		tmp = kvcalloc(num_mmus, sizeof(*tmp), GFP_KERNEL_ACCOUNT);
> > +		if (!tmp)
> > +			return -ENOMEM;
> >  
> > -	/*
> > -	 * If we went through a realocation, adjust the MMU back-pointers in
> > -	 * the previously initialised kvm_pgtable structures.
> > -	 */
> > -	if (kvm->arch.nested_mmus != tmp)
> > -		for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
> > -			kvm->arch.nested_mmus[i].pgt->mmu = &kvm->arch.nested_mmus[i];
> > +		write_lock(&kvm->mmu_lock);
> > +
> > +		if (kvm->arch.nested_mmus_size) {
> > +			memcpy(tmp, kvm->arch.nested_mmus,
> > +			       size_mul(sizeof(*tmp), kvm->arch.nested_mmus_size));
> > +
> > +			for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
> > +				tmp[i].pgt->mmu = &tmp[i];
> > +		}
> > +
> > +		swap(kvm->arch.nested_mmus, tmp);
> > +
> > +		write_unlock(&kvm->mmu_lock);
> > +
> > +		kvfree(tmp);
> > +	}
> >  
> >  	for (int i = kvm->arch.nested_mmus_size; !ret && i < num_mmus; i++)
> >  		ret = init_nested_s2_mmu(kvm, &kvm->arch.nested_mmus[i]);
> > -- 
> > 2.43.0
> > 


Best regards,
Hyunwoo Kim
