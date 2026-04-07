Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B9318AE3
	for <kvmarm@lists.linux.dev>; Tue,  7 Apr 2026 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775585839; cv=pass; b=DzaIthng5eD01vRroa/wdpOKBA22TLBDapUNzAx4Wjck6f01p81dgTHPc0G68qlxGJQvsIdTcxAylqoR4DsmrfjQW4ItEZf9Ckj0vU1UOkeN+Dtg0rfBxbLrG5Ju8kkDxG4rBu0n2LVlf6ZNFqkIrY7MMoO+bxG1mKqmLsse+Lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775585839; c=relaxed/simple;
	bh=2Bwix/zSYySrc0kX3jTfLMril1Sl9tnjFwAF2XKAmeo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=efIImVhwPNWC6WC0j6P87Q90Ux0J82YgypZZIDWmcq8MzvnmmasTp6Bej59wluMOnIPllzLTZgsarzGFnM2x7/LVxNyY83/i9AjsYV7FkJAKGiWV70B7m2h8G3YDfTCo4+jGJ5mkbJmCSsooOT6i090xSJdWj3FTX3Uzlss2LJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jORmClQ2; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jORmClQ2"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a2a70bb69eso5755606e87.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Apr 2026 11:17:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775585836; cv=none;
        d=google.com; s=arc-20240605;
        b=OBPUMHhHvr4Awm87SqaMTDKH62fogpoblnRAO7KhjQ+qj9iV020upibhLjzzF9KSzi
         nvGyxZckXuQlIWr1J1YhSPb0pD6YAaXtPxQzHemuSpS4c9kdcdf7Ireh1vSozGUNlCR9
         eCg8mNRbLRUscQd37T1Y7Rzq08sNdRhz0meAN3ZTsuliawmkKtTEbg+1vwOV9PrVDrVK
         bLynvhRhOTnjraXeRgQTttmT8ter9tvAkyo20kkoMGvq0o4xOG3GwwscKqebyZV339dK
         MGUOM+Frm29d4sD0Wm3c2fsFGEP1PjSesh4KLPaz7uyCA2Tv6IGLHCetGxvx1cjv1WmO
         ZT9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mt4g02G5AbOpgUgPWuwj2Ob36owO6ize2P391N5zN/M=;
        fh=Z7tIw/fsvyYBLq35xCFm2lRcuILCrPrstocFeNZIG4s=;
        b=fjL6vx68+QkPm1+yaF/V8X+niErbcIWZ3h1XcM1Qbq1bU8HCNdfV9D93R/ehAbpXk2
         ovXUac/7tmk1zIzH81PVOp4FWENlxbEAM+0ggVfeSou0Z30Jc6YNg6SFhqIbbXbBQtb0
         iN0p9i7Hpl+D3MEG9MQveQo3ACAAXZvR01eBzac7MgkjVpZXb8A3JLHuU37IhNql4Ram
         Kv199uutKSuyAdpooYi1M19AMW9m+0+BoKGRSJNdzA3MvJwYDa5EFrK+rPhaknWMKoQq
         LQ1xyRCYb9/QdQ1KdPJTRxY9u842mX09CiaWAHUmRUUgMfozAVEnYckvE1FSBGF2kh2T
         F7vA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775585836; x=1776190636; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mt4g02G5AbOpgUgPWuwj2Ob36owO6ize2P391N5zN/M=;
        b=jORmClQ2CTM7ePS0SUqSiyC7lOUzzts0xeCETvy0pKpHB9tszbyzE42FuG8m761j7Y
         cWH6nkxoxbUWbllnECx3TrYvDXtxUyiBLobJPrpCAcjb3n1ouNUsRYeg8dyHvKNnLbRX
         anvt1f2RITc3sdzQ61oXQNyX6QJ1l9UU23V0ARD1qJ4bdggsiaFgUTvPXMx7TFiG1ILx
         9cu5UIHeJnt01wYQVwi8Z1ELFcM7pXPBma7sQnkbcEyDiJPw7kpI5uhKQgJ3PR9T3P+d
         xIUVsKbGoVn84oEIimM2LHCF4JQIc3iJ1FH0t7P6fDfALbGqn5xiMbR5L/3UvYQRFL5a
         WGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775585836; x=1776190636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mt4g02G5AbOpgUgPWuwj2Ob36owO6ize2P391N5zN/M=;
        b=nanXSybEv3p+2XWDOvtHiFt0isSAG+W/HzdfpAF2cxRSE0noueE3qSr5LAivh065TW
         hPoE5Y95fzl1G1A9K8yrRmrF0mBJc6uNUYQ99awGoxGxCepxQOgQFyUORjqm5jZzWAy1
         lv2s0m/cgJzMysklmeyr33233Sgadz/0OI9Hf4q37InxqgBsDXq5jcGBJSE6LAzXKeEE
         yekTx2XWT2U1pSbhUjcsvYmCrZJP947L8/2duRyi3U0aNdFqwIdNE447Ll6Run6jo9g9
         txxVKQFb8873dK9B1L4/yErCxdXAnCK64dLmh0I5QoMUnl7wlJSvqJljzVjjbCq+cUmy
         BYTg==
X-Forwarded-Encrypted: i=1; AJvYcCU/dxEBK70sBvaoKIHKryguz7bg7UY/AZ6r3r/FRiYEh/93DrpG3juDYC+ew0tI4NtFhv66Ou8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDSeJVxuWZOJ+YzhObGaWQBTW/E4tro1jW8ANiaEOCWMfuOZII
	dEOiQzkEeRvi8Bk5cyWIxmiLAoxPxieB1jJJNINIa0iCxi2bkO5LnNiEvU/0ZFpS6N0Jymvm01e
	WXKLugt2kawuCJPnDzzZq2SZMMiYztGKrNToJ3DlO
X-Gm-Gg: AeBDievRmk9/eanqxV9XBySVTT7UH8HDYJ+qZEW8w/qSdvRK9M8p01/Qti8k1i2cY58
	GUGzqUST7NWTA0jfnGPKG0vf7yL0LiQhZ3EpxUNOMV2Pcx+/2eJs6GJtP43wjCfeCEiiQpRkX6Z
	60kRgJBJ05OowEnlAqSVO9GYG4EMYDAvCu+eh7zO05wa9a8121+bLOH54fpPSqvZG01MGpYFAG9
	lpv25CGoPpHALeosPuiDbmceI+KKuglxabsolhH62m/WF4w0Dbgb0EBcb/y+svQFg1UAQJidYU5
	ia5n9DUWYAYCai0wGSUBS743C4kuJESbxgWVsFoa
X-Received: by 2002:ac2:4c4e:0:b0:5a2:b58e:e3d6 with SMTP id
 2adb3069b0e04-5a337580637mr5275968e87.25.1775585835705; Tue, 07 Apr 2026
 11:17:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316224349.2360482-1-jingzhangos@google.com>
 <20260316224349.2360482-3-jingzhangos@google.com> <86wlza6fog.wl-maz@kernel.org>
In-Reply-To: <86wlza6fog.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 7 Apr 2026 11:17:04 -0700
X-Gm-Features: AQROBzDWsswtw1Rj_NegdrANYiqOmmNN9TBoPQpPwwIZCvHJYinhIoSTY4-KYF8
Message-ID: <CAAdAUth2QJfZ+jtWFKWWiVeaK0AyodJXvig6zwz+5Yr6OhHvDQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/3] lib: arm64: Add bare-metal guest
 execution framework
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 17, 2026 at 1:09=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 16 Mar 2026 22:43:48 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
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
> Don't hardcode offsets. Generate them.
>

I'll fix that.

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
>
> Please consider importing the kernel's sysreg definition, or generate
> them from an official source (the architecture JSON file, for
> example).
>

Sure, I'll do that.

> > +
> > +#define HCR_GUEST_FLAGS (HCR_VM | HCR_FMO | HCR_IMO | HCR_AMO | HCR_RW=
 | \
> > +                      HCR_DC | HCR_E2H)
>
> Just to set expectations: HCR_EL2.DC is not supported by KVM, and
> likely never will. I'm hopeful that this bit (and a few others) will
> eventually be deprecated because it serves no purpose. If you need a
> 1:1 S1 mapping, create it using (surprise!) page tables.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Got it. I'll make adjustments accordingly.

Thanks,
Jing
