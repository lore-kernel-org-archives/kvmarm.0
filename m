Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80726D3F
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 21:23:29 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-57000a7480bso16229157b3.0
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 14:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686777808; x=1689369808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EguF6lsG5lYio4UZZ1vADQabPc9eHzO82CmbKeM2Gps=;
        b=1OB4P93nQ9hnwu1SKXSh9Rv08V9u9apR87yzMCxcD97fBtyXQJmA332SMyINsuwF5k
         WDP3zbqRSh1YCG51O8vkwWH9UOylzOgoCLECbGuGxdNvsJ9P+t6xN5lXJVF2MDyWQ87d
         g0kY3pdBzSUOSNlJopYI0Ol7QwH1IW9f/F1Rp9zDz5QHxviCsfLnNikWMf6G8MxzKnVN
         Hkrgiju4CIHHe98opG11KR1x2fJVrXdKGQE9rYvKpUdRZpc6IXYrwgWM5oT55OGSLJ6k
         /GCv5DjRwFS8JcP6fnZdTAWkndoEDNIel4yJiNwk7IwCqMj8H448JxLQqHA/Bc8wTCGB
         WbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686777808; x=1689369808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EguF6lsG5lYio4UZZ1vADQabPc9eHzO82CmbKeM2Gps=;
        b=eN2fSHRoXqA3MEJn30TAx9XrP1MdqoWEFbgPx/X0VNnk3zA/u/q4CgYsbOhMMR8Lqn
         /+uc1q4pSwAFMcgDHnZ/yRkgH9Vrj+kRpSLxAojXWNvMoaTsEG1nHJYfb6e5pAQwktfN
         g6qmEMOTyW4BfAHoEO0unE2LmyzQhI2EL28gt+ypZ33ypGhtAzDQsTQ96kO1h19MtVyb
         w3K65G55QAN5mO/Lmucu6Rco5HvGwyVqF0Ezzg2b/qVOuBX0hjlNo4S98ceqJGFnAnZ+
         mFbB2zvf0iBkfe3Ju6awAER8AQol/i3Zg54saCt5Rfw5a2x2IiH9szE5wIBguzxDJkDI
         gk8A==
X-Gm-Message-State: AC+VfDwyqh6jRqrrdJQjdramFQwAV7Tne9zcRiFkewlwulmmJu2VBQKM
	ijJBn8/6S525nRgMQmDaqLXS9iXredI=
X-Google-Smtp-Source: ACHHUZ4bOpC/uhJHVrKJmWqgRppZDc2NExGMN/kWxkPS3c90+dp9htpQTQSdFXtKL8nnsymOBcUnz5oiwGM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:320d:0:b0:bcc:285c:66de with SMTP id
 y13-20020a25320d000000b00bcc285c66demr1522968yby.5.1686777808777; Wed, 14 Jun
 2023 14:23:28 -0700 (PDT)
Date: Wed, 14 Jun 2023 14:23:27 -0700
In-Reply-To: <ZIovIBVLIM69E5Bo@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com>
Message-ID: <ZIovz22R5dm05u6/@google.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 14, 2023, Sean Christopherson wrote:
> On Fri, Jun 02, 2023, Anish Moorthy wrote:
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 69a221f71914..abbc5dd72292 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2297,4 +2297,10 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
> >   */
> >  inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> >  				     uint64_t gpa, uint64_t len, uint64_t flags);
> > +
> > +static inline bool kvm_slot_nowait_on_fault(
> > +	const struct kvm_memory_slot *slot)
> 
> Just when I was starting to think that we had beat all of the Google3 out of you :-)
> 
> And predicate helpers in KVM typically have "is" or "has" in the name, so that it's
> clear the helper queries, versus e.g. sets the flag or something. 
> 
> > +{
> > +	return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
> 
> KVM is anything but consistent, but if the helper is likely to be called without
> a known good memslot, it probably makes sense to have the helper check for NULL,
> e.g.
> 
> static inline bool kvm_is_slot_nowait_on_fault(const struct kvm_memory_slot *slot)
> {
> 	return slot && slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
> }
> 
> However, do we actually need to force vendor code to query nowait?  At a glance,
> the only external (relative to kvm_main.c) users of __gfn_to_pfn_memslot() are
> in flows that play nice with nowait or that don't support it at all.  So I *think*
> we can do this?
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index be06b09e9104..78024318286d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2403,6 +2403,11 @@ static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
>         return slot->flags & KVM_MEM_READONLY;
>  }
>  
> +static bool memslot_is_nowait_on_fault(const struct kvm_memory_slot *slot)
> +{
> +       return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
> +}
> +
>  static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
>                                        gfn_t *nr_pages, bool write)
>  {
> @@ -2730,6 +2735,11 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>                 writable = NULL;
>         }
>  
> +       if (async && memslot_is_nowait_on_fault(slot)) {
> +               *async = false;
> +               async = NULL;
> +       }

Gah, got turned around and forgot to account for @atomic.  So this?

	if (!atomic && memslot_is_nowait_on_fault(slot)) {
		atomic = true;
		if (async) {
			*async = false;
			async = NULL;
		}
	}
	
> +
>         return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
>                           writable);
>  }
> 
> Ah, crud.  The above highlights something I missed in v3.  The memslot NOWAIT
> flag isn't tied to FOLL_NOWAIT, it's really truly a "fast-only" flag.  And even
> more confusingly, KVM does set FOLL_NOWAIT, but for the async #PF case, which will
> get even more confusing if/when KVM uses FOLL_NOWAIT internally.
> 
> Drat.  I really like the NOWAIT name, but unfortunately it doesn't do what as the
> name says.
> 
> I still don't love "fast-only" as that bleeds kernel internals to userspace.
> Anyone have ideas?  Maybe something about not installing new mappings?
