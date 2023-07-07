Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D262D107B5
	for <kvmarm@lists.linux.dev>; Fri,  7 Jul 2023 18:13:38 +0000 (UTC)
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4718ddce780so835015e0c.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Jul 2023 11:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688753617; x=1691345617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wl3EtNl/p1Cktt9fRTEmIICzF7/RfPgCrlONVu2JLF8=;
        b=eI1zn4t8Fh6JGMDJI5Bq+7k9dpO6L9rVaMjrtcmWYqrKPrO1lGvoMbJkHOfcaiJRuu
         8ZcS1BjOpz6qzvA+9pcDi8DgVD2VZEcgbkRP7s4oBej2iD5vPASUI6/bfougCWgKO43P
         rEPDKe/FvfuX94farPxg9s98aZydJ/J/L6rlBXiN6AXcJcnvLREy6w9Y/LEKYv8mqiy2
         d9vVawDgwU9Nt8Ojzzr91B1hTG43ayZTAGEk6ATiupXwyhplsjkV6fc+Bxqn+kZNBHM7
         IwoW71Fs7kXMoLYCT0sEKaMNCLSOXxg6zIhSzg6qiaUmVfJGk7LSUV1Kosj4ds6WvrT9
         K4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688753617; x=1691345617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wl3EtNl/p1Cktt9fRTEmIICzF7/RfPgCrlONVu2JLF8=;
        b=DE4mFhetQwLjPeL16Qhtua3YIDvpyb1tiY60coGeuN76zm8ovaaOBzolaM41lDQeUG
         pH+ouf4+IM+sDxhLfTEhvLdRynDLsB0PZMiS+VsRwvcL2Y6yxvySon/CMk7GwmEDSG0q
         XNC79h0t4uqqyPRCtjKJ6mCzU9kvphS1ErmZgyrr9Q87yMK3bXp3DNfe/G7qYsnFqCOW
         zP5EdVT8Ri7EeiOmzmYrmbjbN/iuNbXTN1xWfTtyCN2fej6ILkTbXu+1Nc3fNo2Q0FrZ
         Q3YiD78HXHsh3R5CEdYG6pw40iKGRzZ7rLa2M+/+VBy6QMOcCo/GXOd/Amzq2CuVQZlM
         j89A==
X-Gm-Message-State: ABy/qLaYXilwOv9COe3B9wyOExs5jhQLPstzoX3FU5jfjJmsbaOGmPWD
	IN0GhlZGySOfNN6FHYkDiO/EItioixMBnf9zzfQZ8BLaQ25r1LRGhUk=
X-Google-Smtp-Source: APBJJlEeTRK3Fec77w837oSHwaixg5smdIYjkVaVUq4TvKapitjrP1VnWLoUGMQU/BcoXrFfefLWUw1J8FwYAXlfSXU=
X-Received: by 2002:a1f:d2c5:0:b0:471:5110:49e8 with SMTP id
 j188-20020a1fd2c5000000b00471511049e8mr4471582vkg.4.1688753617480; Fri, 07
 Jul 2023 11:13:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com>
In-Reply-To: <ZIovIBVLIM69E5Bo@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 7 Jul 2023 11:13:01 -0700
Message-ID: <CAF7b7mqKJTCENsb+5MZT+D=DwcSva-jMANjtYszMTm-ACvkiKA@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 2:20=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> > +static inline bool kvm_slot_nowait_on_fault(
> > +     const struct kvm_memory_slot *slot)
>
> Just when I was starting to think that we had beat all of the Google3 out=
 of you :-)

I was trying to stay under the line limit here :( But you've commented
on that elsewhere. Fixed (hopefully :)

> And predicate helpers in KVM typically have "is" or "has" in the name, so=
 that it's
> clear the helper queries, versus e.g. sets the flag or something.

Done

> KVM is anything but consistent, but if the helper is likely to be called =
without
> a known good memslot, it probably makes sense to have the helper check fo=
r NULL,
> e.g.

Done: I was doing the null checks in other ways in the arch-specific
code, but yeah it's easier to centralize that here.

> However, do we actually need to force vendor code to query nowait?  At a =
glance,
> the only external (relative to kvm_main.c) users of __gfn_to_pfn_memslot(=
) are
> in flows that play nice with nowait or that don't support it at all.  So =
I *think*
> we can do this?
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index be06b09e9104..78024318286d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2403,6 +2403,11 @@ static bool memslot_is_readonly(const struct kvm_m=
emory_slot *slot)
>         return slot->flags & KVM_MEM_READONLY;
>  }
>
> +static bool memslot_is_nowait_on_fault(const struct kvm_memory_slot *slo=
t)
> +{
> +       return slot->flags & KVM_MEM_NOWAIT_ON_FAULT;
> +}
> +
>  static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slo=
t, gfn_t gfn,
>                                        gfn_t *nr_pages, bool write)
>  {
> @@ -2730,6 +2735,11 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_me=
mory_slot *slot, gfn_t gfn,
>                 writable =3D NULL;
>         }
>
> +       if (async && memslot_is_nowait_on_fault(slot)) {
> +               *async =3D false;
> +               async =3D NULL;
> +       }
> +
>         return hva_to_pfn(addr, atomic, interruptible, async, write_fault=
,
>                           writable);
>  }

Hmm, well not having to modify the vendor code would be nice... but
I'll have to look more at __gfn_to_pfn_memslot()'s callers (and
probably send more questions your way :). Hopefully it works out more
like what you suggest.
