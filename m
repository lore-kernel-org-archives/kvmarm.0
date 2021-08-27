Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C5CC4320A
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:48:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA16A60F42
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:48:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CA16A60F42
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4659A4B0C5;
	Fri, 27 Aug 2021 03:48:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P-kBJyAPvhPH; Fri, 27 Aug 2021 03:48:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28AEB4B0F2;
	Fri, 27 Aug 2021 03:48:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCD244B0C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:48:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JLifFHxL2ng4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 03:48:08 -0400 (EDT)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C78314B0C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:48:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=mwqNvZJA9dIpDEWigadLmAt4ekXHrBRvbcdnGdey0lE=; b=I/IvqbDlSMWcIbpdOOAXfLAePd
 VnuHf80Ij7eT65HZ/ZmLgO4WMPy4itQhDo5T0oqUnYiX+gy+Rpm1rDaH4yfbNkb40sVQ1Gs3+K6Uq
 CAc6W/5Ofu26xIMuG6qfRfTVilpdhWEX2zSVyoNEfY39xPi+5hJeAJd/b2amtCtk8saRHvdqd3spd
 k3S7rVNP4X1Ahst2d+VG5ZMlKiq+sDTGG7S40hJJ0KnXYxsSWY1gkda21RFgy0QIi2/QZhbbB2Vlz
 96YSYnpgLCOvEhsZUVTk4sOSCYRU5PzhafRroNnuKOSTjrZC6AYQI4zn9xh9YCEYcHiHS9VshLf0l
 /zvt21FA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=noisy.programming.kicks-ass.net)
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mJWXo-00EGbQ-KU; Fri, 27 Aug 2021 07:45:12 +0000
Received: from hirez.programming.kicks-ass.net
 (hirez.programming.kicks-ass.net [192.168.1.225])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (Client did not present a certificate)
 by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7022A30035D;
 Fri, 27 Aug 2021 09:44:52 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
 id 549952C6670ED; Fri, 27 Aug 2021 09:44:52 +0200 (CEST)
Date: Fri, 27 Aug 2021 09:44:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH 00/15] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <YSiX9OPcrDsr3P4C@hirez.programming.kicks-ass.net>
References: <20210827005718.585190-1-seanjc@google.com>
 <fd3dcd6c-b3d5-4453-93fb-b46d0595534e@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <fd3dcd6c-b3d5-4453-93fb-b46d0595534e@gmail.com>
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

On Fri, Aug 27, 2021 at 02:52:25PM +0800, Like Xu wrote:
> + STATIC BRANCH/CALL friends.
> 
> On 27/8/2021 8:57 am, Sean Christopherson wrote:
> > This started out as a small series[1] to fix a KVM bug related to Intel PT
> > interrupt handling and snowballed horribly.
> > 
> > The main problem being addressed is that the perf_guest_cbs are shared by
> > all CPUs, can be nullified by KVM during module unload, and are not
> > protected against concurrent access from NMI context.
> 
> Shouldn't this be a generic issue of the static_call() usage ?
> 
> At the beginning, we set up the static entry assuming perf_guest_cbs != NULL:
> 
> 	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr) {
> 		static_call_update(x86_guest_handle_intel_pt_intr,
> 				   perf_guest_cbs->handle_intel_pt_intr);
> 	}
> 
> and then we unset the perf_guest_cbs and do the static function call like this:
> 
> DECLARE_STATIC_CALL(x86_guest_handle_intel_pt_intr,
> *(perf_guest_cbs->handle_intel_pt_intr));
> static int handle_pmi_common(struct pt_regs *regs, u64 status)
> {
> 		...
> 		if (!static_call(x86_guest_handle_intel_pt_intr)())
> 			intel_pt_interrupt();
> 		...
> }

You just have to make sure all static_call() invocations that started
before unreg are finished before continuing with the unload.
synchronize_rcu() can help with that.

This is module unload 101. Nothing specific to static_call().
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
