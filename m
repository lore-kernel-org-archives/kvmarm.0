Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B641C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C58706137E
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C58706137E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 707D64B0D9;
	Wed, 29 Sep 2021 03:12:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I-qky1r-gZXI; Wed, 29 Sep 2021 03:12:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 960A54B14C;
	Wed, 29 Sep 2021 03:12:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2925D407ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 17:59:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kDPH+guQQJr9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 17:59:35 -0400 (EDT)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03A3F40413
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 17:59:34 -0400 (EDT)
Received: by mail-pg1-f177.google.com with SMTP id y186so571547pgd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hR85GCZfhL4YJawbBftoxChN3cnahiYUmelBrtysYzQ=;
 b=d0JUHehyLXdFA5B/wgcgOjwuw3aZVkCR3Gk+OriLfpCmsGGgRbZi5+6+5dzXaHm/Rk
 H3TiGrTERzN09CS95iDAWiZDAmZQ7WtptNJXypeXDWyysDPrB9RadntKAmDj8faRpKjd
 fMchWKVs2KViwzp7iD2lGulOLLVhw7YhvFLNSrL+7iYLmoBrEXEPXy3mdg2HCz/DUqRI
 DfUngAkqbFuin6e/uZEVEtmEQ9sA6tW5M9iMir9UF/2O+6uyZKAnHgdD6XMtiWjc3kEe
 tZ6voUkCgJodnBe8T1C1vXvGgmHGQNNecVIO2odLcNPxegnl1sNnabyit3FrxNWbwdpX
 e9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hR85GCZfhL4YJawbBftoxChN3cnahiYUmelBrtysYzQ=;
 b=GFpAANJrHDRMoaT2CyvFqsIPO2AkISbGz9AkxBAVMbQX0JcrdscrkgvwUFreTphHzt
 XMRAVXPPmfHHLKjkqm7wEtmCjzm1yv2TiBeaLY1KedWPRPNay62AOLBx61vnNfhibGnE
 xBdZhlNFIdpmS9p4c2yx15YfpiIKICZkxB4mKsB/4Vu5gkvXPZ57du5tAFsZlST46yM/
 j9EhMKFnB44sSBlzEXeKNjsrBeOS5FzUyz33oKIe0KYdYPOq7QDSeX7vY9XO9CNQuvT0
 NCSH0rUKBuLsAK/6RSj7V61HQPi8QIHoDZfmoUd6mdiPODcf6h3c5lHea41S8IKdXGQ7
 OANg==
X-Gm-Message-State: AOAM530SmWrCif0+DqnBp3DI8K0KFl5kjIo/D4ZKhjPOW3Vv6ywfb1f6
 MGn4lvtAs3e/AiqE3T8D8ZKO5Q==
X-Google-Smtp-Source: ABdhPJywxfOyjT/Bbb3z07Sb4ifGRgqWGAJFb2yLMs8NKV2zXEevYh6BB5SfG6ECW1CSnDRZbY3y1w==
X-Received: by 2002:a63:50b:: with SMTP id 11mr5654394pgf.308.1632866373808;
 Tue, 28 Sep 2021 14:59:33 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254])
 by smtp.gmail.com with ESMTPSA id z14sm83969pjq.48.2021.09.28.14.59.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 14:59:32 -0700 (PDT)
Date: Tue, 28 Sep 2021 21:59:29 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 08/14] KVM: x86: Tweak halt emulation helper names to
 free up kvm_vcpu_halt()
Message-ID: <YVOQQfgNDO3L0RsS@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-9-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-9-seanjc@google.com>
X-Mailman-Approved-At: Wed, 29 Sep 2021 03:12:40 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Sep 24, 2021 at 05:55:22PM -0700, Sean Christopherson wrote:
> Rename a variety of HLT-related helpers to free up the function name
> "kvm_vcpu_halt" for future use in generic KVM code, e.g. to differentiate
> between "block" and "halt".
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/vmx/nested.c       |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  4 ++--
>  arch/x86/kvm/x86.c              | 13 +++++++------
>  4 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4e8c21083bdb..cfebef10b89c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1679,7 +1679,7 @@ int kvm_emulate_monitor(struct kvm_vcpu *vcpu);
>  int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
>  int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
>  int kvm_emulate_halt(struct kvm_vcpu *vcpu);
> -int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
> +int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu);
>  int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
>  int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index eedcebf58004..f689e463b678 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3618,7 +3618,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  		    !(nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING) &&
>  		      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
>  			vmx->nested.nested_run_pending = 0;
> -			return kvm_vcpu_halt(vcpu);
> +			return kvm_emulate_halt_noskip(vcpu);
>  		}
>  		break;
>  	case GUEST_ACTIVITY_WAIT_SIPI:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d118daed0530..858f5f1f1273 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4740,7 +4740,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
>  		if (kvm_emulate_instruction(vcpu, 0)) {
>  			if (vcpu->arch.halt_request) {
>  				vcpu->arch.halt_request = 0;
> -				return kvm_vcpu_halt(vcpu);
> +				return kvm_emulate_halt_noskip(vcpu);
>  			}
>  			return 1;
>  		}
> @@ -5414,7 +5414,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>  
>  		if (vcpu->arch.halt_request) {
>  			vcpu->arch.halt_request = 0;
> -			return kvm_vcpu_halt(vcpu);
> +			return kvm_emulate_halt_noskip(vcpu);
>  		}
>  
>  		/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0c21d42f453..eade8a2bdccf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8643,7 +8643,7 @@ void kvm_arch_exit(void)
>  #endif
>  }
>  
> -static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
> +static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
>  {
>  	++vcpu->stat.halt_exits;
>  	if (lapic_in_kernel(vcpu)) {
> @@ -8655,11 +8655,11 @@ static int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
>  	}
>  }
>  
> -int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
> +int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu)
>  {
> -	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
> +	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
>  }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
> +EXPORT_SYMBOL_GPL(kvm_emulate_halt_noskip);
>  
>  int kvm_emulate_halt(struct kvm_vcpu *vcpu)
>  {
> @@ -8668,7 +8668,7 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
>  	 * TODO: we might be squashing a GUESTDBG_SINGLESTEP-triggered
>  	 * KVM_EXIT_DEBUG here.
>  	 */
> -	return kvm_vcpu_halt(vcpu) && ret;
> +	return kvm_emulate_halt_noskip(vcpu) && ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_halt);
>  
> @@ -8676,7 +8676,8 @@ int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
>  {
>  	int ret = kvm_skip_emulated_instruction(vcpu);
>  
> -	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
> +	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD,
> +					KVM_EXIT_AP_RESET_HOLD) && ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
>  
> -- 
> 2.33.0.685.g46640cef36-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
