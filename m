Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE1F34CD8
	for <kvmarm@lists.linux.dev>; Tue,  6 Aug 2024 18:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968094; cv=none; b=HVYMKLwq8v9DB1qSP7cEpueoNPwrZNeybf+7RxqTuvekR+8tBf02juCI9niiJnlsKvYdPMbn/0IpF1pb/Qr56QwqPJAuSTgCnlqEiqPiKzXzyOdcAadAIos1YVea5iVLLaydQdyw6+gPkbLUyYUoRFC7WpQ6ElXTtpFHExclh0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968094; c=relaxed/simple;
	bh=nbOH63i1r/yo44GYJ2h3kR6UlpygqBW02KmvGZREjcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T8SX+zPyK2stt2zn4U40a4yw2v9qfF/mY7iXevjjCg+UxVwQL2LYzUYxBioW9aRUh2ElXuO9uWe42NMQBaSavuv5ZXXIJ6Oy+2BYkz7cY70ovs+In055qY2H2JMPWN4HFpzfPbXB3hmfjrABq/y0xDxYohk+9Cm+E0y5jYCtyAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EO5oMAGf; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EO5oMAGf"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-26875acdf72so552020fac.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Aug 2024 11:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722968091; x=1723572891; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFdjbs2mjIASOsCu96qW8fLgpB9sbXImHOr5xadmr5E=;
        b=EO5oMAGferSdOdJQxcKP48bx97cE2yuXAu4oOdboya9d7gAeivehe26G3cmiMgAA8O
         7j3t+ydlrO4zctOJFUxmHEJqduXNQD2998BEY8q7BKWtli01Dxx1VQyUPgcu+FtOdqCr
         ekFd46VhWdQy+o0oOQupx29/sPTS2nHZ3pDnvtallDgjD1pGFRLmrPo9X5OwKrdS8wR/
         e/CTCeQstOG3GutnybunyZE9uzV8UZzQJqv5G7EPYPIhX9tYJLpRN9mjjMquY0Czykpa
         5AEt+oPd6i5TzvyqVTcrE6BBnGzUMALzRPTRjY5IytV+rzb5h9W+gDWzU+9wQeytiK8T
         CovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722968091; x=1723572891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFdjbs2mjIASOsCu96qW8fLgpB9sbXImHOr5xadmr5E=;
        b=oP9PFZyrTayTn/+6aaBG+FXFr+XraLcx4YyEVnvXRAWy9oW5XOLwghmcJO56cF159A
         FDgh2tsTpqi7ug1wUa7UjtDcbSDTael2jO6CPxZ7KLEzCnkmeVb/KOARg8vecZ1vyirL
         diB+P1jQ2LpCBfWrgAYHVnWAyq0RHZ4s4MTTf7GZHTHeCCKN05qhJmUxbLv7kMsVI3pc
         APZ8u17OkUGxs65kyjCBaS8JFaAQmQ7nYHtrp+lGWiHSUaB9OQ+jK/JQSJHHl+rZN5sx
         Wzpmr/8isp8rC9ZJgcwMQwQAG5OhOY7YMMxflzwfyTrrQErxr1okMX071OQd5a1s4P/W
         EjCg==
X-Forwarded-Encrypted: i=1; AJvYcCX9Iw7P2LcEwSts7Jt03o65EE5XP/rX+wn6JFGQ73Mw2wQye8sj/5xqJMOna8EkHz6nHzQ8EVepQhVSha2I4Ydfm+MsNBtC
X-Gm-Message-State: AOJu0Yzp2cRYq/019XgnirZyOTNK2FjeIaxib+rPs9ag6yz88fbb/4Vk
	rzmdH+Ffe6dsueRuZylyWRUk6yYvALEuhDxcUrp7oEWomIHVWfVl1Xtb2tb2hSZKLsIRbYW9yeA
	p/CHJle8Cavl1790KB0vjCtwD1PPSc1DakCwl
X-Google-Smtp-Source: AGHT+IFu4ku3WutNT7glrafGrvIvbfxBCcvM0b4ZV/axE4JgynlazXi+vp9yAoARE88Q8l5LZbFYEorYd+u/vifTLrw=
X-Received: by 2002:a05:6870:b61b:b0:254:a753:d1c0 with SMTP id
 586e51a60fabf-26891ece96fmr20000977fac.48.1722968091357; Tue, 06 Aug 2024
 11:14:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com> <20240802224031.154064-3-amoorthy@google.com>
 <ZrFXcHnhXUcjof1U@linux.dev>
In-Reply-To: <ZrFXcHnhXUcjof1U@linux.dev>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 6 Aug 2024 11:14:15 -0700
Message-ID: <CAF7b7mouOmmDsU23r74s-z6JmLWvr2debGRjFgPdXotew_nAfA@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Declare support for KVM_CAP_MEMORY_FAULT_INFO
To: Oliver Upton <oliver.upton@linux.dev>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 5, 2024 at 3:51=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> The wording of the cap documentation isn't as relaxed as I'd
> anticipated. Perhaps:
>
>   The presence of this capability indicates that KVM_RUN *may* fill
>   kvm_run.memory_fault if ...
>
> IOW, userspace is not guaranteed that the structure is filled for every
> 'memory fault'.

Agreed, I can add a patch to update the docs

While we're at it, what do we think of removing this disclaimer?

>Note: Userspaces which attempt to resolve memory faults so that they can r=
etry
> KVM_RUN are encouraged to guard against repeatedly receiving the same
> error/annotated fault.

I originally added this bit due to my concerns with the idea of
filling kvm_run.memory_fault even for EFAULTs that weren't guaranteed
to be returned by KVM_RUN [1]. However if I'm interpreting Sean's
response to [2] correctly, I think we're now committed to only
KVM_EXIT_MEMORY_FAULTing for EFAULTs/EHWPOISONs which return from
KVM_RUN. At the very least, that seems to be true of current usages.

[1] https://lore.kernel.org/kvm/CAF7b7mrDt6sPQiTenSiqTOHORo1TSPhjSC-tt8fJtu=
q55B86kg@mail.gmail.com/
[2] https://lore.kernel.org/kvm/CAF7b7mqYr0J-J2oaU=3Dc-dzLys-m6Ttp7ZOb3Em7n=
1wUj3rhh+A@mail.gmail.com/#t

> > -:Architectures: x86
> > +:Architectures: x86, arm64
>
> nitpick: alphabetize
>
> >  :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
> >
> >  The presence of this capability indicates that KVM_RUN will fill
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index a7ca776b51ec..4121b5a43b9c 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -335,6 +335,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
> >       case KVM_CAP_ARM_SYSTEM_SUSPEND:
> >       case KVM_CAP_IRQFD_RESAMPLE:
> >       case KVM_CAP_COUNTER_OFFSET:
> > +     case KVM_CAP_MEMORY_FAULT_INFO:
> >               r =3D 1;
> >               break;
>
> Please just squash this into the following patch. Introducing the
> capability without the implied functionality doesn't make a lot of
> sense.
>
> --
> Thanks,
> Oliver
