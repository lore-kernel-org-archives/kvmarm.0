Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9511A8401
	for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 09:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546391; cv=none; b=ZLnW0DzNAyFV1IiRJv+BHdD/5NmruOEoasuJZjEsqe+Ui2+Kr++xMdVOZqHTtYmLBIG4v+PyZHp1AAP4H6U07IpmdDYXob+NbAXZTIwkrdK7v9+DGfyVC0ubk5fGQuIBvWDpeWgKziJ5QqFH2tJNEjlsqoBvhP49LZTokMc7144=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546391; c=relaxed/simple;
	bh=H1jLedcb0c9abNt9EnnOoraJxN0v1huXXHQ9yG2koqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nKEvvH/AZopV0z0rMLaHYuZNX5ACCygetIj6J3KtILAbBF9YSUrNErQuk/62S0CNP7oWi2sBWqKfs9bHwyyV9udmop54Enc72WPyvWq1cuu/G8aL5qkXch8JHxA67vzZ1PHUop2C9ZtII3gX8tHPoM++UHVgpwTsGMlt3Fk+mRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QovAvbiH; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QovAvbiH"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43d5f10e1aaso36155e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 02:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749546387; x=1750151187; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jIEOqDFV34sxstCpq+RUt0hVYd4EUxQLLOVR3mYqwI0=;
        b=QovAvbiHjbRX4Wspi4KhBMQFchsxKaXYChbQV0nJcH5CmOudTE7djirFaJcF46q/yS
         n35gcGsyH7/hJg5HXZ2OunvM5AFkDXTy5jKrQtq0MztbAw9BgEGxhQXc+TLTzBa71b2+
         4nCiW7IXA8eXNwFESycy86PDaUL5pTz8QNomvH9mUrxNbKEopYUQ7hh5BmgmymeHREd5
         Mn7e9iTKrIQqxQOtG+AEKsCEpOtG07uuHkTurGZlIq1nykePgnp8xSep/ynJND8pCwMq
         yltn9p0SFoPw/uTJizkjrLLbc2JUcvUE61qr98RaERzYWtleVjehpv+K/4dHJcEXHhHQ
         Naxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749546387; x=1750151187;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jIEOqDFV34sxstCpq+RUt0hVYd4EUxQLLOVR3mYqwI0=;
        b=VjHwNBroU1E9XmwAYDjowBN7gpJxLrXK2nL+bZyk5eECZam6CaAobM2CZ+3W68BQxZ
         H9TMoGjukROjv6ENJbo60taJpgKfJ0YGqnQyuqjXwQTRGYhmmYHXQyiD3PPdifnCC5Dx
         gn+JNSNWc9ibOZ9Aa1a0zm3DRWZDq40XrjQ0DTmWLr4NX8k7+28AYgfCb+DH26HxTOya
         6GCQ1Sxh58lw/wwnsEIc/WPcUX0CCfcgpBWh2YUeiC0uhdwTv+eIPuGziCE351pckSm1
         8Zxma3etrvTNCrp5Kv4/WL4XAWiPK7oapQqY4EVP5VBgNg+6ivlBZGPpmhNao2j8nacW
         dxIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMVlaYELYfT/NkNxUizX9tr+oy52l2UZ02pDDI9mdf4UkH+VNjHYuB1BREcETZa118CmaBZ70=@lists.linux.dev
X-Gm-Message-State: AOJu0YwndSjoYrfiGhSriMMbQFPLVykiMrfcgw+uHvhhfjlnSi0mI+bd
	N9IRaCaVx+bQUDRDw0eI4zmRisJYEVHPcSdbCG4fg8uylfvdtxh5m2eDtSIfVTjg5A==
X-Gm-Gg: ASbGncvxznhQCsVE9hpqjV39IdBihF0FCUT418Wv5EVGCX5uga7WrAnuKWfaRKG/lFT
	XdVi57q9bVGsgVd17hlnb1hMj/ELZDAv+Dob/uyWUSMnlb5g90PeUToRoN9iFlDhbQu4ht4r4r5
	mOSViF4fbVoKp40O3ae7THbmtQTk0oNvdfgfeV+6LzS89sDtTq4JvOffZhDrQSg5WMJp0eFKamo
	UV1JVMhiNmaTIyZNCaPH/GhZ7vznizWVn4CrbUWuCvQsS79pcOA9tAj4EuVFn3QJJVx125RTEkQ
	3sMUw7VKfaI0B47jkzRKe1NiEDzwr+kHC3Jh5YrC4vaG7NT0zekRaDiGQgj32RSFVqAjSEOBu17
	F/chYns+p1EAXpLVr+PjRo5v8
X-Google-Smtp-Source: AGHT+IFkXmmkUQ+KuMN/Mu1Rm8Yuqy6DpeHtAR7C40bfmIFFiWJhcycZTRk5tolMoY3AgUGXchmxgg==
X-Received: by 2002:a05:600c:cc:b0:450:cb25:ead with SMTP id 5b1f17b1804b1-4530111b3cbmr3556515e9.7.1749546387231;
        Tue, 10 Jun 2025 02:06:27 -0700 (PDT)
Received: from google.com (206.39.187.35.bc.googleusercontent.com. [35.187.39.206])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a5323b67ccsm11729235f8f.40.2025.06.10.02.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 02:06:26 -0700 (PDT)
Date: Tue, 10 Jun 2025 09:06:22 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
Subject: Re: pkvm boot failures
Message-ID: <aEf1jhjFwbaWQgPP@google.com>
References: <yq5ah60pkq03.fsf@kernel.org>
 <aEcY-1Iv8S-e8LVi@google.com>
 <87ldq0f3rx.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ldq0f3rx.wl-maz@kernel.org>

Hi Marc,

On Tue, Jun 10, 2025 at 08:34:58AM +0100, Marc Zyngier wrote:
> Hi Mostafa,
> 
> Thanks for looking into this.
> 
> On Mon, 09 Jun 2025 18:25:15 +0100,
> Mostafa Saleh <smostafa@google.com> wrote:
> > 
> > On Mon, Jun 09, 2025 at 06:53:40PM +0530, Aneesh Kumar K.V wrote:
> > > 
> > > I am hitting the below failure with v6.15 (I tried other kernel versions
> > > with similar results). I disabled CONFIG_PROTECTED_NVHE_STACKTRACE
> > > because with CONFIG_NVHE_EL2_DEBUG, the stack was pointing at
> > > hyp_assert_lock_held() .
> > > 
> > > [    0.664457] kvm [1]: nVHE hyp panic at: [<ffff80008050b10c>] __kvm_nvhe_handle_trap+0x34/0x10c!
> > > [    0.664538] kvm [1]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE
> > > [    0.664566] kvm [1]: Hyp Offset: 0xffff000007c00000
> > > [    0.664631] Kernel panic - not syncing: HYP panic:
> > > [    0.664631] PS:614023c9 PC:000080007890b10c ESR:0000000096000007
> > > [    0.664631] FAR:0000800078c252f0 HPFAR:0000000000000000 PAR:0000000000000000
> > > [    0.664631] VCPU:0000000000000000
> > > [    0.664938] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.15.0-rc1 #594 NONE 
> > > [    0.665068] Hardware name: FVP Base RevC (DT)
> > > [    0.665140] Call trace:
> > > [    0.665196]  show_stack+0x18/0x24 (C)
> > > [    0.665346]  dump_stack_lvl+0x3c/0x80
> > > [    0.665468]  dump_stack+0x18/0x24
> > > [    0.665588]  panic+0x124/0x2d8
> > > [    0.665699]  nvhe_hyp_panic_handler+0x108/0x180
> > > [    0.665825]  do_pkvm_init+0xb0/0x124
> > > [    0.665957]  do_pkvm_init+0xb0/0x124
> > > [    0.666089]  kvm_hyp_init_protection+0x5c/0x6c
> > > [    0.666226]  init_hyp_mode+0x760/0x790
> > > [    0.666362]  kvm_arm_init+0xac/0x23c
> > > [    0.666492]  do_one_initcall+0xa0/0x1f0
> > > [    0.666617]  do_initcall_level+0x8c/0xac
> > > [    0.666753]  do_initcalls+0x54/0x94
> > > [    0.666885]  do_basic_setup+0x18/0x24
> > > [    0.667019]  kernel_init_freeable+0xc0/0x10c
> > > [    0.667157]  kernel_init+0x20/0x118
> > > [    0.667271]  ret_from_fork+0x10/0x20
> > > [    0.667400] SMP: stopping secondary CPUs
> > > [    0.667475] Kernel Offset: disabled
> > > [    0.667534] CPU features: 0x0000,00000140,064dc298,cb7a552f
> > > [    0.667619] Memory Limit: none
> > > [    0.667681] ---[ end Kernel panic - not syncing: HYP panic:
> > > [    0.667681] PS:614023c9 PC:000080007890b10c ESR:0000000096000007
> > > [    0.667681] FAR:0000800078c252f0 HPFAR:0000000000000000 PAR:0000000000000000
> > > [    0.667681] VCPU:0000000000000000 ]
> > > 
> > > I was able to locate a .config that make the pkvm work, But i am not
> > > able to identify which config dependency is making the difference. I am
> > > attaching below the working and non working kernel configs. I am using
> > > FVP to test this.
> > > 
> > 
> > I had a look at this and tracked the issue to "CONFIG_JUMP_LABEL=n"
> > It seems that it panics at
> > 	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> > Where "kvm_protected_mode_initialized" is mapped in the initial PGD for the
> > hypervisor, but not mapped in the hypervisor created one.
> > As the variable is defined outside the hypervisor namespace, it doesn’t exist
> > in the hyp bss section.
> > And in case of "CONFIG_JUMP_LABEL=n" it  won't be patched in this case, causing
> > next access to read the variable and panicking.
> 
> It really begs the question: why do we even support JUMP_LABEL=n? It
> really feels like a backward configuration, and I'd be very glad to
> either mark it as "always on", or make KVM depend on it.
> 
> > I guess moving this key to hyp would cause problems with kernel access after
> > de-privilege as cases from kvm_share_hyp(), So I can only think of having a
> > different key for the hypervisor as
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 8e8848de4d47..8945b335bcea 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -21,6 +21,7 @@
> >  #include <nvhe/trap_handler.h>
> >  
> >  DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> > +DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized_hyp);
> >  
> >  void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
> >  
> > @@ -626,7 +627,7 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> >  	 * basis. This is all fine, however, since __pkvm_prot_finalize
> >  	 * returns -EPERM after the first call for a given CPU.
> >  	 */
> > -	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> > +	if (static_branch_unlikely(&kvm_protected_mode_initialized_hyp))
> >  		hcall_min = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize;
> >  
> >  	id &= ~ARM_SMCCC_CALL_HINTS;
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index fcd70bfe44fb..af0854e98902 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -17,6 +17,7 @@
> >  #include "hyp_constants.h"
> >  
> >  DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> > +DECLARE_STATIC_KEY_FALSE(kvm_nvhe_sym(kvm_protected_mode_initialized_hyp));
> >  
> >  static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
> >  static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
> > @@ -229,6 +230,7 @@ static int __init pkvm_drop_host_privileges(void)
> >  	 * once the host stage 2 is installed.
> >  	 */
> >  	static_branch_enable(&kvm_protected_mode_initialized);
> > +	static_branch_enable(&kvm_nvhe_sym(kvm_protected_mode_initialized_hyp));
> >  	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
> >  	return ret;
> >  }
> >
> 
> I don't really enjoy this duplication, and unless we have a good
> reason not too, I'd rather have something like:
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 713248f240e0..66d232e7c894 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -37,6 +37,7 @@ menuconfig KVM
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>  	select SCHED_INFO
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
> +	select JUMP_LABEL
>  	help
>  	  Support hosting virtualized guest machines.
>  
> It should be OK now that all the supported compilers have asm goto
> support.

Yes, that looks better, I am not sure why that is not automatically
selected. AFAIK, it should be ok atleast for arm64.

There are some hidden problems though, if the condition is false, that
would panic after de-privilege, but as the key is toggled at
pkvm_drop_host_privileges() before the privilege drop, it should be fine
for now. (but not if the code is reworked)

Also, ofcourse static_branch_disable() won’t be supported.

I’d say, we can add a comment explaining that this key can't be read from
the hypervisor from memory, in case someone reworked this in the future.

Thanks,
Mostafa

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
