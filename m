Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B149258CE5
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781248599; cv=pass; b=r81LKDmX0iNO1OYbRz79lM1VK31yZ2+XeYyFvzNA6P/26NZ9fBQXUfHBc+R0/MTBgOMfNOrRk9sUQ9qyR2OM1w0lwLQa6BUsH76jHd5SrYPDSbo12hF+/3sDiQI4YaSZ+DRRQFQt2N8JEQjlCdHnzooXRtzR2M9jLPtcuVJitTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781248599; c=relaxed/simple;
	bh=2RpOwM356Ra4heRzlkvIzismb6CAlUXXw50OyZYWnD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L5ZL1NA/GwPdiUbeG2dwGf+uQ/xXZkKcJLiQw2jHTfn8Uf8Pfxp4wZYYunsu5RQX93/EIe8CCN6tfOyGOxDlqkloPio4k0HSSyFkCqyW2uZZEvstmaK/3EuimXj+tkom2uCwb/5BaY5FVXGV/3MnnD/xgXDQgRqb21ne9+OTsOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RejBmRsH; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RejBmRsH"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51765331535so269751cf.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 00:16:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781248597; cv=none;
        d=google.com; s=arc-20240605;
        b=RL3ym84IQP5py7SBcHGO9vgR4snNiKqpAqxLi9XQGysYJIuVFXQB2Pa3A/yb6FpBZ6
         pvlEGbFZ9oQ353GsOGotD9KfmxQWQzdvSPbTiCdXoC2VmVN/WOS22vctinH3+jW49vI6
         JMdIGghDZc+82TGoHo3iyIxqBvACMIZl1TLvAJo21ResSr7PMcL51d/iizvTrP/az0wP
         K8QulNDwFRSwFlEspPKDD8W6GGyxbYNFhpxDNB7qEf5U7CVOySDsfVwdeEFXdu12j+34
         R5RVkFNfzIFnLyV9dE5rDGta6pEHXIWx6vff5yBQWxVxivERNjCGi9kcFuUuN52VFtse
         Yf8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jndZWBgvBmvORiRm7Is8CyoTvdeDfrMHLX0XtX0TpEs=;
        fh=KaiTqpEov7fPUST8FOXshJlDgv4m4eInFY6jXbsH8OQ=;
        b=kjwYVgUjwQlGEI9DTJhsA6zhRU3SFbyrPx/2va9RPzcfVj3hPV5BvJVVH6geDEanLd
         pZrVx8H7YADuYcnxDE8vG960isg0mysKT2C++wb0AgzikdaLC15yrTl2lin4Pp8zMMgU
         l8MQKk+rVoBECClwD81hAN2JYS97s+ZCEOoi0KI4e5o+BB1bIvta824AHxyuvMzwHVgP
         IvDMT/wPjnxsVayNvAY8oLEIx6ThqnSo1CeJqFINPqH4mq+xQdYsexVQR4zM3CwtBpjF
         1hGdo8FbUfMwI2eqrUPApf2YetT4kA5V1FOX7g+ZEjtbhP2CjW25HefcI1fhrIeUYJUb
         lpMA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781248597; x=1781853397; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jndZWBgvBmvORiRm7Is8CyoTvdeDfrMHLX0XtX0TpEs=;
        b=RejBmRsHWkd89VBX/mLk4ur8mMEGJ5TkBAfQwTihaknDRdFkF4bXJ6Yf/QjxdyrY1A
         bSrujN9kI2ap7gx2L19pzb0oK5VjrnDp466sG1Ohq/GWFKIJJrQrU8hdlaRiHMbJluhH
         vFBiYPw1ptYT3Ss2+xi2/8NDdDepanlKqLMdM+HTl5pmF55bLguCqfT4GL86sg9NTgiW
         W+claYvcZmgQQod3E4EqXn5P7BqQdkrV+oHONGnY2bOxl0vCP8EJ43FNW6B58HCBgDa2
         69hWDhZ6DNZWij7ZgDX8H8WV6kDHqwqo9x+Du6fpWGD7OoaXhBfHA2K+v5b5/bJXfoVn
         k54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781248597; x=1781853397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jndZWBgvBmvORiRm7Is8CyoTvdeDfrMHLX0XtX0TpEs=;
        b=ZxWdZhOpMxCE0Jm4isRPGMkle0AwXqtTCfvnH+jAR6t9Q3EU5/KL0WpUG8h/HaB3Zc
         cU8KniG6Crh8EDprqjgudin+qzg0VUdZRyDeGW1gx7eZnANeKnwv8LeheCCnJgJJY/RI
         wEsFe6B48B+YuINN4Dd8aJTL11m2LfJImUzpE8wBPhvRNklW0o5ocqwLZggXa2uoncxn
         Cce1bjO4XYCRiJrhKPxKsQx8Y1FOUSlLKmTmAw4QOMHaTLRC/Zsi95k+tEef8O3D5aZg
         uWsvUlQuizA08sSYamxoq4ttWi6kWsFGdKgbXpdMv6IPasVX7TB5Bb0zNc6J2bIUD6LL
         Kuhg==
X-Gm-Message-State: AOJu0YzqHfDCR1G236Cj0PcYEr7gZH3kbSPHJXoRakGGl+sHx7RhPLiD
	dPSkS9JLaFYTcujEKINgnG6LnJHxoCU/fsEgoz/pHgAie14V6xfuIl63qn3kaEC4qcys4rCUgkK
	ZLZlnqrtzh/VQz9BpjrO9OJvjuZOOM/zS3PAEBdlD
X-Gm-Gg: Acq92OHRQ3s/CiKSwtJaJEFa8WIbTnnYpVHl+r1mLp0w9x15Y4GYYA0ZkjGtVANY003
	+bbtW0yf6wkckQtRXNPa9E2lROeCreZSokD+Rtn8/d1woqhmsSf5qzEz1r3OkGGaoooScSJ322H
	ua9AmDTB3OMd8VfTpWvBTeZnAJ78Eiivzkc27GALOO9jF2nmr3SKm6+ubbcpmbE3zaXbCy7OoN1
	PqPLt5Z+bKMchcRGo+UzTLp/r8wonIN5aeMGzTEWMrJS2H0vtNhlQnEGzmIOLF6BS9606oPsIev
	hYqnjMuM1Cc23UCo4As=
X-Received: by 2002:ac8:7d0a:0:b0:516:4f62:85ef with SMTP id
 d75a77b69052e-517fb16d601mr5942741cf.20.1781248596399; Fri, 12 Jun 2026
 00:16:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-9-tabba@google.com> <20260612070819.64FE01F000E9@smtp.kernel.org>
In-Reply-To: <20260612070819.64FE01F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 12 Jun 2026 08:15:59 +0100
X-Gm-Features: AVVi8Cc4RzJaP_zaKC2c5KRc_qZk_c-svVjRGNeO-CiUJOo8hWtSYF-SB8GrSfI
Message-ID: <CA+EHjTzVBXakaKnjAqABOBmnqtk5T2-Z9kr3TcWSkPVoAo4O4Q@mail.gmail.com>
Subject: Re: [PATCH v1 08/11] KVM: arm64: Add host and hypervisor vCPU lookup primitives
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Sashiko my old friend,

I came prepared for you...

On Fri, 12 Jun 2026 at 08:08, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] flush_hyp_vcpu() incorrectly copies MDCR_EL2 from the untrusted =
host context for protected VMs, violating EL2 security guidelines.
> --
>
> commit 11498ed516d4ebc65b4ad00086974239ee0e2eb4
> Author: Marc Zyngier <maz@kernel.org>
> KVM: arm64: Add host and hypervisor vCPU lookup primitives
>
> This commit introduces primitives to translate a host vCPU into the
> hypervisor's address space. It refactors handle___kvm_vcpu_run() to use
> these new lookup primitives.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
> > @@ -214,23 +245,16 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_=
context *host_ctxt)
> >                       goto out;
> >               }
> >
> > -             if (!hyp_vcpu) {
> > -                     ret =3D -EINVAL;
> > -                     goto out;
> > -             }
> > -
> >               flush_hyp_vcpu(hyp_vcpu);
>
> [Severity: High]
> This is a pre-existing issue, but does flush_hyp_vcpu() incorrectly copy
> mdcr_el2 from the untrusted host context for protected VMs?
>
> Looking at flush_hyp_vcpu() in arch/arm64/kvm/hyp/nvhe/hyp-main.c:
>
> static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> {
>         struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
>         [ ... ]
>         hyp_vcpu->vcpu.arch.mdcr_el2 =3D host_vcpu->arch.mdcr_el2;
>         [ ... ]
> }
>
> According to the pKVM EL2 Security and Trust Boundary guidelines, trap
> configuration registers like mdcr_el2 must be initialized in an EL2-priva=
te
> context for protected VMs. They must not rely on values written by the ho=
st.
>
> Because host_vcpu resides in untrusted host memory, this unconditional
> assignment could allow a compromised host to overwrite the mdcr_el2
> configuration of a protected VM. This could potentially allow the host to
> manipulate guest debug exceptions and break guest confidentiality or
> hypervisor isolation.

The assignment is not unconditional. It is inside the
`if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))` guard (line 607) and only
executes for non-protected VMs.

For protected VMs, mdcr_el2 is initialized at vCPU-init time by
pvm_init_traps_mdcr() (pkvm.c) and is never overwritten from host
memory on the flush path.

Cheers,
/fuad

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612065925.75=
5562-1-tabba@google.com?part=3D8
