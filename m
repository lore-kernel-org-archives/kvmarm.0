Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89267C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 09:09:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0793120679
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 09:09:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="u5WnUGXs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0793120679
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 706254A523;
	Mon, 15 Jun 2020 05:09:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4HP6F+1bKluS; Mon, 15 Jun 2020 05:09:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03CDD4B0BC;
	Mon, 15 Jun 2020 05:09:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 281434A51D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 05:09:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3h8wjE7mnpl7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 05:09:41 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59B3B4A4A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 05:09:41 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id r15so14003191wmh.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 02:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kBWHSnavnojggz6uvJr4ssNYwt9EO3XZXmWi0mLaVfo=;
 b=u5WnUGXso1CB5GxvVY5/j8SU9R6DyWFLnNXkqLW/yca23ej9LHGG9t327osTw7hV6c
 otK2j+87vksb+pxAnQaE3otq6MTONULdqSOIwMauTjgFICXMGSu3Op4aJ4lOuT+6LJMr
 Z9YA09iSVvv1mUuCTCnu8OICojUAQHjlqjkevFZlNOGr4krWeO0z4IFTZRpfScryQwo3
 T3FYYsNdi1/BurX6pBUs9ch+JI+OUYm5L76j4lj5vjueB3DqOShrhp3KB3VeARns7BTr
 YAbOVynWkOenw/7UXgg2PExrlbTHPj+8+hPpIPFVZdqIPCMc+CG2LAQCeN8d73G9mEB6
 1NPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kBWHSnavnojggz6uvJr4ssNYwt9EO3XZXmWi0mLaVfo=;
 b=LxdM8mrQOvC6cuE4TeTWcpo5pQTHaZHWX27hVKzKRQeM6b32XszwPs5gYLkY9XICh9
 GAo3X5+dzEMdL81SsjD0nd4DnJspjafOsK6b8fhH/tzFRdkn4Qn9lbElGPYx3S1s/rzW
 7GadvvhG8YccehzOTHuRur01GXOncSMexJFghVis6MeBruko+8WWWhuEemNJyjMmNQs1
 TOu81+reeoMbiZWBtKtZM9RBgqoikPjPiNLEu2e6mHNI/S28K+yezl3LDX3tu+HDn50V
 mowByA56VtzvleQtJl+2fZLbNim05WiltXAAnSwi7T21X+EwzSm6GbJOQ9xaniSt2bUr
 kawQ==
X-Gm-Message-State: AOAM533QGrrl/kDWj2Moa99ym2bfPyhyoR4eRZrjZaH4kS0nlM0uH7l6
 aWt9AUlG10hp/emkSw+pdMwN5w==
X-Google-Smtp-Source: ABdhPJxWx8VU501epgibxbnVhiRJ1svQndBXVYgotpBnvYqxiAcvxjK5SEZuaVtNXVlxltfUJaKCZg==
X-Received: by 2002:a7b:cb18:: with SMTP id u24mr2040292wmj.67.1592212180116; 
 Mon, 15 Jun 2020 02:09:40 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id j5sm24100579wrq.39.2020.06.15.02.09.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 15 Jun 2020 02:09:39 -0700 (PDT)
Date: Mon, 15 Jun 2020 10:09:35 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/4] KVM: arm64: Allow PtrAuth to be enabled from
 userspace on non-VHE systems
Message-ID: <20200615090935.GF177680@google.com>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-4-maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jun 15, 2020 at 09:19:53AM +0100, Marc Zyngier wrote:
> Now that the scene is set for enabling PtrAuth on non-VHE, drop
> the restrictions preventing userspace from enabling it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/reset.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index d3b209023727..2a929789fe2e 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -42,6 +42,11 @@ static u32 kvm_ipa_limit;
>  #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
>  				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
>  
> +static bool system_has_full_ptr_auth(void)
> +{
> +	return system_supports_address_auth() && system_supports_generic_auth();
> +}
> +
>  /**
>   * kvm_arch_vm_ioctl_check_extension
>   *
> @@ -80,8 +85,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		break;
>  	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>  	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> -		r = has_vhe() && system_supports_address_auth() &&
> -				 system_supports_generic_auth();
> +		r = system_has_full_ptr_auth();
>  		break;
>  	default:
>  		r = 0;
> @@ -205,19 +209,14 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>  
>  static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>  {
> -	/* Support ptrauth only if the system supports these capabilities. */
> -	if (!has_vhe())
> -		return -EINVAL;
> -
> -	if (!system_supports_address_auth() ||
> -	    !system_supports_generic_auth())
> -		return -EINVAL;
>  	/*
>  	 * For now make sure that both address/generic pointer authentication
> -	 * features are requested by the userspace together.
> +	 * features are requested by the userspace together and the system
> +	 * supports these capabilities.
>  	 */
>  	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
> -	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
> +	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
> +	    !system_has_full_ptr_auth())
>  		return -EINVAL;
>  
>  	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;

That was easy. Let EL2 use ptrauth and it can save and restore the
guest's state and done.

Acked-by: Andrew Scull <ascull@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
