Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB12FC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Nov 2021 20:30:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F9554B0FB;
	Thu, 25 Nov 2021 15:30:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LpyJ+Sj8enXb; Thu, 25 Nov 2021 15:30:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0996C4B13E;
	Thu, 25 Nov 2021 15:30:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6CDF4B129
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 15:30:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1PnjNUdVZa0R for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Nov 2021 15:30:37 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C0034B0FB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 15:30:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637872237;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iNfrKVVQE1EpKSUQXL266KgcPgP5LAHIUbP4H9pnx5A=;
 b=ebICdqRSIK7neFdEfX6JqV/YtnbFDSRT6xa+LGGwKLw9N3BLAu98yuL9ZVFwUNwZ1I6Czz
 o9TJn9+VnIjMZd3LH5FEe6yl3vTkZH2KNbr00Pg3zGAe3Qw/tkxDWVSHoV3K2wxv+FOHgy
 9NE/OaSlxZwuR6XCj0DOsyF2zDzqDJY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-igyTGAixMtiQKT01quEiXQ-1; Thu, 25 Nov 2021 15:30:33 -0500
X-MC-Unique: igyTGAixMtiQKT01quEiXQ-1
Received: by mail-wm1-f70.google.com with SMTP id
 o18-20020a05600c511200b00332fa17a02eso4066492wms.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 12:30:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=iNfrKVVQE1EpKSUQXL266KgcPgP5LAHIUbP4H9pnx5A=;
 b=ir2Kxct8cbuT/XEJNQ6IjRK8WHSZ0ZHdpSsW4VzMM0IRdWx+kBrCdSHvqeLvW8yBUB
 rJgJE4LgjuI7XSfhsx4c543dFnOzAK7f1daVEpp6S6ttWTzhad21nCAkFF4d72udynFT
 A8SCOZSz+MVxO26ZAf8N9zdCGskFXTREigCLTGqiFVDMiXL6JM9+zkcH1AI/UDQRXpBs
 DIfsTuE6siCYASFTyxpRvzQZgpt/DVUCYLJw5jV6aoXWoaNTJ85rKu6/JWPCN1v+2awY
 Hr7tZzZ2yjnxiQR54l/0ETRKLhvDacZgS1Gpt3HeHAkNGI6DuS4husyCql0S5eK/9K6d
 LG5g==
X-Gm-Message-State: AOAM532qWxfZhJ8kfGT/58EizlQl80ZllAGM036Trh9n/L1GP89pNfLP
 0mom9Siov3tgqbWVzOGo0vFvpUsXSPmfoO3Gr/sVpnQdwoDXnIhlRBq+2Yd+2+gb//8NHTydGMO
 0hH9EGQC9fKMq3R+C6Bt46ACT
X-Received: by 2002:a05:600c:4e4a:: with SMTP id
 e10mr11046002wmq.155.1637872232475; 
 Thu, 25 Nov 2021 12:30:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxpB9Sne6bt528o4LNrZerhkHTAF8WsnuzTgtVSd8aKZYeAIsgjjsTr9RNNaL6WNzAIXffHmw==
X-Received: by 2002:a05:600c:4e4a:: with SMTP id
 e10mr11045959wmq.155.1637872232202; 
 Thu, 25 Nov 2021 12:30:32 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id h27sm10008150wmc.43.2021.11.25.12.30.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Nov 2021 12:30:31 -0800 (PST)
Subject: Re: [RFC PATCH v3 10/29] KVM: arm64: Make ID_AA64DFR0_EL1 writable
To: Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-11-reijiw@google.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <bb557b85-8d28-486e-d22c-b3021888bcf8@redhat.com>
Date: Thu, 25 Nov 2021 21:30:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-11-reijiw@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> This patch adds id_reg_info for ID_AA64DFR0_EL1 to make it writable
> by userspace.
> 
> Return an error if userspace tries to set PMUVER field of the
> register to a value that conflicts with the PMU configuration.
> 
> Since number of context-aware breakpoints must be no more than number
> of supported breakpoints according to Arm ARM, return an error
> if userspace tries to set CTX_CMPS field to such value.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 84 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 73 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 772e3d3067b2..0faf458b0efb 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -626,6 +626,45 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static bool id_reg_has_pmu(u64 val, u64 shift, unsigned int min)
I would rename the function as the name currently is misleading. The
function validate the val filed @shift againt @min
> +{
> +	unsigned int pmu = cpuid_feature_extract_unsigned_field(val, shift);
> +
> +	/*
> +	 * Treat IMPLEMENTATION DEFINED functionality as unimplemented for
> +	 * ID_AA64DFR0_EL1.PMUVer/ID_DFR0_EL1.PerfMon.
> +	 */
> +	if (pmu == 0xf)
> +		pmu = 0;
Shouldn't we simply forbid the userspace to set 0xF?
> +
> +	return (pmu >= min);
> +}
> +
> +static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +				    const struct id_reg_info *id_reg, u64 val)
> +{
> +	unsigned int brps, ctx_cmps;
> +	bool vcpu_pmu, dfr0_pmu;
> +
> +	brps = cpuid_feature_extract_unsigned_field(val, ID_AA64DFR0_BRPS_SHIFT);
> +	ctx_cmps = cpuid_feature_extract_unsigned_field(val, ID_AA64DFR0_CTX_CMPS_SHIFT);
> +
> +	/*
> +	 * Number of context-aware breakpoints can be no more than number of
> +	 * supported breakpoints.
> +	 */
> +	if (ctx_cmps > brps)
> +		return -EINVAL;
> +
> +	vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
> +	dfr0_pmu = id_reg_has_pmu(val, ID_AA64DFR0_PMUVER_SHIFT, ID_AA64DFR0_PMUVER_8_0);
> +	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
> +	if (vcpu_pmu ^ dfr0_pmu)
> +		return -EPERM;
> +
> +	return 0;
> +}
> +
>  static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
>  {
>  	u64 limit = id_reg->vcpu_limit_val;
> @@ -669,6 +708,23 @@ static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
>  		id_reg->vcpu_limit_val &= ~PTRAUTH_MASK;
>  }
>  
> +static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
> +{
> +	u64 limit = id_reg->vcpu_limit_val;
> +
> +	/* Limit guests to PMUv3 for ARMv8.4 */
> +	limit = cpuid_feature_cap_perfmon_field(limit, ID_AA64DFR0_PMUVER_SHIFT,
> +						ID_AA64DFR0_PMUVER_8_4);
> +	/* Limit debug to ARMv8.0 */
> +	limit &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
> +	limit |= (FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6));
> +
> +	/* Hide SPE from guests */
> +	limit &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
> +
> +	id_reg->vcpu_limit_val = limit;
> +}
> +
>  static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  				     const struct id_reg_info *idr)
>  {
> @@ -698,6 +754,14 @@ static u64 get_reset_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
>  	       idr->vcpu_limit_val : (idr->vcpu_limit_val & ~PTRAUTH_MASK);
>  }
>  
> +static u64 get_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +				     const struct id_reg_info *idr)
> +{
> +	return kvm_vcpu_has_pmu(vcpu) ?
> +	       idr->vcpu_limit_val :
> +	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)));
> +}
> +
>  static struct id_reg_info id_aa64pfr0_el1_info = {
>  	.sys_reg = SYS_ID_AA64PFR0_EL1,
>  	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
> @@ -742,6 +806,14 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
>  	.validate = validate_id_aa64mmfr0_el1,
>  };
>  
> +static struct id_reg_info id_aa64dfr0_el1_info = {
> +	.sys_reg = SYS_ID_AA64DFR0_EL1,
> +	.ftr_check_types = S_FCT(ID_AA64DFR0_DOUBLELOCK_SHIFT, FCT_LOWER_SAFE),
> +	.init = init_id_aa64dfr0_el1_info,
> +	.validate = validate_id_aa64dfr0_el1,
> +	.get_reset_val = get_reset_id_aa64dfr0_el1,
> +};
> +
>  /*
>   * An ID register that needs special handling to control the value for the
>   * guest must have its own id_reg_info in id_reg_info_table.
> @@ -753,6 +825,7 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
>  static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
>  	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
> +	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
> @@ -1604,17 +1677,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), gic_lim);
>  		}
>  		break;
> -	case SYS_ID_AA64DFR0_EL1:
> -		/* Limit debug to ARMv8.0 */
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
> -		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
> -		/* Limit guests to PMUv3 for ARMv8.4 */
> -		val = cpuid_feature_cap_perfmon_field(val,
> -						      ID_AA64DFR0_PMUVER_SHIFT,
> -						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
> -		/* Hide SPE from guests */
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
> -		break;
>  	case SYS_ID_DFR0_EL1:
>  		/* Limit guests to PMUv3 for ARMv8.4 */
>  		val = cpuid_feature_cap_perfmon_field(val,
> 
Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
