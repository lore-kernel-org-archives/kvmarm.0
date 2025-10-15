Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D4F264602
	for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760554136; cv=none; b=uXBmsfb31cgD+dpzx5foPTcARhSuppx/3f2sbUw+XIxgTOqY6qlNFXHoHXBj8xF8BSGqvbAX2moXjBVJeN2KAROlCk9QMkFG6W7anHjiunVnZ36YZi0250e845jyVnEvgwfI0mWp5F7XpkORxREvW4k11BeOiGCbAG+pknRCxT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760554136; c=relaxed/simple;
	bh=HqqF4x0s/r1hw3Xsgl35/OvKCY5LGibQ5keQMlJM4gM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bnrQby3osVH+0XVIEjH1iCJl6aWz6Xs2MyEi8S8ndV8bQMfhv3jD+FjEaAtiEbw1+t5U4ODRbBAJpHWS3dLI6RX486NADo5vxDO9JlzGLOXzlS4MC1FzAmZTFiGp4ZujlOB7lren+dhp5GUHRnmzJrHcZ3a0k4hAlvdtYd2leQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mWhm0kmJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mWhm0kmJ"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befc5bso13385706a91.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 11:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760554135; x=1761158935; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3naOg0AXa4lxy2J7qWFZUYdZmmuSUah42Rbajn2HebA=;
        b=mWhm0kmJCL1L61gXPHUV3kDwysTvHNsrO7EwEnQsyt6+dtz+D86bjWiELe4NVAUOJl
         nEIbyAnol6wQIxqW/AwHenpwp7ZTQXXkEdzBNi1aaZPz9hlnyfQFq00rJBd2pCg5CHM8
         M+S4RMW/f3XKtPTbwHJLew+9ejnz3H7JCJD8puZ7r4SK0PTeH8FhaqgU4lo/GTSBt285
         IUNqcNCBb6eVNGDcoy+d0QRF+PNQTHh4FMuK0AuLd5Tq2LaJx6P0qneGf5ZVuwsGdMCg
         cgwgnPAtJQkTU67Pbiz1lv2KqRciEMyP3FvGNAO0LCMUWqKGzkz4iJ3Z+55DyFPfMq1+
         zpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554135; x=1761158935;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3naOg0AXa4lxy2J7qWFZUYdZmmuSUah42Rbajn2HebA=;
        b=IEetMN4TlpveydflRFC7Hzx8+Nu1QC14vsqBsjdNrCPhbaq6X/Vj4x/qMCtrb0SA7g
         EuoOkkEdp8gh/P0AJeGiF9F9FOhNZK7Wg2+cFmDzjOhR25XaOwHDfcxVhJDZPLn1XKGB
         Ho9o6crL7FMPsiUFQVthhkgWIQRZ9eojyRAj6m3HorzZkmvEMDPqmzUI2WTq1b3Zh628
         YWbmSOWJuMehsziepQyBwYvf53tQGCPnQHgXj/Xnb7YwZZ+5k1QjgpGEcb8u5wBVClBi
         OCDcRnWJR18Pp8WfGmGxWcKRed6Qms7BVMbEy9DYidj3FfTxHQGH84aLGSK6mXDr/FER
         I/ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW8UsyrL/Snu71F0bw7xS0e1aAYFfUjw2g0nr1YpIyBmi+S1Y0UR8Qix474N5GjJWamjwk4V8=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywn0D1FeDehVfBXktSusrGtsRJfpgNatVKb4EYWs504Vw4mtBrH
	wuf2899M0LPGSCyDQT71J8Yc/Lkf52BcHi2apjZxBzMFX7KIphJhStFs3WfqnfdZSoQBQiRHBIV
	cne83Ag==
X-Google-Smtp-Source: AGHT+IE9eJmZgE8/vrWWkRhltj63ksxMU8MKwID4HHHoGFacVC2zof2bk9aQHK5Js4MPCgK0DcLQje9LyvY=
X-Received: from pjpx13.prod.google.com ([2002:a17:90a:a38d:b0:33b:51fe:1a93])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3909:b0:336:bfcf:c50b
 with SMTP id 98e67ed59e1d1-33b513865a2mr39206696a91.20.1760554134578; Wed, 15
 Oct 2025 11:48:54 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:48:52 -0700
In-Reply-To: <0276af52-c697-46c3-9db8-9284adb6beee@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-33-seanjc@google.com>
 <f896966e-8925-4b4f-8f0d-f1ae8aa197f7@amd.com> <aN1vfykNs8Dmv_g0@google.com> <0276af52-c697-46c3-9db8-9284adb6beee@linux.intel.com>
Message-ID: <aO_slNn8X1A84sI-@google.com>
Subject: Re: [PATCH v5 32/44] KVM: x86/pmu: Disable interception of select PMU
 MSRs for mediated vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sandipan Das <sandidas@amd.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2025, Dapeng Mi wrote:
>=20
> On 10/2/2025 2:14 AM, Sean Christopherson wrote:
> > On Fri, Sep 26, 2025, Sandipan Das wrote:
> >> On 8/7/2025 1:26 AM, Sean Christopherson wrote:
> >>> +	return kvm_need_perf_global_ctrl_intercept(vcpu) ||
> >>>  	       pmu->counter_bitmask[KVM_PMC_GP] !=3D (BIT_ULL(kvm_host_pmu.=
bit_width_gp) - 1) ||
> >>>  	       pmu->counter_bitmask[KVM_PMC_FIXED] !=3D (BIT_ULL(kvm_host_p=
mu.bit_width_fixed) - 1);
> >>>  }
> >> There is a case for AMD processors where the global MSRs are absent in=
 the guest
> >> but the guest still uses the same number of counters as what is advert=
ised by the
> >> host capabilities. So RDPMC interception is not necessary for all case=
s where
> >> global control is unavailable.o
> > Hmm, I think Intel would be the same?  Ah, no, because the host will ha=
ve fixed
> > counters, but the guest will not.  However, that's not directly related=
 to
> > kvm_pmu_has_perf_global_ctrl(), so I think this would be correct?
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 4414d070c4f9..4c5b2712ee4c 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -744,16 +744,13 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned=
 idx, u64 *data)
> >         return 0;
> >  }
> > =20
> > -bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
> > +static bool kvm_need_pmc_intercept(struct kvm_vcpu *vcpu)
>=20
> The function name kvm_need_pmc_intercept() seems a little bit misleading
> and make users think this function is used to check if a certain PMC is
> intercepted. Maybe we can rename the function to=C2=A0kvm_need_global_int=
ercept().

Yeah, I don't love kvm_need_pmc_intercept() either.  But kvm_need_global_in=
tercept()
feels too close to kvm_need_perf_global_ctrl_intercept().

Maybe something like kvm_need_any_pmc_intercept()?
