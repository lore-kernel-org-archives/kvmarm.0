Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6161BC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 16:02:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E81C7410BB;
	Tue, 18 Jan 2022 11:02:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id inUYFVj7bA7o; Tue, 18 Jan 2022 11:02:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8035941174;
	Tue, 18 Jan 2022 11:02:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B590E410BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 11:02:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rM+scbDDVBmh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jan 2022 11:02:40 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6576440C10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 11:02:40 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=dFTabTdMoMcJX1XAylG9vpg02jHwFRqVOFjS9QtjHec=; b=ELDZgodye0MbuAoZBjEoNdnMI4
 tokDuzjdcsUpsrzp0Ze3ziq57JnUcsa+ccHZH0fZ1jpmzGEzZDftZn7KyVK1lLTL1wchBLuAocT7O
 vjYOBQSAB8G3/itrOYh9ubK1UqRxcURddmAhyjFqlsEH6HHd6ypiV9sh2vDAAqGGCZ7GrzuUNoQYg
 IYXEVdwyz/6u0flq/HJkiha4Xz67xzK/WF3q0LjMhh2piAv4guzj8BuUunYR8bWWwYj5z8RnQ1/E1
 hrKHvIphIky5Z/uoKRPtQ0zhgJDNs9JQtdSMb4QtLrlEE8QeI7W5/Xc1dcHnVGC1apzQ7SI6AZlHJ
 IHcMaI8A==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56764)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1n9qwL-0003wp-Aq; Tue, 18 Jan 2022 16:02:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1n9qwG-0004Q0-6S; Tue, 18 Jan 2022 16:02:28 +0000
Date: Tue, 18 Jan 2022 16:02:28 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 14/69] KVM: arm64: nv: Support virtual EL2 exceptions
Message-ID: <YebklBdMSwOplyrJ@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-15-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-15-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Nov 29, 2021 at 08:00:55PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Support injecting exceptions and performing exception returns to and
> from virtual EL2.  This must be done entirely in software except when
> taking an exception from vEL0 to vEL2 when the virtual HCR_EL2.{E2H,TGE}
> == {1,1}  (a VHE guest hypervisor).
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: switch to common exception injection framework]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
...
> +void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
> +{
> +	u64 spsr, elr, mode;
> +	bool direct_eret;
> +
> +	/*
> +	 * Going through the whole put/load motions is a waste of time
> +	 * if this is a VHE guest hypervisor returning to its own
> +	 * userspace, or the hypervisor performing a local exception
> +	 * return. No need to save/restore registers, no need to
> +	 * switch S2 MMU. Just do the canonical ERET.
> +	 */
> +	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
> +	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +	direct_eret  = (mode == PSR_MODE_EL0t &&
> +			vcpu_el2_e2h_is_set(vcpu) &&
> +			vcpu_el2_tge_is_set(vcpu));
> +	direct_eret |= (mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t);

There are excessive parens on the RHS of the above two.

> +static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
> +				     enum exception_type type)
> +{
> +	trace_kvm_inject_nested_exception(vcpu, esr_el2, type);
> +
> +	switch (type) {
> +	case except_type_sync:
> +		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_ELx_SYNC;
> +		break;
> +	case except_type_irq:
> +		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_ELx_IRQ;
> +		break;
> +	default:
> +		WARN_ONCE(1, "Unsupported EL2 exception injection %d\n", type);
> +	}
> +
> +	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL2		|
> +			     KVM_ARM64_PENDING_EXCEPTION);

Ditto, and the "|" has too much white space before it with no good
reason.

> +/*
> + * Emulate taking an exception to EL2.
> + * See ARM ARM J8.1.2 AArch64.TakeException()
> + */
> +static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
> +			     enum exception_type type)
> +{
> +	u64 pstate, mode;
> +	bool direct_inject;
> +
> +	if (!nested_virt_in_use(vcpu)) {
> +		kvm_err("Unexpected call to %s for the non-nesting configuration\n",
> +				__func__);

Too much indentation. I'm guessing this "unexpected" condition isn't
something that can be caused by a rogue guest? If it can, doesn't this
need to be rate limited?

> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * As for ERET, we can avoid doing too much on the injection path by
> +	 * checking that we either took the exception from a VHE host
> +	 * userspace or from vEL2. In these cases, there is no change in
> +	 * translation regime (or anything else), so let's do as little as
> +	 * possible.
> +	 */
> +	pstate = *vcpu_cpsr(vcpu);
> +	mode = pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +	direct_inject  = (mode == PSR_MODE_EL0t &&
> +			  vcpu_el2_e2h_is_set(vcpu) &&
> +			  vcpu_el2_tge_is_set(vcpu));
> +	direct_inject |= (mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t);

Too many parens again...

> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 0418399e0a20..4ef5e86efd8b 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
...
> @@ -149,7 +167,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  	new |= target_mode;
>  
>  	*vcpu_cpsr(vcpu) = new;
> -	__vcpu_write_spsr(vcpu, old);
> +	__vcpu_write_spsr(vcpu, target_mode, old);
>  }
>  
>  /*
> @@ -320,11 +338,22 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  		      KVM_ARM64_EXCEPT_AA64_EL1):
>  			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
>  			break;
> +
> +		case (KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
> +		      KVM_ARM64_EXCEPT_AA64_EL2):

Too many parens...

> +			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_sync);
> +			break;
> +
> +		case (KVM_ARM64_EXCEPT_AA64_ELx_IRQ |
> +		      KVM_ARM64_EXCEPT_AA64_EL2):

Too many parens...

> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index b47df73e98d7..5dcf3f8b08b8 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -12,19 +12,58 @@
>  
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/esr.h>
>  
> +static void pend_sync_exception(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
> +			     KVM_ARM64_PENDING_EXCEPTION);

Too many parens...

> +
> +	/* If not nesting, EL1 is the only possible exception target */
> +	if (likely(!nested_virt_in_use(vcpu))) {
> +		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL1;
> +		return;
> +	}
> +
> +	/*
> +	 * With NV, we need to pick between EL1 and EL2. Note that we
> +	 * never deal with a nesting exception here, hence never
> +	 * changing context, and the exception itself can be delayed
> +	 * until the next entry.
> +	 */
> +	switch(*vcpu_cpsr(vcpu) & PSR_MODE_MASK) {
> +	case PSR_MODE_EL2h:
> +	case PSR_MODE_EL2t:
> +		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL2;
> +		break;
> +	case PSR_MODE_EL1h:
> +	case PSR_MODE_EL1t:
> +		vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL1;
> +		break;
> +	case PSR_MODE_EL0t:
> +		if (vcpu_el2_tge_is_set(vcpu) & HCR_TGE)
> +			vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL2;
> +		else
> +			vcpu->arch.flags |= KVM_ARM64_EXCEPT_AA64_EL1;
> +		break;
> +	default:
> +		BUG();

Is taking out the host really appropriate here? Is this something a
rogue guest could trigger?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
