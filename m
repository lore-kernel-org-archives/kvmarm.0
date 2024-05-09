Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F10D74E11
	for <kvmarm@lists.linux.dev>; Thu,  9 May 2024 17:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715276772; cv=none; b=E9aSYfs1BUGuyPw4ItEtEfpH+G/DoM8yL2MEsJ6OcYBUL3VcefNUCoTXBQ5MQcDpjLmynmHrfvz/GngJpkPqu1p1AXBX4YPbDZJ3mATrCbVoMrslV/q9+34iS682s6ppYC/3IwqK27QaTAQyrAqfKd/ZguTiENKN1GkRqgn3UIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715276772; c=relaxed/simple;
	bh=2Z3IROnIJkTyVb4T0JU/fxSZWR5a3mqHgia2cEwsvcY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lwTeNophpSC7caKpX94Weto43YpZlduyileAyTqDKlD+rwJTagiXr3qmbko3fZA78jCpuDqrQVskYQk1nocuJQKBHpu0uJdljSYXbjsXKCHx7PffI7rb5FK5W1lSOPew3KciodOC50OoaygGgoNIFGnydhqktMkh6vpRhN5mVgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UC6zZTyb; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UC6zZTyb"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-47eec1bef2aso401233137.2
        for <kvmarm@lists.linux.dev>; Thu, 09 May 2024 10:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715276770; x=1715881570; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KYWrC80by0NSPpevQrbh1oP+dL2b43/jzqRh1dValjE=;
        b=UC6zZTybgv2IfI3COpXYvy4QVIcq3ZaPlFoHwxaVqQEUhQRyk8IorySNxEw666Vkpk
         JYA4z4AnwlnVZx1aMZ3d+PjmhSK8gEYKrir0u/X44vy5mDpu+tY3kyBGeTgW5Q/iQTPW
         thvh/ZIbyJoI5z0c58+Jq34mKmwU0hPRPYd2AXVhj3tlEJa4KB2c2Z/wuXKbzzDh0KjB
         V2QWXL9WCHGHO/9YK+5Cob82BkA1TXvHazcutioogajLCyG0dqD9107EhB/NVTVG3jCH
         Ky5F+08btbADFaU40HW1Hp4DarSp1ZqaJdPtKdCumGBkwOKq2VeDgZ2wtO36fpJdjwVb
         7mwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715276770; x=1715881570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KYWrC80by0NSPpevQrbh1oP+dL2b43/jzqRh1dValjE=;
        b=ivtxSE6RbvPuJ+T2ocAxLrNHMfT6ccbjxihTGqyJntDfuB3uPP1einfXOJB4wKZda/
         sGILKKnWi5y14JdVOejAY/ii0wZB5WWoxKCQUnVV9P7hn6RZJTIZ5Qfqnbzjgt3n1xFD
         BsDPUByQyUmnRADNQzWH0AwkGNN6w1IAZ1stAXd7u5+rUZItyWa6eStsihfLIgQIwMz8
         jM3t1/wtxIEe9RRTCZPE/EF85EkJXMV65IZaTrqWfnIYf/4bChUi2PCaTrjeXUPZjSLA
         JnIauPgw1Yxpv7tpedSJfTsNcXLzLdgQ5vvOy3yGn1h3IvEZknGZBMesRo1+HVb0slJP
         V+TQ==
X-Gm-Message-State: AOJu0YwdcbHe4atTNx18u5zLdshFejQIHY7F/l3yWEHlUJuo+62AJl3V
	RlKxMPQqLlKmUG6VAwKCln8LB2R9K46c+WRC7swz6vZdtnwKorX8RBW+puVdbelDatMnpy7CGga
	9ttwagCs1prGGzWB/vkhGJnebXaBqLa9/v1s4
X-Google-Smtp-Source: AGHT+IGJeHYOVpcSB1dxyGH3BRYAKsYW8sAoCh9nA162mYDV+9q9UPjlxp+6qdM+wMWvRgMVTvZt0SsHm9YHVd24E1k=
X-Received: by 2002:a05:6102:c0b:b0:47b:cc56:7aa8 with SMTP id
 ada2fe7eead31-48077ddcda2mr439346137.1.1715276769792; Thu, 09 May 2024
 10:46:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com> <20240423150538.2103045-2-tabba@google.com>
 <4ec3be32-476a-14f2-7826-2171df1c9f77@huawei.com>
In-Reply-To: <4ec3be32-476a-14f2-7826-2171df1c9f77@huawei.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 9 May 2024 18:46:00 +0100
Message-ID: <CA+EHjTwPWP1exm_bb_bSKF154W4doZvKxk5=AqFrBkUy_UsvaQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/30] KVM: arm64: Initialize the kvm host data's
 fpsimd_state pointer in pKVM
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, mark.rutland@arm.com, 
	broonie@kernel.org, joey.gouly@arm.com, rananta@google.com, 
	smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Zenghui,

On Thu, May 9, 2024 at 3:10=E2=80=AFPM Zenghui Yu <yuzenghui@huawei.com> wr=
ote:
>
> Hi Fuad,
>
> On 2024/4/23 23:05, Fuad Tabba wrote:
> > Since the host_fpsimd_state has been removed from kvm_vcpu_arch,
> > it isn't pointing to the hyp's version of the host fp_regs in
> > protected mode.
> >
> > Initialize the host_data fpsimd_state point to the host_data's
> > context fp_regs on pKVM initialization.
> >
> > Fixes: 51e09b5572d6 ("KVM: arm64: Exclude host_fpsimd_state pointer fro=
m kvm_vcpu_arch")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 11 +++++++++++
> >  arch/arm64/kvm/hyp/nvhe/setup.c        |  1 +
> >  3 files changed, 13 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hy=
p/include/nvhe/pkvm.h
> > index 82b3d62538a6..20c3f6e13b99 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > @@ -54,6 +54,7 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcp=
u)
> >  }
> >
> >  void pkvm_hyp_vm_table_init(void *tbl);
> > +void pkvm_host_fpsimd_state_init(void);
> >
> >  int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
> >                  unsigned long pgd_hva);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/p=
kvm.c
> > index 26dd9a20ad6e..492b7fc2c0c7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -247,6 +247,17 @@ void pkvm_hyp_vm_table_init(void *tbl)
> >       vm_table =3D tbl;
> >  }
> >
> > +void pkvm_host_fpsimd_state_init(void)
> > +{
> > +     unsigned long i;
> > +
> > +     for (i =3D 0; i < hyp_nr_cpus; i++) {
> > +             struct kvm_host_data *host_data =3D per_cpu_ptr(&kvm_host=
_data, i);
> > +
> > +             host_data->fpsimd_state =3D &host_data->host_ctxt.fp_regs=
;
>
> So we save the host FP/SIMD state in hypervisor's private host_ctxt when
> guest accesses to FP/SIMD. Do we then need to save it into host VCPU's
> process state and (if so,) how does that happen?

Depends on which tree you're looking at. This is all new in
kvmarm/next [1], and I don't think it has made it to the main tree
yet.

If you look in kvmarm/next, the file arch/arm64/include/asm/kvm_host.h
has "struct kvm_host_data", which has a pointer to fpsimd_state, which
you've already seen.

For normal mode, i.e., without kvm: In arch/arm64/kvm/fpsimd.c,
kvm_arch_vcpu_load_fp(), which is called when a vcpu is loaded,
assigns that pointer to the current task's fpsimd_state:

    *host_data_ptr(fpsimd_state) =3D
kern_hyp_va(&current->thread.uw.fpsimd_state);

You might have missed it because it uses the host_data_ptr() macro to
access struct kvm_host_data

I hope this helps,
/fuad

[1] https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/log/?=
h=3Dnext



>
> Could you please point me to that piece of code? Sorry I'm really not
> familiar with the protected mode. ;-).
>
> Thanks,
> Zenghui
