Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3C0376F1
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733150919; cv=none; b=hI0q4tmWoliTBHAkbHpA4ySFD6SMW37sutuDNxUWc6GohgaKjGw9SodYFlf+mPi6Ug00q+4ilDX7R7HAMfqG2C0ShI5v1vYVfgdtRQbQEqv0u825CkF7fx1PS0fo4Pqxa1vQyWHMbcFP9go7NMkVe9AZPSkT4G3SEJTXITzdYSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733150919; c=relaxed/simple;
	bh=mbH7jfuddTzPYQMptrGs92/hJJrAWNUSzkHCsFxff7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XehRG+Jq7F9UHzQEajkAnP0McjXtoiTwHmHgQR9E2/AFBlVF1ruJhJ+5cV6HyMYLeqcc/YtgYFI6dBicVpL+isKGZ83+jNUl3ospqmiP2C/fasi08FRClcLTd7gddmKkzmKmbiJVPs0Do/CzCeW7jmPHpmKWdu6y86XDuSCIgFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4o/IYRWg; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4o/IYRWg"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4349ea54db7so229805e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 06:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733150916; x=1733755716; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kuoJI3+9b4DhTXF6MzkEBOqdB10jGfOvJOhA0wuCACY=;
        b=4o/IYRWgqWsh3aBQtisRRAHBYYfsgIg/m/aGNw3koG3+VTvYiXp/DUudHBHN5YtZ8d
         Ju9n1CVyWjrTqrSVghBcoJuQZVnQZOtaIPm/utcZ4PAzNjXpC8lsV0OT3OVMZIQuJJPw
         2LZnThXdjVCPqgPkubJy2VLWnXZvQ115pEjlcPVafURP2fWszvPkSMVjx2ujb/SeVZ8H
         TaFSbPgABqwSMxJgNnNimK/GwWCeWRC4ZCDu4Rfh+8H80S+PeW1HR76LKPPsFz5f+y5u
         z5ykFVFi5Va1AprtoIViWGr8QyqmKUHsEPAhEn1XvfToSNcrfW96zEwz27+WqtZN+nTL
         04aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733150916; x=1733755716;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kuoJI3+9b4DhTXF6MzkEBOqdB10jGfOvJOhA0wuCACY=;
        b=ozEn3DjxzSvEuPNYmlxtGSf/GW/rh7oPvRZaACArEBHod7rLYFa+/J4stG3ihUEWaF
         vTzmR2mz/ch2AG/0pcDJuEXN5isQWVOjJeOonaRe3hbvKnG2ypijkhH8Lx77wt6i7+cH
         NppKvmby6z9+jIP0xN/oDm7hZfIXlJGfMzjXo+Xw98HRtnQ65Znj+HehvGsNnOKCxyER
         jbxjZFGgPKBAQPVoND/RjeiPIInSXjJsmgGp2C7xqwMpCx/51hKj1mqTxT9YM8jN5V22
         H5FKUupCHXr1Z6qdB9ygEFcEpzmbbzsQUHYCFF76XJO/9gL2czeai2uV4hDx873IMYDe
         0jDg==
X-Gm-Message-State: AOJu0YxSo7TYC8nGKaK6axUPEkAuM0XdWOWUy65aUoNyJmAY6xYonu0E
	vHIZYY1iscLlv8eBMvtLPF+RQ5Lsc1FC+jdo+rU2m0M7ol4WnaNl+AEloFjLePw1xvgdd7gG+nd
	Pq59LDlOZIg1w1CxcUNGThQwhxgFud6eRUOIN
X-Gm-Gg: ASbGncvecfTE5SXYPGTFYphM3UcJ7Kh2pByfziNtp1MJskceD7CfrfB0IjnVa44OFUV
	s7YsT8E8KdFJpiOg45tsDoaZsY34IDg==
X-Google-Smtp-Source: AGHT+IH+RHZF5RillqOjxyrN+kl1K9NyowcjP13Axo/IJklX7DvsBhh9bTUsEaXTK8MaqJ0VHpeIHFGvXkvmMGcR8m0=
X-Received: by 2002:a05:600c:6a88:b0:42b:a961:e51 with SMTP id
 5b1f17b1804b1-434b0401690mr4828385e9.0.1733150916001; Mon, 02 Dec 2024
 06:48:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com> <20241128123515.1709777-15-tabba@google.com>
 <864j3nv9tk.wl-maz@kernel.org> <CA+EHjTyXj6NhUcxTfER=zPz3VOtd+HgqpfmyfR88cVyiXoxqwA@mail.gmail.com>
 <CA+EHjTysFaaxGBo212e8kSHi_VkpXx6N6ddxwB0UGC6bSoK0gA@mail.gmail.com> <86v7w2taxq.wl-maz@kernel.org>
In-Reply-To: <86v7w2taxq.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Dec 2024 14:47:59 +0000
Message-ID: <CA+EHjTyzAcMPspvO8cAp=0_-i6hJHw2y--eieNkjZk2AuzG5FQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] KVM: arm64: Convert the SVE guest vcpu flag to a
 vm flag
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, james.clark@linaro.org, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Dec 2024 at 14:29, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 02 Dec 2024 12:57:44 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Sun, 1 Dec 2024 at 16:01, Fuad Tabba <tabba@google.com> wrote:
> > >
> > > Hi Marc,
> > >
> > >
> > > On Sun, 1 Dec 2024 at 12:58, Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > On Thu, 28 Nov 2024 12:35:14 +0000,
> > > > Fuad Tabba <tabba@google.com> wrote:
> > > > >
> > > > > The vcpu flag GUEST_HAS_SVE is per-vcpu, but it is based on what
> > > > > is now a per-vm feature. Make the flag per-vm.
> > > > >
> > > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > > ---
> > > > >  arch/arm64/include/asm/kvm_emulate.h    |  6 +++---
> > > > >  arch/arm64/include/asm/kvm_host.h       | 10 ++++++----
> > > > >  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
> > > > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  2 +-
> > > > >  arch/arm64/kvm/hyp/nvhe/pkvm.c          | 11 +++++++----
> > > > >  arch/arm64/kvm/hyp/nvhe/switch.c        |  8 ++++----
> > > > >  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
> > > > >  arch/arm64/kvm/reset.c                  |  2 +-
> > > > >  8 files changed, 24 insertions(+), 19 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > > > > index 406e99a452bf..ae6d0dc0e4ff 100644
> > > > > --- a/arch/arm64/include/asm/kvm_emulate.h
> > > > > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > > > > @@ -620,7 +620,7 @@ static __always_inline void kvm_write_cptr_el2(u64 val)
> > > > >  }
> > > > >
> > > > >  /* Resets the value of cptr_el2 when returning to the host. */
> > > > > -static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
> > > > > +static __always_inline void kvm_reset_cptr_el2(struct kvm *kvm)
> > > >
> > > > I'd rather you avoid the resulting churn:
> > > >
> > > > static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
> > > > {
> > > >         struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> > > >         [...]
> > > >
> > > > which does the trick at zero cost. It is also more logical to keep the
> > > > vcpu as a parameter, as the per-VM-ness is only an implementation
> > > > detail.
> > >
> > > The reason for the churn (here and below for vcpu_has_sve()), which in
> > > hindsight I should have mentioned in the commit message or as a note,
> > > is that this code is called by the host kernel (e.g., in reset.c), and
> > > by the hypervisor). For nvhe, we need kern_hyp_va(), but not for the
> > > host. Should I gate the va conversion with is_hyp_nvhe()?
> >
> > I spoke too soon. Your suggestion results in less churn, and of
> > course, solves the issue I had with kern_hyp_va.
> >
> > I did have to convert kvm_reset_cptr_el2() into a macro, because it
> > now needs kern_hyp_va(), defined in kvm_mmu.h, which in turn includes
> > kvm_emulate.h. But since it's __always_inline, it shouldn't make any
> > difference in practice.
> >
> > If this conversion to a macro is alright by you, I'll respin this.
>
> If you can convert it to something like:
>
> static __always_inline void __kvm_reset_cptr_el2(struct kvm *kvm)
> {
>         [...]
> }
>
> #define kvm_reset_cptr_el2(v)   __kvm_reset_cptr_el2(kern_hyp_va((v)->kvm))
>
> that'd be great, as it keeps the body of the function as C code, which
> helps with debugging.

Will do, thanks again!
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
