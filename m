Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0554DC4338F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 10:20:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56E9060FC3
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 10:20:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 56E9060FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D258D4A003;
	Wed,  4 Aug 2021 06:20:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dNGLHqQTOLza; Wed,  4 Aug 2021 06:20:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62F3F4A195;
	Wed,  4 Aug 2021 06:20:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 635CA49FA6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 06:20:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NYvLX2qOWuOG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 06:20:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A03240FC7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 06:20:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628072415;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=TzuddHkqTHaeNbxF+wgJby3k6T0ZjRGzb/st0YjSDro=;
 b=f2E3MlHdXnsphAvhfHhbLwmwP14YJkOfdq2TcSYdMj+pmh5wyPj3MX9QHKRsJCjEiPp7xS
 Lf/3uos83ONrujd2Fq80liDYZtz2WZiZ7MObEHnMrTBPZLwyliE5pxTZ3ETyfLP6B4AD02
 7oC8fJYvGUsjbajuezD63+6kcjaGGyg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-6OxH6AQRPkqWnBeJit5Hxg-1; Wed, 04 Aug 2021 06:20:14 -0400
X-MC-Unique: 6OxH6AQRPkqWnBeJit5Hxg-1
Received: by mail-ed1-f71.google.com with SMTP id
 n24-20020aa7c7980000b02903bb4e1d45aaso1204457eds.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 03:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TzuddHkqTHaeNbxF+wgJby3k6T0ZjRGzb/st0YjSDro=;
 b=NwVRdFzCBnNcxvwqswNSPE2C/+ibjrzqaC9qPsY4EtjfEh84XkubAmOMEZqefFw4D6
 xAjjwgdCqkkrBzNX9t326/pu0fENe1cZSr1x0Sd6LiRPzsrjGhtVniqjMR+sSFm+fuws
 NUmi9sRTBQSIh2VIIt6k0YKX7VYImDH47nofwn/p5hqiXnUot4cBssdafeEcVyYbpIoi
 yogBVpA4Mk5Fusi2gUmz0NlsMKsbyRBfIxyoNGLINTqYN5AOSiwe4acRODrU2ELVxbgg
 Oeq60EO7/s+4wYkwoN8+kp+N7iBFxR3IlmPqwMWG321pA2CCc66A+eQP7uYHxGToZZvi
 KY+w==
X-Gm-Message-State: AOAM531IZM9clKQ3eRZyI+0kFFEf69QRN2t4/KyDbbV8gfix04bysQWu
 0MO0Tc4BD7gpja2HmvESW02/CVaL7KX/ONbe02gwogBr+6nAM5SM7g7TI3MN5wWTNeFIJn+C6z3
 nzJ7FlAdQS0mLOKFT40KTyKGe
X-Received: by 2002:a17:907:20b4:: with SMTP id
 pw20mr25671617ejb.223.1628072413657; 
 Wed, 04 Aug 2021 03:20:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybp6Q5XxRbGB4tUMy1zZgwfQUbAhHrD8DGApU6sxGqruuw3bd9FVaZMCtp9rMFmgSs9yfqVg==
X-Received: by 2002:a17:907:20b4:: with SMTP id
 pw20mr25671582ejb.223.1628072413361; 
 Wed, 04 Aug 2021 03:20:13 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id n13sm536160ejk.97.2021.08.04.03.20.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 Aug 2021 03:20:13 -0700 (PDT)
Date: Wed, 4 Aug 2021 12:20:10 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v6 13/21] KVM: arm64: Allow userspace to configure a
 vCPU's virtual offset
Message-ID: <20210804102010.poou6o354rink6e4@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-14-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210804085819.846610-14-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
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

On Wed, Aug 04, 2021 at 08:58:11AM +0000, Oliver Upton wrote:
> Allow userspace to access the guest's virtual counter-timer offset
> through the ONE_REG interface. The value read or written is defined to
> be an offset from the guest's physical counter-timer. Add some
> documentation to clarify how a VMM should use this and the existing
> CNTVCT_EL0.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/api.rst    | 10 ++++++++++
>  arch/arm64/include/uapi/asm/kvm.h |  1 +
>  arch/arm64/kvm/arch_timer.c       | 11 +++++++++++
>  arch/arm64/kvm/guest.c            |  6 +++++-
>  include/kvm/arm_arch_timer.h      |  1 +
>  5 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 8d4a3471ad9e..28a65dc89985 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2487,6 +2487,16 @@ arm64 system registers have the following id bit patterns::
>       derived from the register encoding for CNTV_CVAL_EL0.  As this is
>       API, it must remain this way.
>  
> +.. warning::
> +
> +     The value of KVM_REG_ARM_TIMER_OFFSET is defined as an offset from
> +     the guest's view of the physical counter-timer.
> +
> +     Userspace should use either KVM_REG_ARM_TIMER_OFFSET or
> +     KVM_REG_ARM_TIMER_CVAL to pause and resume a guest's virtual
> +     counter-timer. Mixed use of these registers could result in an
> +     unpredictable guest counter value.
> +
>  arm64 firmware pseudo-registers have the following bit pattern::
>  
>    0x6030 0000 0014 <regno:16>
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..949a31bc10f0 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -255,6 +255,7 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
>  #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
>  #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
> +#define KVM_REG_ARM_TIMER_OFFSET	ARM64_SYS_REG(3, 4, 14, 0, 3)
>  
>  /* KVM-as-firmware specific pseudo-registers */
>  #define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 4c2b763a8849..a8815b09da3e 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -868,6 +868,10 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
>  		timer = vcpu_vtimer(vcpu);
>  		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
>  		break;
> +	case KVM_REG_ARM_TIMER_OFFSET:
> +		timer = vcpu_vtimer(vcpu);
> +		update_vtimer_cntvoff(vcpu, value);
> +		break;
>  	case KVM_REG_ARM_PTIMER_CTL:
>  		timer = vcpu_ptimer(vcpu);
>  		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
> @@ -912,6 +916,9 @@ u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
>  	case KVM_REG_ARM_TIMER_CVAL:
>  		return kvm_arm_timer_read(vcpu,
>  					  vcpu_vtimer(vcpu), TIMER_REG_CVAL);
> +	case KVM_REG_ARM_TIMER_OFFSET:
> +		return kvm_arm_timer_read(vcpu,
> +					  vcpu_vtimer(vcpu), TIMER_REG_OFFSET);
>  	case KVM_REG_ARM_PTIMER_CTL:
>  		return kvm_arm_timer_read(vcpu,
>  					  vcpu_ptimer(vcpu), TIMER_REG_CTL);
> @@ -949,6 +956,10 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
>  		val = kvm_phys_timer_read() - timer_get_offset(timer);
>  		break;
>  
> +	case TIMER_REG_OFFSET:
> +		val = timer_get_offset(timer);
> +		break;
> +
>  	default:
>  		BUG();
>  	}
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 1dfb83578277..17fc06e2b422 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -591,7 +591,7 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
>   * ARM64 versions of the TIMER registers, always available on arm64
>   */
>  
> -#define NUM_TIMER_REGS 3
> +#define NUM_TIMER_REGS 4
>  
>  static bool is_timer_reg(u64 index)
>  {
> @@ -599,6 +599,7 @@ static bool is_timer_reg(u64 index)
>  	case KVM_REG_ARM_TIMER_CTL:
>  	case KVM_REG_ARM_TIMER_CNT:
>  	case KVM_REG_ARM_TIMER_CVAL:
> +	case KVM_REG_ARM_TIMER_OFFSET:
>  		return true;
>  	}
>  	return false;
> @@ -614,6 +615,9 @@ static int copy_timer_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	uindices++;
>  	if (put_user(KVM_REG_ARM_TIMER_CVAL, uindices))
>  		return -EFAULT;
> +	uindices++;
> +	if (put_user(KVM_REG_ARM_TIMER_OFFSET, uindices))
> +		return -EFAULT;
>  
>  	return 0;
>  }
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 9d65d4a29f81..615f9314f6a5 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -21,6 +21,7 @@ enum kvm_arch_timer_regs {
>  	TIMER_REG_CVAL,
>  	TIMER_REG_TVAL,
>  	TIMER_REG_CTL,
> +	TIMER_REG_OFFSET,
>  };
>  
>  struct arch_timer_context {
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
