Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE4261694
	for <kvmarm@lists.linux.dev>; Mon, 27 May 2024 08:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716799070; cv=none; b=j5atYiP76kaOfDcdvmtD0TjZxdLK9JaTTx3aS6uurazzbRzwQSr8DqHI9gMDU+NNspHP/SFVmIviia3Xp3u/RqdW+cLQMF/DwAP1uHKg5vEPXpnPMkgw6Bb1JWFN8DRvLzvBOdcrDto1U06mUC/ZnL018OmYVAY5GHrNIfdVsxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716799070; c=relaxed/simple;
	bh=XSj0u9ZXJq+7eaf8CcbjM7rxWFfV/W6a4v1ocsfitkE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gut89wI9qRoRk8C09cSJb/E7t4riXFrlma8VCKHa3FndrdAEnq9diKHA1WkmH5XeauePSe7djaZ51CbfLXkOX2IcRNanu3Sn08K5sIjSNCJBaXvBcBdxagL6ZK5VqcxYGxMyNsyfnprIDekmQ9rf0PjB3bK/yF7QwlqBYtBCAS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PUtVt8zz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PUtVt8zz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716799067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/RhgMwEECZFR61s8FYcjWW0awngsyyphJgJ6n/lYf0=;
	b=PUtVt8zzVItzDttOVsPAECFsUaSaReSAXIRZGcvf+Lvgps/Sg46xU5e5Y1GXVdIW88hhv8
	RhS57FpGkEHAPXjrzzensuQ3GNn9lszhFQhzi74aWEDBpoamiU6fj9bi3KnDCQdehBHqqt
	lfaM4a9r/fqH5Wz+7UYmlLueYMNZEnc=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-p9jC7rFTOPicYqVv3iE9eg-1; Mon, 27 May 2024 04:37:43 -0400
X-MC-Unique: p9jC7rFTOPicYqVv3iE9eg-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-6803de341a5so752608a12.1
        for <kvmarm@lists.linux.dev>; Mon, 27 May 2024 01:37:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716799062; x=1717403862;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D/RhgMwEECZFR61s8FYcjWW0awngsyyphJgJ6n/lYf0=;
        b=o9hRG1dGHPgCNQHQ1Y/GHbSIoS6YzJdLDleEFbG/Dpe9DVvOTA+uRXtVSoTE5y6qrg
         b6glEGABA9Z92IKSFNuE1jp09UkZHcdCQy7Q2uWllad4rjmn48FvZkJG5u408OJgkEKQ
         aaQAQbiZLsUU2KlZqjkjYbHY61g1qo8FPn7gp389AyDROAgPMurpqbW4R+an8IWe6s1b
         zxzgPd73OWKhicaHZU9jvM3jL1rH81SZ04HjQwZPJtijK7O1nDLD7ITxCpAdOAAs3lnO
         RVVc667miNTIZ4hexzSJIvJIUuGjqvCB2sPB44W3lRPUiTF/m+6jh8pMcRdwPGZYNgix
         t10w==
X-Forwarded-Encrypted: i=1; AJvYcCV1Qh5dowjDxvXQqFTbkkI9aIBAp/bbiOu9QfQixuOlfvxNpqb3tbE9isY/CUs6Z1zBJYpfDmf6haqeVJ0RHGIsaJIcHAT0
X-Gm-Message-State: AOJu0Yxqa9Y8E4KOsub74Kt82cEqO26oisj2gLmzjZjszDTHJsB7dvt1
	GAuuFcNC9qhOO2ur91aLD8ZkAnek4YWWVv3QLhjDnLWeC8gOdiYLv0IHyPGUAe2sYQHJ8m6OuaQ
	AtXCcteYvi3+bAAH28BOX9ySAbs/6VSHK9AfT9g4SEPkXy8iFKQxPqQ==
X-Received: by 2002:a17:902:d503:b0:1f4:81ab:7574 with SMTP id d9443c01a7336-1f481ab85b9mr41684685ad.5.1716799062482;
        Mon, 27 May 2024 01:37:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGscjyoiNahK4cBQM5AzDuutXhTg6JzVpYGLAK35GPyBGADXPe1FF2yh44qdXXpiGi7ipjNyQ==
X-Received: by 2002:a17:902:d503:b0:1f4:81ab:7574 with SMTP id d9443c01a7336-1f481ab85b9mr41684485ad.5.1716799061972;
        Mon, 27 May 2024 01:37:41 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f4ae2cc802sm7096095ad.17.2024.05.27.01.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 May 2024 01:37:41 -0700 (PDT)
Message-ID: <f96971e3-f92a-4dca-8e74-a00c9a8505f0@redhat.com>
Date: Mon, 27 May 2024 16:37:38 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] KVM: arm64: maintain per VM value for CTR_EL0
To: Sebastian Ott <sebott@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
References: <20240514072252.5657-1-sebott@redhat.com>
 <20240514072252.5657-3-sebott@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240514072252.5657-3-sebott@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 5/14/24 15:22, Sebastian Ott wrote:
> In preparation for CTR_EL0 emulation maintain a per VM for this
s/per VM/per VM value/     would be better
> register and use it where appropriate.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

Thanks,
Shaoqin
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 ++
>   arch/arm64/kvm/sys_regs.c         | 21 ++++++++++++++-------
>   2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 212ae77eefaf..1259be5e2f3e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -331,6 +331,8 @@ struct kvm_arch {
>   #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
>   	u64 id_regs[KVM_ARM_ID_REG_NUM];
>   
> +	u64 ctr_el0;
> +
>   	/* Masks for VNCR-baked sysregs */
>   	struct kvm_sysreg_masks	*sysreg_masks;
>   
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 41741bf4d2b2..0213c96f73f2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -219,9 +219,9 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>    * Returns the minimum line size for the selected cache, expressed as
>    * Log2(bytes).
>    */
> -static u8 get_min_cache_line_size(bool icache)
> +static u8 get_min_cache_line_size(struct kvm *kvm, bool icache)
>   {
> -	u64 ctr = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +	u64 ctr = kvm->arch.ctr_el0;
>   	u8 field;
>   
>   	if (icache)
> @@ -248,7 +248,7 @@ static u32 get_ccsidr(struct kvm_vcpu *vcpu, u32 csselr)
>   	if (vcpu->arch.ccsidr)
>   		return vcpu->arch.ccsidr[csselr];
>   
> -	line_size = get_min_cache_line_size(csselr & CSSELR_EL1_InD);
> +	line_size = get_min_cache_line_size(vcpu->kvm, csselr & CSSELR_EL1_InD);
>   
>   	/*
>   	 * Fabricate a CCSIDR value as the overriding value does not exist.
> @@ -283,7 +283,7 @@ static int set_ccsidr(struct kvm_vcpu *vcpu, u32 csselr, u32 val)
>   	u32 i;
>   
>   	if ((val & CCSIDR_EL1_RES0) ||
> -	    line_size < get_min_cache_line_size(csselr & CSSELR_EL1_InD))
> +	    line_size < get_min_cache_line_size(vcpu->kvm, csselr & CSSELR_EL1_InD))
>   		return -EINVAL;
>   
>   	if (!ccsidr) {
> @@ -1886,7 +1886,7 @@ static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>   	if (p->is_write)
>   		return write_to_read_only(vcpu, p, r);
>   
> -	p->regval = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +	p->regval = vcpu->kvm->arch.ctr_el0;
>   	return true;
>   }
>   
> @@ -1906,7 +1906,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>    */
>   static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>   {
> -	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
>   	u64 clidr;
>   	u8 loc;
>   
> @@ -1959,8 +1959,8 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>   static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>   		      u64 val)
>   {
> -	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
>   	u64 idc = !CLIDR_LOC(val) || (!CLIDR_LOUIS(val) && !CLIDR_LOUU(val));
> +	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
>   
>   	if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
>   		return -EINVAL;
> @@ -3557,6 +3557,13 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>   	struct kvm *kvm = vcpu->kvm;
>   	unsigned long i;
>   
> +	if (!kvm_vcpu_initialized(vcpu))
> +		/*
> +		 * Make sure CTR_EL0 is initialized before registers
> +		 * that depend on it are reset.
> +		 */
> +		kvm->arch.ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +
>   	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
>   		const struct sys_reg_desc *r = &sys_reg_descs[i];
>   

-- 
Shaoqin

