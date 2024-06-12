Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAEB2A1CA
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718213491; cv=none; b=HVb7A+N1Si17Kkr9cuH8ohst5xs3XZ31gi4Ftd/4bgnbQIYNXlPpJ5lhROePhXIFzN6XDFkFZOJqUXR4kDt4ONwwEwn4rJmBCZsolAxSOGcjBzn900q3Rb6l8ov54PfJ2sx3Z20l+CDdz4hb05dY5ZDfEBuwuK9CJS4Ji7YdAqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718213491; c=relaxed/simple;
	bh=BVxVglBu/aJdIm8zaMwOg3iRpiLrT6XOkxr2cN79Qtg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NZMBMnpaRVvdGYHNaHi+U7xLYomuopdBtdvaqag1VluSApYg5q2VTelh+YkwrMlcyCKZos66S9/kT35yTh0Zz0JI1UgQ5MKfxRnhX9nG0LoapJ+7xjV8AurH8AST4W/G6GtTQFcHsweige/pFsSHQbl3w9qIBdYLlH++vpUIy4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=15dS+5o4; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="15dS+5o4"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f728a74f25so1041335ad.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 10:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718213490; x=1718818290; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZttrWbEybPZrU6j9LIdJZge1/Pd2kmv/UPX9FdzbJ4o=;
        b=15dS+5o4I4KnZX32onwjgQtJR7CQgjEhs6IkPr6J8j851hr2sxLUn+xeAzLTDnvk1U
         RkhCj09bdkljlF/ELjp+cbo2eX5giHh/2mOpXzaofbua3JhVZIh6zZHeqECpa27aglV/
         hhjPG4ud0HQWUHYZ4GYiuRGHmTcSewvdSGvRizNyQEUQOyGjJkUMPuuKZxBArM1rho5s
         ojSpbVittFqoWG3L5iepSFhDErKlUXpONcvvPIEzc1qd6pzI6DNsoKWj8MmnJbt1btVW
         aicsNKMJpLlMNt/fVailY0txPnBoP/PjvQi01q45Wq/umdxkKOjOwc+xxpFHsG/m++i6
         mZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718213490; x=1718818290;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZttrWbEybPZrU6j9LIdJZge1/Pd2kmv/UPX9FdzbJ4o=;
        b=JYGRjQ6IWJZnshGloqLFEDq/iftkUS4Ga7IZDgE+prBw2xuE2DwooTK0lazGebDjHR
         7+A30opzQHytDxeQ+VHRfhovtvxyFsZKmpezg8KE02/Z7TfBdI/ctqx1Vvno1tMRa3V7
         K4E6RWagc3cLn8NLSJZQRZuVfo7MUwN/rmwvCsKrfPlBYDvBE7LzEBHCQaxtpYLHOLgZ
         ekbKJv4ZX0MT/EOlnyRibZp5D5k7YH5/oAllTp2ZwtcpxnJ/1+uT9q7/0ZRoOtbnC3un
         7qGFikL+0YH4j0rIU4uSgRyFfuEjzUTRav8tv94Vke5gtzKUhh7jle9Xk5wufVPzAqu6
         VUbw==
X-Forwarded-Encrypted: i=1; AJvYcCUf6+Y1p216dfqtaTvFwmV4kchDz678vZwgvwuY2miOdm50MhfIQfKT4yE1xxCCCRG5jGyDvAvg+e4uu4f+L/2UPruD5Z7Z
X-Gm-Message-State: AOJu0YyoA34aYkWjP1qi+urgTRqpE12aScgFYFCGtGHQsNB/T8xWJUw9
	+blBktG9BJfgWzvnjo3avqllcInfC5+/lP/x8gVCXB0xFDjQ3VVt+UrsVpFK3kCJfDzIo9Rq+PS
	LhA==
X-Google-Smtp-Source: AGHT+IEfEUqjAJd5HwtcI3SellD9wJyKICC45AOG2hDSPfUBXvAeRlQriWUGwdY0fjJOl8E1dOYOBVVBc8s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:182:b0:1f3:4b2a:1acb with SMTP id
 d9443c01a7336-1f83b23ddb1mr79315ad.0.1718213489334; Wed, 12 Jun 2024 10:31:29
 -0700 (PDT)
Date: Wed, 12 Jun 2024 10:31:27 -0700
In-Reply-To: <Zmm9SdVfg18RECT5@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240405115815.3226315-2-pbonzini@redhat.com> <20240412104408.GA27645@willie-the-truck>
 <86jzl2sovz.wl-maz@kernel.org> <ZhlLHtfeSHk9gRRO@google.com>
 <86h6g5si0m.wl-maz@kernel.org> <Zh1d94Pl6gneVoDd@google.com>
 <20240418141932.GA1855@willie-the-truck> <ZiF6NgGYLSsPNEOg@google.com>
 <20240419112432.GB2972@willie-the-truck> <Zmm9SdVfg18RECT5@google.com>
Message-ID: <Zmnbb-Xlyz4VXNHI@google.com>
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
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

On Wed, Jun 12, 2024, Sean Christopherson wrote:
> On Fri, Apr 19, 2024, Will Deacon wrote:
> > On Thu, Apr 18, 2024 at 12:53:26PM -0700, Sean Christopherson wrote:
> > > On Thu, Apr 18, 2024, Will Deacon wrote:
> > > > > I assume the idea would be to let arch code do single-page invalidations of
> > > > > stage-2 entries for each gfn?
> > > > 
> > > > Right, as it's the only code which knows which ptes actually ended up
> > > > being aged.
> > > > 
> > > > > Unless I'm having a brain fart, x86 can't make use of that functionality.  Intel
> > > > > doesn't provide any way to do targeted invalidation of stage-2 mappings.  AMD
> > > > > provides an instruction to do broadcast invalidations, but it takes a virtual
> > > > > address, i.e. a stage-1 address.  I can't tell if it's a host virtual address or
> > > > > a guest virtual address, but it's a moot point because KVM doen't have the guest
> > > > > virtual address, and if it's a host virtual address, there would need to be valid
> > > > > mappings in the host page tables for it to work, which KVM can't guarantee.
> > > > 
> > > > Ah, so it sounds like it would need to be an arch opt-in then.
> > > 
> > > Even if x86 (or some other arch code) could use the precise tracking, I think it
> > > would make sense to have the behavior be arch specific.  Adding infrastructure
> > > to get information from arch code, only to turn around and give it back to arch
> > > code would be odd.
> > 
> > Sorry, yes, that's what I had in mind. Basically, a way for the arch code
> > to say "I've handled the TLBI, don't worry about it."
> > 
> > > Unless arm64 can't do the invalidation immediately after aging the stage-2 PTE,
> > > the best/easiest solution would be to let arm64 opt out of the common TLB flush
> > > when a SPTE is made young.
> > > 
> > > With the range-based flushing bundled in, this?
> > > 
> > > ---
> > >  include/linux/kvm_host.h |  2 ++
> > >  virt/kvm/kvm_main.c      | 40 +++++++++++++++++++++++++---------------
> > >  2 files changed, 27 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index afbc99264ffa..8fe5f5e16919 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -2010,6 +2010,8 @@ extern const struct kvm_stats_header kvm_vcpu_stats_header;
> > >  extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
> > >  
> > >  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
> > > +int kvm_arch_flush_tlb_if_young(void);
> > > +
> > >  static inline int mmu_invalidate_retry(struct kvm *kvm, unsigned long mmu_seq)
> > >  {
> > >  	if (unlikely(kvm->mmu_invalidate_in_progress))
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 38b498669ef9..5ebef8ef239c 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -595,6 +595,11 @@ static void kvm_null_fn(void)
> > >  }
> > >  #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
> > >  
> > > +int __weak kvm_arch_flush_tlb_if_young(void)
> > > +{
> > > +	return true;
> > > +}
> > 
> > I tend to find __weak functions a little ugly, but I think the gist of the
> > diff looks good to me. Thanks for putting it together!
> 
> Circling back to this, I don't think we should pursue this specific tweak, at
> least not without hard data for a concrete use case.

Ha, I spoke too soon.  Based on the learning from the KVM+MGLRU thread[*], it
looks like KVM should omit the TLB flush when aging pages whenever possible.  If
that's not doable on all architectures for whatever reason, then something like
this is probably the way to go.

[*] https://lore.kernel.org/all/CAOUHufYCmYNngmS=rOSAQRB0N9ai+mA0aDrB9RopBvPHEK42Ng@mail.gmail.com
