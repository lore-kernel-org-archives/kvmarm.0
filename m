Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE08C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:22:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B81B061502
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:22:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B81B061502
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30CEA4B300;
	Tue,  5 Oct 2021 09:22:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KgVMe4974qhH; Tue,  5 Oct 2021 09:22:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 345034B2F5;
	Tue,  5 Oct 2021 09:22:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B0654B2F2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:22:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e32HOBZ1zgUG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 09:22:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D9964B2B3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:22:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633440139;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=WIETha6aSNqE3UiAS7WZd4oRBcDL4c/PhFnZrRoUf/o=;
 b=gKlrp5f3oesfEK7cYA4FzMGOYT5RwGSKtUgfRpptAwsKIad6teMEK9pjpZ6uR/SOg8g4rg
 XL72c1zIvm5M/rNWzWrxCClrpqSBNMyaiLXxxrzx5IbIZFQMUgC+lvuB1c1VE+A3jxGkw2
 hkJrpsQJysQDJxQuZlHecPzrAv5icOY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-sQYZZSSIM8q7cNDcl0qLWQ-1; Tue, 05 Oct 2021 09:22:18 -0400
X-MC-Unique: sQYZZSSIM8q7cNDcl0qLWQ-1
Received: by mail-ed1-f69.google.com with SMTP id
 14-20020a508e4e000000b003d84544f33eso20647231edx.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 06:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=WIETha6aSNqE3UiAS7WZd4oRBcDL4c/PhFnZrRoUf/o=;
 b=ykvMz/uuvcBlYu9vWQc7LB3K7kmwTDMPwJ7v25DiUO2tqkpbAsrrUetXArnFIj5JoE
 7OZg8AF3xwE6PYdcqGYL5Nm75aPZ1E3TJSe6I+UAUbxH6MIGVQ0dJiF4b1ewC4LuCZy/
 pqpvBRMm08XT+nsf05J87h840HMi7wuOUYEQGdgMv9nUrdYJDL/U2zJWbZsDwzyx1yZh
 8AJ//syiVRHm3yRppLaXjw+EF2/2w2+5HcOKbumMMEraSrKv37k/9ib7yoJGdX47oqyN
 +y9KL2atA1NfpFN71VROZ0NtXNqPl2J/mpGWhM6dtZCRzGeED1bBYX234+mZZvX+SFOV
 OhiA==
X-Gm-Message-State: AOAM531BuXmL20Ht3A8jpG0iQ1i2cKFGFIfrmT7qnnT/Y8Mkv2fsxAif
 F7e1ZbC1jKNBkv5oqbeK6Bswz/UuBjHSG+/VYrcEboqCmv1eyzgcN4lki7Ob10jvDXf/uHX6vTX
 +6jiZnxDNNddFjIV5AMscS6ir
X-Received: by 2002:a05:6402:12c2:: with SMTP id
 k2mr40368edx.210.1633440136929; 
 Tue, 05 Oct 2021 06:22:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9pp/WOSkii/F5wDdwkrNtVlDY449U7XBNE0reOoicJr6VkeCprvTth5Y6zAJqwdtuYOl5lA==
X-Received: by 2002:a05:6402:12c2:: with SMTP id
 k2mr40335edx.210.1633440136723; 
 Tue, 05 Oct 2021 06:22:16 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id t14sm7807111ejf.24.2021.10.05.06.22.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 06:22:16 -0700 (PDT)
Date: Tue, 5 Oct 2021 15:22:14 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 01/11] KVM: arm64: Drop unused vcpu param to
 kvm_psci_valid_affinity()
Message-ID: <20211005132214.vcnvg7ckl6wpu3lq@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-2-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210923191610.3814698-2-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 23, 2021 at 07:16:00PM +0000, Oliver Upton wrote:
> The helper function does not need a pointer to the vCPU, as it only
> consults a constant mask; drop the unused vcpu parameter.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/psci.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 74c47d420253..d46842f45b0a 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -59,8 +59,7 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
>  	kvm_vcpu_kick(vcpu);
>  }
>  
> -static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
> -					   unsigned long affinity)
> +static inline bool kvm_psci_valid_affinity(unsigned long affinity)
>  {
>  	return !(affinity & ~MPIDR_HWID_BITMASK);
>  }
> @@ -73,7 +72,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  	unsigned long cpu_id;
>  
>  	cpu_id = smccc_get_arg1(source_vcpu);
> -	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
> +	if (!kvm_psci_valid_affinity(cpu_id))
>  		return PSCI_RET_INVALID_PARAMS;
>  
>  	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
> @@ -132,7 +131,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>  	target_affinity = smccc_get_arg1(vcpu);
>  	lowest_affinity_level = smccc_get_arg2(vcpu);
>  
> -	if (!kvm_psci_valid_affinity(vcpu, target_affinity))
> +	if (!kvm_psci_valid_affinity(target_affinity))
>  		return PSCI_RET_INVALID_PARAMS;
>  
>  	/* Determine target affinity mask */
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
