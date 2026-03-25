Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278FA350A33
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 19:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774466926; cv=pass; b=oWDxBaqvXe/18QH1cVEdPvVgbv5QCFPTC9EHmmschDMTP32/UUtn2JfJI3Z3dAA5I59jrj61qkw6+ubrAfKF4WPRCIFNmI0bvmMedWXFX0HkH1CbcIFKg0/sOKuCgnk7xMYjF4Niu80tk8moWWyn8/uR5T5WHfKV55+gLXfT5C8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774466926; c=relaxed/simple;
	bh=/WySRYOuiTv5rUv0pSIXbsX/HBb642mo9mU23avTJ2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T5A107rVNmAL8oMoJgZ1FsMQvuMrqK7d5NpzmAlNC9iPUw23HJBFvzEb1cCBEB9Sr1JWiUn/RR4r9dkF7puRqEr0FBP49y0HiAiLMFgaE67rcfiv2QPO3bogD75rHZvjHHKXU1uZ18UMg4sMgWSKn86yF4egsjMQuOADS5BtH2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IrfK5mhi; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IrfK5mhi"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50b6c45781aso137541cf.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 12:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774466924; cv=none;
        d=google.com; s=arc-20240605;
        b=V6tJpsKeLEMvAZQhQgWS3y6rznFUNXtLunlFoOpUMLun7jGsBI3LAjuNXkhX4IzyY+
         g5iBhCX9Ga5GP0x9T433c2E6NIr4UKTkVcRK0hhEHcI6FDpPHyDnm77YChZRnkKhO7QE
         VsZaY/iIfBWf5ofU2t7J7J83qrzAMG62KO+CmEN4D0a0uejExmovZ/wmdJFBVrhoxale
         19K+ZOUDuSPF1wfcsdg1y4jYqAqHe+fiN7ItT/lQIUD+mp7Ek9UyiBayC5bjQ7645fDI
         nRjdZ8bG9UiMDQTPBr2aMAyB3AGAnBKGUq0/GyOO6hpektj8F6cqI1SDtIMbBshmsm4M
         GrOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wIokNmwGM3kd/1AiAW2m0XTptRlPEYAfbrhHNMyEeRg=;
        fh=WXifrakrhHpMKuV+YM1LZ/K83mZPglPFmcpcPxsJbCI=;
        b=WfbHmZwfRTTGboUA79hvNLXWfMra5bD4BeSYi+QAGF8hyBu8/VrWJIuWF0JVEYpc4u
         JJJ7387kgJO4o3RRxl0v+YYOt72JKxHVapMICczoTyAlPtw1ee4ABhbxH3WeNCWs54I+
         I8/GThvQj4mk15dujBzWj4Dr21qHUoqfOcD6iWD9t/CayQ7OS3c40PUIUk6yNXiLWl5x
         2/nGvqIBv1Wvq65QFSdE4aPzCJJVzL2lbJgZ1rD9iy/FrE+c+c7zXWrURjhYmN9cXmSG
         byXcCZbi2p1zT6BL1sPHi/QRqwfreZrxyqEUQ04EdepycQ9dwJr2WRPhDGPTfjWD9d2D
         GT1Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774466924; x=1775071724; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wIokNmwGM3kd/1AiAW2m0XTptRlPEYAfbrhHNMyEeRg=;
        b=IrfK5mhio6r0/IuCpN5GAgdFtstESTRRSbnQTlnTzsJrcYtqapvlVF643KwB6TljqK
         du8NpR0d9OGQQ4lx10B23Dio/03wt6TBtyvT2XFy6N8YWpxT6z9UuYFPXpTMi83RxA5b
         75iLxOSlu6/L2CNqo6fZD8CH8/oYo+Zw5434Nu26ul6SzmDNzcBLmMXilNJbY5YQZuyZ
         9vbDycTlIAS2pKzyWRMGavhqJucWrJYARcT7QLbeD29ndw2iKibe68//fHYVyzBAeZom
         WrrwiwrqvNDopJtr2Nm9ye0eUhR7heITc6lgZKZBQEM9oFVEX2xxKcDY2M6qCoJS2pOw
         Meag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774466924; x=1775071724;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIokNmwGM3kd/1AiAW2m0XTptRlPEYAfbrhHNMyEeRg=;
        b=na1EIZ9I5OrEECLaYNvEuNMkKuqCJBBgjElubh/6yjkP4q7YKRPTH9+WT0e1f6xeS/
         wzGTgqTI6RwbP1Baei6C5PdZhgK2t9ta44HWOcRqkNiGnl+6LzTdo7CX6pCL2irUc1ls
         KhsMLr14yRvxXM9OhOywGA7ihhD5Ecc3iLffX/WbT3C2kECrpdkqYpffd4H+/nWBeLhU
         bvFiw/O7XLId463aJmBhwG3UYUP1jCeUYMJJug+lAHTFO6BxAc7tUyLV0AuD9YSKe7Tm
         hTKC/D++ok7A8wk3o1kw/jmo82PTVbRO2RZGQ22+ZJHWOSBcaGlSiP/ZiNnvd44K4Ddo
         C52A==
X-Gm-Message-State: AOJu0YyG2kh7XhJ9H5rHoI5c5WBq1gjHBaPRp1INOtcFmpIuxulRHwdA
	XELY4pQfnOt+otdy9flcN2Ngs46Gd6trHMml0Vf1qwgibdoIzDovULyAqfTYi75u7I1SBCIyunz
	mAsUtvqMWBhoxLrOzNTGE0ME/W75Swtc1L8UQ9m/X
X-Gm-Gg: ATEYQzx133EonOwRX8vfmGOMYoQxU+8QxBsgpLSfNsysx1+zP8gDwBxlRItqUIu/guJ
	lLjI5UV3TAYi+suuc/7xN6nuWx8B/i4dlV82/37UpqG0v28Z5cYwsNYeJbPwgFdX+Ae8SmHBt/V
	aM+vna6vu0Xvx1rd1zG245CIXhD4C2gWIblUj8NtvK+HjFb7nw9n/5W+pCsJeIOhapEkN/Po5Qv
	Qkq/QxGnECbOX2A2zcCNa1ik2shdjw3lUGkeaZr0DYzd+33VcaMoeGaB0PQP+M/5OfxdY3gWn42
	aLNAIxng
X-Received: by 2002:a05:622a:15c7:b0:509:371:f2ab with SMTP id
 d75a77b69052e-50b93b7ed1dmr1169981cf.16.1774466923434; Wed, 25 Mar 2026
 12:28:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260227212136.7660-1-will@kernel.org> <20260227212136.7660-3-will@kernel.org>
In-Reply-To: <20260227212136.7660-3-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 25 Mar 2026 19:28:06 +0000
X-Gm-Features: AQROBzCdbyLPa1JZSjpKKNOftTCsN0s4jT6rOyJ633tQAAZ1oZqbJolcz5MXyP8
Message-ID: <CA+EHjTxM7Mju1Z8+=oshpESJ59=QVdezL7CY2AhKGnvYOtUXMw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Disable SPE Profiling Buffer when
 running in guest context
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Yabin Cui <yabinc@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Feb 2026 at 21:22, Will Deacon <will@kernel.org> wrote:
>
> The nVHE world-switch code relies on zeroing PMSCR_EL1 to disable
> profiling data generation in guest context when SPE is in use by the
> host.
>
> Unfortunately, this may leave PMBLIMITR_EL1.E set and consequently we
> can end up running in guest/hypervisor context with the Profiling Buffer
> enabled. The current "known issues" document for Rev M.a of the Arm ARM
> states that this can lead to speculative, out-of-context translations:
>
>   | 2.18 D23136:
>   |
>   | When the Profiling Buffer is enabled, profiling is not stopped, and
>   | Discard mode is not enabled, the Statistical Profiling Unit might
>   | cause speculative translations for the owning translation regime,
>   | including when the owning translation regime is out-of-context.
>
> In a similar fashion to TRBE, ensure that the Profiling Buffer is
> disabled during the nVHE world switch before we start messing with the
> stage-2 MMU and trap configuration.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Fixes: f85279b4bd48 ("arm64: KVM: Save/restore the host SPE state when entering/leaving a VM")
> Signed-off-by: Will Deacon <will@kernel.org>

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_host.h  |  1 +
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 33 ++++++++++++++++++++----------
>  arch/arm64/kvm/hyp/nvhe/switch.c   |  2 +-
>  3 files changed, 24 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1532ad2b2ec2..d527c77977dd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -768,6 +768,7 @@ struct kvm_host_data {
>                 struct kvm_guest_debug_arch regs;
>                 /* Statistical profiling extension */
>                 u64 pmscr_el1;
> +               u64 pmblimitr_el1;
>                 /* Self-hosted trace */
>                 u64 trfcr_el1;
>                 u64 trblimitr_el1;
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 3dbdee1148d3..75158a9cd06a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -14,20 +14,20 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>
> -static void __debug_save_spe(u64 *pmscr_el1)
> +static void __debug_save_spe(void)
>  {
> -       u64 reg;
> +       u64 *pmscr_el1, *pmblimitr_el1;
>
> -       /* Clear pmscr in case of early return */
> -       *pmscr_el1 = 0;
> +       pmscr_el1 = host_data_ptr(host_debug_state.pmscr_el1);
> +       pmblimitr_el1 = host_data_ptr(host_debug_state.pmblimitr_el1);
>
>         /*
>          * At this point, we know that this CPU implements
>          * SPE and is available to the host.
>          * Check if the host is actually using it ?
>          */
> -       reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
> -       if (!(reg & BIT(PMBLIMITR_EL1_E_SHIFT)))
> +       *pmblimitr_el1 = read_sysreg_s(SYS_PMBLIMITR_EL1);
> +       if (!(*pmblimitr_el1 & BIT(PMBLIMITR_EL1_E_SHIFT)))
>                 return;
>
>         /* Yes; save the control register and disable data generation */
> @@ -37,18 +37,29 @@ static void __debug_save_spe(u64 *pmscr_el1)
>
>         /* Now drain all buffered data to memory */
>         psb_csync();
> +       dsb(nsh);
> +
> +       /* And disable the profiling buffer */
> +       write_sysreg_s(0, SYS_PMBLIMITR_EL1);
> +       isb();
>  }
>
> -static void __debug_restore_spe(u64 pmscr_el1)
> +static void __debug_restore_spe(void)
>  {
> -       if (!pmscr_el1)
> +       u64 pmblimitr_el1 = *host_data_ptr(host_debug_state.pmblimitr_el1);
> +
> +       if (!(pmblimitr_el1 & BIT(PMBLIMITR_EL1_E_SHIFT)))
>                 return;
>
>         /* The host page table is installed, but not yet synchronised */
>         isb();
>
> +       /* Re-enable the profiling buffer. */
> +       write_sysreg_s(pmblimitr_el1, SYS_PMBLIMITR_EL1);
> +       isb();
> +
>         /* Re-enable data generation */
> -       write_sysreg_el1(pmscr_el1, SYS_PMSCR);
> +       write_sysreg_el1(*host_data_ptr(host_debug_state.pmscr_el1), SYS_PMSCR);
>  }
>
>  static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
> @@ -177,7 +188,7 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>  {
>         /* Disable and flush SPE data generation */
>         if (host_data_test_flag(HAS_SPE))
> -               __debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
> +               __debug_save_spe();
>
>         /* Disable BRBE branch records */
>         if (host_data_test_flag(HAS_BRBE))
> @@ -195,7 +206,7 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
>  void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>  {
>         if (host_data_test_flag(HAS_SPE))
> -               __debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
> +               __debug_restore_spe();
>         if (host_data_test_flag(HAS_BRBE))
>                 __debug_restore_brbe(*host_data_ptr(host_debug_state.brbcr_el1));
>         if (__trace_needs_switch())
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index f00688e69d88..9b6e87dac3b9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -278,7 +278,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>          * We're about to restore some new MMU state. Make sure
>          * ongoing page-table walks that have started before we
>          * trapped to EL2 have completed. This also synchronises the
> -        * above disabling of BRBE and SPE.
> +        * above disabling of BRBE.
>          *
>          * See DDI0487I.a D8.1.5 "Out-of-context translation regimes",
>          * rule R_LFHQG and subsequent information statements.
> --
> 2.53.0.473.g4a7958ca14-goog
>
