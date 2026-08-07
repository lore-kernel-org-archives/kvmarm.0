Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3712738DC7E
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 01:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786066648; cv=none; b=EDv+5mqzT4px60U/RxJTsx6cWnPrdKlRkwQw4h+HVs2ziI08AjGj97wiR0noIqt64LmRZZRAvqQ0cSBqvpa3R+JRiPx10JhHEUtt7qV5W5nvNEQTP1AcSMcd9IFsqXV4EDb90UMxXThzqgq6FcoLy4+vT22YidTspRY614wWPr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786066648; c=relaxed/simple;
	bh=nzBnOubumnkOLFZKTZYxCBB0e2qDdrPIXCzhhrN5oeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cxFsy4k09U6hWZqHbZYz79UJscIyC/eBozPN6z78ND9hjuJyqarF9eCaBCwZ71hYtUsj9lZBJ5kCMSDBLR/9PhvDIKVXjj/BMibiZ4zhwMwQcu6rUAftDVeb5aFRk6UZM7MF0T0/cb58L+QwSt/xPq9ipdrdjmaRteGZiiQPO3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aQvAQD7R; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aQvAQD7R"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786066629; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=JGKYpm3NtQnK1t7E2NOgTePh2Nswpahf23hIRl2lOT4=;
	b=aQvAQD7RuZ8kb/qmvFB4Llit9Y0WgZIW3pnH8F4AFxKLgch0I2mNWfYskxPIYYuhws6HbKxtwjZ36rbOSdjyVYvbqOB6k2cBIwmKTcN7bZqCcIm2PpZ8yi0N5MLGsKl7JLLstVPop5haFpPUirFfVFm7+JNS3SpqJ7o4x0YNxfM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8VGXri_1786066627;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X8VGXri_1786066627 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 07 Aug 2026 09:37:08 +0800
Date: Fri, 7 Aug 2026 09:37:06 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, tabba@google.com, 
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
Message-ID: <gm2w76lflkw67xc4io2ornvfugvijbwotzvwmmefsfcqvrasgp@qkybjxr6lukr>
References: <20260806150105.4010701-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806150105.4010701-1-smostafa@google.com>

On Thu, Aug 06, 2026 at 03:01:05PM +0800, Mostafa Saleh wrote:
> When running on a setup affected with broken CNTVOFF_EL2
> (has_broken_cntvoff())
>
> Booting with VHE or protected mode(nvhe) (id_aa64mmfr1.vh=0
> and arm64_sw.hvhe=0) works fine.
>
> However launching a protected VM with protected hvhe mode panics the
> guest kernel:

...

> And for non protected VMs seems to hang or progress really slowly.
>
> The workaround avoids setting non-zero CNTVOFF_EL2 and trapping the
> virtual counter to emulate the offset.
> In the VHE path (timer_set_traps()), traps are only enabled when the
> guest actually has a non-zero virtual timer offset.
> However, __timer_enable_traps() in hyp/nvhe/timer-sr.c unconditionally
> set CNTHCTL_EL1TVT and CNTHCTL_EL1TVCT whenever has_broken_cntvoff()
> was true.
>
> Which causes 2 issues:
> 1) Protected VMs: kvm_handle_pvm_sysreg() does not find "cntv_ctl_el0"
> in pvm_sys_reg_descs and injects undefined instruction exceptions.
>
> 2) non-protected guests are trapped all the time even with offset of
> zero.
>
> Fix this by adding a check in __timer_enable_traps() similar to the one in
> timer_set_traps()

Hi Saleh,

May more fix is needed for case that guest real have virtual
offset, due to no cntv_ctl_el0 handler there. For current
fix for virtual offset is zero:

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
> Fixes: 0bc9a9e85fcf ("KVM: arm64: Work around x1e's CNTVOFF_EL2 bogosity")
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> index ff176f4ce7de..98b6e37ee8fa 100644
> --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> @@ -10,6 +10,7 @@
>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> +#include <hyp/switch.h>
>
>  void __kvm_timer_set_cntvoff(u64 cntvoff)
>  {
> @@ -63,7 +64,7 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
>  	 * Trap the virtual counter/timer if we have a broken cntvoff
>  	 * implementation.
>  	 */
> -	if (has_broken_cntvoff())
> +	if (has_broken_cntvoff() && hyp_timer_get_offset(vcpu_vtimer(vcpu)))
>  		set |= CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT;
>
>  	sysreg_clear_set(cnthctl_el2, clr, set);
> --
> 2.55.0.654.g21b8a5bc05-goog
>
