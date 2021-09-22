Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5FDC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:23:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F3E16120F
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:23:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2F3E16120F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93FD54AC78;
	Wed, 22 Sep 2021 02:23:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Du-YTOIjHnx5; Wed, 22 Sep 2021 02:23:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52EE54A49C;
	Wed, 22 Sep 2021 02:23:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B73794A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:23:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Df5qTUFMdsr3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 02:23:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5EF7406E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:23:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632291817;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Zooka9gAajsg8DCKduDSvz7LupNnOu3u1TFHi7y68Yc=;
 b=TxIE912/sclScoAzCqcd+GJT9rXC021QMVlM4pFrNJfStcaI3ENrIqV38xS2zgkQR2CEP/
 n7aZ6qmr9HATYOqc6h2B71+cYyYtEaYAvPs0Ga2L8hOcZnQlbnScm3KlotWOcG/HSc2pqm
 CbW/ZT1dZfz8WI9yv0jFBvFatv1lPOA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-MNATkwngN025bZBeRapKhA-1; Wed, 22 Sep 2021 02:23:36 -0400
X-MC-Unique: MNATkwngN025bZBeRapKhA-1
Received: by mail-wr1-f69.google.com with SMTP id
 z2-20020a5d4c82000000b0015b140e0562so1146160wrs.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 23:23:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Zooka9gAajsg8DCKduDSvz7LupNnOu3u1TFHi7y68Yc=;
 b=btf8BHFXDaTma2fZzsuWTbtb6MlIQDrVsv+kMMg8l3ra0ApfavRTqi518UFTzr5ijK
 G/RazMvAsWpOyC003nyl5fI3ESYeGzYnBkKffqwJbVUTWhHp/Y0tEkLZbdhr1VhhD9MO
 +CT6OmQ3MthaM0IiWS+TuCyUBHxtKLX/0htH1saZ5jHN0r7BW427M0JBn0rrML+WhgcK
 2ZHIJiF1Jcy/BcFxpTpCIGb74m6K9b4u/BPGbumvih5ZBIZgeJbmNVmscQCKG87YeXDT
 6IpLL/hAFNqqs4EWtN8UjzrSmgC9CUpGOTEcegLhyibOjDijlz5k/46SB1AtLgsRKPVd
 lnfA==
X-Gm-Message-State: AOAM533GwaHwha6/FD4IIzFqV2U1elQKXCaKA7BqvLMGVZ94v5651NWZ
 ipcE9xKV3x1HrWlLcr225kOKh3RuNtHHH7P8qEtAarlaOLi/+6kWlMKDnGTKCay+en2UeMdpfYI
 6rAwN0htqnW6xagt8ZC5/BHim
X-Received: by 2002:a7b:c3cc:: with SMTP id t12mr8423445wmj.68.1632291814989; 
 Tue, 21 Sep 2021 23:23:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4Cxl6B3FvPynsb4jNEGdd2w6uOOFopYtreXbLymB/TUbaoz5flccfGAb2LTh0HveeWZIomg==
X-Received: by 2002:a7b:c3cc:: with SMTP id t12mr8423394wmj.68.1632291814600; 
 Tue, 21 Sep 2021 23:23:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id o1sm1112414wru.91.2021.09.21.23.23.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 23:23:34 -0700 (PDT)
Subject: Re: [PATCH v3 02/16] KVM: x86: Register perf callbacks after calling
 vendor's hardware_setup()
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
 <20210922000533.713300-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e31f767-ae3d-ec87-9880-5a8ebc381192@redhat.com>
Date: Wed, 22 Sep 2021 08:23:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922000533.713300-3-seanjc@google.com>
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
> Wait to register perf callbacks until after doing vendor hardaware setup.
> VMX's hardware_setup() configures Intel Processor Trace (PT) mode, and a
> future fix to register the Intel PT guest interrupt hook if and only if
> Intel PT is exposed to the guest will consume the configured PT mode.
> 
> Delaying registration to hardware setup is effectively a nop as KVM's perf
> hooks all pivot on the per-CPU current_vcpu, which is non-NULL only when
> KVM is handling an IRQ/NMI in a VM-Exit path.  I.e. current_vcpu will be
> NULL throughout both kvm_arch_init() and kvm_arch_hardware_setup().
> 
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Artem Kashkanov <artem.kashkanov@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 86539c1686fa..fb6015f97f9e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8426,8 +8426,6 @@ int kvm_arch_init(void *opaque)
>   
>   	kvm_timer_init();
>   
> -	perf_register_guest_info_callbacks(&kvm_guest_cbs);
> -
>   	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
>   		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>   		supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
> @@ -8461,7 +8459,6 @@ void kvm_arch_exit(void)
>   		clear_hv_tscchange_cb();
>   #endif
>   	kvm_lapic_exit();
> -	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
>   
>   	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>   		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
> @@ -11064,6 +11061,8 @@ int kvm_arch_hardware_setup(void *opaque)
>   	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
>   	kvm_ops_static_call_update();
>   
> +	perf_register_guest_info_callbacks(&kvm_guest_cbs);
> +
>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>   		supported_xss = 0;
>   
> @@ -11091,6 +11090,8 @@ int kvm_arch_hardware_setup(void *opaque)
>   
>   void kvm_arch_hardware_unsetup(void)
>   {
> +	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
> +
>   	static_call(kvm_x86_hardware_unsetup)();
>   }
>   
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
