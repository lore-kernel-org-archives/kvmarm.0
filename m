Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EBE3A963E
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787787501; cv=none; b=gPLqeTbwwSWZvdrN4Qxj8uKJt2zltM2LcE1NIvWL3RbSkBxpmcQAmBVDNjOkY7J8yguKuiJwRFkTPQ6JwZ+NmaGYQRFfFO9yLtiwprMeUbJeOriW4oYFF6u+KHDKM6L0XKEn30qGN5UzBVDCnsTIv9HUu48rxZzioTdkOOLutxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787787501; c=relaxed/simple;
	bh=5tBZ0Lp6Mtupk3SqAudUdIW44a3ph9FaTgWVVua/8yM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u6tMb/PKLZLeMmjCsuO2SJ1zLH3RQmKbyQohgNkLAog1b4LYVGusX31SC07Vet4rNI2Gs/z3eXA12LFLsUjy6S7FiYjUHiKRnjGG19cZfYL9Reqb6Wt1hDToaba1a6Ai5ozDSy2FfgsJXEGSEltjEn/gOZx+iYZnWjGC02LtX9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vb3LghMn; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vb3LghMn"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6df0a1e18so23166155ad.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787787500; x=1788392300; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HC0L0IhxTSjXe4UbRtdaQNXjymrT4RVRL+ppaVsTI8g=;
        b=Vb3LghMnh2+AJTHPQmdsd00aTsBqu+krxCvOZIuXxctGF0G6U2uAphZ/+w9mra3Z67
         LTuAH6HUscjS+X0XJSPuu6iZGmrm+UpLXWk+LKVkn9+sZM7J/N9c/5q8D+yaVZVByAr1
         u3Wew2HdjUTTZpWGz466Ypp7HWLl0hHq7sYPCGGik/KlJerrt0YLnSnJQ5tNMp9bP1y9
         ctmyKnCibfqWBMDsaud+/+GOg2G8xFfFUhSNOGZoh3coZGw7CFHDlRu2YkJ99tlcnpyu
         49FqCeqAJkpC78ZcA12pOqCZInWhVPG2n0BAwr+k8tApaCYGIgMYXAw7AAs48z7gDcdI
         n9nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787787500; x=1788392300;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HC0L0IhxTSjXe4UbRtdaQNXjymrT4RVRL+ppaVsTI8g=;
        b=dXXpMS/k83P1pQL4Rusx7JLFAtaLaWOH1CLVb3hh/StAEXBNFFcNuZn7PYlpZ9v2E7
         xMU7SIO/hOUSBBqKjevwfx1/zHPMIY05F1jFZJkBJmQo3N55wTjh9yojr2eONI5rviO0
         yREuJUJ418QUuiE/S6dvfx99H8hNrlU3wbtBiy/ng2IWfvEynU9lqTnm2UGhgO2HWEx2
         ggwEUSXexE9FYorl2pKY6NPnFpjAeLADR9RUHZQl0M4rAIr+gkIPRk0andAE8TEnO2ly
         LunwPcJs2rZ0rdiXJLnHZC4dgGDhbXWRhap0bG5ssK1KKilyHUQsu3uOFJd2OLL8CHRW
         S8rQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq+bp+Z+s+cLDMypKEe9M9TPxhpwtXJ+Gbbod5h1c9eRuomR5IRMBjQRkbD4uFcxUF1kVQXdUk=@lists.linux.dev
X-Gm-Message-State: AFuF++mvVLnJwCMt8cpVgxHS0LQpGFlO5S02tsEDXvrJX3p8XeJpEJJH
	DYDKQyrQnlflPPhh+fYIQpJCip2CvoDesORx8hvaJcmAcGnLFIEWTG97N5eNig76HiCIsY/s/35
	Me3ogUg==
X-Received: from plfn17.prod.google.com ([2002:a17:902:e551:b0:2d3:2362:d799])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f78e:b0:2c9:deec:f564
 with SMTP id d9443c01a7336-2d707c0d370mr139890095ad.13.1787787499444; Wed, 26
 Aug 2026 16:38:19 -0700 (PDT)
Date: Wed, 26 Aug 2026 16:38:18 -0700
In-Reply-To: <20260826232224.782021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com> <20260826230511.972824-3-seanjc@google.com>
 <20260826232224.782021F000E9@smtp.kernel.org>
Message-ID: <ao946gGsIkSkEwAs@google.com>
Subject: Re: [PATCH 02/20] KVM: selftests: Bump the minimum GPA for page
 tables to 0x200000
From: Sean Christopherson <seanjc@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

+LoongArch folks (question below for you)

On Wed, Aug 26, 2026, sashiko-bot@kernel.org wrote:
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/tes=
ting/selftests/kvm/include/kvm_util.h
> > index 5a7a455b53875..70906a0d1003c 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -175,7 +175,7 @@ static inline struct userspace_mem_region *vm_get_m=
em_region(struct kvm_vm *vm,
> > =20
> >  /* Minimum allocated guest virtual and physical addresses */
> >  #define KVM_UTIL_MIN_VADDR		0x2000
> > -#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
> > +#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x200000
>=20
> [Severity: High]
> Does bumping the minimum GPA to 0x200000 cause the guest page tables to o=
verlap
> with the VGIC redistributor on ARM64?

This is definitely a Marc/Oliver question.  FWIW, I didn't see failures on =
arm64,
but I also have no idea if the hardware I was using supports the v3 tests, =
so
it's entirely possible this is a real and obvious problem.

> In tools/testing/selftests/kvm/arm64/vgic_init.c:subtest_v3_redist_region=
s(),
> the redistributor is hardcoded to be placed at the same address:
>=20
>     addr =3D REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
>     kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>                         KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
>=20
> Because KVM maps the redistributor over memory, wouldn't the hardware MMU=
's
> stage-1 page table walk attempt to read page table entries from an emulat=
ed IO
> region?
>=20
> This seems like it would cause a stage-2 fault that KVM cannot handle for=
 a
> stage-1 page table walk, leading to an infinite exception loop.
>=20
> Additionally, does starting allocations at 0x200000 severely reduce the
> available memory in memslot 0?
>=20
> In tools/testing/selftests/kvm/lib/kvm_util.c:vm_nr_pages_required(), mem=
slot 0
> is sized to be just slightly larger than 2MB:
>=20
>     nr_pages =3D 512;
>    =20
>     /* Account for the per-vCPU stacks on behalf of the test. */
>     nr_pages +=3D nr_runnable_vcpus * DEFAULT_STACK_PGS;

Ugh, right, because this doesn't change the base of the memslot.

Why does LoongArch use 0x200000 instead of 0x180000 as the base?  I switche=
d the
common macro purely because I thought it would be the path of least resista=
nce,
but maybe "fixing" LoongArch to use KVM_GUEST_PAGE_TABLE_MIN_PADDR is easie=
r?

> It seems like this leaves only a few pages for page tables. If a test has
> multiple vCPUs, wouldn't it exhaust this tiny pool and trigger the abort =
in
> tools/testing/selftests/kvm/lib/kvm_util.c:____vm_phy_pages_alloc()?
>=20
>     enomem:
>         fprintf(stderr, "No guest physical page available, min_gpa: 0x%lx=
 "
>                 "page_size: 0x%x memslot: %u\n",
>                 min_gpa, vm->page_size, memslot);
>         fputs("---- vm dump ----\n", stderr);
>         vm_dump(stderr, vm, 2);
>         abort();
>=20
> > =20
> >  #define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
> >  #define DEFAULT_STACK_PGS		5
>=20
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826230511.97=
2824-1-seanjc@google.com?part=3D2
