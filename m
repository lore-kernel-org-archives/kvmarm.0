Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321FCC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 06:30:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F42061269
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 06:30:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9F42061269
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 148CF4B2DA;
	Tue,  5 Oct 2021 02:30:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3cDyB5RKOHEm; Tue,  5 Oct 2021 02:30:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECF334B2C1;
	Tue,  5 Oct 2021 02:30:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3ABD4B2BC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 02:30:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9WRqPwX4g1uW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 02:30:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBEC34B2BB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 02:30:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633415412;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=+l1gGm3H8H2kSoCX1EAZuC99ZPIAIAV2RmbV9LINdQc=;
 b=ccO6wKuIbY1rFp5jO5z+bMpyQXMB3DEl1KUbL6fGUHGLjoW6QD0+dTfbwlTmmT1xfzj2OI
 CSgin8WN7z58JjcyJB06qFr/Q+8w4gciF3G4CfcRV4AK2G8AM1G1COk408C7i/yg734AaJ
 Jh8gVjXcXjHeG4k5A3q6WkPvKbZWfDE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-fR3ex_GDMReUR5vEysSntw-1; Tue, 05 Oct 2021 02:30:08 -0400
X-MC-Unique: fR3ex_GDMReUR5vEysSntw-1
Received: by mail-ed1-f70.google.com with SMTP id
 1-20020a508741000000b003da559ba1eeso19715376edv.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 23:30:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+l1gGm3H8H2kSoCX1EAZuC99ZPIAIAV2RmbV9LINdQc=;
 b=28t8GixAUyJ3QsqgSe02DpDTU9gvaIwVP10hPXxf78vhU/iVnPs426F9fXkSdsWa61
 IcrkdZ/4k1X0M26AmTwchmZEUo3HIKMNHT5smKmAhzF52hUVH/HpHTO8zMVPD7fUQgzJ
 oEzPYjPq2FQd6iP5gFq/W4V2b8uysCNoIffnZRLgvX63HJbBfxXAXsU5cSwMEAqZRr6S
 +VkSCcotYxcTF4kAKLKCZRwSVrBAVobaST+khncg/sT9BeMLATgB4f1Qop0bB8gulOyD
 0CvpIp63Lu4OPS+JwE0S/UI3//fsDk6wqMCZIVzyiCFqvMBmP2UvMA1dq+xtz5F8wNhL
 K5fQ==
X-Gm-Message-State: AOAM5338enR8/ml6hb+pmmfaqiwfb3FJx2u0/5YBZlJ4YgzFo0J0LfBv
 1wothUD6hjuixKG3dqaFOaLcqhshjMZI/7vSJrywE/yM5ZL3IcPQrstDGvbbVrDa8mberckmc0u
 OkJYK8cFr9+2Jl57AoFmcZbDY
X-Received: by 2002:a17:907:2156:: with SMTP id
 rk22mr22868975ejb.64.1633415407676; 
 Mon, 04 Oct 2021 23:30:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyRTR0vwdSM5u3b9W2Rc9FvrTaQHxrX9AyFQUvvBAq3qZOvyJNIXpPOQxdXQmRsa2oyC7R2g==
X-Received: by 2002:a17:907:2156:: with SMTP id
 rk22mr22868953ejb.64.1633415407516; 
 Mon, 04 Oct 2021 23:30:07 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id m13sm2156277eda.41.2021.10.04.23.30.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 23:30:06 -0700 (PDT)
Date: Tue, 5 Oct 2021 08:30:04 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v8 3/8] KVM: arm64: Make a helper function to get nr of
 timer regs
Message-ID: <20211005063004.i2fwqoggglhdvtdb@gator.home>
References: <20210916181510.963449-1-oupton@google.com>
 <20210916181510.963449-4-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210916181510.963449-4-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Thu, Sep 16, 2021 at 06:15:05PM +0000, Oliver Upton wrote:
> Presently, the number of timer registers is constant. There may be
> opt-in behavior in KVM that exposes more timer registers to userspace.
> Prepare for the change by switching from a macro to a helper function to
> get the number of timer registers.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/guest.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5ce26bedf23c..a13a79f5e0e2 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -588,7 +588,10 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
>   * ARM64 versions of the TIMER registers, always available on arm64
>   */
>  
> -#define NUM_TIMER_REGS 3
> +static inline unsigned long num_timer_regs(struct kvm_vcpu *vcpu)
> +{
> +	return 3;
> +}
>  
>  static bool is_timer_reg(u64 index)
>  {
> @@ -711,7 +714,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
>  	res += num_sve_regs(vcpu);
>  	res += kvm_arm_num_sys_reg_descs(vcpu);
>  	res += kvm_arm_get_fw_num_regs(vcpu);
> -	res += NUM_TIMER_REGS;
> +	res += num_timer_regs(vcpu);
>  
>  	return res;
>  }
> @@ -743,7 +746,7 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	ret = copy_timer_indices(vcpu, uindices);
>  	if (ret < 0)
>  		return ret;
> -	uindices += NUM_TIMER_REGS;
> +	uindices += num_timer_regs(vcpu);
>  
>  	return kvm_arm_copy_sys_reg_indices(vcpu, uindices);
>  }
> -- 
> 2.33.0.309.g3052b89438-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
