Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E75C4320A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 13:40:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A2A860F6F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 13:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1A2A860F6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9165F49F92;
	Mon, 26 Jul 2021 09:40:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NaOiEv4riV+U; Mon, 26 Jul 2021 09:40:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 932B64A319;
	Mon, 26 Jul 2021 09:40:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18B9449E50
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 09:40:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o8wSQaJ2NyLB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 09:40:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22B0849F92
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 09:40:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1627306823;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hCZfOAl7ts2DxmB2QUu9PfkSKpATBw/UVjJQZQ4MLGY=;
 b=TQttGfI2IB7AJgKM+hx4k3foZbdof96W9QdthdKXsYEL3oHfsRlXDezVnegrwnSVdWAfLn
 jTOyBND01ybq0n7djo0SSQiZ+eHCs6rZ77aauMrOeRGISrSplP+OhX9T7fmrIyi1F54oH2
 DCkVhodJcddZH0dWcP6G8JSUL25fi1Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-3NpQgTaVOySfJb_DU2wwQA-1; Mon, 26 Jul 2021 09:40:23 -0400
X-MC-Unique: 3NpQgTaVOySfJb_DU2wwQA-1
Received: by mail-ed1-f69.google.com with SMTP id
 j22-20020a50ed160000b02903ab03a06e86so4723540eds.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 06:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=hCZfOAl7ts2DxmB2QUu9PfkSKpATBw/UVjJQZQ4MLGY=;
 b=L+oMDO/6cUjTaJgI52FRJrfE9sCndwSyw+48LQzPcBkXESHNK74jh34vMkXnT43qtE
 rwoJ3ZWejWhfg9g7VPIXOxiq/V8E693iPdz/sGaFJ+lmk3OR3NjycPJRXMOIl5NRbRAK
 z17Wiq/St4sZmyticVUBaruenES5CBgolLoBKqzujtDawULUn9M1kjeFAatwYiTBuTMT
 atOpaZ+6JvGgD9ILQwSY56Ogri8ya6HIPlKRXTTHYoqWbyThVLCYxdQlWu3McWsJYoh0
 /zjvl309VSX4qI0BGtNqI2YWnEreiYGCKE+ZRMk1x+mjgIKNz+rsU+emgliTmd+u3lal
 3OHw==
X-Gm-Message-State: AOAM531rNNOX6UvOV80SzKeC6WsOH8MwzxDfAF4DspBRPeBhLuJJcKo/
 Fpr7v4cHg/CBa9OnhWLBWaYwTI++xu4n09UnjlnGV2L8uoWxjFCAGWifmCF3E98/71eQ7u47trk
 FLNdC/CUtCxZm5ix23SFSY2c5IEVDcogp+dMQtmbYEUu09wF2rnxSCPq8N9JYpeC8m+TclZQkne
 XE
X-Received: by 2002:a17:906:7a56:: with SMTP id
 i22mr16703008ejo.94.1627306821503; 
 Mon, 26 Jul 2021 06:40:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzko4dcZu7JrLLGnLsOcz5h39r9ijD0U3NL4kNBCRhF6IB2UvPA+rdkEJbNblOqI4Hx/b10gw==
X-Received: by 2002:a17:906:7a56:: with SMTP id
 i22mr16702963ejo.94.1627306821229; 
 Mon, 26 Jul 2021 06:40:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id r11sm14254275ejy.71.2021.07.26.06.40.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 26 Jul 2021 06:40:20 -0700 (PDT)
Subject: Re: [PATCH 5/6] kvm: allocate vcpu pointer array separately
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-6-jgross@suse.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <001b7eab-ed7b-da27-a623-057781cf1211@redhat.com>
Date: Mon, 26 Jul 2021 15:40:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701154105.23215-6-jgross@suse.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Sean Christopherson <seanjc@google.com>,
 kvmarm@lists.cs.columbia.edu, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Borislav Petkov <bp@alien8.de>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 01/07/21 17:41, Juergen Gross wrote:
>   {
> -	if (!has_vhe())
> +	if (!has_vhe()) {
> +		kfree(kvm->vcpus);
>   		kfree(kvm);
> -	else
> +	} else {
> +		vfree(kvm->vcpus);
>   		vfree(kvm);
> +	}
>   }
>   
>   int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 79138c91f83d..39cbc4b6bffb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1440,10 +1440,7 @@ static inline void kvm_ops_static_call_update(void)
>   }
>   
>   #define __KVM_HAVE_ARCH_VM_ALLOC
> -static inline struct kvm *kvm_arch_alloc_vm(void)
> -{
> -	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> -}
> +struct kvm *kvm_arch_alloc_vm(void);
>   void kvm_arch_free_vm(struct kvm *kvm);
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3af398ef1fc9..a9b0bb2221ea 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10741,9 +10741,28 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>   	static_call(kvm_x86_sched_in)(vcpu, cpu);
>   }
>   
> +struct kvm *kvm_arch_alloc_vm(void)
> +{
> +	struct kvm *kvm;
> +
> +	kvm = __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!kvm)
> +		return NULL;
> +
> +	kvm->vcpus = __vmalloc(KVM_MAX_VCPUS * sizeof(void *),
> +			       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!kvm->vcpus) {
> +		vfree(kvm);
> +		kvm = NULL;
> +	}
> +

Let's keep this cleaner:

1) use kvfree in the common version of kvm_arch_free_vm

2) split __KVM_HAVE_ARCH_VM_ALLOC and __KVM_HAVE_ARCH_VM_FREE (ARM does 
not need it once kvfree is used)

3) define a __kvm_arch_free_vm version that is defined even if 
!__KVM_HAVE_ARCH_VM_FREE, and which can be used on x86.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
