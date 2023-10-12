Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D92224CF
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PawnM9TE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697124182;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPVVrFpPDVyx3xRaYdaYaCN0WQspDDkOcGN6DIUH97E=;
	b=PawnM9TEt5KilgK+liuL3YtGD1ZvnxzEsnL1m+BIG5fTbl6TSpxGAmxa68w92WqzYb5zmd
	4wpJCdArX3JBgJUZ19Yt+CGF6urTrsj1mQI4HYw21QNGKihSoknVeBqDm42DZRpKaFbfKT
	UPaqkemBOu8gpINBKtAuLLR+9BJEgpE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-nlLZRUF7OV6saidUaeHviA-1; Thu, 12 Oct 2023 11:23:00 -0400
X-MC-Unique: nlLZRUF7OV6saidUaeHviA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-66d12cd3591so9348376d6.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 08:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697124180; x=1697728980;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LPVVrFpPDVyx3xRaYdaYaCN0WQspDDkOcGN6DIUH97E=;
        b=Cygnosbkn87T8EdFSwYsdSMYcfLBVKBBM7YOG020lSfwsOzUUwGvxG/BTf2jSBvR1H
         4RkWqjmCT3LQuMDbVw8IVoTQvRlC68H0SbFx+QHa/ehBN+x5Qgw95/vtp/zo+SGKPeNy
         X05Nsm+dB7W5JFx24LGJ9E/KS3u64Itrq5jXZjn6l5leXdJeshBGYg6V6f+8ny0YQ+i9
         3C9lKZxQzs31eoL39FHF2s1gLNliKKNY0kE1RnwEgW1PjhokXrdp7sFpdU6pk1uB2FI0
         Hd4dMtpLLEw+ao73W9yUy9x8YMLyzIR85OI5a97BD9LmrFgh5/LLpDkEbPVB+LKRkERR
         KvoA==
X-Gm-Message-State: AOJu0Yw4Kgi2km2IzxNR/GzB+RRSkxZ3XlUQUDgHQEBOr4H6rG8Km84r
	g3YyV+zsZo/foNXmn8/k18DNr1ce0/4aYLF//ctvMT943xMDjZ6mYCQ0uud/q20LXPsDDi1P5fd
	QtYgFybJw5W1+j9uE
X-Received: by 2002:a0c:8e8c:0:b0:64f:8213:197d with SMTP id x12-20020a0c8e8c000000b0064f8213197dmr22337067qvb.33.1697124180407;
        Thu, 12 Oct 2023 08:23:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCeMZIB3m1qx2fbkdT4OPLLEqPsHeGO1L/iAH1/dZ2KldB+ZvbUW9y7GqXbzwRlkPP4euU0Q==
X-Received: by 2002:a0c:8e8c:0:b0:64f:8213:197d with SMTP id x12-20020a0c8e8c000000b0064f8213197dmr22337044qvb.33.1697124180079;
        Thu, 12 Oct 2023 08:23:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id dy18-20020ad44e92000000b0066d11c1f578sm883123qvb.97.2023.10.12.08.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 08:22:59 -0700 (PDT)
Message-ID: <7df53e6b-9141-de85-b7a3-b9eb092ef7b4@redhat.com>
Date: Thu, 12 Oct 2023 17:22:56 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 3/3] arm64/kvm: Fine grain _EL2 system registers list
 that affect nested virtualization
To: Miguel Luis <miguel.luis@oracle.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
References: <20231011180103.91774-1-miguel.luis@oracle.com>
 <20231011180103.91774-4-miguel.luis@oracle.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20231011180103.91774-4-miguel.luis@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Miguel,

On 10/11/23 20:01, Miguel Luis wrote:
> Implement a fine grained approach in the _EL2 sysreg ranges.
>
> Fixes: d0fc0a2519a6 ("KVM: arm64: nv: Add trap forwarding for HCR_EL2")
> Signed-off-by: Miguel Luis <miguel.luis@oracle.com>
> ---
>  arch/arm64/kvm/emulate-nested.c | 88 ++++++++++++++++++++++++++++++---
>  1 file changed, 82 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 9ced1bf0c2b7..3af49e130ee6 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -648,15 +648,91 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
>  	SR_TRAP(SYS_APGAKEYLO_EL1,	CGT_HCR_APK),
>  	SR_TRAP(SYS_APGAKEYHI_EL1,	CGT_HCR_APK),
>  	/* All _EL2 registers */
> -	SR_RANGE_TRAP(sys_reg(3, 4, 0, 0, 0),
> -		      sys_reg(3, 4, 3, 15, 7), CGT_HCR_NV),
> +	SR_TRAP(SYS_VPIDR_EL2,		CGT_HCR_NV),
I think you miss DBGVCR32_EL2
> +	SR_TRAP(SYS_VMPIDR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_SCTLR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_ACTLR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_SCTLR2_EL2,		CGT_HCR_NV),
> +	SR_RANGE_TRAP(SYS_HCR_EL2,
> +		      SYS_HCRX_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_SMPRIMAP_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_SMCR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_SDER32_EL2,		CGT_HCR_NV),
> +	SR_RANGE_TRAP(SYS_TTBR0_EL2,
> +		      SYS_TCR2_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_VTTBR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_VTCR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_VNCR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_VSTTBR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_VSTCR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_DACR32_EL2,		CGT_HCR_NV),
> +	SR_RANGE_TRAP(SYS_HDFGRTR_EL2,
> +		      SYS_HAFGRTR_EL2,	CGT_HCR_NV),
>  	/* Skip the SP_EL1 encoding... */
>  	SR_TRAP(SYS_SPSR_EL2,		CGT_HCR_NV),
>  	SR_TRAP(SYS_ELR_EL2,		CGT_HCR_NV),
> -	SR_RANGE_TRAP(sys_reg(3, 4, 4, 1, 1),
> -		      sys_reg(3, 4, 10, 15, 7), CGT_HCR_NV),
> -	SR_RANGE_TRAP(sys_reg(3, 4, 12, 0, 0),
> -		      sys_reg(3, 4, 14, 15, 7), CGT_HCR_NV),
> +	/* SPSR_irq, SPSR_abt, SPSR_und, SPSR_fiq */
> +	SR_RANGE_TRAP(sys_reg(3, 4, 4, 3, 0),
> +		      sys_reg(3, 4, 4, 3, 3), CGT_HCR_NV),
> +	SR_TRAP(SYS_IFSR32_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_AFSR0_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_AFSR1_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_ESR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_VSESR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_FPEXC32_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_TFSR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_FAR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_HPFAR_EL2,		CGT_HCR_NV),
you miss BRBCR_EL2
> +	SR_TRAP(SYS_PMSCR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_MAIR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_AMAIR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_MPAMHCR_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_MPAMVPMV_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_MPAM2_EL2,		CGT_HCR_NV),
> +	SR_RANGE_TRAP(SYS_MPAMVPM0_EL2,
> +		      SYS_MPAMVPM7_EL2,	CGT_HCR_NV),
About the MPAM where did you find the pseudo code?
> +	/*
> +	 * Note that the spec. describes a group of MEC registers
> +	 * whose access should not trap, therefore skip the following:
> +	 * MECID_A0_EL2, MECID_A1_EL2, MECID_P0_EL2,
> +	 * MECID_P1_EL2, MECIDR_EL2, VMECID_A_EL2,
> +	 * VMECID_P_EL2.
> +	 */
> +	SR_RANGE_TRAP(SYS_VBAR_EL2,
> +		      SYS_RMR_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_VDISR_EL2,		CGT_HCR_NV),
> +	/* ICH_AP0R<m>_EL2 */
> +	SR_RANGE_TRAP(SYS_ICH_AP0R0_EL2,
> +		      SYS_ICH_AP0R3_EL2, CGT_HCR_NV),
> +	/* ICH_AP1R<m>_EL2 */
> +	SR_RANGE_TRAP(SYS_ICH_AP1R0_EL2,
> +		      SYS_ICH_AP1R3_EL2, CGT_HCR_NV),
> +	SR_TRAP(SYS_ICC_SRE_EL2,	CGT_HCR_NV),
> +	SR_RANGE_TRAP(SYS_ICH_HCR_EL2,
> +		      SYS_ICH_EISR_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_ICH_ELRSR_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_ICH_VMCR_EL2,	CGT_HCR_NV),
> +	/* ICH_LR<m>_EL2 */
> +	SR_RANGE_TRAP(SYS_ICH_LR0_EL2,
> +		      SYS_ICH_LR15_EL2, CGT_HCR_NV),
> +	SR_TRAP(SYS_CONTEXTIDR_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_TPIDR_EL2,		CGT_HCR_NV),
> +	SR_TRAP(SYS_SCXTNUM_EL2,	CGT_HCR_NV),
> +	/* AMEVCNTVOFF0<n>_EL2, AMEVCNTVOFF1<n>_EL2  */
> +	SR_RANGE_TRAP(SYS_AMEVCNTVOFF0n_EL2(0),
> +		      SYS_AMEVCNTVOFF1n_EL2(15), CGT_HCR_NV),
> +	/* CNT*_EL2 */
> +	SR_TRAP(SYS_CNTVOFF_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_CNTPOFF_EL2,	CGT_HCR_NV),
> +	SR_TRAP(SYS_CNTHCTL_EL2,	CGT_HCR_NV),
> +	SR_RANGE_TRAP(SYS_CNTHP_TVAL_EL2,
> +		      SYS_CNTHP_CVAL_EL2, CGT_HCR_NV),
> +	SR_RANGE_TRAP(SYS_CNTHV_TVAL_EL2,
> +		      SYS_CNTHV_CVAL_EL2, CGT_HCR_NV),
> +	SR_RANGE_TRAP(SYS_CNTHVS_TVAL_EL2,
> +		      SYS_CNTHVS_CVAL_EL2, CGT_HCR_NV),
> +	SR_RANGE_TRAP(SYS_CNTHPS_TVAL_EL2,
> +		      SYS_CNTHPS_CVAL_EL2, CGT_HCR_NV),
>  	/* All _EL02, _EL12 registers */
>  	SR_RANGE_TRAP(sys_reg(3, 5, 0, 0, 0),
>  		      sys_reg(3, 5, 10, 15, 7), CGT_HCR_NV),
Besides this looks good to me and to me this looks safer than the
previous large span approach but that's my taste ;-)

Thanks

Eric

 

