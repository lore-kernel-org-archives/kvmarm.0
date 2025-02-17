Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD0322578B
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739807853; cv=none; b=tFUyIW8P+GZZIFAKBFCT4qYj/udSgMK/AD1Tvw2LUaFO2V7ADDyM2QwJyWLzff/mPryh11vxr8DXM0kRlxYxjph7iGkWQE97VP5otfYFSHq5LLbqZB3/rTO3RW+mwcwGoIouBA6ZgNM3RjG6ejlS2hftWCbmA/dKIPWadVagoh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739807853; c=relaxed/simple;
	bh=yoISy8SAx2ycAIZIYyDBm/+HyqYfNFcYcchha33mJ8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ANSBeebbVQwNlP+bqq4bdc4aaW71PTfprDQ7CLQeeEeaLqa3Wcf0pGjsn+ykxWomZOch3mjk/M5BXYTd5VfcDgXqCiqXKtT4K4CRJbGwyBNbwByVEmSF9gbQF3R2icAMvAfBMAloS/+xSMPmCDPEfdro9HenXlc9RGjsp9eLy9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HpEv68tr; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HpEv68tr"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-471fbfe8b89so65071cf.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 07:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739807850; x=1740412650; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hdwxmEwGAVaWxBcFASmVA+2qnyozZBSbOEWsN4ftwnI=;
        b=HpEv68tr6kBSdmDdBbGmjNG1yHtjKFHqbMRk+z6lNkDe8oiwSgGPvd11ZXgNYZNdr6
         PPpySi9pyC9XpAm0VIARecD6zMiAmD6eGlckuQu9qFUjHJCVU5gHDwDigkRDLICGem7/
         wnJR7UbWs/HTNxkFGIwJ3v2GOOu2q6W+KbUhcL5xUjsx6EjwbMuqeKb9LSTVaQGvZgVy
         S2Cq3fOHgcRsEcid7iuad+i5ou3xhmAgqrkPHJ+TjXwfLjXZ+KPWgGfdnvQmhYgypQU2
         rmXi1QMqjY7YodD43LzPys5AY89uovLGh2JLZXw07+5hHK6L+/DLDW9UjY4dp3NHPqHP
         LBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739807850; x=1740412650;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hdwxmEwGAVaWxBcFASmVA+2qnyozZBSbOEWsN4ftwnI=;
        b=T4L1TgLIc46KKdqznQNmLKi1meapXCuvLOQasY+gEvHlsyDG4j2/VB3Rtp7ERMlsbX
         4H0G4cvnYthBgmL7rzy2EOwREZ/hrTgDKEx9nTfB+K/OU+IXrYBs6JbqVr9oUSTEr/+k
         ZIrSK92c8D0fEy8qbilyOxBdtAOonALCJmxQDQJM/oEhU9XTrPs2XTRsIs6Jb93a3oNw
         2OF2OsH/YidhFRGEPwR7pFiJGBfNsS3Gv9VhCEyWeyj6nTVFoT2zSgFb7SLPl2Q+eXxF
         Oi8UT+GURtX5DMt1cZcAR21zSO59nLq0q/AikOGkOv2n0fKijz8g/y7U3nbXUld/j5m5
         ckHA==
X-Gm-Message-State: AOJu0Yyfo41FyK1krr5mn8C7io4ir5NZww8pvKTJCo5kiuRBKwAns1yF
	arJkjylaLNw3p7Tu21XmqfkqJEFM3psj8KNDcnq7DLQoRNLrK23Vx0ZFC3e9akRVUUBoi/8SFJq
	5hJ5ncS7zbm+OY6gm87eyZNoxXxBWmmkcCcwm
X-Gm-Gg: ASbGnctb2r+OlNryws+Rhw6O9koPQ7crPLjaECrjeDMzaaN0Axoj0HGXbGX7JaWlZKK
	kaGfm3jxUb4UksTmKeaWjvEaDH/zNBGe8visffvYz3I83c+a/2D6NeETSQo+MmFmTkBFwY+w=
X-Google-Smtp-Source: AGHT+IFYjVjyk51aYuA0xgEP1r81NXa4uUmrTwcuX1LAIFx2e5X6SYCkOVaP2cczo18FT3m0bA6e4juvCYH94Jd75dc=
X-Received: by 2002:a05:622a:54e:b0:471:badd:bd2f with SMTP id
 d75a77b69052e-471dc6602d2mr7426021cf.0.1739807850116; Mon, 17 Feb 2025
 07:57:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250214150258.464798-1-tabba@google.com> <20250214150258.464798-4-tabba@google.com>
 <20250217153031.GA16398@willie-the-truck> <CA+EHjTyOk_VpcTaD-VsH9X7KjpPKWu-HyVE3EEV+rzhnHar84A@mail.gmail.com>
In-Reply-To: <CA+EHjTyOk_VpcTaD-VsH9X7KjpPKWu-HyVE3EEV+rzhnHar84A@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Feb 2025 15:56:53 +0000
X-Gm-Features: AWEUYZmLG6GraU3YF5iPhS1GFxu1UOebrI4yee2IulD_nEJ1kmtP1NSNIbx20Uo
Message-ID: <CA+EHjTzLW1HiiPr+=vStMYJcYEHUBFcEy_YMT3uJuLRA3zDzEw@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Create each pKVM hyp vcpu after its
 corresponding host vcpu
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Mon, 17 Feb 2025 at 15:41, Fuad Tabba <tabba@google.com> wrote:
>
> Hi Will,
>
> On Mon, 17 Feb 2025 at 15:30, Will Deacon <will@kernel.org> wrote:
> >
> > On Fri, Feb 14, 2025 at 03:02:58PM +0000, Fuad Tabba wrote:
> > > Instead of creating and initializing _all_ hyp vcpus in pKVM when
> > > the first host vcpu runs for the first time, initialize _each_
> > > hyp vcpu in conjunction with its corresponding host vcpu.
> > >
> > > Some of the host vcpu state (e.g., system registers and traps
> > > values) are not initialized until the first time the host vcpu is
> > > run. Therefore, initializing a hyp vcpu before its corresponding
> > > host vcpu has run for the first time might not view the complete
> > > host state of these vcpus.
> > >
> > > Additionally, this behavior is inline with non-protected modes.
> > >
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h      |  2 +
> > >  arch/arm64/include/asm/kvm_pkvm.h      |  1 +
> > >  arch/arm64/kvm/arm.c                   |  4 ++
> > >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  6 ---
> > >  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 54 +++++++++++++++-----------
> > >  arch/arm64/kvm/pkvm.c                  | 28 ++++++-------
> > >  6 files changed, 53 insertions(+), 42 deletions(-)
> >
> > [...]
> >
> > >  static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
> > >                             struct pkvm_hyp_vm *hyp_vm,
> > > -                           struct kvm_vcpu *host_vcpu,
> > > -                           unsigned int vcpu_idx)
> > > +                           struct kvm_vcpu *host_vcpu)
> > >  {
> > >       int ret = 0;
> > >
> > >       if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> > >               return -EBUSY;
> > >
> > > -     if (host_vcpu->vcpu_idx != vcpu_idx) {
> > > -             ret = -EINVAL;
> > > -             goto done;
> > > -     }
> > > -
> > >       hyp_vcpu->host_vcpu = host_vcpu;
> > >
> > >       hyp_vcpu->vcpu.kvm = &hyp_vm->kvm;
> > >       hyp_vcpu->vcpu.vcpu_id = READ_ONCE(host_vcpu->vcpu_id);
> > > -     hyp_vcpu->vcpu.vcpu_idx = vcpu_idx;
> > > +     hyp_vcpu->vcpu.vcpu_idx = READ_ONCE(host_vcpu->vcpu_idx);
> > >
> > >       hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
> > >       hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
> > > @@ -687,27 +689,28 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
> > >               goto unlock;
> > >       }
> > >
> > > -     idx = hyp_vm->nr_vcpus;
> > > +     ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
> > > +     if (ret)
> > > +             goto unlock;
> > > +
> > > +     idx = hyp_vcpu->vcpu.vcpu_idx;
> > >       if (idx >= hyp_vm->kvm.created_vcpus) {
> > >               ret = -EINVAL;
> > >               goto unlock;
> > >       }
> > >
> > > -     ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu, idx);
> > > -     if (ret)
> > > +     if (hyp_vm->vcpus[idx]) {
> > > +             ret = -EINVAL;
> > >               goto unlock;
> > > +     }
> >
> > I'm not sure how much we care at EL2, but it looks like there's a
> > potential spectre gadget here given that 'idx' is now untrusted.
> > Perhaps chuck something like:
> >
> >         idx = array_index_nospec(idx, hyp_vm->kvm.created_vcpus);
> >
> > before indexing into 'hyp_vm->vcpus[]'?
>
> I'll add that when I respin.

pKVM is riddled with these kinds of accesses (e.g.,
get_vm_by_handle(). It might be better if I address this in a separate
series.

Cheers,
/fuad

>
> > Either way:
> >
> > Acked-by: Will Deacon <will@kernel.org>
>
> Thanks,
> /fuad
>
> > Will
