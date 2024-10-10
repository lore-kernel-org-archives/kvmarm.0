Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036991BE23D
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 10:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728555543; cv=none; b=vEugjaCLhufUMoBZ3VbJw7T7D/qOq3Nn2ubVXywMeWjj8AAnUFnyC0EzcGpfHqZvwejlQ1ql69M3y2S3kFLzghtsaXj2LUqaOuaCwPnve4FeJby7RfpGd3Cbm0RFtlvuQ/pk8nP2+q1ueGGwbl+pRVQZMgGRdm0q4yzo2KOINHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728555543; c=relaxed/simple;
	bh=QY+UzrPLRuoYedCIabq6aZHSKkvKxzYCgH/SgyaWQB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eH7kcE63vBljlhjGL+OWKnUKU+bkMAyT06aQwAdHejDVK2nP1MRp+rduXN0dAAXDdlevkCCaWoIC47ziGYosj8WTgEZySnfgOMwyLRF91jz82CxCd245spD1J49eoiIP1egADplrbzS/BSiybUAHHIu+jSZA7p5XHWt/lT51854=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB83C497;
	Thu, 10 Oct 2024 03:19:30 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66AD43F58B;
	Thu, 10 Oct 2024 03:18:59 -0700 (PDT)
Date: Thu, 10 Oct 2024 11:18:54 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Gavin Shan <gshan@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	anshuman.khandual@arm.com, james.morse@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 4/7] KVM: arm64: Fix missing traps of guest accesses
 to the MPAM registers
Message-ID: <20241010101854.GA3084174@e124191.cambridge.arm.com>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
 <20241004110714.2051604-5-joey.gouly@arm.com>
 <c98586dc-da5f-44f2-9ed7-1acb6d9afe86@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c98586dc-da5f-44f2-9ed7-1acb6d9afe86@redhat.com>

Hi Gavin,

Thanks for looking at the patches!

On Wed, Oct 09, 2024 at 03:53:46PM +1000, Gavin Shan wrote:
> On 10/4/24 9:07 PM, Joey Gouly wrote:
> > From: James Morse <james.morse@arm.com>
> > 
> > commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
> > ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
> > but didn't add trap handling.
> > 
> > If you are unlucky, this results in an MPAM aware guest being delivered
> > an undef during boot. The host prints:
> > | kvm [97]: Unsupported guest sys_reg access at: ffff800080024c64 [00000005]
> > | { Op0( 3), Op1( 0), CRn(10), CRm( 5), Op2( 0), func_read },
> > 
> > Which results in:
> > | Internal error: Oops - Undefined instruction: 0000000002000000 [#1] PREEMPT SMP
> > | Modules linked in:
> > | CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.6.0-rc7-00559-gd89c186d50b2 #14616
> > | Hardware name: linux,dummy-virt (DT)
> > | pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > | pc : test_has_mpam+0x18/0x30
> > | lr : test_has_mpam+0x10/0x30
> > | sp : ffff80008000bd90
> > ...
> > | Call trace:
> > |  test_has_mpam+0x18/0x30
> > |  update_cpu_capabilities+0x7c/0x11c
> > |  setup_cpu_features+0x14/0xd8
> > |  smp_cpus_done+0x24/0xb8
> > |  smp_init+0x7c/0x8c
> > |  kernel_init_freeable+0xf8/0x280
> > |  kernel_init+0x24/0x1e0
> > |  ret_from_fork+0x10/0x20
> > | Code: 910003fd 97ffffde 72001c00 54000080 (d538a500)
> > | ---[ end trace 0000000000000000 ]---
> > | Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> > | ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---
> > 
> > Add the support to enable the traps, and handle the three guest accessible
> > registers by injecting an UNDEF. This stops KVM from spamming the host
> > log, but doesn't yet hide the feature from the id registers.
> > 
> > With MPAM v1.0 we can trap the MPAMIDR_EL1 register only if
> > ARM64_HAS_MPAM_HCR, with v1.1 an additional MPAM2_EL2.TIDR bit traps
> > MPAMIDR_EL1 on platforms that don't have MPAMHCR_EL2. Enable one of
> > these if either is supported. If neither is supported, the guest can
> > discover that the CPU has MPAM support, and how many PARTID etc the
> > host has ... but it can't influence anything, so its harmless.
> > 
> > Fixes: 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in ID_AA64PFR0 register")
> > CC: Anshuman Khandual <anshuman.khandual@arm.com>
> > Link: https://lore.kernel.org/linux-arm-kernel/20200925160102.118858-1-james.morse@arm.com/
> > Signed-off-by: James Morse <james.morse@arm.com>
> > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > ---
> >   arch/arm64/include/asm/cpufeature.h     |  2 +-
> >   arch/arm64/include/asm/kvm_arm.h        |  1 +
> >   arch/arm64/include/asm/mpam.h           |  2 +-
> >   arch/arm64/kernel/image-vars.h          |  5 ++++
> >   arch/arm64/kvm/hyp/include/hyp/switch.h | 32 +++++++++++++++++++++++++
> >   arch/arm64/kvm/sys_regs.c               | 11 +++++++++
> >   6 files changed, 51 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > index 1abe55e62e63..985d966787b1 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -845,7 +845,7 @@ static inline bool system_supports_poe(void)
> >   		alternative_has_cap_unlikely(ARM64_HAS_S1POE);
> >   }
> > -static inline bool cpus_support_mpam(void)
> > +static __always_inline bool cpus_support_mpam(void)
> >   {
> >   	return alternative_has_cap_unlikely(ARM64_MPAM);
> >   }
> 
> The changes belong to PATCH[3/7] if I'm correct.
> 
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 109a85ee6910..16afb7a79b15 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -103,6 +103,7 @@
> >   #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
> >   #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
> > +#define MPAMHCR_HOST_FLAGS	0
> >   /* TCR_EL2 Registers bits */
> >   #define TCR_EL2_DS		(1UL << 32)
> > diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> > index d3ef0b5cd456..3ffe0f34ffff 100644
> > --- a/arch/arm64/include/asm/mpam.h
> > +++ b/arch/arm64/include/asm/mpam.h
> > @@ -15,7 +15,7 @@
> >   DECLARE_STATIC_KEY_FALSE(arm64_mpam_has_hcr);
> >   /* check whether all CPUs have MPAM virtualisation support */
> > -static inline bool mpam_cpus_have_mpam_hcr(void)
> > +static __always_inline bool mpam_cpus_have_mpam_hcr(void)
> >   {
> >   	if (IS_ENABLED(CONFIG_ARM64_MPAM))
> >   		return static_branch_unlikely(&arm64_mpam_has_hcr);
> 
> Save as above, the changes belong to PATCH[3/7].

These changes are in this patch, because this is the point in which KVM
(specifically HYP/nVHE) starts to use the helpers.

See for example: e43f1331e2ef ("arm64: Ask the compiler to __always_inline functions used by KVM at HYP")

I can merge them into the earlier patch, but having them here is a bit of
documentation-ish. I could mention it in the commit message too. Or merge them,
I'm fine either way!

Thanks,
Joey
