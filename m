Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7E1431E5D
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 10:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784629170; cv=none; b=FMjyUGRTB/v+dCmtwViSVHplj2Pr6KEFgs409d2csBqEO9vJTIkAGHvVdeGGfYnhnQutTyBlQoR8IaEhsdfNEedFwnpREmpFixcfvLY37vKrTWxVDKlYRwWiey1E5mXqn7K4YJ6HUmWvG9EEEJTOr7BhSQHRoZgCmgu5ubHlN4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784629170; c=relaxed/simple;
	bh=eSm5wrlga3AWz+thbSYRjW/00aUtEdcAAvw7zwTxUhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNRwWaJ963SCIiJjslq/cIdAOYH8Obk8iznh9UEnUrn3FCTFjbiTVdxE9XyQiLToGcHUSi6o0SgVjsRATdtG+wjXq78Ll1IveAEaohTjL7u7Luo8goH4EzlYhcTHRN6pztK0mrkhP7qXIuArI6j/LVkoIMKwonrxutRfFJaYE/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NmUMir5v; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NmUMir5v"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-495509b08ebso120885e9.1
        for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 03:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784629167; x=1785233967; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7MJ40kT4710HmcEWSuZdjclOwHS9zhiVrIrryh8M1XY=;
        b=NmUMir5vb2cJ3ydqtwCKEL+IQLxdfT26/CsYL8SwZRiUePaAQN6BkAg3cTPCCXh7se
         LZRgTc3PsmKwDHPTXPFw+yZ0YBd+T/StpcQCEiDPNaRT7LW3mhWgAYWSFK/MUUUK0tGp
         BjtVcClmljP9oYjn1pq5HchvjpDr8KaDWjSnJzLU8kDuO24ammHjRdLdOSBMy0+Ld60s
         vlyyZN/+WAtYRqHKi7rwUQI+FDp8ARzn8uv+JD/DU08qcZvwjkdcOWqaINTYSqFasVUd
         9aE+trGODvISi0hM49Fj59tGqrEcV1PTPpY3GhcmRXVdT+f745b6hWltys6GnWTlvOGy
         qRbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784629167; x=1785233967;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7MJ40kT4710HmcEWSuZdjclOwHS9zhiVrIrryh8M1XY=;
        b=jUPlFoHiUFwL3sYhYtVH0qKyelDp/X3OAD5jJy6Spl2yTy69MscAEPUS4A9Yqxl8A2
         er2b7P0iLzK68AUdF31unf15pNxQ3VZ/yHGizDAoDPRfDhGiSMGGiQSfxd7O0zADz48a
         h3zwH6Kxfd5J57ePZyWHmvPzwVx6X46gXeFI90FVdIPTtPK0T3oyxNlqBHVAqfWitHOB
         pLzUhzaM7UywRuvPdfN1RE7E2nQkPMP11aoKSrAJJVfNRb1ChND0zodeCSrWhpUuhPaV
         OZsNJW5khFCQejaNbWXD3E5ePn52wxcuRS6EXtdwSHWvmndhJ9y83ln9nG7jntD3kT8i
         p8IA==
X-Forwarded-Encrypted: i=1; AHgh+RoFwrrqC7meE1cxeV4rIMW8Y2C4viA+ebeJ5CIIQNwxgplPAL0nysoH2EBnQMJF56tdm8TfE9M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyi9lldS1kDgDXRrcfnCDoaOLDP4xAnzDPdrocdOgYmOyuqY09w
	n6tHk5Pn15S8CO8Aox5wlRrnyON/jb/R5NW84C7OV05O7D+Q5FIEYnCAlkCoCqsUOA==
X-Gm-Gg: AfdE7ck7unlps9s1AC5QQBasb5WzHcAVVh1EJzBLOSmPZ6EiHm0CYwcCJldIvSRpp/p
	9X88/7mJVNi4GhUTz585tKOScCeU4YeLxrxhUML5Rbl/gTXRwXkiNRnwjiINGZbM37sG8cDu8pY
	upOFxKHndpuJzlmTO+GzwEQFxZPnk/UUUG6Eqa8fjs0oDoquL8/5eqVUrnbFudnatCRjWKUJf65
	pFlXzTebclQ66Ng7otHXn3VrZj6PriyFOxULhfnQMRRNsQzboYG+xihqwcWHSJ0FoKhfeYecui9
	amBNo3IIhma+CGBNgC3YvQsiWb4BztYCgYi7jFtcSGUB1ZiTPAoaBdhzPQsZBufrn8bmJNr7HaA
	lSHf95SERBwNNQVWBCm1vCGKDMgutWW0KlZo3Y3rIG4xP5SCcCmbhftSLTjp40wDxn0pz2rWLhw
	mESl3Vft+CAr9QMmiAbhhqxwpD7HtOhLn/P/xwAA==
X-Received: by 2002:a05:600c:300b:b0:495:4747:548b with SMTP id 5b1f17b1804b1-495642ea594mr1062635e9.0.1784629166651;
        Tue, 21 Jul 2026 03:19:26 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ee926dsm35363290f8f.35.2026.07.21.03.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 03:19:25 -0700 (PDT)
Date: Tue, 21 Jul 2026 10:19:22 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, oupton@kernel.org,
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	vdonnefort@google.com, tabba@google.com, sebastianene@google.com,
	keirf@google.com, Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2] KVM: arm64: Optimize protected mode and FWB
Message-ID: <al9HqhO6sp3FFbtQ@google.com>
References: <20260721085646.1660673-1-smostafa@google.com>
 <86y0f4ejr4.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y0f4ejr4.wl-maz@kernel.org>

On Tue, Jul 21, 2026 at 11:10:07AM +0100, Marc Zyngier wrote:
> On Tue, 21 Jul 2026 09:56:45 +0100,
> Mostafa Saleh <smostafa@google.com> wrote:
> > 
> > KVM opportunistically enables FWB if supported by the system for guest
> > VMs, which allows it to elude cache maintenance for data as they are
> > forced to be cacheable from stage-2.
> > In that case, __clean_dcache_guest_page() will immediately return.
> > However in protected mode, before calling __clean_dcache_guest_page()
> > it loops over the range and fix_map/unmap it, issuing TLB
> > invalidations, dsb() and isb() unnecessarily.
> > 
> > This can be optimized by returning early if FWB is supported,
> > kvm_pgtable_stage2_map() already issues dsb() and tlb invalidation
> > functions issue dsb() for the unmap path.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 4e329e39a695..049a09be2bbf 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -261,6 +261,13 @@ static void __apply_guest_page(void *va, size_t size,
> >  
> >  static void clean_dcache_guest_page(void *va, size_t size)
> >  {
> > +	/*
> > +	 * Guest stage-2 uses FWB if available, making it safe to elide CMOs.
> > +	 * In contrast, the host stage-2 never has FWB enabled.
> 
> Beeeeeeep!!! Since a373930ec9406 ("KVM: arm64: Switch pKVM host S2
> over to KVM_PGTABLE_S2_AS_S1"), FWB is enabled everywhere when
> available.
> 
> Not sure that changes anything, but the comment is factually wrong.

Ah, I see it uses KVM_PGTABLE_S2_AS_S1 in that case, that should not
change the patch, I will need to update the comment.

Thanks,
Mostafa

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
