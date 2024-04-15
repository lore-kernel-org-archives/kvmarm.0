Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7641582C88
	for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713200635; cv=none; b=QVezc9lY/pcGXD20gbKJ/bjCuUPAdoRae0/jK2d4TI9orpzMbUyMzBHQhD70cQndVPieCbS/8QmbBDdqHwEZ6tSKimIRUwtaBgeQKIZhz+1jdszeqL+xhKDYcMxS+2oOxQZq3sRo3/hHUefFCCOnD3FC/IvyeyYYBpwBwj6R38o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713200635; c=relaxed/simple;
	bh=irgloZCVTvzuDkYp0ohKwo1sf7N8wth+rz+R9T7PAmU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dCVr4HHeDmQ8Qf5PrF6JkIKaMY7SV+jCyO09q8HjuFkYT0uHlfHN7IFQg+kw6eOA+HMz07Jc3m5elQOUbJTX/KjcYagpRxNPkwKymH/5t3et+Hk1LkGA0vgM0YFwRmkpwCgTxuT05DgFaYZo1e3E5T4T4EbRfAGKb+bhcDDedpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eyi9uqxX; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eyi9uqxX"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f00a42c5bbso478313b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 10:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713200633; x=1713805433; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zfqt/NgDwjKFxB5AgyRPdEKVaYoxBURY78UkNYsrqoM=;
        b=eyi9uqxX/v8JCho2O5pEfp9SxQcwgxGxAf50uouMGBe+Plw1Mo61C2Jq1K51ZsJKYq
         UAfrDICoWsZ6mMvxnEGkfdl3oqw9sJYSgYT6cXerhF40WbXHaD7NHFJ1jVsD9dYOUPOl
         pym00ADuIi3GZoYxVFdrMtFmzuYhvRi0jphKJF2oyKES2qen83j8Exb/kZXe8dIyUWgH
         Dil5engk63hQjxnMHjh7qtFl3ascGGqDKWzZ1aAsgnAJCcBfGMvetdwXxyA7sA8DHlaf
         rgsF2T/LhZhUjRHHgkOsQoyG8IL4FzViffSe1K24TGWGuS+zl9HqKLo7M2rBhYd3SZTM
         2CQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713200633; x=1713805433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zfqt/NgDwjKFxB5AgyRPdEKVaYoxBURY78UkNYsrqoM=;
        b=TqqyAvlrNRR7W94eDs3Lsqixzj0cLjffdUrNTuPsJUIYlKqhDGocINRqe/fjb7KupM
         ASRjrPDRPoDqq8+WG8IOGW5lx9Yayr593fQDLbnMgaTCWdW+KErxgkWA7vRqb6SlP5NG
         qKvMcQAR5SUH0yzgqfosYz4vAS8M2YMfBQMqoW//U7ZZqTC39QnA2QEZgqYLxsm6nZug
         k7AIgtPgvvNyThrgnAMpCrah4guXFPzA4y8BC/GU89Zqu7BR861rh4n9DHIIATm9rPiX
         XGugda+IA+vap4oVAb4F7TYPmwY7AYsiLE0/qCdKeBssqPFZwnNsaUQ/I9SsBHgD5ikz
         IiAw==
X-Forwarded-Encrypted: i=1; AJvYcCWBzy46b73NlIswwOmuKRAr+JtCTwjOWuWxb7xz3lxa00cdgdsDRvGnz5bxSptvakwx1qoDCEX6v/d/m8IxI72T9iaiQTQ9
X-Gm-Message-State: AOJu0YwXVGnA055nE6DsWAwbi5i6uvQMr/9uY1OKLKvtn8hWVezdq17U
	vgypJ1dOiXy++EKlpeGSDOIlTFPOoGjndn4P8twHk3vJjJu6YUaZ8Mchul9E3TA3LX03Rbb4W3E
	TdA==
X-Google-Smtp-Source: AGHT+IGA4ztkhkZCfS7682EU3T6gUsIsEcYhQEyC6yG3styg4+lnibMOlTTY3gI+fKNitZWoNIXkz2MBC8E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9399:b0:6ec:f266:d214 with SMTP id
 ka25-20020a056a00939900b006ecf266d214mr254346pfb.4.1713200632756; Mon, 15 Apr
 2024 10:03:52 -0700 (PDT)
Date: Mon, 15 Apr 2024 10:03:51 -0700
In-Reply-To: <86h6g5si0m.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240405115815.3226315-1-pbonzini@redhat.com> <20240405115815.3226315-2-pbonzini@redhat.com>
 <20240412104408.GA27645@willie-the-truck> <86jzl2sovz.wl-maz@kernel.org>
 <ZhlLHtfeSHk9gRRO@google.com> <86h6g5si0m.wl-maz@kernel.org>
Message-ID: <Zh1d94Pl6gneVoDd@google.com>
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Nicholas Piggin <npiggin@gmail.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Apr 13, 2024, Marc Zyngier wrote:
> On Fri, 12 Apr 2024 15:54:22 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Fri, Apr 12, 2024, Marc Zyngier wrote:
> > > On Fri, 12 Apr 2024 11:44:09 +0100, Will Deacon <will@kernel.org> wrote:
> > > > On Fri, Apr 05, 2024 at 07:58:12AM -0400, Paolo Bonzini wrote:
> > > > Also, if you're in the business of hacking the MMU notifier code, it
> > > > would be really great to change the .clear_flush_young() callback so
> > > > that the architecture could handle the TLB invalidation. At the moment,
> > > > the core KVM code invalidates the whole VMID courtesy of 'flush_on_ret'
> > > > being set by kvm_handle_hva_range(), whereas we could do a much
> > > > lighter-weight and targetted TLBI in the architecture page-table code
> > > > when we actually update the ptes for small ranges.
> > > 
> > > Indeed, and I was looking at this earlier this week as it has a pretty
> > > devastating effect with NV (it blows the shadow S2 for that VMID, with
> > > costly consequences).
> > > 
> > > In general, it feels like the TLB invalidation should stay with the
> > > code that deals with the page tables, as it has a pretty good idea of
> > > what needs to be invalidated and how -- specially on architectures
> > > that have a HW-broadcast facility like arm64.
> > 
> > Would this be roughly on par with an in-line flush on arm64?  The simpler, more
> > straightforward solution would be to let architectures override flush_on_ret,
> > but I would prefer something like the below as x86 can also utilize a range-based
> > flush when running as a nested hypervisor.

...

> I think this works for us on HW that has range invalidation, which
> would already be a positive move.
> 
> For the lesser HW that isn't range capable, it also gives the
> opportunity to perform the iteration ourselves or go for the nuclear
> option if the range is larger than some arbitrary constant (though
> this is additional work).
> 
> But this still considers the whole range as being affected by
> range->handler(). It'd be interesting to try and see whether more
> precise tracking is (or isn't) generally beneficial.

I assume the idea would be to let arch code do single-page invalidations of
stage-2 entries for each gfn?

Unless I'm having a brain fart, x86 can't make use of that functionality.  Intel
doesn't provide any way to do targeted invalidation of stage-2 mappings.  AMD
provides an instruction to do broadcast invalidations, but it takes a virtual
address, i.e. a stage-1 address.  I can't tell if it's a host virtual address or
a guest virtual address, but it's a moot point because KVM doen't have the guest
virtual address, and if it's a host virtual address, there would need to be valid
mappings in the host page tables for it to work, which KVM can't guarantee.
