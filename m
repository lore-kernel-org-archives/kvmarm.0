Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFB51112
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 12:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="va6BMRYL"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-66d093265dfso42980146d6.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 05:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698842800; x=1699447600; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mygXGcRJ5YlWP61Tr7KN5KWyfhmOoXTRmQYYFZqOKKI=;
        b=va6BMRYLVKoJX82bORxDaBZ8QK6FIVQ2zmwY6pusl6SE+4D9fkNI0BrJBYyvgpKeci
         jFwQom3jwN+L5Fo3o3vwDxiDFcv9t+ys5YNWYttsORLNVk9iO7iYvQnF9H911M8Rro8a
         QIGfRITktFNTuRMGoPhLWoiOd2ERjZwYpeJkAV+4WQHsC2xD9GpCZw24sjVqg/855XWX
         tkNlSMGcivPyOTFV0IWMyu1AlhZQYubuS/iXxObHl7Sd6hPInHzyKJLsRkP+Th16RqC8
         wY6wSkpAXi82M1La1zy0t+aEzljZJSPtzJx4Rkn20rMUvmOuG5MtTgxaol8zpHjkXIlq
         gTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698842800; x=1699447600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mygXGcRJ5YlWP61Tr7KN5KWyfhmOoXTRmQYYFZqOKKI=;
        b=f8rPabl+WXNrdgbghvqorD5dc1GE8CFvGDoYR6vLMwljgTlgbK1E5hx2uXQHCXhmD/
         emSu5yr8QS+q5rKe+PRyuL811pFqzg5WOYYPkeCV+RHTSxITVskHaPTxUXkhbK1/MiJo
         kupPlBXlXJ7r6EORFHsls2VUJh5bE90i3HByi76RqM+w6xeL1ZbifUaUhvwnAi75oMDE
         UMh0VfofGLxYWTDk5V+xVW0wqpAAlDeMEEBaI/uHOWHcEp+i/ZLJDDBCYMh8ADtwQooy
         GgFl6KRA3iAa5wUHWUSqdV77muXEaJ89S9N0ggv4RMRu0oeG6yqXfj1T6UlR4mItgCnf
         SdTQ==
X-Gm-Message-State: AOJu0YxMA4gxRRFV2CWcjEba9bjjG/pNxvuU36h8SvmNwFMXqlG1OwV9
	rrmAafBfYERFOqGP//Qn9nhTY5hYwnj34GBCFgzk+A==
X-Google-Smtp-Source: AGHT+IHd9N8dL6zdz3IA97hhnoDYG1Yv2Mx5veJZKoCg3Vt6EBcnFz3FSACXzGNwepp4FUZ865yy59BtQyGtgdViYUM=
X-Received: by 2002:a05:6214:f6c:b0:671:739e:e2fa with SMTP id
 iy12-20020a0562140f6c00b00671739ee2famr13258176qvb.59.1698842799599; Wed, 01
 Nov 2023 05:46:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-2-seanjc@google.com>
In-Reply-To: <20231027182217.3615211-2-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 1 Nov 2023 12:46:02 +0000
Message-ID: <CA+EHjTy5tmgGmVNGTX4a2Engb+r1AQizsMxwb8xqOi1f9+VQLA@mail.gmail.com>
Subject: Re: [PATCH v13 01/35] KVM: Tweak kvm_hva_range and hva_handler_t to
 allow reusing for gfn ranges
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
> Rework and rename "struct kvm_hva_range" into "kvm_mmu_notifier_range" so
> that the structure can be used to handle notifications that operate on gf=
n
> context, i.e. that aren't tied to a host virtual address.  Rename the
> handler typedef too (arguably it should always have been gfn_handler_t).
>
> Practically speaking, this is a nop for 64-bit kernels as the only
> meaningful change is to store start+end as u64s instead of unsigned longs=
.
>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  virt/kvm/kvm_main.c | 34 +++++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 15 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 486800a7024b..0524933856d4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -541,18 +541,22 @@ static inline struct kvm *mmu_notifier_to_kvm(struc=
t mmu_notifier *mn)
>         return container_of(mn, struct kvm, mmu_notifier);
>  }
>
> -typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *ran=
ge);
> +typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *ran=
ge);
>
>  typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
>                              unsigned long end);
>
>  typedef void (*on_unlock_fn_t)(struct kvm *kvm);
>
> -struct kvm_hva_range {
> -       unsigned long start;
> -       unsigned long end;
> +struct kvm_mmu_notifier_range {
> +       /*
> +        * 64-bit addresses, as KVM notifiers can operate on host virtual
> +        * addresses (unsigned long) and guest physical addresses (64-bit=
).
> +        */
> +       u64 start;
> +       u64 end;
>         union kvm_mmu_notifier_arg arg;
> -       hva_handler_t handler;
> +       gfn_handler_t handler;
>         on_lock_fn_t on_lock;
>         on_unlock_fn_t on_unlock;
>         bool flush_on_ret;
> @@ -581,7 +585,7 @@ static const union kvm_mmu_notifier_arg KVM_MMU_NOTIF=
IER_NO_ARG;
>              node =3D interval_tree_iter_next(node, start, last))      \
>
>  static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
> -                                                 const struct kvm_hva_ra=
nge *range)
> +                                                 const struct kvm_mmu_no=
tifier_range *range)
>  {
>         bool ret =3D false, locked =3D false;
>         struct kvm_gfn_range gfn_range;
> @@ -608,9 +612,9 @@ static __always_inline int __kvm_handle_hva_range(str=
uct kvm *kvm,
>                         unsigned long hva_start, hva_end;
>
>                         slot =3D container_of(node, struct kvm_memory_slo=
t, hva_node[slots->node_idx]);
> -                       hva_start =3D max(range->start, slot->userspace_a=
ddr);
> -                       hva_end =3D min(range->end, slot->userspace_addr =
+
> -                                                 (slot->npages << PAGE_S=
HIFT));
> +                       hva_start =3D max_t(unsigned long, range->start, =
slot->userspace_addr);
> +                       hva_end =3D min_t(unsigned long, range->end,
> +                                       slot->userspace_addr + (slot->npa=
ges << PAGE_SHIFT));
>
>                         /*
>                          * To optimize for the likely case where the addr=
ess
> @@ -660,10 +664,10 @@ static __always_inline int kvm_handle_hva_range(str=
uct mmu_notifier *mn,
>                                                 unsigned long start,
>                                                 unsigned long end,
>                                                 union kvm_mmu_notifier_ar=
g arg,
> -                                               hva_handler_t handler)
> +                                               gfn_handler_t handler)
>  {
>         struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> -       const struct kvm_hva_range range =3D {
> +       const struct kvm_mmu_notifier_range range =3D {
>                 .start          =3D start,
>                 .end            =3D end,
>                 .arg            =3D arg,
> @@ -680,10 +684,10 @@ static __always_inline int kvm_handle_hva_range(str=
uct mmu_notifier *mn,
>  static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_noti=
fier *mn,
>                                                          unsigned long st=
art,
>                                                          unsigned long en=
d,
> -                                                        hva_handler_t ha=
ndler)
> +                                                        gfn_handler_t ha=
ndler)
>  {
>         struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> -       const struct kvm_hva_range range =3D {
> +       const struct kvm_mmu_notifier_range range =3D {
>                 .start          =3D start,
>                 .end            =3D end,
>                 .handler        =3D handler,
> @@ -771,7 +775,7 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>                                         const struct mmu_notifier_range *=
range)
>  {
>         struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> -       const struct kvm_hva_range hva_range =3D {
> +       const struct kvm_mmu_notifier_range hva_range =3D {
>                 .start          =3D range->start,
>                 .end            =3D range->end,
>                 .handler        =3D kvm_unmap_gfn_range,
> @@ -835,7 +839,7 @@ static void kvm_mmu_notifier_invalidate_range_end(str=
uct mmu_notifier *mn,
>                                         const struct mmu_notifier_range *=
range)
>  {
>         struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> -       const struct kvm_hva_range hva_range =3D {
> +       const struct kvm_mmu_notifier_range hva_range =3D {
>                 .start          =3D range->start,
>                 .end            =3D range->end,
>                 .handler        =3D (void *)kvm_null_fn,
> --
> 2.42.0.820.g83a721a137-goog
>
