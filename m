Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BA5516DD
	for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696000130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hEGFAwORKfsvdgrCcVd+UUjZF6l0U2fhYj6xzLXT72Y=;
	b=ZtMsEWNtl4H+mmwxu1iLV9YZXfEo43ZPHpZYxS+xRm0Eq/pYrswlxtulaeEfHVFhjk12YG
	2Tf2LxndwVK0VrvOx1Uvk+A5CHXrDxnLnxHLQmoZr2lRSglnkxjQR8tlpLDVuT6eODBC2s
	qy9JE7NVZGyjCyklRLmgtotNqBCIowY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-msQ29wyUP7KsxeFOw2hUCA-1; Fri, 29 Sep 2023 11:08:49 -0400
X-MC-Unique: msQ29wyUP7KsxeFOw2hUCA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-65b13294747so142433616d6.3
        for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 08:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696000128; x=1696604928;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hEGFAwORKfsvdgrCcVd+UUjZF6l0U2fhYj6xzLXT72Y=;
        b=H/ffnYSuobS6qEeDo8Nh/UcMSBu3iRXo+oHhZ3PUK7ozdZxa11cNieKdsSM0/56yz8
         KzR1V7aheACXmz3m/z2G7+rSHLklx4qjJcl5EdbJSpOBQKNxs0XVdpwmaiwO3Fg5+oIo
         +IKfgMC8QPTyeFTuBUXsuZWELWFEQQlJKC1D0IjSp2q8pCW81R4m1aRAagV47Pp7TMOw
         N3EORJk93vQmm8Mmf5z9bz3UK2aqptV0BmPwZ49b/abE0ehQ6D3+x5aP17eAcCC6Hz9l
         eVs4i7WTuOeezylG7ozVA2KD3SMWiXQbcVGS1fAXlJlURrDw8uxVcZp5IHCjw4yFBOAp
         6pyA==
X-Gm-Message-State: AOJu0Ywt7SmeoJHU2X5o/Inqc1Qzjf+hLuZcb+UnrSLhqobZqdyFics1
	eiiEKg867YL3aW+AEo8LwB0Gx6GjBHiRFlUvRj0HbPDQpfSLdpTFDAYqbw3rMjv56GchazRwcn5
	2KXrdN4q8px/k2CYX
X-Received: by 2002:a05:6214:5195:b0:656:3895:fcf9 with SMTP id kl21-20020a056214519500b006563895fcf9mr5233556qvb.32.1696000128459;
        Fri, 29 Sep 2023 08:08:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpXBwGNEJJzKEDm/uR6gg/YZKn0fFNat4TrMwImkQUzzjWH19IG5NZ7qpVQxSogcBiIrZGdw==
X-Received: by 2002:a05:6214:5195:b0:656:3895:fcf9 with SMTP id kl21-20020a056214519500b006563895fcf9mr5233520qvb.32.1696000128081;
        Fri, 29 Sep 2023 08:08:48 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a10-20020a0ce38a000000b0063f88855ef2sm3377788qvl.101.2023.09.29.08.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 08:08:47 -0700 (PDT)
Message-ID: <c01525e8-0906-6990-19b9-df374fdb087b@redhat.com>
Date: Fri, 29 Sep 2023 17:08:42 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 2/2] arm64/kvm: Fine grain _EL2 system registers list
 that affect nested virtualization
To: Miguel Luis <miguel.luis@oracle.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230925162057.27548-1-miguel.luis@oracle.com>
 <20230925162057.27548-3-miguel.luis@oracle.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20230925162057.27548-3-miguel.luis@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Miguel,
On 9/25/23 18:20, Miguel Luis wrote:
> Some _EL1 registers got included in the _EL2 ranges, which are not
if they aren't too many, you may list them as it eases the review
> affected by NV. Remove them, fine grain the ranges to exclusively
> include the _EL2 ones and fold SPSR/ELR _EL2 registers into the
> existing range.
> 
> Signed-off-by: Miguel Luis <miguel.luis@oracle.com>
Fixes: d0fc0a2519a6 (" KVM: arm64: nv: Add trap forwarding for HCR_EL2") ?
> ---
>  arch/arm64/kvm/emulate-nested.c | 44 ++++++++++++++++++++++++++++-----
>  1 file changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 9ced1bf0c2b7..f6d0c87803f4 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -649,14 +649,46 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
>  	SR_TRAP(SYS_APGAKEYHI_EL1,	CGT_HCR_APK),
>  	/* All _EL2 registers */
>  	SR_RANGE_TRAP(sys_reg(3, 4, 0, 0, 0),
> -		      sys_reg(3, 4, 3, 15, 7), CGT_HCR_NV),
> +		      sys_reg(3, 4, 4, 0, 1), CGT_HCR_NV),
>  	/* Skip the SP_EL1 encoding... */
> -	SR_TRAP(SYS_SPSR_EL2,		CGT_HCR_NV),
> -	SR_TRAP(SYS_ELR_EL2,		CGT_HCR_NV),
> -	SR_RANGE_TRAP(sys_reg(3, 4, 4, 1, 1),
> -		      sys_reg(3, 4, 10, 15, 7), CGT_HCR_NV),
I am not sure I fully understand the sysreg encoding but globally there
are not so many _EL2 regs trapped with .NV. And I can see holes within
somes ranges defined above (I searched all "if EL2Enabled() &&
HCR_EL2.NV == '1' then" in the ARM ARM). Maybe I don't know how to use
the ARM ARM doc but I feel  difficult to understand if the "holes"
within the encoding of some ranges are unused or are allocated to some
other sysregs, which wouldn't be trapped by /NV. I fear range encoding
may be quite risky.
> +	SR_RANGE_TRAP(sys_reg(3, 4, 4, 3, 0),
> +		      sys_reg(3, 4, 10, 6, 7), CGT_HCR_NV),
> +	/*
> +	 * Note that the spec. describes a group of MEC registers
> +	 * whose access should not trap, therefore skip the following:
> +	 * MECID_A0_EL2, MECID_A1_EL2, MECID_P0_EL2,
> +	 * MECID_P1_EL2, MECIDR_EL2, VMECID_A_EL2,
> +	 * VMECID_P_EL2.
> +	 */
>  	SR_RANGE_TRAP(sys_reg(3, 4, 12, 0, 0),
> -		      sys_reg(3, 4, 14, 15, 7), CGT_HCR_NV),
> +		      sys_reg(3, 4, 12, 1, 1), CGT_HCR_NV),
> +	/* ICH_AP0R<m>_EL2 */
> +	SR_RANGE_TRAP(SYS_ICH_AP0R0_EL2,
> +		      SYS_ICH_AP0R3_EL2, CGT_HCR_NV),
> +	/* ICH_AP1R<m>_EL2 */
> +	SR_RANGE_TRAP(SYS_ICH_AP1R0_EL2,
> +		      SYS_ICH_AP1R3_EL2, CGT_HCR_NV),
> +	SR_RANGE_TRAP(sys_reg(3, 4, 12, 9, 5),
> +		      sys_reg(3, 4, 12, 11, 7), CGT_HCR_NV),
> +	/* ICH_LR<m>_EL2 */
> +	SR_RANGE_TRAP(SYS_ICH_LR0_EL2,
> +		      SYS_ICH_LR7_EL2, CGT_HCR_NV),
> +	SR_RANGE_TRAP(SYS_ICH_LR8_EL2,
> +		      SYS_ICH_LR15_EL2, CGT_HCR_NV),
> +	SR_RANGE_TRAP(sys_reg(3, 4, 13, 0, 1),
> +		      sys_reg(3, 4, 13, 0, 7), CGT_HCR_NV),
> +	/* AMEVCNTVOFF0<n>_EL2 */
> +	SR_RANGE_TRAP(sys_reg(3, 4, 13, 8, 0),
> +		      sys_reg(3, 4, 13, 8, 7), CGT_HCR_NV),
> +	SR_RANGE_TRAP(sys_reg(3, 4, 13, 9, 0),
> +		      sys_reg(3, 4, 13, 9, 7), CGT_HCR_NV),
I think those 2 above ranges can be merged
> +	/* AMEVCNTVOFF1<n>_EL2 */
> +	SR_RANGE_TRAP(sys_reg(3, 4, 13, 10, 0),
> +		      sys_reg(3, 4, 13, 10, 7), CGT_HCR_NV),
> +	SR_RANGE_TRAP(sys_reg(3, 4, 13, 11, 0),
> +		      sys_reg(3, 4, 13, 11, 7), CGT_HCR_NV),
/* CNT*_EL2 */
> +	SR_RANGE_TRAP(sys_reg(3, 4, 14, 0, 3),
> +		      sys_reg(3, 4, 14, 5, 2), CGT_HCR_NV),
>  	/* All _EL02, _EL12 registers */
>  	SR_RANGE_TRAP(sys_reg(3, 5, 0, 0, 0),
>  		      sys_reg(3, 5, 10, 15, 7), CGT_HCR_NV),
not related to your patch but wrt the EL02 the only ones that I
idenftied beeing trapped by NV using above search are

CNTP_TVAL_EL02	3	5	14	2	0
CNTP_CTL_EL02	3	5	14	2	1
CNTP_CVAL_EL02	3	5	14	2	2
CNTV_TVAL_EL02	3	5	14	3	0
CNTV_CTL_EL02	3	5	14	3	1
CNTV_CVAL_EL02	3	5	14	3	2

Thanks

Eric

