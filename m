Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E672F2A
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 18:09:01 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id d20so9342176vsf.11
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 10:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFS2s1TR/3Kjk49puEHZLo8Qp1XbI3IEgMXOzJt184k=;
        b=T5IJAdz1LLwq9Wpe/lYsePig5wU3ht7E3XBfh+hgfH9QST0GfyYIgBlwgpI5O4mani
         rZIblgtTc6rbIYvr29cW1lsZGQDsNNjbLJmM9HYUEKikey9Qql1PRkJPgYlaRmFu5e2N
         LGj2FMYFaOEkWL8mGYvTQ3Vn7z0ODfq96Tsg1YXvbb5WVEEyoz5Sfs0JGBUwPeZzM21h
         27AMPaY+3E8diGs3Qq+0UvjwD32cBcn5tHRKFEFz4XJWCYmEnw744gDyE01cZp3Q9MRJ
         C7l0NSF4td3tovqrUj6grQE1k5M5JoTxHepZybKKiQDz154BjPBgwzQNflKkDkbRn1Fi
         zNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZFS2s1TR/3Kjk49puEHZLo8Qp1XbI3IEgMXOzJt184k=;
        b=VhRliib1spJnXneKR+yNq7ArALCkKDKhOGbuaRZGMv3Uzhs94C4ileTh6tULtcnEGN
         sPpEIHsLt6onop1ERTmW0azPWjLI9ydWC1pXUUSU53Bx/6I31W++RUwGTLty/7+J6A7A
         d7RQW4G3m2ht0oLbKM852gXAud6bx1z1Wn5ARQAt4dX/GJN3oA0SOtfHY6uISQbNLhM0
         ZJW6f1Vs1+YiOO4cKviYjtEQxYw43UkyJvaETcpsj4Iux6a/treLrs+GOvD4XvntBYu2
         BrZEjGo7TV/0JF2fzpV1ewy2wUc0BGK7mQxYRpvylW2eaBavV0UaO69WLkuL5q39u6Bk
         rJfg==
X-Gm-Message-State: AO0yUKWNOViYvMFka1UxeMBjJiOygg1BAJA6MpT21ol0fXqIt7J97Hiu
	hKQGbuU0MNoWUhNX1m8oSKbWvts4C6mqR+fyhqUPKg==
X-Google-Smtp-Source: AK7set/BLzsOKlrQCPCfz1/Srjggdbaz1bD3yeHmhdVN17JBRgqFpgtS/JiELfEpEe2qyTgQFGrUqdU1JBFociC1vOk=
X-Received: by 2002:a05:6102:22c2:b0:414:d29b:497c with SMTP id
 a2-20020a05610222c200b00414d29b497cmr479716vsh.6.1677175740528; Thu, 23 Feb
 2023 10:09:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-6-yuzhao@google.com>
 <Y/elw7CTvVWt0Js6@google.com>
In-Reply-To: <Y/elw7CTvVWt0Js6@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Thu, 23 Feb 2023 11:08:21 -0700
Message-ID: <CAOUHufbAKpv95k6rVedstjD_7JzP0RrbOD652gyZh2vbAjGPOg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm: multi-gen LRU: use mmu_notifier_test_clear_young()
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 10:43=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Feb 16, 2023, Yu Zhao wrote:
> > An existing selftest can quickly demonstrate the effectiveness of this
> > patch. On a generic workstation equipped with 128 CPUs and 256GB DRAM:
>
> Not my area of maintenance, but a non-existent changelog (for all intents=
 and
> purposes) for a change of this size and complexity is not acceptable.

Will fix.

> >   $ sudo max_guest_memory_test -c 64 -m 250 -s 250
> >
> >   MGLRU      run2
> >   ---------------
> >   Before    ~600s
> >   After      ~50s
> >   Off       ~250s
> >
> >   kswapd (MGLRU before)
> >     100.00%  balance_pgdat
> >       100.00%  shrink_node
> >         100.00%  shrink_one
> >           99.97%  try_to_shrink_lruvec
> >             99.06%  evict_folios
> >               97.41%  shrink_folio_list
> >                 31.33%  folio_referenced
> >                   31.06%  rmap_walk_file
> >                     30.89%  folio_referenced_one
> >                       20.83%  __mmu_notifier_clear_flush_young
> >                         20.54%  kvm_mmu_notifier_clear_flush_young
> >   =3D>                      19.34%  _raw_write_lock
> >
> >   kswapd (MGLRU after)
> >     100.00%  balance_pgdat
> >       100.00%  shrink_node
> >         100.00%  shrink_one
> >           99.97%  try_to_shrink_lruvec
> >             99.51%  evict_folios
> >               71.70%  shrink_folio_list
> >                 7.08%  folio_referenced
> >                   6.78%  rmap_walk_file
> >                     6.72%  folio_referenced_one
> >                       5.60%  lru_gen_look_around
> >   =3D>                    1.53%  __mmu_notifier_test_clear_young
>
> Do you happen to know how much of the improvement is due to batching, and=
 how
> much is due to using a walkless walk?

No. I have three benchmarks running at the moment:
1. Windows SQL server guest on x86 host,
2. Apache Spark guest on arm64 host, and
3. Memcached guest on ppc64 host.

If you are really interested in that, I can reprioritize -- I need to
stop 1) and use that machine to get the number for you.

> > @@ -5699,6 +5797,9 @@ static ssize_t show_enabled(struct kobject *kobj,=
 struct kobj_attribute *attr, c
> >       if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YO=
UNG))
> >               caps |=3D BIT(LRU_GEN_NONLEAF_YOUNG);
> >
> > +     if (kvm_arch_has_test_clear_young() && get_cap(LRU_GEN_SPTE_WALK)=
)
> > +             caps |=3D BIT(LRU_GEN_SPTE_WALK);
>
> As alluded to in patch 1, unless batching the walks even if KVM does _not=
_ support
> a lockless walk is somehow _worse_ than using the existing mmu_notifier_c=
lear_flush_young(),
> I think batching the calls should be conditional only on LRU_GEN_SPTE_WAL=
K.  Or
> if we want to avoid batching when there are no mmu_notifier listeners, pr=
obe
> mmu_notifiers.  But don't call into KVM directly.

I'm not sure I fully understand. Let's present the problem on the MM
side: assuming KVM supports lockless walks, batching can still be
worse (very unlikely), because GFNs can exhibit no memory locality at
all. So this option allows userspace to disable batching.

I fully understand why you don't want MM to call into KVM directly. No
acceptable ways to set up a clear interface between MM and KVM other
than the MMU notifier?
