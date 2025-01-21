Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3FB15C0
	for <kvmarm@lists.linux.dev>; Tue, 21 Jan 2025 04:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737433482; cv=none; b=H5WoGi8XQ1F0RHK4QW/0D5xJnxRK7uEJAszjX5gxD4VUO1BOjhZ+fNhfZXt8TxIyHYX1WOZd9iMSKQ4qHcwp5Pw7Dd1ygsI8t+1yJfHpPA2WxTtuxtzoK1kTMq/Jj9q7Lx/0zHrlQFZ1KoP4j3cWrdz1K1XRMu0FPoEIpdLO0Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737433482; c=relaxed/simple;
	bh=sHvglNfMEhhcfie0VUGKFdXt6Y6BwSaXcBAzp1L3Etc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kf1mObVoAG1YCuJKzmDTtFmrCszgcwzccfjk1wXHPzXQ/Bzzpgu2EsGWDpB2Xw037UtUQiWJaCdC7AumxJyeuU0uuEXsDNzFIjC8mz31SMG+YIJcexg/yhdyGXTd52OO/qtJXxduS0tz6BgFItgPTx9L9/z4AEWislltxIRs+YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oaJeAB6j; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oaJeAB6j"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-219f6ca9a81so257555ad.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Jan 2025 20:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737433479; x=1738038279; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCHIuyllCbEvGhB8ZhLY3eiF7ea/e+TGQlrY3TscTek=;
        b=oaJeAB6jY+qem68CmHNDxe/gnfUFEF4m+xaZsQMKV00dwZr6QLlAdBLHYGvsY8nwa1
         gOB1SSZ+JnsAgsrgCgjAn+O8ib+JBKQ6R6DvwzRV35D+7DhqPyUAUJnFOHVAZe8nR76q
         Vjp/SsBu6Xww4TkflLOhbOmt+Q8GPHwvByqJxoh8wWVrx/IGkomjXNcjVFOLyQIq+N+w
         Hj/vhKCk0eI5WosOSjDC4+dINE2Z/j/RJRUWFFjgv35VJjNI9ZJl9iF67mcVWUdknh8i
         6kYmAbK6sAvVmLZ/fxbuLIQbX0mQO1jVys8gl4dDsOiF1MI7j2ZDndWw302527Ea1q9W
         bL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737433479; x=1738038279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KCHIuyllCbEvGhB8ZhLY3eiF7ea/e+TGQlrY3TscTek=;
        b=CTwOGdXzOAFwMxE5jJ5jT8KKYDROAW7u2tWCNcWwfjFsrqezJyFR0Npf1ONFT+pApS
         QR03/kHFyN9qVzBazzlr8IEnV1/Vf0DVt9gDUY6ajpRHjB2PAdz5ewQj8dGM7bS5z8Lj
         8NcyxjMGeov1Woohq/NTqWmX8fnpfWOIToLls9i4zCQcxj+4CQqx/phOwkX+KqfUDSbh
         sdYSl7JqxO210EmB5mjvoSt9r/8a4FQ5X90sgT3JI4a5Qorzam5LWaQYiKN4NMTRBokF
         LblswaekFeQWa95Z+o3VqDDQxpO+1V8dJ2yEUa8Akzrr2DK5uZVwh0xae3cQ4ubC1yPs
         FAPg==
X-Forwarded-Encrypted: i=1; AJvYcCVEZZqudYq0pbNMwSxtV70b8i7bL/A8NG5v/FbUhJY9V8kxySc2E6RMQ6OXJe0HFyoUz2J262M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2lVX1CAOkUtsf9CGG59TwiUVBoiaUJsYv2nenDGgXi51V2l0f
	fN5LN83FLCJ8EKgAjlXHyQG3g0tqLes4Ir20rmwByK2axh97kGg/uJcLihdEAGDw4AsJ6UMvkY/
	6tTlTR0/gPPB1I0xE1tS7P8VmZ9mwd8vp3N3c
X-Gm-Gg: ASbGnctv2UraVCinQAdXDOAGURYms4re9uq2ns7Gu7jtggXHjS/KzlZ9xeoO2AAwHft
	JkHEHUFSUYm/n6IlXSwAmNd27SQhAiME0nRafRtoTNnVeRlMjL2URiWfgJ1TofNwFTy4Wo3yGcB
	8wI2HY2A==
X-Google-Smtp-Source: AGHT+IHxtlEPWJVSdhR6rrakC31zpMurRjTirZiq5bee0Zk7X+dmUx5SDeFxWcpkjSx7Vdpec3Sqtnl2AlPVMCHAbco=
X-Received: by 2002:a17:903:2404:b0:215:98fd:cb04 with SMTP id
 d9443c01a7336-21c61dccf33mr4540225ad.25.1737433479373; Mon, 20 Jan 2025
 20:24:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250120151514.1769597-1-lokeshvutla@google.com> <86sepdv4xn.wl-maz@kernel.org>
In-Reply-To: <86sepdv4xn.wl-maz@kernel.org>
From: Lokesh Vutla <lokeshvutla@google.com>
Date: Tue, 21 Jan 2025 09:54:26 +0530
X-Gm-Features: AbW1kvabEKtOD-nLKTX9gYTsSARLIVR3-5bisQwyCI_CiI_yRSu2JSnqikAmF5I
Message-ID: <CAOcHnfPdq9F6qqN=kCrUSRSstgsY74MQO4uPKyz4CgPbWKsxhw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Flush hyp bss section after initialization of
 variables in bss
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, sachinparekh@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Jan 20, 2025 at 9:44=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 20 Jan 2025 15:15:14 +0000,
> Lokesh Vutla <lokeshvutla@google.com> wrote:
> >
> > To determine CPU features during initialization, the NVHE hypervisor
>
> s/NVHE/nVHE/

ok

>
> > utilizes sanitized values of the host's CPU features registers. These
> > values, stored in u64 idaa64*_el1_sys_val variables are updated by the
> > kvm_hyp_init_symbols() function at EL1. To ensure EL2 visibility, the
>
> visibility *with the MMU off*

ok

>
> > data cache needs to be flushed after these updates. However,
> > individually flushing each variable using kvm_flush_dcache_to_poc() is
> > inefficient.
> >
> > These cpu feature variables would be part of the bss section of
> > the hypervisor. Hence, flush the entire bss section of hypervisor
> > once the initialization is complete.
> >
> > Motivation for this change:
> > * Since the existing variables are not flushed from EL1, the
> >   id_aa64pfr0_el1_sys_val is seen as 0 from EL2.
> > * based on this value check_override macro in hypervisor skips
> >   updating the sve (cpacr_el1) at finalise_el2_state.
> > * The default value for cpacr_el1 enables the sve traps to EL2.
> > * With sve enabled, during the context switch from EL0 -> EL1 (which is
> >   much later in the boot process), the sve registers are saved/restored=
.
> > * Since sve traps are enabled, accessing sve registers at EL1 caused a
> >   trap to EL2.
> > * However, hypervisor is not ready to handle sve traps at this stage
> >   causing the below kernel crash during the boot:
>
> Drop this section, it doesn't bring much to the discussion.
>
> >
> > [    0.320850][    T1] Run /init as init process
> > [    0.321392][    T1] kvm [1]: nVHE hyp BUG at: [<ffffffc08112ee8c>] _=
_kvm_nvhe_$x.24+0x254/0x254!
> > [    0.321522][    T1] kvm [1]: Cannot dump pKVM nVHE stacktrace: !CONF=
IG_PROTECTED_NVHE_STACKTRACE
> > [    0.321635][    T1] kvm [1]: Hyp Offset: 0xffffff6e60000000
> > [    0.321710][    T1] Kernel panic - not syncing: HYP panic:
> > [    0.321710][    T1] PS:634023c9 PC:000000522112ee8c ESR:00000000f200=
0800
> > [    0.321710][    T1] FAR:0000000000000000 CPACR:0000000000310000 PAR:=
0000000000000800
> > [    0.321710][    T1] VCPU:0000000000000000
> > [...]
> > [    0.322251][    T1] Call trace:
> > [    0.322292][    T1]  dump_backtrace+0x100/0x180
> > [    0.322355][    T1]  show_stack+0x20/0x30
> > [    0.322410][    T1]  dump_stack_lvl+0x40/0x88
> > [    0.322471][    T1]  dump_stack+0x18/0x24
> > [    0.322523][    T1]  panic+0x13c/0x364
> > [    0.322578][    T1]  nvhe_hyp_panic_handler+0x148/0x1cc
> > [    0.322646][    T1]  do_sve_acc+0xec/0x260
> > [    0.322706][    T1]  el0_sve_acc+0x34/0x68
>
> This is essentially content-free, given that there is no
> backtrace. Please drop this.

Sure.. will drop the above 2 sections in v2.

>
> >
> > Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System =
Registers")
> > Suggested-by: Fuad Tabba <tabba@google.com>
> > Signed-off-by: Lokesh Vutla <lokeshvutla@google.com>
> > ---
> >  arch/arm64/kvm/arm.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index a102c3aebdbc..5d3b2069a2d5 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2661,6 +2661,12 @@ static int __init init_hyp_mode(void)
> >               }
> >       }
> >
> > +     /*
> > +      * Flush entire BSS since part of its data is read while the MMU =
is off.
> > +      */
> > +     kvm_flush_dcache_to_poc(kvm_ksym_ref(__hyp_bss_start),
> > +                             kvm_ksym_ref(__hyp_bss_end) - kvm_ksym_re=
f(__hyp_bss_start));
> > +
> >       return 0;
> >
> >  out_err:
>
> I don't understand how this fixes anything. At this stage, the
> hypervisor has already been initialised, and I expect it will have
> evaluated the wrong values.
>
> Even worse, I strongly suspect that by the time you perform this, S2
> is enabled on the host, and that the BSS is off-limit. Which means it
> could fault and send you to lalaland.
>
> Have you actually tested this with upstream?
>
> I would have expected the clean operations to be called from
> kvm_hyp_init_symbols(), which runs before EL2 gets initialised in
> protected mode.

Sorry my bad.. Actually we started flushing each variable and tested
the solution. With this we observed that the hypervisor is able to read
the data properly with MMU off. Then kept optimizing the solution by
flushing the entire bss and moving around the place of flushing..
I guess it got lucky in the last run with this wrong placement.
Will add the flush in kvm_hyp_init_symbols() and post v2.

Thanks and Regards,
Lokesh



>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
