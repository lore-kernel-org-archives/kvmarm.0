Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DB446524
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2qOLQpkG"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-35c6cefa872so3095ab.0
        for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 13:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701121301; x=1701726101; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lIiUOLs4B5FYCz4BIBDodRBLizz4WQxtB5imEZ+H1Ys=;
        b=2qOLQpkGy9gsghfGAF5xVRAu8Z4IJWSfdoVEAkJL91ab1ITBXdZkYwlBCrAZsnuTcX
         BFJXD6xlxnT0KBzkmDyJ+CZa3rA8yw9XdnVXnVgVkx+u6xyp0Klm4cYG3JYGK7H5pDIl
         lYyYiT9Fm83dz5aSw1RMPqXqQo0WXs04tKNIVpBrYVmGdDK/Z9U+Ln4FvqWbAZg31aZ5
         lc6el9UPfInnbq+ekGLvwWyySR36PqwKH50n0117PeUPorxPENJFePewDxThuPC/H+4d
         0KL1CTqAKwUALHF3metiSkzaQXjCLf0RS+k/52VFzaYdczY5sDGNvkB06sAzgS6RcPoy
         C/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701121301; x=1701726101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIiUOLs4B5FYCz4BIBDodRBLizz4WQxtB5imEZ+H1Ys=;
        b=XPwTc7xvbrakVQVxTs4asCNwrwGe75SzfEc9qAaf+x5oG7bI//sfnWkA5dYqPtossm
         ufOfrw4wYnjvIE5GO6bPF3zzcmgX/wJH/rhom4FhJWth94sQ04Q1bZGFn3R1MYOQ7SUF
         lC7gD322OVo6/RZrHcDbu2xgl8AB6pzKzqB1rYfFPD5E7/PrnWa/cqgYVXxji7ScDqTF
         07aAWBjhPYwgfmzttPItswz+dn2ryut6fryyTnV4DiN24JfD6H492giABMzJDaV8EGzW
         onT/JsKDgP03p/Lw0H6cW7kUMEXuqB2i4HxcjYK5/SmUMXyDXHC0YbrPZG61nv+FVfNy
         F2dA==
X-Gm-Message-State: AOJu0YwUFjnOh/t9DAIbb0QsoyuOSegmSslRBNY0nXMkWWb+/rGVDpCd
	GHBQYZYXpGDja8WkzNBTRCJrOLH2mkruuFItx0HFfQ==
X-Google-Smtp-Source: AGHT+IGbIr/R+htW7xaVZXcb1VijRsa9rXR3s4S6dUyOEpmr2hZBOp1GOfigsseF1e08qY1EZCsyy9k88qjMupsCCfE=
X-Received: by 2002:a92:da04:0:b0:35c:e49d:3e65 with SMTP id
 z4-20020a92da04000000b0035ce49d3e65mr211441ilm.11.1701121301101; Mon, 27 Nov
 2023 13:41:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231122221526.2750966-1-rananta@google.com> <d5cc3cf1-7b39-9ca3-adf2-224007c751fe@redhat.com>
In-Reply-To: <d5cc3cf1-7b39-9ca3-adf2-224007c751fe@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 27 Nov 2023 13:41:29 -0800
Message-ID: <CAJHc60zinMfkjFF=QS5R6YO0B8_Anmyw2cZ2f0QEnW0i=hWHcQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: aarch64: Remove unused functions from
 vpmu test
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shaoqin,

On Wed, Nov 22, 2023 at 10:43=E2=80=AFPM Shaoqin Huang <shahuang@redhat.com=
> wrote:
>
> Hi Raghavendra,
>
> Those functions might be useful for other pmu tests. Recently I just
> wrote a pmu_event_filter_test[1] and use the enable_counter().
>
> There may have more pmu tests which can use the helper functions, so I
> think we can keep it now. And in my series[1], I have moved them into
> the lib/ as the helper function.
>
> [1]https://lore.kernel.org/all/20231123063750.2176250-1-shahuang@redhat.c=
om/
>
Thanks for the pointer. If you are planning to use it, then we can
abandon this patch. However, disable_counter() may need fixing. I'll
comment directly on your patch.

Thank you.
Raghavendra

> Thanks,
> Shaoqin
>
> On 11/23/23 06:15, Raghavendra Rao Ananta wrote:
> > vpmu_counter_access's disable_counter() carries a bug that disables
> > all the counters that are enabled, instead of just the requested one.
> > Fortunately, it's not an issue as there are no callers of it. Hence,
> > instead of fixing it, remove the definition entirely.
> >
> > Remove enable_counter() as it's unused as well.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   .../selftests/kvm/aarch64/vpmu_counter_access.c  | 16 ---------------=
-
> >   1 file changed, 16 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c =
b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > index 5ea78986e665f..e2f0b720cbfcf 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > @@ -94,22 +94,6 @@ static inline void write_sel_evtyper(int sel, unsign=
ed long val)
> >       isb();
> >   }
> >
> > -static inline void enable_counter(int idx)
> > -{
> > -     uint64_t v =3D read_sysreg(pmcntenset_el0);
> > -
> > -     write_sysreg(BIT(idx) | v, pmcntenset_el0);
> > -     isb();
> > -}
> > -
> > -static inline void disable_counter(int idx)
> > -{
> > -     uint64_t v =3D read_sysreg(pmcntenset_el0);
> > -
> > -     write_sysreg(BIT(idx) | v, pmcntenclr_el0);
> > -     isb();
> > -}
> > -
> >   static void pmu_disable_reset(void)
> >   {
> >       uint64_t pmcr =3D read_sysreg(pmcr_el0);
>
