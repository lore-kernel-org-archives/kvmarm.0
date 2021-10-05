Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB88C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:35:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B745613D5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:35:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3B745613D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E43234B2C4;
	Tue,  5 Oct 2021 09:35:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0DnoM5BwJYr4; Tue,  5 Oct 2021 09:35:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9C2A4B300;
	Tue,  5 Oct 2021 09:35:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 432A54B2C4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:35:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ni8fjoCEowKN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 09:35:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EBF94B24E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:35:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633440920;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=KfaTPPXNWS5AUY7/4WlVqX2CS7teeff8sBrzhkV3hmE=;
 b=MUUtykAeU8iMVrXx3Eq5r6+lHOI4GboXbmfsI68Cz9zZy+3pTWyzaFniOAevhK7UG9cEV+
 7rdr0omPcF12XsBibPMA+ssnDvJRZ/0jrhCzZDVVIBccO+Adr/UrZP7uWl62ZMrOy1Mldm
 LFxKEPjwlGIfq1MxgqMrEJoEs2gCPOo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-GaPLzsLYPWq4717AWG6zOA-1; Tue, 05 Oct 2021 09:35:19 -0400
X-MC-Unique: GaPLzsLYPWq4717AWG6zOA-1
Received: by mail-ed1-f70.google.com with SMTP id
 p20-20020a50cd94000000b003db23619472so66834edi.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 06:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KfaTPPXNWS5AUY7/4WlVqX2CS7teeff8sBrzhkV3hmE=;
 b=eEC9WEhvM6W1n3fTNvosEEJf8TMJ+YJ8l56KvbWmKnoYZbVuyQUyWJd3iqMby79XeN
 5ATfpnFx/gGPTGC7ASeJH66IxuonS3D+rpaZES/Td/Yf4u8YlkwTscFl1hTCIqVH6Zks
 JuMzcdHfFigxx2t0r23HwNnopugmW2iQ3pAh9prXNZTyvdsxON72zpXHDbDFuw+L97+C
 on4zwre8rER+gOnYI8MprMbQn66ueltox48TeuXIpzSNjHCJ98ZlBOxfcwfedZnudbeN
 3/6EhIPEkzMwVNKpf2dEOTml8S0z0OalnbLBv4P333+Z67N8GUHso/ALtr85xYRu6Ghh
 I2PQ==
X-Gm-Message-State: AOAM533PHnBBHKiSMeVHGUs9Adwj4G5DaQoeQNTI5EwdfvAtU84KLMAv
 wsRbByRGbMbap0I5ucHCryNd1zb7Askl+irijyQk004j1Zx/A4rpqCDgtPyhcqlP7wawo+f+qGi
 FKJFHkHEA4E07TM9y+5c+xOEt
X-Received: by 2002:aa7:d7d2:: with SMTP id e18mr4790229eds.126.1633440918087; 
 Tue, 05 Oct 2021 06:35:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxP127jOwYiacxXnSzlc5ipHSpvkJtRpDUiBKA4dWOl5i+2EpfWMjN92eHE+tejZxGKeqgIA==
X-Received: by 2002:aa7:d7d2:: with SMTP id e18mr4790205eds.126.1633440917888; 
 Tue, 05 Oct 2021 06:35:17 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id q23sm3690738ejr.0.2021.10.05.06.35.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 06:35:17 -0700 (PDT)
Date: Tue, 5 Oct 2021 15:35:15 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in
 a helper function
Message-ID: <20211005133515.nj6erqoct65esbb6@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-4-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210923191610.3814698-4-oupton@google.com>
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

On Thu, Sep 23, 2021 at 07:16:02PM +0000, Oliver Upton wrote:
> In its implementation of the PSCI function, KVM needs to request that a
> target vCPU resets before its next entry into the guest. Wrap the logic
> for requesting a reset in a function for later use by other implemented
> PSCI calls.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
>  1 file changed, 35 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 310b9cb2b32b..bb59b692998b 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
>  	return !(affinity & ~MPIDR_HWID_BITMASK);
>  }
>  
> -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> +					unsigned long entry_addr,
> +					unsigned long context_id,
> +					bool big_endian)
>  {
>  	struct vcpu_reset_state *reset_state;
> +
> +	lockdep_assert_held(&vcpu->kvm->lock);
> +
> +	reset_state = &vcpu->arch.reset_state;
> +	reset_state->pc = entry_addr;
> +
> +	/* Propagate caller endianness */
> +	reset_state->be = big_endian;
> +
> +	/*
> +	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
> +	 * the general purpose registers are undefined upon CPU_ON.
> +	 */
> +	reset_state->r0 = context_id;
> +
> +	WRITE_ONCE(reset_state->reset, true);
> +	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +
> +	/*
> +	 * Make sure the reset request is observed if the change to
> +	 * power_state is observed.
> +	 */
> +	smp_wmb();
> +	vcpu->arch.power_off = false;
> +}
> +
> +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> +{
>  	struct kvm *kvm = source_vcpu->kvm;
>  	struct kvm_vcpu *vcpu = NULL;
>  	unsigned long cpu_id;
> @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  			return PSCI_RET_INVALID_PARAMS;
>  	}
>  
> -	reset_state = &vcpu->arch.reset_state;
> -
> -	reset_state->pc = smccc_get_arg2(source_vcpu);
> -
> -	/* Propagate caller endianness */
> -	reset_state->be = kvm_vcpu_is_be(source_vcpu);
> -
> -	/*
> -	 * NOTE: We always update r0 (or x0) because for PSCI v0.1
> -	 * the general purpose registers are undefined upon CPU_ON.
> -	 */
> -	reset_state->r0 = smccc_get_arg3(source_vcpu);
> -
> -	WRITE_ONCE(reset_state->reset, true);
> -	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> -
> -	/*
> -	 * Make sure the reset request is observed if the change to
> -	 * power_state is observed.
> -	 */
> -	smp_wmb();
> -
> -	vcpu->arch.power_off = false;
> +	kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> +				    smccc_get_arg3(source_vcpu),
> +				    kvm_vcpu_is_be(source_vcpu));
>  	kvm_vcpu_wake_up(vcpu);
>  
>  	return PSCI_RET_SUCCESS;
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
