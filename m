Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E6A19E83E
	for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 13:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732885850; cv=none; b=MKsfpO0ifg60i9VhvKGy5spSEoMx3E6TpwFsTsxreJJe+WYef223qPMakUwgQSpVZ6iQPU0lnZnF69OuYM4okT+vyOMkpfFOavr+21YDY4GDyBb/A+LIff6XTPDkYwaJP1xKlfdaRbRMeqOoNOQbO125h+Ujt1LE4r5Cn7FdQxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732885850; c=relaxed/simple;
	bh=2tCjuOPED//3wVHlOYnA5EqRmXXYDjuVZ5VnkrbozuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CMmvdFS97O6D53teRdNawQCj8R34ifEZ376YzpQRIk4kfrqjrZQiheqC/5oOgf0oeX9VS+5Ph7V6rb9tPdmrvk43pRMGPVekTzPq/yNjIGTARNtQXKAfwyvtT8JhTqIs40BhKkzBM/mm7pf+BrLgPs368X6jYFbgJMW++4gK0HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Olv2ieB9; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Olv2ieB9"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa535eed875so265708966b.3
        for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 05:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732885847; x=1733490647; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hm3r4VcFovoN7vV/Z/7/O6DCsQhUW6XXm/ZhBzyEdx0=;
        b=Olv2ieB9+iHt4bPMxCBCwnWgk6A5272U2+4N1jlQHFyKfuJ8yPtZggIPg4tjcg1dXs
         QDYNzUr0vNtjYvZp6VC4IG3sb/cZOroDTe4QG7+podsbdjadk7xNyM5f+N8fP4X5iXtC
         VQJCnWd4XmlLy9mKYd0VRcGwD4yKpeudXdEn4mP4d65ZUMgk/JWh7H+ruHVI4xJzVrFL
         TcP8Sjm55w0dcJXKfMJYg7acTtMjpl/g4e+9HokdfLggbEQitggSpL+0mty5s6aa4dJ6
         6fqdbiszg/VvVfiflCIp9eV1wnqMrOP+HD2p3uq4bjehNHo0rO+onDqj3HbrWsP9CVka
         e21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732885847; x=1733490647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hm3r4VcFovoN7vV/Z/7/O6DCsQhUW6XXm/ZhBzyEdx0=;
        b=a1Pz4d92c1T2V84SMglRFI/aBeibCjAOKMjXa6BKDiK5ppIQLGFKLC6rpi4Jpb3jTz
         +xdN/N73M9vTN00RG3jlqN2xSLAtpAvfNUZQxfv1Z5Nh+wIuY/SjM5LM2tPyQOGDaSOj
         kpQR1N4jpz0Lvi9ynNZXhA/3ZGy3UUiNDaFckcIDyBcdwmw6x6ulxfjIctS+rYQZRuRU
         Wgl8RN+3VGff11RLXlgfaFruwkEwpillooq33mnsRAIQYzpyD3vMdLyP7MgdNFEfQd6P
         b8Tpsjl6omlvXPI+alp1tcb6r6sxfLqauE+9AVSkBVDi+navpYhWWV9JLiIPRaNvXgha
         KbSg==
X-Forwarded-Encrypted: i=1; AJvYcCUrf53LbI2CTCQq2xWbE3WzMQkHsewXMYs7XrBk9b/fsFntjxPjExwBuezoSm/tx2iPOxnbgBc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2h3esj3SCZ9vHEY0XNIGHYM3BZhKxGtl+9UtLXn098z9Btc8+
	Z0NAJsU53F4nNgbMOlrOIIlmy8BE18k1YFCP8QE7X1OmDxN6ANsdhyMu4lhB2g==
X-Gm-Gg: ASbGncuIqp2ZbZc1znIu/Cm7hwlUu6//8TrfdvNx0NCDwvnoJJEnxFQD+JQTqk5J2DP
	eqEjN5DYdGUqXUfiymp6m/d7G9PmDtc4MS2MUVhJB8Vz18MzKHaD2YwfP50FlLYKyuJlOfbaEoV
	75f6QPvwLKvboarxgsZYGDnhQggzwX1Z4PUPirabK0WkyrwaocUq96yUr2OPJHLHxxhkJEMspGT
	o+XI07XMkjV88QZ+j83lhh152kfdZ8iXLl3I8Qy3GGRRkT7RhaX9jUbqnczcsFRdIKAW2A7efKC
	/6XmZqw7
X-Google-Smtp-Source: AGHT+IEWryAv62jI6ZAYM2AouC0F8zHOcrJl/X+93V7MahOSmgmNr39a624Qy4c77JELRVfcnOj3xA==
X-Received: by 2002:a17:907:7852:b0:aa5:1d0c:3671 with SMTP id a640c23a62f3a-aa580f2c498mr828473066b.23.1732885845504;
        Fri, 29 Nov 2024 05:10:45 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5997d55eesm172306766b.80.2024.11.29.05.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:10:45 -0800 (PST)
Date: Fri, 29 Nov 2024 13:10:41 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Always check the state from hyp_ack_unshare()
Message-ID: <Z0m9UXJYcjzf-pgX@google.com>
References: <20241128154406.602875-1-qperret@google.com>
 <20241129095812.GA4298@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241129095812.GA4298@willie-the-truck>

On Friday 29 Nov 2024 at 09:58:13 (+0000), Will Deacon wrote:
> On Thu, Nov 28, 2024 at 03:44:06PM +0000, Quentin Perret wrote:
> > There are multiple pKVM memory transitions where the state of a page is
> > not cross-checked from the completer's PoV for performance reasons.
> > For example, if a page is PKVM_PAGE_OWNED from the initiator's PoV,
> > we should be guaranteed by construction that it is PKVM_NOPAGE for
> > everybody else, hence allowing us to save a page-table lookup.
> > 
> > When it was introduced, hyp_ack_unshare() followed that logic and bailed
> > out without checking the PKVM_PAGE_SHARED_BORROWED state in the
> > hypervisor's stage-1. This was correct as we could safely assume that
> > all host-initiated shares were directed at the hypervisor at the time.
> > But with the introduction of other types of shares (e.g. for FF-A or
> > non-protected guests), it is now very much required to cross check this
> > state to prevent the host from running __pkvm_host_unshare_hyp() on a
> > page shared with TZ or a non-protected guest.
> > 
> > Thankfully, if an attacker were to try this, the hyp_unmap() call from
> > hyp_complete_unshare() would fail, hence causing to WARN() from
> > __do_unshare() with the host lock held, which is fatal. But this is
> > fragile at best, and can hardly be considered a security measure.
> > 
> > Let's just do the right thing and always check the state from
> > hyp_ack_unshare().
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index caba3e4bd09e..e75374d682f4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -783,9 +783,6 @@ static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
> >  	if (tx->initiator.id == PKVM_ID_HOST && hyp_page_count((void *)addr))
> >  		return -EBUSY;
> >  
> > -	if (__hyp_ack_skip_pgtable_check(tx))
> > -		return 0;
> > -
> 
> Acked-by: Will Deacon <will@kernel.org>

Cheers.

> I suppose __hyp_ack_skip_pgtable_check() is now quite poorly named,
> since we only want to use it in cases where the page is PKVM_PAGE_OWNED
> by the initiator.

I don't mind the name personally, but happy to respin if someone can
come up with a better one :-).

> Hopefully nobody smart tries to add it back here!

Right, so here's a patch adding a selftest for this stuff:

  https://lore.kernel.org/kvmarm/20241129125800.992468-1-qperret@google.com/

That should help catch future regressions in that area.

FTR, I've started hating on the skip_pgtable_check() logic altogether as
enabling CONFIG_EL2_NVHE_DEBUG happens to 'solve' the problem -- it's not
exactly intuitive that enabling debug options improves security. The
np-guest series moves the host state to the hyp vmemmap, so we can
probably nuke __host_ack_skip_pgtable_check() with that as the check
becomes really cheap. And we could surely do the same thing for the hyp
state, and just always do the cross-check. I'll give it a spin.

Thanks,
Quentin
