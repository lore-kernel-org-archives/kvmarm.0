Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F9D15CA
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 03:59:24 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id o6so13324495vsq.10
        for <kvmarm@lists.linux.dev>; Wed, 22 Feb 2023 19:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677124763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H32nxJKYLFgX94VN5oR58FHUZwCnE+gpSinuTrZzCc0=;
        b=V4Q5l6WLAj/WwxnVZRzvheA/iOME8vS7OMCgLQWsVt/tZ1p+FehahQQjYkfBEwnn5l
         TKqvMJ4ouOnvNtwLpkdvRKTTNQhJdK8GWjwAgSM5gu2EhnU0opER4l31mwe55domXE0w
         Hh/RGdOf2a1K2z7Re8lyE0yCVzCTzILxkZUcQXewKdfJ3nDh+Cx8jTMdJZGQX0pZkZUY
         4CAifutvKd9vpOwllaoBeMHWTAZ8SHL+wtWN3Q2twnpq3HAsmolU0vVpaO0k7gzLbvmc
         s3sDmxNfwKOsOYTnd2jaudx9jqxs70BYLlpqGNm2hwnZxrqrv9nxqoKIAVBvW5yE8AKf
         bHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677124763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H32nxJKYLFgX94VN5oR58FHUZwCnE+gpSinuTrZzCc0=;
        b=zayxH6fAw8ij3DsPLkusndTlLh4Z5lteq9IsrdpeqvrUwhNu2vKsekUrTSJLZY+13l
         KgiMPPjiCtugmWYY7ShiIxVKGc+ElSReJKDv1hw+LmGAalpQZDsgUY81GUHOJSBoII/f
         IbJTQuJvnWKEvwi9UP9vBHXtsukBo8HIm21aBTyfzBl1F1iBxlJnH+gRdr18wE2B0QXn
         CEGtjAw+LZodr2bYAWEbLfQg114+2Gx+mqtbm4ZuklAtRmRrvv9G7563q7tlh0IVCyc5
         r7EceNP6OWYpV0sVn10heutA6VUG4s9aDiQEfZ8m1VTJ4I72b+xhvdnCrSUN2JyHxCbC
         rnMA==
X-Gm-Message-State: AO0yUKXX/cjGySk/iQveQ407d+4zDoPOznyTLWB8Hcez5e8eQAVoQ7W/
	8NKe8pVNB5KiEG5Rxo7WY08PUQPGnWt0leGDOJxGvA==
X-Google-Smtp-Source: AK7set8d4Kt8nwIvSPEaytrIpcGaTkhsSfI3kbZZEBvM/1NXFxRlVl/iWmVtGErpsTF5b/RMhuHUh6LwD5LpoKFSFjM=
X-Received: by 2002:a1f:aa41:0:b0:412:948:73ff with SMTP id
 t62-20020a1faa41000000b00412094873ffmr143108vke.13.1677124763494; Wed, 22 Feb
 2023 19:59:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-4-yuzhao@google.com>
 <CAOUHufYSx-edDVCZSauOzwOJG6Av0++0TFT4ko8qWq7vLi_mjw@mail.gmail.com> <86lekwy8d7.wl-maz@kernel.org>
In-Reply-To: <86lekwy8d7.wl-maz@kernel.org>
From: Yu Zhao <yuzhao@google.com>
Date: Wed, 22 Feb 2023 20:58:47 -0700
Message-ID: <CAOUHufbbs2gG+DPvSOw_N_Kx7FWdZvpdJUvLzko-BDQ8vfd6Xg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 3/5] kvm/arm64: add kvm_arch_test_clear_young()
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, 
	linux-mm@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17, 2023 at 2:00=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 17 Feb 2023 04:21:28 +0000,
> Yu Zhao <yuzhao@google.com> wrote:
> >
> > On Thu, Feb 16, 2023 at 9:12 PM Yu Zhao <yuzhao@google.com> wrote:
> > >
> > > This patch adds kvm_arch_test_clear_young() for the vast majority of
> > > VMs that are not pKVM and run on hardware that sets the accessed bit
> > > in KVM page tables.
>
> I'm really interested in how you can back this statement. 90% of the
> HW I have access to is not FEAT_HWAFDB capable, either because it
> predates the feature or because the feature is too buggy to be useful.

This is my expericen too -- most devices are pre v8.2.

> Do you have numbers?

Let's do a quick market survey by segment. The following only applies
to ARM CPUs:

1. Phones: none of the major Android phone vendors sell phones running
VMs; no other major Linux phone vendors.
2. Laptops: only a very limited number of Chromebooks run VMs, namely
ACRVM. No other major Linux laptop vendors.
3. Desktops: no major Linux desktop vendors.
4. Embedded/IoT/Router: no major Linux vendors run VMs (Android Auto
can be a VM guest on QNX host).
5. Cloud: this is where the vast majority VMs come from. Among the
vendors available to the general public, Ampere is the biggest player.
Here [1] is a list of its customers. The A-bit works well even on its
EVT products (Neoverse cores).

[1] https://en.wikipedia.org/wiki/Ampere_Computing

> > > It relies on two techniques, RCU and cmpxchg, to safely test and clea=
r
> > > the accessed bit without taking the MMU lock. The former protects KVM
> > > page tables from being freed while the latter clears the accessed bit
> > > atomically against both the hardware and other software page table
> > > walkers.
> > >
> > > Signed-off-by: Yu Zhao <yuzhao@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h       |  7 +++
> > >  arch/arm64/include/asm/kvm_pgtable.h    |  8 +++
> > >  arch/arm64/include/asm/stage2_pgtable.h | 43 ++++++++++++++
> > >  arch/arm64/kvm/arm.c                    |  1 +
> > >  arch/arm64/kvm/hyp/pgtable.c            | 51 ++--------------
> > >  arch/arm64/kvm/mmu.c                    | 77 +++++++++++++++++++++++=
+-
> > >  6 files changed, 141 insertions(+), 46 deletions(-)
> >
> > Adding Marc and Will.
> >
> > Can you please add other interested parties that I've missed?
>
> The MAINTAINERS file has it all:
>
> KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
> M:      Marc Zyngier <maz@kernel.org>
> M:      Oliver Upton <oliver.upton@linux.dev>
> R:      James Morse <james.morse@arm.com>
> R:      Suzuki K Poulose <suzuki.poulose@arm.com>
> R:      Zenghui Yu <yuzenghui@huawei.com>
> L:      kvmarm@lists.linux.dev
>
> May I suggest that you repost your patch and Cc the interested
> parties yourself? I guess most folks will want to see this in context,
> and not as a random, isolated change with no rationale.

This clarified it. Thanks. (I was hesitant to spam people with the
entire series containing changes to other architectures.)
