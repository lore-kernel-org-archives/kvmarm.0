Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1D528A41F
	for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 09:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546241; cv=none; b=cMLGIMLxW/stUO8sv4KjA4mYFNDardn51dufPgu0GQg5v3mfuX58mjrLjvvzmNWi48UX8cT+an3rVqsdWdGSBkXnxXMlU8v4MJIb+ogp/IvA5SDPOJGC8uGFUiMXpTRCto0aysoDjeW0ie/N/os6aT75FsvPAdWcHzz43OwlYgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546241; c=relaxed/simple;
	bh=aWN0e0qZc76i/NcEH21btu5WBjZv6kgKlBGtDGHusdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0y0mNA9NWhT36wdf8HdorwZzVOGrFmH5PlrEbWk8UNas3ZZM5/FUNrZ3vt5QzIGgcMrDtx8k35ZmXVDEp93IN3bVHiKPcZo7Dea6IkelVp2KfMlNs4nUFKo0vNb2aXVjUqbcYtm5HbAat5bU21QZL8d3wfv1Hff8vkFbXektx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=frD5L8i0; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="frD5L8i0"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d5f10e1aaso35865e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 02:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749546237; x=1750151037; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eUU4jTX6j/YLG0PO5T+2es6EecD1Csp6s99sQaXFOfM=;
        b=frD5L8i0vCcbsWEncY1gaOyE+RF+oLhjOQJlRUVfON5oejbnzjZCJLVoPwT1KPYoWs
         NqN0tQeP3A7n5XlnSSQ/tvBe+q6ijaVOwuNtgSZWABuO/QNti7RO4SKoyKcGZeGSY/i8
         iYzlTF8dDMls78Zr7ysR7PS3rED0TyUBcFL6siayg3oVhWD/ZbG7d8r/UWP4aW2dlgnL
         j6ZhYJMSgQkyhg1ndkBWmU6Y9synkDIUo0iWkUFTfdY4GZbYVr1U145uYYXFyMt5yeRC
         EjpcT6i4qIAqUf/ZeHceAvLBrV2pToMgUscKSaERAcAKEHqahqAmglbHfCZ6O3XtCN9C
         bP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749546237; x=1750151037;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eUU4jTX6j/YLG0PO5T+2es6EecD1Csp6s99sQaXFOfM=;
        b=pic2rBIPsNvD7vJYHfxFsOh2BsVGkON9D2Tbk+xvdf3gcMxzaUU8dFxKIYYAVvVllJ
         ahGYJ7rYCGsrY9293a1oTQ3/b9/lzuCKHTjRZ6Iz3stI6wMkCIkksDbmC2ZIrLZAgW27
         PkPbF44Ixy8kwZ/gWDZg2yxSy+PKZgYCyv+03VFQeN0Hyz6vQ8OtJru4qyTHqYmYs/gM
         0UiJToS0qYH5UG5SM9uXfco6UfeML5Q9mMJWwISE80merhA+EVj9XDdaJNAQ9Ey9r4IW
         YbXgxlAcejzGacg0fgFRkcjxwrR8M2KcEK2VlYg9XYg+7R7JqmBKwc2tYSjROreR+aFN
         BKgg==
X-Gm-Message-State: AOJu0Yy6qVXvxOEtgIFK35/L96yKnrXlIZrxoriYDL+7BI8imKerfV8D
	eY+t6k2qIZzMqNOTt7mvo1hq8JNQKJcCAFY8JfDQNohxrInWAqjYSbBU565w8Lu3jQ==
X-Gm-Gg: ASbGncvcOQmsO5VC/IVPhWMkJdLNJtOahxQSgVqrVO9McXksNiUHkijX0VbVppr+sth
	Lv6sy/DH2+0oeJueAqlELZIyhCbJ6zZl68r5xAy44BZfMR7xBPfxKbbs405lvannQb6FIHH8ck0
	klH/PhVI8HkwQRLkn6cCNekzLGeDZA/nxUPI6szkLbxdh/sdK9MJSzGHmenACT3/RchLimyBSWG
	G9pfIPBaBicNrqg99WKvm0HBTQyIfvm4wcU/4ul2hilPgedQWD2nnO1cxfk1jtsxi4nS6gl85+S
	Y5aKp7avSMJ19GtxN3suI3qFVEXYbvC5lJSnvfBNEEFOnc/MTXYwWpTRTTqjxHHDmtcmhCEQXeT
	LzLuVl8F5e29LZTFxURl/Plwj
X-Google-Smtp-Source: AGHT+IHsGogAAjQObXABMnRa/kBF7OX4/EIU475yl7Cy0JL4WGrsr5WEwzOSNLLnq0CJWZTrP8WqmA==
X-Received: by 2002:a05:600c:3b26:b0:453:5c2:7c6f with SMTP id 5b1f17b1804b1-45305c28162mr4086125e9.4.1749546237344;
        Tue, 10 Jun 2025 02:03:57 -0700 (PDT)
Received: from google.com (206.39.187.35.bc.googleusercontent.com. [35.187.39.206])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45209ce1afasm136222275e9.10.2025.06.10.02.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 02:03:56 -0700 (PDT)
Date: Tue, 10 Jun 2025 09:03:52 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Quentin Perret <qperret@google.com>
Subject: Re: pkvm boot failures
Message-ID: <aEf0-GGIuTqrNiRh@google.com>
References: <yq5ah60pkq03.fsf@kernel.org>
 <aEcY-1Iv8S-e8LVi@google.com>
 <yq5aecvskswm.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5aecvskswm.fsf@kernel.org>

On Tue, Jun 10, 2025 at 12:03:13PM +0530, Aneesh Kumar K.V wrote:
> Mostafa Saleh <smostafa@google.com> writes:
> 
> > On Mon, Jun 09, 2025 at 06:53:40PM +0530, Aneesh Kumar K.V wrote:
> >> 
> >> I am hitting the below failure with v6.15 (I tried other kernel versions
> >> with similar results). I disabled CONFIG_PROTECTED_NVHE_STACKTRACE
> >> because with CONFIG_NVHE_EL2_DEBUG, the stack was pointing at
> >> hyp_assert_lock_held() .
> >> 
> >> [    0.664457] kvm [1]: nVHE hyp panic at: [<ffff80008050b10c>] __kvm_nvhe_handle_trap+0x34/0x10c!
> >> [    0.664538] kvm [1]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE
> >> [    0.664566] kvm [1]: Hyp Offset: 0xffff000007c00000
> >> [    0.664631] Kernel panic - not syncing: HYP panic:
> >> [    0.664631] PS:614023c9 PC:000080007890b10c ESR:0000000096000007
> >> [    0.664631] FAR:0000800078c252f0 HPFAR:0000000000000000 PAR:0000000000000000
> >> [    0.664631] VCPU:0000000000000000
> >> [    0.664938] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.15.0-rc1 #594 NONE 
> >> [    0.665068] Hardware name: FVP Base RevC (DT)
> >> [    0.665140] Call trace:
> >> [    0.665196]  show_stack+0x18/0x24 (C)
> >> [    0.665346]  dump_stack_lvl+0x3c/0x80
> >> [    0.665468]  dump_stack+0x18/0x24
> >> [    0.665588]  panic+0x124/0x2d8
> >> [    0.665699]  nvhe_hyp_panic_handler+0x108/0x180
> >> [    0.665825]  do_pkvm_init+0xb0/0x124
> >> [    0.665957]  do_pkvm_init+0xb0/0x124
> >> [    0.666089]  kvm_hyp_init_protection+0x5c/0x6c
> >> [    0.666226]  init_hyp_mode+0x760/0x790
> >> [    0.666362]  kvm_arm_init+0xac/0x23c
> >> [    0.666492]  do_one_initcall+0xa0/0x1f0
> >> [    0.666617]  do_initcall_level+0x8c/0xac
> >> [    0.666753]  do_initcalls+0x54/0x94
> >> [    0.666885]  do_basic_setup+0x18/0x24
> >> [    0.667019]  kernel_init_freeable+0xc0/0x10c
> >> [    0.667157]  kernel_init+0x20/0x118
> >> [    0.667271]  ret_from_fork+0x10/0x20
> >> [    0.667400] SMP: stopping secondary CPUs
> >> [    0.667475] Kernel Offset: disabled
> >> [    0.667534] CPU features: 0x0000,00000140,064dc298,cb7a552f
> >> [    0.667619] Memory Limit: none
> >> [    0.667681] ---[ end Kernel panic - not syncing: HYP panic:
> >> [    0.667681] PS:614023c9 PC:000080007890b10c ESR:0000000096000007
> >> [    0.667681] FAR:0000800078c252f0 HPFAR:0000000000000000 PAR:0000000000000000
> >> [    0.667681] VCPU:0000000000000000 ]
> >> 
> >> I was able to locate a .config that make the pkvm work, But i am not
> >> able to identify which config dependency is making the difference. I am
> >> attaching below the working and non working kernel configs. I am using
> >> FVP to test this.
> >> 
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
> >
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
> 
> There are other references to kvm_protected_mode_initialized within
> nvhe. Shouldn't all of those be updated as well?

Yes, I missed the ones in the headers, those should be replaced with
“kvm_protected_mode_initialized_hyp” also.

> 
> Also, do we need to drop this line?
> 
> KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
> 

Yes, that’s not needed now.

> If I understand correctly, nvhe will now have a separate static key,
> distinct from the one used by the EL1 host. So we'll need to update
> functions like is_pkvm_initialized() and host_data_ptr() accordingly,
> right?

As far as I see, those are used by the kernel only, but if needed we can
guard that with “__KVM_NVHE_HYPERVISOR__”

host_data_ptr() won’t access the key from the hypervisor because of the
macro check.

But I agree with Marc, that is a lot of duplication.

Thanks,
Mostafa

> 
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
> > --
> >
> > Can you please check if that helps in your case?
> >
> > Thanks,
> > Mostafa
> >
> 
> -aneesh
