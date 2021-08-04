Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6DAC4338F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 10:25:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 26C1961002
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 10:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 26C1961002
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7874A500;
	Wed,  4 Aug 2021 06:25:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ufziYT5qgb2B; Wed,  4 Aug 2021 06:25:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 549914A4E5;
	Wed,  4 Aug 2021 06:25:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6A3C4A4E5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 06:25:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W35zRs1wNS-G for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 06:25:44 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1C204A4A4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 06:25:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628072744;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/dh0XveA2tRdR86ekoEcjKfOMTNwMf1qc/oepL3g3Eo=;
 b=JdI1aph3UrxICv1LwegqGsJ1nfBdlZyDn2N5fQdCDKnJ7FuTB3nk7mBV3o10HcQKl53cwd
 +AvoGx+BBHTueKm04oXJeHxyvnx2sE75Q6UdAFJIvQq0+bg2n8tZkoO20F7en6iYm6OCAP
 KVbdTNlNTq1hdo/eAmC3Atu0IHtdT4w=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-_22EW2iNPIi4mTFK84ZD6A-1; Wed, 04 Aug 2021 06:25:43 -0400
X-MC-Unique: _22EW2iNPIi4mTFK84ZD6A-1
Received: by mail-ed1-f70.google.com with SMTP id
 u25-20020aa7d8990000b02903bb6a903d90so1213293edq.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 03:25:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/dh0XveA2tRdR86ekoEcjKfOMTNwMf1qc/oepL3g3Eo=;
 b=V/jVZNPYgQPQOJI/Slt3Y2rxI2Xk5qQhAVkA++bxeKhtmBD1x2t5q7M52eICa+zf6L
 YoZ+WDcfaAz9yXsNH4bvAu2YpkCzAPX30zpQe73wQZuY0sEwTR5CnH+OFTbMPNqSw3Yi
 LtniIH3gk1tdomSPO4Z/xOh/TAT/GR9qGSyEq3EWz3Ut6Ik9RcAeHACo9/jZg2na0pUR
 6FHIKCNmemGayhsNqN6UG09RqB0SZRHwXqpxiC5T2h8zRpD0IsdfrG6lIrTq2MfkO1vW
 RCmXc+ZxK2JKEc1vCqimErEJn8hXCg6ukqo0HWUfpN6D+fFsa5Zrb5KxBxz3uBzud/1S
 3GBQ==
X-Gm-Message-State: AOAM533MgzXBTAP37OqW5sPnsLNwtheeRa6XTkYBwQkMXLGa/OPRPK0e
 1JlYSEviZYlNTsPE3Tbtf9jolrU5tkBMhcJXmai9gUFO52T6frrT2UY+nVB/G6N1umLgM2zANrB
 XdbEluzgbkEViHoYaX/pn3Tys
X-Received: by 2002:a50:8d8c:: with SMTP id r12mr31140628edh.99.1628072742271; 
 Wed, 04 Aug 2021 03:25:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhWkWNUQ6HtRYDgaJL2+7vGqrK616hPjU3P+qoXMZQXZlcYgAGMb+FE/+6EFllwfEXAiURHQ==
X-Received: by 2002:a50:8d8c:: with SMTP id r12mr31140602edh.99.1628072742037; 
 Wed, 04 Aug 2021 03:25:42 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id q11sm550145ejb.10.2021.08.04.03.25.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 Aug 2021 03:25:41 -0700 (PDT)
Date: Wed, 4 Aug 2021 12:25:39 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v6 18/21] KVM: arm64: Configure timer traps in
 vcpu_load() for VHE
Message-ID: <20210804102539.yczeevsaqlhptgib@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-19-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210804085819.846610-19-oupton@google.com>
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

On Wed, Aug 04, 2021 at 08:58:16AM +0000, Oliver Upton wrote:
> In preparation for emulated physical counter-timer offsetting, configure
> traps on every vcpu_load() for VHE systems. As before, these trap
> settings do not affect host userspace, and are only active for the
> guest.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/arch_timer.c  | 10 +++++++---
>  arch/arm64/kvm/arm.c         |  4 +---
>  include/kvm/arm_arch_timer.h |  2 --
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index f15058612994..9ead94aa867d 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -51,6 +51,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
>  static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
>  			      struct arch_timer_context *timer,
>  			      enum kvm_arch_timer_regs treg);
> +static void kvm_timer_enable_traps_vhe(void);
>  
>  u32 timer_get_ctl(struct arch_timer_context *ctxt)
>  {
> @@ -668,6 +669,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>  
>  	if (map.emul_ptimer)
>  		timer_emulate(map.emul_ptimer);
> +
> +	if (has_vhe())
> +		kvm_timer_enable_traps_vhe();
>  }
>  
>  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
> @@ -1383,12 +1387,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  }
>  
>  /*
> - * On VHE system, we only need to configure the EL2 timer trap register once,
> - * not for every world switch.
> + * On VHE system, we only need to configure the EL2 timer trap register on
> + * vcpu_load(), but not every world switch into the guest.
>   * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
>   * and this makes those bits have no effect for the host kernel execution.
>   */
> -void kvm_timer_init_vhe(void)
> +static void kvm_timer_enable_traps_vhe(void)
>  {
>  	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
>  	u32 cnthctl_shift = 10;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..47ea1e1ba80b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1558,9 +1558,7 @@ static void cpu_hyp_reinit(void)
>  
>  	cpu_hyp_reset();
>  
> -	if (is_kernel_in_hyp_mode())
> -		kvm_timer_init_vhe();
> -	else
> +	if (!is_kernel_in_hyp_mode())
>  		cpu_init_hyp_mode();
>  
>  	cpu_set_hyp_vector();
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 615f9314f6a5..254653b42da0 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -87,8 +87,6 @@ u64 kvm_phys_timer_read(void);
>  void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
>  
> -void kvm_timer_init_vhe(void);
> -
>  bool kvm_arch_timer_get_input_level(int vintid);
>  
>  #define vcpu_timer(v)	(&(v)->arch.timer_cpu)
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
