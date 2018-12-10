From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 3/8] arm64: KVM: Install stage-2 translation before
 enabling traps
Date: Mon, 10 Dec 2018 11:13:57 +0100
Message-ID: <20181210101357.GI30263@e113682-lin.lund.arm.com>
References: <20181206173126.139877-1-marc.zyngier@arm.com>
 <20181206173126.139877-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03E1B4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:14:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Afdbt-78eMEZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 05:13:59 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFF3E4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:13:59 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181206173126.139877-4-marc.zyngier@arm.com>
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

On Thu, Dec 06, 2018 at 05:31:21PM +0000, Marc Zyngier wrote:
> It is a bit odd that we only install stage-2 translation after having
> cleared HCR_EL2.TGE, which means that there is a window during which
> AT requests could fail as stage-2 is not configured yet.
> 
> Let's move stage-2 configuration before we clear TGE, making the
> guest entry sequence clearer: we first configure all the guest stuff,
> then only switch to the guest translation regime.
> 
> While we're at it, do the same thing for !VHE. It doesn't hurt,
> and keeps things symmetric.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 7cc175c88a37..a8fa61c68c32 100644
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
> @@ -545,8 +545,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  
>  	__sysreg_save_state_nvhe(host_ctxt);
>  
> -	__activate_traps(vcpu);
>  	__activate_vm(kern_hyp_va(vcpu->kvm));
> +	__activate_traps(vcpu);
>  
>  	__hyp_vgic_restore_state(vcpu);
>  	__timer_enable_traps(vcpu);
> -- 
> 2.19.2
> 

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
