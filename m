Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C2A1E1A9
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 12:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691671114;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e0Wo4ft2/DV+pES3oEs9VkOI6CJR3CbB7D53EzyrdWY=;
	b=CdlDeRaQnolhtdgz5+ZMBjGBN4jMH18/WJPAfiIaBJWbPV8fD0/oO8g8JOQGm72JlwDmuQ
	dGrKbgjUnIO7ZNszJC2zIPCoz/3qFaEa1cm6MMr9niD6U+U8QvzJ1ItbsuyhYqZdIu/hKL
	pnNsrfIrtSwIeXdeB40/9x6gAqgQFAs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-C93x--8cPKW_KFLma3wB_Q-1; Thu, 10 Aug 2023 08:38:31 -0400
X-MC-Unique: C93x--8cPKW_KFLma3wB_Q-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3176ace3f58so535606f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 05:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691671110; x=1692275910;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e0Wo4ft2/DV+pES3oEs9VkOI6CJR3CbB7D53EzyrdWY=;
        b=Rqgs+vibZVqpwCN2d3QsV/c21N9aF2Ty4qjDiReG+bBM8kBjf+H+nKQZy9Yq7MoGor
         0XZBSkoAsGOiW+C/YlGddydiDgfIAwCa2IJ7wvmb96lnfWOS6xoRgLCILKGgDBis6IFL
         Jbwjc6FlStHIeROAx/cGrDfDB6kCpqgsa2jvC8wYFQ33dfHB7U1Z5tJQY91oHz1IoHYp
         O60b0Qkme6bir4gTt4cznn89fkSIRsJwh4xxc5SkB6qrzzxQseAkv/HNqxugVLaeS7gb
         rMhMvGToyx/Nqf+n2LHzPUFxULyrk9JXVMclo70HKW23AmyoN99iZRJg6YibEn/ry2W8
         /t5g==
X-Gm-Message-State: AOJu0YyzRgGA/Ld77E4iB8BZLOgpMhgn14yK/z5LmbwTBwY3Gx2aArBr
	BonyHK6sDeGowAGUNDATiLGfCijlW/XZLjtGoRPrT8czs3madEauifF+ynDzm48BHz2AModzvqJ
	hmyEIqdSYMsehYLBq
X-Received: by 2002:a5d:61d0:0:b0:313:f463:9d40 with SMTP id q16-20020a5d61d0000000b00313f4639d40mr2256915wrv.65.1691671109949;
        Thu, 10 Aug 2023 05:38:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbXiWhGp1spWUmxlRDOb6WbdU0xknSGtpi8pHz6NkVFa/AtQ/PIb5TpAiXANZhMbQnGi8aQw==
X-Received: by 2002:a5d:61d0:0:b0:313:f463:9d40 with SMTP id q16-20020a5d61d0000000b00313f4639d40mr2256889wrv.65.1691671109649;
        Thu, 10 Aug 2023 05:38:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f18-20020a5d6652000000b003143ba62cf4sm2051508wrw.86.2023.08.10.05.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 05:38:28 -0700 (PDT)
Message-ID: <15fc525c-7357-7457-c3c2-a8211619e787@redhat.com>
Date: Thu, 10 Aug 2023 14:38:26 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 26/27] KVM: arm64: Move HCRX_EL2 switch to load/put on
 VHE systems
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
 <20230808114711.2013842-27-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230808114711.2013842-27-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 8/8/23 13:47, Marc Zyngier wrote:
> Although the nVHE behaviour requires HCRX_EL2 to be switched
> on each switch between host and guest, there is nothing in
> this register that would affect a VHE host.
>
> It is thus possible to save/restore this register on load/put
> on VHE systems, avoiding unnecessary sysreg access on the hot
> path. Additionally, it avoids unnecessary traps when running
> with NV.
>
> To achieve this, simply move the read/writes to the *_common()
> helpers, which are called on load/put on VHE, and more eagerly
> on nVHE.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index a4750070563f..060c5a0409e5 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -197,6 +197,9 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  
> +	if (cpus_have_final_cap(ARM64_HAS_HCX))
> +		write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
> +
>  	__activate_traps_hfgxtr(vcpu);
>  }
>  
> @@ -213,6 +216,9 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
>  		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
>  	}
>  
> +	if (cpus_have_final_cap(ARM64_HAS_HCX))
> +		write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
> +
>  	__deactivate_traps_hfgxtr(vcpu);
>  }
>  
> @@ -227,9 +233,6 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu)
>  
>  	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
>  		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
> -
> -	if (cpus_have_final_cap(ARM64_HAS_HCX))
> -		write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
>  }
>  
>  static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
> @@ -244,9 +247,6 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
>  		vcpu->arch.hcr_el2 &= ~HCR_VSE;
>  		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
>  	}
> -
> -	if (cpus_have_final_cap(ARM64_HAS_HCX))
> -		write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
>  }
>  
>  static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

