Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E82C6AC0
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 06:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="0CO6lfNa"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6d266bfcd10so21648b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 22:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702533901; x=1703138701; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvVjokEhJRkgiYQ+o9OaV0HA0xI9C7Xt69a6c2d+FcQ=;
        b=0CO6lfNa485us7C2gE7ze8KtE9nqlCHimbvCANJ/DKd+NXy2yHDLrrzgFGnWxsNEaO
         pkq0obW1Qv9h01zeWCNtv0oFn+s9MN5C5T27oamldYB8aFoA8LfaZj44LlZHMyNQ+Ksf
         cWI8Rmml/clle8/agAH7I13pFoTGRqNc/nXBe1ME9GJpiUdl7Ox1MLOocr1t0yPQaklI
         qCQxx6lOS2m6NsjFCkRfTo21zSoZgT2zxvpxsmqgtmsLHcN4RXoqgV6BbJs54tIzfMrP
         8KWGqmVVh5RAocbD3P24ne3GTHQtNv4dEUojXFWXajjf03VpzaCL+EtDdUSLixKHfGwD
         owUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702533901; x=1703138701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dvVjokEhJRkgiYQ+o9OaV0HA0xI9C7Xt69a6c2d+FcQ=;
        b=Nd1XsDRGqbY4bR1tWRlMNz1OcRBGWoRAo/y/003TDZvkbrRpqPgmGzWrgKWyawcvLo
         LwBMDHwXDWhLcJXGiAcU42bal/VRrlVkgb8oKvFtzcrqZ8bEl2GEnPsbFu7a5Ik/SNJF
         BlE27kTaTha7PXTbqmCv+uub1AaDUt+aos/QDl4svAkRUIyh0IXpnNoLnE08qitCsTZB
         c6qY+IIkBSpEBG6WT52MNRVrZWHGJyNOAHC8Zl16Ab6LiqkJ5vkdRh1HnoNHYkx+SiaT
         OyFQYNGUOJVBaW54XPrCNSam85xy4q4dY9NB7MRR8YVmg7hpy7WF3dvJfWPZSzy7Twyz
         mS+g==
X-Gm-Message-State: AOJu0Yy51mnNx0SDk9oWRRkFVc+os/LFvATxUlBUYjMZxSKDKsksZbjx
	TWojH5DmMXN90ZGcO7qiGCSHLeaYhyPOzz7YCMkpYw==
X-Google-Smtp-Source: AGHT+IHIasKoIhsfkj7Yu+FMUSkaxjPll3cuawBTpXD75vrutVj6NpINC37M3K8JiCCZ1y7ffegWrPb57ZwkbEZ9v2I=
X-Received: by 2002:a17:90a:e395:b0:286:bfed:6f55 with SMTP id
 b21-20020a17090ae39500b00286bfed6f55mr4390822pjz.38.1702533901140; Wed, 13
 Dec 2023 22:05:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com> <20230916003118.2540661-20-seanjc@google.com>
In-Reply-To: <20230916003118.2540661-20-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 11:34:49 +0530
Message-ID: <CAAhSdy1bzQ2mxOew0iw-OuLWxzOhk3LtO+908TYw2gw+5yN3RA@mail.gmail.com>
Subject: Re: [PATCH 19/26] KVM: Standardize include paths across all architectures
To: Sean Christopherson <seanjc@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>, 
	Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 16, 2023 at 6:01=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Standardize KVM's include paths across all architectures by declaring
> the KVM-specific includes in the common Makefile.kvm.  Having common KVM
> "own" the included paths reduces the temptation to unnecessarily add
> virt/kvm to arch include paths, and conversely if allowing arch code to
> grab headers from virt/kvm becomes desirable, virt/kvm can be added to
> all architecture's include path with a single line update.
>
> Having the common KVM makefile append to ccflags also provides a
> convenient location to append other things, e.g. KVM-specific #defines.
>
> Note, this changes the behavior of s390 and PPC, as s390 and PPC
> previously overwrote ccflags-y instead of adding on.  There is no evidenc=
e
> that overwriting ccflags-y was necessary or even deliberate, as both s390
> and PPC switched to the overwrite behavior without so much as a passing
> mention when EXTRA_CFLAGS was replaced with ccflags-y (commit c73028a0288=
7
> ("s390: change to new flag variable") and commit 4108d9ba9091
> ("powerpc/Makefiles: Change to new flag variables")).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/arm64/kvm/Makefile   | 2 --
>  arch/mips/kvm/Makefile    | 2 --
>  arch/powerpc/kvm/Makefile | 2 --
>  arch/riscv/kvm/Makefile   | 2 --
>  arch/s390/kvm/Makefile    | 2 --
>  arch/x86/kvm/Makefile     | 1 -
>  virt/kvm/Makefile.kvm     | 2 ++
>  7 files changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index c0c050e53157..3996489baeef 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -3,8 +3,6 @@
>  # Makefile for Kernel-based Virtual Machine module
>  #
>
> -ccflags-y +=3D -I $(srctree)/$(src)
> -
>  include $(srctree)/virt/kvm/Makefile.kvm
>
>  obj-$(CONFIG_KVM) +=3D kvm.o
> diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
> index 96a7cd21b140..d198e1addea7 100644
> --- a/arch/mips/kvm/Makefile
> +++ b/arch/mips/kvm/Makefile
> @@ -4,8 +4,6 @@
>
>  include $(srctree)/virt/kvm/Makefile.kvm
>
> -ccflags-y +=3D -Iarch/mips/kvm
> -
>  kvm-$(CONFIG_CPU_HAS_MSA) +=3D msa.o
>
>  kvm-y +=3D    mips.o emulate.o entry.o \
> diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
> index 08a0e53d58c7..d6c6678ddf65 100644
> --- a/arch/powerpc/kvm/Makefile
> +++ b/arch/powerpc/kvm/Makefile
> @@ -3,8 +3,6 @@
>  # Makefile for Kernel-based Virtual Machine module
>  #
>
> -ccflags-y :=3D -Iarch/powerpc/kvm
> -
>  include $(srctree)/virt/kvm/Makefile.kvm
>
>  common-objs-y +=3D powerpc.o emulate_loadstore.o
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 4c2067fc59fc..ff7d5f67e229 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -3,8 +3,6 @@
>  # Makefile for RISC-V KVM support
>  #
>
> -ccflags-y +=3D -I $(srctree)/$(src)
> -
>  include $(srctree)/virt/kvm/Makefile.kvm
>
>  obj-$(CONFIG_KVM) +=3D kvm.o
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index f17249ab2a72..f8153189e003 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -5,8 +5,6 @@
>
>  include $(srctree)/virt/kvm/Makefile.kvm
>
> -ccflags-y :=3D -Iarch/s390/kvm
> -
>  kvm-y +=3D kvm-s390.o intercept.o interrupt.o priv.o sigp.o
>  kvm-y +=3D diag.o gaccess.o guestdbg.o vsie.o pv.o
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 80e3fe184d17..d13f1a7b7b3d 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -1,6 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
>
> -ccflags-y +=3D -I $(srctree)/arch/x86/kvm
>  ccflags-$(CONFIG_KVM_WERROR) +=3D -Werror
>
>  ifeq ($(CONFIG_FRAME_POINTER),y)
> diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
> index 29373b59d89a..e85079ad245d 100644
> --- a/virt/kvm/Makefile.kvm
> +++ b/virt/kvm/Makefile.kvm
> @@ -3,6 +3,8 @@
>  # Makefile for Kernel-based Virtual Machine module
>  #
>
> +ccflags-y +=3D -I$(srctree)/$(src)
> +
>  KVM ?=3D ../../../virt/kvm
>
>  kvm-y :=3D $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
> --
> 2.42.0.459.ge4e396fd5e-goog
>
