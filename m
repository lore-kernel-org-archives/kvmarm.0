Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE2481ADA
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 05:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729833481; cv=none; b=dxKbFQT5Re1OL3FgUYrdDXp8b3K5BHG7inIi026pFJEISz9jrQdocujNHIjgbDfl6JemdpjTBiVNvTizFDxRoq2IgotxHqPue1Aq1CSF2UcZ+4LAqZp1JpnfjJWiFZp1D4fj0JhHGWmW6qJSWvRo/5DSImlkkNAUapNIDSzRbhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729833481; c=relaxed/simple;
	bh=I4pmiyUhINIecMcBCwgPTwtCWUpPs5Rbd1ukL/gPB80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fcS3daULzK4TQvXot0nR+GSiJZ++01svEjUxXqAIXMmhNoHsuNJiVFyjt2z3YbjmR5iVyvb7tvY5WvygNP/+7ULVZI/7jMdVJKd/DfEGtyKOF+nPUahxFfE/zraJO27qDhq1AMnuBo46vj66DbjLGWm5ExCrzwHy6AzyrVlluQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 693D2339;
	Thu, 24 Oct 2024 22:18:27 -0700 (PDT)
Received: from [10.162.16.84] (unknown [10.162.16.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4D953F528;
	Thu, 24 Oct 2024 22:17:55 -0700 (PDT)
Message-ID: <7e6b683f-5dd0-4e94-9979-3dcca2d04f2c@arm.com>
Date: Fri, 25 Oct 2024 10:47:53 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/17] KVM: arm64: nv: Support for EL2 PMU controls
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/7/24 23:15, Oliver Upton wrote:
> Marc, I stole patch 1 from you for the sake of sending out a consistent
> series. I can sort things out when I apply patches if that patch is a
> common base for the both of us.
> 
> v2 -> v3:
>  - Use the sysreg sanitisation infrastructure to apply RES0/RES1 masks
>    to MDCR_EL2
>  - Drop trap_config bit describing if a trap applies to Host EL0
>  - Honor MDCR_EL2.{HPME,HLP} for the 'hypervisor range' of PMU counters
> 
> v2: https://lore.kernel.org/kvmarm/20240827002235.1753237-1-oliver.upton@linux.dev/#r
> 
> Marc Zyngier (1):
>   KVM: arm64: Extend masking facility to arbitrary registers
> 
> Oliver Upton (16):
>   arm64: sysreg: Migrate MDCR_EL2 definition to table
>   arm64: sysreg: Add missing definitions for ID_AA64DFR0_EL1
>   KVM: arm64: Describe RES0/RES1 bits of MDCR_EL2
>   KVM: arm64: nv: Allow coarse-grained trap combos to use complex traps
>   KVM: arm64: nv: Rename BEHAVE_FORWARD_ANY
>   KVM: arm64: nv: Reinject traps that take effect in Host EL0
>   KVM: arm64: nv: Honor MDCR_EL2.{TPM, TPMCR} in Host EL0
>   KVM: arm64: nv: Describe trap behaviour of MDCR_EL2.HPMN
>   KVM: arm64: nv: Advertise support for FEAT_HPMN0
>   KVM: arm64: Rename kvm_pmu_valid_counter_mask()
>   KVM: arm64: nv: Adjust range of accessible PMCs according to HPMN
>   KVM: arm64: Add helpers to determine if PMC counts at a given EL
>   KVM: arm64: nv: Honor MDCR_EL2.HPME
>   KVM: arm64: nv: Honor MDCR_EL2.HLP
>   KVM: arm64: nv: Apply EL2 event filtering when in hyp context
>   KVM: arm64: nv: Reprogram PMU events affected by nested transition
> 
>  arch/arm64/include/asm/kvm_arm.h     |  29 ---
>  arch/arm64/include/asm/kvm_emulate.h |   5 +
>  arch/arm64/include/asm/kvm_host.h    |  21 +-
>  arch/arm64/kvm/emulate-nested.c      | 298 ++++++++++++++++-----------
>  arch/arm64/kvm/nested.c              |  52 ++++-
>  arch/arm64/kvm/pmu-emul.c            | 136 ++++++++++--
>  arch/arm64/kvm/sys_regs.c            |  15 +-
>  arch/arm64/tools/sysreg              |  45 +++-
>  include/kvm/arm_pmu.h                |  18 +-
>  9 files changed, 432 insertions(+), 187 deletions(-)
> 
> 
> base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc

Hello Marc/Oliver,

I am planning to rebase the KVM FEAT_FGT2 series [1] on this one after accommodating
the following changes and respin.

- Latest changes to spec (https://developer.arm.com/documentation/ddi0601/2024-09/)
- Adding nDCCIVAPS and TSBCSYNC handling in HFGITR2_EL2 registers
- Integrating SYS_PMEVCNTSVR_EL1(N) handling in check_mdcr_hpmn() (proposed here)

OR should I just wait for this series to be merged mainline first. Please do suggest.
Thank you.

- Anshuman

[1] https://lore.kernel.org/all/20241001024356.1096072-1-anshuman.khandual@arm.com/
