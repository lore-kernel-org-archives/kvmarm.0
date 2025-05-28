Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6ACF288C1C
	for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 15:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748445721; cv=none; b=A5Mvo2I3w0ozg84DsN9/glHyf+K6XcUiqBgPszLt8GEn7AxFjElwUN8na4oQ20wIvqXDmERK7haCk5gLjaaRQKCiUEhuUbhxQ3Im9RAEsGp+FV4XTp+M6sqXWfcXGsqvmEeqDHkMQzoHrpRGu12ZEopsnNkKCZ13octR9XgyJck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748445721; c=relaxed/simple;
	bh=0L9FqIrWV1HH0CKjcDoLD6PMX4MXaZyCx+Isv4wqI6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gth/u0CA2ppgkb3XUqh46VVKppOVNG96dPixLar2YrdOq7SG1W8vm04jZZdaqmAIrbd4gr1sAILgn0lo2j8jSfLz7lp0M2G1IOIbAL0/QJEpFHKtZg28R0Dv9vf+6jnUM2M6r+YJcBjhgZmVJXUP6V+JDkua6sWOSHZf+nLwHSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=13Ptvw15; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="13Ptvw15"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e7dc89108bfso1632940276.3
        for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 08:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748445718; x=1749050518; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32qgoYfovQ3gS/SAum8cU1W1nbKSlw2h8oFp1ZvYf5Q=;
        b=13Ptvw155Jue5rAxjUhtPGwDvQ4zV7Roc94t6XwqJS5T5toS9CMDkzqWqKm+kBpLst
         YtWgT1/uMI5ugyNV7wLCezLeomfnDYdCDtpDhBNwlAvjeh3jsSI+WLCfxggNFG18QkFn
         4vNgCe/UgVgUeUIe9DkzgLRhDfy13547YY+mX/aqk+msSbVECB2hbenK1hjOWMb64cUl
         lxf4rKtuIMDXq/w0R5ATGMbzhHFtYpTXfPhaFkvW/sUeAQJPqdVKCbwjrWvwYUNOEnC/
         3VE3d5OuXvA4WZrlXYpJrALEdVnFSC/c6bd+ROJ8GUUUjwoqqP5axXkCOhPhOpTV8N5a
         sWGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748445718; x=1749050518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32qgoYfovQ3gS/SAum8cU1W1nbKSlw2h8oFp1ZvYf5Q=;
        b=Nblv8Cx2J0B5uD1cmtucENvuLo4pYOVE2Aike7QEKw5+ClnUdE3uYPy8F+jlibN9b/
         V+sL+XKtdoWyzQZBEZxJ1cv9CTdzB0t027VPP4KmBDQrDchwf2zXJSHSmEf7uhJMGe5d
         9D3I5QrCIamkEwqd+KMSwIgrhKU9ZPIhvIepLb8KC3SEJFEwhzX4T7xb5QH5SFDsriTi
         TXHGw0J8MYUOUyZxQYm2Ih02Nvq5qV9bP6zG6gcqhsKpZ4jZm3zm7m/sJZZ4qY304xyw
         a3tU9S8wDPs8kbuwRf8K1q+7guaryeNFS07HQhZhUmMW5qzjvt7JuvEUhupRrVvCPUZe
         zVGw==
X-Forwarded-Encrypted: i=1; AJvYcCVI3IV0aSpU/0SSaF1qgHy4MJCswNDsgJnhCOhdLgj0HKiO0V0G02NTZ3W9cqecpkWrPciiZFY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxlvhvqjROcf6fFR3P5HzhxbuC8oKCLI86gU9meTcXyhcoJydH
	WC2qWgbsm2pxA6C3Xl+jTwNGfHa375MPiJCmjrA78rNmcEyFNqmyoaHNvyprb2jrElD5N9p2ptw
	Bqz6i7fJO7H2Pwb8FqDuid3rW6JS/rCBJkF8w21i2
X-Gm-Gg: ASbGncuM9DKdCfaEiwdR3+vhrthjeKLNkyiHVVnY4RcSDbI5e6leDrmVf6ePoyZEQJk
	3wXB5GVtqfn6b2XXqnrXtiCnu5FfJNbM9TQ5Ow2h4y+Vz2OLon6Shw8qBOf3XQ8FrEs1v9TEn1h
	afWqhWZnKTUixibsCzOOeEjQ2cLqWQC7iZnGjtmuu53eX0e4cswCoyCg977JYbKjclTuU4wVLlS
	h8ohA==
X-Google-Smtp-Source: AGHT+IFSzzwtG0QBLjREdP8rJp3MI7Sye8YaM/FgQl/WLbT3PKgJS/6Q9/qQMcY7F2ocTfZADqMYbCZWjE0ffy1ogQw=
X-Received: by 2002:a05:6902:2b0c:b0:e78:f7a0:fd02 with SMTP id
 3f1490d57ef6-e7f61839725mr2840203276.37.1748445717406; Wed, 28 May 2025
 08:21:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-2-jthoughton@google.com> <aBqi7fDtnvxzxV1V@google.com>
In-Reply-To: <aBqi7fDtnvxzxV1V@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 28 May 2025 11:21:21 -0400
X-Gm-Features: AX0GCFti85Bmslv3UKy35YTx4AbsV0M4oMVo9TuLb01TfEKfWoCE-rNdRG1Yeks
Message-ID: <CADrL8HUMm0PUqx-xNdPvSMP6z4gzs2OTUJG1sdyy88D-XWxT3g@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 8:01=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Jan 09, 2025, James Houghton wrote:
> > Use one of the 14 reserved u64s in struct kvm_userspace_memory_region2
> > for the user to provide `userfault_bitmap`.
> >
> > The memslot flag indicates if KVM should be reading from the
> > `userfault_bitmap` field from the memslot. The user is permitted to
> > provide a bogus pointer. If the pointer cannot be read from, we will
> > return -EFAULT (with no other information) back to the user.
>
> For the uAPI+infrastructure changelog, please elaborate on the design goa=
ls and
> choices.  The "what" is pretty obvious from the patch; describe why this =
is being
> added.
>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  include/linux/kvm_host.h | 14 ++++++++++++++
> >  include/uapi/linux/kvm.h |  4 +++-
> >  virt/kvm/Kconfig         |  3 +++
> >  virt/kvm/kvm_main.c      | 35 +++++++++++++++++++++++++++++++++++
> >  4 files changed, 55 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 401439bb21e3..f7a3dfd5e224 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -590,6 +590,7 @@ struct kvm_memory_slot {
> >       unsigned long *dirty_bitmap;
> >       struct kvm_arch_memory_slot arch;
> >       unsigned long userspace_addr;
> > +     unsigned long __user *userfault_bitmap;
> >       u32 flags;
> >       short id;
> >       u16 as_id;
> > @@ -724,6 +725,11 @@ static inline bool kvm_arch_has_readonly_mem(struc=
t kvm *kvm)
> >  }
> >  #endif
> >
> > +static inline bool kvm_has_userfault(struct kvm *kvm)
> > +{
> > +     return IS_ENABLED(CONFIG_HAVE_KVM_USERFAULT);
> > +}
>
> Eh, don't think we need this wrapper.  Just check the CONFIG_xxx manually=
 in the
> one or two places where code isn't guarded by an #ifdef.
>
> >  struct kvm_memslots {
> >       u64 generation;
> >       atomic_long_t last_used_slot;
> > @@ -2553,4 +2559,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_v=
cpu *vcpu,
> >                                   struct kvm_pre_fault_memory *range);
> >  #endif
> >
> > +int kvm_gfn_userfault(struct kvm *kvm, struct kvm_memory_slot *memslot=
,
> > +                   gfn_t gfn);
> > +
> > +static inline bool kvm_memslot_userfault(struct kvm_memory_slot *memsl=
ot)
>
> I strongly prefer kvm_is_userfault_memslot().  KVM's weird kvm_memslot_<f=
lag>()
> nomenclature comes from ancient code, i.e. isn't something I would follow=
.
>
> > +{
> > +     return memslot->flags & KVM_MEM_USERFAULT;
>
> I think it's worth checking for a non-NULL memslot, even if all current c=
allers
> pre-check for a slot.
>
> > @@ -2042,6 +2051,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >               if (r)
> >                       goto out;
> >       }
> > +     if (mem->flags & KVM_MEM_USERFAULT)
> > +             new->userfault_bitmap =3D
> > +               (unsigned long __user *)(unsigned long)mem->userfault_b=
itmap;
>
>         if (mem->flags & KVM_MEM_USERFAULT)
>                 new->userfault_bitmap =3D u64_to_user_ptr(mem->userfault_=
bitmap);

Applied this change to the other cast (where we do access_ok()) as well, th=
anks!

>
> >       r =3D kvm_set_memslot(kvm, old, new, change);
> >       if (r)
> > @@ -6426,3 +6438,26 @@ void kvm_exit(void)
> >       kvm_irqfd_exit();
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_exit);
> > +
> > +int kvm_gfn_userfault(struct kvm *kvm, struct kvm_memory_slot *memslot=
,
> > +                    gfn_t gfn)
>
> I think this series is the perfect opportunity (read: victim) to introduc=
e a
> common "struct kvm_page_fault".  With a common structure to provide the g=
fn, slot,
> write, exec, and is_private fields, this helper can handle the checks and=
 the call
> to kvm_prepare_memory_fault_exit().
>
> And with that in place, I would vote to name this something like kvm_do_u=
serfault(),
> return a boolean, and let the caller return -EFAULT.

Returning 'true' from kvm_do_userfault() without a
kvm_prepare_memory_fault_exit() looked a bit strange at first, but I
don't have strong feelings. I'll add a small comment there.

>
> For making "struct kvm_page_fault" common, one thought would be to have a=
rch code
> define the entire struct, and simply assert on the few fields that common=
 KVM needs
> being defined by arch code.  And wrap all references in CONFIG_KVM_GENERI=
C_PAGE_FAULT.
>
> I don't expect there will be a huge number of fields that common KVM need=
s, i.e. I
> don't think the maintenance burden of punting to arch code will be high. =
 And letting
> arch code own the entire struct means we don't need to have e.g. fault->a=
rch.present
> vs. fault->write in KVM x86, which to me is a big net negative for readab=
ility.
>
> I'll respond to the cover letter with an attachment of seven patches to s=
ketch out
> the idea.

Looks great! Thanks very much!

>
> > +{
> > +     unsigned long bitmap_chunk =3D 0;
> > +     off_t offset;
> > +
> > +     if (!kvm_memslot_userfault(memslot))
> > +             return 0;
> > +
> > +     if (WARN_ON_ONCE(!memslot->userfault_bitmap))
> > +             return 0;
>
> '0' is technically a valid userspace address.  I'd just drop this.  If we=
 have a
> KVM bug that results in failure to generate usefaults, we'll notice quite=
 quickly.
>
> > +
> > +     offset =3D gfn - memslot->base_gfn;
> > +
> > +     if (copy_from_user(&bitmap_chunk,
> > +                        memslot->userfault_bitmap + offset / BITS_PER_=
LONG,
> > +                        sizeof(bitmap_chunk)))
>
> Since the address is checked during memslot creation, I'm pretty sure thi=
s can
> use __get_user().  At the very least, it should be get_user().

Thanks! I agree, __get_user() should be fine.

>
> > +             return -EFAULT;
> > +
> > +     /* Set in the bitmap means that the gfn is userfault */
> > +     return !!(bitmap_chunk & (1ul << (offset % BITS_PER_LONG)));
>
> test_bit()?

Thanks for all the feedback and applying it for me in those patches
you sent back. :)
