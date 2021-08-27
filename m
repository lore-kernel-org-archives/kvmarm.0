Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF052C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:25:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A40960FD9
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:25:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1A40960FD9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D674B0BA;
	Fri, 27 Aug 2021 03:25:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EbelZg28OSaj; Fri, 27 Aug 2021 03:24:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 615AE4B0F2;
	Fri, 27 Aug 2021 03:24:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C4064B0BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:24:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 84-uZSPcKt11 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 03:24:54 -0400 (EDT)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EC964B0BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:24:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=neG8mg28UHUzHJK70IF++gxfO1zx12p3aLda6nUX0F8=; b=AukJ9GkzIV3P3F+0ekocwQawBL
 tFlCkXpct0NjVzxDAYN3qp6dW8DFOR5++b6oO+2oFghCLwWlQldR9xUKOxe6O9xGeZ3SF85D2ScKC
 RFt1tMii/X4MA5Hvk4XKVnCAHMtwMT7KO94Zi39lswz81eHv7+EWswbpXCxLYyjwAhehjD4Pj9zhD
 /QGUZAd7iD4iU9YTu64FgKEGL0luhMV0hc4vrnvpZFSqjXRBBxUSDax4g0UrRpI2dleksB66sSbSW
 I8F5HQkpMUSSv+Lz7wFRfoB+E5euI/bbEB/SVUaXfnNNAHO9evgCgJrPXZXun2y+vLo5dnB1ozeVf
 G62jQfjw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=noisy.programming.kicks-ass.net)
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mJWBM-00EFSX-VT; Fri, 27 Aug 2021 07:22:07 +0000
Received: from hirez.programming.kicks-ass.net
 (hirez.programming.kicks-ass.net [192.168.1.225])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (Client did not present a certificate)
 by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A41C630035D;
 Fri, 27 Aug 2021 09:21:43 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
 id 80EAF2C6670E9; Fri, 27 Aug 2021 09:21:43 +0200 (CEST)
Date: Fri, 27 Aug 2021 09:21:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 06/15] KVM: x86: Register perf callbacks only when
 actively handling interrupt
Message-ID: <YSiShwJeBvAVPVKe@hirez.programming.kicks-ass.net>
References: <20210827005718.585190-1-seanjc@google.com>
 <20210827005718.585190-7-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210827005718.585190-7-seanjc@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Ingo Molnar <mingo@redhat.com>, Like Xu <like.xu.linux@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Zhu Lingshan <lingshan.zhu@intel.com>,
 Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Thu, Aug 26, 2021 at 05:57:09PM -0700, Sean Christopherson wrote:
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 9bc1375d6ed9..2f28d9d8dc94 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6485,6 +6485,18 @@ static void perf_pending_event(struct irq_work *entry)
>  #ifdef CONFIG_HAVE_GUEST_PERF_EVENTS
>  DEFINE_PER_CPU(struct perf_guest_info_callbacks *, perf_guest_cbs);
>  
> +void __perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
> +{
> +	__this_cpu_write(perf_guest_cbs, cbs);
> +}
> +EXPORT_SYMBOL_GPL(__perf_register_guest_info_callbacks);
> +
> +void __perf_unregister_guest_info_callbacks(void)
> +{
> +	__this_cpu_write(perf_guest_cbs, NULL);
> +}
> +EXPORT_SYMBOL_GPL(__perf_unregister_guest_info_callbacks);

This is 100% broken, and a prime example of why I hate modules.

It provides an interface for all modules, and completely fails to
validate even the most basic usage.

By using __this_cpu*() it omits the preemption checks, so you can call
this with preemption enabled, no problem.

By not checking the previous state, multiple modules can call this
interleaved without issue.

Basically assume any EXPORTed function is hostile, binary modules and
out-of-tree modules *are* just that. It's a cesspit out there.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
