Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B921224882
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739806910; cv=none; b=JU/9LC+ciG+ZSVe0DcoojA82qgnAsYIcBKWmhrzjcSQLfVW0w0B74JrZzWOcdo6JhiJo4zLj0qZGmq9xLyHQEDZ7Kpqg15l39d8suNK2oQXvZKVArTGx+fKhkL1QQWJ9SERPiEKMivOqvT00/Lm0/liUNrKLpxcOGkBaJaJdWh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739806910; c=relaxed/simple;
	bh=6/0BDYb69mma+FxRHG0m1fyDcxKaSxzRuXugMsnTeSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RkyEk0YlJrdA6Xb15dQFFxOHRXAjrfH2bNN1fwcis1EjJEo6XXpRfvC/cPO5+27UAC6ty15gkcwzUqUUESXupIZ7P9u1dYt74qKvOgbq0ggAJAS5HlNcfMY1L3OcKBIMUkwJOu8Y/CaVB/4O8fzgDNOEn8xUXuMuuH249dQAWpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZgFWwacl; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZgFWwacl"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-471c9947bb5so529911cf.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 07:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739806908; x=1740411708; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s5Qn3Izea1XkIFjORxwyxiB7Rz8OfU+yXngImMLSszU=;
        b=ZgFWwaclHOrivEicwiMozfRpfwo9IvXFlMQJ92MEtFq5FcL7QQRKFgVHr2elbU97Pr
         1GiQxeXTh/n4Nluh3ZQUfy7AyBH+EYQ3K818R/CepoSxQnZqjij/+5BAbsf26FB8H5qY
         ql47A4ZXvS7ovZyqaChk4Z7FD9up1WwgL1BB2Rz/GXqMEB7qmPvVEulbt8enocVZyCAK
         5TCWtzo5OAskxUR0fHfXPk0Q/uXWPvWcIF7iOcNtQxM4yAXG7sa9XZWyySMFaICmXc4x
         sibl0FL35KV1WrGvAhFlehceofbd005rQUnieugldAm2O//Lhtlaw/SIbjeN3z+8qx9t
         Isng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739806908; x=1740411708;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s5Qn3Izea1XkIFjORxwyxiB7Rz8OfU+yXngImMLSszU=;
        b=RAlgZ+dr/ItBhekvw0NLEPdYd4CdXm3tLQ6CCcNWH01v8rjqJSsZE4qUKjGJCtNkCn
         n6L0c5gy4qLvBBLxVNy5H9UvojNndCXU+2vLOzvLDEG/0s13Fqn3ip03rJo/VLqylaST
         g+mIPJ5pah36pcLHU3GIREP+yGyKCNRqkf0Y/vfd2FVbPxHDM80CIs6IamC42AS1L4g+
         rlqme7FrNvAqiYGphQ7nDD1r3c4Aopk9uxZoNzFbLvY47BYfAam9EcYvyUc7wiw0C+Ab
         xWULwk/Jjevk1qF8336qaJlWb5W4o290cYd++e6kUzzFBvr+QP6QKuho7jffZO0wvIRI
         A92A==
X-Gm-Message-State: AOJu0Ywy4fPnXO/ZvGqmT8WBqXGdqbyzMDDVwvYzxTzFkG/h4yDRXmzn
	ZllrM1Rix6irisA+MLQFyhpmf/x2a+AT8zciFiXbqqCVOTIqZuK8KDtxeivLxbBZZy3oZZaM4VG
	a8i5HjbDNyHmr4pHBGAIrDBQ/2r1aQLQdrmcA
X-Gm-Gg: ASbGncuScHu/wwTkwbU6sXbTtu/MnH5QdegX4AF+jX2KqTp4g2/vuQkLHlu5TTQRDLG
	Pwl1k7QBnQbY0sAMZV5wAsmExJUw3nWm/AGbdRtNZBib6Se+1hNQ7PkvdheOJ3j0NCU/jGbs=
X-Google-Smtp-Source: AGHT+IEV69uZM3laRSzjCGKBZlseoILARY1eAIAe+bkM661+fIqBeto74KePJaR81k8/nxiNWACCqrXZjC0ZbFzBnwY=
X-Received: by 2002:a05:622a:1899:b0:467:7c30:3446 with SMTP id
 d75a77b69052e-471de0b5ed9mr6696061cf.25.1739806907930; Mon, 17 Feb 2025
 07:41:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250214150258.464798-1-tabba@google.com> <20250214150258.464798-4-tabba@google.com>
 <20250217153031.GA16398@willie-the-truck>
In-Reply-To: <20250217153031.GA16398@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Feb 2025 15:41:10 +0000
X-Gm-Features: AWEUYZkFTQSHdZxvo_v7HWx6s0y_SqFFArebD5bJZjqRw5mfCRmh2Sc8vDT1ZT8
Message-ID: <CA+EHjTyOk_VpcTaD-VsH9X7KjpPKWu-HyVE3EEV+rzhnHar84A@mail.gmail.com>
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

On Mon, 17 Feb 2025 at 15:30, Will Deacon <will@kernel.org> wrote:
>
> On Fri, Feb 14, 2025 at 03:02:58PM +0000, Fuad Tabba wrote:
> > Instead of creating and initializing _all_ hyp vcpus in pKVM when
> > the first host vcpu runs for the first time, initialize _each_
> > hyp vcpu in conjunction with its corresponding host vcpu.
> >
> > Some of the host vcpu state (e.g., system registers and traps
> > values) are not initialized until the first time the host vcpu is
> > run. Therefore, initializing a hyp vcpu before its corresponding
> > host vcpu has run for the first time might not view the complete
> > host state of these vcpus.
> >
> > Additionally, this behavior is inline with non-protected modes.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h      |  2 +
> >  arch/arm64/include/asm/kvm_pkvm.h      |  1 +
> >  arch/arm64/kvm/arm.c                   |  4 ++
> >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  6 ---
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 54 +++++++++++++++-----------
> >  arch/arm64/kvm/pkvm.c                  | 28 ++++++-------
> >  6 files changed, 53 insertions(+), 42 deletions(-)
>
> [...]
>
> >  static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
> >                             struct pkvm_hyp_vm *hyp_vm,
> > -                           struct kvm_vcpu *host_vcpu,
> > -                           unsigned int vcpu_idx)
> > +                           struct kvm_vcpu *host_vcpu)
> >  {
> >       int ret = 0;
> >
> >       if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> >               return -EBUSY;
> >
> > -     if (host_vcpu->vcpu_idx != vcpu_idx) {
> > -             ret = -EINVAL;
> > -             goto done;
> > -     }
> > -
> >       hyp_vcpu->host_vcpu = host_vcpu;
> >
> >       hyp_vcpu->vcpu.kvm = &hyp_vm->kvm;
> >       hyp_vcpu->vcpu.vcpu_id = READ_ONCE(host_vcpu->vcpu_id);
> > -     hyp_vcpu->vcpu.vcpu_idx = vcpu_idx;
> > +     hyp_vcpu->vcpu.vcpu_idx = READ_ONCE(host_vcpu->vcpu_idx);
> >
> >       hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
> >       hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
> > @@ -687,27 +689,28 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
> >               goto unlock;
> >       }
> >
> > -     idx = hyp_vm->nr_vcpus;
> > +     ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
> > +     if (ret)
> > +             goto unlock;
> > +
> > +     idx = hyp_vcpu->vcpu.vcpu_idx;
> >       if (idx >= hyp_vm->kvm.created_vcpus) {
> >               ret = -EINVAL;
> >               goto unlock;
> >       }
> >
> > -     ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu, idx);
> > -     if (ret)
> > +     if (hyp_vm->vcpus[idx]) {
> > +             ret = -EINVAL;
> >               goto unlock;
> > +     }
>
> I'm not sure how much we care at EL2, but it looks like there's a
> potential spectre gadget here given that 'idx' is now untrusted.
> Perhaps chuck something like:
>
>         idx = array_index_nospec(idx, hyp_vm->kvm.created_vcpus);
>
> before indexing into 'hyp_vm->vcpus[]'?

I'll add that when I respin.

> Either way:
>
> Acked-by: Will Deacon <will@kernel.org>

Thanks,
/fuad

> Will
