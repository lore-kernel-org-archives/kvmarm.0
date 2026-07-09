Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AA3403AF1
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783611181; cv=none; b=IZSEjniVVZvgR9Hkl2/AbMFTpwCYyiCmF6LzfSHeMjZ7+bK6sZpv/ArBNwegl7jyc+5NmFrRR8rV8rFlULTGkN4tnU5Qh7+6XsOZLubGjWFgNdjd6YXcSXlb85q6ePon/Vem/C8T0eZYgfoyHlFvT1Gdyexzlu4v4aGxgbIZZQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783611181; c=relaxed/simple;
	bh=FOuIs2FnelcStzjfytUlQj/XIh2mk+bBiRzy7TnhJj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HGXJIoQfvmv2I+nJu/58qJcf1E0g+/H0UFurMeHtPbOuCjSwRpY40nwHe/OOsyhpkKUO8fgezW7iIGysjOuBHpicYG68hOGm22QF36wh2Ii5ufCaOxq6AE17TTwQL1uzhNRpmy7HUMRWZ0WKo/15THPRGMK25Z6soxQ13fU7QbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X/I5hT5U; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X/I5hT5U"
X-Forwarded-Encrypted: i=1; AHgh+RrNgfQTOJvHIFYR+MUmmmUquWOKC4MFeUK/tEDQflERke3pOUXEWsmej8E36pdCZy3O7DCBJwE=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783611176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QpeEm7ql8fQsW5ehwhWZnRCBt4W3+00jKdxsrJyt878=;
	b=X/I5hT5U0NVnEXCDAUXeQYXCI+ZKLfeJkb6kLll0iN1QEf5uFieADVwfkUxr+1nvaSjvc8
	EZt3aDGsN6ocPq9GWuumgJEz+iikjT9WpF6JtbJ1oH93Xg/D3P9kF3FmkPBbfrrR4KmSmw
	MGR/qCMZzEyOio3cjqE8gtP3kuPfHrM=
X-Gm-Message-State: AOJu0YzGMoiR6/KVJ9xXr9FwO9ZDbWFu7lxF29CiYbwTYSyQFQfYucc0
	S7T+zwVZM+uhgxYXJ2LsQUTQth3TGLvPqdmt/ga6/0CQkAkJV0OW71DxP/sRVe8u+Piq6yd225J
	A/wGf6q80zkLTunzHOuLzfrHfRK/JsKw1RBdLxOO+
X-Received: by 2002:ac8:7d13:0:b0:517:38aa:c2b3 with SMTP id
 d75a77b69052e-51c9a7db081mr9671891cf.14.1783611173225; Thu, 09 Jul 2026
 08:32:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260708182510.2181857-1-fuad.tabba@linux.dev>
 <20260708182510.2181857-4-fuad.tabba@linux.dev> <ak-5P-bZkbO4UCce@raptor>
In-Reply-To: <ak-5P-bZkbO4UCce@raptor>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 9 Jul 2026 16:32:15 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwYFt1W6JA7G7VnOdXp8tKMxSGpwRtoeqV4sYf+FwZMEQ@mail.gmail.com>
X-Gm-Features: AUfX_myyBpO-l-rxJGxLvxqJ6kl7SA4aMKfpn8Mmr6hqEebu9jdCxhiF2GymYAc
Message-ID: <CA+EHjTwYFt1W6JA7G7VnOdXp8tKMxSGpwRtoeqV4sYf+FwZMEQ@mail.gmail.com>
Subject: Re: [PATCH kvmtool v2 3/4] Add support for registering
 guest_memfd-backed memory regions
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Thu, 9 Jul 2026 at 16:07, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi Fuad,
>
> On Wed, Jul 08, 2026 at 07:25:09PM +0100, Fuad Tabba wrote:
> > Extend kvm__register_mem() with a guest_memfd file descriptor and
> > offset. A bank with a guest_memfd is registered with
> > KVM_SET_USER_MEMORY_REGION2 and KVM_MEM_GUEST_MEMFD, binding the
> > memslot to the file. This prepares for backing guest RAM with
> > guest_memfd on arm64.
> >
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  hw/cfi_flash.c    |  2 +-
> >  include/kvm/kvm.h | 15 +++++++++++++--
> >  kvm.c             | 36 ++++++++++++++++++++++++++----------
> >  3 files changed, 40 insertions(+), 13 deletions(-)
> >
> > diff --git a/hw/cfi_flash.c b/hw/cfi_flash.c
> > index b68d9e0..4413955 100644
> > --- a/hw/cfi_flash.c
> > +++ b/hw/cfi_flash.c
> > @@ -451,7 +451,7 @@ static int map_flash_memory(struct kvm *kvm, struct cfi_flash_device *sfdev)
> >       int ret;
> >
> >       ret = kvm__register_mem(kvm, sfdev->base_addr, sfdev->size,
> > -                             sfdev->flash_memory,
> > +                             sfdev->flash_memory, -1, 0,
> >                               KVM_MEM_TYPE_RAM | KVM_MEM_TYPE_READONLY);
> >       if (!ret)
> >               sfdev->is_mapped = true;
> > diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> > index eb23e2f..5e7b5eb 100644
> > --- a/include/kvm/kvm.h
> > +++ b/include/kvm/kvm.h
> > @@ -128,11 +128,22 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
> >  bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
> >  int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
> >  int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
> > +                   int guest_memfd, u64 guest_memfd_offset,
> >                     enum kvm_mem_type type);
> >  static inline int kvm__register_ram(struct kvm *kvm, u64 guest_phys, u64 size,
> >                                   void *userspace_addr)
> >  {
> >       return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
> > +                              -1, 0, KVM_MEM_TYPE_RAM);
> > +}
> > +
> > +static inline int kvm__register_ram_guest_memfd(struct kvm *kvm, u64 guest_phys,
> > +                                             u64 size, void *userspace_addr,
> > +                                             int guest_memfd,
> > +                                             u64 guest_memfd_offset)
> > +{
> > +     return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
> > +                              guest_memfd, guest_memfd_offset,
> >                                KVM_MEM_TYPE_RAM);
>
> One small nitpick here, KVM_CREATE_GUEST_MEMFD returns -1 on error. If
> callers forget to check the result of KVM_CREATE_GUEST_MEMFD and pass the
> result to kvm__register_ram_guest_memfd(), the error won't be detected and
> kvmtool will end up creating a non-guest_memfd backed memslot. Definitely
> unexpected. It might be useful to someone, someday, to add a check here for
> guest_memfd >= 0, but it's not terribly important.

Good point. The only caller today (mmap_guest_memfd) already dies on
error, but a defensive check in kvm__register_mem makes the contract
explicit. I'll add one in v3.

> Regardless:
>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!
/fuad

>
> Thanks,
> Alex
>
> >  }
> >
> > @@ -140,13 +151,13 @@ static inline int kvm__register_dev_mem(struct kvm *kvm, u64 guest_phys,
> >                                       u64 size, void *userspace_addr)
> >  {
> >       return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
> > -                              KVM_MEM_TYPE_DEVICE);
> > +                              -1, 0, KVM_MEM_TYPE_DEVICE);
> >  }
> >
> >  static inline int kvm__reserve_mem(struct kvm *kvm, u64 guest_phys, u64 size)
> >  {
> >       return kvm__register_mem(kvm, guest_phys, size, NULL,
> > -                              KVM_MEM_TYPE_RESERVED);
> > +                              -1, 0, KVM_MEM_TYPE_RESERVED);
> >  }
> >
> >  int __must_check kvm__register_iotrap(struct kvm *kvm, u64 phys_addr, u64 len,
> > diff --git a/kvm.c b/kvm.c
> > index 95ccfcb..947721b 100644
> > --- a/kvm.c
> > +++ b/kvm.c
> > @@ -237,9 +237,9 @@ out:
> >  }
> >
> >  int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> > -                   void *userspace_addr, enum kvm_mem_type type)
> > +                   void *userspace_addr, int guest_memfd,
> > +                   u64 guest_memfd_offset, enum kvm_mem_type type)
> >  {
> > -     struct kvm_userspace_memory_region mem;
> >       struct kvm_mem_bank *merged = NULL;
> >       struct kvm_mem_bank *bank;
> >       struct list_head *prev_entry;
> > @@ -320,15 +320,31 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> >               flags |= KVM_MEM_READONLY;
> >
> >       if (type != KVM_MEM_TYPE_RESERVED) {
> > -             mem = (struct kvm_userspace_memory_region) {
> > -                     .slot                   = slot,
> > -                     .flags                  = flags,
> > -                     .guest_phys_addr        = guest_phys,
> > -                     .memory_size            = size,
> > -                     .userspace_addr         = (unsigned long)userspace_addr,
> > -             };
> > +             if (guest_memfd >= 0) {
> > +                     struct kvm_userspace_memory_region2 mem2 = {
> > +                             .slot                   = slot,
> > +                             .flags                  = flags | KVM_MEM_GUEST_MEMFD,
> > +                             .guest_phys_addr        = guest_phys,
> > +                             .memory_size            = size,
> > +                             .userspace_addr         = (unsigned long)userspace_addr,
> > +                             .guest_memfd            = guest_memfd,
> > +                             .guest_memfd_offset     = guest_memfd_offset,
> > +                     };
> >
> > -             ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> > +                     ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2,
> > +                                 &mem2);
> > +             } else {
> > +                     struct kvm_userspace_memory_region mem = {
> > +                             .slot                   = slot,
> > +                             .flags                  = flags,
> > +                             .guest_phys_addr        = guest_phys,
> > +                             .memory_size            = size,
> > +                             .userspace_addr         = (unsigned long)userspace_addr,
> > +                     };
> > +
> > +                     ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION,
> > +                                 &mem);
> > +             }
> >               if (ret < 0) {
> >                       ret = -errno;
> >                       goto out;
> > --
> > 2.39.5
> >
