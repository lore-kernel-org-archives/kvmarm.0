From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 4/4] arm64: KVM: Implement workaround for Cortex-A76
 erratum 1165522
Date: Mon, 5 Nov 2018 18:34:35 +0000
Message-ID: <a13dfb2d-df5b-7783-2e8b-8a8ffe50b436@arm.com>
References: <20181105143617.120602-1-marc.zyngier@arm.com>
 <20181105143617.120602-5-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BFB84A31B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Nov 2018 13:34:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W4-f7AhAkYK4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Nov 2018 13:34:40 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E99E14A2BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Nov 2018 13:34:39 -0500 (EST)
In-Reply-To: <20181105143617.120602-5-marc.zyngier@arm.com>
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

On 05/11/2018 14:36, Marc Zyngier wrote:
> Early versions of Cortex-A76 can end-up with corrupt TLBs if they
> speculate an AT instruction in during a guest switch while the

                              (in during?)

> S1/S2 system registers are in an inconsistent state.
> 
> Work around it by:
> - Mandating VHE
> - Make sure that S1 and S2 system registers are consistent before
>    clearing HCR_EL2.TGE, which allows AT to target the EL1 translation
>    regime
> 
> These two things together ensure that we cannot hit this erratum.


> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 51d5d966d9e5..322109183853 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -143,6 +143,13 @@ static void deactivate_traps_vhe(void)
>   {
>   	extern char vectors[];	/* kernel exception vectors */
>   	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
> +
> +	/*
> +	 * ARM erratum 1165522 requires the actual execution of the
> +	 * above before we can switch to the host translation regime.
> +	 */
> +	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));
> +

Host regime too ... does __tlb_switch_to_host_vhe() need the same 
treatment? It writes vttbr_el2 and hcr_el2 back to back.



Thanks,

James
