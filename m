Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9097946BC
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 08:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691656549;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jk538eFMrHIWa3w11rqlSGvFFMXijrmVWJBtVe7uM/A=;
	b=Bul/72VQKZiqcFu+fcMYbUUvS9N+AtwEwhLqH++73Mc24+7T8c8prHfkx3M2F4q93wgNYu
	Ofb/J5BzMqkrHg2sHbOo69/ipXDpKhYtX5/HXToWDTA39dItugN+MNtFLQ6MhTXhlN3eY4
	YjY1bYJIQlvXcJ8IdujuNvp8jSqIBBA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-fHjElUZEO6-jBn9vVlKmRQ-1; Thu, 10 Aug 2023 04:35:45 -0400
X-MC-Unique: fHjElUZEO6-jBn9vVlKmRQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f42bcef2acso3742325e9.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 01:35:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691656544; x=1692261344;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jk538eFMrHIWa3w11rqlSGvFFMXijrmVWJBtVe7uM/A=;
        b=NwCOx95h5VaQSkl7z5pV0Ul5XYhWPBvoRrfIhT3vQiVN9OnVzsgYIfqwttVXymM3NV
         HVnzlAF/vXJ7/8V9Elgq+rmI6dG+TWlMw1OVAZcml656N4iw18gTgUe70UhpOAoARXpO
         DbX1wVMz9F4gNiFl8CsjGSrq8Dtf8l1GPLkyZn3v3blsxzcFT2XvltdV8cuVsY9mNZXc
         pkl/yHostWH/B2XyxJz9FaSFR+HW4u5IsFcavjcPy7dr7/nPVE3u8o3l5KRCuRIYqaXF
         g5SMvwUyR7HoPlZX9ymwaTv43soHrufl115QEsTRMUx2ihtLriaMNqecmuiVMZHp2k2n
         xUWQ==
X-Gm-Message-State: AOJu0Yz2VChksM9cnUVDd1lR3Tnnb5kofZbtxT9ctGjU1M3DHoJlrlYU
	z85OxRNosZjrsbja/b2yZigP4ann28CbpnwdrzLYDqkXf2Myxlea9Jg+X44cOK4FkbedOdPOVyd
	RB8Zt+kgZGqwNCU02
X-Received: by 2002:a05:600c:2295:b0:3fb:e356:b60d with SMTP id 21-20020a05600c229500b003fbe356b60dmr1385053wmf.38.1691656544717;
        Thu, 10 Aug 2023 01:35:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKj1rJEmsV9LAdJXON8lV0H8i55xE2G2qoBc8w5J7RMLtkQJBRrLaKFMG6nBkIeF2lX3uNwA==
X-Received: by 2002:a05:600c:2295:b0:3fb:e356:b60d with SMTP id 21-20020a05600c229500b003fbe356b60dmr1385038wmf.38.1691656544383;
        Thu, 10 Aug 2023 01:35:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n20-20020a7bc5d4000000b003fe2a40d287sm1413364wmk.1.2023.08.10.01.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 01:35:43 -0700 (PDT)
Message-ID: <2a751a64-559e-cb17-4359-7f368c1b42ca@redhat.com>
Date: Thu, 10 Aug 2023 10:35:41 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 23/27] KVM: arm64: nv: Add SVC trap forwarding
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
 <20230808114711.2013842-24-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230808114711.2013842-24-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 8/8/23 13:47, Marc Zyngier wrote:
> HFGITR_EL2 allows the trap of SVC instructions to EL2. Allow these
> traps to be forwarded. Take this opportunity to deny any 32bit activity
> when NV is enabled.

I can't figure out how HFGITR_EL2.{SVC_EL1, SVC_EL0 and ERET} are
handled. Please could you explain.

Eric
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c         |  4 ++++
>  arch/arm64/kvm/handle_exit.c | 12 ++++++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 72dc53a75d1c..8b51570a76f8 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -36,6 +36,7 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/kvm_pkvm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/sections.h>
> @@ -818,6 +819,9 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
>  	if (likely(!vcpu_mode_is_32bit(vcpu)))
>  		return false;
>  
> +	if (vcpu_has_nv(vcpu))
> +		return true;
> +
>  	return !kvm_supports_32bit_el0();
>  }
>  
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 6dcd6604b6bc..3b86d534b995 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -226,6 +226,17 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static int handle_svc(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * So far, SVC traps only for NV via HFGITR_EL2. A SVC from a
> +	 * 32bit guest would be caught by vpcu_mode_is_bad_32bit(), so
> +	 * we should only have to deal with a 64 bit exception.
> +	 */
> +	kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +	return 1;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] = {
>  	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
>  	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
> @@ -239,6 +250,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[ESR_ELx_EC_SMC32]	= handle_smc,
>  	[ESR_ELx_EC_HVC64]	= handle_hvc,
>  	[ESR_ELx_EC_SMC64]	= handle_smc,
> +	[ESR_ELx_EC_SVC64]	= handle_svc,
>  	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
>  	[ESR_ELx_EC_SVE]	= handle_sve,
>  	[ESR_ELx_EC_ERET]	= kvm_handle_eret,

