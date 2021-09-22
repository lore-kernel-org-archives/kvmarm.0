Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCA5C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:24:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A59161268
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0A59161268
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B143F4A500;
	Wed, 22 Sep 2021 02:24:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rKF8TmnpLl+B; Wed, 22 Sep 2021 02:24:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96D3E4048A;
	Wed, 22 Sep 2021 02:24:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 365574018F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:24:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H0oBaBnUErqq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 02:24:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02E3C4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:24:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632291851;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1o72rZ3J4EUS5ZaXq1DHK1qEjD5sQ31Ny28qqm6SkjQ=;
 b=gHGD/4jF+Za5vqMuH8tMJxO5j//Rjh06cHBnA7e2eHauaYOGVnuI3fMpr0qldOY4m4PlxC
 cvKDXVDpkHzcQQ+N59YjAQDl0weH7S6Bm4RMwyk0B9qSURl8j91ERgYLJ3rFnU1KBBAJPP
 0CoHYavZtifPB7tx25Gl9aiYwzRBv9g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431--k9NjAlUO2-rGLD7oqQIjw-1; Wed, 22 Sep 2021 02:24:10 -0400
X-MC-Unique: -k9NjAlUO2-rGLD7oqQIjw-1
Received: by mail-wr1-f71.google.com with SMTP id
 h5-20020a5d6885000000b0015e21e37523so1130998wru.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 23:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=1o72rZ3J4EUS5ZaXq1DHK1qEjD5sQ31Ny28qqm6SkjQ=;
 b=mjFwZcM8Xj6wFqwnZcUFNI43jUHjaxo+emY7DJMIg8gCxE31Qs+s1zXod2J08eh/MZ
 ODs/vRWmNxgyuI2gPxFZJt+3eCtPZ1ZLCd335iBCvUTZ91QMN352PGqoaDZmzp6qxOk0
 wgu1Jk6XuIvmZHns6bGQir582ke5b3BBR/OLsBU0yOhCWZMpuX4mMb3SOL40fMSpq4vi
 aBn6bRmgwPW/JAeTbzMnHAyJ3U05jvM0f494RLIPXJH1wOJF8Z2BCPyKl9DPCLOQ5Zja
 JkXvirua78k2P+PFmQ6G36ART5v3FdVaRO0ifb8b1bjNKLZiZzxrT0SWAeIHVqXlL4ni
 5lSw==
X-Gm-Message-State: AOAM531icW+2sko49sPWuHbvU+AdoCL+JhhBduq64lIQhIkHqEqxQn0g
 wTTNvnlI0tdhO1Y/v9PKMz8QRaFITBiwI61zaZm9gP+KTV/lUFsITooEoQvTbdP2cMkApUfJFJ9
 00M3jBqpibxsIb42e1kGAJP+c
X-Received: by 2002:a1c:448a:: with SMTP id r132mr8797107wma.105.1632291849586; 
 Tue, 21 Sep 2021 23:24:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQTq0zGwJ27i2S0Z0f0XPnoR50fJdudIkaF4OKBHHQ4AgCyC4Ha/kLdM9RRJcXFpLjepRj8g==
X-Received: by 2002:a1c:448a:: with SMTP id r132mr8797078wma.105.1632291849339; 
 Tue, 21 Sep 2021 23:24:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id z13sm1236395wrs.90.2021.09.21.23.24.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 23:24:08 -0700 (PDT)
Subject: Re: [PATCH v3 03/16] KVM: x86: Register Processor Trace interrupt
 hook iff PT enabled in guest
To: Sean Christopherson <seanjc@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
 Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
 Greentime Hu <green.hu@gmail.com>, Vincent Chen <deanbo422@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-4-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <459f2af0-d4ea-955e-fb2b-e118140ee9bf@redhat.com>
Date: Wed, 22 Sep 2021 08:24:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922000533.713300-4-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-riscv@lists.infradead.org,
 Jiri Olsa <jolsa@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-csky@vger.kernel.org, xen-devel@lists.xenproject.org,
 Namhyung Kim <namhyung@kernel.org>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
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

On 22/09/21 02:05, Sean Christopherson wrote:
> Override the Processor Trace (PT) interrupt handler for guest mode if and
> only if PT is configured for host+guest mode, i.e. is being used
> independently by both host and guest.  If PT is configured for system
> mode, the host fully controls PT and must handle all events.
> 
> Fixes: 8479e04e7d6b ("KVM: x86: Inject PMI for KVM guest")
> Cc: stable@vger.kernel.org
> Cc: Like Xu <like.xu.linux@gmail.com>
> Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Reported-by: Artem Kashkanov <artem.kashkanov@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/vmx/vmx.c          | 1 +
>   arch/x86/kvm/x86.c              | 5 ++++-
>   3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 09b256db394a..1ea4943a73d7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1494,6 +1494,7 @@ struct kvm_x86_init_ops {
>   	int (*disabled_by_bios)(void);
>   	int (*check_processor_compatibility)(void);
>   	int (*hardware_setup)(void);
> +	bool (*intel_pt_intr_in_guest)(void);
>   
>   	struct kvm_x86_ops *runtime_ops;
>   };
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fada1055f325..f19d72136f77 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7896,6 +7896,7 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
>   	.disabled_by_bios = vmx_disabled_by_bios,
>   	.check_processor_compatibility = vmx_check_processor_compat,
>   	.hardware_setup = hardware_setup,
> +	.intel_pt_intr_in_guest = vmx_pt_mode_is_host_guest,
>   
>   	.runtime_ops = &vmx_x86_ops,
>   };
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb6015f97f9e..ffc6c2d73508 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8305,7 +8305,7 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
>   	.is_in_guest		= kvm_is_in_guest,
>   	.is_user_mode		= kvm_is_user_mode,
>   	.get_guest_ip		= kvm_get_guest_ip,
> -	.handle_intel_pt_intr	= kvm_handle_intel_pt_intr,
> +	.handle_intel_pt_intr	= NULL,
>   };
>   
>   #ifdef CONFIG_X86_64
> @@ -11061,6 +11061,8 @@ int kvm_arch_hardware_setup(void *opaque)
>   	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
>   	kvm_ops_static_call_update();
>   
> +	if (ops->intel_pt_intr_in_guest && ops->intel_pt_intr_in_guest())
> +		kvm_guest_cbs.handle_intel_pt_intr = kvm_handle_intel_pt_intr;
>   	perf_register_guest_info_callbacks(&kvm_guest_cbs);
>   
>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> @@ -11091,6 +11093,7 @@ int kvm_arch_hardware_setup(void *opaque)
>   void kvm_arch_hardware_unsetup(void)
>   {
>   	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
> +	kvm_guest_cbs.handle_intel_pt_intr = NULL;
>   
>   	static_call(kvm_x86_hardware_unsetup)();
>   }
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
