Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA750C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 07:59:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CEC749F49;
	Fri,  4 Nov 2022 03:59:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aeWuwKWpzI-9; Fri,  4 Nov 2022 03:59:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B364243482;
	Fri,  4 Nov 2022 03:59:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3542341075
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 03:59:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sT3NqQWqjhBe for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 03:59:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B15D94013F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 03:59:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667548752;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EJeUF4PeIyDwWhg83Rm4e9DTJIlz0RfDdBHuS7iY8Qc=;
 b=IR2tdOmrTRSk+dJN70STqGRsLNF6IZmhLHLJmJIg2ruYnIlRpt9pL03yRnwBgNveZkDPWy
 We/dhWd20tMKwJpyKjIpBspxnbBzyHtfrLdXrkH48ALEgl4/BKzHb+6HNCYPJdp6jNWipy
 n7KlGpQ4H5hpJw0szmYI/aDXFAawgTc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-3s-fC7yHOl2sYie33MfhbA-1; Fri, 04 Nov 2022 03:59:11 -0400
X-MC-Unique: 3s-fC7yHOl2sYie33MfhbA-1
Received: by mail-ej1-f71.google.com with SMTP id
 jg27-20020a170907971b00b007ad9892f5f6so2704356ejc.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 00:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=EJeUF4PeIyDwWhg83Rm4e9DTJIlz0RfDdBHuS7iY8Qc=;
 b=whWgYIr4Z7WpGtcC/cBV7Sk3FjXxPf5Z9NuoHwXD5do8OQ3G6jyasL43BzGY6Stweh
 /+F82bh7eHZbtqVblUDcEO9kwevxho+8tDVFFVX68ZSAeHnSOTQnpQodHsCWcuTsWS5n
 QwCn3vA0/jy47+fPJMSOBW02fl6wr9IQFzo1XZavIfgH4vt02kuhKWiE6vhZSrQKk8FF
 7EnlMeQeZEtYDSjlawd2PiQXoHVTlN2t1LkB0V+RpYbLRcJVQGSr6DbV5wP2wVCDUGme
 cYOgHy9r5oPK/iHqN0z5+P8Y1+XwNlcX2a1nlBnrvhp14staA7tjWBEziMWNlFWo70aQ
 ozIA==
X-Gm-Message-State: ACrzQf2DMr7rcSUPBFeKyfZWIlQ9/SRsQZMHjpBDoVI556tlQ77PVorh
 00VhSQWRLswAY7bMySqqtdO1xCqImVCKK9WPVXh9ylgnw82T6uHAgJ0570xXomex3LFFIcKvxrL
 GhM9Yv6qoZ4BeR2ZdGqZWIx7F
X-Received: by 2002:a05:6402:378c:b0:458:8053:6c5f with SMTP id
 et12-20020a056402378c00b0045880536c5fmr33842111edb.9.1667548749724; 
 Fri, 04 Nov 2022 00:59:09 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4JQssOxBto/uy8zX5hPa1fJjqq666daf9UF+4lfquuNi1ItDIQofNjauQbNAII7zHijsljig==
X-Received: by 2002:a05:6402:378c:b0:458:8053:6c5f with SMTP id
 et12-20020a056402378c00b0045880536c5fmr33842056edb.9.1667548749383; 
 Fri, 04 Nov 2022 00:59:09 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5?
 ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
 by smtp.googlemail.com with ESMTPSA id
 t24-20020aa7d4d8000000b00461a98a2128sm1576537edr.26.2022.11.04.00.59.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 04 Nov 2022 00:59:08 -0700 (PDT)
Message-ID: <2d964d60-c2e9-ea00-37b4-ad82af9e013f@redhat.com>
Date: Fri, 4 Nov 2022 08:59:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
To: Isaku Yamahata <isaku.yamahata@gmail.com>,
 Sean Christopherson <seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221104071749.GC1063309@ls.amr.corp.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221104071749.GC1063309@ls.amr.corp.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On 11/4/22 08:17, Isaku Yamahata wrote:
> On Wed, Nov 02, 2022 at 11:18:27PM +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> 
>> Non-x86 folks, please test on hardware when possible.  I made a _lot_ of
>> mistakes when moving code around.  Thankfully, x86 was the trickiest code
>> to deal with, and I'm fairly confident that I found all the bugs I
>> introduced via testing.  But the number of mistakes I made and found on
>> x86 makes me more than a bit worried that I screwed something up in other
>> arch code.
>>
>> This is a continuation of Chao's series to do x86 CPU compatibility checks
>> during virtualization hardware enabling[1], and of Isaku's series to try
>> and clean up the hardware enabling paths so that x86 (Intel specifically)
>> can temporarily enable hardware during module initialization without
>> causing undue pain for other architectures[2].  It also includes one patch
>> from another mini-series from Isaku that provides the less controversial
>> patches[3].
>>
>> The main theme of this series is to kill off kvm_arch_init(),
>> kvm_arch_hardware_(un)setup(), and kvm_arch_check_processor_compat(), which
>> all originated in x86 code from way back when, and needlessly complicate
>> both common KVM code and architecture code.  E.g. many architectures don't
>> mark functions/data as __init/__ro_after_init purely because kvm_init()
>> isn't marked __init to support x86's separate vendor modules.
>>
>> The idea/hope is that with those hooks gone (moved to arch code), it will
>> be easier for x86 (and other architectures) to modify their module init
>> sequences as needed without having to fight common KVM code.  E.g. I'm
>> hoping that ARM can build on this to simplify its hardware enabling logic,
>> especially the pKVM side of things.
>>
>> There are bug fixes throughout this series.  They are more scattered than
>> I would usually prefer, but getting the sequencing correct was a gigantic
>> pain for many of the x86 fixes due to needing to fix common code in order
>> for the x86 fix to have any meaning.  And while the bugs are often fatal,
>> they aren't all that interesting for most users as they either require a
>> malicious admin or broken hardware, i.e. aren't likely to be encountered
>> by the vast majority of KVM users.  So unless someone _really_ wants a
>> particular fix isolated for backporting, I'm not planning on shuffling
>> patches.
>>
>> Tested on x86.  Lightly tested on arm64.  Compile tested only on all other
>> architectures.
> 
> Thanks for the patch series. I the rebased TDX KVM patch series and it worked.
> Since cpu offline needs to be rejected in some cases(To keep at least one cpu
> on a package), arch hook for cpu offline is needed.
> I can keep it in TDX KVM patch series.

Yes, this patch looks good.

Paolo

> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 23c0f4bc63f1..ef7bcb845d42 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -17,6 +17,7 @@ BUILD_BUG_ON(1)
>   KVM_X86_OP(hardware_enable)
>   KVM_X86_OP(hardware_disable)
>   KVM_X86_OP(hardware_unsetup)
> +KVM_X86_OP_OPTIONAL_RET0(offline_cpu)
>   KVM_X86_OP(has_emulated_msr)
>   KVM_X86_OP(vcpu_after_set_cpuid)
>   KVM_X86_OP(is_vm_type_supported)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 496c7c6eaff9..c420409aa96f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1468,6 +1468,7 @@ struct kvm_x86_ops {
>   	int (*hardware_enable)(void);
>   	void (*hardware_disable)(void);
>   	void (*hardware_unsetup)(void);
> +	int (*offline_cpu)(void);
>   	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
>   	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2ed5a017f7bc..17c5d6a76c93 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12039,6 +12039,11 @@ void kvm_arch_hardware_disable(void)
>   	drop_user_return_notifiers();
>   }
>   
> +int kvm_arch_offline_cpu(unsigned int cpu)
> +{
> +	return static_call(kvm_x86_offline_cpu)();
> +}
> +
>   bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
>   {
>   	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 620489b9aa93..4df79443fd11 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1460,6 +1460,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
>   int kvm_arch_hardware_enable(void);
>   void kvm_arch_hardware_disable(void);
>   #endif
> +int kvm_arch_offline_cpu(unsigned int cpu);
>   int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>   bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
>   int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f6b6dcedaa0a..f770fdc662d0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5396,16 +5396,24 @@ static void hardware_disable_nolock(void *junk)
>   	__this_cpu_write(hardware_enabled, false);
>   }
>   
> +__weak int kvm_arch_offline_cpu(unsigned int cpu)
> +{
> +	return 0;
> +}
> +
>   static int kvm_offline_cpu(unsigned int cpu)
>   {
> +	int r = 0;
> +
>   	mutex_lock(&kvm_lock);
> -	if (kvm_usage_count) {
> +	r = kvm_arch_offline_cpu(cpu);
> +	if (!r && kvm_usage_count) {
>   		preempt_disable();
>   		hardware_disable_nolock(NULL);
>   		preempt_enable();
>   	}
>   	mutex_unlock(&kvm_lock);
> -	return 0;
> +	return r;
>   }
>   
>   static void hardware_disable_all_nolock(void)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
