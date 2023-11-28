Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B75B1DA35
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 10:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2enpbhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F9FC433C7
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 10:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701168577;
	bh=tUkzum0x3uQ5g3yMZlFjFWf/DT7FZDPH7j7j0AAJCjE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=H2enpbhQpGKZg2yhQjAHEFxrHfQ8kwHwUgt/8nLfM3cjgxJmOWsqACqRpX08syplj
	 iW/nhjKNtRhSfxu00TamT97HyM8BqQG3lvqHDBUR4IhMioOYRzzFeQ2Pe7g2NyMfkr
	 mKyzfP/ch8rZnpSaq1UMKniD8Tpqx68H+5YRJxdaHbm5y+9M3Ix41Y1RxVFeLc0Bx0
	 7QcJ0qdbC0nNkbKVezO7/IU6HKPWx8eHpHvl1TlqkxVkFGMYcVAoLFjLmy4BlnzCnD
	 Rpwip9CnX51fHbG6TRHXl17kEffAMR/srLiqvm1WBC87DRxKTD1Rez2HdC6MKlrfSh
	 PqjfARJNzmxfg==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2c501bd6ff1so70787001fa.3
        for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 02:49:37 -0800 (PST)
X-Gm-Message-State: AOJu0YyNSNcrh4hxSFd1v6FDdtc37+0SynIz7OCoJ7ochgdmCcCaLk2H
	I9diIrMuT0alI2LLZ/b3JifYffNV4UIuU1ICc/k=
X-Google-Smtp-Source: AGHT+IGHhRa6/wWTa9cg45X0LpR6jDhr25e6kgVLfLLp0Jv2e2zFqDC2vJjEtvJ3UAzRbyYLX/RmSqOm16uWqTtysrE=
X-Received: by 2002:a2e:8e26:0:b0:2c9:9ca2:25f5 with SMTP id
 r6-20020a2e8e26000000b002c99ca225f5mr4859654ljk.49.1701168575735; Tue, 28 Nov
 2023 02:49:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231127111737.1897081-1-ryan.roberts@arm.com> <20231127111737.1897081-9-ryan.roberts@arm.com>
In-Reply-To: <20231127111737.1897081-9-ryan.roberts@arm.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 28 Nov 2023 11:49:24 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG-ry6UntNRgtOw-mTEadtNuvmKCy2-FFmYjvZqHmbS1Q@mail.gmail.com>
Message-ID: <CAMj1kXG-ry6UntNRgtOw-mTEadtNuvmKCy2-FFmYjvZqHmbS1Q@mail.gmail.com>
Subject: Re: [PATCH v6 08/12] KVM: arm64: Convert translation level parameter
 to s8
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Nov 2023 at 12:18, Ryan Roberts <ryan.roberts@arm.com> wrote:
>
> With the introduction of FEAT_LPA2, the Arm ARM adds a new lel of
> translation, level -1, so levels can now be in the range [-1;3]. 3 is
> always the last level and the first level is determined based on the
> number of VA bits in use.
>
> Convert level variables to use a signed type in preparation for
> supporting this new level -1.
>
> Since the last level is always anchored at 3, and the first level varies
> to suit the number of VA/IPA bits, take the opportunity to replace
> KVM_PGTABLE_MAX_LEVELS with the 2 macros KVM_PGTABLE_FIRST_LEVEL and
> KVM_PGTABLE_LAST_LEVEL. This removes the assumption from the code that
> levels run from 0 to KVM_PGTABLE_MAX_LEVELS - 1, which will soon no
> longer be true.
>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h  |  2 +-
>  arch/arm64/include/asm/kvm_pgtable.h  | 31 +++++++------
>  arch/arm64/include/asm/kvm_pkvm.h     |  5 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +--
>  arch/arm64/kvm/hyp/nvhe/mm.c          |  4 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c       |  2 +-
>  arch/arm64/kvm/hyp/pgtable.c          | 66 +++++++++++++++------------
>  arch/arm64/kvm/mmu.c                  | 16 ++++---
>  8 files changed, 71 insertions(+), 61 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 78a550537b67..13fd9dbf2d1d 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -409,7 +409,7 @@ static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vc
>         return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_TYPE;
>  }
>
> -static __always_inline u8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
> +static __always_inline s8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
>  {
>         return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_LEVEL;
>  }

This helper is currently only used for permission faults, which don't
exist at level -1. Also, there is only a single caller of this helper,
which uses the result only to infer the size covered by the block
entry that describes the mapping.

So in my LPA2 series, I intend to remove this helper altogether, and
just replace it with something along the lines of

static inline
u64 kvm_vcpu_trap_get_perm_fault_granule(const struct kvm_vcpu *vcpu)
{
    unsigned long esr = kvm_vcpu_get_esr(vcpu);

    BUG_ON(!esr_is_permission_fault(esr));
    return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(esr & ESR_ELx_FSC_LEVEL));
}

to avoid having to reason about whether masking with ESR_ELx_FSC_LEVEL
is appropriate for the fault type in question.

https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=arm64-lpa2-v6-combined&id=26c3425ec73ca751c45848f6f3f2d96e02cb4327
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=arm64-lpa2-v6-combined&id=d6a849d6b318e70bf2f80f9b18a933136520019a
