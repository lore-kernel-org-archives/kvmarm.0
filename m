Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BDFC432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 15:34:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF2C060FDA
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 15:34:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DF2C060FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71D194B12A;
	Fri, 27 Aug 2021 11:34:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xTisOGyH9wac; Fri, 27 Aug 2021 11:34:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D6324B10A;
	Fri, 27 Aug 2021 11:34:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C32604B0DF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 11:22:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D0UzXGPHBE84 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 11:22:39 -0400 (EDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95BF84B0C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 11:22:39 -0400 (EDT)
Received: by mail-pf1-f170.google.com with SMTP id g14so6005523pfm.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 08:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QatDM27fKYA9pWDzVSAqlJ2DDoFQbm13fmaaMfb9ulg=;
 b=LbfQeRJPD2tlThKAHYznAy0sM0IgIfh1wTpRJBZ2a8T56zVu98PuMUUVUbHs4fqFWr
 6+86/kLM/nQLlWQf9dDa+no5hVa+6sXIHhmX9R3rM1SD9hRro8HWA2j/NGyx2O8VrgV+
 oGP6lA9WOmK8FVw2oSIVs+avOR5GJ+s6JTH9S2ut8a2dmjwSmakGT8siao8WSM0rYY/D
 l8AtqZP9IsjFRz1XRX7SFZjz8ry7nluU0QO8loudJxQXIIhTLPgOJCI+sU7b8vw4rsbo
 7ceZSl6gyIwnJ0+ZB+tg2Cex82NuQqvIiek/SOq2xNCKjHmmV/miz2C81kIq6WQooMor
 pjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QatDM27fKYA9pWDzVSAqlJ2DDoFQbm13fmaaMfb9ulg=;
 b=O51zXcHTg0CcoWzBydU67JGJZlWDpsN6PxXS+kVcmvoSIKCgaexrdGAz/4A95TI/J8
 l/BKUWEQ/kF/FgEcmSexkdQ7Y8ZtBPifmj1bb4/MUuUSq6NsMMU8Ye5UNanW2qwQE14L
 16MHKF5DWGYpm86BzdFFezPEBei+fTwJFZHcHnGbwwfxgEbFpQSqiQY4ZS92B9Gdwydy
 X2+MljNjLySKU5gWXn/XwJ3rNNix04OFhxUOwiqeIDFanz1KDzK8BDclC/010NJJBEiR
 u17CUX1wAJOkJvpGLEB2yQZ9iawYGXye+ellI46SFBCTKFP+U1JoylR/nzN4Ga9heYOC
 2Q1Q==
X-Gm-Message-State: AOAM532YgerCDiuGux6ct53PbR90yP+X5yIQGHtx3n/VASac2rOdkSAB
 lGMqVIR6xOFUdQUvinjeZC7+sg==
X-Google-Smtp-Source: ABdhPJzEumx17gqrFfS4IgX2tHxkXDWTQYfyqElR8d63vRz/R/VGX/kHlh1uWjTReV2Ta0/ixjnVag==
X-Received: by 2002:a05:6a00:26f6:b0:3ed:834e:153 with SMTP id
 p54-20020a056a0026f600b003ed834e0153mr9605926pfw.53.1630077758383; 
 Fri, 27 Aug 2021 08:22:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id q3sm7448697pgf.18.2021.08.27.08.22.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 27 Aug 2021 08:22:37 -0700 (PDT)
Date: Fri, 27 Aug 2021 15:22:33 +0000
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 05/15] perf: Track guest callbacks on a per-CPU basis
Message-ID: <YSkDOWze5dBHkJnA@google.com>
References: <20210827005718.585190-1-seanjc@google.com>
 <20210827005718.585190-6-seanjc@google.com>
 <YSiRBQQE7md7ZrNC@hirez.programming.kicks-ass.net>
 <YSj7jq32U8Euf38o@google.com>
 <YSj9LQfbKxOhxqcP@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YSj9LQfbKxOhxqcP@hirez.programming.kicks-ass.net>
X-Mailman-Approved-At: Fri, 27 Aug 2021 11:34:48 -0400
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

On Fri, Aug 27, 2021, Peter Zijlstra wrote:
> On Fri, Aug 27, 2021 at 02:49:50PM +0000, Sean Christopherson wrote:
> > On Fri, Aug 27, 2021, Peter Zijlstra wrote:
> > > On Thu, Aug 26, 2021 at 05:57:08PM -0700, Sean Christopherson wrote:
> > > > Use a per-CPU pointer to track perf's guest callbacks so that KVM can set
> > > > the callbacks more precisely and avoid a lurking NULL pointer dereference.
> > > 
> > > I'm completely failing to see how per-cpu helps anything here...
> > 
> > It doesn't help until KVM is converted to set the per-cpu pointer in flows that
> > are protected against preemption, and more specifically when KVM only writes to
> > the pointer from the owning CPU.  
> 
> So the 'problem' I have with this is that sane (!KVM using) people, will
> still have to suffer that load, whereas with the static_call() we patch
> in an 'xor %rax,%rax' and only have immediate code flow.

Again, I've no objection to the static_call() approach.  I didn't even see the
patch until I had finished testing my series :-/

> > Ignoring static call for the moment, I don't see how the unreg side can be safe
> > using a bare single global pointer.  There is no way for KVM to prevent an NMI
> > from running in parallel on a different CPU.  If there's a more elegant solution,
> > especially something that can be backported, e.g. an rcu-protected pointer, I'm
> > all for it.  I went down the per-cpu path because it allowed for cleanups in KVM,
> > but similar cleanups can be done without per-cpu perf callbacks.
> 
> If all the perf_guest_cbs dereferences are with preemption disabled
> (IRQs disabled, IRQ context, NMI context included), then the sequence:
> 
> 	WRITE_ONCE(perf_guest_cbs, NULL);
> 	synchronize_rcu();
> 
> Ensures that all prior observers of perf_guest_csb will have completed
> and future observes must observe the NULL value.

That alone won't be sufficient, as the read side also needs to ensure it doesn't
reload perf_guest_cbs between NULL checks and dereferences.  But that's easy
enough to solve with a READ_ONCE and maybe a helper to make it more cumbersome
to use perf_guest_cbs directly.

How about this for a series?

  1. Use READ_ONCE/WRITE_ONCE + synchronize_rcu() to fix the underlying bug
  2. Fix KVM PT interrupt handler bug
  3. Kill off perf_guest_cbs usage in architectures that don't need the callbacks
  4. Replace ->is_in_guest()/->is_user_mode() with ->state(), and s/get_guest_ip/get_ip
  5. Implement static_call() support
  6. Cleanups, if there are any
  6..N KVM cleanups, e.g. to eliminate current_vcpu and share x86+arm64 callbacks
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
