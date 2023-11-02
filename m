Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A89C199D4
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 13:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PjUVkBS1"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-66d24ccc6f2so17413496d6.0
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 06:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698933379; x=1699538179; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWVbaemD/Qn2/IvLfOB52rG+LgMP2W3NogibJrZTMZ4=;
        b=PjUVkBS1CRSkAP1C/RMHCylOgIOkqnUKDawBATYhtCPPHuajeK+/X3phBj0Jbmnl+2
         +5L9ge2Gdcbk1KmT8l7UTRGH0+iu784iQCk4BKQ0MI9QBBuos0f1qqoCRx/5/xBiMuqh
         3ReXOwxYrtPGhiLYRouhTn2av6wEgglVXF/qsZHIgYEJy0WbkBGNsXi6oFM3uBLquBHk
         yXMM4ya00KeGecl6oUspcXCa5bIIF8OnzXDZ93QiDjeV6iF8lrdpWTRuHJrJaXoPVaaA
         Us9LsXvBztIPmL3+Uu5xPGO3o5p/+6z/sOtfAEQurA6dNRhj6kHReXHSOlXW2xEDF1VT
         RFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698933379; x=1699538179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LWVbaemD/Qn2/IvLfOB52rG+LgMP2W3NogibJrZTMZ4=;
        b=o8P/BZM18mE0C970f7EZ0IrKPtUoGiGMiWNOp2LzR32ZE1YGNf/VKOhSYCt3BhsLpY
         9y9+G/69AF4LxdUM+cKkr9jOrpibmp5nDFVLOfJ1J224hHMwm2VJ3LdlWaIF+Gjv4++i
         C22Fw2gyzNVMoaQb3y8IKrkc1EsLrtykkN4b6eJ4L4IIr3h6exjO/08OhoI2fzJ7QRG9
         jz5w0+vW9ZmrQpbIeJpdqbRAfgiZxdTOqj2S45HG5NxrMhFMDWNWciW2yA9INfVpHuH/
         6bxyvz7UhrSZ8gs/z1ILi5sV5D1Ydlp5tilJsKuMlzXRgNUrDLy1iXKAqOWyub/sxKIX
         taKA==
X-Gm-Message-State: AOJu0YyFoY4VDrgbxEs9S2wdNJtnyUkF5bzkT1UWdaBLA7su5mT+BClF
	lzUo0A41PasSNmmOVH5d+1y2LG9rdZhQz25JL74oHQ==
X-Google-Smtp-Source: AGHT+IFRO7nq4nst6JF9hgQLfpXFHnQOjyBS3ejG9W5aUngaZEoEMY927pDB5PiH0nPNP2AZTqWUqRKAOoKphwpYQM4=
X-Received: by 2002:a05:6214:27ce:b0:66f:b9ef:9636 with SMTP id
 ge14-20020a05621427ce00b0066fb9ef9636mr10883504qvb.32.1698933378923; Thu, 02
 Nov 2023 06:56:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-12-seanjc@google.com>
In-Reply-To: <20231027182217.3615211-12-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 2 Nov 2023 13:55:42 +0000
Message-ID: <CA+EHjTzz2PftRAFU9pQaE1D=E3hwBDCDQpJ69O6r5akdAs0Exw@mail.gmail.com>
Subject: Re: [PATCH v13 11/35] KVM: Drop .on_unlock() mmu_notifier hook
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 7:22=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Drop the .on_unlock() mmu_notifer hook now that it's no longer used for
> notifying arch code that memory has been reclaimed.  Adding .on_unlock()
> and invoking it *after* dropping mmu_lock was a terrible idea, as doing s=
o
> resulted in .on_lock() and .on_unlock() having divergent and asymmetric
> behavior, and set future developers up for failure, i.e. all but asked fo=
r
> bugs where KVM relied on using .on_unlock() to try to run a callback whil=
e
> holding mmu_lock.
>
> Opportunistically add a lockdep assertion in kvm_mmu_invalidate_end() to
> guard against future bugs of this nature.
>
> Reported-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Link: https://lore.kernel.org/all/20230802203119.GB2021422@ls.amr.corp.in=
tel.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  virt/kvm/kvm_main.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2bc04c8ae1f4..cb9376833c18 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -544,7 +544,6 @@ static inline struct kvm *mmu_notifier_to_kvm(struct =
mmu_notifier *mn)
>  typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *ran=
ge);
>
>  typedef void (*on_lock_fn_t)(struct kvm *kvm);
> -typedef void (*on_unlock_fn_t)(struct kvm *kvm);
>
>  struct kvm_mmu_notifier_range {
>         /*
> @@ -556,7 +555,6 @@ struct kvm_mmu_notifier_range {
>         union kvm_mmu_notifier_arg arg;
>         gfn_handler_t handler;
>         on_lock_fn_t on_lock;
> -       on_unlock_fn_t on_unlock;
>         bool flush_on_ret;
>         bool may_block;
>  };
> @@ -663,11 +661,8 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva=
_range(struct kvm *kvm,
>         if (range->flush_on_ret && r.ret)
>                 kvm_flush_remote_tlbs(kvm);
>
> -       if (r.found_memslot) {
> +       if (r.found_memslot)
>                 KVM_MMU_UNLOCK(kvm);
> -               if (!IS_KVM_NULL_FN(range->on_unlock))
> -                       range->on_unlock(kvm);
> -       }
>
>         srcu_read_unlock(&kvm->srcu, idx);
>
> @@ -687,7 +682,6 @@ static __always_inline int kvm_handle_hva_range(struc=
t mmu_notifier *mn,
>                 .arg            =3D arg,
>                 .handler        =3D handler,
>                 .on_lock        =3D (void *)kvm_null_fn,
> -               .on_unlock      =3D (void *)kvm_null_fn,
>                 .flush_on_ret   =3D true,
>                 .may_block      =3D false,
>         };
> @@ -706,7 +700,6 @@ static __always_inline int kvm_handle_hva_range_no_fl=
ush(struct mmu_notifier *mn
>                 .end            =3D end,
>                 .handler        =3D handler,
>                 .on_lock        =3D (void *)kvm_null_fn,
> -               .on_unlock      =3D (void *)kvm_null_fn,
>                 .flush_on_ret   =3D false,
>                 .may_block      =3D false,
>         };
> @@ -813,7 +806,6 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>                 .end            =3D range->end,
>                 .handler        =3D kvm_mmu_unmap_gfn_range,
>                 .on_lock        =3D kvm_mmu_invalidate_begin,
> -               .on_unlock      =3D (void *)kvm_null_fn,
>                 .flush_on_ret   =3D true,
>                 .may_block      =3D mmu_notifier_range_blockable(range),
>         };
> @@ -858,6 +850,8 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>
>  void kvm_mmu_invalidate_end(struct kvm *kvm)
>  {
> +       lockdep_assert_held_write(&kvm->mmu_lock);
> +
>         /*
>          * This sequence increase will notify the kvm page fault that
>          * the page that is going to be mapped in the spte could have
> @@ -889,7 +883,6 @@ static void kvm_mmu_notifier_invalidate_range_end(str=
uct mmu_notifier *mn,
>                 .end            =3D range->end,
>                 .handler        =3D (void *)kvm_null_fn,
>                 .on_lock        =3D kvm_mmu_invalidate_end,
> -               .on_unlock      =3D (void *)kvm_null_fn,
>                 .flush_on_ret   =3D false,
>                 .may_block      =3D mmu_notifier_range_blockable(range),
>         };
> --
> 2.42.0.820.g83a721a137-goog
>
