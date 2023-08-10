Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A14719BB3
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 08:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691657995;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4Q3bG06Um9xiuwQLyhROTUHKOWnInCYCVs9Q129Zb0=;
	b=jVBxn0Z/UyeTQ0SS5/R7pd0P3/5XWR715C11U8OIheoPtGj9UnWrq6Njy7E2yfhapg4ze3
	ieMb3HSRsfhnKcaRI4AF0EVfWKA0JcG9sxG/BMmWa4mlRekFIHi42XTPhiePbT63nRozJc
	yjTWpinNW9k0+cpTUPMNzaY4H1cd+M4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-D_8M_ZSePz-PVYG2jzbw0g-1; Thu, 10 Aug 2023 04:59:54 -0400
X-MC-Unique: D_8M_ZSePz-PVYG2jzbw0g-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-314256aedcbso408974f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 01:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691657993; x=1692262793;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c4Q3bG06Um9xiuwQLyhROTUHKOWnInCYCVs9Q129Zb0=;
        b=TO4nRt9rDhOAsTSdLGug02daUtp5ri9bm9spSNXdjwbFLQyHhSvDhMfWungu7NZVY7
         uKBuvJ4S94ockVDf7lekTRARgz1SlA0Jsu+zVCcGnq6oa5SbfGY2862IUYnR2S5KeLp5
         sQUJ3PlXxy6PkVnIcpg//vye9Gq/Y2ZWtwLwK9Bhe62UilQMJi7l+VRWyQAMA/Addhvt
         WvURhVLi7WjgzoBc5WU1zwZxDGFonFGWkOeTk1d0hz8Yzt4FOgQ4m2YlfkCfCpdxwVV/
         WwQ9XlBNKW7bbf1WCXQdu4lpyhAg0IK0DIXFluSY+PCRLY9iByg/26daTVOQL+YcpOaG
         sLVQ==
X-Gm-Message-State: AOJu0YzYimBMDAM2E1N/HUKbhxIMQFQ18cyMwfTmlV47cbXBnQzj8EOh
	/yKgpKihbjkVsL0yPKgAoqZrfyDVhcaz9WPn4NlukQ7h1XMnrXMCxk6ROolcmxad78JD/kE2mme
	9hD68rrkMfXwUxCC8
X-Received: by 2002:a5d:6450:0:b0:317:6513:da83 with SMTP id d16-20020a5d6450000000b003176513da83mr1697677wrw.43.1691657992893;
        Thu, 10 Aug 2023 01:59:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrNAflve3upAMyov7jePR9HhkLqj4IxvNQI19KVxlcAWoTyHZWkkK9xo/FbcP07VS+yI24Ug==
X-Received: by 2002:a5d:6450:0:b0:317:6513:da83 with SMTP id d16-20020a5d6450000000b003176513da83mr1697665wrw.43.1691657992546;
        Thu, 10 Aug 2023 01:59:52 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id i10-20020a5d438a000000b0031760af2331sm1431230wrq.100.2023.08.10.01.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 01:59:51 -0700 (PDT)
Message-ID: <6fd0dc2e-4837-ae64-65c7-c342764b668f@redhat.com>
Date: Thu, 10 Aug 2023 10:59:49 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 24/27] KVM: arm64: nv: Add switching support for
 HFGxTR/HDFGxTR
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230808114711.2013842-1-maz@kernel.org>
 <20230808114711.2013842-25-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230808114711.2013842-25-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 8/8/23 13:47, Marc Zyngier wrote:
> Now that we can evaluate the FGT registers, allow them to be merged
> with the hypervisor's own configuration (in the case of HFG{RW}TR_EL2)
> or simply set for HFGITR_EL2, HDGFRTR_EL2 and HDFGWTR_EL2.
HDFGRTR_EL2

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 48 +++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e096b16e85fd..a4750070563f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -70,6 +70,13 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +#define compute_clr_set(vcpu, reg, clr, set)				\
> +	do {								\
> +		u64 hfg;						\
> +		hfg = __vcpu_sys_reg(vcpu, reg) & ~__ ## reg ## _RES0;	\
> +		set |= hfg & __ ## reg ## _MASK; 			\
> +		clr |= ~hfg & __ ## reg ## _nMASK; 			\
> +	} while(0)
>  
>  
>  static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> @@ -97,6 +104,10 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>  		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
>  
> +	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> +		compute_clr_set(vcpu, HFGRTR_EL2, r_clr, r_set);
> +		compute_clr_set(vcpu, HFGWTR_EL2, w_clr, w_set);
> +	}
>  
>  	/* The default is not to trap anything but ACCDATA_EL1 */
>  	r_val = __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> @@ -109,6 +120,38 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  
>  	write_sysreg_s(r_val, SYS_HFGRTR_EL2);
>  	write_sysreg_s(w_val, SYS_HFGWTR_EL2);
> +
> +	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> +		return;
> +
> +	ctxt_sys_reg(hctxt, HFGITR_EL2) = read_sysreg_s(SYS_HFGITR_EL2);
> +
> +	r_set = r_clr = 0;
> +	compute_clr_set(vcpu, HFGITR_EL2, r_clr, r_set);
> +	r_val = __HFGITR_EL2_nMASK;
> +	r_val |= r_set;
> +	r_val &= ~r_clr;
> +
> +	write_sysreg_s(r_val, SYS_HFGITR_EL2);
> +
> +	ctxt_sys_reg(hctxt, HDFGRTR_EL2) = read_sysreg_s(SYS_HDFGRTR_EL2);
> +	ctxt_sys_reg(hctxt, HDFGWTR_EL2) = read_sysreg_s(SYS_HDFGWTR_EL2);
> +
> +	r_clr = r_set = w_clr = w_set = 0;
> +
> +	compute_clr_set(vcpu, HDFGRTR_EL2, r_clr, r_set);
> +	compute_clr_set(vcpu, HDFGWTR_EL2, w_clr, w_set);
> +
> +	r_val = __HDFGRTR_EL2_nMASK;
> +	r_val |= r_set;
> +	r_val &= ~r_clr;
> +
> +	w_val = __HDFGWTR_EL2_nMASK;
> +	w_val |= w_set;
> +	w_val &= ~w_clr;
> +
> +	write_sysreg_s(r_val, SYS_HDFGRTR_EL2);
> +	write_sysreg_s(w_val, SYS_HDFGWTR_EL2);
>  }
>  
>  static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> @@ -121,7 +164,12 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  	write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
>  	write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
>  
> +	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> +		return;
>  
> +	write_sysreg_s(ctxt_sys_reg(hctxt, HFGITR_EL2), SYS_HFGITR_EL2);
> +	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGRTR_EL2), SYS_HDFGRTR_EL2);
> +	write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2);
>  }
>  
>  static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
besides looks good to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

