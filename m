Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8231862AF
	for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 10:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718621128; cv=none; b=KWlH4Vtlxfhqb3P5SKfgKGJ1F6rmdw2cZIZuzHaIMIBhuzU6Czm33rM3tU2M2B5FZbkdm9clzTnlxxemivHz1RNXhVdCiL26zmQmG4oD0aKHUEqKvMtNJaLvXMWrogHCWhOnD8fyOc5cMvy73wpihj8uv8a2IAow6FsCEoUbU90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718621128; c=relaxed/simple;
	bh=vuQcy+KVm29pLB+XSdlOguyYKB5bJJLBLEcIzo669oA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IEMTNM1fMif5fnx2/p74mCd33rI3kWXlUTrcFnaXl5wx6ZH2g+pG/nkJX1gDu7EZTTptfYyXTicURHRKWGGJgzFxbq/cZBidNs/PhrDb/UgjNo0brGoVH/zGkFvmF3bywD3QBUKMVmNfAiXcZrwQUn0W1UJ50K5yqzc4lURo0Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wfx43mjW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wfx43mjW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718621126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NRJxfdPnVe61FMxCcvDTR6bA2bGURPuEq5h0b2zz8Mw=;
	b=Wfx43mjWb6fj6tQphyWdeFkWio8JcM4Tutm8u35C5gJrL9Vb65q8VZUKWL+yTja83L+iRo
	Bs5NhOd/jhnGMrX/L3ECiuI1Gb34mmqYtusHAsEtv6nvF+9yLQC7PvxSECv49QwlTdrHKm
	AvoLDTkuFLOBs/3uIss4xUjM0MXTGSs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-cXPMlX6OMqyS_Vb_kziBIw-1; Mon, 17 Jun 2024 06:45:24 -0400
X-MC-Unique: cXPMlX6OMqyS_Vb_kziBIw-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-57a460247f3so2550177a12.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 03:45:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718621123; x=1719225923;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NRJxfdPnVe61FMxCcvDTR6bA2bGURPuEq5h0b2zz8Mw=;
        b=VELIG6doSosv4aQJikMKA1/Ylsy0EyY+yI0VGbXZuT5jv1oLcXfCUCmHcVZfkMDO18
         M6U9z8ZDcdmAwTOucIGE9Zp6UbgK7RTzBy0HVbN1izEcQ2vziKLEK5yiiqtkKiz7g88A
         77M01cA+JRnVKuqRJNERaiVJ9C2z6nWQgGYgQoovAISivFxi9mmFWr17huMalnlEAfOL
         qpD8x68TUGONsVbYWQBHQTztXFIfBMb2iSgLOhg3gwF80DGLfCZeVVwuME+WYjthIw2v
         692fdEELRxQeDoUliq5cqcCS5HE8lTWxj3yu79cwtGOphhyQwS66KZivjC/E+zE6HziZ
         mGVA==
X-Forwarded-Encrypted: i=1; AJvYcCULSDPKnGfL+ioVYiDF27/yJZkk4Zl079I0jiKsL4kTq5xG9q+gnmbRuClpQE8DKokiVLgIAhPusV7+CzPIiPMW4lfpGogk
X-Gm-Message-State: AOJu0YyhVbLWMqB+/eamG7/UMglbVw0xAaxE6pzYgQndW64XX2UhA5ot
	AL7fd2mskIyVL0c8ngsyvb4HJNspXLMZn1JTw4HXFlP2KtGd33vpqM2DzmxUs7FiojKBBR9uM1M
	2G1zjpl+qZGXxATv43KC+54bYvtFPJ7u871P40vMw2uDdt6Q+SQj94A==
X-Received: by 2002:a05:6402:17d9:b0:57c:c712:a3c7 with SMTP id 4fb4d7f45d1cf-57cc712a42emr4992939a12.36.1718621123507;
        Mon, 17 Jun 2024 03:45:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw1dOfO65idOI5S5hHYI2dR8VfPt3UB6du2RlcOyEDzhJXF4pRAG6lh6hyi8RsfiJwinPS0Q==
X-Received: by 2002:a05:6402:17d9:b0:57c:c712:a3c7 with SMTP id 4fb4d7f45d1cf-57cc712a42emr4992914a12.36.1718621123073;
        Mon, 17 Jun 2024 03:45:23 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb72e992dsm6225534a12.48.2024.06.17.03.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 03:45:22 -0700 (PDT)
Date: Mon, 17 Jun 2024 12:45:21 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: add emulation for CTR_EL0 register
In-Reply-To: <ZmyMxRoKN5VhUW7J@linux.dev>
Message-ID: <393a1898-504c-c6a6-3c94-4b67b3f4c573@redhat.com>
References: <20240603130507.17597-1-sebott@redhat.com> <20240603130507.17597-4-sebott@redhat.com> <ZmtwjLbP283ra0Xq@linux.dev> <Zmty99X4hnYwtRS4@linux.dev> <0b148e21-1714-f4f7-bc77-2a12b990572d@redhat.com> <ZmyMxRoKN5VhUW7J@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 14 Jun 2024, Oliver Upton wrote:
> On Fri, Jun 14, 2024 at 05:31:37PM +0200, Sebastian Ott wrote:
>
> [...]
>
>> Hm, but in that case we'd use reset_vm_ftr_id_reg() meaning we would have
>> to make IDREG() work for this reg. Either by adding special handling to
>> that macro or by increasing kvm->arch.id_regs[] a lot - both options don't
>> sound very appealing.
>
> Hiding some of the ugly details behind IDREG() isn't the worst thing,
> IMO. The feature ID registers are not laid out contiguously in the
> architecture, so it'd make sense that the corresponding KVM code not be
> brittle to this.
>
> The other benefit is we initialize kvm->arch.ctr_el0 exactly once, just
> like the other ID registers. I believe there's a quirk with this patch
> where an initialization that happens after a KVM_SET_ONE_REG on CTR_EL0
> will clobber the userspace value.
>
> So, here's where I'm at locally, I'll work it a bit more and try to
> densely pack CTR_EL0 into the id_regs array. I also have some (untested)
> changes to get CTR_EL0 to show up in the debugfs interface we now have.
>
> Mind if I post what I have afterwards?

Sure go ahead.

Thanks,
Sebastian


>
> commit 6bf81bd50dc16309a627863948d49cfeeb00897e
> Author: Sebastian Ott <sebott@redhat.com>
> Date:   Mon Jun 3 15:05:03 2024 +0200
>
>    KVM: arm64: Treat CTR_EL0 as a VM feature ID register
>
>    Signed-off-by: Sebastian Ott <sebott@redhat.com>
>    Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
>    Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 212ae77eefaf..e5b8cdd70914 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -327,10 +327,20 @@ struct kvm_arch {
> 	 */
> #define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
> #define IDX_IDREG(idx)		sys_reg(3, 0, 0, ((idx) >> 3) + 1, (idx) & Op2_mask)
> -#define IDREG(kvm, id)		((kvm)->arch.id_regs[IDREG_IDX(id)])
> +#define IDREG(kvm, id)								\
> +(*({										\
> +	u64 *__reg;								\
> +	if ((id) == SYS_CTR_EL0)						\
> +		__reg = &(kvm)->arch.ctr_el0;					\
> +	else									\
> +		__reg = &((kvm)->arch.id_regs[IDREG_IDX(id)]);			\
> +	__reg;									\
> +}))
> #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
> 	u64 id_regs[KVM_ARM_ID_REG_NUM];
>
> +	u64 ctr_el0;
> +
> 	/* Masks for VNCR-baked sysregs */
> 	struct kvm_sysreg_masks	*sysreg_masks;
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index dfabf7aec2c7..1ab2cbbc7a76 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1583,6 +1583,9 @@ static bool is_feature_id_reg(u32 encoding)
>  */
> static inline bool is_vm_ftr_id_reg(u32 id)
> {
> +	if (id == SYS_CTR_EL0)
> +		return true;
> +
> 	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
> 		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
> 		sys_reg_CRm(id) < 8);
> @@ -1886,7 +1889,7 @@ static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> 	if (p->is_write)
> 		return write_to_read_only(vcpu, p, r);
>
> -	p->regval = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +	p->regval = IDREG(vcpu->kvm, SYS_CTR_EL0);
> 	return true;
> }
>
> @@ -2475,7 +2478,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
> 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
> 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
> -	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
> +	ID_WRITABLE(CTR_EL0, CTR_EL0_DIC_MASK |
> +			     CTR_EL0_IDC_MASK |
> +			     CTR_EL0_DminLine_MASK |
> +			     CTR_EL0_IminLine_MASK),
> 	{ SYS_DESC(SYS_SVCR), undef_access },
>
> 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
> @@ -3714,18 +3720,11 @@ FUNCTION_INVARIANT(midr_el1)
> FUNCTION_INVARIANT(revidr_el1)
> FUNCTION_INVARIANT(aidr_el1)
>
> -static u64 get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
> -{
> -	((struct sys_reg_desc *)r)->val = read_sanitised_ftr_reg(SYS_CTR_EL0);
> -	return ((struct sys_reg_desc *)r)->val;
> -}
> -
> /* ->val is filled in by kvm_sys_reg_table_init() */
> static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
> 	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
> 	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
> 	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
> -	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
> };
>
> static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
>
> -- 
> Thanks,
> Oliver
>
>

