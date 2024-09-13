Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6380ED502
	for <kvmarm@lists.linux.dev>; Fri, 13 Sep 2024 22:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726267314; cv=none; b=VzhdgEcVQSS4PWZl+I5Z3Fu0WMzijf764CEL4EuYbuSUU6Ks/oWPqFP6aqT1XcNQyNpeYtCUjNUaR5z++3YD90nPMCXefISIpFm0niCUXkHTMsBfpEVTy65vh96h9cg/kl0BRtbhN5jxnmz0jGgMP37QBPmcuQ7eAuks1WXQMHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726267314; c=relaxed/simple;
	bh=icrItZvHpFuET3+CJhIilIA7XOmNI4pwD00NBgnwCBk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HqB89iDt6KwxnqGaMo/Y/qWap7NC6o1lOPiLNuX0IPZkaOsOtjn33Yt8xuj9fchMIOKJQEDBorsdXNfXI1Rg9MABjzDIRSX2ITNk98waaZVpyk3rVNlFlUhaTS4W2Bkeuz4FM+AzBoAyLDt764Tiam/K5SfuTRB+H4TmCSvqC4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rl49Szno; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rl49Szno"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a90349aa7e5so275944766b.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Sep 2024 15:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726267311; x=1726872111; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtXOc95I+x4HHrv/uM3TaVJscG84UiL/FTjzf5cP9lg=;
        b=rl49SznoJ22ZdUfCTo3VAgR2E2bQboR+KNXnCYcukKL+ciLwsTs1YBMX4zS4mU41YS
         KIgEABFdGRo4KA7b4SJHMnutEJ83GTxDcaihHCMttQTqPaFmvTu6GXFxdW663B2pegG+
         nKexRQ78DKVZsGEVjLWTXR83fAiOeX52+/MzCLvlwI7bohKGmF/ZfZWvfPEmMQy7ADKZ
         uMLab4WGkWhzYkCxlqRDG6hWvqlyziTVdebFysazMYnVq5YC8j9DTa6BgbcD70C2uwcO
         OqkvtXRpJ/JgBJmyVFG6tNin3q7X8vz91thloR9aZUUwt83SWLePDs70csJy1aIez8ya
         Tf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726267311; x=1726872111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtXOc95I+x4HHrv/uM3TaVJscG84UiL/FTjzf5cP9lg=;
        b=eexpprJ0825cMxM3ug1R8zUqxYPFU8WZXTT5syUDoXSD4SMeJ08hnrjU5oq5LZaHUv
         3CEN6F/TZrSFZaHU1QpTcvfGTxbeFNI20sOqi7rTkbp4TUDQbner2Tnr3hammchL7wUx
         WS84BD4EhieJr9hMm5YjvN3tkINv4NV8YlJTXZMpwFd7X7Y9of1qtM/0p4Z8+0sUX4aR
         Z27YoZXJAB+5m2gpHKffPMJqclZUfevuFRtdLu7VS/Foy7fWqUremRmmfkyjjK558Nrb
         ZLEl3X94RNPgO9jQ5iS9tTzlg9hswA804zSTj88uXrwEU6sZx0f58KP+7Sqnii7E3SrP
         mgSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsIFhwIUlM0dN9mbpL/7hafOfgXvJrBswquwXvHil1i4rUoa0Fr3WlWweHtFN327DwjBmv6ig=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLiGHAwbON+32R3YLJqH5MKOzL8YQsP5bEhiZZ+Ra8taW1du6B
	G7rfNGoIykP7r52uIZ53aSUrPFRQqSvKrAL2FE0WbK+VOHtkvlTFx/TUP0cLRZg5vBe9HlfIut8
	fqV5nVhP7mf3/gZ1lBt+1Tm8bd/pecEO7bJk=
X-Google-Smtp-Source: AGHT+IEa9o6+4F9ecXEPCE9xVtutXb4eyOyLgX+ck4F98FYJYIKeRJ9wFivoEdQm/0xma88gFu4dGiIwH/JM3LxZ+Nc=
X-Received: by 2002:a17:907:e29f:b0:a8a:3ece:d073 with SMTP id
 a640c23a62f3a-a90293fb566mr699784166b.10.1726267310213; Fri, 13 Sep 2024
 15:41:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com> <20240911093029.3279154-7-vdonnefort@google.com>
In-Reply-To: <20240911093029.3279154-7-vdonnefort@google.com>
From: John Stultz <jstultz@google.com>
Date: Fri, 13 Sep 2024 15:41:38 -0700
Message-ID: <CANDhNCr8ptL+JbCTFwtkRx+=yLscqrTQ=P0dmu3rGStuZiBeuw@mail.gmail.com>
Subject: Re: [PATCH 06/13] KVM: arm64: Add clock support in the nVHE hyp
To: Vincent Donnefort <vdonnefort@google.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 2:31=E2=80=AFAM 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:
>
> By default, the arm64 host kernel is using the arch timer as a source
> for sched_clock. Conveniently, EL2 has access to that same counter,
> allowing to generate clock values that are synchronized.
>
> The clock needs nonetheless to be setup with the same slope values as
> the kernel. Introducing at the same time trace_clock() which is expected
> to be later configured by the hypervisor tracing.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kv=
m_hyp.h
> index c838309e4ec4..355bae0056f0 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -144,5 +144,4 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
>  extern unsigned long kvm_nvhe_sym(__icache_flags);
>  extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
>  extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
> -
>  #endif /* __ARM64_KVM_HYP_H__ */
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp=
/include/nvhe/clock.h
> new file mode 100644
> index 000000000000..2bd05b3b89f9
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ARM64_KVM_HYP_NVHE_CLOCK_H
> +#define __ARM64_KVM_HYP_NVHE_CLOCK_H
> +#include <linux/types.h>
> +
> +#include <asm/kvm_hyp.h>
> +
> +#ifdef CONFIG_TRACING
> +void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc=
);
> +u64 trace_clock(void);
> +#else
> +static inline void
> +trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
> +static inline u64 trace_clock(void) { return 0; }
> +#endif
> +#endif
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/M=
akefile
> index b43426a493df..323e992089bd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -28,6 +28,7 @@ hyp-obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch=
.o tlb.o hyp-init.o host.o
>  hyp-obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../=
entry.o \
>          ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
>  hyp-obj-$(CONFIG_LIST_HARDENED) +=3D list_debug.o
> +hyp-obj-$(CONFIG_TRACING) +=3D clock.o
>  hyp-obj-y +=3D $(lib-objs)
>
>  ##
> diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/cl=
ock.c
> new file mode 100644
> index 000000000000..0d1f74bc2e11
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/clock.c
> @@ -0,0 +1,49 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2024 Google LLC
> + * Author: Vincent Donnefort <vdonnefort@google.com>
> + */
> +
> +#include <nvhe/clock.h>
> +
> +#include <asm/arch_timer.h>
> +#include <asm/div64.h>
> +
> +static struct clock_data {
> +       struct {
> +               u32 mult;
> +               u32 shift;
> +               u64 epoch_ns;
> +               u64 epoch_cyc;
> +       } data[2];
> +       u64 cur;
> +} trace_clock_data;
> +
> +/* Does not guarantee no reader on the modified bank. */
> +void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc=
)
> +{
> +       struct clock_data *clock =3D &trace_clock_data;
> +       u64 bank =3D clock->cur ^ 1;
> +
> +       clock->data[bank].mult          =3D mult;
> +       clock->data[bank].shift         =3D shift;
> +       clock->data[bank].epoch_ns      =3D epoch_ns;
> +       clock->data[bank].epoch_cyc     =3D epoch_cyc;
> +
> +       smp_store_release(&clock->cur, bank);
> +}

Can't see from the context in this patch how it's called, but with
timekeeping there can be multiple updaters (settimeofday, timer tick,
etc).
So would it be smart to have some serialization here to avoid you
don't get parallel updates here?

> +
> +/* Using host provided data. Do not use for anything else than debugging=
. */
> +u64 trace_clock(void)
> +{
> +       struct clock_data *clock =3D &trace_clock_data;
> +       u64 bank =3D smp_load_acquire(&clock->cur);
> +       u64 cyc, ns;
> +
> +       cyc =3D __arch_counter_get_cntpct() - clock->data[bank].epoch_cyc=
;
> +
> +       ns =3D cyc * clock->data[bank].mult;
> +       ns >>=3D clock->data[bank].shift;
> +
> +       return (u64)ns + clock->data[bank].epoch_ns;
> +}

You might want some overflow protection on the mult?  See the
max_cycles value we use in timekeeping_cycles_to_ns()

-john
