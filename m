Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8DD409286
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 15:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783526400; cv=none; b=FOLSZVIG2ZM6k8UlHkuw/YLssBv0Gklg7PM9Atgwi19sIi/znX4qxkrepgHgfRTKkM6+xtxxFs0l/PIqIxPcjCLepJbG15EZqOHFnFXoxJO+IRwOgZYgMa4mKZoef5hjSrFGvAyEW4RP8zN817+9/fug292YUfd1j7cM8xixdAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783526400; c=relaxed/simple;
	bh=Wisa0hatuEJjiJu8RfGgGd55BM75sG9fW5fgSsBCR6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PIXbiohPf01zVrKre+jyFi1vGxViJLbtK40Wj2LBSIFMeCHUoVyH2LEaGh3FFVkq2JP7iqkVLYdH2hwO+VQq5lp8xDQEjqmsYKhE5opeJp3WiiNhsozbH1teog5mbBxWB922bDaL3DQHCiTQ1LWJJz79DVatVxZP9nVHJFK/q7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RbQ7LMp0; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RbQ7LMp0"
X-Forwarded-Encrypted: i=1; AHgh+Rq+v9sNjz6gKtmCIoXWo+qPmLsIZPPRbwvu7styjv7rGypfMeD0g4i5vLhX7ELg6cYOt0cSzRk=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783526396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BYWRPdLaFuG1romC1lCIBnWdBcrZaYParIdEPwnHq5s=;
	b=RbQ7LMp0M/xJU/8tAfIBda2U0mMPSuw0Ctt/YiKSkRA1en+9U6okdoJ7u8OQX55dvdS4H+
	srGyoQdVvfH0wvvIWRIyNVOjwZ79zBTV2WP7Uw32gkn+YRZtR4s8VM5dwFy0eVy4Gpdvh0
	ub2suxcmd0tFAbo5Zsdyq2ExNN5nrck=
X-Gm-Message-State: AOJu0YynsgbNg2joAlIsjCNQ/tOIMxU1w2JjFKXXLWx9hS44DhISAwLa
	kpG8dM5BMEC4skfrrSk6pdKH3NlN4vWrxUVH39Hc99JC+9McspfqmWeKeJjyxpSWXOiXi21qWTC
	BVuAW4eQz3aankPkIovEUUeZaMycDdCgLWDgXNspV
X-Received: by 2002:a05:622a:1909:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-51c88756ce0mr10244531cf.5.1783526377949; Wed, 08 Jul 2026
 08:59:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706083555.302972-1-fuad.tabba@linux.dev> <20260706083555.302972-6-fuad.tabba@linux.dev>
 <ak5KcuSzEo7s9P1s@raptor>
In-Reply-To: <ak5KcuSzEo7s9P1s@raptor>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 8 Jul 2026 16:59:01 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzXDaN2xPHW3iocrJZFAnY34Svq4OFsgJ=gc3ove0iYHA@mail.gmail.com>
X-Gm-Features: AUfX_myqNOr7mXQIdwBZF9pz250HWIccvC8EjVkA9Pco7CACbbHZP63pPBeyxYU
Message-ID: <CA+EHjTzXDaN2xPHW3iocrJZFAnY34Svq4OFsgJ=gc3ove0iYHA@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 5/5] arm64: Add --guest-memfd option to back
 guest RAM with guest_memfd
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Wed, 8 Jul 2026 at 14:02, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi Fuad,
>
> Looks good me, two small things: it might be useful for debugging to first
> check that KVM supports KVM_CAP_GUEST_MEMFD before checking
> KVM_CAP_GUEST_MEMFD_FLAGS, and the file descriptor could be closed after it
> is unmapped.

Good points, will fix both in v2.

Thanks,
/fuad


>
> Thanks,
> Alex
>
> On Mon, Jul 06, 2026 at 09:35:55AM +0100, Fuad Tabba wrote:
> > Back guest RAM with a guest_memfd created with GUEST_MEMFD_FLAG_MMAP
> > and GUEST_MEMFD_FLAG_INIT_SHARED, mmapped MAP_SHARED to provide the
> > userspace mapping.
> >
> > Protected VMs need in-place shared/private conversion of guest_memfd,
> > which the kernel does not support yet, so reject the combination of
> > --protected and --guest-memfd.
> >
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  arm64/include/kvm/kvm-config-arch.h |  5 +++-
> >  arm64/kvm.c                         | 38 +++++++++++++++++++++++------
> >  include/kvm/kvm.h                   |  1 +
> >  include/kvm/util.h                  |  1 +
> >  kvm.c                               |  1 +
> >  util/util.c                         | 34 ++++++++++++++++++++++++++
> >  6 files changed, 71 insertions(+), 9 deletions(-)
> >
> > diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
> > index c2702d5..d8a8ef7 100644
> > --- a/arm64/include/kvm/kvm-config-arch.h
> > +++ b/arm64/include/kvm/kvm-config-arch.h
> > @@ -20,6 +20,7 @@ struct kvm_config_arch {
> >       bool            no_pvtime;
> >       bool            psci;
> >       bool            protected;
> > +     bool            guest_memfd;
> >  };
> >
> >  int irqchip_parser(const struct option *opt, const char *arg, int unset);
> > @@ -73,6 +74,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
> >       OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,                                 \
> >                   "Create guest without VHE support"),                        \
> >       OPT_BOOLEAN('\0', "protected", &(cfg)->protected,                       \
> > -                     "Create a protected VM when pKVM is enabled"),
> > +                     "Create a protected VM when pKVM is enabled"),          \
> > +     OPT_BOOLEAN('\0', "guest-memfd", &(cfg)->guest_memfd,                   \
> > +                     "Use guest_memfd to back guest RAM"),
> >
> >  #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
> > diff --git a/arm64/kvm.c b/arm64/kvm.c
> > index fb0b98d..b594578 100644
> > --- a/arm64/kvm.c
> > +++ b/arm64/kvm.c
> > @@ -49,9 +49,14 @@ void kvm__init_ram(struct kvm *kvm)
> >       kvm->arch.ram_alloc_size = kvm->ram_size;
> >       if (!kvm->cfg.hugetlbfs_path)
> >               kvm->arch.ram_alloc_size += SZ_2M;
> > -     kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
> > -                                             kvm->cfg.hugetlbfs_path,
> > -                                             kvm->arch.ram_alloc_size);
> > +
> > +     if (kvm->cfg.arch.guest_memfd)
> > +             kvm->arch.ram_alloc_start =
> > +                     mmap_guest_memfd(kvm, kvm->arch.ram_alloc_size);
> > +     else
> > +             kvm->arch.ram_alloc_start =
> > +                     mmap_anon_or_hugetlbfs(kvm, kvm->cfg.hugetlbfs_path,
> > +                                            kvm->arch.ram_alloc_size);
> >
> >       if (kvm->arch.ram_alloc_start == MAP_FAILED)
> >               die("Failed to map %lld bytes for guest memory (%d)",
> > @@ -60,17 +65,25 @@ void kvm__init_ram(struct kvm *kvm)
> >       kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
> >                                       SZ_2M);
> >
> > -     madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> > -             MADV_MERGEABLE);
> > +     if (!kvm->cfg.arch.guest_memfd) {
> > +             madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> > +                     MADV_MERGEABLE);
> >
> > -     madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> > -             MADV_HUGEPAGE);
> > +             madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> > +                     MADV_HUGEPAGE);
> > +     }
> >
> >       phys_start      = kvm->cfg.ram_addr;
> >       phys_size       = kvm->ram_size;
> >       host_mem        = kvm->ram_start;
> >
> > -     err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
> > +     if (kvm->cfg.arch.guest_memfd)
> > +             err = kvm__register_ram_guest_memfd(kvm, phys_start,
> > +                                                 phys_size, host_mem,
> > +                                                 kvm->ram_guest_memfd,
> > +                                                 host_mem - kvm->arch.ram_alloc_start);
> > +     else
> > +             err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
> >       if (err)
> >               die("Failed to register %lld bytes of memory at physical "
> >                   "address 0x%llx [err %d]", phys_size, phys_start, err);
> > @@ -468,6 +481,15 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
> >       if (kvm->cfg.arch.e2h0 && !kvm->cfg.arch.nested_virt)
> >               pr_warning("--e2h0 requires --nested, ignoring");
> >
> > +     if (kvm->cfg.arch.guest_memfd) {
> > +             /* Requires in-place shared/private conversion of guest_memfd. */
> > +             if (kvm->cfg.arch.protected)
> > +                     die("Protected VMs do not yet support guest_memfd");
> > +
> > +             if (kvm->cfg.hugetlbfs_path)
> > +                     die("guest_memfd cannot be backed by hugetlbfs");
> > +     }
> > +
> >       if (kvm->cfg.arch.protected) {
> >               if (kvm->cfg.ram_size &&
> >                   kvm->cfg.ram_size < DMA_MEM_REGION_SIZE) {
> > diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> > index 5e7b5eb..95dc52f 100644
> > --- a/include/kvm/kvm.h
> > +++ b/include/kvm/kvm.h
> > @@ -90,6 +90,7 @@ struct kvm {
> >       u64                     ram_size;       /* Guest memory size, in bytes */
> >       void                    *ram_start;
> >       u64                     ram_pagesize;
> > +     int                     ram_guest_memfd; /* guest_memfd backing RAM, -1 if none */
> >       struct mutex            mem_banks_lock;
> >       struct list_head        mem_banks;
> >
> > diff --git a/include/kvm/util.h b/include/kvm/util.h
> > index a6dba11..9e23431 100644
> > --- a/include/kvm/util.h
> > +++ b/include/kvm/util.h
> > @@ -148,5 +148,6 @@ static inline int pow2_size(unsigned long x)
> >  struct kvm;
> >  void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
> >  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
> > +void *mmap_guest_memfd(struct kvm *kvm, u64 size);
> >
> >  #endif /* KVM__UTIL_H */
> > diff --git a/kvm.c b/kvm.c
> > index 3d05756..a400dd2 100644
> > --- a/kvm.c
> > +++ b/kvm.c
> > @@ -162,6 +162,7 @@ struct kvm *kvm__new(void)
> >       mutex_init(&kvm->mem_banks_lock);
> >       kvm->sys_fd = -1;
> >       kvm->vm_fd = -1;
> > +     kvm->ram_guest_memfd = -1;
> >
> >  #ifdef KVM_BRLOCK_DEBUG
> >       kvm->brlock_sem = (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
> > diff --git a/util/util.c b/util/util.c
> > index 05d49c4..c60fe02 100644
> > --- a/util/util.c
> > +++ b/util/util.c
> > @@ -6,7 +6,9 @@
> >  #include "kvm/util.h"
> >
> >  #include <kvm/kvm.h>
> > +#include <linux/kvm.h>
> >  #include <linux/magic.h>     /* For HUGETLBFS_MAGIC */
> > +#include <sys/ioctl.h>
> >  #include <sys/mman.h>
> >  #include <sys/stat.h>
> >  #include <sys/statfs.h>
> > @@ -169,3 +171,35 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 si
> >               return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
> >       }
> >  }
> > +
> > +/*
> > + * Map guest RAM backed by a guest_memfd. The file descriptor must stay open
> > + * for the lifetime of the VM: closing it invalidates the memslot bindings.
> > + */
> > +void *mmap_guest_memfd(struct kvm *kvm, u64 size)
> > +{
> > +     u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
> > +     struct kvm_create_guest_memfd gmem = {
> > +             .size   = size,
> > +             .flags  = flags,
> > +     };
> > +     void *addr;
> > +     int ret;
> > +
> > +     ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_GUEST_MEMFD_FLAGS);
> > +     if (ret < 0 || ((u64)ret & flags) != flags)
> > +             die("kernel does not support guest_memfd with mmap");
> > +
> > +     ret = ioctl(kvm->vm_fd, KVM_CREATE_GUEST_MEMFD, &gmem);
> > +     if (ret < 0)
> > +             die_perror("KVM_CREATE_GUEST_MEMFD");
> > +
> > +     addr = mmap(NULL, size, PROT_RW, MAP_SHARED, ret, 0);
> > +     if (addr == MAP_FAILED)
> > +             die_perror("guest_memfd mmap");
> > +
> > +     kvm->ram_guest_memfd = ret;
> > +     kvm->ram_pagesize = getpagesize();
> > +
> > +     return addr;
> > +}
> > --
> > 2.39.5
> >
