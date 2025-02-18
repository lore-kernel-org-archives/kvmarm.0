Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3891D2309B5
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 15:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739892803; cv=none; b=YnxhcXrr0NgQwgGyZV0c2/ORHZ1PTH1I/MQozSXvoaavDoIul4OCJqowhLWYZkWqPOkixBK63UMLxIAyl84hafnFz0WbPDewze0nyRku9AV7qMewLs68DhOFHbgOEzu/HY8xlBcKsnkB3zF6L9VanLWsvUcu1wM11lLkBaPRnPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739892803; c=relaxed/simple;
	bh=MO5UCBGCyhir3P6PU8Z417LywKsJskz8wwebQ4THHNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rd8ekN8OmMJFs+DtcwVIAZVfOLezRANT97pQ/ZIyYIsanvMvNRns9DcibKwZ9V6P2F1IQ4sqxQIx8Vy1vHGEMXaJBm/vygLnMNst4B9ioILJB0NFOSnAFq/NZQV2fgVqlDLwLFHVOQoJSBIRlyCljXYTucUEbZ2g9olxGQZt4vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DL2g7cSo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DL2g7cSo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739892800;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0UCjt3mp7yDvSEsnhqs87k56LFrtYTUCWzATqqG4knA=;
	b=DL2g7cSoa83cutkxLiFEqq1r4YDYUj9nmw4fc9uquHKzuTA9zsuf7kIRuWrH2aUaZ91qFI
	YqDy33m+3/2rRkLzDew5sTUPEHl/OMXt1WPNNGcqritCd/1nLHq4H7phFQ9XTtQ1D8lNrX
	OadBFLDwaO7LPimy3rclGGrv+RfY7cI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-xlBAYsWjNSiXt4R4KHErOg-1; Tue, 18 Feb 2025 10:33:17 -0500
X-MC-Unique: xlBAYsWjNSiXt4R4KHErOg-1
X-Mimecast-MFC-AGG-ID: xlBAYsWjNSiXt4R4KHErOg_1739892796
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38f20b530dfso5781464f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 07:33:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739892796; x=1740497596;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0UCjt3mp7yDvSEsnhqs87k56LFrtYTUCWzATqqG4knA=;
        b=VIVBFGpwTZPxhP2xQTBxJdQYm8Y5NXld1cLVFJAdBeUu/8rje+G37Sldfi5FvKUbKI
         Os1W91MDxCV1LB4PICPFTcnjvijGhqCne+N1EI9DWBgp4M1dbaEUooYbmPl/4B/mzhzn
         ShYM4B1m9GcIxPqpjPAs1Omn7irAAutWuqsUNGyOgLIaOBFu21YzoaZmlSKVGCihVk1G
         5SVXJFUTUAnE/LFhEoRGwZLbkGzvF/p1+dSIDupmyBZC2xzqMPwbUePSympsxl64wsQu
         rOYEMH3QRQCj5Fy8r+kVJa9oKmq8dLPoYNi/tnX1xsgwnyCJMcHCs1C+Xv9hKHKtx57q
         ubhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUA1YS61GE0FN6Xc7c8q/9mG5MMU0vTI3xHFtsTI0DmjnGD0mxOttrJmDMSeYxNn0W9N/eZrT0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyb6VRfEXjcYvkwArHG/o/w2vWkFpn78JcuBKepcnAd95+MFYqh
	FuH5p02MdSnwzLsMIza9tKB4AQLjIhjxiq87L8ldQ+qpVmYFydzv+BjWW9gu7ocWKZ0ArK/8THk
	TCtnh/6xTZOSXzKUO4au1aJu65BHx4SxE3HitaNHukIdRFmhNK6+aUA==
X-Gm-Gg: ASbGncu2gDeny4e/LI9WTfUfB01Yl3rrK2Q9KfmpLf9QTgVdffL8XhipxFJQDZqV+Ip
	32tY/iVbFve69u0daxIKRGKophEjN1JzNDsrtXTGv1nq3oVqaDz5r3Jqk9Tm7AVN/ToPMXpD2+K
	oPq3Mw+AL6+1jU+7EQacklpOcjpocRCvFvTEedRnEdRuj+mikAcvAHx6DqZHmfZ+tlQ+GREmXmJ
	zR+b4/1UWpyNLrdOgdWHBUmd+imLj0FvNesK5fFYx/G57G4fsdiHKTh9KoHrvS4jjM+AKvD+lmK
	fExW++amrx+l8vvQd53Hg6Whzr+DcngWgKpIsU7KGjRReEugFC6c
X-Received: by 2002:adf:e80a:0:b0:38f:2230:c0ff with SMTP id ffacd0b85a97d-38f33f4ea6dmr10548881f8f.30.1739892796522;
        Tue, 18 Feb 2025 07:33:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzkUCXr2JJcUxJNQuE/eRCZ66ignXp/RWQWbK2xa7+TiL33a+A9YN3MmY2SKlj/Tq3XxIkyA==
X-Received: by 2002:adf:e80a:0:b0:38f:2230:c0ff with SMTP id ffacd0b85a97d-38f33f4ea6dmr10548858f8f.30.1739892796174;
        Tue, 18 Feb 2025 07:33:16 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d5c36sm15486329f8f.67.2025.02.18.07.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 07:33:15 -0800 (PST)
Message-ID: <b1a2e796-b2f5-4acc-9d6d-e85d99d67a0d@redhat.com>
Date: Tue, 18 Feb 2025 16:33:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 02/15] arm/kvm: add accessors for storing host features
 into idregs
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-3-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250207110248.1580465-3-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xAu9zrcQgcVJChuD8efh38askqlLVQmXzM_JSjlZPxI_1739892796
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Hi Connie

On 2/7/25 12:02 PM, Cornelia Huck wrote:
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu-sysregs.h |  3 +++
>  target/arm/cpu64.c       | 25 +++++++++++++++++++++++++
>  target/arm/kvm.c         | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 58 insertions(+)
>
> diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
> index de09ebae91a5..54a4fadbf0c1 100644
> --- a/target/arm/cpu-sysregs.h
> +++ b/target/arm/cpu-sysregs.h
> @@ -128,4 +128,7 @@ static const uint32_t id_register_sysreg[NUM_ID_IDX] = {
>      [CTR_EL0_IDX] = SYS_CTR_EL0,
>  };
>  
> +int get_sysreg_idx(ARMSysRegs sysreg);
> +uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg);
> +
>  #endif /* ARM_CPU_SYSREGS_H */
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 8188ede5cc8a..9ae78253cb34 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -736,6 +736,31 @@ static void aarch64_a53_initfn(Object *obj)
>      define_cortex_a72_a57_a53_cp_reginfo(cpu);
>  }
>  
> +#ifdef CONFIG_KVM
> +
> +int get_sysreg_idx(ARMSysRegs sysreg)
> +{
> +    int i;
> +
> +    for (i = 0; i < NUM_ID_IDX; i++) {
> +        if (id_register_sysreg[i] == sysreg) {
I agree with Richard that if we could get rid of this linear search it
would be nicer.
> +            return i;
> +        }
> +    }
> +    return -1;
> +}
> +
> +uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg)
> +{
> +    return ARM64_SYS_REG((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >> CP_REG_ARM64_SYSREG_OP0_SHIFT,
> +                         (sysreg & CP_REG_ARM64_SYSREG_OP1_MASK) >> CP_REG_ARM64_SYSREG_OP1_SHIFT,
> +                         (sysreg & CP_REG_ARM64_SYSREG_CRN_MASK) >> CP_REG_ARM64_SYSREG_CRN_SHIFT,
> +                         (sysreg & CP_REG_ARM64_SYSREG_CRM_MASK) >> CP_REG_ARM64_SYSREG_CRM_SHIFT,
> +                         (sysreg & CP_REG_ARM64_SYSREG_OP2_MASK) >> CP_REG_ARM64_SYSREG_OP2_SHIFT);
> +}
> +
> +#endif
> +
>  static void aarch64_host_initfn(Object *obj)
>  {
>  #if defined(CONFIG_KVM)
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index da30bdbb2349..3b8bb5661f2b 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -246,6 +246,36 @@ static bool kvm_arm_pauth_supported(void)
>              kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
>  }
>  
> +/* read a 32b sysreg value and store it in the idregs */
> +static int get_host_cpu_reg32(int fd, ARMHostCPUFeatures *ahcf, ARMSysRegs sysreg)
those are defined as static but there is no user so this will break
compilation locally

Eric
> +{
> +    int index = get_sysreg_idx(sysreg);
> +    uint64_t *reg;
> +    int ret;
> +
> +    if (index < 0) {
> +        return -ERANGE;
> +    }
> +    reg = &ahcf->isar.idregs[index];
> +    ret = read_sys_reg32(fd, (uint32_t *)reg, idregs_sysreg_to_kvm_reg(sysreg));
> +    return ret;
> +}
> +
> +/* read a 64b sysreg value and store it in the idregs */
> +static int get_host_cpu_reg64(int fd, ARMHostCPUFeatures *ahcf, ARMSysRegs sysreg)
> +{
> +    int index = get_sysreg_idx(sysreg);
> +    uint64_t *reg;
> +    int ret;
> +
> +    if (index < 0) {
> +        return -ERANGE;
> +    }
> +    reg = &ahcf->isar.idregs[index];
> +    ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
> +    return ret;
> +}
> +
>  static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>  {
>      /* Identify the feature bits corresponding to the host CPU, and

