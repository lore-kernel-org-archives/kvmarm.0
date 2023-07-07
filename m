Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0458523C7
	for <kvmarm@lists.linux.dev>; Fri,  7 Jul 2023 20:07:50 +0000 (UTC)
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-47e655e9a9aso918217e0c.2
        for <kvmarm@lists.linux.dev>; Fri, 07 Jul 2023 13:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688760469; x=1691352469;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N9qU/Uq2LcL3uTNrj7xBoEZcMO3Zt2Ax77k0O53wuuw=;
        b=DFJe3y+AnMA3aG++VmiJOc9libNpH39V8Q7JlXqLpPhd7smK3iuJs4YLVGa44gtUFz
         BNn2oQSlkAQQdufYUKJQLABklLX9nm5xT2Nm7TaPSSf8LB3t3Jzwfv8XqVb8CyKYW6Lb
         sgli/ABMJurdaUSnPTUcJCv5vUm2tfPObPwIVq6ZBFSdXnTei/04LFIKYjJBN/Qz5pLl
         2X4Qy4aNwBe5rl+nI7D3PWXc9Rk2D8idPH5tFgULjE3nsFzU8i9k94D6a7gS6lvOUWqo
         1NFkOIojfE4KbkwqbqlEyjNeyPzMKbnyb6H3A+0BcNIU6MBLYl5BGDTscZ9pBIp41+Ip
         XaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688760469; x=1691352469;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N9qU/Uq2LcL3uTNrj7xBoEZcMO3Zt2Ax77k0O53wuuw=;
        b=To+k7LrWGsa02wzpHPjTa+PUMxZ6mnbK9XBXYeVIaX01ZsP5y4dN/Ib4v3GHfgUorO
         p2PPuAVI4zetLFxN2styKO5ELS6/MPMBj02BDExJoMbpeB2/VB+t+brXBi6O7TpuSN0x
         aE/xeY2K2s0B2Hi/rjkeASh8VCFbdwjbg564iyC+XiMXTHPyrsQimMZ86tQAHRA2IrgW
         vDfKRs0XhKDPc85B3FqFFEwOM+XF9J3tm++5QavpwJTzw0Le6ikI5ulEp1bojopI7Ge2
         ubt+WaiANOE7yqzC1caPN11000Ka6sT2bQ1BuKuWuSHYrv8H+Qxg95gFT6RFOCwIHZKs
         5Q4A==
X-Gm-Message-State: ABy/qLYPQl9FbWk9wrazpIhB8cRlquqgLGsOP15hrCSok7ucxSl/BArV
	cb7WdD90lTYWXF91Carl8+WWmnUrHhDlS8GjtzfN8w==
X-Google-Smtp-Source: APBJJlFbA0+MGli2FsF318+uGY/31P13FYZhO0TBRccUTaBDtFPRrBVZo40WEwkxXIkbpoi5LgXyRrYmK2gGB/VxSZU=
X-Received: by 2002:a1f:d605:0:b0:471:7996:228f with SMTP id
 n5-20020a1fd605000000b004717996228fmr4417802vkg.7.1688760469605; Fri, 07 Jul
 2023 13:07:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <CAF7b7mqKJTCENsb+5MZT+D=DwcSva-jMANjtYszMTm-ACvkiKA@mail.gmail.com>
In-Reply-To: <CAF7b7mqKJTCENsb+5MZT+D=DwcSva-jMANjtYszMTm-ACvkiKA@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 7 Jul 2023 13:07:13 -0700
Message-ID: <CAF7b7mrabLtnq+0Gtsg9FA+Gfr12FqbmfxwJZuQcBNDz1+3yLw@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

> > However, do we actually need to force vendor code to query nowait?  At a glance,
> > the only external (relative to kvm_main.c) users of __gfn_to_pfn_memslot() are
> > in flows that play nice with nowait or that don't support it at all.  So I *think*
> > we can do this?
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index be06b09e9104..78024318286d 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2403,6 +2403,11 @@ static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
> >         return slot->flags & KVM_MEM_READONLY;
> >  }
> >
> > +static bool memslot_is_nowait_on_fault(const struct kvm_memory_slot *slot)
> > +{
> > +       return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
> > +}
> > +
> >  static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
> >                                        gfn_t *nr_pages, bool write)
> >  {
> > @@ -2730,6 +2735,11 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> >                 writable = NULL;
> >         }
> >
> > +       if (async && memslot_is_nowait_on_fault(slot)) {
> > +               *async = false;
> > +               async = NULL;
> > +       }
> > +
> >         return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
> >                           writable);
> >  }
>
> Hmm, well not having to modify the vendor code would be nice... but
> I'll have to look more at __gfn_to_pfn_memslot()'s callers (and
> probably send more questions your way :). Hopefully it works out more
> like what you suggest.

I took a look of my own, and I don't think moving the nowait query
into __gfn_to_pfn_memslot() would work. At issue is the actual
behavior of KVM_CAP_NOWAIT_ON_FAULT, which I documented as follows:

> The presence of this capability indicates that userspace may pass the
> KVM_MEM_NOWAIT_ON_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
> to fail (-EFAULT) in response to page faults for which resolution would require
> the faulting thread to sleep.

 Moving the nowait check out of __kvm_faultin_pfn()/user_mem_abort()
and into __gfn_to_pfn_memslot() means that, obviously, other callers
will start to see behavior changes. Some of that is probably actually
necessary for that documentation to be accurate (since any usages of
__gfn_to_pfn_memslot() under KVM_RUN should respect the memslot flag),
but I think there are consumers of __gfn_to_pfn_memslot() from outside
KVM_RUN.

Anyways, after some searching on my end: I think the only caller of
__gfn_to_pfn_memslot() in core kvm/x86/arm64 where moving the "nowait"
check into the function actually changes anything is gfn_to_pfn(). But
that function gets called from vmx_vcpu_create() (through
kvm_alloc_apic_access_page()), and *that* certainly doesn't look like
something KVM_RUN does or would ever call.
