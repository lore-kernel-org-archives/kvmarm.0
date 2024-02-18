Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A50D538A
	for <kvmarm@lists.linux.dev>; Sun, 18 Feb 2024 06:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708238476; cv=none; b=NgLjoESRIG8ZTNJvC1IcofASgMyRSRmZPZc59vvFMcWx5jNMpI9WvOeHH3obWZEBGV3IalFsA561I9+795WaCS7fsuBwGTu/zksS0hjZh43omUe6IClYjvy4OufzCnsi4nxLL6e4c1dXbzmYrzyIhpNvbG4QpnIHNmSCEm4c3+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708238476; c=relaxed/simple;
	bh=iuQbiFx2hJLfWb+6L78zmyCOPRaRIT6gS+4sPUW3K4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=efMKckdG/nwfhPr1zMhwdH1j9eujlW8ha+5sjWSj+ZungxMVyNYMk0WRGME6YtKYmc9oz8NEaYTIGY8CsE4RIBDPAubH2O3qXzIlsUzAU4AV8jgn2kClZaOFuY/L2HdX2hng4ThjwaNZ0R/HUvQMDb1VXBeolW8wmdj2JGi5V5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jkjSGrEA; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jkjSGrEA"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d220e39907so21786031fa.1
        for <kvmarm@lists.linux.dev>; Sat, 17 Feb 2024 22:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708238473; x=1708843273; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0Y6u+5ShCMCnWeHjQjEcItSyrNAyQ4PzYVN7xsknZY=;
        b=jkjSGrEAJNybCPUoxjR9i/TB+RXX2NvXxtNQECinygtaSxutJDBouXAu4kjSBBWQm9
         W43kPnfhwK1frVeYX1/czwBahzOYL7F+bcRbB8gM12g+LyUeEfkZIrlxxP5EKRSFSKEs
         3Vd8P8j+FMen20/oRW0z7gd5FxL6TIX0p0ZQ4axhMaefveSFe0rdz4F3eRN86aPW4x4U
         GpnUGapqRD1UX26xbUe8TZ2GsewlblQTH16gqaN2fxHVTQ7En0LY/QzKiFpBkyUIf+KV
         mqQfmELkbcCwk01KKFnLzs55JwZKn2PFCIWinqEzKfzYdS1CMoxAzq62vF4opsoKLdle
         nZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708238473; x=1708843273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q0Y6u+5ShCMCnWeHjQjEcItSyrNAyQ4PzYVN7xsknZY=;
        b=dp7l9KiTUkXzn4oY0kZa25ArHuvqGX3wkHY5lnj87u+e8XS/rmU/lmaSBnsYiPe89a
         9jU9yE85j5fgU5Mp5GzYlMJxyZ3M7Ld3U8+Xc4AqjFAJCAXVJBAOwdi+sccaKUls61co
         x7p9JqV42PuUZAnWndPrHbVjtCevUhUutOCSK/DFBkU/XHkW2eBMohXaLrO9ahXQyVf3
         /GrpbErr5RroqOlesPLYsdmpDyAoBqfSOUdnCnjaUOcPWQfPk1m3JKmsrgzssQmVFz/j
         Msd1NrSxZhilh4XbiAYNjFlD3v6XLSr+tMBW8794IQB875Gk6z3gQx2QIUcPv0SAVge6
         pv8g==
X-Forwarded-Encrypted: i=1; AJvYcCVrL+BP1u/NWUg1Itc3ICIxs4ksMhUvLZ/OARTqFavsLzXpHYlZU1cmmL8CCxk0KkH+Wveyr+yeow4/6/nACLksxcC039r3
X-Gm-Message-State: AOJu0YymV79G9UnIVSyQblmUvSaXQot0rdxTSOsG6PTQteSMIuTx1qv/
	0n6c+QIrgoLP17m7tNpZQRYJHrkPxI1hJo3/JqcEBglLlg6AIvx/SvKjNU6x09ecE2mAiO8gK7B
	/GHtgqq3M6lutwFkC2gtXmPQSxDQ=
X-Google-Smtp-Source: AGHT+IEU/ZiwgqWrDWfItsbjFQF1nhRZH5qrkBorAITC5xFGNJCVzU/oI+JZS45+PPkqBNqvb8/D/bZalu0eAbcSmoY=
X-Received: by 2002:a2e:8684:0:b0:2d2:3913:5c4 with SMTP id
 l4-20020a2e8684000000b002d2391305c4mr54562lji.37.1708238472941; Sat, 17 Feb
 2024 22:41:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1705916069.git.haibo1.xu@intel.com> <CAAhSdy2wFzk0h5MiM5y9Fij0HyWake=7vNuV1MExUxkEtMWShw@mail.gmail.com>
In-Reply-To: <CAAhSdy2wFzk0h5MiM5y9Fij0HyWake=7vNuV1MExUxkEtMWShw@mail.gmail.com>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Sun, 18 Feb 2024 14:41:00 +0800
Message-ID: <CAJve8okkfvdRtvh8onQYL7_bmv9ntrViP54u805fQMq3apWFcQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] RISCV: Add kvm Sstc timer selftests
To: Anup Patel <anup@brainfault.org>
Cc: Haibo Xu <haibo1.xu@intel.com>, ajones@ventanamicro.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atishp@atishpatra.org>, 
	Guo Ren <guoren@kernel.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, wchen <waylingii@gmail.com>, 
	Greentime Hu <greentime.hu@sifive.com>, Jisheng Zhang <jszhang@kernel.org>, 
	Samuel Holland <samuel@sholland.org>, Minda Chen <minda.chen@starfivetech.com>, 
	Sean Christopherson <seanjc@google.com>, Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, 
	Vipin Sharma <vipinsh@google.com>, Thomas Huth <thuth@redhat.com>, 
	Aaron Lewis <aaronlewis@google.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 12, 2024 at 8:24=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Mon, Jan 22, 2024 at 3:15=E2=80=AFPM Haibo Xu <haibo1.xu@intel.com> wr=
ote:
> >
> > The RISC-V arch_timer selftests is used to validate Sstc timer
> > functionality in a guest, which sets up periodic timer interrupts
> > and check the basic interrupt status upon its receipt.
> >
> > This KVM selftests was ported from aarch64 arch_timer and tested
> > with Linux v6.7-rc8 on a Qemu riscv64 virt machine.
> >
> > ---
> > Changed since v4:
> >   * Rebased to Linux 6.7-rc8
> >   * Added new patch(2/12) to clean up the data type in struct test_args
> >   * Re-ordered patch(11/11) in v4 to patch(3/12)
> >   * Changed the timer_err_margin_us type from int to uint32_t
> >
> > Haibo Xu (11):
> >   KVM: arm64: selftests: Data type cleanup for arch_timer test
> >   KVM: arm64: selftests: Enable tuning of error margin in arch_timer
> >     test
> >   KVM: arm64: selftests: Split arch_timer test code
> >   KVM: selftests: Add CONFIG_64BIT definition for the build
> >   tools: riscv: Add header file csr.h
> >   tools: riscv: Add header file vdso/processor.h
> >   KVM: riscv: selftests: Switch to use macro from csr.h
> >   KVM: riscv: selftests: Add exception handling support
> >   KVM: riscv: selftests: Add guest helper to get vcpu id
> >   KVM: riscv: selftests: Change vcpu_has_ext to a common function
> >   KVM: riscv: selftests: Add sstc timer test
> >
> > Paolo Bonzini (1):
> >   selftests/kvm: Fix issues with $(SPLIT_TESTS)
>
> Rebased on Linux-6.8-rc4 and queued this series for Linux-6.9
>

Thanks!

> Thanks,
> Anup
>
> >
> >  tools/arch/riscv/include/asm/csr.h            | 541 ++++++++++++++++++
> >  tools/arch/riscv/include/asm/vdso/processor.h |  32 ++
> >  tools/testing/selftests/kvm/Makefile          |  27 +-
> >  .../selftests/kvm/aarch64/arch_timer.c        | 295 +---------
> >  tools/testing/selftests/kvm/arch_timer.c      | 259 +++++++++
> >  .../selftests/kvm/include/aarch64/processor.h |   4 -
> >  .../selftests/kvm/include/kvm_util_base.h     |   9 +
> >  .../selftests/kvm/include/riscv/arch_timer.h  |  71 +++
> >  .../selftests/kvm/include/riscv/processor.h   |  65 ++-
> >  .../testing/selftests/kvm/include/test_util.h |   2 +
> >  .../selftests/kvm/include/timer_test.h        |  45 ++
> >  .../selftests/kvm/lib/riscv/handlers.S        | 101 ++++
> >  .../selftests/kvm/lib/riscv/processor.c       |  87 +++
> >  .../testing/selftests/kvm/riscv/arch_timer.c  | 111 ++++
> >  .../selftests/kvm/riscv/get-reg-list.c        |  11 +-
> >  15 files changed, 1353 insertions(+), 307 deletions(-)
> >  create mode 100644 tools/arch/riscv/include/asm/csr.h
> >  create mode 100644 tools/arch/riscv/include/asm/vdso/processor.h
> >  create mode 100644 tools/testing/selftests/kvm/arch_timer.c
> >  create mode 100644 tools/testing/selftests/kvm/include/riscv/arch_time=
r.h
> >  create mode 100644 tools/testing/selftests/kvm/include/timer_test.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/riscv/handlers.S
> >  create mode 100644 tools/testing/selftests/kvm/riscv/arch_timer.c
> >
> > --
> > 2.34.1
> >
