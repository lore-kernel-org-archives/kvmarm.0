Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4AF1D12EC
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 00:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724978021; cv=none; b=XNkHzt9O/cjLux1cDJOh9HipTRGDBto6Gw6fdel8hjbzIxFxUQOKgdstJLBKCuq0yl2M+g7dDXeYiX2vzb9kl2kJTzu4CB2s0aw1vCJeZqi0i6etBPBfI2kV8OZj5C7beyWbhWOdbB3tAY3dHGFKuTaR58AxXK4BQqzIfZ+odjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724978021; c=relaxed/simple;
	bh=SH85gWPyWDBMrPTxg5hwF9eFmgdFespsOtsowukOS9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JvnmL/z1MLF5BW7UKtcw2XpoMfxr5yIF9OLNZ0M1gOxZqNa6hr3MsIM+fdu/BtLda093O6Qk7+fPjBEI6BpLBazAP5kKAeKgbvKOvvqgQhDJZZmGgY/8+qYzDKn3hdyZQZ2Ubz+FyADDSBXMW10Kht3B5/s3/TCf/TMo+f7aA84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C3ZeXGXu; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C3ZeXGXu"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6c3f1939d12so11325107b3.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 17:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724978017; x=1725582817; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0c5SIq1ErU8LqTXRTvzlDlvgCjUaMFsATO9CN846VQ=;
        b=C3ZeXGXuEWB1ivJO6mPXHUW2jwnLUwYm4NCzXY5VDmTEnmKNhW5izT68c9vaFH1/43
         cCgB6MhPkbRRbltRkA6dzD3fSXinpg3Ej0jC7LAonRL0BjQgP34gEBtnqCHsa6Umciin
         4gG+FYd01L/e15cA6RQDs9id6ftqpA8/IsxfB53ysg9PP4lDNHPpT45QadPbLKaISJ6B
         qcjEplOZVNcjqWoATzefcAAqqvn0XS7G6+xdH2zvXu6YNn615VDeDC0HIvXCIMqPsWUl
         Xq7x0nVX55I9bfmxS0SEixumOYDVNMNzNszFo/Ist9lGZ6J8BWTod2sgW5Kw7D5sf9N+
         18MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724978017; x=1725582817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0c5SIq1ErU8LqTXRTvzlDlvgCjUaMFsATO9CN846VQ=;
        b=ZeRCsumIdxTF3NMwxYRxLMuhD0FPjj1sVfOjnyvOzi+vGuFcFyfj/jE6NPdhMZjp8E
         kcpJ+inzbZUHqZmv7h+nk7IkzdmZJ0ORX47WRL4Km+aDUeqjlcbhdUR+QOf8XhOrEwZ6
         gxYV+rfrrfl6LRUjSXpJucnwtDg94Kuf3uvQDzg+gKFFPF/35lhoAKEOKnTNd4h0LeM/
         YlZfcFrlM9qLHrX50ecVqKhOqPV3WsM2WcJuK9M6C1nZXpRvujPUbEtDJHEqj/8lFA1l
         jHV6EeIZrsdCryBRz1nLb2mUB9DspTeNRqayMhiRifbuFPWYXrlXbiGl+1XnckHs4hk0
         /gKg==
X-Forwarded-Encrypted: i=1; AJvYcCW3cqbuxbTcg6kBni1k3uljyOt0SSYxop8PyE2Pr6cI0rhdSELz3/zTsXnlCw7gSaM3nDk29ag=@lists.linux.dev
X-Gm-Message-State: AOJu0YxP+81LlsMEc8oAxDClu1QLXFupv4As9fiKpyB0/V2n18wYG5J4
	kc6+4Sm08sxuKWZp+aKrL8zw3hEHd5dV7VG+DzHdIkkR6JTIbWwON2nvIxHoDzjQi3tN78BGrTR
	baQ2LwtXZWA18u5v4K6Z+Qnjw7I3XIT7GpC++
X-Google-Smtp-Source: AGHT+IE56ditvMsqd+EwyV0AwwWQn10JX3FwGZqO74Otl79fYNdQirjfyiEfOM48/ZWOjAG0+PeTvxcA3jfyHAIhk/4=
X-Received: by 2002:a05:690c:f84:b0:62c:e6c0:e887 with SMTP id
 00721157ae682-6d40d88eabfmr4560677b3.9.1724978017312; Thu, 29 Aug 2024
 17:33:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-4-jthoughton@google.com> <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
 <Zr_y7Fn63hdowfYM@google.com> <CAOUHufYc3hr-+fp14jgEkDN++v6t-z-PRf1yQdKtnje6SgLiiA@mail.gmail.com>
 <ZsOuEP6P0v45ffC0@linux.dev>
In-Reply-To: <ZsOuEP6P0v45ffC0@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Thu, 29 Aug 2024 17:33:00 -0700
Message-ID: <CADrL8HWf-Onu=4ONBO1CFZ1Tqj5bee=+NnRC333aKqkUy+0Sxg@mail.gmail.com>
Subject: Re: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>, Sean Christopherson <seanjc@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2024 at 1:42=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, Aug 16, 2024 at 07:03:27PM -0600, Yu Zhao wrote:
> > On Fri, Aug 16, 2024 at 6:46=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
>
> [...]
>
> > > Were you expecting vCPU runtime to improve (more)?  If so, lack of mo=
vement could
> > > be due to KVM arm64 taking mmap_lock for read when handling faults:

I had no real expectation. I was hoping that maybe there could be a
vCPU runtime improvement, given that user_mem_abort() (being called
because we're faulting memory in continuously in this test) has to
take the KVM MMU lock for reading, and aging is taking it for reading
vs. writing. I think that's why aging is a lot slower when using the
write lock: it is waiting for the readers to drop the lock, but I
guess the delay on the *readers* due to the pending writer seems to be
pretty minimal.

> > >
> > > https://lore.kernel.org/all/Zr0ZbPQHVNzmvwa6@google.com
> >
> > For the above test, I don't think it's mmap_lock
>
> Yeah, I don't think this is related to the mmap_lock.
>
> James is likely using hardware that has FEAT_HAFDBS, so vCPUs won't
> fault for an Access flag update. Even if he's on a machine w/o it,
> Access flag faults are handled outside the mmap_lock.

Yeah I was running on Ampere Altra CPUs.

> Forcing SW management of the AF at stage-2 would be the best case for
> demonstrating the locking improvement:
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index a24a2a857456..a640e8a8c6ea 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -669,8 +669,6 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift=
)
>          * happen to be running on a design that has unadvertised support=
 for
>          * HAFDBS. Here be dragons.
>          */
> -       if (!cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> -               vtcr |=3D VTCR_EL2_HA;
>  #endif /* CONFIG_ARM64_HW_AFDBM */
>
>         if (kvm_lpa2_is_enabled())

Thanks!

> Changing the config option would work too, but I wasn't sure if
> FEAT_HAFDBS on the primary MMU influenced MGLRU heuristics.

Indeed, disabling CONFIG_ARM64_HW_AFDBM will cause MGLRU not to do aging.

> > -- the reclaim path,
> > e.g., when zswapping guest memory, has two stages: aging (scanning
> > PTEs) and eviction (unmapping PTEs). Only testing the former isn't
> > realistic at all.
>
> AIUI, the intention of this test data is to provide some justification
> for why Marc + I should consider the locking change *outside* of any
> MMU notifier changes. So from that POV, this is meant as a hacked
> up microbenchmark and not meant to be realistic.
>
> And really, the arm64 change has nothing to do with this series at
> this point, which is disappointing. In the interest of moving this
> feature along for both architectures, would you be able help James
> with:
>
>  - Identifying a benchmark that you believe is realistic
>
>  - Suggestions on how to run that benchmark on Google infrastructure
>
> Asking since you had a setup / data earlier on when you were carrying
> the series. Hopefully with supportive data we can get arm64 to opt-in
> to HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY as well.

I'll keep trying some other approaches I can take for getting similar
testing that Yu had; it is somewhat difficult for me to reproduce
those tests (and it really shouldn't be.... sorry).

I think it makes most sense for me to drop the arm64 patch for now and
re-propose it (or something stronger) alongside enabling aging. Does
that sound ok?
