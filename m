Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260C4C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 14:57:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C68C60EFF
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 14:57:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8C68C60EFF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09DC14B128;
	Fri, 27 Aug 2021 10:57:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ao-xGjKouX+d; Fri, 27 Aug 2021 10:57:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E16A34B0C0;
	Fri, 27 Aug 2021 10:57:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D4D94B0A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 10:57:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KPUstyP3Rj7p for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 10:57:24 -0400 (EDT)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB7014B09C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 10:57:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=NSdJTnTrDORwb+LwDd1YsYwMgPCJRxx0pXYK8FlAauE=; b=Fa7lAXZuZMGlhMkvCLlAaInQ0M
 LvZMAI9dgp92KcFz4u2w541+/Nu67i2Ea3rAZpKD6Q1P9ILjKx8E7vJPC9Yy4BHzufUafcmzb+2zu
 XEqetUQrDWVmWgUJbeWVLi3VrFACkcynBo/GAIrkEDlonwYXZkgrnKNPnvuRXhzSenXsmorxKXv3b
 UaLmP8193HgPXArb5Wp1c/mrxTLlf/21JEFOup9O58miZONiwbcuapmO9GWG87OVfsWhj7CHiSkGX
 N5n6bqMpN0VhS93yWvq33V/48j5w+oHy6eCsh396wVtLrGJfjfA+JtKu/NF0o3UbeTizVS7b6v5Pe
 Ifw0PqQQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=noisy.programming.kicks-ass.net)
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mJdHk-00DX6q-CH; Fri, 27 Aug 2021 14:56:48 +0000
Received: from hirez.programming.kicks-ass.net
 (hirez.programming.kicks-ass.net [192.168.1.225])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (Client did not present a certificate)
 by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 06096300DEF;
 Fri, 27 Aug 2021 16:56:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
 id DA39829CFAC0B; Fri, 27 Aug 2021 16:56:45 +0200 (CEST)
Date: Fri, 27 Aug 2021 16:56:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 05/15] perf: Track guest callbacks on a per-CPU basis
Message-ID: <YSj9LQfbKxOhxqcP@hirez.programming.kicks-ass.net>
References: <20210827005718.585190-1-seanjc@google.com>
 <20210827005718.585190-6-seanjc@google.com>
 <YSiRBQQE7md7ZrNC@hirez.programming.kicks-ass.net>
 <YSj7jq32U8Euf38o@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YSj7jq32U8Euf38o@google.com>
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

On Fri, Aug 27, 2021 at 02:49:50PM +0000, Sean Christopherson wrote:
> On Fri, Aug 27, 2021, Peter Zijlstra wrote:
> > On Thu, Aug 26, 2021 at 05:57:08PM -0700, Sean Christopherson wrote:
> > > Use a per-CPU pointer to track perf's guest callbacks so that KVM can set
> > > the callbacks more precisely and avoid a lurking NULL pointer dereference.
> > 
> > I'm completely failing to see how per-cpu helps anything here...
> 
> It doesn't help until KVM is converted to set the per-cpu pointer in flows that
> are protected against preemption, and more specifically when KVM only writes to
> the pointer from the owning CPU.  

So the 'problem' I have with this is that sane (!KVM using) people, will
still have to suffer that load, whereas with the static_call() we patch
in an 'xor %rax,%rax' and only have immediate code flow.

> Ignoring static call for the moment, I don't see how the unreg side can be safe
> using a bare single global pointer.  There is no way for KVM to prevent an NMI
> from running in parallel on a different CPU.  If there's a more elegant solution,
> especially something that can be backported, e.g. an rcu-protected pointer, I'm
> all for it.  I went down the per-cpu path because it allowed for cleanups in KVM,
> but similar cleanups can be done without per-cpu perf callbacks.

If all the perf_guest_cbs dereferences are with preemption disabled
(IRQs disabled, IRQ context, NMI context included), then the sequence:

	WRITE_ONCE(perf_guest_cbs, NULL);
	synchronize_rcu();

Ensures that all prior observers of perf_guest_csb will have completed
and future observes must observe the NULL value.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
