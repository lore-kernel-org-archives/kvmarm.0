Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2422C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 08:19:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47E374B25A;
	Thu, 21 Apr 2022 04:19:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aN9w3ogxuqOS; Thu, 21 Apr 2022 04:19:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C930F4B25C;
	Thu, 21 Apr 2022 04:19:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F7E24B246
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 04:19:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RBK+pI34E7wV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 04:19:42 -0400 (EDT)
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com
 [209.85.166.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C84354B23A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 04:19:42 -0400 (EDT)
Received: by mail-il1-f169.google.com with SMTP id r11so2606261ila.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 01:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=P56/aqSXvni0QoKYoULDb5A31mpfbgt7sEmpHmoEIlc=;
 b=gIn2mMnS06epgXRLCjvtDw0+hmC9kUfx972AMTP2HYiuJPuMhetM+2OFI7uWnP+d4d
 nKqczCfnhT4SnEAPM9L7mD01JL5Vo2t75f4DvsuUActO7Dz+pqkoODU7UUXyJ2uJZtEO
 T9Gq/InZZvSYMov5dFcli+LbhIw2hZ1M/qixsQwudzF7SotQRXjxI2mTsR+fZUs2At8N
 r7bOR/0uITmjddTHz37YXO/IF3mFPCM3nLTQQeSp8BtvxUOD13uacYQUil139zpTMZsq
 5l+mS2nKKQRbfCduDTno5oNDsjp8uiOsm6R+EYmz0UhdLHD4LcnA/mXFBWaNXKd6ou/5
 Bo0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=P56/aqSXvni0QoKYoULDb5A31mpfbgt7sEmpHmoEIlc=;
 b=oudlvOhCAyNRN45hAhXF5ctiJioPSIp0f4KEUnfCvbTXOxo537U91XgzLrXNfuTN/n
 zFhwZoNJztYpzXiNqTA7C5glS98ArnAkY/BOOfbWqbk78Vm4Fq7VakWtK/s/xW8j+zu5
 cdiT7Ui8Sq6rVHnjq24jWcdcY/a2/YfCVpvEe5sEadZk00p/35HhFJ6yVdReA4MMSwXL
 m6Dph8R6ZvS/+/2WaFymiUHgX9v1GucDoIggGLDYordxi0hSFqi0xMf5gOZgJVs23Vny
 3Frl6c5Kys789Pxw6BFJRdoaBtJRR5uku9uu2aeC536rX8QCI4bIaf1Iz/f7+fZavrXC
 dZEA==
X-Gm-Message-State: AOAM532r9ivW45ERZ0dN+HOHFEjyXz5Ak2lUqYHfCTNiC3kWLum69qZQ
 Miz59T5ouYE8nnkh/E+OpuEXlg==
X-Google-Smtp-Source: ABdhPJw6Tzh8S+DTfpy5e1rXdQR4qQkWA+uh3alJlY8pBN6QySeAAm7+u/vmzg0iDamD8CnzRhBhGg==
X-Received: by 2002:a92:d7d0:0:b0:2ca:33ba:8bde with SMTP id
 g16-20020a92d7d0000000b002ca33ba8bdemr11313305ilq.121.1650529181878; 
 Thu, 21 Apr 2022 01:19:41 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 q18-20020a92c012000000b002cac16f96cesm11828268ild.82.2022.04.21.01.19.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 21 Apr 2022 01:19:40 -0700 (PDT)
Date: Thu, 21 Apr 2022 08:19:37 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 02/18] KVM: arm64: Route hypercalls based on their owner
Message-ID: <YmETmWvPPQvHpQwP@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-3-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220403153911.12332-3-gshan@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Gavin,

On Sun, Apr 03, 2022 at 11:38:55PM +0800, Gavin Shan wrote:
> kvm_hvc_call_handler() directly handles the incoming hypercall, or
> and routes it based on its (function) ID. kvm_psci_call() becomes
> the gate keeper to handle the hypercall that can't be handled by
> any one else. It makes kvm_hvc_call_handler() a bit messy.
> 
> This reorgnizes the code to route the hypercall to the corresponding
> handler based on its owner.

nit: write changelogs in the imperative:

Reorganize the code to ...

> The hypercall may be handled directly
> in the handler or routed further to the corresponding functionality.
> The (function) ID is always verified before it's routed to the
> corresponding functionality. By the way, @func_id is repalced by
> @func, to be consistent with by smccc_get_function().
> 
> PSCI is the only exception, those hypercalls defined by 0.2 or
> beyond are routed to the handler for Standard Secure Service, but
> those defined in 0.1 are routed to the handler for Standard
> Hypervisor Service.
> 
> Suggested-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/hypercalls.c | 199 +++++++++++++++++++++++-------------
>  1 file changed, 127 insertions(+), 72 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 8438fd79e3f0..b659387d8919 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c

[...]

> +static int kvm_hvc_standard(struct kvm_vcpu *vcpu, u32 func)
> +{
> +	u64 val = SMCCC_RET_NOT_SUPPORTED;
> +
> +	switch (func) {
> +	case ARM_SMCCC_TRNG_VERSION ... ARM_SMCCC_TRNG_RND32:
> +	case ARM_SMCCC_TRNG_RND64:
> +		return kvm_trng_call(vcpu);
> +	case PSCI_0_2_FN_PSCI_VERSION ... PSCI_0_2_FN_SYSTEM_RESET:
> +	case PSCI_0_2_FN64_CPU_SUSPEND ... PSCI_0_2_FN64_MIGRATE_INFO_UP_CPU:
> +	case PSCI_1_0_FN_PSCI_FEATURES ... PSCI_1_0_FN_SET_SUSPEND_MODE:
> +	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
> +	case PSCI_1_1_FN_SYSTEM_RESET2:
> +	case PSCI_1_1_FN64_SYSTEM_RESET2:

Isn't it known from the SMCCC what range of hypercall numbers PSCI and
TRNG fall under, respectively?

https://developer.arm.com/documentation/den0028/e/

See sections 6.3 and 6.4.

> +		return kvm_psci_call(vcpu);
> +	}
> +
> +	smccc_set_retval(vcpu, val, 0, 0, 0);
> +	return 1;

I don't think any cases of the switch statement change val, could you
just use SMCCC_RET_NOT_SUPPORTED here?

> +}
> +
> +static int kvm_hvc_standard_hyp(struct kvm_vcpu *vcpu, u32 func)
> +{
> +	u64 val = SMCCC_RET_NOT_SUPPORTED;
> +	gpa_t gpa;
> +
> +	switch (func) {
>  	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -		val[0] = kvm_hypercall_pv_features(vcpu);
> +		val = kvm_hypercall_pv_features(vcpu);
>  		break;
>  	case ARM_SMCCC_HV_PV_TIME_ST:
>  		gpa = kvm_init_stolen_time(vcpu);
>  		if (gpa != GPA_INVALID)
> -			val[0] = gpa;
> +			val = gpa;
>  		break;
> +	case KVM_PSCI_FN_CPU_SUSPEND ... KVM_PSCI_FN_MIGRATE:
> +		return kvm_psci_call(vcpu);

You might want to handle these from the main call handler with a giant
disclaimer that these values predate SMCCC and therefore collide with
the standard hypervisor service range.

[...]

> +
> +int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> +{
> +	u32 func = smccc_get_function(vcpu);
> +	u64 val = SMCCC_RET_NOT_SUPPORTED;
> +
> +	switch (ARM_SMCCC_OWNER_NUM(func)) {
> +	case ARM_SMCCC_OWNER_ARCH:
> +		return kvm_hvc_arch(vcpu, func);
> +	case ARM_SMCCC_OWNER_STANDARD:
> +		return kvm_hvc_standard(vcpu, func);
> +	case ARM_SMCCC_OWNER_STANDARD_HYP:
> +		return kvm_hvc_standard_hyp(vcpu, func);
> +	case ARM_SMCCC_OWNER_VENDOR_HYP:
> +		return kvm_hvc_vendor_hyp(vcpu, func);
> +	}
> +
> +	smccc_set_retval(vcpu, val, 0, 0, 0);

Same here, avoid indirecting the return value through a local variable.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
