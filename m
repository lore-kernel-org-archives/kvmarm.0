From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 22/38] KVM: arm64: Handle PSCI call via smc from
 the guest
Date: Sun, 30 Jul 2017 22:00:20 +0200
Message-ID: <20170730200020.GL5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-23-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D158340D16
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 15:59:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IyvDwDpDd45E for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Jul 2017 15:59:09 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAD2D49C14
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 15:59:09 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id m85so154174347wma.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 13:00:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1500397144-16232-23-git-send-email-jintack.lim@linaro.org>
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

On Tue, Jul 18, 2017 at 11:58:48AM -0500, Jintack Lim wrote:
> VMs used to execute hvc #0 for the psci call if EL3 is not implemented.
> However, when we come to provide the virtual EL2 mode to the VM, the
> host OS inside the VM calls kvm_call_hyp() which is also hvc #0. So,
> it's hard to differentiate between them from the host hypervisor's point
> of view.

This is a bit confusing.  I think you should just refer to the fact that
the architecture requires HVC calls to be handled at EL2, and when
emulating EL2 inside the VM, HVC calls from the VM are handled by the VM
itself, and therefore we add the support for SMC as the conduit for PSCI
calls.

> 
> So, let the VM execute smc instruction for the psci call. On ARMv8.3,
> even if EL3 is not implemented, a smc instruction executed at non-secure
> EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than being treated as
> UNDEFINED. So, the host hypervisor can handle this psci call without any
> confusion.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index d19e253..6cf6b93 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -53,8 +53,28 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
> -	kvm_inject_undefined(vcpu);
> -	return 1;
> +	int ret;
> +
> +	/* If imm is non-zero, it's not defined */
> +	if (kvm_vcpu_hvc_get_imm(vcpu)) {
> +		kvm_inject_undefined(vcpu);
> +		return 1;
> +	}
> +
> +	/*
> +	 * If imm is zero, it's a psci call.

That's only a necessary, but not sufficient requirement.  So we should
say, it may be a PSCI call or we check if it's a PSCI call...



> +	 * Note that on ARMv8.3, even if EL3 is not implemented, SMC executed
> +	 * at Non-secure EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than
> +	 * being treated as UNDEFINED.
> +	 */
> +	ret = kvm_psci_call(vcpu);
> +	if (ret < 0) {
> +		kvm_inject_undefined(vcpu);
> +		return 1;
> +	}
> +	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> +
> +	return ret;
>  }
>  
>  /*
> -- 
> 1.9.1
> 

Thanks,
-Christoffer
