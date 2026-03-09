Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE881285C80
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 18:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079673; cv=none; b=Qo/IH2dTIIL0gGxPJ0Vjjn2wzIEJXrT+OiLYKoEPb316m3xo0b3Hz4Ri/4LXC2UJrtcisTqA/lM2nx0fyaN4A33ZzgT6ER/GSlZwR4Uah2PFiHB8y9rE5LiYT/5YpHQ1sBIIIHyK06FNZIlPfQVVs1fjFVtdbDoTDpCD6lzDobQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079673; c=relaxed/simple;
	bh=7LpOfCmNe/sv5OpPhKI1O+WzbBcsEPbQY1M31xETqqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DH/WkMpzEdvgkbBZgmWk2ZFqwV9KMQBzWbJY9af5/ETtZHQY9WochbI07OyG5Q0b/jtvXks3EnJos9TVRUkvJeOoB0Eb9fUf/fhYF6JPH2mDCt5TKY4cdMhXd1B+ooVPwZHa8O0GLiFX24uxSIjQZUBBo3Nj+gP2tlTDRMDPUHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pw/snnHF; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pw/snnHF"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so22286545e9.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 11:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773079670; x=1773684470; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ADzjqBFR4WyG4XO+KFuvgSIJVhmrK46zCfN+Fca80dI=;
        b=Pw/snnHFahn5c1JhUku3pJ2z4cP3bxvHj0ScAssYmYH1hAoWtIqmgQmSabP33oBNaV
         rVCCTk7dbUmZGsjJutbEtz9rIRcywkzJLrGypcRuHPbaDY/trmtPawDrZ+ckGggP83vf
         +XQfq2SXf4hLWCxC8PUkkzcStVgD/oyxCcDJVS5cpLjfWUD6qB3ZbcLZMPGj+xtyKeKq
         ZFJem2qGZFilpxTXWl4Fl3K3O8mvabjWg1nNt14z7XKLK+Pcd9QhxFM4MpqcIDFVL3Hq
         1t362+ffktM+fjLk2LejZoR7DLiiupn5ah6OAkcAKh4MjkJX7l+QqcVbjh9isOqS9MJt
         rL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773079670; x=1773684470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ADzjqBFR4WyG4XO+KFuvgSIJVhmrK46zCfN+Fca80dI=;
        b=Eq2dVGcev7TY/B+lyvN6k2SXXv7qoxEJFToB00eCVtN4lkRxIo5APoMPLq/SoWuv3e
         Uk8IHV2qOp8qPCA++Z6taSYiGEkKODtwfBpRVRT294Ac9FwXFzjFX0Nn0fmP9XRtSukV
         cXB75nmtUmc7fIQYS2yeibzV3zW0hvuOUGercTK6N1y54+nEAbk6MX3l0TyETQCaNti3
         U4SgGpMgQZ5SfLpgzD31OSPZowf6dFGImZ0U78DgJpJQ5gLpD5oNGsAAWJH9GsWQcn8M
         4bJq/Ht2I0niOtgn5JE/MfJ9jQ6u8jc008Ka1vFbePidxczeJWhO5YSmJpnODdOXe/Nu
         6G6g==
X-Forwarded-Encrypted: i=1; AJvYcCXPP7FLZrKPaxx0IbJGN7scVEDBkzJR1QxuK84tQdxE1BX9NjVoS3PqPp0nEiL2hWh9hLEjPZA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNWDBVRLxEyCGXXbyRwU1gwvVq68JQyrqVvLa+ZQAfkgUmB2lM
	qr+eEnUAaJ0guOkSaPlG8+7FtCAH7RJeZaLymRyhufH+kuJS0m3I90hUMh+f6A8zDg==
X-Gm-Gg: ATEYQzwHejxTmqwpJDn3gAZoWVe/0WzBWHgouwEyiYm7dLS+C3ZyLyy7lnzmie8L5rn
	D9WzOHA2S3PV7RQTRyOP7XNLyaizJkn/RyvjId/zc8IgAUOhqKkvQISAI0z7XmdHupjpofkVN50
	VI4ldnc7PLnR1sqixokaFUuoDaeMSRMGVgJ8tXDi8PqDwo8/A5DqUo2M3DM+uq0+O1uN2Ds9pFO
	wKapl2Qm6Y+aNazVUdYff9V1eocWOtxFjbYWBIFM7Rb4an2WUWxA8UAUxR/HL+AjJk4RP66g43w
	sfwo/opLmqa9k/UxMNoKpyDE2VL3DuKiPkfVPCq3a5QNLSyMpB4tcXrrhtXQIsGqeTmcprK5VkD
	aplzVFLMJdzhlmo3L47EF0Mz+UgKCVHoI5CGzfaixjBEnkJlYG5lGdvC3apBRV+CNDPL68chMPl
	UuaOIBtKDbsJDv/N39qFR/llKzHh1ClbDdt3Yu8RdVuiH0hLMwUDYKsx4tm8LIN07cPJ0=
X-Received: by 2002:a05:6000:40dd:b0:439:cb5c:b18d with SMTP id ffacd0b85a97d-439da893f6cmr21068586f8f.38.1773079669660;
        Mon, 09 Mar 2026 11:07:49 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8d973sm26709539f8f.3.2026.03.09.11.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 11:07:49 -0700 (PDT)
Date: Mon, 9 Mar 2026 18:07:45 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, tabba@google.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Fix ICV_DIR_EL1 trapping detection for pKVM
Message-ID: <aa8McT6o2_KSXVfz@google.com>
References: <20260309160450.2610295-1-vdonnefort@google.com>
 <86h5qo7vr9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h5qo7vr9.wl-maz@kernel.org>

[...]

> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index e7790097db93..0432852228f9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -463,6 +463,11 @@ static void handle___vgic_v3_get_gic_config(struct kvm_cpu_context *host_ctxt)
> >  	cpu_reg(host_ctxt, 1) = __vgic_v3_get_gic_config();
> >  }
> >  
> > +static void handle___vgic_v3_get_ich_vtr_el2(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	cpu_reg(host_ctxt, 1) = read_sysreg_s(SYS_ICH_VTR_EL2);
> > +}
> > +
> >  static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
> >  {
> >  	__vgic_v3_init_lrs();
> > @@ -622,6 +627,7 @@ static const hcall_t host_hcall[] = {
> >  	HANDLE_FUNC(__kvm_timer_set_cntvoff),
> >  	HANDLE_FUNC(__vgic_v3_save_aprs),
> >  	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
> > +	HANDLE_FUNC(__vgic_v3_get_ich_vtr_el2),
> >  	HANDLE_FUNC(__pkvm_reserve_vm),
> >  	HANDLE_FUNC(__pkvm_unreserve_vm),
> >  	HANDLE_FUNC(__pkvm_init_vm),
> > 
> 
> This looks incredibly complicated. Since pKVM forbids late onlining of
> CPUs, you are absolutely sure that you have already seen the CPU being
> hot-plugged on.
> 
> So it would make a lot more sense to just return the current value of
> the property you are trying to re-evaluate: you know for sure it
> cannot change under your feet.
> 
> I have quickly tested the following hack:
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c31f8e17732a3..947ff71b3b66b 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2345,6 +2345,9 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
>  	    !is_midr_in_range_list(has_vgic_v3))
>  		return false;
>  
> +	if (system_capabilities_finalized() && is_protected_kvm_enabled())
> +		return cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR);
> +
>  	if (is_kernel_in_hyp_mode())
>  		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
>  	else
> 
> which works for me. Could you please give it a go?

That works! I can spin a V2 with that if you want.

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
