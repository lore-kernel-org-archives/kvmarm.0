Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627C3414A26
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 11:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337133; cv=none; b=h+3fRCp3ylkM8aEHM5150y+A5I4UtP6e3pjdq/iB9WkmJHTJ/tlWMiy9+rU4p4VYc5E9h9jo2KnDFeyM78UVSmH1i/7dlco5wbTCIu6wBgWM2lDopUjCiSEJIzh0B15ZKtmN7ngP4NrcoTjGwFSTKkecVn/nCH/IM+KOehiMeFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337133; c=relaxed/simple;
	bh=DdyLefuk4V401v9pnaZhUI0yZT4ki/AII9kaTjvz6ZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BOZUENAyvLoXZaXSx8qC2hf+Ndj2UGhsXMVDs+3O+Yczg/4oerCLxV9G0t6g9EVIZhYetZ1+BkzZkcCsX9lE+K/mxTH8fV0vbsFSRQmEWCJ0Cu2RS0RBqOPb5ljj4eV7HEeMTjxMQgfOZg8XVdvzV/GHAe/MGwZbo3j+5a5JSfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Eyvjakc+; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Eyvjakc+"
X-Forwarded-Encrypted: i=1; AHgh+RrXUGYU4ME0oWbiEO+R9EluzqjOYFSiyvpYQUBXOAufATQQq7Zki50WiqFOZiK9SSEpo3ic9wk=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783337127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oNZ7vz3mChtJA5HuS+BfwRPDUKdi6rP3C3C7C53mF+c=;
	b=Eyvjakc+MOYbLCgTuPyLGypOPT7iwxnMrkAv6/kO4xSUtMFiBfbdzgo+vbulkBaap1kErn
	9MLfc+UMZoozi3gm+Rb5C/45qjVBomdvbJg9+t0XPQ4bZakNuPuIbVuxgKolChDjLBkYmF
	GaJ6BujPRLPsLJbQevv9xARwMXYS4+A=
X-Gm-Message-State: AOJu0YwFU7AalVEIY0CeFImCOZvAw9z4jfebcxJImUhiZLv849yOH8Le
	+itwOnbCRU7wVERqj/BYOQu8ssnUOmjKTUenUjGzVk2/cUYwWg2rekUyiIAjToa0ZBzvsSu3see
	c0KAEobekCWZCOeJe4xWDO5h6Yszwb/XQ+UlmZsQe
X-Received: by 2002:ac8:5f0c:0:b0:510:f9b:fb5f with SMTP id
 d75a77b69052e-51c4c0dcbf3mr17981821cf.16.1783337098415; Mon, 06 Jul 2026
 04:24:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706083555.302972-1-fuad.tabba@linux.dev> <20260706083555.302972-6-fuad.tabba@linux.dev>
 <90145d58-7ab3-4e88-98cc-21f574cbd673@arm.com>
In-Reply-To: <90145d58-7ab3-4e88-98cc-21f574cbd673@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 6 Jul 2026 12:24:21 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzniSpmF6gBO_M3DjgnOs21xu61sJ+uT8wagiKdnvJwMQ@mail.gmail.com>
X-Gm-Features: AVVi8Cf0ZipCB6_pW_zjjfFQnpwUaaTuj8Emfcnawv91sJAj_fu5ZwM0t9wu7Ok
Message-ID: <CA+EHjTzniSpmF6gBO_M3DjgnOs21xu61sJ+uT8wagiKdnvJwMQ@mail.gmail.com>
Subject: Re: [PATCH kvmtool v1 5/5] arm64: Add --guest-memfd option to back
 guest RAM with guest_memfd
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 12:19, Suzuki K Poulose <suzuki.poulose@arm.com> wrot=
e:
>
> On 06/07/2026 09:35, Fuad Tabba wrote:
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
> >   arm64/include/kvm/kvm-config-arch.h |  5 +++-
> >   arm64/kvm.c                         | 38 +++++++++++++++++++++++-----=
-
> >   include/kvm/kvm.h                   |  1 +
> >   include/kvm/util.h                  |  1 +
> >   kvm.c                               |  1 +
> >   util/util.c                         | 34 ++++++++++++++++++++++++++
> >   6 files changed, 71 insertions(+), 9 deletions(-)
> >
> > diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kv=
m-config-arch.h
> > index c2702d5..d8a8ef7 100644
> > --- a/arm64/include/kvm/kvm-config-arch.h
> > +++ b/arm64/include/kvm/kvm-config-arch.h
> > @@ -20,6 +20,7 @@ struct kvm_config_arch {
> >       bool            no_pvtime;
> >       bool            psci;
> >       bool            protected;
> > +     bool            guest_memfd;
> >   };
> >
> >   int irqchip_parser(const struct option *opt, const char *arg, int uns=
et);
> > @@ -73,6 +74,8 @@ int sve_vl_parser(const struct option *opt, const cha=
r *arg, int unset);
> >       OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,                          =
       \
> >                   "Create guest without VHE support"),                 =
       \
> >       OPT_BOOLEAN('\0', "protected", &(cfg)->protected,                =
       \
> > -                     "Create a protected VM when pKVM is enabled"),
> > +                     "Create a protected VM when pKVM is enabled"),   =
       \
> > +     OPT_BOOLEAN('\0', "guest-memfd", &(cfg)->guest_memfd,            =
       \
> > +                     "Use guest_memfd to back guest RAM"),
> >
> >   #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
> > diff --git a/arm64/kvm.c b/arm64/kvm.c
> > index fb0b98d..b594578 100644
> > --- a/arm64/kvm.c
> > +++ b/arm64/kvm.c
> > @@ -49,9 +49,14 @@ void kvm__init_ram(struct kvm *kvm)
> >       kvm->arch.ram_alloc_size =3D kvm->ram_size;
> >       if (!kvm->cfg.hugetlbfs_path)
> >               kvm->arch.ram_alloc_size +=3D SZ_2M;
> > -     kvm->arch.ram_alloc_start =3D mmap_anon_or_hugetlbfs(kvm,
> > -                                             kvm->cfg.hugetlbfs_path,
> > -                                             kvm->arch.ram_alloc_size)=
;
> > +
> > +     if (kvm->cfg.arch.guest_memfd)
> > +             kvm->arch.ram_alloc_start =3D
> > +                     mmap_guest_memfd(kvm, kvm->arch.ram_alloc_size);
> > +     else
> > +             kvm->arch.ram_alloc_start =3D
> > +                     mmap_anon_or_hugetlbfs(kvm, kvm->cfg.hugetlbfs_pa=
th,
> > +                                            kvm->arch.ram_alloc_size);
> >
> >       if (kvm->arch.ram_alloc_start =3D=3D MAP_FAILED)
> >               die("Failed to map %lld bytes for guest memory (%d)",
> > @@ -60,17 +65,25 @@ void kvm__init_ram(struct kvm *kvm)
> >       kvm->ram_start =3D (void *)ALIGN((unsigned long)kvm->arch.ram_all=
oc_start,
> >                                       SZ_2M);
> >
> > -     madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> > -             MADV_MERGEABLE);
> > +     if (!kvm->cfg.arch.guest_memfd) {
> > +             madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_si=
ze,
> > +                     MADV_MERGEABLE);
> >
> > -     madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> > -             MADV_HUGEPAGE);
> > +             madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_si=
ze,
> > +                     MADV_HUGEPAGE);
> > +     }
> >
> >       phys_start      =3D kvm->cfg.ram_addr;
> >       phys_size       =3D kvm->ram_size;
> >       host_mem        =3D kvm->ram_start;
> >
> > -     err =3D kvm__register_ram(kvm, phys_start, phys_size, host_mem);
> > +     if (kvm->cfg.arch.guest_memfd)
> > +             err =3D kvm__register_ram_guest_memfd(kvm, phys_start,
> > +                                                 phys_size, host_mem,
> > +                                                 kvm->ram_guest_memfd,
> > +                                                 host_mem - kvm->arch.=
ram_alloc_start);
> > +     else
> > +             err =3D kvm__register_ram(kvm, phys_start, phys_size, hos=
t_mem);
> >       if (err)
> >               die("Failed to register %lld bytes of memory at physical =
"
> >                   "address 0x%llx [err %d]", phys_size, phys_start, err=
);
> > @@ -468,6 +481,15 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
> >       if (kvm->cfg.arch.e2h0 && !kvm->cfg.arch.nested_virt)
> >               pr_warning("--e2h0 requires --nested, ignoring");
> >
> > +     if (kvm->cfg.arch.guest_memfd) {
> > +             /* Requires in-place shared/private conversion of guest_m=
emfd. */
> > +             if (kvm->cfg.arch.protected)
> > +                     die("Protected VMs do not yet support guest_memfd=
");
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
> >       u64                     ram_size;       /* Guest memory size, in =
bytes */
> >       void                    *ram_start;
> >       u64                     ram_pagesize;
> > +     int                     ram_guest_memfd; /* guest_memfd backing R=
AM, -1 if none */
> >       struct mutex            mem_banks_lock;
> >       struct list_head        mem_banks;
> >
> > diff --git a/include/kvm/util.h b/include/kvm/util.h
> > index a6dba11..9e23431 100644
> > --- a/include/kvm/util.h
> > +++ b/include/kvm/util.h
> > @@ -148,5 +148,6 @@ static inline int pow2_size(unsigned long x)
> >   struct kvm;
> >   void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 si=
ze);
> >   void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_p=
ath, u64 size);
> > +void *mmap_guest_memfd(struct kvm *kvm, u64 size);
> >
> >   #endif /* KVM__UTIL_H */
> > diff --git a/kvm.c b/kvm.c
> > index 3d05756..a400dd2 100644
> > --- a/kvm.c
> > +++ b/kvm.c
> > @@ -162,6 +162,7 @@ struct kvm *kvm__new(void)
> >       mutex_init(&kvm->mem_banks_lock);
> >       kvm->sys_fd =3D -1;
> >       kvm->vm_fd =3D -1;
> > +     kvm->ram_guest_memfd =3D -1;
> >
> >   #ifdef KVM_BRLOCK_DEBUG
> >       kvm->brlock_sem =3D (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER=
;
> > diff --git a/util/util.c b/util/util.c
> > index 05d49c4..c60fe02 100644
> > --- a/util/util.c
> > +++ b/util/util.c
> > @@ -6,7 +6,9 @@
> >   #include "kvm/util.h"
> >
> >   #include <kvm/kvm.h>
> > +#include <linux/kvm.h>
> >   #include <linux/magic.h>    /* For HUGETLBFS_MAGIC */
> > +#include <sys/ioctl.h>
> >   #include <sys/mman.h>
> >   #include <sys/stat.h>
> >   #include <sys/statfs.h>
> > @@ -169,3 +171,35 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, cons=
t char *hugetlbfs_path, u64 si
> >               return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, =
0);
> >       }
> >   }
> > +
> > +/*
> > + * Map guest RAM backed by a guest_memfd. The file descriptor must sta=
y open
> > + * for the lifetime of the VM: closing it invalidates the memslot bind=
ings.
> > + */
> > +void *mmap_guest_memfd(struct kvm *kvm, u64 size)
> > +{
> > +     u64 flags =3D GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARE=
D;
> > +     struct kvm_create_guest_memfd gmem =3D {
> > +             .size   =3D size,
> > +             .flags  =3D flags,
> > +     };
> > +     void *addr;
> > +     int ret;
> > +
> > +     ret =3D ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_GUEST_MEMF=
D_FLAGS);
> > +     if (ret < 0 || ((u64)ret & flags) !=3D flags)
> > +             die("kernel does not support guest_memfd with mmap");
>
> Minor nit: "VM type doesn't support..", to be precise ?

Done,
/fuad

>
> Suzuki
> IMPORTANT NOTICE: The contents of this email and any attachments are conf=
idential and may also be privileged. If you are not the intended recipient,=
 please notify the sender immediately and do not disclose the contents to a=
ny other person, use it for any purpose, or store or copy the information i=
n any medium. Thank you.
