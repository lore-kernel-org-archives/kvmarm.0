Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26F8C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 12:33:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2CF7C6113E
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 12:33:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2CF7C6113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DBE24B10A;
	Wed,  8 Sep 2021 08:33:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I-CYestImt5r; Wed,  8 Sep 2021 08:33:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 592014B102;
	Wed,  8 Sep 2021 08:33:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF1894B0DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 08:33:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2IIQBhyqtiD9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 08:33:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 668584B0D6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 08:33:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631104391;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=aWw53LNgJz3aDc43XCZOPsV9FvfAENW+YZYZivjZJN4=;
 b=cKLVltDOE1OiFTOPcX1TSsRFtoz7lD7ZXx8JUq2rA/ABgHbTVI1iWyHLrmDyhtGunFEBl1
 YLMWL75qGyUHASWRUzCsYRcw7ExT0AGotvXk1Oy4mohEKq3AuMbMPTK/ZgCkIcSajQB2tZ
 1rrukpXSu/gKF7RD02TkqiC/FCTtn3U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-e7aj2-xOOLKA_tMezOnTBQ-1; Wed, 08 Sep 2021 08:33:10 -0400
X-MC-Unique: e7aj2-xOOLKA_tMezOnTBQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 bf22-20020a0564021a5600b003c86b59e291so991261edb.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 05:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=aWw53LNgJz3aDc43XCZOPsV9FvfAENW+YZYZivjZJN4=;
 b=e8Hj5azVMO3jq++HGqgHj4uUaqrcwAuQuATzGtQZogS0LxzExo4d1vUa0DkDzJqH+k
 w/XNgHxoXNZ88N9uheIzGjEE0tMxTJnJ5RH8XKefVzH+tVsHH05mx20QsXOWEQ1HCezz
 vNTfcyeGIQMmocpVdN5Sfg2ZoDaZKCBOAdj3+UONwrKTtNbDRc4H1DNmv/16RMNL6cu6
 1WbpkXMX09jGx5sHZGDid8g3oHEI/W2W9vqL3OpYM49MPTRdZ1gdU5l+no8R/edrqnBy
 8L8apGCDF48hAxbHJljdSQHGcZELCrF6p0rmWCcaKFOM1gJVqwd7LF6FPaTaWHB9/1Gz
 8FtQ==
X-Gm-Message-State: AOAM533GsFGq2V3ESxQas1jqfPYRO1H6BRXb4F/+JW/yAHLTWBytESfA
 r0OQO3AhXOIIuMBdGM1/7wEPxfgkvWNpLAQ10bi/oExp6TAgHBIoA2IrQJ2Mg9wnxuINfSueT7D
 skp17OriAs842vKzLyx8BJhTs
X-Received: by 2002:a17:906:dc43:: with SMTP id
 yz3mr3872910ejb.467.1631104389137; 
 Wed, 08 Sep 2021 05:33:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIuRzcv6t607G/tVLSQPrkOuXVPBvLzyNFDBGRHwQRCQr3jx8byLjmzZ6F+EPiIBVQ5zUG3w==
X-Received: by 2002:a17:906:dc43:: with SMTP id
 yz3mr3872889ejb.467.1631104388955; 
 Wed, 08 Sep 2021 05:33:08 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id h2sm1156061edd.43.2021.09.08.05.33.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 05:33:08 -0700 (PDT)
Date: Wed, 8 Sep 2021 14:33:06 +0200
From: Andrew Jones <drjones@redhat.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v5 1/8] KVM: arm64: Pass struct kvm to per-EC handlers
Message-ID: <20210908123306.7xthfbxz274ndxit@gator>
References: <20210827101609.2808181-1-tabba@google.com>
 <20210827101609.2808181-2-tabba@google.com>
MIME-Version: 1.0
In-Reply-To: <20210827101609.2808181-2-tabba@google.com>
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

On Fri, Aug 27, 2021 at 11:16:02AM +0100, Fuad Tabba wrote:
> We need struct kvm to check for protected VMs to be able to pick
> the right handlers for them.
> 
> Mark the handler functions inline, since some handlers will be
> called in future code from the protected VM handlers.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 16 ++++++++--------
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 0397606c0951..7cbff0ee59a5 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -163,7 +163,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
>   * If FP/SIMD is not implemented, handle the trap and inject an undefined
>   * instruction exception to the guest. Similarly for trapped SVE accesses.
>   */
> -static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	bool sve_guest, sve_host;
>  	u8 esr_ec;
> @@ -318,7 +318,7 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
>  
>  DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  
> -static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	struct kvm_cpu_context *ctxt;
>  	u64 val;
> @@ -343,7 +343,7 @@ static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return true;
>  }
>  
> -static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
>  	    handle_tx2_tvm(vcpu))
> @@ -356,7 +356,7 @@ static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
>  
> -static bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
>  	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
> @@ -365,7 +365,7 @@ static bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
>  
> -static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	if (!__populate_fault_info(vcpu))
>  		return true;
> @@ -373,7 +373,7 @@ static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
>  
> -static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static inline bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	if (!__populate_fault_info(vcpu))
>  		return true;
> @@ -403,7 +403,7 @@ static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
>  
>  typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
>  
> -static const exit_handler_fn *kvm_get_exit_handler_array(void);
> +const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm);
>  
>  /*
>   * Allow the hypervisor to handle the exit with an exit handler if it has one.
> @@ -413,7 +413,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(void);
>   */
>  static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> -	const exit_handler_fn *handlers = kvm_get_exit_handler_array();
> +	const exit_handler_fn *handlers = kvm_get_exit_handler_array(kern_hyp_va(vcpu->kvm));
>  	exit_handler_fn fn;
>  
>  	fn = handlers[kvm_vcpu_trap_get_class(vcpu)];
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index c52d580708e0..ebc0a5a4dd6a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -170,7 +170,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>  	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
>  };
>  
> -static const exit_handler_fn *kvm_get_exit_handler_array(void)
> +const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
>  {
>  	return hyp_exit_handlers;
>  }
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 0e0d342358f7..d823b089d3e9 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -108,7 +108,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>  	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
>  };
>  
> -static const exit_handler_fn *kvm_get_exit_handler_array(void)
> +const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
>  {
>  	return hyp_exit_handlers;
>  }
> -- 
> 2.33.0.259.gc128427fd7-goog
>

I have to admit my ignorance here. How do we link KVM? Are not
nvhe/switch.c and vhe/switch.c linked into the same kernel? If so,
then how does this compile after the static on
kvm_get_exit_handler_array() was removed?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
