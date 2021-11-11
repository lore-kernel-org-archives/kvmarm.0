Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4362BC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 11:20:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B46F2611F2
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 11:20:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B46F2611F2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4053D4B176;
	Thu, 11 Nov 2021 06:20:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Cx6KofGjU-B; Thu, 11 Nov 2021 06:20:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A0554B20A;
	Thu, 11 Nov 2021 06:20:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5ECD4B209
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 06:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rpzyLMkepVWJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Nov 2021 06:20:01 -0500 (EST)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 850F04B176
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 06:20:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=Rwfbmkoas7VebHdsAPeFky9gQjs68+546BvuzLh8KOw=; b=nYW2D8WwDzTJBO/3hqaCnKl+rG
 Juv9WqI4u6yj05w2X63ioSsTn5cEdV6jDA351V4/q9yydOsa7FW1hSEMYTFCpYM+34h+eLD05vIuf
 aJw4KwauVgbsmZhkliH2C6iKJqojPUXuWEPcd38B1dtT88o84f5Sp/oMWfV8h9DaHJOesh+0xGqtP
 n4R4aYuGwPrCobAnDwuTl24Bkv/pjQsvWW5g0gG3sYG1rBE7VdaHTNsjeZ1KJKR5jtxxyS54nzBQU
 j+XeoDvq2JxdCtTPVCSG+YQMQo1n/omY8trwJKb2fdS0v2mWaEEA6whxFBt8nI2ZCCfGYmM487YiO
 s2UIUTPg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=noisy.programming.kicks-ass.net)
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1ml873-002g98-8m; Thu, 11 Nov 2021 11:19:26 +0000
Received: from hirez.programming.kicks-ass.net
 (hirez.programming.kicks-ass.net [192.168.1.225])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (Client did not present a certificate)
 by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 627DF3000D5;
 Thu, 11 Nov 2021 12:19:22 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
 id 304F0201EC1CF; Thu, 11 Nov 2021 12:19:21 +0100 (CET)
Date: Thu, 11 Nov 2021 12:19:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v4 00/17] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <YYz8OTWtkcFUkvbZ@hirez.programming.kicks-ass.net>
References: <20211111020738.2512932-1-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211111020738.2512932-1-seanjc@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Will Deacon <will@kernel.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 Russell King <linux@armlinux.org.uk>, linux-csky@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Ingo Molnar <mingo@redhat.com>,
 Like Xu <like.xu.linux@gmail.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Zhu Lingshan <lingshan.zhu@intel.com>, Jiri Olsa <jolsa@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Greentime Hu <green.hu@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Like Xu <like.xu@linux.intel.com>,
 Nick Hu <nickhu@andestech.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
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

On Thu, Nov 11, 2021 at 02:07:21AM +0000, Sean Christopherson wrote:

> Like Xu (1):
>   perf/core: Rework guest callbacks to prepare for static_call support
> 
> Sean Christopherson (16):
>   perf: Protect perf_guest_cbs with RCU
>   KVM: x86: Register perf callbacks after calling vendor's
>     hardware_setup()
>   KVM: x86: Register Processor Trace interrupt hook iff PT enabled in
>     guest
>   perf: Stop pretending that perf can handle multiple guest callbacks
>   perf: Drop dead and useless guest "support" from arm, csky, nds32 and
>     riscv
>   perf: Add wrappers for invoking guest callbacks
>   perf: Force architectures to opt-in to guest callbacks
>   perf/core: Use static_call to optimize perf_guest_info_callbacks
>   KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu
>     variable
>   KVM: x86: More precisely identify NMI from guest when handling PMI
>   KVM: Move x86's perf guest info callbacks to generic KVM
>   KVM: x86: Move Intel Processor Trace interrupt handler to vmx.c
>   KVM: arm64: Convert to the generic perf callbacks
>   KVM: arm64: Hide kvm_arm_pmu_available behind CONFIG_HW_PERF_EVENTS=y
>   KVM: arm64: Drop perf.c and fold its tiny bits of code into arm.c
>   perf: Drop guest callback (un)register stubs

Thanks!, I'll queue them up and push them into tip/perf/core once -rc1
happens.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
