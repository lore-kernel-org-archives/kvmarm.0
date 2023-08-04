Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE17253A8
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 22:30:27 +0000 (UTC)
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-56ccda6b0dfso3669820eaf.2
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 15:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691188226; x=1691793026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bFzzUD1s8YBHblwI04VOeCdWAbdee3I5YnQWnVOxvpo=;
        b=TFcn4WhuF59CuOFW+nA/rZmm0UJ9lmliU/kzI0ZppRYE7sDBYkerAuHzzRxdX3d7+X
         4kzLTKYNiq3+tnYZLXIkLwujJLcAX9xlXFF7P6HucTbVVv4htw7jc7Fx1odjOorNhcMK
         dodd2vDxN7Iv863IP8Ul0VCeKTSNeqWflaPt3PPJv7+5ayDRQWhkgJ+D3K75dcAoYxtZ
         WPhu6CqDtddYxxH4dTGFYTkyLBsWJw8IjQxufeXxzFdyCgNiKmvISMu1mHITGEKHgkkb
         HhwXF5timTSNjIo6jS4S4vsYjZPe1ZaATLPhRP8kRuAhbSLipOJg1Qe8hXm34hNZJUIk
         0cUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691188226; x=1691793026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bFzzUD1s8YBHblwI04VOeCdWAbdee3I5YnQWnVOxvpo=;
        b=N/3H6ORMu5yEZCJTtPVwEXDl8VfPg4dQ8Q4d0UskniEUALETRjuDSk0nC2AkqLP3fL
         Xt6CxMNXxlh+Jl5fbZD1aFCgzY5dVRKuBX7Z2UW9/QXGcRbFwjglgWmcq8zTKHgXcxam
         R3JaMzUWKp4ClPPf5M2460p8kPGQNeTjNpXQf1xRDQwD1BujuKWUwXzavLNCAGge+9P+
         KO9FJ0rbW4ce/g6FJOL61u4jwFFh5zpkWuT+5teo3YJR13wVTt2vxBRkFA6TERwCAR6u
         la2py/nY1suVlNoVRZ1iR6rZO63wdRxkj4Z8pdNoA5x8AvAW05Hzv9roqOwQ+HrpWTt8
         1FsQ==
X-Gm-Message-State: AOJu0YwNWvTJArtqzVbTjlJydOuPj2HrDBAkJBeMJSeZOL+9IeYWEwFx
	3mxvvWlojHqRA9euMwqDT6Hq8u9miFw=
X-Google-Smtp-Source: AGHT+IG/f7h4NBFD7Fzz9VqAMwBIHPfIp5Oxxm2+KkdFX36TNY82jUIYr8jbB4mGvNrT4WJJhTCK/9o3DZg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6808:198b:b0:3a7:75cd:df61 with SMTP id
 bj11-20020a056808198b00b003a775cddf61mr4531539oib.5.1691188226241; Fri, 04
 Aug 2023 15:30:26 -0700 (PDT)
Date: Fri, 4 Aug 2023 15:30:24 -0700
In-Reply-To: <20230705080756.xv7fm3jxewipunvn@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-5-stevensd@google.com>
 <20230705080756.xv7fm3jxewipunvn@linux.intel.com>
Message-ID: <ZM18AAFj21Fo36hg@google.com>
Subject: Re: [PATCH v7 4/8] KVM: x86/mmu: Migrate to __kvm_follow_pfn
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: David Stevens <stevensd@chromium.org>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 05, 2023, Yu Zhang wrote:
> On Tue, Jul 04, 2023 at 04:50:49PM +0900, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> > 
> > Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn.

Please turn up your changelog verbosity from ~2 to ~8.  E.g. explain the transition
from async => FOLL_NOWAIT+KVM_PFN_ERR_NEEDS_IO, there's no reason to force readers
to suss that out on their own.

> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 35 +++++++++++++++++++++++++----------
> >  1 file changed, 25 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ec169f5c7dce..e44ab512c3a1 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4296,7 +4296,12 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
> >  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  {
> >  	struct kvm_memory_slot *slot = fault->slot;
> > -	bool async;
> > +	struct kvm_follow_pfn foll = {
> > +		.slot = slot,
> > +		.gfn = fault->gfn,
> > +		.flags = FOLL_GET | (fault->write ? FOLL_WRITE : 0),
> > +		.allow_write_mapping = true,
> > +	};
> >  
> >  	/*
> >  	 * Retry the page fault if the gfn hit a memslot that is being deleted
> > @@ -4325,12 +4330,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  			return RET_PF_EMULATE;
> >  	}
> >  
> > -	async = false;
> > -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> > -					  fault->write, &fault->map_writable,
> > -					  &fault->hva);
> > -	if (!async)
> > -		return RET_PF_CONTINUE; /* *pfn has correct page already */
> > +	foll.flags |= FOLL_NOWAIT;
> > +	fault->pfn = __kvm_follow_pfn(&foll);
> > +
> > +	if (!is_error_noslot_pfn(fault->pfn))
> > +		goto success;
> > +
> > +	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
> > +		return RET_PF_CONTINUE;
> 
> IIUC, FOLL_NOWAIT is set only when we wanna an async fault. So
> KVM_PFN_ERR_NEEDS_IO may not be necessary? 

But FOLL_NOWAIT is set above.  This logic is essentially saying "bail immediately
if __gfn_to_pfn_memslot() returned a fatal error".

A commented would definitely be helpful though.  How about?

	/*
	 * If __kvm_follow_pfn() failed because I/O is needed to fault in the
	 * page, then either set up an asynchronous #PF to do the I/O, or if
	 * doing an async #PF isn't possible, retry __kvm_follow_pfn() with
	  I/O allowed. All other failures are fatal, i.e. retrying won't help.
	 */
	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
		return RET_PF_CONTINUE;
