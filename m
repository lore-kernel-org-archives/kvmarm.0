Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65037C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 10:19:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB2E460FC4
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 10:19:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CB2E460FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4026740667;
	Wed,  4 Aug 2021 06:19:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7dxBUGa6Ynpa; Wed,  4 Aug 2021 06:19:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17E5A49FB7;
	Wed,  4 Aug 2021 06:19:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE70640FC7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 06:19:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mcQTwHcVx1Yo for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 06:19:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCE5D40667
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 06:19:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628072348;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=JpNym3PhHBiG2R7OBr9EbOywreJxnv7DJQK3hgv/PcA=;
 b=Qy8nHwoPvzjqk0HrVIjnThJsp9Et/zd5Gua8uVq7EJFYe4ip6HAFG/tRUAYbvFfSQ4V2Tq
 Rs9qBWepMnP/qAd7mv+xGxt18GyXtfyVrKVIEiprwh6z8lU6Ar4f6VEgN44gvLLUHLdRdF
 nnxlYOgDQtslbnglZVdqvMBnrLIuYEQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-ZgZ7sCYzNjOFKSbyYNnB6w-1; Wed, 04 Aug 2021 06:19:07 -0400
X-MC-Unique: ZgZ7sCYzNjOFKSbyYNnB6w-1
Received: by mail-ej1-f72.google.com with SMTP id
 k22-20020a1709061596b02905a370b2f477so657887ejd.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 03:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JpNym3PhHBiG2R7OBr9EbOywreJxnv7DJQK3hgv/PcA=;
 b=Mu1jntzw/YdvQZTWTJVGLKM8ktwPAvAzxdhSW6dnDvq0U8ax4NNzMXYMLKNl0Pfhv2
 MZsPyFlODqF7xUXyqleajSp35SHowB2/x/ShHIROvZG6/m7zIPRk9ZrXCcfYzCYaKtRC
 MRat1jdSIfQMGmaslEcl9WBEMT6lmkDipMCUfE6DSy9b2fgYFi0zNfPrAvfg974W/2jg
 CGRyWm9C0DtTpiO+wEXVqFEK+ZC7WXWlyLiYg9Eq0onDZgIRLG1uNrt2MHxEWRJZvC9k
 R6e3z/yNUrl5j1Ur92ec7uojOfMX2TPRyPKkk6tCKQ+hycHa0kGdoYaY8Xq4ku+SSq7w
 Lw3g==
X-Gm-Message-State: AOAM530mjGgEerZvIkOiKCEnStDnq4zNcgEQIBsvQncRTcYhoI2mOMP2
 O81wwYWVYM96Fw85MTlJpbnze70TJyP6fQUPKPaNnaaQLFgUNrnAjU3tbDn6VpGRdsFsxGK6DVG
 Dx2eEpYW1wIdFEAaJTZL746iS
X-Received: by 2002:a05:6402:22b0:: with SMTP id
 cx16mr31181364edb.185.1628072346379; 
 Wed, 04 Aug 2021 03:19:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynmhEZkIMhWx+PRVqGR61bwf7cgXKe96j5baJK90yrMt+GBIqVMmzYMWmFgf1rT3lH7xIO0w==
X-Received: by 2002:a05:6402:22b0:: with SMTP id
 cx16mr31181329edb.185.1628072346086; 
 Wed, 04 Aug 2021 03:19:06 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id r27sm762827edb.66.2021.08.04.03.19.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 Aug 2021 03:19:05 -0700 (PDT)
Date: Wed, 4 Aug 2021 12:19:03 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v6 12/21] KVM: arm64: Separate guest/host counter offset
 values
Message-ID: <20210804101903.3grfwrv5mlm5sydd@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-13-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210804085819.846610-13-oupton@google.com>
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

On Wed, Aug 04, 2021 at 08:58:10AM +0000, Oliver Upton wrote:
> In some instances, a VMM may want to update the guest's counter-timer
> offset in a transparent manner, meaning that changes to the hardware
> value do not affect the synthetic register presented to the guest or the
> VMM through said guest's architectural state. Lay the groundwork to
> separate guest offset register writes from the hardware values utilized
> by KVM.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/arch_timer.c  | 48 ++++++++++++++++++++++++++++++++----
>  include/kvm/arm_arch_timer.h |  3 +++
>  2 files changed, 46 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index c0101db75ad4..4c2b763a8849 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -87,6 +87,18 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
>  	struct kvm_vcpu *vcpu = ctxt->vcpu;
>  
>  	switch(arch_timer_ctx_index(ctxt)) {
> +	case TIMER_VTIMER:
> +		return ctxt->host_offset;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static u64 timer_get_guest_offset(struct arch_timer_context *ctxt)
> +{
> +	struct kvm_vcpu *vcpu = ctxt->vcpu;
> +
> +	switch (arch_timer_ctx_index(ctxt)) {
>  	case TIMER_VTIMER:
>  		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
>  	default:
> @@ -132,13 +144,31 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  
>  	switch(arch_timer_ctx_index(ctxt)) {
>  	case TIMER_VTIMER:
> -		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> +		ctxt->host_offset = offset;
>  		break;
>  	default:
>  		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
>  	}
>  }
>  
> +static void timer_set_guest_offset(struct arch_timer_context *ctxt, u64 offset)
> +{
> +	struct kvm_vcpu *vcpu = ctxt->vcpu;
> +
> +	switch (arch_timer_ctx_index(ctxt)) {
> +	case TIMER_VTIMER: {
> +		u64 host_offset = timer_get_offset(ctxt);
> +
> +		host_offset += offset - __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> +		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> +		timer_set_offset(ctxt, host_offset);
> +		break;
> +	}
> +	default:
> +		WARN_ONCE(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
> +	}
> +}
> +
>  u64 kvm_phys_timer_read(void)
>  {
>  	return timecounter->cc->read(timecounter->cc);
> @@ -749,7 +779,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>  
>  /* Make offset updates for all timer contexts atomic */
>  static void update_timer_offset(struct kvm_vcpu *vcpu,
> -				enum kvm_arch_timers timer, u64 offset)
> +				enum kvm_arch_timers timer, u64 offset,
> +				bool guest_visible)
>  {
>  	int i;
>  	struct kvm *kvm = vcpu->kvm;
> @@ -758,13 +789,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
>  	lockdep_assert_held(&kvm->lock);
>  
>  	kvm_for_each_vcpu(i, tmp, kvm)
> -		timer_set_offset(vcpu_get_timer(tmp, timer), offset);
> +		if (guest_visible)
> +			timer_set_guest_offset(vcpu_get_timer(tmp, timer),
> +					       offset);
> +		else
> +			timer_set_offset(vcpu_get_timer(tmp, timer), offset);
>  
>  	/*
>  	 * When called from the vcpu create path, the CPU being created is not
>  	 * included in the loop above, so we just set it here as well.
>  	 */
> -	timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
> +	if (guest_visible)
> +		timer_set_guest_offset(vcpu_get_timer(vcpu, timer), offset);
> +	else
> +		timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
>  }
>  
>  static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
> @@ -772,7 +810,7 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
>  	struct kvm *kvm = vcpu->kvm;
>  
>  	mutex_lock(&kvm->lock);
> -	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
> +	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff, true);
>  	mutex_unlock(&kvm->lock);
>  }
>  
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 51c19381108c..9d65d4a29f81 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -42,6 +42,9 @@ struct arch_timer_context {
>  	/* Duplicated state from arch_timer.c for convenience */
>  	u32				host_timer_irq;
>  	u32				host_timer_irq_flags;
> +
> +	/* offset relative to the host's physical counter-timer */
> +	u64				host_offset;
>  };
>  
>  struct timer_map {
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
