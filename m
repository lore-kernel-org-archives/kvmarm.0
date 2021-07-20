Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6D7C07E9B
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 14:53:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 65389613BE
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 14:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65389613BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF6D74B0F9;
	Tue, 20 Jul 2021 10:53:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HneeI8iluWf5; Tue, 20 Jul 2021 10:53:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BF024A588;
	Tue, 20 Jul 2021 10:53:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71EF04A32E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 10:53:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xuwrEApEOiXK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 10:53:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D8B64A319
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 10:53:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626792783;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=AJ3a+l7HYygfc5k+wq8ZfjE4bAmzGHq+jXXRV2Bhjoc=;
 b=GKM5ssceMpY5ORPJal14VzP2TvLVWco+TCdm9SZ7UIFMiR5Nnc9fnCtci+lcXIzioI8rRO
 oHGuFZ73g7f58vVX9tPt8kL5qLkzzCOnocjtuG4qhd9lPUsTAYKgH9IGeOPrBkOQ4MeOH8
 gscumfu12II+4L5G5o91qhqfcqrAYxQ=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-WgaTqBYtNTOeSOqIyFvZuA-1; Tue, 20 Jul 2021 10:53:01 -0400
X-MC-Unique: WgaTqBYtNTOeSOqIyFvZuA-1
Received: by mail-io1-f72.google.com with SMTP id
 v21-20020a5d90550000b0290439ea50822eso15526945ioq.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AJ3a+l7HYygfc5k+wq8ZfjE4bAmzGHq+jXXRV2Bhjoc=;
 b=GQPMFTQAwhZazgBT8GjIYzYdKr91bNZCzfCIewFQPvL2eQ6OzPgS2AGdtaUT/pnwAA
 sH1N+bEvQbe62czxA5o18+fmhPmkFz4UqY24y4bNwJGoeU74RxD+3C5xUyv0fE/DvMS3
 MEgP+MRU7Xr4VeMIgcfmjZv3pJe7rbu+pg6dja83kJKRak0zqpGa43z5uv1kdGl5lIcw
 EW2kOaf1Agk/CAMgaRXPV3WW0E/e5773pFXQ0nntzbJq1pBUEJp89fk3oKl2OCvcg2ws
 CZfoaFUDowIoAkjms8/i6oju36X4YHCJCQedf1OIHQ8a76nw+t0gKMu4NQbjnMPMrdZV
 ujAQ==
X-Gm-Message-State: AOAM531E8GLdWaVHN3Qs8YBVnb+dv+J9gO4rPKLKwF17Bd508Q61UPYH
 tVlQCEIIvaDAma54hcRjtyYIkIlfLuzQJnE1s3Pr7M0m5mzmPgunOcccFU2yrDi35V6WNBaQDA2
 dRTwtRoEJ+wCFihhcj+IyhuS/
X-Received: by 2002:a92:ab0a:: with SMTP id v10mr6070844ilh.17.1626792781079; 
 Tue, 20 Jul 2021 07:53:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytAJej/L/uU7XclEttOrrPj1uCh7eLW+Gj07JbLiTweYRkQoA4op5Sy4dx4Bzh1ky2IX4HwQ==
X-Received: by 2002:a92:ab0a:: with SMTP id v10mr6070822ilh.17.1626792780811; 
 Tue, 20 Jul 2021 07:53:00 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id g26sm10093279ioh.48.2021.07.20.07.52.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 07:53:00 -0700 (PDT)
Date: Tue, 20 Jul 2021 16:52:58 +0200
From: Andrew Jones <drjones@redhat.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
Message-ID: <20210720145258.axhqog3abdvtpqhw@gator>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-7-tabba@google.com>
MIME-Version: 1.0
In-Reply-To: <20210719160346.609914-7-tabba@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Jul 19, 2021 at 05:03:37PM +0100, Fuad Tabba wrote:
> On deactivating traps, restore the value of mdcr_el2 from the
> newly created and preserved host value vcpu context, rather than
> directly reading the hardware register.
> 
> Up until and including this patch the two values are the same,
> i.e., the hardware register and the vcpu one. A future patch will
> be changing the value of mdcr_el2 on activating traps, and this
> ensures that its value will be restored.
> 
> No functional change intended.

I'm probably missing something, but I can't convince myself that the host
will end up with the same mdcr_el2 value after deactivating traps after
this patch as before. We clearly now restore whatever we had when
activating traps (presumably whatever we configured at init_el2_state
time), but is that equivalent to what we had before with the masking and
ORing that this patch drops?

Thanks,
drew

> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  5 ++++-
>  arch/arm64/include/asm/kvm_hyp.h        |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  6 +++++-
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 11 ++---------
>  arch/arm64/kvm/hyp/vhe/switch.c         | 12 ++----------
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |  2 +-
>  6 files changed, 15 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4d2d974c1522..76462c6a91ee 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -287,10 +287,13 @@ struct kvm_vcpu_arch {
>  	/* Stage 2 paging state used by the hardware on next switch */
>  	struct kvm_s2_mmu *hw_mmu;
>  
> -	/* HYP configuration */
> +	/* Values of trap registers for the guest. */
>  	u64 hcr_el2;
>  	u64 mdcr_el2;
>  
> +	/* Values of trap registers for the host before guest entry. */
> +	u64 mdcr_el2_host;
> +
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
>  
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 9d60b3006efc..657d0c94cf82 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -95,7 +95,7 @@ void __sve_restore_state(void *sve_pffr, u32 *fpsr);
>  
>  #ifndef __KVM_NVHE_HYPERVISOR__
>  void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
> -void deactivate_traps_vhe_put(void);
> +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
>  #endif
>  
>  u64 __guest_enter(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e4a2f295a394..a0e78a6027be 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -92,11 +92,15 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  		write_sysreg(0, pmselr_el0);
>  		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
>  	}
> +
> +	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  }
>  
> -static inline void __deactivate_traps_common(void)
> +static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
>  {
> +	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
> +
>  	write_sysreg(0, hstr_el2);
>  	if (kvm_arm_support_pmu_v3())
>  		write_sysreg(0, pmuserenr_el0);
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index f7af9688c1f7..1778593a08a9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -69,12 +69,10 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  {
>  	extern char __kvm_hyp_host_vector[];
> -	u64 mdcr_el2, cptr;
> +	u64 cptr;
>  
>  	___deactivate_traps(vcpu);
>  
> -	mdcr_el2 = read_sysreg(mdcr_el2);
> -
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
>  		u64 val;
>  
> @@ -92,13 +90,8 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  		isb();
>  	}
>  
> -	__deactivate_traps_common();
> -
> -	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
> -	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
> -	mdcr_el2 |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
> +	__deactivate_traps_common(vcpu);
>  
> -	write_sysreg(mdcr_el2, mdcr_el2);
>  	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
>  
>  	cptr = CPTR_EL2_DEFAULT;
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index b3229924d243..0d0c9550fb08 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -91,17 +91,9 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
>  	__activate_traps_common(vcpu);
>  }
>  
> -void deactivate_traps_vhe_put(void)
> +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
>  {
> -	u64 mdcr_el2 = read_sysreg(mdcr_el2);
> -
> -	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
> -		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
> -		    MDCR_EL2_TPMS;
> -
> -	write_sysreg(mdcr_el2, mdcr_el2);
> -
> -	__deactivate_traps_common();
> +	__deactivate_traps_common(vcpu);
>  }
>  
>  /* Switch to the guest for VHE systems running in EL2 */
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> index 2a0b8c88d74f..007a12dd4351 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -101,7 +101,7 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
>  	struct kvm_cpu_context *host_ctxt;
>  
>  	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> -	deactivate_traps_vhe_put();
> +	deactivate_traps_vhe_put(vcpu);
>  
>  	__sysreg_save_el1_state(guest_ctxt);
>  	__sysreg_save_user_state(guest_ctxt);
> -- 
> 2.32.0.402.g57bb445576-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
