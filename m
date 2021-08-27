Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C197C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:51:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F07EC60F39
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:51:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F07EC60F39
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79E234B0E3;
	Fri, 27 Aug 2021 06:51:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AjFZBT3G7L5H; Fri, 27 Aug 2021 06:51:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C3DB4B10B;
	Fri, 27 Aug 2021 06:51:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09D824B0E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:51:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T9ubJs1V+CJk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 06:51:14 -0400 (EDT)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B98D74B0E3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:51:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=OvP4Yc4jC04J0qjspa8OOFxuL+jnhRGg3XpJSSUjD4o=; b=dSa6gg/k/uLkIao8HV8YKHe55R
 QJNUW1DSGmJFIQkoPB+Yq9DSt+RE29HdMkm2cJByn2hw71NQjxJsEPWO+21wDTQDfhVhvu8BkQjf+
 L2krqmyZ3aAWLWTmA2aYMCQduTwu64ujYtSfjBEUhfAlVzmTqYLy4o2Ws9e1IwuEUwmRG03uA93za
 1BcwsEtY0TALxF7lF4k1iZju+DOeaUy6K5KSj20dObZE8KmsuxkJigtb+xm3AzeIgXlZyxOHnS/+B
 4KvrvAwWmfWEjBAXOKEuxfukFtVoVnSRlyFVxwDa8h8JGPBd0g9VYSiib1uZ+XvyETPfQlMGdpOrv
 2P9m3iwg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=noisy.programming.kicks-ass.net)
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mJZOS-00ESWc-Uh; Fri, 27 Aug 2021 10:47:37 +0000
Received: from hirez.programming.kicks-ass.net
 (hirez.programming.kicks-ass.net [192.168.1.225])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (Client did not present a certificate)
 by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 69DD6300024;
 Fri, 27 Aug 2021 12:47:25 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
 id 4ECD229A12A47; Fri, 27 Aug 2021 12:47:25 +0200 (CEST)
Date: Fri, 27 Aug 2021 12:47:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH 00/15] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <YSjCvbWE6sZ29dPr@hirez.programming.kicks-ass.net>
References: <20210827005718.585190-1-seanjc@google.com>
 <fd3dcd6c-b3d5-4453-93fb-b46d0595534e@gmail.com>
 <YSiX9OPcrDsr3P4C@hirez.programming.kicks-ass.net>
 <3bd4955a-1219-20b0-058b-d23f1e30aa77@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3bd4955a-1219-20b0-058b-d23f1e30aa77@gmail.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Josh Poimboeuf <jpoimboe@redhat.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Stefano Stabellini <sstabellini@kernel.org>,
 Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 Steven Rostedt <rostedt@goodmis.org>, xen-devel@lists.xenproject.org,
 Juergen Gross <jgross@suse.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Zhu Lingshan <lingshan.zhu@intel.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Jason Baron <jbaron@akamai.com>,
 Borislav Petkov <bp@alien8.de>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Nick Hu <nickhu@andestech.com>,
 Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Aug 27, 2021 at 04:01:45PM +0800, Like Xu wrote:
> On 27/8/2021 3:44 pm, Peter Zijlstra wrote:

> > You just have to make sure all static_call() invocations that started
> > before unreg are finished before continuing with the unload.
> > synchronize_rcu() can help with that.
> 
> Do you mean something like that:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 64e310ff4f3a..e7d310af7509 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8465,6 +8465,7 @@ void kvm_arch_exit(void)
>  #endif
>  	kvm_lapic_exit();
>  	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
> +	synchronize_rcu();
> 
>  	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>  		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index e466fc8176e1..63ae56c5d133 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6508,6 +6508,7 @@ EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
>  int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>  {
>  	perf_guest_cbs = NULL;
> +	arch_perf_update_guest_cbs();

I'm thinking the synchronize_rcu() should go here, and access to
perf_guest_cbs should be wrapped to yell when called with preemption
enabled.

But yes..

>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
> 
> > 
> > This is module unload 101. Nothing specific to static_call().
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
