Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A892135C5
	for <kvmarm@lists.linux.dev>; Tue,  7 Apr 2026 18:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775585806; cv=pass; b=MH/1d1/m43vTP+pvbEaaqhuoDaEBG3pZKeeM/X0msQ8DxbpYPt0hxPQZc2gzI3Cf7zsQ6m1IpzG6X8gol6UAkRhXnfnzaDwFWSU0m2/IZlet3qy9q51jyd+9KkrXxZo+3pj2K4rLGt/EiGD6i5RTZCLJvT5bz6H+7w4jz/sFy/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775585806; c=relaxed/simple;
	bh=raCu0wjTeer4dJZmimSOtFlNMVFoEYDmn9xZsXA83cI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ItocOVIb+k2//+1i6Ft5ZyeUxxuId6hDNP6gkhcwpQo/RlgSlPhy+HzqyCZ08ADtOZz6aLsjfTbIJPMuK2Zd1dafMOEgQPTBadLhFsb28UA/2pcHBRdzzAzxm1P0e67VEzga29nFaqiAta6H40atDrUw+/weZZDxBW8j/4XVU20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z7QfmFed; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z7QfmFed"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a2bd236adbso124374e87.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Apr 2026 11:16:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775585802; cv=none;
        d=google.com; s=arc-20240605;
        b=WDQMz8iUnhWG/PxyyvPHX8ASrZkdmPgRO+gwESUVAwXTrIRgkDoCBupCkJd0cAAYKD
         9Xe/MAV4kjHCfXXPCEApQv5bUI2l/JerLkiOHiGxiOSJEgMN/VygyyegSxl9nUOAzmmi
         WZ6qsAkoe/+OC96WV1qeVHFV+cgrVE439gMoSWedU0pMg3BfNkkQtiUiI/yQNDi0ttaW
         EZZtT9LiPiL226qcRk9YXLkjJ1vtkKCqxz08njpgkUh4IOiFih1FOlJvysbp2iSMEnD3
         irDdka5Om6UGEVBSaqSFpAYFyd4ExnPyzEwFAmLDJB34y4KpHtiWQzBR6fwRt+vYcAxF
         SAHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xlFK/wD4F+eyo8wTBsNxCQrZtWztOHdIjmIZcpsn4cY=;
        fh=rIB+Fjr8S5N4QE8H7yvtOyYLLNAjJ+sgJJEyuLP+37E=;
        b=glzcqhL+WslYsNJM5QWUyL50EapdZSVMeYget2uidGu7witVOwtoBIrprj0uZHIO6W
         gl8lete8w0D2YRvFHX70utUXxoepIqBhCC6Mng8C6Z2VlASdRkIDaarT737tyJCngYSx
         9sr0QjhrEQHO91PKWZ4V12AGAu76hArm2vMPiPOjRME38aiktHOEXIxESI34mn47pD8U
         CAPudksWdccYqyTu/gd5Za1TN2AVedAtRkXAJDL+/4OBumgwYv7iyqojH/EnmhUR7TIt
         J2V9a82Lktfzuz1tPY2xYy4VR1jBPsAmYRf06tNvt2TaU00ZyLxDA91y8rvq4OhFSMZp
         plmg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775585802; x=1776190602; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xlFK/wD4F+eyo8wTBsNxCQrZtWztOHdIjmIZcpsn4cY=;
        b=Z7QfmFedZn/vBiX3KpBBRaYmfygXW5W8AWrXXrNjzcdTSkIZ4NGHMEBRaa3hPENuKt
         Hr4cwkCKGofuVwObbzUz3Jws5vIXbaG8Xm5M7sPRS3xb7DQUMaJzPaogoouN2rA/G+WO
         wnr1olIJYPEL7hRr1HbrD5naorXblFo3usp1WA0is6PtSTxZ+cQmKggpHYIlSLUT+UEP
         et8R/08W8MSEo0OUDCK7RaTdkjVttDHoWfBdRoWlFck8sES/fZRIXn8wPs2W3EsWKDBa
         uQ1v2RsbpBs6YqdlcTLdMBWnIsxeMaIzlQWBLHTn9K6zpbRJeyOvbFK+hsFEATS7VwEQ
         jGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775585802; x=1776190602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xlFK/wD4F+eyo8wTBsNxCQrZtWztOHdIjmIZcpsn4cY=;
        b=W4ebpqaLli8RGJRcV5m1TUS/oy9nxZCtgXSQu2wiywCCWvDdspyK33ORx3ng8pNeAz
         56+z7rUnyvqfmfV9yS8h5CSyI0/vim3VqR71wcOUdxO+kfxQDOzp/wXLtWWIgqX0psdt
         J/HgeFdDM8GcPkpsBLpLOqIfyzjyg/WfrsUxNRdy0wWbnuWVNCbcYP3nmjg9QjtCm5rn
         lSoo2sR4ImgeilA1LoUwZZWj9Jl800Q06uxGOvw5guoyYAQJwceC2Vqm1qfFTlGUUgSi
         PoMVFU3oOnB9XWITEA7Nx5m1lziajFf40bDQSzH1FkHksuQ1MSQLbyv7QPkQhBiq0+z3
         XkVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLz8wwEDc50o4bFsHLwhl7hoy3Wzl9YJBc/CcLySYutXtnroe2sLZY6UZIGlaO+6ge/OGaNxU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0zwWsx/o7Rrfswsn5au/9vFAQ7NE8ubTNQEfDeku1EJ6I7lH1
	hUXZG7uxGgN7T/FmOaePs5L1s1kadaI8QfeBYHn/pImWhOULlTxCa/Qu/ktnmK+XHpJ6411qVdq
	QhrRDtxuvdlxMdJlBYgNZHrZE4XoSWpWmoHawB6VZ
X-Gm-Gg: AeBDietI96EiXXA9ocovtQ3hXVs5afVR22+gD8K0VeK0bNYpmDd1U1m4KnxVPIoCU5N
	KGo+6dwFJaQCV8cCEweOMd86DzXNgxIFw6puzSeY3DVL3Hl2RhP0pB4A9vvJEpqwgJbJgcmuVRv
	Qk3tVsGncMZ0VIrC3BbjNXxPaxKJobIYghn8C7EasoEXEsmv81peA7sFFa+Akc39aF22ajcalC+
	El7uYJ0Ph7i19iheXEa14S5n3B++mKbeAou3zhJc+Yfwd8grii1Ll0G+Ow/t7FGmFnAtPKmcB9i
	kFRYMenWfnamdZpoSPE4jvgexYKiIy9PdgM5q51r
X-Received: by 2002:a05:6512:3d9e:b0:5a1:742d:277f with SMTP id
 2adb3069b0e04-5a2c8d7b2bbmr7047755e87.11.1775585801708; Tue, 07 Apr 2026
 11:16:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316224349.2360482-1-jingzhangos@google.com>
 <20260316224349.2360482-2-jingzhangos@google.com> <ddnv43zjv2hqmlqhkh6p3z5dqx75h4ylhww4hz3s5cq7y7nhjy@z3q7rca4vvui>
In-Reply-To: <ddnv43zjv2hqmlqhkh6p3z5dqx75h4ylhww4hz3s5cq7y7nhjy@z3q7rca4vvui>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 7 Apr 2026 11:16:30 -0700
X-Gm-Features: AQROBzDPRhtXt9KF4z73Z8XwLpuaq5wTH6xkGLmcItTJkIH8O1sHVTn0zeBCOiI
Message-ID: <CAAdAUtgBbN1McGo2667vuhdxJt2qkogV=yg2N=TbxNWb1itSTA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/3] lib: arm64: Add stage2 page table
 management library
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 8:12=E2=80=AFAM Wei-Lin Chang <weilin.chang@arm.com=
> wrote:
>
> Hi,
>
> On Mon, Mar 16, 2026 at 03:43:47PM -0700, Jing Zhang wrote:
> > Tests running at EL2 (hypervisor level) often require the ability to
> > manage Stage 2 translation tables to control Guest Physical Address (IP=
A)
> > to Host Physical Address (PA) translation.
> >
> > Add a generic Stage 2 MMU library that provides software management of
> > ARM64 Stage 2 translation tables.
> >
> > The library features include:
> > - Support for 4K, 16K, and 64K translation granules.
> > - Dynamic page table allocation using the allocator.
> > - Support for 2M block mappings where applicable.
> > - APIs for mapping, unmapping, enabling, and disabling the Stage 2 MMU.
> > - Basic fault info reporting (ESR, FAR, HPFAR).
> >
> > This infrastructure is necessary for upcoming virtualization and
> > hypervisor-mode tests.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arm/Makefile.arm64         |   1 +
> >  lib/arm64/asm/stage2_mmu.h |  74 +++++++
> >  lib/arm64/stage2_mmu.c     | 402 +++++++++++++++++++++++++++++++++++++
> >  3 files changed, 477 insertions(+)
> >  create mode 100644 lib/arm64/asm/stage2_mmu.h
> >  create mode 100644 lib/arm64/stage2_mmu.c
> >
> > diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> > index a40c830d..5e50f5ba 100644
> > --- a/arm/Makefile.arm64
> > +++ b/arm/Makefile.arm64
> > @@ -40,6 +40,7 @@ cflatobjs +=3D lib/arm64/stack.o
> >  cflatobjs +=3D lib/arm64/processor.o
> >  cflatobjs +=3D lib/arm64/spinlock.o
> >  cflatobjs +=3D lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
> > +cflatobjs +=3D lib/arm64/stage2_mmu.o
> >
> >  ifeq ($(CONFIG_EFI),y)
> >  cflatobjs +=3D lib/acpi.o
> > diff --git a/lib/arm64/asm/stage2_mmu.h b/lib/arm64/asm/stage2_mmu.h
> > new file mode 100644
> > index 00000000..c9e931a8
> > --- /dev/null
> > +++ b/lib/arm64/asm/stage2_mmu.h
> > @@ -0,0 +1,74 @@
> > +/*
> > + * Copyright (C) 2026, Google LLC.
> > + * Author: Jing Zhang <jingzhangos@google.com>
> > + *
> > + * SPDX-License-Identifier: LGPL-2.0-or-later
> > + */
> > +#ifndef _ASMARM64_STAGE2_MMU_H_
> > +#define _ASMARM64_STAGE2_MMU_H_
> > +
> > +#include <libcflat.h>
> > +#include <asm/page.h>
> > +#include <asm/pgtable.h>
> > +
> > +#define pte_is_table(pte)    (pte_val(pte) & PTE_TABLE_BIT)
> > +
> > +/* Stage-2 Memory Attributes (MemAttr[3:0]) */
> > +#define S2_MEMATTR_NORMAL    (0xFUL << 2) /* Normal Memory, Outer/Inne=
r Write-Back */
> > +#define S2_MEMATTR_DEVICE    (0x0UL << 2) /* Device-nGnRnE */
> > +
> > +#define ESR_ELx_EC_SHIFT     (26)
> > +#define ESR_ELx_EC_HVC64     UL(0x16)
> > +#define ESR_ELx_EC_DABT_LOW  UL(0x24)
>
> nit:
> This looks out of place to me, could this be better if moved to guest.h?
>

I'll refine this.

> > +
> > +/* Stage-2 Access Permissions (S2AP[1:0]) */
> > +#define S2AP_NONE    (0UL << 6)
> > +#define S2AP_RO              (1UL << 6) /* Read-only */
> > +#define S2AP_WO              (2UL << 6) /* Write-only */
> > +#define S2AP_RW              (3UL << 6) /* Read-Write */
> > +
> > +/* Flags for mapping */
> > +#define S2_MAP_RW    (S2AP_RW | S2_MEMATTR_NORMAL | PTE_AF | PTE_SHARE=
D)
> > +#define S2_MAP_DEVICE        (S2AP_RW | S2_MEMATTR_DEVICE | PTE_AF)
> > +
> > +enum s2_granule {
> > +     S2_PAGE_4K,
> > +     S2_PAGE_16K,
> > +     S2_PAGE_64K,
> > +};
> > +
> > +/* Main Stage-2 MMU Structure */
> > +struct s2_mmu {
> > +     pgd_t *pgd;
> > +     int vmid;
> > +
> > +     /* Configuration */
> > +     enum s2_granule granule;
> > +     bool allow_block_mappings;
> > +
> > +     /* Internal helpers calculated from granule & VA_BITS */
> > +     unsigned int page_shift;
> > +     unsigned int level_shift;
> > +     int root_level; /* 0, 1, or 2 */
> > +     unsigned long page_size;
> > +     unsigned long block_size;
> > +};
> > +
> > +/* API */
> > +/* Initialize an s2_mmu struct with specific settings */
> > +struct s2_mmu *s2mmu_init(int vmid, enum s2_granule granule, bool allo=
w_block_mappings);
> > +
> > +/* Management */
> > +void s2mmu_destroy(struct s2_mmu *mmu);
> > +void s2mmu_map(struct s2_mmu *mmu, unsigned long ipa, unsigned long pa=
,
> > +            unsigned long size, unsigned long flags);
> > +void s2mmu_unmap(struct s2_mmu *mmu, unsigned long ipa, unsigned long =
size);
> > +
> > +/* Activation */
> > +void s2mmu_enable(struct s2_mmu *mmu);
> > +void s2mmu_disable(struct s2_mmu *mmu);
> > +
> > +/* Debug */
> > +void s2mmu_print_fault_info(void);
> > +
> > +#endif /* _ASMARM64_STAGE2_MMU_H_ */
> > diff --git a/lib/arm64/stage2_mmu.c b/lib/arm64/stage2_mmu.c
> > new file mode 100644
> > index 00000000..bfe87eac
> > --- /dev/null
> > +++ b/lib/arm64/stage2_mmu.c
> > @@ -0,0 +1,402 @@
> > +/*
> > + * Copyright (C) 2026, Google LLC.
> > + * Author: Jing Zhang <jingzhangos@google.com>
> > + *
> > + * SPDX-License-Identifier: LGPL-2.0-or-later
> > + */
> > +#include <libcflat.h>
> > +#include <alloc.h>
> > +#include <asm/stage2_mmu.h>
> > +#include <asm/sysreg.h>
> > +#include <asm/io.h>
> > +#include <asm/barrier.h>
> > +#include <alloc_page.h>
> > +
> > +/* VTCR_EL2 Definitions */
> > +#define VTCR_SH0_INNER               (3UL << 12)
> > +#define VTCR_ORGN0_WBWA              (1UL << 10)
> > +#define VTCR_IRGN0_WBWA              (1UL << 8)
> > +
> > +/* TG0 Encodings */
> > +#define VTCR_TG0_4K          (0UL << 14)
> > +#define VTCR_TG0_64K         (1UL << 14)
> > +#define VTCR_TG0_16K         (2UL << 14)
> > +
> > +/* Physical Address Size (PS) - Derive from VA_BITS for simplicity or =
max */
> > +#if VA_BITS > 40
> > +#define VTCR_PS_VAL          (5UL << 16) /* 48-bit PA */
> > +#else
> > +#define VTCR_PS_VAL          (2UL << 16) /* 40-bit PA */
> > +#endif
> > +
> > +struct s2_mmu *s2mmu_init(int vmid, enum s2_granule granule, bool allo=
w_block_mappings)
> > +{
> > +     struct s2_mmu *mmu =3D calloc(1, sizeof(struct s2_mmu));
> > +     int order =3D 0;
> > +
> > +     mmu->vmid =3D vmid;
> > +     mmu->granule =3D granule;
> > +     mmu->allow_block_mappings =3D allow_block_mappings;
> > +
> > +     /* Configure shifts based on granule */
> > +     switch (granule) {
> > +     case S2_PAGE_4K:
> > +             mmu->page_shift =3D 12;
> > +             mmu->level_shift =3D 9;
> > +             /*
> > +              * Determine Root Level for 4K:
> > +              * VA_BITS > 39 (e.g. 48) -> Start L0
> > +              * VA_BITS <=3D 39 (e.g. 32, 36) -> Start L1
> > +              */
> > +             mmu->root_level =3D (VA_BITS > 39) ? 0 : 1;
> > +             break;
> > +     case S2_PAGE_16K:
> > +             mmu->page_shift =3D 14;
> > +             mmu->level_shift =3D 11;
> > +             /*
> > +              * 16K: L1 covers 47 bits. L0 not valid for 16K
> > +              * Start L1 for 47 bits. Start L2 for 36 bits.
> > +              */
> > +             mmu->root_level =3D (VA_BITS > 36) ? 1 : 2;
> > +             break;
> > +     case S2_PAGE_64K:
> > +             mmu->page_shift =3D 16;
> > +             mmu->level_shift =3D 13;
> > +             /* 64K: L1 covers 52 bits. L2 covers 42 bits. */
> > +             mmu->root_level =3D (VA_BITS > 42) ? 1 : 2;
> > +             break;
> > +     }
> > +
> > +     mmu->page_size =3D 1UL << mmu->page_shift;
> > +     mmu->block_size =3D 1UL << (mmu->page_shift + mmu->level_shift);
> > +
> > +     /* Alloc PGD. Use order for allocation size */
> > +     if (mmu->page_size > PAGE_SIZE) {
> > +             order =3D __builtin_ctz(mmu->page_size / PAGE_SIZE);
> > +     }
> > +     mmu->pgd =3D (pgd_t *)alloc_pages(order);
> > +     if (mmu->pgd) {
> > +             memset(mmu->pgd, 0, mmu->page_size);
> > +     } else {
> > +             free(mmu);
> > +             return NULL;
> > +     }
> > +
> > +     return mmu;
> > +}
> > +
> > +static unsigned long s2mmu_get_addr_mask(struct s2_mmu *mmu)
> > +{
> > +     switch (mmu->granule) {
> > +     case S2_PAGE_16K:
> > +             return GENMASK_ULL(47, 14);
> > +     case S2_PAGE_64K:
> > +             return GENMASK_ULL(47, 16);
> > +     default:
> > +             return GENMASK_ULL(47, 12); /* 4K */
> > +     }
> > +}
> > +
> > +static void s2mmu_free_tables(struct s2_mmu *mmu, pte_t *table, int le=
vel)
> > +{
> > +     unsigned long entries =3D 1UL << mmu->level_shift;
> > +     unsigned long mask =3D s2mmu_get_addr_mask(mmu);
> > +     unsigned long i;
> > +
> > +     /*
> > +      * Recurse if not leaf level
> > +      * Level 3 is always leaf page. Levels 0-2 can be Table or Block.
> > +      */
> > +     if (level < 3) {
> > +             for (i =3D 0; i < entries; i++) {
> > +                     pte_t entry =3D table[i];
> > +                     if ((pte_valid(entry) && pte_is_table(entry))) {
> > +                             pte_t *next =3D (pte_t *)phys_to_virt(pte=
_val(entry) & mask);
> > +                             s2mmu_free_tables(mmu, next, level + 1);
> > +                     }
> > +             }
> > +     }
> > +
> > +     free_pages(table);
> > +}
> > +
> > +void s2mmu_destroy(struct s2_mmu *mmu)
> > +{
> > +     if (mmu->pgd)
> > +             s2mmu_free_tables(mmu, (pte_t *)mmu->pgd, mmu->root_level=
);
> > +     free(mmu);
> > +}
> > +
> > +void s2mmu_enable(struct s2_mmu *mmu)
> > +{
> > +     unsigned long vtcr =3D VTCR_PS_VAL | VTCR_SH0_INNER |
> > +                          VTCR_ORGN0_WBWA | VTCR_IRGN0_WBWA;
> > +     unsigned long t0sz =3D 64 - VA_BITS;
> > +     unsigned long vttbr;
> > +
> > +     switch (mmu->granule) {
> > +     case S2_PAGE_4K:
> > +             vtcr |=3D VTCR_TG0_4K;
> > +             /* SL0 Encodings for 4K: 0=3DL2, 1=3DL1, 2=3DL0 */
> > +             if (mmu->root_level =3D=3D 0)
> > +                     vtcr |=3D (2UL << 6); /* Start L0 */
> > +             else if (mmu->root_level =3D=3D 1)
> > +                     vtcr |=3D (1UL << 6); /* Start L1 */
> > +             else
> > +                     vtcr |=3D (0UL << 6); /* Start L2 */
> > +             break;
> > +     case S2_PAGE_16K:
> > +             vtcr |=3D VTCR_TG0_16K;
> > +             /* SL0 Encodings for 16K: 0=3DL3(Res), 1=3DL2, 2=3DL1, 3=
=3DL0(Res) */
> > +             if (mmu->root_level =3D=3D 1)
> > +                     vtcr |=3D (2UL << 6); /* Start L1 */
> > +             else
> > +                     vtcr |=3D (1UL << 6); /* Start L2 */
> > +             break;
> > +     case S2_PAGE_64K:
> > +             vtcr |=3D VTCR_TG0_64K;
> > +             /* SL0 Encodings for 64K: 0=3DL3(Res), 1=3DL2, 2=3DL1, 3=
=3DL0(Res) */
> > +             if (mmu->root_level =3D=3D 1)
> > +                     vtcr |=3D (2UL << 6); /* Start L1 */
> > +             else
> > +                     vtcr |=3D (1UL << 6); /* Start L2 */
> > +             break;
> > +     }
>
> The pattern (xUL << 6) is repeated many times, perhaps turn it into a
> macro, then the comments behind it can be omitted as well.
>

I'll clean this up.

> > +
> > +     vtcr |=3D t0sz;
> > +
> > +     write_sysreg(vtcr, vtcr_el2);
> > +     isb();
> > +
> > +     /* Setup VTTBR */
> > +     vttbr =3D virt_to_phys(mmu->pgd);
> > +     vttbr |=3D ((unsigned long)mmu->vmid << 48);
> > +     write_sysreg(vttbr, vttbr_el2);
> > +     isb();
> > +
> > +     asm volatile("tlbi vmalls12e1is");
> > +     dsb(ish);
> > +     isb();
>
> I don't think you need the previous isb's other that this last one, the
> effects of change vtcr_el2 and vttbr_el2 need not to be observed
> immediately.
>

You're right. I'll clean this up.

> > +}
> > +
> > +void s2mmu_disable(struct s2_mmu *mmu)
> > +{
> > +     write_sysreg(0, vttbr_el2);
> > +     isb();
> > +}
>
> I see you have HCR_DC further down, but writing 0s to vttbr_el2 does not =
mean
> s2 translation gets disabled.
>
> Thanks,
> Wei-Lin Chang

I'll move HCR_EL2 handling into s2mmu library to make s2mmu_disable
clearly disalbe stage2 MMU.

>
> > +
> > +static pte_t *get_pte(struct s2_mmu *mmu, pte_t *table, unsigned long =
idx, bool alloc)
> > +{
> > +     unsigned long mask =3D s2mmu_get_addr_mask(mmu);
> > +     pte_t entry =3D table[idx];
> > +     pte_t *next_table;
> > +     int order =3D 0;
> > +
> > +     if (pte_valid(entry)) {
> > +             if (pte_is_table(entry))
> > +                     return (pte_t *)phys_to_virt(pte_val(entry) & mas=
k);
> > +             /* Block Entry */
> > +             return NULL;
> > +     }
> > +
> > +     if (!alloc)
> > +             return NULL;
> > +
> > +     /* Allocate table memory covering the Stage-2 Granule size */
> > +     if (mmu->page_size > PAGE_SIZE)
> > +             order =3D __builtin_ctz(mmu->page_size / PAGE_SIZE);
> > +
> > +     next_table =3D (pte_t *)alloc_pages(order);
> > +     if (next_table)
> > +             memset(next_table, 0, mmu->page_size);
> > +
> > +     pte_val(entry) =3D virt_to_phys(next_table) | PTE_TABLE_BIT | PTE=
_VALID;
> > +     WRITE_ONCE(table[idx], entry);
> > +
> > +     return next_table;
> > +}
> > +
> > +void s2mmu_map(struct s2_mmu *mmu, unsigned long ipa, unsigned long pa=
,
> > +            unsigned long size, unsigned long flags)
> > +{
> > +     unsigned long level_mask, level_shift, level_size, level;
> > +     unsigned long start_ipa, end_ipa, idx;
> > +     pte_t entry, *table, *next_table;
> > +     bool is_block_level;
> > +
> > +     start_ipa =3D ipa;
> > +     end_ipa =3D ipa + size;
> > +     level_mask =3D (1UL << mmu->level_shift) - 1;
> > +
> > +     while (start_ipa < end_ipa) {
> > +             table =3D (pte_t *)mmu->pgd;
> > +
> > +             /* Walk from Root to Leaf */
> > +             for (level =3D mmu->root_level; level < 3; level++) {
> > +                     level_shift =3D mmu->page_shift + (3 - level) * m=
mu->level_shift;
> > +                     idx =3D (start_ipa >> level_shift) & level_mask;
> > +                     level_size =3D 1UL << level_shift;
> > +
> > +                     /*
> > +                      * Check for Block Mapping
> > +                      * Valid Block Levels:
> > +                      * 4K:  L1 (1G), L2 (2MB)
> > +                      * 16K: L2 (32MB)
> > +                      * 64K: L2 (512MB)
> > +                      */
> > +                     is_block_level =3D (level =3D=3D 2) ||
> > +                             (mmu->granule =3D=3D S2_PAGE_4K && level =
=3D=3D 1);
> > +
> > +                     if (mmu->allow_block_mappings && is_block_level) =
{
> > +                             if ((start_ipa & (level_size - 1)) =3D=3D=
 0 &&
> > +                                 (pa & (level_size - 1)) =3D=3D 0 &&
> > +                                 (start_ipa + level_size) <=3D end_ipa=
) {
> > +                                     /* Map Block */
> > +                                     pte_val(entry) =3D (pa & ~(level_=
size - 1)) |
> > +                                                      flags | PTE_VALI=
D;
> > +                                     WRITE_ONCE(table[idx], entry);
> > +                                     start_ipa +=3D level_size;
> > +                                     pa +=3D level_size;
> > +                                     goto next_chunk; /* Continue oute=
r loop */
> > +                             }
> > +                     }
> > +
> > +                     /* Move to next level */
> > +                     next_table =3D get_pte(mmu, table, idx, true);
> > +                     if (!next_table) {
> > +                             printf("Error allocating or existing bloc=
k conflict.\n");
> > +                             return;
> > +                     }
> > +                     table =3D next_table;
> > +             }
> > +
> > +             /* Leaf Level (Level 3 PTE) */
> > +             if (level =3D=3D 3) {
> > +                     idx =3D (start_ipa >> mmu->page_shift) & level_ma=
sk;
> > +                     pte_val(entry) =3D (pa & ~(mmu->page_size - 1)) |=
 flags | PTE_TYPE_PAGE;
> > +                     WRITE_ONCE(table[idx], entry);
> > +                     start_ipa +=3D mmu->page_size;
> > +                     pa +=3D mmu->page_size;
> > +             }
> > +
> > +next_chunk:
> > +             continue;
> > +     }
> > +
> > +     asm volatile("tlbi vmalls12e1is");
> > +     dsb(ish);
> > +     isb();
> > +}
> > +
> > +/*
> > + * Recursive helper to unmap a range within a specific table.
> > + * Returns true if the table at this level is now completely empty
> > + * and should be freed by the caller.
> > + */
> > +static bool s2mmu_unmap_level(struct s2_mmu *mmu, pte_t *table,
> > +                           unsigned long current_ipa, int level,
> > +                           unsigned long start_ipa, unsigned long end_=
ipa,
> > +                           unsigned long mask)
> > +{
> > +     unsigned long level_size, entry_ipa, entry_end;
> > +     bool child_empty, table_empty =3D true;
> > +     pte_t entry, *next_table;
> > +     unsigned int level_shift;
> > +     unsigned long i;
> > +
> > +     /* Calculate shift and size for this level */
> > +     if (level =3D=3D 3) {
> > +             level_shift =3D mmu->page_shift;
> > +     } else {
> > +             level_shift =3D mmu->page_shift + (3 - level) * mmu->leve=
l_shift;
> > +     }
> > +     level_size =3D 1UL << level_shift;
> > +
> > +     /* Iterate over all entries in this table */
> > +     for (i =3D 0; i < (1UL << mmu->level_shift); i++) {
> > +             entry =3D table[i];
> > +             entry_ipa =3D current_ipa + (i * level_size);
> > +             entry_end =3D entry_ipa + level_size;
> > +
> > +             /* Skip entries completely outside our target range */
> > +             if (entry_end <=3D start_ipa || entry_ipa >=3D end_ipa) {
> > +                     if (pte_valid(entry))
> > +                             table_empty =3D false;
> > +                     continue;
> > +             }
> > +
> > +             /*
> > +              * If the entry is fully covered by the unmap range,
> > +              * we can clear it (leaf) or recurse and free (table).
> > +              */
> > +             if (entry_ipa >=3D start_ipa && entry_end <=3D end_ipa) {
> > +                     if (pte_valid(entry)) {
> > +                             if (pte_is_table(entry) && level < 3) {
> > +                                     /* Recurse to free children first=
 */
> > +                                     next_table =3D (pte_t *)phys_to_v=
irt(pte_val(entry) & mask);
> > +                                     s2mmu_free_tables(mmu, next_table=
, level + 1);
> > +                             }
> > +                             /* Invalidate the entry */
> > +                             WRITE_ONCE(table[i], __pte(0));
> > +                     }
> > +                     continue;
> > +             }
> > +
> > +             /*
> > +              * Partial overlap: This must be a table (split required)=
.
> > +              * If it's a Block, we can't split easily in this context
> > +              * without complex logic, so we generally skip or fail.
> > +              * Assuming standard breakdown: recurse into the table.
> > +              */
> > +             if (pte_valid(entry) && pte_is_table(entry) && level < 3)=
 {
> > +                     next_table =3D (pte_t *)phys_to_virt(pte_val(entr=
y) & mask);
> > +                     child_empty =3D s2mmu_unmap_level(mmu, next_table=
, entry_ipa, level + 1,
> > +                                                     start_ipa, end_ip=
a, mask);
> > +
> > +                     if (child_empty) {
> > +                             free_pages(next_table);
> > +                             WRITE_ONCE(table[i], __pte(0));
> > +                     } else {
> > +                             table_empty =3D false;
> > +                     }
> > +             } else if (pte_valid(entry)) {
> > +                     /*
> > +                      * Overlap on a leaf/block entry that extends
> > +                      * beyond the unmap range. We cannot simply clear=
 it.
> > +                      */
> > +                     table_empty =3D false;
> > +             }
> > +     }
> > +
> > +     return table_empty;
> > +}
> > +
> > +void s2mmu_unmap(struct s2_mmu *mmu, unsigned long ipa, unsigned long =
size)
> > +{
> > +     unsigned long end_ipa =3D ipa + size;
> > +     unsigned long mask =3D s2mmu_get_addr_mask(mmu);
> > +
> > +     if (!mmu->pgd)
> > +             return;
> > +
> > +     /*
> > +      * Start recursion from the root level.
> > +      * We rarely free the PGD itself unless destroying the MMU,
> > +      * so we ignore the return value here.
> > +      */
> > +     s2mmu_unmap_level(mmu, (pte_t *)mmu->pgd, 0, mmu->root_level,
> > +                       ipa, end_ipa, mask);
> > +
> > +     /* Ensure TLB invalidation occurs after page table updates */
> > +     asm volatile("tlbi vmalls12e1is");
> > +     dsb(ish);
> > +     isb();
> > +}
> > +
> > +void s2mmu_print_fault_info(void)
> > +{
> > +     unsigned long esr =3D read_sysreg(esr_el2);
> > +     unsigned long far =3D read_sysreg(far_el2);
> > +     unsigned long hpfar =3D read_sysreg(hpfar_el2);
> > +     printf("Stage-2 Fault Info: ESR=3D0x%lx FAR=3D0x%lx HPFAR=3D0x%lx=
\n", esr, far, hpfar);
> > +}
> > --
> > 2.53.0.851.ga537e3e6e9-goog
> >

Thanks,
Jing
