Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A196613AF9
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 16:20:06 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3492e05be7cso153675ab.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 09:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691511605; x=1692116405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U4qeJyFw/gGtNGwwL76+JxYJVDiytKHvIxhzv45xt00=;
        b=FpfAKc3XyP1qtbWBZ1r5mjM0gGcK3mBqFnQDJg0z7xglITdvPvyPFO68jQ0PYtEUYV
         rpNDUVZsipF7n+fTt95dGPnaD80TOiS9mDENUKcX5WGNdhDAs8DDDxN/NVyVQA8z0W5P
         25Tt2lotrmP+TltcpTJg7iP1p/XE1wX+ZjijZoVt+3tKY7bWxnQCNP5LL5wrjU0b2GnI
         aVqQqHH8Ca7ngxoTSYzFdMaiz/kEiqSAcaMrBMBDLXzcSuPFg8+njtH5c8+y240S5y9+
         6uPltBfXOJFc9jALMNDRbM20jjU7jRwikkRkGmhO/qF4WtwZoWK1pjQTtuAfpe/Mq/Sf
         Sg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691511605; x=1692116405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U4qeJyFw/gGtNGwwL76+JxYJVDiytKHvIxhzv45xt00=;
        b=QtRVbAT/M3nW50CxGlEAXNwAUfqR7fy3WOsQSr6GmO/OCQakAi92f9nmh2MhIBAnqU
         JgPCwJPuWfScmUsePs21675KOmfj3YTSmxYnXd71WmaVsK+LkEwvojDXwRGPm0KBVUM/
         l/kDAVCark/TnL+CkhsZEVDO7Su25afPwfNpGGqoIfRCUvPOgJicn/4zIgm+7JdDPKgG
         NITQvffWDZQzms+9ZRDASaIzMHCKlJ7dRjVpy80BfX3ifgj7P5o3GaRtsFKcpbz4SgjD
         CiSSHetN3Bt0pIw8Ni75s0MzlGtmOkwxsvyB4hXP/Lsq2qhdT9KwCr0uQ5Eq76e/nSVa
         FNXQ==
X-Gm-Message-State: AOJu0Ywyf3XYJdBYz9Yv+4BMTO4ZIcOUahfi082M745QurJruaQ/0Zqo
	zo+k3+jBHeh6dIPeVd5HVFzjEM+9wgW8YAe/JI5+KQ==
X-Google-Smtp-Source: AGHT+IE0t1UQBz7Q+Wd5oVDkD3MWrd9+fYCOI5tNf8F86oCLp/yKAd0cOFrr+Qrz9mpkQuy5myhBpG2/Eo43uNjBaY0=
X-Received: by 2002:a05:6e02:156e:b0:33b:4a8c:2147 with SMTP id
 k14-20020a056e02156e00b0033b4a8c2147mr897399ilu.8.1691511605457; Tue, 08 Aug
 2023 09:20:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-3-rananta@google.com>
 <87tttpr6qy.wl-maz@kernel.org> <ZMgsjx8dwKd4xBGe@google.com>
 <877cqdqw12.wl-maz@kernel.org> <CAJHc60xAUVt5fbhEkOqeC-VF8SWVOt3si=1yxVVAUW=+Hu_wNg@mail.gmail.com>
 <CAJHc60zN-dc2E-fS7fuXgkrfGD9bqW6tMy2GRZxbHOeZv0ZOBw@mail.gmail.com> <ZNJaPxTtPRCv0HOl@google.com>
In-Reply-To: <ZNJaPxTtPRCv0HOl@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 8 Aug 2023 09:19:53 -0700
Message-ID: <CAJHc60yiGnVc=ysdOaNemWaDpTBSk02mRLenK3sN2XtN_Cp98g@mail.gmail.com>
Subject: Re: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
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

On Tue, Aug 8, 2023 at 8:07=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Aug 04, 2023, Raghavendra Rao Ananta wrote:
> > On Wed, Aug 2, 2023 at 4:28=E2=80=AFPM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > Sure, I'll change it to kvm_arch_flush_vm_tlbs() in v8.
> > >
> > While working on the renaming, I realized that since this function is
> > called from kvm_main.c's kvm_flush_remote_tlbs(). Do we want to rename
> > this and the other kvm_flush_*() functions that the series introduces
> > to match their kvm_arch_flush_*() counterparts?
>
> Hmm, if we're going to rename one arch hook, then yes, I think it makes s=
ense to
> rename all the common APIs and arch hooks to match.
>
> However, x86 is rife with the "remote_tlbs" nomenclature, and renaming th=
e common
> APIs will just push the inconsistencies into x86.  While I 100% agree tha=
t the
> current naming is flawed, I am not willing to end up with x86 being parti=
ally
> converted.
>
> I think I'm ok renaming all of x86's many hooks?  But I'd definitely want=
 input
> from more x86 folks, and the size and scope of this series would explode.=
  Unless
> Marc objects and/or has a better idea, the least awful option is probably=
 to ignore
> the poor "remote_tlbs" naming and tackle it in a separate series.
>
Sure, I think it's better to do it in a separate series as well. I'm
happy to carry out the task after this one gets merged. But, let's
wait for Marc and others' opinion on the matter.

Thank you.
Raghavendra
> Sorry for not noticiing this earlier, I didn't realize just how much x86 =
uses
> remote_tlbs.
>
> > (spiraling more into this, we also have the 'remote_tlb_flush_requests'=
 and
> > 'remote_tlb_flush' stats)
>
> Regardless of what we decide for the APIs, definitely leave the stats alo=
ne.  The
> names are ABI.  We could preserve the names and changes the struct fields=
, but that
> would be a net negative IMO.
