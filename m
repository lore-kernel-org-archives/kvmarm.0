Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61049C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 13:46:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2BB44B1AD;
	Wed, 24 Nov 2021 08:46:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xgsQf77VMEL7; Wed, 24 Nov 2021 08:46:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4F04B168;
	Wed, 24 Nov 2021 08:46:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2284B165
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 08:46:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rhfbntJjsMkY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 08:46:11 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB8FC4B160
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 08:46:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637761571;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OtRl2DIeR6fkYgUP++XZmn9F5k5GX+nWQIi0KKjrOO4=;
 b=CUGXx1mneI9QnNiSzjR9gay98Lq6te7wrzBrNsoRUfZ+mE+vf3mZJ7/AhJjEJhvZhoy8hu
 sIhh8gFpAfaJFSYa9PmiGDPj1FH2PmtpdK1hGMHLirwsMv/mH5+4DUIKTKXXEI6MIk1FED
 8Myvd70DTX1lQkeijjrTJvtRPIEMgkQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-DZxi5j-7NuGiEaAWvIKKMA-1; Wed, 24 Nov 2021 08:46:10 -0500
X-MC-Unique: DZxi5j-7NuGiEaAWvIKKMA-1
Received: by mail-wr1-f72.google.com with SMTP id
 d18-20020adfe852000000b001985d36817cso502766wrn.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 05:46:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:subject:to:cc:references:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=OtRl2DIeR6fkYgUP++XZmn9F5k5GX+nWQIi0KKjrOO4=;
 b=ScAf6e5++JkD8iP/SsTbVEr9+JMgAL9CdylCNjvIiSOB78B6cwPqb3MKyqnYx3u1f1
 UHpNwBh53CsByP+IgDgzWlfzBZWwrB8h5SB9RSoUeHFYsgUzNXCuA+kabc0l7l7ViUi2
 9EjcoJhjOhFjMgNPKQDcf6vYzx7uhLGoDt6T4ApCmE6FNnkEL4nTDCE9+DLHsPN2AbTR
 Jrxbg9qtTsDEGCKg/9Fw0GFobLsW2wt0apYOeXKLmO5uwt5nHmNLfN9TqxufRpMhQ3lN
 tNRjnXw77ujq4sGNqSeYrN3DR5IbTqyX76Qq2d1RXY2LbVbULJGZg2le5te9b0J8ERdg
 pbnQ==
X-Gm-Message-State: AOAM530Gf2V5mT/7OXIaeL3A1hKkkuIqZ6uyWuTlekMRCuxPNT7MK4ph
 ZkeCi5ZhBsB0fP+IBUj7YdvbiNLYyZFSAQ7hMlUYghHqymJJ0STrtaJt77Ic3LxZrrO0e68maav
 953PgGKlKV6zhPxZz0E/9WgA5
X-Received: by 2002:a05:600c:19c8:: with SMTP id
 u8mr15160961wmq.155.1637761569292; 
 Wed, 24 Nov 2021 05:46:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzwKOp/eXh78FWh0Lz/OPIavW3bbflloOckEelksALsyukTUhRiaUa5Q6OjguOoC1UT9wglgw==
X-Received: by 2002:a05:600c:19c8:: with SMTP id
 u8mr15160919wmq.155.1637761569079; 
 Wed, 24 Nov 2021 05:46:09 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id d7sm14680732wrw.87.2021.11.24.05.46.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 24 Nov 2021 05:46:08 -0800 (PST)
From: Eric Auger <eauger@redhat.com>
Subject: Re: [RFC PATCH v3 11/29] KVM: arm64: Make ID_DFR0_EL1 writable
To: Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-12-reijiw@google.com>
Message-ID: <cda3eb28-1cf6-da6e-1769-104c29f81d4a@redhat.com>
Date: Wed, 24 Nov 2021 14:46:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-12-reijiw@google.com>
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
> This patch adds id_reg_info for ID_DFR0_EL1 to make it writable
> by userspace.
> 
> Return an error if userspace tries to set PerfMon field of the
> register to a value that conflicts with the PMU configuration.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 52 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 46 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0faf458b0efb..fbd335ac5e6b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -665,6 +665,27 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
> +				const struct id_reg_info *id_reg, u64 val)
> +{
> +	bool vcpu_pmu, dfr0_pmu;
> +	unsigned int perfmon;
> +
> +	perfmon = cpuid_feature_extract_unsigned_field(val, ID_DFR0_PERFMON_SHIFT);
> +	if (perfmon == 1 || perfmon == 2)
> +		/* PMUv1 or PMUv2 is not allowed on ARMv8. */
> +		return -EINVAL;
> +
> +	vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
> +	dfr0_pmu = id_reg_has_pmu(val, ID_DFR0_PERFMON_SHIFT, ID_DFR0_PERFMON_8_0);
> +
> +	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
> +	if (vcpu_pmu ^ dfr0_pmu)
> +		return -EPERM;
This breaks the migration on ThunderX v2 as vcpu_pmu == true and
dfr0_pmu == false

Thanks

Eric
> +
> +	return 0;
> +}
> +
>  static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
>  {
>  	u64 limit = id_reg->vcpu_limit_val;
> @@ -725,6 +746,15 @@ static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
>  	id_reg->vcpu_limit_val = limit;
>  }
>  
> +static void init_id_dfr0_el1_info(struct id_reg_info *id_reg)
> +{
> +	/* Limit guests to PMUv3 for ARMv8.4 */
> +	id_reg->vcpu_limit_val =
> +		cpuid_feature_cap_perfmon_field(id_reg->vcpu_limit_val,
> +						ID_DFR0_PERFMON_SHIFT,
> +						ID_DFR0_PERFMON_8_4);
> +}
> +
>  static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  				     const struct id_reg_info *idr)
>  {
> @@ -762,6 +792,14 @@ static u64 get_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>  	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)));
>  }
>  
> +static u64 get_reset_id_dfr0_el1(struct kvm_vcpu *vcpu,
> +				 const struct id_reg_info *idr)
> +{
> +	return kvm_vcpu_has_pmu(vcpu) ?
> +	       idr->vcpu_limit_val :
> +	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_DFR0_PERFMON)));
> +}
> +
>  static struct id_reg_info id_aa64pfr0_el1_info = {
>  	.sys_reg = SYS_ID_AA64PFR0_EL1,
>  	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
> @@ -814,6 +852,13 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
>  	.get_reset_val = get_reset_id_aa64dfr0_el1,
>  };
>  
> +static struct id_reg_info id_dfr0_el1_info = {
> +	.sys_reg = SYS_ID_DFR0_EL1,
> +	.init = init_id_dfr0_el1_info,
> +	.validate = validate_id_dfr0_el1,
> +	.get_reset_val = get_reset_id_dfr0_el1,
> +};
> +
>  /*
>   * An ID register that needs special handling to control the value for the
>   * guest must have its own id_reg_info in id_reg_info_table.
> @@ -823,6 +868,7 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
>   */
>  #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
>  static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
> +	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
>  	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
> @@ -1677,12 +1723,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), gic_lim);
>  		}
>  		break;
> -	case SYS_ID_DFR0_EL1:
> -		/* Limit guests to PMUv3 for ARMv8.4 */
> -		val = cpuid_feature_cap_perfmon_field(val,
> -						      ID_DFR0_PERFMON_SHIFT,
> -						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
> -		break;
>  	}
>  
>  	return val;
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
