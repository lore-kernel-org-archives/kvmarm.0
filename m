From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 16/55] KVM: arm64: Forward VM reg traps to the guest
 hypervisor
Date: Wed, 22 Feb 2017 12:39:04 +0100
Message-ID: <20170222113904.GJ26976@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-17-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8042340C8E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 06:38:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DbPz2x4qYyE4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Feb 2017 06:38:20 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDCA140C72
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 06:38:19 -0500 (EST)
Received: by mail-wm0-f53.google.com with SMTP id v77so9024303wmv.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 03:39:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1483943091-1364-17-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, shihwei@cs.columbia.edu, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, andre.przywara@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 01:24:12AM -0500, Jintack Lim wrote:
> Forward virtual memory register traps to the guest hypervisor
> if it has set corresponding bits to the virtual HCR_EL2.

I was a bit confused about the subject of this patch.  I would recommend
calling it something like
"Respect virtul HCR_EL2.TVM and HCR_EL2.TRVM settings"

> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm64/kvm/sys_regs.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b8e993a..0f5d21b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -90,6 +90,23 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool forward_vm_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
> +{
> +	u64 hcr_el2 = vcpu_el2_reg(vcpu, HCR_EL2);
> +
> +	/* If this is a trap from the virtual EL2, the host handles */
> +	if (vcpu_mode_el2(vcpu))
> +		return false;
> +
> +	/* If the guest wants to trap on R/W operation, forward this trap */
> +	if ((hcr_el2 & HCR_TVM) && p->is_write)
> +		return true;
> +	else if ((hcr_el2 & HCR_TRVM) && !p->is_write)
> +		return true;
> +
> +	return false;
> +}
> +
>  /*
>   * Generic accessor for VM registers. Only called as long as HCR_TVM
>   * is set. If the guest enables the MMU, we stop trapping the VM
> @@ -101,6 +118,9 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  {
>  	bool was_enabled = vcpu_has_cache_enabled(vcpu);
>  
> +	if (forward_vm_traps(vcpu, p))
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
>  	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
>  
>  	if (!p->is_write) {
> -- 
> 1.9.1
> 
> 
