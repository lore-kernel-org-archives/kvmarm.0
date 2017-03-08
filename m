From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/5] KVM: arm/arm64: prepare to use vcpu requests
Date: Wed, 8 Mar 2017 05:21:48 -0800
Message-ID: <20170308132148.GB109908@lvm>
References: <20170227175504.15751-1-drjones@redhat.com>
 <20170227175504.15751-2-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 975A140064
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 08:20:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9FRv9yU0Ynch for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Mar 2017 08:20:29 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6185E40019
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 08:20:28 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id t189so30569914wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Mar 2017 05:21:52 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170227175504.15751-2-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, ashoks@broadcom.com, imammedo@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 27, 2017 at 06:55:00PM +0100, Andrew Jones wrote:
> Make sure we don't leave vcpu requests we don't intend to
> handle later set in the request bitmap. If we don't clear
> them, then kvm_request_pending() may return true when we
> don't want it to.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm/kvm/handle_exit.c   | 1 +
>  arch/arm/kvm/psci.c          | 1 +
>  arch/arm64/kvm/handle_exit.c | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> index 4e40d1955e35..2ec31748fa0b 100644
> --- a/arch/arm/kvm/handle_exit.c
> +++ b/arch/arm/kvm/handle_exit.c
> @@ -72,6 +72,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		trace_kvm_wfx(*vcpu_pc(vcpu), false);
>  		vcpu->stat.wfi_exit_stat++;
>  		kvm_vcpu_block(vcpu);
> +		__kvm_request_clear(KVM_REQ_UNHALT, vcpu);
>  	}
>  
>  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
> index c2b131527a64..fd7e381b13b2 100644
> --- a/arch/arm/kvm/psci.c
> +++ b/arch/arm/kvm/psci.c
> @@ -57,6 +57,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
>  	 * for KVM will preserve the register state.
>  	 */
>  	kvm_vcpu_block(vcpu);
> +	__kvm_request_clear(KVM_REQ_UNHALT, vcpu);
>  
>  	return PSCI_RET_SUCCESS;
>  }
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 1bfe30dfbfe7..b34971d7c30a 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -89,6 +89,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
>  		vcpu->stat.wfi_exit_stat++;
>  		kvm_vcpu_block(vcpu);
> +		__kvm_request_clear(KVM_REQ_UNHALT, vcpu);
>  	}
>  
>  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> -- 
> 2.9.3
> 
