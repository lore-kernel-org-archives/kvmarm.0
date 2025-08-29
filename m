Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66112638AF
	for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 17:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756489286; cv=none; b=Sx/1cn7cNr24oinv24d7Xynbgwzd2zPgJN8FRiHglJ/hBNN3yZVSpg0uozxfDhhWsfLvXhM5oDNreM2MPptGGVCfojUNEFnylPVP2hZ9Jhy0sy0LOs63zTSzDr5JM+cmragvICis7AUhzgUoe3C5O7bTvt7NSkbFsfukUEXy4GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756489286; c=relaxed/simple;
	bh=glCrBMW/ePbIaVp9ZQqc9/ec3heiWmO5wHHmhQa7QCE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V5luAAjPTe+Q9qCwMH4QaPgcQNRqKVEBkWUkOySNGzutcSqRhzJ/+5an9yEaPkdxtKF0jc8GMYXmo2Yad1JhvBAOnhZ40/sSrDR2Uu4GSooOnRSTp/2S0VVgI7olzSgPqjdhZFgwlZwH0agSeDRziAwubdonA7CRZAepZh6Fiy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ag5vScod; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ag5vScod"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756489283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwPu03jaHQbL9plgFkDc5n/BjvF9GZXn+nK8MJCiCA8=;
	b=ag5vScodEoS/791ccwC4ZHsG/6XWIdMJenbMQAnMTy4z+Pao/gbhREX174/oYGWpYcEkvA
	45WqoA5lLG9Vqh5GfSVGyWGh3WYGYDuIRtpJOCDgdKVX9T5vCmOcsuFYRs/93sEUfl6VYo
	+f2iVr1U39q7K5PIzVwHfQvw8eFOayI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-3M2lvnG5N0eZweJ1FQZ7TQ-1; Fri, 29 Aug 2025 13:41:22 -0400
X-MC-Unique: 3M2lvnG5N0eZweJ1FQZ7TQ-1
X-Mimecast-MFC-AGG-ID: 3M2lvnG5N0eZweJ1FQZ7TQ_1756489281
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ce059e3b83so913488f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 10:41:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756489280; x=1757094080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GwPu03jaHQbL9plgFkDc5n/BjvF9GZXn+nK8MJCiCA8=;
        b=N0JmjsK1C7DnIFp6y+xv3cXsBxfnJhv2/0SdhCokA/E/k7kegCas4Us3WulrO/Ta6j
         zspnKU9Hmy36G6cNk6XpsSq3hCzOaZ45r7V8qEVn0zMd292WxYbocRHY2wp9gza8DtDp
         j1Lbjit31JPhBatbGm3yQuhPJY36l+B2aeFmqfnFuMccxx3WrY0SixZOut6OvpdeOlav
         ZleqcoyH9PnmusAS36hSAXgAk6n51Bh6UL4PCduKS+B5SSCRSJVPBzM8mL2DYZJa/PRr
         sgiXAr/6quBehNP6x5rEyRiVi9gZWdpjAOYf6fxIF9aLLx8wsSU3Gyhf4tv85KDs85IN
         RAcg==
X-Forwarded-Encrypted: i=1; AJvYcCUHZwcmcK0lzsNXVcpp5ysi4aXWHW3qLttih7Ncl6Pk16JrYr35VriiAbxAa3sLri417Avckc8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0gVJ/jL2JXdzUSOb28VmcPM0jBtqQkq3ERRMiO+ICa3QJK09M
	LjINLMrPirvBzwiFUyO56BiEdQMgIIKcEpfiZTSg7+HkJk5g1qfOr9WmJcdcNpLiLPPXKFkq7dI
	TN4lpOxog8PZRk8P7n/26zX6TDwiOjqX3WIfBF1JlJAN5ucrPBAenHcyVDK5WKAC6574MyX5qfr
	tAY0qHqrmmvFnLksnM6IReP8oxSMGt5y5mTBj4bW8R
X-Gm-Gg: ASbGncuP5CrE92enVOZe08VWD56CHJEZOFdl7P7aXUEcQSwAqiozppantW3w+S5hoiG
	iu00CbrKgDeEePF+WbX6YGg1pf53E5DqEg2eQeCRwPcoZoqadVXDIgHEdODS2y7SJDXvmwiKw+C
	qGnfhPrGMeUboPFx9dVU4pQtVFRIQMXp+cFb8W2w1eXyHtg/c52yQL+JDB7U+1mErxbgVpufqYT
	Sl5e+qryM4aPVZnrAZW6cVn
X-Received: by 2002:a05:6000:1250:b0:3d0:bec0:6c38 with SMTP id ffacd0b85a97d-3d0bec06f6emr1997239f8f.46.1756489280283;
        Fri, 29 Aug 2025 10:41:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHef7hnKsc4VKdyLJI/9fAoEaywqHHBYXSuku3r0gqpnCFH+0A5TWHYLgakwS0hhVJFGrbrMGcjC6C+4SEji84=
X-Received: by 2002:a05:6000:1250:b0:3d0:bec0:6c38 with SMTP id
 ffacd0b85a97d-3d0bec06f6emr1997230f8f.46.1756489279768; Fri, 29 Aug 2025
 10:41:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aLC1Su7FEo7XtI0K@linux.dev>
In-Reply-To: <aLC1Su7FEo7XtI0K@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 29 Aug 2025 19:41:01 +0200
X-Gm-Features: Ac12FXzYeuI8RGEBRq2btI1bTSLuptZUKYiDZDZWLc4r05Cd1Uj13b5LkYmiX5c
Message-ID: <CABgObfakE9wDkXSm0mDEc3rbe1DiQG8LPsofE++DzEO6_WKB2g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 changes for 6.17, take #2
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TAuBk6WMZHvEvzl5ULgSDHE_61mkjXkMfhQdGZrJZsY_1756489281
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025 at 10:00=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Paolo,
>
> Unfortunately work had me sidelined for an extended period of time, so
> after much delay here is a pile of fixes for 6.17. This is a bit larger
> than I would like, but the handling of on-CPU sysregs has had multiple ug=
ly
> bugs and a localized fix would just be unnecessary churn.

It's fine, I added some extra context from the commit message in my
pull request to Linus.

Thanks,

Paolo

> Details in the tag; please pull.
>
> Thanks,
> Oliver
>
> The following changes since commit 18ec25dd0e97653cdb576bb1750c31acf2513e=
a7:
>
>   KVM: arm64: selftests: Add FEAT_RAS EL2 registers to get-reg-list (2025=
-07-28 08:28:05 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.17-1
>
> for you to fetch changes up to ee372e645178802be7cb35263de941db7b2c5354:
>
>   KVM: arm64: nv: Fix ATS12 handling of single-stage translation (2025-08=
-28 12:44:42 -0700)
>
> ----------------------------------------------------------------
> KVM/arm64 changes for 6.17, take #2
>
>  - Correctly handle 'invariant' system registers for protected VMs
>
>  - Improved handling of VNCR data aborts, including external aborts
>
>  - Fixes for handling of FEAT_RAS for NV guests, providing a sane
>    fault context during SEA injection and preventing the use of
>    RASv1p1 fault injection hardware
>
>  - Ensure that page table destruction when a VM is destroyed gives an
>    opportunity to reschedule
>
>  - Large fix to KVM's infrastructure for managing guest context loaded
>    on the CPU, addressing issues where the output of AT emulation
>    doesn't get reflected to the guest
>
>  - Fix AT S12 emulation to actually perform stage-2 translation when
>    necessary
>
>  - Avoid attempting vLPI irqbypass when GICv4 has been explicitly
>    disabled for a VM
>
>  - Minor KVM + selftest fixes
>
> ----------------------------------------------------------------
> Arnd Bergmann (1):
>       kvm: arm64: use BUG() instead of BUG_ON(1)
>
> Fuad Tabba (3):
>       KVM: arm64: Handle AIDR_EL1 and REVIDR_EL1 in host for protected VM=
s
>       KVM: arm64: Sync protected guest VBAR_EL1 on injecting an undef exc=
eption
>       arm64: vgic-v2: Fix guest endianness check in hVHE mode
>
> Marc Zyngier (14):
>       KVM: arm64: nv: Properly check ESR_EL2.VNCR on taking a VNCR_EL2 re=
lated fault
>       KVM: arm64: selftest: Add standalone test checking for KVM's own UU=
ID
>       KVM: arm64: Correctly populate FAR_EL2 on nested SEA injection
>       arm64: Add capability denoting FEAT_RASv1p1
>       KVM: arm64: Handle RASv1p1 registers
>       KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's EL2
>       KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable
>       KVM: arm64: Make ID_AA64PFR1_EL1.RAS_frac writable
>       KVM: arm64: Get rid of ARM64_FEATURE_MASK()
>       KVM: arm64: Check for SYSREGS_ON_CPU before accessing the 32bit sta=
te
>       KVM: arm64: Simplify sysreg access on exception delivery
>       KVM: arm64: Fix vcpu_{read,write}_sys_reg() accessors
>       KVM: arm64: Remove __vcpu_{read,write}_sys_reg_{from,to}_cpu()
>       KVM: arm64: nv: Fix ATS12 handling of single-stage translation
>
> Mark Brown (1):
>       KVM: arm64: selftests: Sync ID_AA64MMFR3_EL1 in set_id_regs
>
> Oliver Upton (1):
>       KVM: arm64: nv: Handle SEAs due to VNCR redirection
>
> Raghavendra Rao Ananta (3):
>       KVM: arm64: Don't attempt vLPI mappings when vPE allocation is disa=
bled
>       KVM: arm64: Split kvm_pgtable_stage2_destroy()
>       KVM: arm64: Reschedule as needed when destroying the stage-2 page-t=
ables
>
>  arch/arm64/include/asm/kvm_host.h                  | 111 +-----
>  arch/arm64/include/asm/kvm_mmu.h                   |   1 +
>  arch/arm64/include/asm/kvm_pgtable.h               |  30 ++
>  arch/arm64/include/asm/kvm_pkvm.h                  |   4 +-
>  arch/arm64/include/asm/kvm_ras.h                   |  25 --
>  arch/arm64/include/asm/sysreg.h                    |   3 -
>  arch/arm64/kernel/cpufeature.c                     |  24 ++
>  arch/arm64/kvm/arm.c                               |   8 +-
>  arch/arm64/kvm/at.c                                |   6 +-
>  arch/arm64/kvm/emulate-nested.c                    |   2 +-
>  arch/arm64/kvm/hyp/exception.c                     |  20 +-
>  arch/arm64/kvm/hyp/nvhe/list_debug.c               |   2 +-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   5 +
>  arch/arm64/kvm/hyp/pgtable.c                       |  25 +-
>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |   2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c                    |   5 +-
>  arch/arm64/kvm/mmu.c                               |  65 +++-
>  arch/arm64/kvm/nested.c                            |   5 +-
>  arch/arm64/kvm/pkvm.c                              |  11 +-
>  arch/arm64/kvm/sys_regs.c                          | 419 ++++++++++++++-=
------
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   8 +
>  arch/arm64/kvm/vgic/vgic-mmio.c                    |   2 +-
>  arch/arm64/kvm/vgic/vgic.h                         |  10 +-
>  arch/arm64/tools/cpucaps                           |   1 +
>  tools/arch/arm64/include/asm/sysreg.h              |   3 -
>  tools/testing/selftests/kvm/Makefile.kvm           |   1 +
>  .../testing/selftests/kvm/arm64/aarch32_id_regs.c  |   2 +-
>  .../testing/selftests/kvm/arm64/debug-exceptions.c |  12 +-
>  tools/testing/selftests/kvm/arm64/kvm-uuid.c       |  70 ++++
>  tools/testing/selftests/kvm/arm64/no-vgic-v3.c     |   4 +-
>  .../testing/selftests/kvm/arm64/page_fault_test.c  |   6 +-
>  tools/testing/selftests/kvm/arm64/set_id_regs.c    |   9 +-
>  .../selftests/kvm/arm64/vpmu_counter_access.c      |   2 +-
>  tools/testing/selftests/kvm/lib/arm64/processor.c  |   6 +-
>  34 files changed, 560 insertions(+), 349 deletions(-)
>  delete mode 100644 arch/arm64/include/asm/kvm_ras.h
>  create mode 100644 tools/testing/selftests/kvm/arm64/kvm-uuid.c
>

