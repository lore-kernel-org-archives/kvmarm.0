Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF1758AB0
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYbpEa28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615A8C433C9
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701179445;
	bh=SxoUOOnNq1+F5smHn5ZoplP80wZSsy9FIAJno24EMyM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KYbpEa2898+UF3lSkxcnUTX2Dfp4wGfRmA6tIOtv8+I087R2TuHYyyp+OhZ3JyaO6
	 j3n5GOtJg/4xt+Nu7qv/aqhvc5AfD8Ofn8UHmZ9q69EV7FKTaxKOcQTTz7wyjF1wvT
	 FpGnJuSu4TJzIBcnmaHgqCkn6upYNHcFWAwsiySg2QFIviWmfBz9ba38s69UCQNjfs
	 d/hBHyZGmMPO2y/fA6/VwQlZOhDEcJsW5eeshtC6qseCwxDSKxT8yI73+oIjUhcA58
	 e4FK1DAMsYJzMiO+n/K9UjWDkU1Nuf4Twc+PVBvYBU3GUpdKYisTgbJzuRozAj+mIx
	 tXDLzLWZPHAbw==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2c88b7e69dfso66566561fa.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 05:50:45 -0800 (PST)
X-Gm-Message-State: AOJu0YyCpEzRUyY5hVAq1TwX4sD2UYcBgYkMDuMvzFHsC5X3VlHRdGxG
	6FWVTtFbrpKpf2YEPuBhDCyy2gseuYklFuiDwmk=
X-Google-Smtp-Source: AGHT+IGLlPnzlUN5YbTlg0lVxqdMkxwcMkZJcY63OvwA1zAsRn9VPXYHFnM6hzix3zM9n5G0GoMzISI+Mc54ylLxYY8=
X-Received: by 2002:a2e:97d6:0:b0:2c5:16c0:6239 with SMTP id
 m22-20020a2e97d6000000b002c516c06239mr10186835ljj.51.1701179443564; Tue, 28
 Nov 2023 05:50:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231127111737.1897081-1-ryan.roberts@arm.com>
 <20231127111737.1897081-9-ryan.roberts@arm.com> <CAMj1kXG-ry6UntNRgtOw-mTEadtNuvmKCy2-FFmYjvZqHmbS1Q@mail.gmail.com>
 <b6a003e1-effd-46a4-9f4f-b686dc97517b@arm.com> <86a5qyc7vs.wl-maz@kernel.org>
In-Reply-To: <86a5qyc7vs.wl-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 28 Nov 2023 14:50:29 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF=Q82wJoOO_d7B4ozpVn7v-cgX6C1rMKHLQzpaPW2m+w@mail.gmail.com>
Message-ID: <CAMj1kXF=Q82wJoOO_d7B4ozpVn7v-cgX6C1rMKHLQzpaPW2m+w@mail.gmail.com>
Subject: Re: [PATCH v6 08/12] KVM: arm64: Convert translation level parameter
 to s8
To: Marc Zyngier <maz@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Nov 2023 at 14:41, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 28 Nov 2023 12:23:38 +0000,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
> >
> > On 28/11/2023 10:49, Ard Biesheuvel wrote:
> > > On Mon, 27 Nov 2023 at 12:18, Ryan Roberts <ryan.roberts@arm.com> wrote:
> > >>
> > >> With the introduction of FEAT_LPA2, the Arm ARM adds a new lel of
> > >> translation, level -1, so levels can now be in the range [-1;3]. 3 is
> > >> always the last level and the first level is determined based on the
> > >> number of VA bits in use.
> > >>
> > >> Convert level variables to use a signed type in preparation for
> > >> supporting this new level -1.
> > >>
> > >> Since the last level is always anchored at 3, and the first level varies
> > >> to suit the number of VA/IPA bits, take the opportunity to replace
> > >> KVM_PGTABLE_MAX_LEVELS with the 2 macros KVM_PGTABLE_FIRST_LEVEL and
> > >> KVM_PGTABLE_LAST_LEVEL. This removes the assumption from the code that
> > >> levels run from 0 to KVM_PGTABLE_MAX_LEVELS - 1, which will soon no
> > >> longer be true.
> > >>
> > >> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> > >> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> > >> ---
> > >>  arch/arm64/include/asm/kvm_emulate.h  |  2 +-
> > >>  arch/arm64/include/asm/kvm_pgtable.h  | 31 +++++++------
> > >>  arch/arm64/include/asm/kvm_pkvm.h     |  5 +-
> > >>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +--
> > >>  arch/arm64/kvm/hyp/nvhe/mm.c          |  4 +-
> > >>  arch/arm64/kvm/hyp/nvhe/setup.c       |  2 +-
> > >>  arch/arm64/kvm/hyp/pgtable.c          | 66 +++++++++++++++------------
> > >>  arch/arm64/kvm/mmu.c                  | 16 ++++---
> > >>  8 files changed, 71 insertions(+), 61 deletions(-)
> > >>
> > >> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > >> index 78a550537b67..13fd9dbf2d1d 100644
> > >> --- a/arch/arm64/include/asm/kvm_emulate.h
> > >> +++ b/arch/arm64/include/asm/kvm_emulate.h
> > >> @@ -409,7 +409,7 @@ static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vc
> > >>         return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_TYPE;
> > >>  }
> > >>
> > >> -static __always_inline u8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
> > >> +static __always_inline s8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
> > >>  {
> > >>         return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_LEVEL;
> > >>  }
> > >
> > > This helper is currently only used for permission faults, which don't
> > > exist at level -1. Also, there is only a single caller of this helper,
> > > which uses the result only to infer the size covered by the block
> > > entry that describes the mapping.
> > >
> > > So in my LPA2 series, I intend to remove this helper altogether, and
> > > just replace it with something along the lines of
> > >
> > > static inline
> > > u64 kvm_vcpu_trap_get_perm_fault_granule(const struct kvm_vcpu *vcpu)
> > > {
> > >     unsigned long esr = kvm_vcpu_get_esr(vcpu);
> > >
> > >     BUG_ON(!esr_is_permission_fault(esr));
> > >     return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(esr & ESR_ELx_FSC_LEVEL));
> > > }
> > >
> > > to avoid having to reason about whether masking with ESR_ELx_FSC_LEVEL
> > > is appropriate for the fault type in question.
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=arm64-lpa2-v6-combined&id=26c3425ec73ca751c45848f6f3f2d96e02cb4327
> > > https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=arm64-lpa2-v6-combined&id=d6a849d6b318e70bf2f80f9b18a933136520019a
> > >
> >
> > This would take me an afternoon to get educated enough to even be able to offer
> > an opinon. So I'll leave this to the bigger boys to discuss. :)
>
> Dunno who the big boys are (I'm rather small, myself).
>
> Looking at the first patch, I rather like that cleanup. It makes it
> clear (cue the fault_granule handling for permission fault) that we
> should consider splitting user_mem_abort() into two functions: one
> that deals with translation faults, and one that is solely concerned
> with permissions faults.
>
> Ard, if you want to split the KVM stuff from the core arch code in
> that patch and post the result, I'd be happy to take it for a ride in
> -next.
>

Sure. The only core arch code that it touches is mm/fault.c, beyond
adding the esr_is_*_fault() helpers, which the KVM code depends on.

So i'll just keep those in asm/esr.h, unless you prefer to add them to
a kvm/arm include now and move them later?
