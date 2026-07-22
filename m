Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A061F4CB3
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 11:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784721141; cv=none; b=QoaPXNVBzLwGChV5JLsgCdt3AJ79J2fCBJ0jyrLxabMYR87DXeIaAFnIo4Zh6nApHRBjWyNKdXuith/OVEodryyXhG3mFX7/1lqKLkK/LWuXRdiWBBHP0G/3r9E5p74yoPOPSNtM2s6N+XI4Z76I9j6kgKon0VZ9CZMFlqQEok0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784721141; c=relaxed/simple;
	bh=hdAPbluOOCHMnr6b2tjeruX2akiUqzneuGvwHZGpWnw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rFhHlaVtvaoFpfMGuAsZnxRXTgeDRs6QO9LV54dompgtVdjXCvgnGWcyvwHKv+3DbBodCHpw4d1x1gys4R8VjdCp1wKQCwHJTNKFG1R6hKnEvY59mesJmLAoSUYmIFf1pqZc2Kr2gh9c7tq5t8hiSDuJN9ystbb0p+FdstQo/j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=For3sVmn; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="For3sVmn"
X-Forwarded-Encrypted: i=1; AHgh+RrNGJSSEL01CP6VffnL4zoOVtsF39/4V+tP10wYAqbGQWJ0XCh5RxpWzhByGCY11ckq5fzZlRA=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784721136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yvrTKQMuH/eIiqrhZIkhsy/BDXpf6gi3fx2V0TPVyqE=;
	b=For3sVmnjySi0O+ZSSX0/zCcmAPJY+Rjn74T9NM4vSYMCMlOBRdkLxRqi0Sub0Fs7nVZ0R
	M/utwa6Vcw+hA8y1ZpFlGZ9Q3wI75Ba2PFQIWgUOAt3Zf78Ld58Vv+qTNMfJE1y7hwww7z
	b8Ao01ILgpe4QDUL0/R+iCGvnc3mKGQ=
X-Gm-Message-State: AOJu0Yy0jpOQTonjj4cVeAHfzrG1kP+boKgLvxTTd1dnDidHltZEwUq7
	lPrmdOAFnOT31mYLyL/BT1oqWM7hVHT/ltok9N5RpAmPP8iNjTA8sbIIFnae+KEZfk/dOGTJZP4
	EvdTcc0z0/luwaC7ASyCgqSyu1IiRWEMXO3NpdOwG
X-Received: by 2002:ac8:5d14:0:b0:526:d7ae:8eb1 with SMTP id
 d75a77b69052e-527efb1cb7bmr7672571cf.21.1784721132970; Wed, 22 Jul 2026
 04:52:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260721085646.1660673-1-smostafa@google.com> <86y0f4ejr4.wl-maz@kernel.org>
 <al9HqhO6sp3FFbtQ@google.com>
In-Reply-To: <al9HqhO6sp3FFbtQ@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 22 Jul 2026 12:51:35 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwp6gQDjL5uE+aAJ04yRnPgvABgBaBWe44hyVSMXGQP9w@mail.gmail.com>
X-Gm-Features: AUfX_myxGfq1s8jj6zkDmzja_7hOKzisg2DOisitMb1W1idiDZ-akaduHbBJtgw
Message-ID: <CA+EHjTwp6gQDjL5uE+aAJ04yRnPgvABgBaBWe44hyVSMXGQP9w@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Optimize protected mode and FWB
To: Mostafa Saleh <smostafa@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 21 Jul 2026 at 11:19, Mostafa Saleh <smostafa@google.com> wrote:
>
> On Tue, Jul 21, 2026 at 11:10:07AM +0100, Marc Zyngier wrote:
> > On Tue, 21 Jul 2026 09:56:45 +0100,
> > Mostafa Saleh <smostafa@google.com> wrote:
> > >
> > > KVM opportunistically enables FWB if supported by the system for guest
> > > VMs, which allows it to elude cache maintenance for data as they are
> > > forced to be cacheable from stage-2.
> > > In that case, __clean_dcache_guest_page() will immediately return.
> > > However in protected mode, before calling __clean_dcache_guest_page()
> > > it loops over the range and fix_map/unmap it, issuing TLB
> > > invalidations, dsb() and isb() unnecessarily.
> > >
> > > This can be optimized by returning early if FWB is supported,
> > > kvm_pgtable_stage2_map() already issues dsb() and tlb invalidation
> > > functions issue dsb() for the unmap path.
> > >
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > index 4e329e39a695..049a09be2bbf 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > @@ -261,6 +261,13 @@ static void __apply_guest_page(void *va, size_t size,
> > >
> > >  static void clean_dcache_guest_page(void *va, size_t size)
> > >  {
> > > +   /*
> > > +    * Guest stage-2 uses FWB if available, making it safe to elide CMOs.
> > > +    * In contrast, the host stage-2 never has FWB enabled.
> >
> > Beeeeeeep!!! Since a373930ec9406 ("KVM: arm64: Switch pKVM host S2
> > over to KVM_PGTABLE_S2_AS_S1"), FWB is enabled everywhere when
> > available.
> >
> > Not sure that changes anything, but the comment is factually wrong.
>
> Ah, I see it uses KVM_PGTABLE_S2_AS_S1 in that case, that should not
> change the patch, I will need to update the comment.

Sorry, this confusing is partially my fault. The original comment in v1

>  /* See __clean_dcache_guest_page() */

wasn't very clear to me, since I wasn't sure what I was looking for in
__clean_dcache_guest_page(). Talking to Mostafa in person, he's
referring to the comment _inside_ __clean_dcache_guest_page. I think
the best fix is to rephase as

+  /* See comment in __clean_dcache_guest_page() */

This would save duplication and having to repeat the comment.

Cheers,
/fuad

> Thanks,
> Mostafa
>
> >
> > Thanks,
> >
> >       M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
