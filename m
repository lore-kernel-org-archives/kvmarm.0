From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 3/4] arm64: KVM: Install stage-2 translation before
 enabling traps on VHE
Date: Tue, 6 Nov 2018 09:06:57 +0100
Message-ID: <20181106080657.GG12057@e113682-lin.lund.arm.com>
References: <20181105143617.120602-1-marc.zyngier@arm.com>
 <20181105143617.120602-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B4634A31D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 03:07:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LR8lLTHEG53r for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Nov 2018 03:07:00 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49EE74A31B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 03:07:00 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181105143617.120602-4-marc.zyngier@arm.com>
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

On Mon, Nov 05, 2018 at 02:36:15PM +0000, Marc Zyngier wrote:
> It is a bit odd that we only install stage-2 translation after having
> cleared HCR_EL2.TGE, which means that there is a window during which
> AT requests could fail as stage-2 is not configured yet.
> 
> Let's move stage-2 configuration before we clear TGE, making the
> guest entry sequence clearer: we first configure all the guest stuff,
> then only switch to the guest translation regime.
> 
> Non-VHE doesn't have that kind of behaviour, and is left alone.

I'm a bit confused about this statement.  You can still issue a S12E1x
AT instruction after activating traps (setting HCR_EL2.VM) on non-VHE
and get at the same behavior, right?

Is the point here that we are not aware of any non-VHE implementations
that speculate AT instructions in this window, or am I missing some
architectural nugget that prevents problems on non-VHE systems?

In any case, why not change the non-VHE code as well to preserve
symmetry for both types of systems?


Thanks,

    Christoffer

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 7cc175c88a37..51d5d966d9e5 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -499,8 +499,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  
>  	sysreg_save_host_state_vhe(host_ctxt);
>  
> -	__activate_traps(vcpu);
>  	__activate_vm(vcpu->kvm);
> +	__activate_traps(vcpu);
>  
>  	sysreg_restore_guest_state_vhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
> -- 
> 2.19.1
> 
