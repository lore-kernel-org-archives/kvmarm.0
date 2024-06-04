Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70FC146599
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 22:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717539659; cv=none; b=YYP1xMZ5hNz3a5rYkJW3ARGg3tBdMfdWfxnsGDpzWPpOCYKUo1FCSO8e3AeR2AXaf+z2POOKpaMeJVW7kc834Uq0mw6KR+gYZzQ2a2/tie0/a0ygCb1v6IW78UvGdq+Kwimftwl6fV18J8MbXfPwa9MJncPUitauKb7You/5LTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717539659; c=relaxed/simple;
	bh=PEwtsHuB5I4aiO3jiKouMVnFQZ+bv8RQ/fbI3oGiDcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N/S56oATL2Nqahp1ACSeQC/x6C8zFh5BCCzGnt3aEj4BgvUKwfmP91DuKsg9BanonWfL+kZo5trzBuLVOOe9PNAmuOg1iDmR3hqyeTqI1IUl0d6eZk5/4fVWmXIjPuq5yHT7NrcqwNqDeWDkt+CZ0fNx12oxfc3Bp820xPFBnEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pUeRih3D; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pUeRih3D"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-43dfe020675so137831cf.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Jun 2024 15:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717539657; x=1718144457; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIBmj4SOCWbNZTcEJ36wTOG253WABX8+/zZKq57PG38=;
        b=pUeRih3Dq96NUD3SN3NFXdePi2ewzeFynOBQ6nl/PngZizGXspPYpOCVBgZTqATIQ2
         8LxjCCyN2CpGgv9z9jTjygzLkm14pvfFkBESV9iAE1IByPdzrwyHIPE1sp7LW0ZTsK6R
         Gl1hfy46BicfgRi2xsdyMMJGQjqD9wJOvc92xN+qry/yNpk9H8qbvR+d/m8+ftS+2GQd
         IGEQww+otlqf4TTqX/MgYvSA7LSdVfvs87k1t5ftRRFtVRwZduPiD8MAjh3RSf+gMn1P
         XHY7vkU3hherzPDtgPDzBHtbO2JADPi2O2dplEkLndHskhIICxiOS48s9lHDqVdE1NVR
         jH1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717539657; x=1718144457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AIBmj4SOCWbNZTcEJ36wTOG253WABX8+/zZKq57PG38=;
        b=ZbEo5TGbXCPCnjT4tXbU0vOtX4eAbzpKjqkYbykPOkdYBMUDa8ViNYa9JXPE8Qvvdi
         7sk2sMdYgVl7IaHBU9jlK27eruA3lMgF3by+XOpzYkmG2K+ZreLlfEJya8fMKbojEKeA
         apDp1VOliO8MmkJ5+enQRjilQug3+qTbBR1nsaDQOe7C8xvBfVInefs1lQ4GDeWMYY1k
         4WT1CFWKlmx3QO42VOHYBTFfIGmSbbeQ7VtGuknJ2w328kcwaGafaH/DWbOlBeqKg95u
         tPbHDIerzJfi7PmfeTpvEWGPVBfldpvrrSlANdSauBcA+M/E5ftB8PXcGCpjm7v+vBN7
         nesQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfiDM6UQFMXgkQfYBBE6Vrh87uLafZ+QkbroPv9Nptib/CaweYUdVb4Y7+o4zIzBxKYdhtWbg9NM88bI5q9WgZaEuxCbd+
X-Gm-Message-State: AOJu0Yy0IStE4wXaObUq1zg45/7Jm9jwhANHd+UZRAeJkmwkwuWneb96
	0mqNHR5APNpOB+um4o7eBkPoDBZsXKTRE51IxsWMg76PEN2OQUKRufuETzhiJ8hVG1+5MX21QYS
	ZNllz7qVaMo7Lz2/OlARe12d2SvBNTzybj4k6
X-Google-Smtp-Source: AGHT+IFqQR6wV0ldEWSB61hJVaO5R3FbfhfGJ/jL2Y1RO1QFt4uPcpp04yR87XJA3WIv/pXl4si2o71lLJw9aUuCxfc=
X-Received: by 2002:a05:622a:5a98:b0:43d:dc3b:518c with SMTP id
 d75a77b69052e-4402ce13c55mr332451cf.11.1717539656344; Tue, 04 Jun 2024
 15:20:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
 <20240529180510.2295118-7-jthoughton@google.com> <Zlog5Yk_Pjq0jQhC@linux.dev> <Zloicw4IU8_-V5Ns@linux.dev>
In-Reply-To: <Zloicw4IU8_-V5Ns@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 4 Jun 2024 15:20:20 -0700
Message-ID: <CADrL8HV4SZ9BEQg1j3ojG-v5umL_d3sa4e1k2vMQCMmBEgeFpQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] KVM: arm64: Relax locking for kvm_test_age_gfn and kvm_age_gfn
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Ankit Agrawal <ankita@nvidia.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 12:18=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Fri, May 31, 2024 at 12:11:33PM -0700, Oliver Upton wrote:
> > On Wed, May 29, 2024 at 06:05:09PM +0000, James Houghton wrote:
> >
> > [...]
> >
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtabl=
e.c
> > > index 9e2bbee77491..eabb07c66a07 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -1319,10 +1319,8 @@ static int stage2_age_walker(const struct kvm_=
pgtable_visit_ctx *ctx,
> > >     data->young =3D true;
> > >
> > >     /*
> > > -    * stage2_age_walker() is always called while holding the MMU loc=
k for
> > > -    * write, so this will always succeed. Nonetheless, this delibera=
tely
> > > -    * follows the race detection pattern of the other stage-2 walker=
s in
> > > -    * case the locking mechanics of the MMU notifiers is ever change=
d.
> > > +    * This walk may not be exclusive; the PTE is permitted to change
> > > +    * from under us.
> > >      */
> > >     if (data->mkold && !stage2_try_set_pte(ctx, new))
> > >             return -EAGAIN;
> >
> > It is probably worth mentioning that if there was a race to update the
> > PTE then the GFN is most likely young, so failing to clear AF probably
> > isn't even consequential.

Thanks Oliver.

>
> Oh, and the WARN_ON() in kvm_pgtable_stage2_test_clear_young() is bogus
> now. Maybe demote it to:
>
>   r =3D kvm_pgtable_walk(...);
>   WARN_ON_ONCE(r && r !=3D -EAGAIN);

Oh, indeed, thank you. Just to make sure -- does it make sense to
retry the cmpxchg if it fails? For example, the way I have it now for
x86[1], we retry the cmpxchg if the spte is still a leaf, otherwise we
move on to the next one having done nothing. Does something like that
make sense for arm64?

[1]: https://lore.kernel.org/linux-mm/20240529180510.2295118-6-jthoughton@g=
oogle.com/
