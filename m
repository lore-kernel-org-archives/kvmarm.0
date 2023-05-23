Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FEB4A840
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 11:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684842773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06VwMlvzR/6CE72qZy68IsZn5wGl4zzgeBN/A6aW1cc=;
	b=MsuxQ6ktF467fOie33aFnbvYxyAEX7NdOzzxEGLmmPCx9Iy0vdw/0bYwJMhFS6KaSV+Pc0
	9Jnx7hMY5jpXyXsVJxpLa8FZfWYBKcWtLCvhsROPmMO2eoi4yvmLLkL2HcNx3cQATFqaTg
	jwzCBXPQa8lswkpQ3OCh/fP6iBT1yuU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-Q3yE5q-JNN6Ra0AqddZqQQ-1; Tue, 23 May 2023 07:52:51 -0400
X-MC-Unique: Q3yE5q-JNN6Ra0AqddZqQQ-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2535c34919bso241827a91.1
        for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 04:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684842770; x=1687434770;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=06VwMlvzR/6CE72qZy68IsZn5wGl4zzgeBN/A6aW1cc=;
        b=KpwG1uAtTFG43NSQufLJZPlK4RKOfZe6Iz5796Kbv318boRNU8c45o9EyZ1rjfsUW3
         0s7V5PELwOCMm+qQQdrLTM3kvqGevfMVA2FMxlx38bin05NrqEyuVUwKZvTedRkJpS/0
         us5VXp0FZl1Q6iTUPPnN6t7wFjVkoFm74Wa1ixTQPog3UtlcM9XP6D79uBc1HEK/h0d1
         Oz/emblL46fTfDov9W/rP9LgsYHOYRJvMAXRygaEvJwAVmT84u3Ld+e0OmMui2zB71h/
         S3uI1bZKXJRuXOSvu8rmk1IdjncfI5Kul9LIC2rFY0COKSLBAdf8dtaIQ47NcMqlCHIk
         SfTQ==
X-Gm-Message-State: AC+VfDwgq7A3ZKMP09eyqrtNJy8bEnikVB5mpXDRHuXfsojml4OA6P2R
	euSB+LZ2FRw2j0CNQbFkvumrFhE/bHEO1QhT8P1F9CBtmA0e8y6LTOXqB0igtinD2MPGGiFSAzA
	8HJAPW2yTE2ffAOOg
X-Received: by 2002:a17:903:2341:b0:1ac:3ebc:af0c with SMTP id c1-20020a170903234100b001ac3ebcaf0cmr14894237plh.1.1684842770673;
        Tue, 23 May 2023 04:52:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6vP9F0VfIfiU5Je8+q5mg6HvhTsJ6AolGVBg5cr9od6knJO5Ku6pDmkpyrmFj/G2NCOZWtlQ==
X-Received: by 2002:a17:903:2341:b0:1ac:3ebc:af0c with SMTP id c1-20020a170903234100b001ac3ebcaf0cmr14894226plh.1.1684842770366;
        Tue, 23 May 2023 04:52:50 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ja2-20020a170902efc200b001ab13f1fa82sm6645521plb.85.2023.05.23.04.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 04:52:50 -0700 (PDT)
Message-ID: <47e5efc6-f635-70a1-83d6-0c1efbd9168b@redhat.com>
Date: Tue, 23 May 2023 19:52:45 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/5] arm64/sysreg: Standardise naming of bitfield
 constants in OSL[AS]R_EL1
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
 <20230419-arm64-syreg-gen-v1-4-936cd769cb9e@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230419-arm64-syreg-gen-v1-4-936cd769cb9e@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/23/23 00:22, Mark Brown wrote:
> Our standard scheme for naming the constants for bitfields in system
> registers includes _ELx in the name but not the SYS_, update the
> constants for OSL[AS]R_EL1 to follow this convention.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 +-
>   arch/arm64/include/asm/sysreg.h   | 10 +++++-----
>   arch/arm64/kvm/sys_regs.c         | 10 +++++-----
>   3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bcd774d74f34..cde4ad590f8c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -996,7 +996,7 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>   void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
>   
>   #define kvm_vcpu_os_lock_enabled(vcpu)		\
> -	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK))
> +	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & OSLSR_EL1_OSLK))
>   
>   int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>   			       struct kvm_device_attr *attr);
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 4ecae92b56b5..09de958e79ed 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -141,13 +141,13 @@
>   #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
>   
>   #define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
> -#define SYS_OSLAR_OSLK			BIT(0)
> +#define OSLAR_EL1_OSLK			BIT(0)
>   
>   #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
> -#define SYS_OSLSR_OSLM_MASK		(BIT(3) | BIT(0))
> -#define SYS_OSLSR_OSLM_NI		0
> -#define SYS_OSLSR_OSLM_IMPLEMENTED	BIT(3)
> -#define SYS_OSLSR_OSLK			BIT(1)
> +#define OSLSR_EL1_OSLM_MASK		(BIT(3) | BIT(0))
> +#define OSLSR_EL1_OSLM_NI		0
> +#define OSLSR_EL1_OSLM_IMPLEMENTED	BIT(3)
> +#define OSLSR_EL1_OSLK			BIT(1)
>   
>   #define SYS_OSDLR_EL1			sys_reg(2, 0, 1, 3, 4)
>   #define SYS_DBGPRCR_EL1			sys_reg(2, 0, 1, 4, 4)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 53749d3a0996..8a5160a90d3c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -388,9 +388,9 @@ static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
>   		return read_from_write_only(vcpu, p, r);
>   
>   	/* Forward the OSLK bit to OSLSR */
> -	oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
> -	if (p->regval & SYS_OSLAR_OSLK)
> -		oslsr |= SYS_OSLSR_OSLK;
> +	oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~OSLSR_EL1_OSLK;
> +	if (p->regval & OSLAR_EL1_OSLK)
> +		oslsr |= OSLSR_EL1_OSLK;
>   
>   	__vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
>   	return true;
> @@ -414,7 +414,7 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>   	 * The only modifiable bit is the OSLK bit. Refuse the write if
>   	 * userspace attempts to change any other bit in the register.
>   	 */
> -	if ((val ^ rd->val) & ~SYS_OSLSR_OSLK)
> +	if ((val ^ rd->val) & ~OSLSR_EL1_OSLK)
>   		return -EINVAL;
>   
>   	__vcpu_sys_reg(vcpu, rd->reg) = val;
> @@ -1760,7 +1760,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
>   	{ SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
>   	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1,
> -		SYS_OSLSR_OSLM_IMPLEMENTED, .set_user = set_oslsr_el1, },
> +		OSLSR_EL1_OSLM_IMPLEMENTED, .set_user = set_oslsr_el1, },
>   	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
>   	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
>   	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
> 

-- 
Shaoqin

