Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831F6383BB
	for <kvmarm@lists.linux.dev>; Mon, 18 Mar 2024 13:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710767475; cv=none; b=aitgJwnHguJNpgeEu5vKZ/mcWnqPZ+sSL71U41HOBPtwsO01g1t5jc3uXcBkqJOqED26PSA5xCIpqk8ZTg8bdorxlCRYDpVlNq4z5QbMAWFd+Y+t4R4/6kQJ1CfJxVjkt+K6rz3ylY4T4TbT5ApcUidnf9Fnw0V7AdufMbwCIv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710767475; c=relaxed/simple;
	bh=6+niSvsrlTdoebUFvZkR5TjyZ5KAxqQlNjvmrnyAdUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O3oFbGYunC03I4XcdoDYo+dBL/PtEU6iBqg5K21nrOYMIPdS0oOulJp5AVnx+Z5ErkpUGZBKxq0L6TjTUia3x3fJA21PcT/gq6fYLo+t1G1QZLtekUhvNsFf9IoL7l/dfR2X86knHJpo60rk5sahl9Q3UTeTRRpsAwfNadOcCW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EBikxk6B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EBikxk6B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710767472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9neb2kg1Bn3mmLQBIkZNqW8zmI6QIZ7MrEWOD5a8wx4=;
	b=EBikxk6Bfxqz8AQ2C2pY9oPygkK1YOByUK0j0zebzb1x6251ktEfanKOr4a+oIhUruLXPv
	v3OwWtcem3DQr3X8qyYdiPU/nWgBU11B0JWohkPPizXSBGJgzhA52wCjFE+ChvN+as6c0+
	vLW6KNu/oCmsUYlUzYuSIPawbVaCveY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-EAdjJGz3NWit8p1xxkrAHQ-1; Mon, 18 Mar 2024 09:11:09 -0400
X-MC-Unique: EAdjJGz3NWit8p1xxkrAHQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33e4397540bso2746536f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 18 Mar 2024 06:11:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710767468; x=1711372268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9neb2kg1Bn3mmLQBIkZNqW8zmI6QIZ7MrEWOD5a8wx4=;
        b=FsmBufVpJegloFstAWooErwxAlyaz1pl63o5NCKiF+NobRSNVioLYpCMIAjprOk9y7
         GUcRNwS6SlW5SvTwzaYu9xcocEYpYyghQwk45SFDEGJgibghL7lN9JsPFzuer9zbGWRT
         1z7XD1SXsTf6ehBouM2ayd/qRD1DfypNebFicqhwBSPc+jMRGuPxHOTNSNtVQrplfEoC
         FjvkBkYOQcDKoOFo0hh+DPmZxOPiY1gr4gw2FxxVET3gVXKPqwqyxFJ6jNZULyi+w+W6
         PMzMu1T6i1w1p/KskA+1szgrax/VtVcZ6dEPqlq9L9Y69i7hHtVKlpdJH/yKO7eiBw1j
         36QQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAh0NtKbU2QNtzE4yrSqB9SoQEHE2NWhdjjK6DhrR5WWqB5L09txBcAmMjucBimeK5hjNjk1U4lUWGBgp4PyXzb/wJOQI8
X-Gm-Message-State: AOJu0YxdegPl1NsSYU6OiU/4cR/e778VTxskGfaH4prOAC8Ouzor1XWt
	2EcSlgcHrDRA/fvv/6hmPhKAECcJqhsTKqwxVU7i19qQ1t13nkNk7jsIMTyLosavWlvmo9bXise
	KjrTHVPCE9TovskKxvz4RvKQmAfepZfGrXicnIl/DpaHdCI1IMvpoV6o9DJG5k32GyTvtE3hwOM
	nri2fOBzSX/gomR5gM3TExjczeRHQv
X-Received: by 2002:adf:e745:0:b0:33e:7621:e15f with SMTP id c5-20020adfe745000000b0033e7621e15fmr8170832wrn.39.1710767468019;
        Mon, 18 Mar 2024 06:11:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyQ6S+WKFdZAsvaIMGYmlFh0x17pkrdrAjmpMvBAmA8hhGJBijSIHID0mFmSY2uazi/xgXq4p4w28uS6bhFxU=
X-Received: by 2002:adf:e745:0:b0:33e:7621:e15f with SMTP id
 c5-20020adfe745000000b0033e7621e15fmr8170817wrn.39.1710767467700; Mon, 18 Mar
 2024 06:11:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com> <ZfG801lYHRxlhZGT@google.com>
 <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com> <ZfHKoxVMcBAMqcSC@google.com>
 <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com> <ZfHhqzKVZeOxXMnx@google.com>
 <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com> <d2a95b5c-4c93-47b1-bb5b-ef71370be287@amd.com>
 <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com>
 <985fd7f8-f8dd-4ce4-aa07-7e47728e3ebd@amd.com> <ZfeYU6hqlVF7y9YO@infradead.org>
In-Reply-To: <ZfeYU6hqlVF7y9YO@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 18 Mar 2024 14:10:55 +0100
Message-ID: <CABgObfZCay5-zaZd9mCYGMeS106L055CxsdOWWvRTUk2TPYycg@mail.gmail.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
To: Christoph Hellwig <hch@infradead.org>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Stevens <stevensd@chromium.org>, Sean Christopherson <seanjc@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 18, 2024 at 3:07=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
> > > Fundamentally, what this series is doing is
> > > allowing pfns returned by follow_pte to be mapped into KVM's shadow
> > > MMU without inadvertently translating them into struct pages.
> >
> > As far as I can tell that is really the right thing to do. Yes.
>
> IFF your callers don't need pages and you just want to track the
> mapping in the shadow mmu and never take a refcount that is a good
> thing.

Yes, that's the case and for everything else we can use a function
that goes from guest physical address to struct page with a reference
taken, similar to the current gfn_to_page family of functions.

> But unless I completely misunderstood the series that doesn't seem
> to be the case - it builds a new kvm_follow_pfn API which is another
> of these weird multiplexers like get_user_pages that can to tons of
> different things depending on the flags.  And some of that still
> grabs the refcount, right?

Yes, for a couple reasons. First, a lot of the lookup logic is shared
by the two cases; second, it's easier for both developers and
reviewers if you first convert to the new API, and remove the refcount
in a separate commit. Also, you have to do this for every architecture
since we agree that this is the direction that all of them should move
to.

So what we could do, would be to start with something like David's
patches, and move towards forbidding the FOLL_GET flag (the case that
returns the page with elevated refcount) in the new kvm_follow_pfn()
API.

Another possibility is to have a double-underscore version that allows
FOLL_GET, and have the "clean" kvm_follow_pfn() forbid it. So you
would still have the possibility to convert to __kvm_follow_pfn() with
FOLL_GET first, and then when you remove the refcount you switch to
kvm_follow_pfn().


Paolo

> > Completely agree. In my thinking when you go a step further and offload
> > grabbing the page reference to get_user_pages() then you are always on =
the
> > save side.
>
> Agreed.
>
> > Because then it is no longer the responsibility of the KVM code to get =
all
> > the rules around that right, instead you are relying on a core function=
ality
> > which should (at least in theory) do the correct thing.
>
> Exactly.
>

