Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5CA19CCF7
	for <kvmarm@lists.linux.dev>; Tue,  7 Apr 2026 18:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775588213; cv=pass; b=dWZXzQp3fvVS28BX0rgezKEJWxjTRel/dEUV4em4W2qk+N3R/Vf7+JL6mqaFNjYi/sNmFSLoUtOsqnwU3ZvYPkx752hR7Jcp+ak852NIC1diiR3Sucl80hJNDJiF1V+UHxou/A4rneQx34VyXt9oyhfWjequr0DsmE+sVX0ci5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775588213; c=relaxed/simple;
	bh=i5RQMcV396b63nA42SUmQRpwNcFVD/M4pkvCRG+nx/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YtXyl8hgXecVvJxzV6RTK6xDvWYoCf54HEHlxlSHsN9ggAvKmT820AFASAPY7BbAp0PRqRbjITILb2LcLEyR9z5Y5tZ+dBEdmhBUyCk+959Hgzkks2d6uqOHqG6IArysLCqml/JJWisKRfEWduIJhlrMEWHRa/vU98w/2nKh1P4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BPGlDOYs; arc=pass smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BPGlDOYs"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-38dd9f0fdc6so2183441fa.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Apr 2026 11:56:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775588210; cv=none;
        d=google.com; s=arc-20240605;
        b=F3F2l3LZu9AOOPMwaLmK5v01QcWTeVCEHGc5FN8pWz2o912HFxFn1TOSBjBc31VQch
         yqD1NsEbt32qJ/ZY5lu/lH8L8Zeg8cwU7+wzzqE8wmN3BG2MknOxFwIUVc3JrLqpMl9X
         1Ik4sV2raop1LvO2C47iM4aphGbydv/MfedXvtfRf0vH3ghiIWYl0NWQ+aG/0jVfXMl6
         sKxy7YsSq1uT/yf1GIcKWUDHE2nqvFnP8zblCiR8qcY9Y5m1B0rTIGOnvfdUTBfJBNtZ
         YP3Sjj0iElW11y5lafSj9phEbiTzDE0GiCXmAgB6myVlBRf9FWszAUMSRFDjDhEbUKns
         rHGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=li6eJRq571VbkAQY3SCY76KP+ZDhJq6m6xXIOEYY8mE=;
        fh=0dcpBD7MIu2J4aEAwExV4oUaVKRD74WDtsfIuecahYc=;
        b=C47XsuwOVWsBLSfa6q5b7GXV6vTowzfbjiEyCPtCa8fIFhPhM0DQElIUZkSvdO7WSd
         rCUHRCyFr7EYAHrMX54ogVQu6A2fP+zfd86l1KphpLp5N4LUDyZ6Un0put8OIX2Ag7Zv
         HVZM9J8JunUSBML0ah5KKKX59KDFC26gnSMmqT+SqMpQgKwteP6OrTInHNkSqRftIvMS
         eIgUwrL9xHgH5IO5OYVcyN8hFiqSGCQMns0Wm8OJt8z3Ivj9bwFoEk0CraRIOsB9s5uK
         w5i06o3X/1BNqrW5nW87nwXD1NxxlCbw7Rjer6dStB85gZsO8pbpcnoChd+z0NBkNbJc
         mNiQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775588210; x=1776193010; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=li6eJRq571VbkAQY3SCY76KP+ZDhJq6m6xXIOEYY8mE=;
        b=BPGlDOYshKotLYuOlAl3pkXzrB8NXkW6rpYD+vpt44Vy8aHkGYKmUyYgkByjfToOBb
         bNp16WEiJolF3tWnoB8992ftLlZ9po25Jx8896ECHBE1Zc3wniECGLHnPX0UCx7i7cfO
         Wcq4rL60GJ8yCk0IG2HLuLeF0V30fzHiR0QkynhHhShIYk2ttGoN2kS12QYVo9TT/Emz
         FQ1/KnVM2d/XFLa+ff/A86ozR4stSS0YQy8muCVQCNGdQ4IfmNbkgQ3F9tV8l82A9FR8
         Zdma8NcuL32j5tQ4eO4p+WyEK7PJX9KWKE6UO69UMNVRsPKYOUIXbb8bZlskIalOwimT
         MkVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775588210; x=1776193010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=li6eJRq571VbkAQY3SCY76KP+ZDhJq6m6xXIOEYY8mE=;
        b=juJMpHw3ENbKR2dRpsidK9+Y4QNeG3tBM53pjkgkKCYcIYuip1PPY70zWO+MKg9bPp
         8ipF5HBaXsnKIr1Hj4ijP9SjbaO4HAsJjNN3Y1EwK/ymO/ektEpdhJrsu1OIPfh8Ie++
         OBAVesTwd1faJR20v30crlJsH2zQbomGtkc4+vQbWV0tNe8AccplnLXuUZVgIt4uIrlM
         MM4yGzIUm4eQEuUSjA4oHpA4FnU9HgqKtdESt7izz6/lgmElMJ2hGIrfNhq9lp2lzYnh
         IRh2Ks6hwqWQBJ7Mr7/Z2frHHCotePd5VOZDLiMQS1mFNv/nVJmqCaS1nbloQlOBn45Q
         avWw==
X-Forwarded-Encrypted: i=1; AJvYcCWkFuxp4gBVNUmgStnLVgaKapnMKufel//W9QXf2/RcVkYAPNyNIVPL+9P86qqZoRer2lB7O9s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxiYDNULmDsGTzb8F8unlUU65eUxGcPY45/ktKc6KQ+FB8L9ulL
	oTMXK8xs4n/pF6QuFiFh540TJBUquozDHbFPQVDmj0Jz7/vYbEm11fL3F/ClU1oy7EHX1OKlFzh
	9gGWJVx8gdqLF5VgV45EoL5YaTivTUNGWbIUCVKVfOWO21DhgkwHIrQ==
X-Gm-Gg: AeBDieslw7NrBicAVJwdQmZOl2XLsGcufdyI97XgoNQXN/U8AEKoX/S5FJcLprqTW3U
	SFwajlB8ZJehdvjGAOQ1q2Qvc+L8Pca0H/hMK3PUbAzXwgqkieUs2sFfWcgbIwF72Bbt0NVBb5l
	5lMp064RlhOB1hXRtjdjE1elad0rCeJ8G+rU5bp+8A0VAW00isnM9eWtf2/3YKKXTz+KM0XPKuV
	q7W0J5fMpQOCjydBkpVhVyI6y2CFC9ISnT/ybNPErbD0ttiJnC5yPgHXlsh72nyvMXF9xLZZRHB
	aulEwM0PUz+qoj0R952hLfnNo+Yz66R+xOO19t7r
X-Received: by 2002:a05:6512:23a1:b0:5a1:182e:1fdd with SMTP id
 2adb3069b0e04-5a32f69149bmr5992701e87.0.1775588208992; Tue, 07 Apr 2026
 11:56:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316224349.2360482-1-jingzhangos@google.com>
 <20260316224349.2360482-3-jingzhangos@google.com> <20260324150441.GA456067@e124191.cambridge.arm.com>
In-Reply-To: <20260324150441.GA456067@e124191.cambridge.arm.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 7 Apr 2026 11:56:36 -0700
X-Gm-Features: AQROBzCgzrPGp_qS7-15deV5V29ZGuIZ171C--Z3cgkW7LdmL5RkW2sXJjmeSvE
Message-ID: <CAAdAUtgZLm5=i6iLcV+FC_zTzf9sB6uA_s8xJHuskyoDVV1Ciw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/3] lib: arm64: Add bare-metal guest
 execution framework
To: Joey Gouly <joey.gouly@arm.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 8:04=E2=80=AFAM Joey Gouly <joey.gouly@arm.com> wro=
te:
>
> Hi,
>
> Just some preliminary comments.
>
> On Mon, Mar 16, 2026 at 03:43:48PM -0700, Jing Zhang wrote:
> > To test advanced KVM features such as nested virtualization (NV) and
> > GICv4 direct interrupt injection, kvm-unit-tests needs the ability to
> > act as an L1 hypervisor running at EL2 and manage its own L2 guests.
> >
> > Introduce a lightweight guest management library that provides the
> > infrastructure to create, configure, and execute nested guests.
> >
> > This framework includes:
> > - Guest lifecycle management: `guest_create()` and `guest_destroy()`
> >   APIs to allocate guest context and setup Stage-2 identity mappings
> >   for code and stack using the s2mmu library.
> > - Context switching: The `guest_run()` assembly routine handles
> >   saving the host (L1) callee-saved registers and loading the guest
> >   (L2) GPRs and EL1 system registers.
> > - VM-Exit handling: Installs an EL2 trap handler (`guest_hyp_vectors`)
> >   to intercept guest exits and route them to `guest_c_exception_handler=
`
> >   to determine whether to return to the host test logic or resume.
> > - Guest-internal exceptions: Provides `guest_el1_vectors` to catch
> >   Sync, IRQ, FIQ, and SError exceptions occurring entirely within the
> >   guest (EL1) without trapping to the host.
>
> Might be helpful if this patch could be split into 2-3 commits.
>

Sure, will do.

> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arm/Makefile.arm64     |   2 +
> >  lib/arm64/asm/guest.h  | 156 ++++++++++++++++++++++++
> >  lib/arm64/guest.c      | 197 ++++++++++++++++++++++++++++++
> >  lib/arm64/guest_arch.S | 263 +++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 618 insertions(+)
> >  create mode 100644 lib/arm64/asm/guest.h
> >  create mode 100644 lib/arm64/guest.c
> >  create mode 100644 lib/arm64/guest_arch.S
> >
> > diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> > index 5e50f5ba..9026fd71 100644
> > --- a/arm/Makefile.arm64
> > +++ b/arm/Makefile.arm64
> > @@ -41,6 +41,8 @@ cflatobjs +=3D lib/arm64/processor.o
> >  cflatobjs +=3D lib/arm64/spinlock.o
> >  cflatobjs +=3D lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
> >  cflatobjs +=3D lib/arm64/stage2_mmu.o
> > +cflatobjs +=3D lib/arm64/guest.o
> > +cflatobjs +=3D lib/arm64/guest_arch.o
> >
> >  ifeq ($(CONFIG_EFI),y)
> >  cflatobjs +=3D lib/acpi.o
> > diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
> > new file mode 100644
> > index 00000000..1d70873d
> > --- /dev/null
> > +++ b/lib/arm64/asm/guest.h
> > @@ -0,0 +1,156 @@
> > +/*
> > + * Copyright (C) 2026, Google LLC.
> > + * Author: Jing Zhang <jingzhangos@google.com>
> > + *
> > + * SPDX-License-Identifier: LGPL-2.0-or-later
> > + */
> > +#ifndef _ASMARM64_GUEST_H_
> > +#define _ASMARM64_GUEST_H_
> > +
> > +/* Offsets for assembly (Must match struct guest) */
> > +#define GUEST_X_OFFSET                       0
> > +#define GUEST_ELR_OFFSET             248
> > +#define GUEST_SPSR_OFFSET            256
> > +#define GUEST_HCR_OFFSET             264
> > +#define GUEST_VTTBR_OFFSET           272
> > +#define GUEST_SCTLR_OFFSET           280
> > +#define GUEST_VBAR_OFFSET            288
> > +#define GUEST_SP_EL1_OFFSET          296
> > +#define GUEST_ESR_OFFSET             304
> > +#define GUEST_FAR_OFFSET             312
> > +#define GUEST_HPFAR_OFFSET           320
> > +#define GUEST_EXIT_CODE_OFFSET               328
> > +#define GUEST_TPIDR_EL1_OFFSET               336
> > +#define GUEST_ICH_VMCR_EL2_OFFSET    344
>
> Look at lib/arm64/asm-offsets.c for how to generate theses.
>

Thanks. I'll refine this.

> > +
> > +#ifndef __ASSEMBLY__
> > +
> > +#include <libcflat.h>
> > +#include <asm/stage2_mmu.h>
> > +
> > +/* HCR_EL2 Definitions */
> > +#define HCR_VM               (1UL << 0)      /* Virtualization Enable =
*/
> > +#define HCR_FMO              (1UL << 3)      /* Physical FIQ Routing *=
/
> > +#define HCR_IMO              (1UL << 4)      /* Physical IRQ Routing *=
/
> > +#define HCR_AMO              (1UL << 5)      /* Physical SError Interr=
upt Routing */
> > +#define HCR_RW               (1UL << 31)     /* Execution State: AArch=
64 */
> > +#define HCR_DC               (1UL << 12)     /* Default Cacheable */
> > +#define HCR_E2H              (1UL << 34)     /* EL2 Host */
> > +
>
> Should be in lib/arm64/asm/sysreg.h
>

I'll clean up all the register and offset definitions.

> > +#define HCR_GUEST_FLAGS (HCR_VM | HCR_FMO | HCR_IMO | HCR_AMO | HCR_RW=
 | \
> > +                      HCR_DC | HCR_E2H)
> > +
> > +/* ICH_VMCR_EL2 bit definition */
> > +#define ICH_VMCR_PMR_SHIFT   24
> > +#define ICH_VMCR_PMR_MASK    (0xffUL << ICH_VMCR_PMR_SHIFT)
> > +#define ICH_VMCR_ENG0_SHIFT  0
> > +#define ICH_VMCR_ENG0_MASK   (1 << ICH_VMCR_ENG0_SHIFT)
> > +#define ICH_VMCR_ENG1_SHIFT  1
> > +#define ICH_VMCR_ENG1_MASK   (1 << ICH_VMCR_ENG1_SHIFT)
> > +
> > +/* Guest stack size */
> > +#define GUEST_STACK_SIZE             SZ_64K
> > +
> > +/*
> > + * Result from Handler:
> > + * RESUME: Keep guest running (ERET immediately)
> > + * EXIT:   Return to Host C caller
> > + */
> > +enum guest_handler_result {
> > +     GUEST_ACTION_RESUME,
> > +     GUEST_ACTION_EXIT
> > +};
> > +
> > +struct guest;
> > +typedef enum guest_handler_result (*guest_handler_t)(struct guest *gue=
st);
> > +
> > +/* EL1 (Guest-internal) Exception Vector */
> > +enum guest_el1_vector {
> > +     GUEST_EL1_SYNC,
> > +     GUEST_EL1_IRQ,
> > +     GUEST_EL1_FIQ,
> > +     GUEST_EL1_SERROR,
> > +     GUEST_EL1_MAX
> > +};
> > +
>
> There's a similar vector enum in lib/arm64/asm/processor.h, is there a sp=
ecific
> need to have a separate guest_el1 version?
>

Not really. I'll try to reuse those.

> > +/*
> > + * Guest EL1 Exception Frame (pushed to guest stack by asm stub)
> > + * We use a simplified frame: x0-x30, elr, spsr. size =3D 33*8
> > + */
> > +struct guest_el1_regs {
> > +     unsigned long regs[31];
> > +     unsigned long elr;
> > +     unsigned long spsr;
> > +};
>
> What about SP?
>

It is in the guest->sp_el1.

> > +
> > +typedef void (*guest_el1_handler_t)(struct guest_el1_regs *regs, unsig=
ned int esr);
> > +
> > +/* Exceptions from the Guest (Lower EL using AArch64) */
> > +enum guest_vector {
> > +     GUEST_VECTOR_SYNC,
> > +     GUEST_VECTOR_IRQ,
> > +     GUEST_VECTOR_FIQ,
> > +     GUEST_VECTOR_SERROR,
> > +     GUEST_VECTOR_MAX
> > +};
>
> Same comment about vector.
>
> > +
> > +/*
> > + * Guest Context Structure
> > + * This will be pointed to by TPIDR_EL1 while the guest is running.
> > + */
> > +struct guest_context {
> > +     guest_el1_handler_t handlers[GUEST_EL1_MAX];
> > +};
> > +
> > +struct guest {
> > +     /* 0x000: General Purpose Registers */
> > +     unsigned long x[31]; /* x0..x30 */
> > +
> > +     /* 0x0F8: Execution State */
> > +     unsigned long elr_el2;
> > +     unsigned long spsr_el2;
> > +
> > +     /* 0x108: Control Registers */
> > +     unsigned long hcr_el2;
> > +     unsigned long vttbr_el2;
> > +     unsigned long sctlr_el1;
> > +     unsigned long vbar_el1;
> > +     unsigned long sp_el1;
> > +
> > +     /* 0x130: Exit Information */
> > +     unsigned long esr_el2;
> > +     unsigned long far_el2;
> > +     unsigned long hpfar_el2;
> > +     unsigned long exit_code; /* enum guest_vector */
> > +     unsigned long tpidr_el1;
> > +
> > +     /* 0x158: GIC Registers */
> > +     unsigned long ich_vmcr_el2;
> > +
> > +     /* 0x160: Exception Handlers */
> > +     guest_handler_t handlers[GUEST_VECTOR_MAX];
> > +     struct guest_context *guest_context;
> > +
> > +     struct s2_mmu *s2mmu;
> > +};
> > +
> > +/* API */
> > +struct guest *guest_create(int vmid, void (*guest_func)(void), enum s2=
_granule granule);
> > +void guest_destroy(struct guest *guest);
> > +
> > +/* Configuration */
> > +void guest_set_vector(struct guest *guest, void *vector_table);
> > +void guest_set_stack(struct guest *guest, void *stack_top);
> > +void guest_install_handler(struct guest *guest, enum guest_vector v, g=
uest_handler_t handler);
> > +
> > +/* Install handler for exceptions INSIDE EL1 */
> > +void guest_install_el1_handler(struct guest *guest, enum guest_el1_vec=
tor v, guest_el1_handler_t handler);
> > +
> > +unsigned long guest_c_exception_handler(struct guest *guest, unsigned =
long vector_offset);
> > +void guest_el1_c_handler(struct guest_el1_regs *regs, unsigned int vec=
tor);
> > +
> > +/* Core Run Loop */
> > +void guest_run(struct guest *guest);
> > +
> > +#endif /* __ASSEMBLY__ */
> > +#endif /* _ASMARM64_GUEST_H_ */
> > diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
> > new file mode 100644
> > index 00000000..6c256c11
> > --- /dev/null
> > +++ b/lib/arm64/guest.c
> > @@ -0,0 +1,197 @@
> > +/*
> > + * Copyright (C) 2026, Google LLC.
> > + * Author: Jing Zhang <jingzhangos@google.com>
> > + *
> > + * SPDX-License-Identifier: LGPL-2.0-or-later
> > + */
> > +#include <libcflat.h>
> > +#include <asm/guest.h>
> > +#include <asm/io.h>
> > +#include <asm/sysreg.h>
> > +#include <asm/barrier.h>
> > +#include <alloc_page.h>
> > +#include <alloc.h>
> > +
> > +/* Compile-time checks to ensure Assembly macros match C Struct */
> > +_Static_assert(offsetof(struct guest, x) =3D=3D GUEST_X_OFFSET,
> > +            "GUEST_X_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, elr_el2) =3D=3D GUEST_ELR_OFFSET=
,
> > +            "GUEST_ELR_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, spsr_el2) =3D=3D GUEST_SPSR_OFFS=
ET,
> > +            "GUEST_SPSR_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, hcr_el2) =3D=3D GUEST_HCR_OFFSET=
,
> > +            "GUEST_HCR_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, vttbr_el2) =3D=3D GUEST_VTTBR_OF=
FSET,
> > +            "GUEST_VTTBR_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, sctlr_el1) =3D=3D GUEST_SCTLR_OF=
FSET,
> > +            "GUEST_SCTLR_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, vbar_el1) =3D=3D GUEST_VBAR_OFFS=
ET,
> > +            "GUEST_VBAR_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, sp_el1) =3D=3D GUEST_SP_EL1_OFFS=
ET,
> > +            "GUEST_SP_EL1_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, esr_el2) =3D=3D GUEST_ESR_OFFSET=
,
> > +            "GUEST_ESR_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, far_el2) =3D=3D GUEST_FAR_OFFSET=
,
> > +            "GUEST_FAR_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, hpfar_el2) =3D=3D GUEST_HPFAR_OF=
FSET,
> > +            "GUEST_HPFAR_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, exit_code) =3D=3D GUEST_EXIT_COD=
E_OFFSET,
> > +            "GUEST_EXIT_CODE_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, tpidr_el1) =3D=3D GUEST_TPIDR_EL=
1_OFFSET,
> > +             "GUEST_TPIDR_EL1_OFFSET mismatch");
> > +_Static_assert(offsetof(struct guest, ich_vmcr_el2) =3D=3D GUEST_ICH_V=
MCR_EL2_OFFSET,
> > +             "GUEST_ICH_VMCR_EL2_OFFSET mismatch");
> > +
> > +/*
> > + * C-Entry for Exception Handling
> > + * Returns 0 to Resume Guest, 1 to Exit to Host Caller
> > + */
> > +unsigned long guest_c_exception_handler(struct guest *guest, unsigned =
long vector_offset)
> > +{
> > +     enum guest_vector vector =3D (enum guest_vector)guest->exit_code;
> > +
> > +     /* Save Trap Info */
> > +     guest->esr_el2 =3D read_sysreg(esr_el2);
> > +     guest->far_el2 =3D read_sysreg(far_el2);
> > +     guest->hpfar_el2 =3D read_sysreg(hpfar_el2);
> > +
> > +     /* Invoke Handler if registered */
> > +     if (guest->handlers[vector]) {
> > +             if (guest->handlers[vector](guest) =3D=3D GUEST_ACTION_RE=
SUME) {
> > +                     return 0; /* ASM stub will restore and ERET */
> > +             }
> > +     }
> > +
> > +     /* Default: Exit to caller */
> > +     return 1;
> > +}
> > +
> > +/* --- EL1 (Guest-Internal) Vector Handling --- */
> > +
> > +void guest_install_el1_handler(struct guest *guest, enum guest_el1_vec=
tor v, guest_el1_handler_t handler)
> > +{
> > +     if (guest && guest->guest_context && v < GUEST_EL1_MAX)
> > +             guest->guest_context->handlers[v] =3D handler;
> > +}
> > +
> > +void guest_el1_c_handler(struct guest_el1_regs *regs, unsigned int vec=
tor)
> > +{
> > +     struct guest_context *ctx =3D (struct guest_context *)read_sysreg=
(tpidr_el1);
> > +     unsigned int esr =3D read_sysreg(esr_el1);
> > +
> > +     if (ctx && vector < GUEST_EL1_MAX && ctx->handlers[vector]) {
> > +             ctx->handlers[vector](regs, esr);
> > +     } else {
> > +             printf("Guest: Unhandled Exception Vector %d, ESR=3D0x%x\=
n", vector, esr);
> > +             asm volatile("hvc #0xFFFF");
> > +     }
> > +}
> > +
> > +extern void guest_el1_vectors(void);
> > +
> > +static struct guest *__guest_create(struct s2_mmu *s2_ctx, void *entry=
_point)
> > +{
> > +     struct guest *guest =3D calloc(1, sizeof(struct guest));
> > +     struct guest_context *guest_ctx;
> > +     unsigned long guest_ctx_pa;
> > +
> > +     /* Allocate the internal context table */
> > +     guest_ctx =3D (void *)alloc_page();
> > +     memset(guest_ctx, 0, PAGE_SIZE);
> > +     guest->guest_context =3D guest_ctx;
> > +
> > +     guest_ctx_pa =3D virt_to_phys(guest_ctx);
> > +     if (s2_ctx)
> > +             s2mmu_map(s2_ctx, guest_ctx_pa, guest_ctx_pa, PAGE_SIZE, =
S2_MAP_RW);
> > +
> > +     guest->tpidr_el1 =3D guest_ctx_pa;;
> > +
> > +     guest->elr_el2 =3D (unsigned long)entry_point;
> > +     guest->spsr_el2 =3D 0x3C5; /* M=3DEL1h, DAIF=3DMasked */
> > +     guest->hcr_el2 =3D HCR_GUEST_FLAGS;
> > +
> > +     if (s2_ctx) {
> > +             guest->vttbr_el2 =3D virt_to_phys(s2_ctx->pgd);
> > +             guest->vttbr_el2 |=3D ((unsigned long)s2_ctx->vmid << 48)=
;
> > +     }
> > +
> > +     guest->sctlr_el1 =3D read_sysreg(sctlr_el1);
> > +     guest->sctlr_el1 |=3D SCTLR_EL1_C | SCTLR_EL1_I | SCTLR_EL1_M;
> > +
> > +     guest->ich_vmcr_el2 =3D read_sysreg(ich_vmcr_el2);
> > +     guest->ich_vmcr_el2 |=3D (0xFFUL << ICH_VMCR_PMR_SHIFT) | (1UL <<=
 ICH_VMCR_ENG1_SHIFT);
> > +
> > +     guest->vbar_el1 =3D (unsigned long)guest_el1_vectors;
> > +     guest->s2mmu =3D s2_ctx;
> > +
> > +     return guest;
> > +}
> > +
> > +struct guest *guest_create(int vmid, void (*guest_func)(void), enum s2=
_granule granule)
> > +{
> > +     unsigned long guest_pa, code_base, stack_pa;
> > +     unsigned long *stack_page;
> > +     struct guest *guest;
> > +     struct s2_mmu *ctx;
> > +
> > +     ctx =3D s2mmu_init(vmid, granule, true);
> > +     /*
> > +      * Map the Host's code segment Identity Mapped (IPA=3DPA).
> > +      * To be safe, we map a large chunk (e.g., 2MB) around the functi=
on
> > +      * to capture any helper functions the compiler might generate ca=
lls to.
> > +      */
> > +     guest_pa =3D virt_to_phys((void *)guest_func);
> > +     code_base =3D guest_pa & ~(SZ_2M - 1);
> > +     s2mmu_map(ctx, code_base, code_base, SZ_2M, S2_MAP_RW);
> > +
> > +     /*
> > +      * Map Stack
> > +      * Allocate 16 pages (64K) in Host, get its PA, and map it for Gu=
est.
> > +      */
> > +     stack_page =3D alloc_pages(get_order(GUEST_STACK_SIZE >> PAGE_SHI=
FT));
> > +     stack_pa =3D virt_to_phys(stack_page);
> > +     /* Identity Map it (IPA =3D PA) */
> > +     s2mmu_map(ctx, stack_pa, stack_pa, GUEST_STACK_SIZE, S2_MAP_RW);
> > +
> > +     s2mmu_enable(ctx);
> > +
> > +     /* Create Guest */
> > +     /* Entry point is the PA of the function (Identity Mapped) */
> > +     guest =3D __guest_create(ctx, (void *)guest_pa);
> > +
> > +     /*
> > +      * Setup Guest Stack Pointer
> > +      * Must match where we mapped the stack + Offset
> > +      */
> > +     guest_set_stack(guest, (void *)(stack_pa + GUEST_STACK_SIZE));
> > +
> > +     /* Map UART identity mapped, printf() available to guest */
> > +     s2mmu_map(ctx, 0x09000000, 0x09000000, PAGE_SIZE, S2_MAP_DEVICE);
> > +
> > +     return guest;
> > +}
> > +
> > +void guest_destroy(struct guest *guest)
> > +{
> > +     s2mmu_disable(guest->s2mmu);
> > +     s2mmu_destroy(guest->s2mmu);
> > +     if (guest->guest_context)
> > +             free_page(guest->guest_context);
> > +     free(guest);
> > +}
> > +
> > +void guest_set_vector(struct guest *guest, void *vector_table)
> > +{
> > +     guest->vbar_el1 =3D (unsigned long)vector_table;
> > +}
> > +
> > +void guest_set_stack(struct guest *guest, void *stack_top)
> > +{
> > +     guest->sp_el1 =3D (unsigned long)stack_top;
> > +}
> > +
> > +void guest_install_handler(struct guest *guest, enum guest_vector v, g=
uest_handler_t handler)
> > +{
> > +     if (v < GUEST_VECTOR_MAX)
> > +             guest->handlers[v] =3D handler;
> > +}
> > diff --git a/lib/arm64/guest_arch.S b/lib/arm64/guest_arch.S
> > new file mode 100644
> > index 00000000..cb7074d7
> > --- /dev/null
> > +++ b/lib/arm64/guest_arch.S
> > @@ -0,0 +1,263 @@
> > +/*
> > + * Copyright (C) 2026, Google LLC.
> > + * Author: Jing Zhang <jingzhangos@google.com>
> > + *
> > + * SPDX-License-Identifier: LGPL-2.0-or-later
> > + */
> > +#define __ASSEMBLY__
> > +#include <asm/guest.h>
> > +
> > +.global guest_run
> > +guest_run:
> > +     /* x0 =3D struct guest pointer */
> > +
> > +     /* Save Host Callee-Saved Regs */
> > +     stp     x29, x30, [sp, #-16]!
> > +     stp     x27, x28, [sp, #-16]!
> > +     stp     x25, x26, [sp, #-16]!
> > +     stp     x23, x24, [sp, #-16]!
> > +     stp     x21, x22, [sp, #-16]!
> > +     stp     x19, x20, [sp, #-16]!
> > +
> > +     /* Cache Guest Pointer in TPIDR_EL2 */
> > +     msr     tpidr_el2, x0
> > +
> > +     /* Configure ICC_SRE_EL2 to allow EL1 access to SysRegs */
> > +     /* Bit 3 (Enable) =3D 1, Bit 0 (SRE) =3D 1 */
> > +     mrs     x1, icc_sre_el2
> > +     orr     x1, x1, #1
> > +     orr     x1, x1, #(1 << 3)
> > +     msr     icc_sre_el2, x1
> > +     isb
> > +
> > +     /* Enable virtual CPU interface */
> > +     mrs     x1, ich_hcr_el2
> > +     orr     x1, x1, #1
> > +     msr     ich_hcr_el2, x1
> > +
> > +     /* Load Guest System Registers */
> > +     ldr     x1, [x0, #GUEST_ELR_OFFSET]
> > +     msr     elr_el2, x1
> > +     ldr     x1, [x0, #GUEST_SPSR_OFFSET]
> > +     msr     spsr_el2, x1
> > +     ldr     x1, [x0, #GUEST_HCR_OFFSET]
> > +     msr     hcr_el2, x1
> > +     ldr     x1, [x0, #GUEST_VTTBR_OFFSET]
> > +     msr     vttbr_el2, x1
> > +     ldr     x1, [x0, #GUEST_SCTLR_OFFSET]
> > +     msr     S3_5_c1_c0_0, x1
> > +     ldr     x1, [x0, #GUEST_VBAR_OFFSET]
> > +     msr     S3_5_c12_c0_0, x1
>
> Need to add these registers to the sysreg.h file, so don't need the raw e=
ncoding.
>

Sure, will refine it.

> > +     ldr     x1, [x0, #GUEST_SP_EL1_OFFSET]
> > +     msr     sp_el1, x1
> > +     ldr     x1, [x0, #GUEST_TPIDR_EL1_OFFSET]
> > +     msr     tpidr_el1, x1
> > +     ldr     x1, [x0, #GUEST_ICH_VMCR_EL2_OFFSET]
> > +     msr     ich_vmcr_el2, x1
> > +
> > +     /* Load Guest GPRs */
> > +     ldp     x1, x2, [x0, #8]
> > +     ldp     x3, x4, [x0, #24]
> > +     ldp     x5, x6, [x0, #40]
> > +     ldp     x7, x8, [x0, #56]
> > +     ldp     x9, x10, [x0, #72]
> > +     ldp     x11, x12, [x0, #88]
> > +     ldp     x13, x14, [x0, #104]
> > +     ldp     x15, x16, [x0, #120]
> > +     ldp     x17, x18, [x0, #136]
> > +     ldp     x19, x20, [x0, #152]
> > +     ldp     x21, x22, [x0, #168]
> > +     ldp     x23, x24, [x0, #184]
> > +     ldp     x25, x26, [x0, #200]
> > +     ldp     x27, x28, [x0, #216]
> > +     ldp     x29, x30, [x0, #232]
> > +     ldr     x0, [x0, #0]
> > +
> > +     /* Install Trap Handler */
> > +     adrp    x29, guest_hyp_vectors
> > +     add     x29, x29, :lo12:guest_hyp_vectors
> > +     msr     vbar_el2, x29
> > +
> > +     /* Restore x29 from struct (via tpidr_el2) */
> > +     mrs     x29, tpidr_el2
> > +     ldr     x29, [x29, #232]
> > +
> > +     isb
> > +     eret
> > +
> > +     .align 11
> > +guest_hyp_vectors:
> > +     .skip 0x400
> > +
> > +guest_exit_sync:
> > +     stp     x0, x1, [sp, #-16]!
> > +     mrs     x0, tpidr_el2
> > +     mov     x1, #0
> > +     str     x1, [x0, #GUEST_EXIT_CODE_OFFSET]
> > +     b       guest_common_exit
> > +
> > +     .balign 0x80
> > +
> > +guest_exit_irq:
> > +     stp     x0, x1, [sp, #-16]!
> > +     mrs     x0, tpidr_el2
> > +     mov     x1, #1
> > +     str     x1, [x0, #GUEST_EXIT_CODE_OFFSET]
> > +     b       guest_common_exit
> > +
> > +guest_common_exit:
> > +     stp     x2, x3, [x0, #16]
> > +     stp     x4, x5, [x0, #32]
> > +     stp     x6, x7, [x0, #48]
> > +     stp     x8, x9, [x0, #64]
> > +     stp     x10, x11, [x0, #80]
> > +     stp     x12, x13, [x0, #96]
> > +     stp     x14, x15, [x0, #112]
> > +     stp     x16, x17, [x0, #128]
> > +     stp     x18, x19, [x0, #144]
> > +     stp     x20, x21, [x0, #160]
> > +     stp     x22, x23, [x0, #176]
> > +     stp     x24, x25, [x0, #192]
> > +     stp     x26, x27, [x0, #208]
> > +     stp     x28, x29, [x0, #224]
> > +     str     x30, [x0, #240]
> > +
> > +     ldp     x2, x3, [sp], #16
> > +     stp     x2, x3, [x0, #0]
> > +
> > +     mrs     x1, elr_el2
> > +     str     x1, [x0, #GUEST_ELR_OFFSET]
> > +     mrs     x1, spsr_el2
> > +     str     x1, [x0, #GUEST_SPSR_OFFSET]
> > +     mrs     x1, esr_el2
> > +     str     x1, [x0, #GUEST_ESR_OFFSET]
> > +     mrs     x1, far_el2
> > +     str     x1, [x0, #GUEST_FAR_OFFSET]
> > +     mrs     x1, hpfar_el2
> > +     str     x1, [x0, #GUEST_HPFAR_OFFSET]
> > +     mrs     x1, sp_el1
> > +     str     x1, [x0, #GUEST_SP_EL1_OFFSET]
>
> Missing VBAR_EL1?
>

Thanks, will fix it.

> > +     mrs     x1, ich_vmcr_el2
> > +     str     x1, [x0, #GUEST_ICH_VMCR_EL2_OFFSET]
> > +
> > +     /* x29 contains vector offset from entry */
> > +     mov     x1, x29
> > +     bl      guest_c_exception_handler
> > +     cbz     x0, guest_resume_guest
> > +
> > +     /* EXIT */
> > +     /* Restore Host Callee-Saved Regs */
> > +     ldp     x19, x20, [sp], #16
> > +     ldp     x21, x22, [sp], #16
> > +     ldp     x23, x24, [sp], #16
> > +     ldp     x25, x26, [sp], #16
> > +     ldp     x27, x28, [sp], #16
> > +     ldp     x29, x30, [sp], #16
> > +     ret
> > +
> > +     /* RESUME */
> > +guest_resume_guest:
> > +     mrs     x0, tpidr_el2
> > +     ldr     x1, [x0, #GUEST_ELR_OFFSET]
> > +     msr     elr_el2, x1
> > +     ldr     x1, [x0, #GUEST_SPSR_OFFSET]
> > +     msr     spsr_el2, x1
> > +     ldr     x1, [x0, #GUEST_SP_EL1_OFFSET]
> > +     msr     sp_el1, x1
> > +
> > +     ldp     x1, x2, [x0, #8]
> > +     ldp     x3, x4, [x0, #24]
> > +     ldp     x5, x6, [x0, #40]
> > +     ldp     x7, x8, [x0, #56]
> > +     ldp     x9, x10, [x0, #72]
> > +     ldp     x11, x12, [x0, #88]
> > +     ldp     x13, x14, [x0, #104]
> > +     ldp     x15, x16, [x0, #120]
> > +     ldp     x17, x18, [x0, #136]
> > +     ldp     x19, x20, [x0, #152]
> > +     ldp     x21, x22, [x0, #168]
> > +     ldp     x23, x24, [x0, #184]
> > +     ldp     x25, x26, [x0, #200]
> > +     ldp     x27, x28, [x0, #216]
> > +     ldp     x29, x30, [x0, #232]
> > +     ldr     x0, [x0, #0]
> > +     eret
> > +
> > +/* EL1 Vector Table */
> > +.align 11
> > +.global guest_el1_vectors
> > +guest_el1_vectors:
> > +     /* Sync (0x000) */
> > +     .skip 0x200
> > +     /* Sync (0x200) */
> > +     stp     x29, x30, [sp, #-16]!
> > +     mov     x29, #0
> > +     b       guest_el1_common
> > +     .skip 0x80 - 12
> > +     /* IRQ (0x280) */
> > +     stp     x29, x30, [sp, #-16]!
> > +     mov     x29, #1
> > +     b       guest_el1_common
> > +     .skip 0x80 - 12
> > +     /* FIQ (0x300) */
> > +     stp     x29, x30, [sp, #-16]!
> > +     mov     x29, #2
> > +     b       guest_el1_common
> > +     .skip 0x80 - 12
> > +     /* SError (0x380) */
> > +     stp     x29, x30, [sp, #-16]!
> > +     mov     x29, #3
> > +     b       guest_el1_common
> > +     .skip 0x400
> > +
> > +guest_el1_common:
> > +     sub     sp, sp, #264
> > +     stp     x0, x1, [sp, #0]
> > +     stp     x2, x3, [sp, #16]
> > +     stp     x4, x5, [sp, #32]
> > +     stp     x6, x7, [sp, #48]
> > +     stp     x8, x9, [sp, #64]
> > +     stp     x10, x11, [sp, #80]
> > +     stp     x12, x13, [sp, #96]
> > +     stp     x14, x15, [sp, #112]
> > +     stp     x16, x17, [sp, #128]
> > +     stp     x18, x19, [sp, #144]
> > +     stp     x20, x21, [sp, #160]
> > +     stp     x22, x23, [sp, #176]
> > +     stp     x24, x25, [sp, #192]
> > +     stp     x26, x27, [sp, #208]
> > +     stp     x28, x30, [sp, #224]
> > +
> > +     mrs     x0, elr_el1
> > +     str     x0, [sp, #248]
> > +     mrs     x0, spsr_el1
> > +     str     x0, [sp, #256]
> > +
> > +     mov     x0, sp
> > +     mov     x1, x29
> > +     bl      guest_el1_c_handler
> > +
> > +     ldr     x0, [sp, #248]
> > +     msr     elr_el1, x0
> > +     ldr     x0, [sp, #256]
> > +     msr     spsr_el1, x0
> > +
> > +     ldp     x0, x1, [sp, #0]
> > +     ldp     x2, x3, [sp, #16]
> > +     ldp     x4, x5, [sp, #32]
> > +     ldp     x6, x7, [sp, #48]
> > +     ldp     x8, x9, [sp, #64]
> > +     ldp     x10, x11, [sp, #80]
> > +     ldp     x12, x13, [sp, #96]
> > +     ldp     x14, x15, [sp, #112]
> > +     ldp     x16, x17, [sp, #128]
> > +     ldp     x18, x19, [sp, #144]
> > +     ldp     x20, x21, [sp, #160]
> > +     ldp     x22, x23, [sp, #176]
> > +     ldp     x24, x25, [sp, #192]
> > +     ldp     x26, x27, [sp, #208]
> > +     ldp     x28, x30, [sp, #224]
> > +
> > +     add     sp, sp, #264
> > +     ldp     x29, x30, [sp], #16
> > +     eret
> > --
>
> Thanks,
> Joey

Thanks,
Jing
