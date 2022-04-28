Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26637C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 08:46:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B65D4B26F;
	Thu, 28 Apr 2022 04:46:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V3LzZsWfG6j6; Thu, 28 Apr 2022 04:46:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 244104B260;
	Thu, 28 Apr 2022 04:46:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA29C4B231
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 04:46:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x4YyhZYw5sqE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 04:46:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 370A84B1EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 04:46:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD9FF1474;
 Thu, 28 Apr 2022 01:46:21 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09E693F774;
 Thu, 28 Apr 2022 01:46:19 -0700 (PDT)
Date: Thu, 28 Apr 2022 09:46:21 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Inject exception on out-of-IPA-range
 translation fault
Message-ID: <YmpUXWRJc3Kq3wGE@monolith.localdoman>
References: <20220427220434.3097449-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220427220434.3097449-1-maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Christoffer Dall <christoffer.dall@arm.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

On Wed, Apr 27, 2022 at 11:04:34PM +0100, Marc Zyngier wrote:
> When taking a translation fault for an IPA that is outside of
> the range defined by the hypervisor (between the HW PARange and
> the IPA range), we stupidly treat it as an IO and forward the access
> to userspace. Of course, userspace can't do much with it, and things
> end badly.
> 
> Arguably, the guest is braindead, but we should at least catch the
> case and inject an exception.
> 
> Check the faulting IPA against:
> - the sanitised PARange: inject an address size fault
> - the IPA size: inject an abort
> 
> Reported-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  1 +
>  arch/arm64/kvm/inject_fault.c        | 28 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/mmu.c                 | 19 +++++++++++++++++++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 7496deab025a..f71358271b71 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -40,6 +40,7 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu);
>  void kvm_inject_vabt(struct kvm_vcpu *vcpu);
>  void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
>  void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
> +void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
>  
>  void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index b47df73e98d7..ba20405d2dc2 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -145,6 +145,34 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
>  		inject_abt64(vcpu, true, addr);
>  }
>  
> +void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long addr, esr;
> +
> +	addr  = kvm_vcpu_get_fault_ipa(vcpu);
> +	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> +
> +	if (kvm_vcpu_trap_is_iabt(vcpu))
> +		kvm_inject_pabt(vcpu, addr);
> +	else
> +		kvm_inject_dabt(vcpu, addr);
> +
> +	/*
> +	 * If AArch64 or LPAE, set FSC to 0 to indicate an Address
> +	 * Size Fault at level 0, as if exceeding PARange.
> +	 *
> +	 * Non-LPAE guests will only get the external abort, as there
> +	 * is no way to to describe the ASF.
> +	 */
> +	if (vcpu_el1_is_32bit(vcpu) &&
> +	    !(vcpu_read_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE))
> +		return;
> +
> +	esr = vcpu_read_sys_reg(vcpu, ESR_EL1);
> +	esr &= ~GENMASK_ULL(5, 0);
> +	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +}
> +
>  /**
>   * kvm_inject_undefined - inject an undefined instruction into the guest
>   * @vcpu: The vCPU in which to inject the exception
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 53ae2c0640bc..5400fc020164 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1337,6 +1337,25 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>  
> +	if (fault_status == FSC_FAULT) {
> +		/* Beyond sanitised PARange (which is the IPA limit) */
> +		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> +			kvm_inject_size_fault(vcpu);
> +			return 1;
> +		}
> +
> +		/* Falls between the IPA range and the PARange? */
> +		if (fault_ipa >= BIT_ULL(vcpu->arch.hw_mmu->pgt->ia_bits)) {
> +			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> +
> +			if (is_iabt)
> +				kvm_inject_pabt(vcpu, fault_ipa);
> +			else
> +				kvm_inject_dabt(vcpu, fault_ipa);
> +			return 1;
> +		}

Doesn't KVM treat faults outside a valid memslot (aka guest RAM) as MMIO
aborts? From the guest's point of view, the IPA is valid because it's
inside the HW PARange, so it's not entirely impossible that the VMM put a
device there.

Thanks,
Alex

> +	}
> +
>  	/* Synchronous External Abort? */
>  	if (kvm_vcpu_abt_issea(vcpu)) {
>  		/*
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
