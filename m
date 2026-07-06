Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529223F889E
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 21:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783374366; cv=none; b=rjD5xbMDFEuAQChv/3tJvp9I3DXeeQt90/FbCDuJpa2bKu9pla1PiQWhiJo73FdaXpZS3ETn9NGlAuDP6nimn8KGE3oqoY81vIxji+/0EKOB/OsJKbJg9FirI/U7qAt8Xlzjsynv7qHV81/AAjLdE6zI07VGFFUXsgIOfQQmBYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783374366; c=relaxed/simple;
	bh=3N4ytG+E4H/OljtRigUhcR8G4j5CEvRKQ9nzA6+RjxM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hjZpkDPgJGxxXPi76TiQoW+Id9dOV3hZu6AVuP4CgzjgEVZB1cUuvB8GQs1fjk+gf1npVBWuhIwTOrLE0NbXBDh/KXk/6+ZoHWcKwOCNc8TggwhElgDxU65YpR7YunYwFxcI8j6hD4O/Urv5An43O3PXobSjeBbMm6NRsZ/W7WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U2To6sk4; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U2To6sk4"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c85a298cd62so2985804a12.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 14:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783374365; x=1783979165; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H1AXWpDbuwot7e/IsmprnSM8i9vxDyXshC7OCwJGDTM=;
        b=U2To6sk4/3Q+Qa40U+Y7RuvOsRuJ+8Z6DLzoOFW6Ac1XtCkUIm2x7VnZV4HOQZu1Mc
         +iDwKUo6Fc9uCN2zUpI9pphC5wig74lk1FeEhjyDoJXthhvoFlsRyyhMwl42V1CAp6E7
         2656zepdfxrx3eUYNXgKu5qN4yXeDmGzuvciALLKuyaG17cRwXxzaZFxir8Hs0FL6tRO
         WiDn73cZsrNfagPoKmzxKWCOM8AbPHG8dFbe/hY59nWS2ic5XQecIRdCanEUKazlAZcd
         QybSd4pEUV86KHKnv2/xikh6FFNY4Sj8ehbkglwLgtN3sU5UmpT2DMUxCM7S5dYumGcp
         7U1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783374365; x=1783979165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H1AXWpDbuwot7e/IsmprnSM8i9vxDyXshC7OCwJGDTM=;
        b=YMo9uOcVeBRgLGXGndHmyhS738EwfIN90O7apa9PQrrlE9yoHrUJ4wqJ0GqBc5MuEt
         tMa9gjowDqASgKm1bVbSecnxrkY0qjLUlMzdEAVgb+2itS3Od1g+AFhdcai1qo9M9YgL
         GUTC5UwKqY2oVSR5K0ZG4wGHUnTL0i1HYGk5RpSBw72whrQYiS9t2r9apwjmgUwg8Zlu
         aJmRqL2NHJIcQBDOZ2gyJmFPrDaMMrdLdszu6/SB9Ktj7IiEzKPCAphgUbwRFKhgdx/9
         NjkKydpVyz1MeDJUpTRA38PERW4e/eykHu/YtMtLdn8vHzEVS/gSMxnsU0xajZa4OMri
         yMJw==
X-Forwarded-Encrypted: i=1; AHgh+RqZofyehxNCc5Gk5JcL6szzmBNYyOK+5cdH+vZbMypWTIfKskSUw857n2K4WxsJyrv+LMjWe+k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9zzEuCJDHuAixw8eF6c4qPHp2VuLmZF2rKXmLIUm/MHBx1EDR
	Y2hfMy9tVs4N+/4ZWG3AP2YsRQGR208W01/VrrBawMjoWkzB7IE/YP3OukU4A+7tVhQakVFGyBG
	U7NRT4w==
X-Received: from pgbeu10.prod.google.com ([2002:a05:6a02:478a:b0:c85:a528:228f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:220c:b0:3b7:9c18:c681
 with SMTP id adf61e73a8af0-3c08ec8da6fmr2781635637.9.1783374364514; Mon, 06
 Jul 2026 14:46:04 -0700 (PDT)
Date: Mon, 6 Jul 2026 14:46:03 -0700
In-Reply-To: <akuxjY-VRrmcybjZ@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-2-alexandru.elisei@arm.com> <8a24f016-6f0f-4322-b646-d843f6fa481e@arm.com>
 <akuxjY-VRrmcybjZ@raptor>
Message-ID: <akwiG_tDu5Eyyc0-@google.com>
Subject: Re: [RFC PATCH 1/3] KVM: guest_memfd: Use memslot id to keep track of
 associated memslots
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: David Hildenbrand <david.hildenbrand@arm.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	fuad.tabba@linux.dev, mark.rutland@arm.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 06, 2026, Alexandru Elisei wrote:
> On Mon, Jul 06, 2026 at 09:14:59AM +0200, David Hildenbrand wrote:
> > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > index db57c5766ab6..43ef8e908aaf 100644
> > > --- a/virt/kvm/guest_memfd.c
> > > +++ b/virt/kvm/guest_memfd.c
> > > @@ -25,6 +25,7 @@ struct gmem_file {
> > >  	struct kvm *kvm;
> > >  	struct xarray bindings;
> > >  	struct list_head entry;
> > > +	bool found_memslot;	/* Used for balancing invalidations when punching a hole */
> > 
> > Probabably best to document what it means, not only what it is used for (and
> > maybe document above the member if you end up with more text).
> 
> Sure, this is how I changed it:
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 210bdd76f0aa..3cee64047bce 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -25,7 +25,13 @@ struct gmem_file {
>         struct kvm *kvm;
>         struct xarray bindings;
>         struct list_head entry;
> -       bool found_memslot;     /* Used for balancing invalidations when punching a hole */
> +       /*
> +        * Keeps track of whether memory has been unmapped during secondary MMU
> +        * invalidation, to keep the invalidate start and end calls balanced.
> +        *
> +        * Accessed while holding the inode->i_mapping lock in exclusive mode.
> +        */
> +       bool memslot_invalidated;
>  };
> 
> Hopefully the new name is better.

Why add a boolean?  It's not _needed_ to balance updates, or rather it shouldn't
be needed.  filemap_invalidate_lock() prevents modifying bindings while an
invalidation is in-progress.  It might be a performation optimization, but if so,
it's a premature one and belongs in a separate patch.
