Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C08FC43217
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:32:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1F176120F
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 06:32:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F1F176120F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B06440573;
	Wed, 22 Sep 2021 02:32:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HFYiVPO7tdBI; Wed, 22 Sep 2021 02:32:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49FB04A19F;
	Wed, 22 Sep 2021 02:32:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42D0949E57
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:32:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mZTcFYpSdfYM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 02:32:32 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 363EC40573
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 02:32:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632292352;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QQ8YzZrVP1svLk3AMq6cxZLez6XFnWefi9KQVDYCfgo=;
 b=fmYLC59k7++KkSe/bCnLfoBH49jP1rYDAvQErwIUR3kdMMo7ClBrp2ITSGlDSsj8cL9ujD
 wAJxkcHO/VBC5PRsFmoo9VhnDixWkPVKS04GZqhm0BBcIbCogWRxVHnijpt2iCyxcby+R4
 D8E9PTytjRgi56qA4zXVHspE23UjzIA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165--2n6MxQSOeuC1dTlIjv9Kg-1; Wed, 22 Sep 2021 02:32:30 -0400
X-MC-Unique: -2n6MxQSOeuC1dTlIjv9Kg-1
Received: by mail-ed1-f71.google.com with SMTP id
 q17-20020a50c351000000b003d81427d25cso1779335edb.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 23:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=QQ8YzZrVP1svLk3AMq6cxZLez6XFnWefi9KQVDYCfgo=;
 b=d0128S8dKPe9+E0dXBA5XdHz0ZFmHM7kIWbp/jVzhHHP3c5fpfpf5lBzikJctYGmgn
 NPCvso2gkhz5KCT95mDsUibf44C2BJJ2z4fjuNGUA5RnqXc0MUJwbzORUiBlJA+OOTdi
 QTFDlxvlsDY4P4H5XMaFZpmskRGqe1zkSP77xwL09AvdT2bci3oLIUMM9iH52lnIrulm
 T3nI64Mq72dYnWQiEcSYGd5APn1GiRjFlAcbQSW9u/6gQjlYlYNm0UaBSVo8MoKD9HTq
 FivmKd5IS90tNo4DSO4sQRbn0Lg+XsqUAa49tIo4Ht/qBruzb8eynu2m/seow7eblFqh
 IAtA==
X-Gm-Message-State: AOAM531muc62uWGS3/hEmTt5T7R8iHPMxzLiCninSiwToSXwXrwBZ9Eb
 GDzqY8CA8oK4XxwNRhi+pZlCxZ0J4fky/4aJml7WW1ayPD0J9YpbFouCeWW3bwktRyjQfVWxHUx
 a6fm/7OKwLEavXcpDxnzHKEtE
X-Received: by 2002:a17:907:11c5:: with SMTP id
 va5mr38316024ejb.215.1632292349170; 
 Tue, 21 Sep 2021 23:32:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYtbJQ8octsTI+p+irGuyf7bBUrwOfK9ScnlhWiK83zRobYLAMfdGjMGdI45oS8miuwF0xKA==
X-Received: by 2002:a17:907:11c5:: with SMTP id
 va5mr38315988ejb.215.1632292348952; 
 Tue, 21 Sep 2021 23:32:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id yd3sm552542ejb.6.2021.09.21.23.32.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 23:32:28 -0700 (PDT)
Subject: Re: [PATCH v3 08/16] perf: Force architectures to opt-in to guest
 callbacks
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
 <20210922000533.713300-9-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f2ad98e2-ddfb-c688-65af-7ecbd8bc3b3d@redhat.com>
Date: Wed, 22 Sep 2021 08:32:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922000533.713300-9-seanjc@google.com>
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
> Introduce GUEST_PERF_EVENTS and require architectures to select it to
> allow registering and using guest callbacks in perf.  This will hopefully
> make it more difficult for new architectures to add useless "support" for
> guest callbacks, e.g. via copy+paste.
> 
> Stubbing out the helpers has the happy bonus of avoiding a load of
> perf_guest_cbs when GUEST_PERF_EVENTS=n on arm64/x86.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/kvm/Kconfig     | 1 +
>   arch/x86/kvm/Kconfig       | 1 +
>   arch/x86/xen/Kconfig       | 1 +
>   include/linux/perf_event.h | 6 ++++++
>   init/Kconfig               | 4 ++++
>   kernel/events/core.c       | 2 ++
>   6 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index a4eba0908bfa..f2121404c7c6 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -37,6 +37,7 @@ menuconfig KVM
>   	select HAVE_KVM_IRQ_BYPASS
>   	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>   	select SCHED_INFO
> +	select GUEST_PERF_EVENTS if PERF_EVENTS
>   	help
>   	  Support hosting virtualized guest machines.
>   
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index ac69894eab88..699bf786fbce 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -36,6 +36,7 @@ config KVM
>   	select KVM_MMIO
>   	select SCHED_INFO
>   	select PERF_EVENTS
> +	select GUEST_PERF_EVENTS
>   	select HAVE_KVM_MSI
>   	select HAVE_KVM_CPU_RELAX_INTERCEPT
>   	select HAVE_KVM_NO_POLL
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index afc1da68b06d..d07595a9552d 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -23,6 +23,7 @@ config XEN_PV
>   	select PARAVIRT_XXL
>   	select XEN_HAVE_PVMMU
>   	select XEN_HAVE_VPMU
> +	select GUEST_PERF_EVENTS
>   	help
>   	  Support running as a Xen PV guest.
>   
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index c0a6eaf55fb1..eefa197d5354 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1238,6 +1238,7 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
>   				 enum perf_bpf_event_type type,
>   				 u16 flags);
>   
> +#ifdef CONFIG_GUEST_PERF_EVENTS
>   extern struct perf_guest_info_callbacks *perf_guest_cbs;
>   static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
>   {
> @@ -1273,6 +1274,11 @@ static inline unsigned int perf_guest_handle_intel_pt_intr(void)
>   }
>   extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
>   extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
> +#else
> +static inline unsigned int perf_guest_state(void)		 { return 0; }
> +static inline unsigned long perf_guest_get_ip(void)		 { return 0; }
> +static inline unsigned int perf_guest_handle_intel_pt_intr(void) { return 0; }
> +#endif /* CONFIG_GUEST_PERF_EVENTS */

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Having perf_guest_handle_intel_pt_intr in generic code is a bit off.  Of 
course it has to be in the struct, but the wrapper might be placed in 
arch/x86/include/asm/perf_event.h as well (applies to patch 7 as well).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
