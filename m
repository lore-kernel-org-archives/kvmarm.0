Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8B22FBDF2
	for <kvmarm@lists.linux.dev>; Mon, 29 Dec 2025 23:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767052645; cv=none; b=OBpgES0Ipp8fPe0Up/59jI6hXO2mN2Z8eReYXAAB8VGf9RSlSzegtlbLsmeKtiTiDbz58yYmJWzHDC0L4SriJY46AEa85eAPtvOyMxINdA178M0fR4xT2HyndZo2x7a3jnoxlwYqwC1bopjoAGxoNiIUaI3sWZ4Ih8unEi/bIWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767052645; c=relaxed/simple;
	bh=XsdXtJjKqE4UQSylmLBTu+OUvPU6Hv2It+NLCukC3Fw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MZFfq92WTOKF+0G5t5o34IjObqBMePqLoisyF0W6apIPSqFimUSmsC3RHtqJ7sIz3yZPDPzOUrlgeaGhlT1mRABX5evj7/ed6k7M4utR+bDic3poYO/o4/mok8a2M9Qoajh6aq3OJ0RwP6DvQW6fU0HmFSesu64G/DRBdcFvKz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a8fKTjaQ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a8fKTjaQ"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7c240728e2aso20431839b3a.3
        for <kvmarm@lists.linux.dev>; Mon, 29 Dec 2025 15:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767052643; x=1767657443; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vaCAmCD1pI2PB4kVDvq818qZSC88KaBTxMeyOFyVIUw=;
        b=a8fKTjaQ4XxSs0L7OyJAxgSLPjQ/ThP8tgvRem+Rgy0xPXF0pb26ujUBj+DYyVDGGq
         Xq5ybnSBiAEcv1QLzO8V2ikNMV8GtOv9ZePmCjUJBWCxn0+VT1r4EuhWmDXBLQeuL4vB
         434HclW32lOnikzKfkZ0ESo0X69NlUzZpGghGp3H6l2srB9Yash+CSgB5Vsbc7i769x0
         bh7eLIRl8xXt9s7M/VS5VQhxK4cgHXmNpomE5qJ94bjruxQZv18DLMljcQFQP8CEvzRW
         hAFSznffOvXR/OQacENCMzeaIZ30UiSC/CXR0cB8U6l5TqKKJB7W5s4OKrYmRH5f3afX
         bvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767052643; x=1767657443;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vaCAmCD1pI2PB4kVDvq818qZSC88KaBTxMeyOFyVIUw=;
        b=Akobcpk4TSegCm+4CKS0CBxnZwRWZQsikJ0qJQ5IScj8jgM85rmxWjRr76Nur3USFO
         TL19UpzW3rqPHvGaURDNWotKs4fhpF7eYv2YyluDSjkiiyCgqR4cgD3U7seBQF8OKNBl
         ACpCUUf07+uce6Laeq2agHQfTe7u6mwRdDUwBi7qHZo8UA0TvK3YAFmy9QaYxaH7SF/X
         ro9nx3GO5QR/vzIKLIY8t7Ided9ICmGUZG8yhm15XNLjXKEd/ZBzRZWJWqNcInslNL3y
         rqBowD8NAtDOr977MkGOJhVwzo92mf31bgFFLwC1LpIZL6EODuC6Uq6xvLfb801MZFHJ
         XJDw==
X-Forwarded-Encrypted: i=1; AJvYcCXRY04Oewb4joApKYZYRIlYYVJe4Z4RhzSlMtA1Ht0IOjTbVAQhFCYqAu05X+LshJEa+Nfnddw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzF/d8LrKpzJzeZTe7PWRTmJbgGdFwIpah7BAu97nRNKXCd0Beg
	rhUuK5myJflVjCCd3JFUhS8DXXdhlEbosR4FdUtJ+FZwc+2cu/kHcUEFP/inj8EW0X+fLgZJRyU
	tpZZVMA==
X-Google-Smtp-Source: AGHT+IGWSzvMBdAgSpc1cQ4FNAzud2F9vkcmbgsGWHl/uECW+mXFCBlsNw6jhBxprH27ZWhYhxw4eDFyKfA=
X-Received: from pjhk89.prod.google.com ([2002:a17:90a:4ce2:b0:34c:1d76:2fe9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9185:b0:343:af1:9a57
 with SMTP id adf61e73a8af0-376aa8e98d6mr28981483637.56.1767052643109; Mon, 29
 Dec 2025 15:57:23 -0800 (PST)
Date: Mon, 29 Dec 2025 15:57:21 -0800
In-Reply-To: <43d1cde6-2277-4f3c-8e7d-59e6edb2228a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com> <20251206001720.468579-16-seanjc@google.com>
 <43d1cde6-2277-4f3c-8e7d-59e6edb2228a@linux.intel.com>
Message-ID: <aVMVYY_WkNClfXuj@google.com>
Subject: Re: [PATCH v6 15/44] KVM: x86/pmu: Snapshot host (i.e. perf's)
 reported PMU capabilities
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 25, 2025, Dapeng Mi wrote:
>=20
> On 12/6/2025 8:16 AM, Sean Christopherson wrote:
> > Take a snapshot of the unadulterated PMU capabilities provided by perf =
so
> > that KVM can compare guest vPMU capabilities against hardware capabilit=
ies
> > when determining whether or not to intercept PMU MSRs (and RDPMC).
> >
> > Reviewed-by: Sandipan Das <sandipan.das@amd.com>
> > Tested-by: Xudong Hao <xudong.hao@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/pmu.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 487ad19a236e..7c219305b61d 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -108,6 +108,8 @@ void kvm_init_pmu_capability(const struct kvm_pmu_o=
ps *pmu_ops)
> >  	bool is_intel =3D boot_cpu_data.x86_vendor =3D=3D X86_VENDOR_INTEL;
> >  	int min_nr_gp_ctrs =3D pmu_ops->MIN_NR_GP_COUNTERS;
> > =20
> > +	perf_get_x86_pmu_capability(&kvm_host_pmu);
> > +
> >  	/*
> >  	 * Hybrid PMUs don't play nice with virtualization without careful
> >  	 * configuration by userspace, and KVM's APIs for reporting supported
>=20
> Hi Sean,
>=20
> It looks a merging error here. We don't need this patch.

Gah, right you are.  I overlooked it because it didn't conflict on a rebase=
, and
I once again forgot to test on a hybrid PMU, grr.

Thanks!

> The original patch "51f34b1 ("KVM: x86/pmu: Snapshot host (i.e. perf's)
> reported PMU capabilities")" had been merged into upstream and subsequent=
ly
> we submitted a new patch "034417c1439a ("KVM: x86/pmu: Don't try to get
> perf capabilities for hybrid CPUs")" to fix the warning introduced from
> previous patch=C2=A0 "51f34b1 ("KVM: x86/pmu: Snapshot host (i.e. perf's)
> reported PMU capabilities")". Thanks.
>=20
> -Dapeng Mi
>=20
>=20
