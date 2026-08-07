Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D653246EC60
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 15:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116458; cv=none; b=e64r3VCAmaBPZfl1v2vqkF+QNP1vi/uxSeMDZJquagJU+i7BSDJhL4SyRgwfIxiuZlMN3DuAlGChWgzc/K+MAAfyYjrd0uORw8s1P2RF7ztS0ifIL0JFJxRE6jCh+2mnrdKbSwV0Dv5bfoj7qRheE6pgEDaGbya+aejrzN0bkDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116458; c=relaxed/simple;
	bh=7MyKzC0rWs3PkIm6fjcshUyz/i7oJAXec3HrhTPaz4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIaXFTrn/+0Alq70quLMUhT5jIzXdtz3wWeAVfaAGx05M5I8hjlHXbPPY3q0CILXxNfWn6i5ZoVTuOlq4kgiuyFmO2WIwzlNYKhxxDB5fBR0i7cVQf25K4XI7Oghph8eZkDY5U2Cos0aMmJ2w7/srZI/2Jw31IRntTT+qZ58dfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xj3tWlrk; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xj3tWlrk"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a17c7c3c6eso10318a12.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 08:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786116455; x=1786721255; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kRRGQ8YPUxChghesyKo/Ao+VKKmI85UeyDmpYQWLsKY=;
        b=Xj3tWlrkIrBg/gApV5s2fwWmwhzztttTixwFKn13OMgnSPEkv4zanXVy//NvI1x+nI
         EGNxmRdyIzSqQ1SXWnmV8PbY0EUygvbeQRqwSjp2s7L4rhEasDE0NIAgWmHlxcYvt+oQ
         L42S2MV7XuybVHXXj+LrNt94cIQx2+9TpYaETrg8E3K69I+WfXYVUPGB9G8bGm4ueklG
         2xlCBtV7SGO7vvvgrab3iK9GyJX6JzpL0D0lnRlykfkph8PLLYpd9ITew3pB+TUfee+y
         3lWqFuJC36JzSBGDxMCZ/f2Ri/cM/aqj74kFyOOpR3NqkRsaEZO6gq5FJe0ArkdHcZG8
         I4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786116455; x=1786721255;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kRRGQ8YPUxChghesyKo/Ao+VKKmI85UeyDmpYQWLsKY=;
        b=qX7kQn3stszdQkUC5wGkDmHNqnazHLGahG4NPFfH5Q+/+oxbWDAnDvwhMrfnI6Yny0
         yNithFwR8jul0v0P9+fWJtT4ds45Z7H/3u3cgQpHyWwfX5zRLy9DVaRD5cwAY3y0p0N1
         YU9wBkSkLOUPUAf+b6RDv+AaXKaDeByewcB8YJlUQb66vLZ4UvIrbSc7v4S7MzetkCTI
         BPwhyjHc/hZsLRY4AgPj2qRvnOfBrqWAlISrFSmq8BabM3nQW3vBZXIJkSzgnPw27V26
         z9ddbmChd4+wM97Ox8CUgzreoBkT7hlv+6/BMAxB8V4yMhjRZVNivNl1IT7BHJTxsEL/
         uTNA==
X-Forwarded-Encrypted: i=1; AHgh+RptdEZnA5PHNnQQ1bApsMzzWMQJ4stEpEGFm0Kd4doURrfmPrRjBR2ObTOsowJZugtwTwy86AU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxbuBfBn3qsc7Ylw4qk7r47yIjmiUrhtjejqzgPKRaOJHcBfkTG
	Za9VTSiMHnBulp2iim24S2KhD0eIBiaXAmy8gIDXGosw7sLraTYCLN3NR/zvF766Vw==
X-Gm-Gg: AR+sD103Eqvh4grUf2COCww9afCyzDcftX4O5M6NYJf12ypBD55pmV9G/6+kTpX4WGM
	0y6NPJtP+lhvxFyYSuwrN/1yv5LqmnUCtbY3RQKop8/0IaCLfvMusQW7FfozqOmKcxxRbUCNAeU
	4rEOxbS1w4r8YNKtuQefsW1FYgKIG2q0Yn1Xs9IxC2bUZ1KAcGtN7NuRDnO6azF2IXG7lwMMDzr
	UNUc/TePoTfmZBws0+DG6CPc2DGPFr+YnxItn9VWkpeUdGi9GlSjc3XygzHvKHR3SdoIIRMY6WC
	dsbwzaR1pZpF0Xxx/lkFquJQ9ssLZ6NfJ1iychk2fMOlELVBm8fl114ynHw/dBuJzQszq0Z4bgv
	a3ZcHQyTVoKKZ8rkd4nKo2YsB7oFMGm0y5yAYZnokA/wfvEvhHhoyq71GFAtNnWjITXW+JEn/Yy
	vSIWxk2E0BdPKJfN7o1ELYKWJiMiX6oWUwMyX1A1f0leG1quD02FST61DZijiVWpplsTV9tt46+
	z1fy4TemYX2jnJTx5VkWTS5huaBgQ==
X-Received: by 2002:a05:6402:21cd:b0:69f:d9cd:ec41 with SMTP id 4fb4d7f45d1cf-6a1d9edad2amr102227a12.6.1786116452123;
        Fri, 07 Aug 2026 08:27:32 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a1e7cab27asm698938a12.8.2026.08.07.08.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 08:27:31 -0700 (PDT)
Date: Fri, 7 Aug 2026 15:27:23 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, oupton@kernel.org,
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	vdonnefort@google.com, tabba@google.com, sebastianene@google.com,
	keirf@google.com
Subject: Re: [PATCH] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
Message-ID: <anX5WyOim2Q7SL3P@google.com>
References: <20260806150105.4010701-1-smostafa@google.com>
 <86zeyy9pbt.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86zeyy9pbt.wl-maz@kernel.org>

On Fri, Aug 07, 2026 at 11:50:46AM +0100, Marc Zyngier wrote:
> On Thu, 06 Aug 2026 16:01:05 +0100,
> Mostafa Saleh <smostafa@google.com> wrote:
> > 
> > When running on a setup affected with broken CNTVOFF_EL2
> > (has_broken_cntvoff())
> > 
> > Booting with VHE or protected mode(nvhe) (id_aa64mmfr1.vh=0
> > and arm64_sw.hvhe=0) works fine.
> > 
> > However launching a protected VM with protected hvhe mode panics the
> > guest kernel:
> > 
> > [    0.000000] Internal error: Oops - Undefined instruction: 0000000000000000 [#1]  SMP
> > [    0.000000] Modules linked in:
> > [    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.2.0-rc3-g05f75bd71e0e-dirty #29 PREEMPT
> > [    0.000000] Hardware name: linux,dummy-virt (DT)
> > [    0.000000] pstate: 000003c5 (nzcv DAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [    0.000000] pc : arch_timer_shutdown_virt+0x4/0x1c
> > [    0.000000] lr : arch_timer_starting_cpu+0x1c4/0x2d4
> > [    0.000000] sp : ffffa6bd9a193c00
> > [    0.000000] x29: ffffa6bd9a193c20 x28: ffffa6bd9a1bcf88 x27: 0000000000000000
> > [    0.000000] x26: ffff00001be70dd8 x25: ffffa6bd99d85000 x24: ffffa6bd99d85ee4
> > [    0.000000] x23: ffffa6bd99d85000 x22: ffffa6bd9a1499c0 x21: ffffa6bd9a1ab900
> > [    0.000000] x20: 00ffffffffffffff x19: ffff00001be8b600 x18: 000000000000028c
> > [    0.000000] x17: 00000000510f0010 x16: 00000000510f0010 x15: 00000000500f0000
> > [    0.000000] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000018
> > [    0.000000] x11: ffffa6bd9a8ac000 x10: 0000000000f0000f x9 : ffffffffffffffff
> > [    0.000000] x8 : ffffa6bd98822e18 x7 : 0070752d65746174 x6 : 00111ff76e007261
> > [    0.000000] x5 : ffffa6bd9ad68078 x4 : 0000000000000000 x3 : ffffa6bd98822a0c
> > [    0.000000] x2 : 0000000000000073 x1 : 0000000000000001 x0 : ffff00001be8b600
> > [    0.000000] Call trace:
> > [    0.000000]  arch_timer_shutdown_virt+0x4/0x1c (P)
> > [    0.000000]  cpuhp_invoke_callback+0x11c/0x280
> > [    0.000000]  cpuhp_issue_call+0x1e8/0x224
> > [    0.000000]  __cpuhp_setup_state_cpuslocked+0x1d8/0x2b8
> > [    0.000000]  __cpuhp_setup_state+0x50/0x74
> > [    0.000000]  arch_timer_register+0xc0/0x148
> > [    0.000000]  arch_timer_of_init+0x148/0x170
> > [    0.000000]  timer_probe+0x74/0x124
> > [    0.000000]  time_init+0x18/0x58
> > [    0.000000]  start_kernel+0x1c0/0x3ac
> > [    0.000000]  __primary_switched+0x88/0x90
> > [    0.000000] Code: c80b7d2a 35ffffab 17ffffeb d503245f (d53be328)
> > 
> > And for non protected VMs seems to hang or progress really slowly.
> > 
> > The workaround avoids setting non-zero CNTVOFF_EL2 and trapping the
> > virtual counter to emulate the offset.
> > In the VHE path (timer_set_traps()), traps are only enabled when the
> > guest actually has a non-zero virtual timer offset.
> > However, __timer_enable_traps() in hyp/nvhe/timer-sr.c unconditionally
> > set CNTHCTL_EL1TVT and CNTHCTL_EL1TVCT whenever has_broken_cntvoff()
> > was true.
> > 
> > Which causes 2 issues:
> > 1) Protected VMs: kvm_handle_pvm_sysreg() does not find "cntv_ctl_el0"
> > in pvm_sys_reg_descs and injects undefined instruction exceptions.
> > 
> > 2) non-protected guests are trapped all the time even with offset of
> > zero.
> > 
> > Fix this by adding a check in __timer_enable_traps() similar to the one in
> > timer_set_traps()
> > 
> > Fixes: 0bc9a9e85fcf ("KVM: arm64: Work around x1e's CNTVOFF_EL2 bogosity")
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/timer-sr.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> > index ff176f4ce7de..98b6e37ee8fa 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> > @@ -10,6 +10,7 @@
> >  
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> > +#include <hyp/switch.h>
> 
> I'd rather not include this. It drags too many things, and is solely
> expected to be included from switch.c (both implementations).
> 
> You could use the hack below as a prefix to this change.
> 

I see, I will add your patch as a prefix and respin another version.

> >  
> >  void __kvm_timer_set_cntvoff(u64 cntvoff)
> >  {
> > @@ -63,7 +64,7 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
> >  	 * Trap the virtual counter/timer if we have a broken cntvoff
> >  	 * implementation.
> >  	 */
> > -	if (has_broken_cntvoff())
> > +	if (has_broken_cntvoff() && hyp_timer_get_offset(vcpu_vtimer(vcpu)))
> >  		set |= CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT;
> >  
> >  	sysreg_clear_set(cnthctl_el2, clr, set);
> 
> I don't immediately see why a non-protected guest is so slow with
> hVHE, irrespective of the offset. Even if we go back to the host for
> the emulation, this should be usable.
> 
> Could you describe what actually happens? Do you also see the issue
> with pure hVHE (without protected)?

I haven't checked with pure hvhe, I do not have access to the HW at
the moment, but I can repro both the pVM panic and non-protected hang
on Qemu by stubbing “has_broken_cntvoff()” which indicates it’s a
software issue.

I looked more into this and I think I get it, which is the same bug
Sashiko reported here:

The kernel sets the offset when a non-protected VM is started at
kvm_timer_vcpu_init() based on the current timer value.

When hypervisor emulates the timer it reads in kvm_handle_cntxct() =>
compute_counter_value() which sets offset of zero (that's a bug)
and the guest reads the raw counter value.

However, I see the guest using CVAL (likely for tick or events), which
is handled by the host and not the hypervisor, and the host will use
the true offset in that case which is not zero, which makes the VM
events fire way later.

Adding some traces in timer_restore_state() I can confirm the massive
CVAL diff from the current virtual timer.

I have a fix already for this that fixes the hang without this patch,
I will send it along the respin shortly.

Thanks,
Mostafa



> 
> Thanks,
> 
> 	M.
> 
> From a7ec0d7f23d86b028164328f33a7114fa6aad2c3 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Fri, 7 Aug 2026 11:36:48 +0100
> Subject: [PATCH] KVM: arm64: Make timer_get_offset() work in all contexts
> 
> We currently have two implementations of get_timer offset(), one
> in arm_arch_timer.h, and another one in switch.h.
> 
> These two only differ by a pair of kern_hyp_va(), which seems a
> pretty weak reason to open-code it.
> 
> Turn this function into a macro to avoid the include dependency hell
> on kern_hyp_va(), and make it work correctly in all contexts.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +----------
>  include/kvm/arm_arch_timer.h            | 34 +++++++++++++++----------
>  2 files changed, 22 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 4bf624a49591d..2aceda749641c 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -706,22 +706,9 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -/* Open-coded version of timer_get_offset() to allow for kern_hyp_va() */
> -static inline u64 hyp_timer_get_offset(struct arch_timer_context *ctxt)
> -{
> -	u64 offset = 0;
> -
> -	if (ctxt->offset.vm_offset)
> -		offset += *kern_hyp_va(ctxt->offset.vm_offset);
> -	if (ctxt->offset.vcpu_offset)
> -		offset += *kern_hyp_va(ctxt->offset.vcpu_offset);
> -
> -	return offset;
> -}
> -
>  static inline u64 compute_counter_value(struct arch_timer_context *ctxt)
>  {
> -	return arch_timer_read_cntpct_el0() - hyp_timer_get_offset(ctxt);
> +	return arch_timer_read_cntpct_el0() - timer_get_offset(ctxt);
>  }
>  
>  static bool kvm_handle_cntxct(struct kvm_vcpu *vcpu)
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 15a4f97f81051..bc6f2fdd7ad33 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -162,20 +162,28 @@ static inline bool has_cntpoff(void)
>  	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
>  }
>  
> -static inline u64 timer_get_offset(struct arch_timer_context *ctxt)
> -{
> -	u64 offset = 0;
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +#define KERN_HYP_VA(x)		kern_hyp_va(x)
> +#else
> +#define KERN_HYP_VA(x)		x
> +#endif
>  
> -	if (!ctxt)
> -		return 0;
> -
> -	if (ctxt->offset.vm_offset)
> -		offset += *ctxt->offset.vm_offset;
> -	if (ctxt->offset.vcpu_offset)
> -		offset += *ctxt->offset.vcpu_offset;
> -
> -	return offset;
> -}
> +#define timer_get_offset(ctxt)						\
> +	({								\
> +		struct arch_timer_context *__ctxt = (ctxt);		\
> +		u64 off = 0;						\
> +									\
> +		if (__ctxt) {						\
> +			struct arch_timer_offset *ato = &__ctxt->offset;\
> +									\
> +			if (ato->vm_offset)				\
> +				off += *KERN_HYP_VA(ato->vm_offset);	\
> +			if (ato->vcpu_offset)				\
> +				off += *KERN_HYP_VA(ato->vcpu_offset);	\
> +		}							\
> +									\
> +		off;							\
> +	})
>  
>  static inline void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  {
> -- 
> 2.47.3
> 
> 
> -- 
> Without deviation from the norm, progress is not possible.
