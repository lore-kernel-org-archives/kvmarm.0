Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AA256B9C
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 06:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715323522; cv=none; b=hVnPvlhXnC6zkemjm4baX7JKluH+FiWnHYAhFOJTuy6/9xZNb5ot7RksX7MroI7cdbTWHkUeDMjmX9qs6hC30BqltbhU82HuEFIEOhR4B7dA9dYbk9RyS+h79DgeEbTlZ/sFOvG8Z+/qLtDo07IFY2wUlsYqONoNaS+91U+NKLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715323522; c=relaxed/simple;
	bh=fs7/bLrP7pwP+qHDr9sx2z6QNNl14YvTX9WeqcGZAEM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C0R5liWf6IRqV6KCV8ikxrVjYawd8UgWC5AGMG9v+vIwPY2C5Fu7bl6rJdDK5tMKe2SJS9BT5uOr4EMajSmkQEGR42OWoegDi0RiKixhcj9FS7F26z0fhWYhR0V+h6itADU9PgIqcrW/OCLs8cRhzs6CRMFE8EOhSIIsQR5JkSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=El0nGkyS; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="El0nGkyS"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-7f6e510b2ecso535358241.2
        for <kvmarm@lists.linux.dev>; Thu, 09 May 2024 23:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715323519; x=1715928319; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qeMj/T5h/bvflruMDgl2bbCkIdNUOBGv8/ZJLo75xFY=;
        b=El0nGkySDv4qIi3yBAaEvA03t0BSVkYPY4slFaj/drgW1/E+TP65T65fy6bRXaQ2tB
         ONpV6glKh62kULH8vFl3bzPWq0ggY4L0Tt0Mn4Bhc0h6ugPA5OtdsZbWUXML4jkWCxQb
         PqOCNCV93oe+D52Y2mt0IjqTtg41GDcY+xWDzhjr2MlM+4w9TS+YZgeigRzNcvogPvFz
         Jlpc3KW2F/royqdVKoPs1Ygnme28hxaofyLqjuWF0vDBG2KIYzpd4DbyNBQ4d3gJmCii
         Q1PcJKx17Gc7lwtHG1ZFGwnNv9FnDGESULHHYlA8Kw9dwZe2YfDcXwavB22QG180DDxa
         4JaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715323519; x=1715928319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qeMj/T5h/bvflruMDgl2bbCkIdNUOBGv8/ZJLo75xFY=;
        b=dWxxr3HSnYZ1z/omKmroE7tX+sUvjiAjPQC8zMHZCXgVWrzV6pgAysspkgCBsJ3zPA
         OjplS0L5reMuhEBnk2b2HoY/mOrfBkB539PUPadX7VfY54bpi4svrPjXWSdEsOqBT3Pv
         zmhiq+ZfK+M/aEDQUlGnGOQlgiX04rEonFr1ThDPQEZoTGK18xsBtWxNObbhFjFyr2WW
         8gwfh5rqrkKZGamSh6SMi7nrRimhsbSyVu/seEkf9gYhoPNu2i+mnwZdT9NQxh85bV4Z
         rwI8+AZgv2BTj1QY9aWr6+PABkBkDlouMo4KFzGgW4EqpPpG+WRxi00ENrvpulEKhkBy
         iw+w==
X-Gm-Message-State: AOJu0Yz40Tc1wV07TxkkzB20AR6Uojozq/G0gEnrcaIPT5Pt1z56QMAO
	rtahfqbC1tG3S3h4oGohiYrenKTL3Rd+uz+SFuuJWSh0G4i9bbmvOk9PO0h9q5a0L1RVtxZepN8
	tpW2rJ0wGIYVzbrR9l/fmoczFCp+ttQwl57Fm
X-Google-Smtp-Source: AGHT+IH2TYqW9mknxhkfOf7u7LBZ/BETJyc5Wt2A1vHBdkNnPO/wnKOP5l6UJXJxUlW9qY8W06Q7p3agrj5zvuTKOGI=
X-Received: by 2002:a05:6102:3709:b0:47b:dc91:e69 with SMTP id
 ada2fe7eead31-48077e7b9a0mr1808324137.27.1715323519118; Thu, 09 May 2024
 23:45:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com> <20240423150538.2103045-2-tabba@google.com>
 <4ec3be32-476a-14f2-7826-2171df1c9f77@huawei.com> <CA+EHjTwPWP1exm_bb_bSKF154W4doZvKxk5=AqFrBkUy_UsvaQ@mail.gmail.com>
 <d1435598-9a4d-1fc0-3355-9db78e6a7e27@huawei.com>
In-Reply-To: <d1435598-9a4d-1fc0-3355-9db78e6a7e27@huawei.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 10 May 2024 07:44:42 +0100
Message-ID: <CA+EHjTzoD4wXhiG-uQ2xzrZkw5fLqjdOsiE87EdY5Z1qfvF7_g@mail.gmail.com>
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

Hi,

On Fri, May 10, 2024 at 3:40=E2=80=AFAM Zenghui Yu <yuzenghui@huawei.com> w=
rote:
>
> On 2024/5/10 1:46, Fuad Tabba wrote:
> > Hi Zenghui,
> >
> > On Thu, May 9, 2024 at 3:10=E2=80=AFPM Zenghui Yu <yuzenghui@huawei.com=
> wrote:
> >>
> >> Hi Fuad,
> >>
> >> On 2024/4/23 23:05, Fuad Tabba wrote:
> >>> Since the host_fpsimd_state has been removed from kvm_vcpu_arch,
> >>> it isn't pointing to the hyp's version of the host fp_regs in
> >>> protected mode.
> >>>
> >>> Initialize the host_data fpsimd_state point to the host_data's
> >>> context fp_regs on pKVM initialization.
> >>>
> >>> Fixes: 51e09b5572d6 ("KVM: arm64: Exclude host_fpsimd_state pointer f=
rom kvm_vcpu_arch")
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
> >>>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 11 +++++++++++
> >>>  arch/arm64/kvm/hyp/nvhe/setup.c        |  1 +
> >>>  3 files changed, 13 insertions(+)
> >>>
> >>> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/=
hyp/include/nvhe/pkvm.h
> >>> index 82b3d62538a6..20c3f6e13b99 100644
> >>> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> >>> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> >>> @@ -54,6 +54,7 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_v=
cpu)
> >>>  }
> >>>
> >>>  void pkvm_hyp_vm_table_init(void *tbl);
> >>> +void pkvm_host_fpsimd_state_init(void);
> >>>
> >>>  int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
> >>>                unsigned long pgd_hva);
> >>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe=
/pkvm.c
> >>> index 26dd9a20ad6e..492b7fc2c0c7 100644
> >>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>> @@ -247,6 +247,17 @@ void pkvm_hyp_vm_table_init(void *tbl)
> >>>     vm_table =3D tbl;
> >>>  }
> >>>
> >>> +void pkvm_host_fpsimd_state_init(void)
> >>> +{
> >>> +     unsigned long i;
> >>> +
> >>> +     for (i =3D 0; i < hyp_nr_cpus; i++) {
> >>> +             struct kvm_host_data *host_data =3D per_cpu_ptr(&kvm_ho=
st_data, i);
> >>> +
> >>> +             host_data->fpsimd_state =3D &host_data->host_ctxt.fp_re=
gs;
> >>
> >> So we save the host FP/SIMD state in hypervisor's private host_ctxt wh=
en
> >> guest accesses to FP/SIMD. Do we then need to save it into host VCPU's
> >> process state and (if so,) how does that happen?
> >
> > Depends on which tree you're looking at. This is all new in
> > kvmarm/next [1], and I don't think it has made it to the main tree
> > yet.
>
> I had looked at Marc's "host-data" series before your series, so we
> should at the same position.
>
> > If you look in kvmarm/next, the file arch/arm64/include/asm/kvm_host.h
> > has "struct kvm_host_data", which has a pointer to fpsimd_state, which
> > you've already seen.
> >
> > For normal mode, i.e., without kvm: In arch/arm64/kvm/fpsimd.c,
>
> "without pkvm"?

Oops, typo, yes, without pKVM.

>
> > kvm_arch_vcpu_load_fp(), which is called when a vcpu is loaded,
> > assigns that pointer to the current task's fpsimd_state:
> >
> >     *host_data_ptr(fpsimd_state) =3D
> > kern_hyp_va(&current->thread.uw.fpsimd_state);
> >
> > You might have missed it because it uses the host_data_ptr() macro to
> > access struct kvm_host_data
>
> Actually I was not asking for the normal mode (VHE, Hyp nVHE), where we
> save the host's FP/SIMD state directly into the current task's
> fpsimd_state, which just looks fine.
>
> I asked that in protected mode, how do we save the host state? It looks
> to me that we only save it into EL2's private
> kvm_host_data->host_ctxt.fp_regs which the host kernel isn't aware of.
> How can host kernel restore the state for the current task later (e.g.,
> for host userspace accesses)? What am I missing?

What I'm going to say applies only to protected VMs in protected mode,
i.e., non-protected VM's in protected mode use the mechanism above
(kvm_arch_vcpu_load_fp()).

Also, the upstream code for pKVM isn't complete yet as we're still
upstreaming it, so you not being able to find something is our fault
not yours :) You can find my branch of pKVM, based on the latest
kvmarm/next here [1].

For protected VMs, we don't want to lazily save/restore the host's
fpsimd state, because that could leak information to the host that the
protected guest is using fpsimd. Therefore, for protected VMs, the
host fpsimd state is maintained (saved/restored) in hyp (at EL2),
without the host needing to know or do anything about it.

I hope this helps,
/fuad

[1] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/next/pkvm=
-core


>
> Thanks,
> Zenghui
