Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E417612B75
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 16:34:51 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-263036d4bc3so3436199a91.2
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 09:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689006891; x=1691598891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=McmzJB5w4UGeZqusQBhdxfjqigG3UhKtoIfFccLuj2s=;
        b=UuZrn4FN/UbJwfewh85rKzjLye9uELQEX45+YZjjYTP/BYBPgS+1UF+XIPNG2dESCU
         W86RtEBWvSwsPMW2x13eLsYhpVucWKpqju+x0agjnUbM9X4mJPFqV5rxvm4kT+xeCHJ2
         VLT5n9dF1ENtaArZbX2UUhZour8m8LNq5DgukydBxaU2fh8GLhckDOL0rRtQHMK6r9Zy
         jdOMwsf8im36X5gkixxf9GaLSAwdB6NrArpT95n6SO2ZLoGIlJK/Rxm4qX2jwfk/k1E7
         Ou/qPcZpE/ua9W+K5ji+Kqm43nFA7KCT2k00BsUZLSUM4S3DFaj6X8Q0tH21tk5YJKRc
         ar2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689006891; x=1691598891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=McmzJB5w4UGeZqusQBhdxfjqigG3UhKtoIfFccLuj2s=;
        b=I4fLq0eNwZn2mp6/1K+/SM9ZRB9vsc7Nd77OXy17gALbloH2een01ZuqHXGTapqVt/
         g/5JGkNon2mLOLROqS/Bv8ZeTWispDyi/8C+YVtHTxiXrgX8tqYLp88Tn6wrQQJhKPc4
         mf77vHnW8o6/uPH+tVJzvf/WsviJ1r823sz08qLSAgeCZu6AndS/FgJ5whEztO+Yf1b1
         ewKwSnk2Qm3O8o5eH9VbUoHO3ZvWhY8Z2TJbvZAHPcm1HfKuT5FC1IE5oGjRctKg6eJN
         MIZNUPqhA43DAgBrZ0eXuR92H9vx0q1YN+Iqp1P60joaZxbaJWkBTsZZdEZX1cXm5Z6V
         6LFw==
X-Gm-Message-State: ABy/qLbCrroxT+O1l2AR+Ilr+Ccume2pZsJmpm0jjtumsZVJ0i6y/fK4
	m23sEv3Sw2bFUemWZEuygRE=
X-Google-Smtp-Source: APBJJlFGgItLHZLzX11JZjIS73D9W6Es/hAVqOzRDVW3J19VHlBJaksBcwskjpiGnATOLXIP8QCxUQ==
X-Received: by 2002:a17:90a:b315:b0:261:113e:50d2 with SMTP id d21-20020a17090ab31500b00261113e50d2mr13856226pjr.31.1689006890824;
        Mon, 10 Jul 2023 09:34:50 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090aae0800b00263f40cf83esm6456783pjq.47.2023.07.10.09.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 09:34:50 -0700 (PDT)
Date: Mon, 10 Jul 2023 09:34:48 -0700
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: David Stevens <stevensd@chromium.org>
Cc: Isaku Yamahata <isaku.yamahata@gmail.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to
 __kvm_follow_pfn
Message-ID: <20230710163448.GE3894444@ls.amr.corp.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com>
 <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
 <20230706155805.GD3894444@ls.amr.corp.intel.com>
 <CAD=HUj6GiK3TSSe7UY8C2Jd+3tjZNBa-TLgk-UodyL=E+qKavg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAD=HUj6GiK3TSSe7UY8C2Jd+3tjZNBa-TLgk-UodyL=E+qKavg@mail.gmail.com>

On Fri, Jul 07, 2023 at 10:35:02AM +0900,
David Stevens <stevensd@chromium.org> wrote:

> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > index e44ab512c3a1..b1607e314497 100644
> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > >
> > > > ...
> > > >
> > > > > @@ -2937,6 +2943,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> > > > >       bool host_writable = !fault || fault->map_writable;
> > > > >       bool prefetch = !fault || fault->prefetch;
> > > > >       bool write_fault = fault && fault->write;
> > > > > +     bool is_refcounted = !fault || fault->is_refcounted_page;
> > > >
> > > > Just wonder, what if a non-refcounted page is prefetched?  Or is it possible in
> > > > practice?
> > >
> > > Prefetching is still done via gfn_to_page_many_atomic, which sets
> > > FOLL_GET. That's fixable, but it's not something this series currently
> > > does.
> >
> > So if we prefetch a page, REFCOUNTED bit is cleared unconditionally with this
> > hunk.  kvm_set_page_{dirty, accessed} won't be called as expected for prefetched
> > spte.  If I read the patch correctly, REFCOUNTED bit in SPTE should represent
> > whether the corresponding page is ref-countable or not, right?
> >
> > Because direct_pte_prefetch_many() is for legacy KVM MMU and FNAME(prefetch_pte)
> > is shadow paging, we need to test it with legacy KVM MMU or shadow paging to hit
> > the issue, though.
> >
> 
> direct_pte_prefetch_many and prefetch_gpte both pass NULL for the
> fault parameter, so is_refcounted will evaluate to true. So the spte's
> refcounted bit will get set in that case.

Oops, my bad.  My point is "unconditionally".  Is the bit always set for
non-refcountable pages?  Or non-refcountable pages are not prefeched?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
