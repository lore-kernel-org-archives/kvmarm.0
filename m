Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B14A15666D
	for <kvmarm@lists.linux.dev>; Mon, 25 Nov 2024 12:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732536082; cv=none; b=C7XGhc78V5VRtPbyBZEpQC925G/DBW1mxfWHRsOl9/9gNcQAUrSyxUUnDpkz2hrzOQYwmZkNgwaicLGRzMJxe5eKqNKhFCtb4spr1cnVlg2lQR0NvBg67MkJLd5eTnLzYDZqY76oK4UIpXKACt3AZLaq4XfUBXBSK4tOc9lu+1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732536082; c=relaxed/simple;
	bh=zN1GKAe2aJ6fL9wordjuaZa3Kor/0LAiPg7NugCu4TE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P1hnJdhxsY9L8VghZx1NAnot5Shwml+avX0vsLm8BlMOQfCeGuRz0MmEFgNgEKatHWw00T1cEKrzzn3mUhpPGnuBfVausnnbIAJtVFMmbiTR7C5VaOgmdGP452MwoEyYXAGCKxmoyydjkZyukPpy5/55GWGn/5u5LaxtuUmGxnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4XKWdCfT; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4XKWdCfT"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4349ea54db7so42435e9.0
        for <kvmarm@lists.linux.dev>; Mon, 25 Nov 2024 04:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732536079; x=1733140879; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w7ZsJLgH7EJzomT/OPbscdiTb7j7tI+Uck1UKkacBNc=;
        b=4XKWdCfTlEIWI4n/uhxEI+hoy/2ipkvzyIQPKp5TXtql1SOuyKq45bxkFpx4X/tOjK
         Yk4mK6jDRFIhHAjqJVAeVbhT2H5H1D3iVBFBs/D4NVc1VuhAcLUt0YrlbbK3htX9lWIB
         MWug+XHs+90h9zxLCsgoE84Rpzq3mnIpjrMxTOdYMFSW1Ka+/oSeqAaW/XrXGNfRxd1k
         zDBCJkAtKtjNiM/IB0+/y83oDVhahKgzrL7KGBTY8P9QUsJzDpnaMg7llJ5Qra3obH2T
         QONk9cXJiDIAqAOpsShW2bkXpBQ1EW2nLUSxNmRmsGfe8WQ+AilYkFqAjkMcNvDaDynn
         0uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732536079; x=1733140879;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w7ZsJLgH7EJzomT/OPbscdiTb7j7tI+Uck1UKkacBNc=;
        b=AI9iUAVuNeZdqxrAhObD0EtZzTdnrQYTlM2j8bhvzWqlC3IC9h9nDCmzqlxdH1efzD
         eT5szazeLepB+KcH4UB5Lk7dN3LU8q4i3YDTvew7ubdgo0QJQgUgNCq4XEzX3AYlhb1l
         cRVOWI1IzyvTXoqCOh+C/UxBHhD7RrpWd3MaGKIGuOe+Byo1iD68ClsReamUaa2hjB7r
         pgOz19eKf08KV/8gV4z7MfnFsgagA7X/oD6nvrJd3YNmYmsQYsDW4wFioyAUZeas8I0b
         kfrfIQpXVhrsm/bcBWj+BFwfIFd0on33B8+995ycvr71XV9DijkY4uMqM9Qkj+USR692
         FU6w==
X-Gm-Message-State: AOJu0Yyh4fyLuR/o/UIeQXT9MOswXnm747tLeWRifgjeqLRsqZbA5Wew
	INwVnKehwxKL+kmxlwV0AEji5wt0B6OgADEGc5DKPTVZocW1vfSjqlRfRaHTwNt7GCIehS05dgn
	v4tko6YQPHMcPTFpq2hSuUOoLARYflxhbxUlE
X-Gm-Gg: ASbGnctP3RB4L3B/u0RgxfbEYyE5wX7EzEF17C0bMtbiQpQrB1U0UT0btPL+OzEAryQ
	P473Xy/wnX0JE4tQ1uT4cAvd6zSuGTw==
X-Google-Smtp-Source: AGHT+IGOoaM7iUnf0v0aEQenNPMbZX7T/9Rp6+XXRcBOMI/kWtHC1wFoi9txS3/EaMmCMufV90GE3ir42ciJ7WuyrRM=
X-Received: by 2002:a05:600c:4f06:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-4348bdae14amr2761825e9.2.1732536078343; Mon, 25 Nov 2024
 04:01:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241122110622.3010118-1-tabba@google.com> <20241122110622.3010118-8-tabba@google.com>
 <86jzcsvmba.wl-maz@kernel.org>
In-Reply-To: <86jzcsvmba.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 25 Nov 2024 12:00:42 +0000
Message-ID: <CA+EHjTwuTgH1gdoSuZu_A0MxOuFnt3PGTBdMAnfMnSOh8QAQLQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] KVM: arm64: Rework specifying restricted
 features for protected VMs
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, james.clark@linaro.org, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sun, 24 Nov 2024 at 12:38, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 22 Nov 2024 11:06:17 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The existing code didn't properly distinguish between signed and
> > unsigned features, and was difficult to read and to maintain.
> > Rework it using the same method used in other parts of KVM when
> > handling vcpu features.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  .../arm64/kvm/hyp/include/nvhe/fixed_config.h |   1 -
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 356 +++++++++---------
> >  2 files changed, 186 insertions(+), 171 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
> > index 69e26d1a0ebe..37a6d2434e47 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
> > @@ -198,7 +198,6 @@
> >       FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3), ID_AA64ISAR2_EL1_APA3_PAuth) \
> >       )
> >
> > -u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> >  bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
> >  bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
> >  void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > index 3aa76b018f70..cea3b099dc56 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -28,221 +28,237 @@ u64 id_aa64mmfr1_el1_sys_val;
> >  u64 id_aa64mmfr2_el1_sys_val;
> >  u64 id_aa64smfr0_el1_sys_val;
> >
> > -/*
> > - * Inject an unknown/undefined exception to an AArch64 guest while most of its
> > - * sysregs are live.
> > - */
> > -static void inject_undef64(struct kvm_vcpu *vcpu)
> > -{
> > -     u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
> > -
> > -     *vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
> > -     *vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
> > -
> > -     kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
> > -
> > -     __kvm_adjust_pc(vcpu);
> > -
> > -     write_sysreg_el1(esr, SYS_ESR);
> > -     write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
> > -     write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> > -     write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> > -}
> > +struct pvm_feature {
> > +     int shift;
> > +     int width;
> > +     u64 mask;
> > +     u64 max_supported;
> > +     bool is_signed;
>
> Most of this is very similar to struct arm64_ftr_bits. Can you align
> the types and names with it? And do you really need 'mask', which can
> be derived from shift and width?

Ack. I stored mask since it's already there in sysreg-defs.h, but I'll
recalculate it.

> max_supported as an unsigned value is also potentially troublesome for
> signed features. And does it need to be 64bit wide?

It doesn't need to be 64 bits. I will make it a u8. As for the sign,
the function that handles it, get_restricted_features(), uses bit
manipulation to handle it, since the sign bit is bit 3 for most (or
all) id regs, rather than rely on the sign, which is why I went with
unsigned.

> > +     bool (*vcpu_supported)(const struct kvm_vcpu *vcpu);
>
> We really need to find a way to kill this. The two features that stick
> out badly are SVE and PAuth, and I don't see why we can't eventually
> track them at the VM level instead (despite the userspace API).

It is actually being tracked per vm, and only calculated once per vm.
I went with the name vcpu_supported, since the functions (or macros)
it will point to are vcpu_has_ptrauth() and vcpu_has_sve(). I could at
least rename it here to vm_supported(), in anticipation of a wider
change.

That said, this should be fixed for all of kvm/arm64. I'll see if it's
a simple patch to add to this series as a respin, or something for
later.

Thanks again!

/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
