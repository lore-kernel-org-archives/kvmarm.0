From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 6/8] arm64: KVM: Add synchronization on translation
 regime change for erratum 1165522
Date: Tue, 27 Nov 2018 09:51:03 +0000
Message-ID: <488a0599-fcc3-65bb-acf2-d017c02e39ac@arm.com>
References: <20181123184107.39334-1-marc.zyngier@arm.com>
 <20181123184107.39334-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 452F04A324
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Nov 2018 04:51:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iQjMnQQIZ-vT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Nov 2018 04:51:07 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 137774A321
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Nov 2018 04:51:07 -0500 (EST)
In-Reply-To: <20181123184107.39334-7-marc.zyngier@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 23/11/2018 18:41, Marc Zyngier wrote:
> In order to ensure that slipping HCR_EL2.TGE is done at the right
> time when switching translation regime, let insert the required ISBs
> that will be patched in when erratum 1165522 is detected.

Reviewed-by: James Morse <james.morse@arm.com>


> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 23aca66767f9..ce46bb1c5f4b 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -163,6 +163,13 @@ static __always_inline void __hyp_text __load_guest_stage2(struct kvm *kvm)
>  {
>  	write_sysreg(kvm->arch.vtcr, vtcr_el2);
>  	write_sysreg(kvm->arch.vttbr, vttbr_el2);
> +
> +	/*
> +	 * ARM erratum 1165522 requires the actual execution of the above
> +	 * before we can switch to the EL1/EL0 translation regime used by
> +	 * the guest.
> +	 */
> +	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));

(kvm_hyp.h doesn't include alternative.h, .... but already uses ALTERNATIVE())


Thanks,

James
