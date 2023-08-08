Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347261B7C3
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 16:46:42 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4036bd4fff1so6621cf.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 09:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691513202; x=1692118002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5cUkGvBinqrQEB7Ikj5Ug8tOjVRS6TZ8gJMeTTJk/U=;
        b=MEkJuLCCzNqujltO/2hEBF2IZ8JWjwedY1wVwMFzuxok1cUuORptjOLuKh3jhngmbg
         OszqqJ2FqeHwHlyz5sFzOsmGpkD/3QVma5URjR1jvw5cArnTbvACynfjopC1KnzTKMyP
         LXtBLl+32K1Fk6s33cihV9KIyTralnRC9ZedyF08T1fha1zO1t3FCcIBW73zDo4JKWLl
         vJ8fFQFUq8E0fvlL0hxqbxzzMtCdpELvpY0iRowFTc93kwORZVBnOlcAefdf1Jr8F9Be
         CvcMGmnUR49gQaXX06ieIIW2SXQ7B8dXiV4ZHtlX/+YS3IaUh5D5bc+PU8DnZ2XozQpU
         wELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691513202; x=1692118002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e5cUkGvBinqrQEB7Ikj5Ug8tOjVRS6TZ8gJMeTTJk/U=;
        b=Fu1zatWfdPhmz5phkH+J7Y+gXgltKSofoGsWiikLP/q7HzVrJb1DrRIAr/tSw29s5O
         oEdrqGxHP1Ge79EatiVJXMIpA5Jkjxjr0pUdkmBDr+TKeUIlrVR9X/dBjFAQ7qnIsAiJ
         Jt9c5xgrxlmmPiS33WlLIyjYgJkr/B754APSFzkQAmbRjyWdQ79ea3mDgOL4Ql7zhY41
         UWgEtIdYEc7YTYBMUxOngVb7BFNapYkwvvGn2BqFcok++I6TbiEjqdhgVBqNTqAtM/Ai
         /eEhVqXelHd4T7NCJe8nCKXDgAYDvMXuxWs7fRaE6OxRISDlyDW0xEuofrRAaNlon0Ut
         bpmg==
X-Gm-Message-State: AOJu0YyJuxF5LqcR5Vd7+RjgWggOzVxMKMK9RT9WKAW8jQZwqsae5Gh/
	qCExf0nKkvTnUI1ZJZ2C+UVCuQ/l9bYRGzcYcR2VZg==
X-Google-Smtp-Source: AGHT+IF4HzuUwWkMUsGsweRhCwPAzuoceDkfaSL4D3AD1VB/sy6hMsEVitqG7c6zwkKT6LNm7NuGpkKpwVJ6D73FF6Q=
X-Received: by 2002:a05:622a:11d3:b0:40f:dc70:fde2 with SMTP id
 n19-20020a05622a11d300b0040fdc70fde2mr2783qtk.26.1691513201715; Tue, 08 Aug
 2023 09:46:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-3-rananta@google.com>
 <87tttpr6qy.wl-maz@kernel.org> <ZMgsjx8dwKd4xBGe@google.com>
 <877cqdqw12.wl-maz@kernel.org> <CAJHc60xAUVt5fbhEkOqeC-VF8SWVOt3si=1yxVVAUW=+Hu_wNg@mail.gmail.com>
 <CAJHc60zN-dc2E-fS7fuXgkrfGD9bqW6tMy2GRZxbHOeZv0ZOBw@mail.gmail.com>
 <ZNJaPxTtPRCv0HOl@google.com> <CAJHc60yiGnVc=ysdOaNemWaDpTBSk02mRLenK3sN2XtN_Cp98g@mail.gmail.com>
 <fc430350dd7d8ac664054a99f1e452c1@kernel.org>
In-Reply-To: <fc430350dd7d8ac664054a99f1e452c1@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 8 Aug 2023 09:46:30 -0700
Message-ID: <CAJHc60zspGChscVTj5K31=gzRmFu5d++FZNLz8eaZMxfOV+KAQ@mail.gmail.com>
Subject: Re: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
To: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 8, 2023 at 9:43=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2023-08-08 17:19, Raghavendra Rao Ananta wrote:
> > On Tue, Aug 8, 2023 at 8:07=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com>
> > wrote:
> >>
> >> On Fri, Aug 04, 2023, Raghavendra Rao Ananta wrote:
> >> > On Wed, Aug 2, 2023 at 4:28=E2=80=AFPM Raghavendra Rao Ananta
> >> > <rananta@google.com> wrote:
> >> > >
> >> > > Sure, I'll change it to kvm_arch_flush_vm_tlbs() in v8.
> >> > >
> >> > While working on the renaming, I realized that since this function i=
s
> >> > called from kvm_main.c's kvm_flush_remote_tlbs(). Do we want to rena=
me
> >> > this and the other kvm_flush_*() functions that the series introduce=
s
> >> > to match their kvm_arch_flush_*() counterparts?
> >>
> >> Hmm, if we're going to rename one arch hook, then yes, I think it
> >> makes sense to
> >> rename all the common APIs and arch hooks to match.
> >>
> >> However, x86 is rife with the "remote_tlbs" nomenclature, and renaming
> >> the common
> >> APIs will just push the inconsistencies into x86.  While I 100% agree
> >> that the
> >> current naming is flawed, I am not willing to end up with x86 being
> >> partially
> >> converted.
> >>
> >> I think I'm ok renaming all of x86's many hooks?  But I'd definitely
> >> want input
> >> from more x86 folks, and the size and scope of this series would
> >> explode.  Unless
> >> Marc objects and/or has a better idea, the least awful option is
> >> probably to ignore
> >> the poor "remote_tlbs" naming and tackle it in a separate series.
> >>
> > Sure, I think it's better to do it in a separate series as well. I'm
> > happy to carry out the task after this one gets merged. But, let's
> > wait for Marc and others' opinion on the matter.
>
> Yeah, let's punt that to a separate series. I'm more interested in
> getting this code merged than in the inevitable bike-shedding that
> will result from such a proposal.
>
> Raghavendra, any chance you could respin the series this week?
> I'd really like it to spend some quality time in -next...
>
No problem. I'll send out v8 by today or tomorrow.

Thank you.
Raghavendra
> Thanks,
>
>          M.
> --
> Jazz is not dead. It just smells funny...
