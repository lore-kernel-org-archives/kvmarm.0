From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 38/38] KVM: arm64: Respect the virtual
 CPTR_EL2.TCPAC setting
Date: Mon, 31 Jul 2017 14:59:20 +0200
Message-ID: <20170731125920.GX5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-39-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5ABB40A80
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 08:58:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YDD32yPcNNEu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 08:58:10 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 834EE40960
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 08:58:10 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id m85so75052147wma.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 05:59:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1500397144-16232-39-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, marc.zyngier@arm.com, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:59:04AM -0500, Jintack Lim wrote:
> Forward CPACR_EL1 traps to the virtual EL2 if virtual CPTR_EL2 is
> configured to trap CPACR_EL1 accesses from EL1.
> 
> This is for recursive nested virtualization.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6f67666..ba2966d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1091,6 +1091,11 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
>  	if (el12_reg(p) && forward_nv_traps(vcpu))
>  		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>  
> +	/* Forward this trap to the virtual EL2 if CPTR_EL2.TCPAC is set*/
> +	if (!el12_reg(p) && !vcpu_mode_el2(vcpu) &&
> +	    (vcpu_sys_reg(vcpu, CPTR_EL2) & CPTR_EL2_TCPAC))
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +

I'm trying to understand what should happen if the VM is in EL1 and
accesses CPACR_EL12, but the guest hypervisor did not set
CPTR_EL2.TCPAC, why would we get here, and if there's a good reason why
we god here, is the EL12 access not supposed to undef at EL1 as opposed
to actually work, like it seems your code does when it doesn't take the
branch?

>  	/*
>  	 * When the virtual HCR_EL2.E2H == 1, an access to CPACR_EL1
>  	 * in the virtual EL2 is to access CPTR_EL2.
> -- 
> 1.9.1
> 

Thanks,
-Christoffer
