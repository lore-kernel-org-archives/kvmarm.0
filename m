From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Access CNTHCTL_EL2 bit fields correctly
 on VHE systems
Date: Fri, 13 Jan 2017 14:42:04 +0000
Message-ID: <20170113144204.GB2472@leverpostej>
References: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
 <1484307093-29153-3-git-send-email-marc.zyngier@arm.com>
 <20170113123612.GA31994@cbox>
 <d496020c-a097-ffd5-adb7-7edb7c1a214e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84EB9402EC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 09:41:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oFcSirQqvW8C for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jan 2017 09:41:16 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A95F402AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 09:41:15 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <d496020c-a097-ffd5-adb7-7edb7c1a214e@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Fri, Jan 13, 2017 at 01:30:29PM +0000, Marc Zyngier wrote:
> [+ Suzuki, who wrote the whole cpus_have_const_cap thing]
> 
> On 13/01/17 12:36, Christoffer Dall wrote:
> > On Fri, Jan 13, 2017 at 11:31:32AM +0000, Marc Zyngier wrote:

> >> +static inline bool has_vhe(void)
> >> +{
> >> +	if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
> >> +		return true;
> >> +
> >> +	return false;
> >> +}
> >> +
> > 
> > I was experimenting with using has_vhe for some of the optimization code
> > I was writing, and I saw a hyp crash as a result.  That made me wonder
> > if this is really safe in Hyp mode?
> > 
> > Specifically, there is no guarantee that this will actually be inlined
> > in the caller, right?  At least that's what I can gather from trying to
> > understand the semantics of the inline keyword in the GCC manual.
> 
> Indeed, there is no strict guarantee that this is enforced. We should
> probably have __always_inline instead. But having checked the generated
> code for __timer_restore_state, the function is definitely inlined
> (gcc 6.2). Happy to queue an extra patch changing that.

> > Further, are we guaranteed that the static branch gets compiled into
> > something that doesn't actually look at cpu_hwcap_keys, which is not
> > mapped in hyp mode?

If I disable CONFIG_JUMP_LABEL (which lives under "General setup", with
teh title "Optimize very unlikely/likely branches"), I see adrp; add;
ldr sequences accessing cpu_hwcap_keys when using cpus_have_const_cap()
in hyp code, even with the patch below.

Do we have the whole kernel image mapped around hyp, so that this would
work by relative offset? Do we have a guarantee that adrp+add is used?

Thanks,
Mark.

> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index b4989df..4710469 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -105,10 +105,11 @@ static inline bool cpu_have_feature(unsigned int num)
>  }
>  
>  /* System capability check for constant caps */
> -static inline bool cpus_have_const_cap(int num)
> +static __always_inline bool cpus_have_const_cap(int num)
>  {
> -	if (num >= ARM64_NCAPS)
> -		return false;
> +	BUILD_BUG_ON(!__builtin_constant_p(num));
> +	BUILD_BUG_ON(num >= ARM64_NCAPS);
> +
>  	return static_branch_unlikely(&cpu_hwcap_keys[num]);
>  }
>  
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 439f6b5..1257701 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -81,7 +81,7 @@ static inline bool is_kernel_in_hyp_mode(void)
>  	return read_sysreg(CurrentEL) == CurrentEL_EL2;
>  }
>  
> -static inline bool has_vhe(void)
> +static __always_inline bool has_vhe(void)
>  {
>  	if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
>  		return true;
> 
> 
> But that's probably another patch or two. Thoughts?
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
