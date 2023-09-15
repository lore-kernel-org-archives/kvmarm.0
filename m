Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3934437
	for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 06:23:50 +0000 (UTC)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5029ace4a28so3452769e87.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 23:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694759029; x=1695363829; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1zuvJ7RRCqy9MSyULz3DiU3qO3y4/pQtJW6GP4mEKM=;
        b=gRBjFwjNTogTH8w7vm4XujhPLPGMEUHnAA6xsxBf4PIirq4268JXhjP1SUMZ35qW3i
         yCyFzE4HGwkjmETs8OpXotyS84hcyGXl0rgln3mL5PTqBjUHIYvJ+4pLsSuQMrAQDzmo
         Yt+iHUEtSyUZBH/7xsN9rjoa0wStbFs1JYKQQ2vg0fv2b+z4lkNukK3JjpEhVeil9U3O
         tybwICnxJld5+mt0Ldx98LRyRR/dWmFO5xpiVaVL1SfUiMXDXEY27kN61sOTVtdbXmIU
         ZJXIeOiHgJXR3e7nYUd/39AeiRYKPmo1t5l3OGnGaXH9/j78y6Gmm544dWA0Bdp8HQ08
         UEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694759029; x=1695363829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g1zuvJ7RRCqy9MSyULz3DiU3qO3y4/pQtJW6GP4mEKM=;
        b=QogOFVgIm4aaUHWN+V+/Z2NNBlBvajYDeeGNFQN1AsqpvaNHJjPaYLdTtn4LIqrHHy
         s4K7k6BzpdrzcqJ/Emk9MtU3zSnMknthoi8WDTeoIaPI1Cf1X6Fq0pwEWN+xaL/kvf1v
         rLaiiifCFx81gx7xq1D1LOhXVfgLjq1+Dh5H800cFl2kbbIKhv40tfYbXwrzEb9WziIh
         U9HEFdnrO6KNpnniINbxGNzJwy47oFcz6GSg6EayH3hjAPmU8aWCKUOwG9mqbXwOr0wq
         Pv2Y53DHaT1KsRCET/2qPo21XsjOOSlkC8gI8TCx9iLBQBsI0uYXOjWPuoAWcVjUvj9h
         YRRA==
X-Gm-Message-State: AOJu0Ywcx6d+S7WHRPP2fkAoRcCARMWuEejRsK7UWM4lYIsLkHpwFKZJ
	o+IW4Rbc9DKvgVNMo2ouDWhTtzEk5IxieReljpA=
X-Google-Smtp-Source: AGHT+IGj/HsfBsymLbWepYETxK1fPN+QHY/uRqAGLNuLGZZu2qI+OypS0+lHToloM5nAwXB8QRxambJWef0/qHqiQfY=
X-Received: by 2002:a05:6512:1095:b0:502:d973:3206 with SMTP id
 j21-20020a056512109500b00502d9733206mr1476766lfg.6.1694759028702; Thu, 14 Sep
 2023 23:23:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1694421911.git.haibo1.xu@intel.com> <64e0637cd6f22dd7557ed44bd2242001e7830d1c.1694421911.git.haibo1.xu@intel.com>
 <20230914-ee133dd5e804282ce28833d6@orel> <20230914-reflector-preshow-786425ad7ae2@wendy>
 <20230914-2232dea1c6d03fb5985755e6@orel>
In-Reply-To: <20230914-2232dea1c6d03fb5985755e6@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Fri, 15 Sep 2023 14:23:37 +0800
Message-ID: <CAJve8ok9de0bGMU24iyUSX6V4+1tZM3ca=Ntyk=2gythd4uWCg@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] KVM: riscv: selftests: Add sstc timer test
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Conor Dooley <conor.dooley@microchip.com>, Haibo Xu <haibo1.xu@intel.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Sean Christopherson <seanjc@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 14, 2023 at 6:15=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, Sep 14, 2023 at 10:52:15AM +0100, Conor Dooley wrote:
> > On Thu, Sep 14, 2023 at 11:36:01AM +0200, Andrew Jones wrote:
> > > > +static inline void cpu_relax(void)
> > > > +{
> > > > +#ifdef __riscv_zihintpause
> > > > + asm volatile("pause" ::: "memory");
> > > > +#else
> > > > + /* Encoding of the pause instruction */
> > > > + asm volatile(".4byte 0x100000F" ::: "memory");
> > > > +#endif
> > > > +}
> > >
> > > cpu_relax() should go to include/riscv/processor.h
> >
> > Can the one from asm/vdso/processor.h be reused, or are there special
> > considerations preventing that?
>
> We'd need to copy it into tools/arch/riscv/include/asm, but it could be
> done. Hmm, now that I look at it, I see we're missing the barrier() call
> in this kvm selftests version.
>

Will reuse the one from asm/vdso/processor.h and copy it to
tools/arch/riscv/include/asm.

> Thanks,
> drew
