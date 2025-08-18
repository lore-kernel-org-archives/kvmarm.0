Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9DD31CA62
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 13:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522245; cv=none; b=bfGy9OKSNn5Lifz2jYIJPO6VKe6lRAyHsLBq/yJD5YWk4S7OTAvaZO3KLC1/DLFp4K2XFfCX/NbYsma4xruToQ/pe2/26TM+qXr8vftoLP2O9qr5wcaJMCv0hHMc1KMg4CPUt6CZfHJ2agMcU6w1lyRtVU+2ChEPONQO0oStOfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522245; c=relaxed/simple;
	bh=lYZA5VfdTs12GvwB0UgMs7/Igy4jx2YAnk1czQGn/L4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EzFDoaqkW8UHki6SaUUl628lYhrGjF6PyCy+/ezk8R/FzBvcpEHUG2Ozt4aGi6pfrzNsiNDoBYlMiwIMMGS0HyD1rfxvzQDwAHTl4UKUCZox5iLWKFqZ/qJBAXALpzdBy4bVACuwWdrOfAfOqLYjgBsc7yHety/I25Mw6p+WrC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wkMPP8ov; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wkMPP8ov"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb7347e09so655147666b.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 06:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755522242; x=1756127042; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NduKahaSsHRwJryndzTREtjDiwEP6iz1IQoYnQXnz+8=;
        b=wkMPP8ovWvByUPazj7B/D7qpnwccMjl236BX+1xlOG+ZkmY7BYYsPGTla8LOYDJAlk
         tyzaeHidVm6B+CQasxOVn202bWjPAbCFpUxiwkfaV9M1P7s/n4F3p142cJBrjVDNO62G
         JSQPeBYmOgkwZ3DY5D5RcH3w3eea1K7tsrXTjbzUAGhVV9K+yo5mzY7Wq083YUPGOtWY
         T8fO1q0NqEBrl5YFlji78PAhIqTh4X4Tgr7CityWexcnxqqXqGoTQoY60cGNiL7PRRIy
         NZNzV8z2eJGfGz5+EIxhtB3YLNiVwTOVGmYN7pwppbqSwIE0PBITE/dYne8ENEqdtCAw
         RvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755522242; x=1756127042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NduKahaSsHRwJryndzTREtjDiwEP6iz1IQoYnQXnz+8=;
        b=ct1z4rqIFqfcmA6ENZFs/oFq/Cqnac9y0BliBCqrr7jiQmnUDqeP4/tHaL1Q5Lqvfd
         O2bGcuMt7XXYyxxhZGWqOOmwaRQvU0KajofSthCDITfynxZ5ckO8Nx/OLRc4XBnQ35pX
         6bnxT5u5dfwYM8rZPzfWYvoGrKnNyOWAeTG+GQwdkiStP4vhZoQ70G5gnsnvQAbbgJNf
         OhsCbyt4j8LMvyr7pmP5y+Lzzb8DHsV/q8v9WDN3QUTzMPGFn0qmZRN8gkXBzhEgTsh+
         ApcqHmSBq6NtQYqShk7h/eqYhpWKLVUaOrmuM6SeEj8uuuzaCJAn6xP4nTWISkH6tSW1
         aO1g==
X-Forwarded-Encrypted: i=1; AJvYcCXGKaHdNErW9MK8xvoicgs9W3Vuf7FRvzbYjxHZzH1q8zcSdDADvBgH04czKLKDwWYygmEC/go=@lists.linux.dev
X-Gm-Message-State: AOJu0YwC89+up+ApuH4Bfve+9wwwo4qAqVvRxVMUMq/o+63WZPaIc9b5
	DKNq9Kchd1RsXCfc/zOh8vpR8oPV/enzC0XASD9Qpw1+VummPQEAk2sx6N6l9SjagA==
X-Gm-Gg: ASbGncv8TXs2Qtd2rPCFzSv0zK7UIMxQCorzi3k4iDuSajkSOWp87YFy4sVVMaXXTwB
	/6uDRmxYTEWfqga0XF3UOBXVuK4W9Ia6bJDFInY56Wd+GbEVw5Z7wvG1GlO2hNmTIo/jcQiN/0f
	ERhIjDmw6yMK6s7gKbKZruaEmsVGzC7fo1QjzbcEUQQkGHcidV+yi6Yfj9w8G99WZMeJs6/bXi9
	Ne+ZUH2BVpzBTrfRne0udzjPpHcV3LT3m7s5M9AxNI/DpcdEWy0o7FmRx6XyYTgGUlvDHBPv4xw
	XYWR2ir06yvfAAI6L8v/pgnVCcaC9d8JevlF6XEuZqbMmbCeaXDWwKZ8+CA46m417Ew2trwGlGm
	tI09SGRwNopoH9MqilkMER/ixH+xMKN1EGN9uQ70W1fp/qA3RAcCbtybDU95ho4w=
X-Google-Smtp-Source: AGHT+IHw9k3Ozl8ODhQt1aTftbUxAvnT87BIGBhJUDtNJHRuqigi8Ct6sSymmRAchwlefla4IBRy/w==
X-Received: by 2002:a17:906:c04f:b0:afd:bd24:4de7 with SMTP id a640c23a62f3a-afdbd2497f1mr391580566b.29.1755522241561;
        Mon, 18 Aug 2025 06:04:01 -0700 (PDT)
Received: from google.com (211.29.195.35.bc.googleusercontent.com. [35.195.29.211])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdcfcce69sm785410866b.82.2025.08.18.06.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:04:01 -0700 (PDT)
Date: Mon, 18 Aug 2025 14:03:57 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, james.morse@arm.com, tabba@google.com,
	Quentin Perret <qperret@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix debug checking for np-guests using huge
 mappings
Message-ID: <aKMkvQEyeK1QH12X@google.com>
References: <20250815162655.121108-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815162655.121108-1-ben.horgan@arm.com>

Thanks for the fix!

On Fri, Aug 15, 2025 at 05:26:55PM +0100, Ben Horgan wrote:
> When running with transparent huge pages and CONFIG_NVHE_EL2_DEBUG then
> the debug checking in assert_host_shared_guest() fails on the launch of an
> np-guest. This WARN_ON() causes a panic and generates the stack below.
> 
> In __pkvm_host_relax_perms_guest() the debug checking assumes the mapping
> is a single page but it may be a block map. Update the checking so that
> the size is not checked and just assumes the correct size.
> 
> While we're here make the same fix in __pkvm_host_mkyoung_guest().
> 
>   Info: # lkvm run -k /share/arch/arm64/boot/Image -m 704 -c 8 --name guest-128
>   Info: Removed ghost socket file "/.lkvm//guest-128.sock".
> [ 1406.521757] kvm [141]: nVHE hyp BUG at: arch/arm64/kvm/hyp/nvhe/mem_protect.c:1088!
> [ 1406.521804] kvm [141]: nVHE call trace:
> [ 1406.521828] kvm [141]:  [<ffff8000811676b4>] __kvm_nvhe_hyp_panic+0xb4/0xe8
> [ 1406.521946] kvm [141]:  [<ffff80008116d12c>] __kvm_nvhe_assert_host_shared_guest+0xb0/0x10c
> [ 1406.522049] kvm [141]:  [<ffff80008116f068>] __kvm_nvhe___pkvm_host_relax_perms_guest+0x48/0x104
> [ 1406.522157] kvm [141]:  [<ffff800081169df8>] __kvm_nvhe_handle___pkvm_host_relax_perms_guest+0x64/0x7c
> [ 1406.522250] kvm [141]:  [<ffff800081169f0c>] __kvm_nvhe_handle_trap+0x8c/0x1a8
> [ 1406.522333] kvm [141]:  [<ffff8000811680fc>] __kvm_nvhe___skip_pauth_save+0x4/0x4
> [ 1406.522454] kvm [141]: ---[ end nVHE call trace ]---
> [ 1406.522477] kvm [141]: Hyp Offset: 0xfffece8013600000
> [ 1406.522554] Kernel panic - not syncing: HYP panic:
> [ 1406.522554] PS:834003c9 PC:0000b1806db6d170 ESR:00000000f2000800
> [ 1406.522554] FAR:ffff8000804be420 HPFAR:0000000000804be0 PAR:0000000000000000
> [ 1406.522554] VCPU:0000000000000000
> [ 1406.523337] CPU: 3 UID: 0 PID: 141 Comm: kvm-vcpu-0 Not tainted 6.16.0-rc7 #97 PREEMPT
> [ 1406.523485] Hardware name: FVP Base RevC (DT)
> [ 1406.523566] Call trace:
> [ 1406.523629]  show_stack+0x18/0x24 (C)
> [ 1406.523753]  dump_stack_lvl+0xd4/0x108
> [ 1406.523899]  dump_stack+0x18/0x24
> [ 1406.524040]  panic+0x3d8/0x448
> [ 1406.524184]  nvhe_hyp_panic_handler+0x10c/0x23c
> [ 1406.524325]  kvm_handle_guest_abort+0x68c/0x109c
> [ 1406.524500]  handle_exit+0x60/0x17c
> [ 1406.524630]  kvm_arch_vcpu_ioctl_run+0x2e0/0x8c0
> [ 1406.524794]  kvm_vcpu_ioctl+0x1a8/0x9cc
> [ 1406.524919]  __arm64_sys_ioctl+0xac/0x104
> [ 1406.525067]  invoke_syscall+0x48/0x10c
> [ 1406.525189]  el0_svc_common.constprop.0+0x40/0xe0
> [ 1406.525322]  do_el0_svc+0x1c/0x28
> [ 1406.525441]  el0_svc+0x38/0x120
> [ 1406.525588]  el0t_64_sync_handler+0x10c/0x138
> [ 1406.525750]  el0t_64_sync+0x1ac/0x1b0
> [ 1406.525876] SMP: stopping secondary CPUs
> [ 1406.525965] Kernel Offset: disabled
> [ 1406.526032] CPU features: 0x0000,00000080,8e134ca1,9446773f
> [ 1406.526130] Memory Limit: none
> [ 1406.959099] ---[ end Kernel panic - not syncing: HYP panic:
> [ 1406.959099] PS:834003c9 PC:0000b1806db6d170 ESR:00000000f2000800
> [ 1406.959099] FAR:ffff8000804be420 HPFAR:0000000000804be0 PAR:0000000000000000
> [ 1406.959099] VCPU:0000000000000000 ]
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> Fixes: db14091d8f75 ("KVM: arm64: Stage-2 huge mappings for np-guests")

Not sure if it really matters but it's more about fixing f28f1d02f4ea (KVM: arm64: Add a range
to __pkvm_host_unshare_guest()) which introduced the check size !=
kvm_granule_size(). Even though this is noop until db14091d8f75

> Cc: Vincent Donnefort <vdonnefort@google.com>
> Cc: Quentin Perret <qperret@google.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Vincent Donnefort <vdonnefort@google.com> 

> 
> ---
> 
> This addresses the bug I raised here:
> https://lore.kernel.org/linux-arm-kernel/17b526ff-b824-4c24-8ac0-6821e5cc8900@arm.com/
> 
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 8957734d6183..ddc8beb55eee 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1010,9 +1010,12 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
>  		return ret;
>  	if (!kvm_pte_valid(pte))
>  		return -ENOENT;
> -	if (kvm_granule_size(level) != size)
> +	if (size && kvm_granule_size(level) != size)
>  		return -E2BIG;
>  
> +	if (!size)
> +		size = kvm_granule_size(level);
> +
>  	state = guest_get_page_state(pte, ipa);
>  	if (state != PKVM_PAGE_SHARED_BORROWED)
>  		return -EPERM;
> @@ -1100,7 +1103,7 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
>  	if (prot & ~KVM_PGTABLE_PROT_RWX)
>  		return -EINVAL;
>  
> -	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
> +	assert_host_shared_guest(vm, ipa, 0);
>  	guest_lock_component(vm);
>  	ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
>  	guest_unlock_component(vm);
> @@ -1156,7 +1159,7 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
>  	if (pkvm_hyp_vm_is_protected(vm))
>  		return -EPERM;
>  
> -	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
> +	assert_host_shared_guest(vm, ipa, 0);
>  	guest_lock_component(vm);
>  	kvm_pgtable_stage2_mkyoung(&vm->pgt, ipa, 0);
>  	guest_unlock_component(vm);
> -- 
> 2.43.0
> 
