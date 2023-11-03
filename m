Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A006023745
	for <kvmarm@lists.linux.dev>; Fri,  3 Nov 2023 20:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CrhGfzzh"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5a7be940fe1so33085997b3.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Nov 2023 13:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699041908; x=1699646708; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jqcMVObXfls0ky1XyE/2RgALPyYZ3suExFhfxoDOdHI=;
        b=CrhGfzzh6QEMsRMFgq2ee6zKiojG3zHstQ6sWsoX8pM10o4MdEHgwf5hyxIHvf8Gnp
         o3jGFTz8H2br/SoHTkneIyA/gw9HKqc0kVTR3S+yMnp/YIt9AKh62Vu0rHWkZlEMSA51
         zweQ/4h9gflYFPmM7HPKbv37xSKYLnrVWsYjHHprRpdxh38w4TzTteBPhW4co/VhQzHk
         VzKzKIXKZ8U6ONCG1rpe8ohckao5Cr/VvKqsr5wyumwiiNPZ8HxWM/xU3gUP+qaZHSWQ
         sDBWwxY2VUd5xgfAMh03B34Q1/70D2EheMQ4bu0AkZDIS0H2YvAAZzvlx7UaJhnS1EBA
         h9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699041908; x=1699646708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqcMVObXfls0ky1XyE/2RgALPyYZ3suExFhfxoDOdHI=;
        b=mSsWPgsVe1SpWy12XTw9E5xIqhmDzV4M00DfaAs+Z1mGcGD4IhhG93nmFaFV+KDGdd
         6zVPh3v+cUfASHsB/y258fpZ2AkyaolLaXrXU5j3Q5htIFGtSLnByGbH91xPylnR2yMn
         Aa+FlcgT54iYyfJcM0R48jGTDOli74Ek/j7pYxWoLHNahc37eGNZorhF/sMjQx4r2StY
         Qp6m3g86xWZAQKq3M9i9keDEiybOTPE35q7B83ALIp1RKvhRmDrqppU2ZqQIrsfbRSX4
         S1gH3c/PbaQsS+yX/EehyCQeS0iJ9akgM7QMjTz5086Sp3wIrQ1cWguhnbf0LFBitoQc
         l+Dw==
X-Gm-Message-State: AOJu0YxhB7JuoSF8/dwtW/nD98S2IRj4n8QhnbTdHCKgTWC7/KQ40GQa
	0/HinpxDTZiP4Rrgv8Lo/13j9QXu0Ac=
X-Google-Smtp-Source: AGHT+IGH4Rtieqwe95qBNeWUXhNQ+Ebl8RlTr4T8qnuOOz8KnxiiMEnAz51IwzHps12wkHgG32ggh8NaFYw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d9d5:0:b0:59b:f493:813d with SMTP id
 b204-20020a0dd9d5000000b0059bf493813dmr73742ywe.1.1699041908564; Fri, 03 Nov
 2023 13:05:08 -0700 (PDT)
Date: Fri, 3 Nov 2023 13:05:07 -0700
In-Reply-To: <CAF7b7mpzkjvBTybbaEUSp7iL3dVURVi+rDtkkojOcXAY=Bk9=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
 <CAF7b7mpzkjvBTybbaEUSp7iL3dVURVi+rDtkkojOcXAY=Bk9=g@mail.gmail.com>
Message-ID: <ZUVSc-Cu3LaeAcWd@google.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: David Matlack <dmatlack@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Anish Moorthy wrote:
> I'm going to squash this into patch 9: the fact that it's separated is
> a holdover from when the memslot flag check lived in arch-specific
> code.
> 
> Proposed commit message for the squashed commit
> 
> > KVM: Add KVM_CAP_EXIT_ON_MISSING which forbids page faults in stage-2 fault handlers

Please don't use "forbids page faults".  As I said earlier:

 : "Forbid fault" is rather nonsensical because a fault has already happened.  The
 : confusion between "page fault VM-Exit" and "faulting in memory in the host" is
 : the main reason we wandered away from anything with "fault" in the name.

The part that is being "forbidden" is not a "page fault", it's the act of faulting
in a page.  And "forbids" doesn't add any clarity to KVM_CAP_EXIT_ON_MISSING; if
anything, it muddies the waters by making it sound like page faults somehow become
fatal.

Regarding the capability, stating the capability name is both unnecessary and
uninteresting.  The fact that there's a new capability is an implementation detail,
it's in no way needed to understand the basic gist of the patch, which is basically
*the* role of the shortlog.

The key things to cover in the shortlog:

 * What does the feature do?   Exits when an hva isn't fully mapped
 * Who controls the behavior?  Userspace
 * How is the feature enabled? Memslot flag

I would go with something like:

  KVM: Add memslot flag to let userspace force an exit on missing hva mappings

> > Faulting in pages via the stage-2 fault handlers can be undesirable in
> > the context of userfaultfd-based postcopy: contention for userfaultfd's
> > internal wait queues can cause significant slowness when delivering
> > faults to userspace. A performant alternative is to allow the stage-2
> > fault handlers to, where they would currently page-fault on the
> > userspace mappings, exit from KVM_RUN and deliver relevant information
> > to userspace via KVM_CAP_MEMORY_FAULT_INFO. This approach avoids
> > contention-related issues.
> 
> > Add, and mostly implement, a capability through which userspace can
> > indicate to KVM (through the new KVM_MEM_EXIT_ON_MISSING memslot flag)
> > that it should not fault in pages from the stage-2 fault handlers.
> 
> > The basic implementation strategy is to check the memslot flag from
> > within __gfn_to_pfn_memslot() and override the "atomic" parameter
> > accordingly. Some callers (such as kvm_vcpu_map()) must be able to opt
> > out of this behavior, and do so by passing the new can_exit_on_missing
> > parameter as false.
> 
> > No functional change intended: nothing sets KVM_MEM_EXIT_ON_MISSING.
> 
> One comment/question though- as I have the (sqaushed) patches/new
> commit message written, I think it could mislead readers into thinking
> that callers that pass can_exit_on_missing=false to
> __gfn_to_pfn_memslot() *must* do so. But at least some of these cases,
> such as the ones in the powerpc mmu, I think we're just punting on.
> 
> I see a few options here
> 
> 1. Make all callers pass can_exit_on_missing=false, and leave the
> =true update to the x86/arm64 specific "enable/annotate
> KVM_EXIT_ON_MISSING" commits [my preference]

This one.  Nothing should pass %true until the caller fully supports
KVM_MEM_EXIT_ON_MISSING.

> 2. Make the powerpc callers pass can_exit_on_missing=true as well,
> even though we're not adding KVM_CAP_EXIT_ON_MISSING for them
> 
> 3. Add a disclaimer in the commit message that some cases where
> can_exit_on_missing=false could become =true in the future
> 
> 4. Things are fine as-is and I'm making a mountain out of a molehill
> 
> Any thoughts?
