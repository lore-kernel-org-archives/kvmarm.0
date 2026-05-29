Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F160C3403F1
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 10:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780049289; cv=none; b=pSXoCDamaELlOWMBgdsjoDqkL2RpjrFQGUvyDBUoVR7r2xuVYDhwY+UVJMPA++QhnLpqiTZDJ+cGzA14FrhbALOrmWAVgdn6j8qu9jFjctp2nzSt5PsGl0OXSLZm+kFhetchyBV4If7ijM3UKgAkLOxwD/FnqVyF268ep4EZiQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780049289; c=relaxed/simple;
	bh=VLrSr6znP2Jb1CNBZKlAy9slLm27Fo1ks9K+hx9L70Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+ogXX53PIDC/J7Pjx4C6bc/xUUCb0r1JI5Qp1pPUWQPkF/pg/gdqzv1KHsohcJxsbXPpxfRT4mphy6nqOb077PWxK35u87puMFzg6AI7vv0m5SJikDSbUzV6YYnBmIlbmnv4o0cOqPkJp//faLhnJ9vwONAI1GcBPlpbEZC/vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yo2n9P1v; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yo2n9P1v"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891b0786beso91744885e9.1
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 03:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780049286; x=1780654086; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=695o6Vsk+rg4TEq2m0E4aPhfvl/ze1rK746wt9maXiQ=;
        b=Yo2n9P1vc+Dt6paG7e+SwMTJgmTIbuXoEiGHoytvdE3jk3+/fhMltVnxtMVGPBYfR8
         QqIVKYPkn3AENmDpvihMYIQcM9lmXROA3K0sNRKHSTsbeVyPQkGTjofe4BgI7r748NeD
         CNQH03w51P2yu3kwyLF4vhW08XjzM+i9GmrHiv2E6fzk5f2BMJaxTTYsyia13ccQOijM
         11ptwo5NayWfWBFZuFFpSUTZOv4nbbXwvzDv9KRTjzZiYV2lbmOLtrRDLz2dkleJTLuZ
         Q3rlLacdgWgYu6B2HUlyr8bkfMT/rYTUsCE3xlzxVF53yUTZe5l11oLIOvDwmYujwf+z
         kOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780049286; x=1780654086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=695o6Vsk+rg4TEq2m0E4aPhfvl/ze1rK746wt9maXiQ=;
        b=NodZ+Z9Hp4Nri3zOH6tAuP2uycjZikrnEKrDlrYTQb66B1cXUfGtM2RX4NsBgdXlmE
         3Vll8NoAb3HSkFRIm2vCdwc9p5Ecry2W8n6A1cxBZxFhide9oF8A9PcdwGF+/QswV2Ai
         Zbr6/hT51MvEM+OnWj4IzqoixYpkyKJ31ine3EJHb0MLrpc7CKpciDkHhMnQHH4nL1zM
         XDTpKoLL5g4LUXNx2fHqNovs8ATugfsqP0FstynZMRcL+XayGbWArLsWME7aXB/4Ukm7
         Y/KbDJgHkFKd7XgQ/kx2M1kQBObGSRR/9Us4gAXP9G+eceDMRXMrrzyrkC8o+z7k3cH8
         JqyA==
X-Forwarded-Encrypted: i=1; AFNElJ98cJlj6X8/C1o782USKkZZT7xjBNx3XH/3K1/qRVsi0W9qFFmc1Ea9nE+HCyu1wCMSYkLNI+4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVPAoqUfvB7U5SuD87ThRmf/Kbbg9Otpr2nbnLe/w+HZarCAnO
	KarqqAGEti9gUhTAn4HSy9RHNXmotMqMYspLoR4u6cD25K8IsFLv64qUiiOJKjr65Q==
X-Gm-Gg: Acq92OF/jOX29FAYSrLb2zo11k8Ab9fdhmDqt/CebYXn6JVoz754vDI3k7jUfUmDpXW
	Rruj6Uc0JMokGfQfuGMrhxuZAL/+RB1Nx8OCGwMsvmhwwl22dTXlLZC+Dgyqc/7ix8a7IhK2h3f
	p5IcFAXpiLJrUd/SUy4Yn/1eO1r2J8r7BU+BDo1gbyDN18Ih+XcDySdwyaz2NRr7yRMfFawgTB7
	nVO32K9/2/ukTD16HJ09KBZvXDvkXWQrAF1+Y+vA1gx6KYzJLzp/4hMHSyRbYgJMeucXs5zxZxM
	YzwEJyW7RP07McRtkyfz4O7SFaFBQr54E1UaUjNjzGQd81+oCwHkAsKY340VhfZa1JG5+QuoHqU
	K7y2DkGT+hpKpUJWmLUtkcmkc1qpLrcY6P78B2pqjHvaVV4+Cxpk9YCZieunFktmc9rxFtcg6Fw
	Y1Lti9ObRN5NY8EkdWvLlJZ9tkqfNA4VGnMccfjmCMbf8y1Ei5VVugqJ1jppc8sg1weu/czIJtR
	0xYFw==
X-Received: by 2002:a05:600c:6287:b0:488:a882:c7 with SMTP id 5b1f17b1804b1-4909c0bce7bmr41795985e9.25.1780049285690;
        Fri, 29 May 2026 03:08:05 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c12f4d0sm11602305e9.34.2026.05.29.03.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 03:08:04 -0700 (PDT)
Date: Fri, 29 May 2026 11:07:59 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Fix host/hyp tracking on share/unshare
 hypercall failure
Message-ID: <ahllfyVfQw8G3tFX@google.com>
References: <20260529074341.2271950-1-tabba@google.com>
 <ahlIJQU-1b0mayPP@google.com>
 <CA+EHjTxktk4-B6qcAOf4O26++M5s6CKkkP539s4dRBRWxZN83Q@mail.gmail.com>
 <86a4tivdh3.wl-maz@kernel.org>
 <CA+EHjTykVY6x+iFwSFH7MaK7rfV5CTSeFwx4cZatbB+Fuzu9Yg@mail.gmail.com>
 <ahlapmZj4wnce__B@google.com>
 <CA+EHjTzpKjs-xFC=5cQ33Ly2O7qkNj=yJSzOSjx0SpyBjKFdbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzpKjs-xFC=5cQ33Ly2O7qkNj=yJSzOSjx0SpyBjKFdbQ@mail.gmail.com>

On Fri, May 29, 2026 at 10:23:22AM +0100, Fuad Tabba wrote:
> On Fri, 29 May 2026 at 10:21, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > On Fri, May 29, 2026 at 09:20:50AM +0100, Fuad Tabba wrote:
> > > On Fri, 29 May 2026 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > On Fri, 29 May 2026 09:05:35 +0100,
> > > > Fuad Tabba <tabba@google.com> wrote:
> > > > >
> > > > > On Fri, 29 May 2026 at 09:02, Vincent Donnefort <vdonnefort@google.com> wrote:
> > > > > >
> > > > > > On Fri, May 29, 2026 at 08:43:39AM +0100, tabba@google.com wrote:
> > > > > > > Hi folks,
> > > > > > >
> > > > > > > Yet another bug I found while testing Sashiko locally with fixes to
> > > > > > > review-prompts.
> > > > > > >
> > > > > > > share_pfn_hyp() and unshare_pfn_hyp() in arch/arm64/kvm/mmu.c
> > > > > > > maintain a host-side RB-tree mirroring the set of pages shared with
> > > > > > > EL2. Both invoke a hypercall that can fail (page-state mismatch,
> > > > > > > EL2 refcount still held), but neither cleans up on failure:
> > > > > > >
> > > > > > > - share_pfn_hyp() inserts the tracking node before the hypercall
> > > > > > >   and leaves it in the tree on failure, leaking the allocation and
> > > > > > >   presenting a phantom share to a later unshare.
> > > > > > >
> > > > > > > - unshare_pfn_hyp() erases the tracking node before the hypercall;
> > > > > > >   on failure the host loses its record while EL2 still owns the
> > > > > > >   share, breaking later operations on the same pfn.
> > > > > > >
> > > > > > > Severity is low (no isolation impact) and the failure paths are rare
> > > > > > > in practice, but the desync is real. Both patches are independent and
> > > > > > > apply cleanly to current mainline. In other words, this can wait for
> > > > > > > 7.2.
> > > > > >
> > > > > >
> > > > > > I believe I fixed that here lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com but
> > > > > > as Quentin pointed-out, there's absolutely no reason for the hypercall to fail.
> > > > > > So I haven't sent a v2.
> > > > >
> > > > > At the very least we need to add a comment, otherwise, people like me
> > > > > and LLMs like Sashiko would stumble upon it.
> > > > >
> > > > > That said, this fix adds no real overhead, makes the code clearer, and
> > > > > guards us against a future where that call might fail.
> > > > > Self-documenting in essense.
> > > > >
> > > > > WDYT?
> > > >
> > > > If a hypercall really cannot fail, why does it have a return value?
> > >
> > > Good point. If we know it cannot fail, how about just `void`?
> > >
> > > That said, Vincen't exact words are: `very much unlikely`, not the
> > > same as cannot fail :)
> > >
> > > https://lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com/
> >
> > The error would happen only if the host tries to share/unshare a page with the
> > wrong state. This would only happen in the case of a misbehaving host.
> >
> > And Quentin's point was that this is anyway incomplete. To handle this error
> > properly, kvm_share_hyp/kvm_unshare_hyp would also need to rollback things...
> > The callers of the unshare should also leak the memory which couldn't be
> > unshared properly. This isn't the case now, (however we do WARN_ON).
> 
> If we WARN_ON() in hyp, then I argue we shouldn't have a return value.

I meant the WARN_ON in the host's kvm_hyp_unshare()

> Or at least add a comment, BUG_ON() here. Think of the poor LLMs and
> the people who run them :)
> 
> /fuad
> 
> >
> > >
> > > /fuad
> > >
> > > >
> > > >         M.
> > > >
> > > > --
> > > > Without deviation from the norm, progress is not possible.
