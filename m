Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C425C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Nov 2022 18:47:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5FEC4B8D2;
	Tue, 15 Nov 2022 13:47:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7GW2a5f0M+vo; Tue, 15 Nov 2022 13:47:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E8864B897;
	Tue, 15 Nov 2022 13:47:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2C84B857
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 13:47:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dVJ0CtjttlsN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 13:47:42 -0500 (EST)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45A614B84C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 13:47:42 -0500 (EST)
Received: by mail-pg1-f181.google.com with SMTP id b62so14136938pgc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 10:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=AkKPIWHeRn4hniFMrnTGIvHiqEhhgn36keNoZHXH3oI=;
 b=hDLtK/CfhXpByl5cdJHj5fS6CRLCYmzHAAmcDFoAq0ZWMqmrPakIcZ7dyCKeczjCoU
 ijVNKn8k2kccZk6ZkpitihnY2qlj8f7j/fPfk2POgyWKHBUnkCSOh3kueO1ZX0g2IL30
 IAZEpHmHEfgTXiDQzQNlTqmTr/xibzlUqGu9uaxhaxHk8xDxgoeBTrvt0pL0N7vlKXdU
 3uAjS/AJ/zsByV84zOyxr3NkKiC6ze5xAjSZ2QbeaVlSdAW3PAoa6n0F287ykgDHtDS7
 AHuAbh6r6PuJ+clQieWCi5h1ryW4s/uVIwz//7XkCgod/d5XMjb1T6loNU4sDlNJDlsd
 wNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=AkKPIWHeRn4hniFMrnTGIvHiqEhhgn36keNoZHXH3oI=;
 b=PwyuixR9bcoviS7Fjo2ImJNjGwaFg25EmOF3/j4pLpBSJ0l5E/KNog5j8kNC9dSkX/
 lAR+EyCf1FEbCtk6EgSygvH3E0fKbKCj8BoDWIA4+HMYgD7HLSZrgO+3lKaShIYfuvVk
 Fw5Ap/Fuqir8IxC2/r1V69sW+WCThfYBiSbgQ5xW6hPAjSWng4iCJrZIvg9NSeWyZcSV
 smxur/M9LOSe/2ZQ2LEgB0L7orzaoGOGVPCEY9ubwJ73eq5PMJy7AFFoxb/ZYUegNhq0
 vYw05lNpU2ebe67wL+fiiFBZn1dikq6ZMwY2EodgeSKLnLuHt6YSfk8FYtQ8DxilAaJn
 gYzQ==
X-Gm-Message-State: ANoB5pnh1L8SrvmELC7+RL3Lp8bxiGIPeZIPc9P9t2O6mJJSE7u2Aj4E
 SoA+EIy+uUFMtpOvmvllpmRGQg==
X-Google-Smtp-Source: AA0mqf5ewUFxFuYZmhYALZjNpcyEotKOZbibubDZGdomI5FE4JI3gXz3HN+ZL/JWRORbOZ+Q96LHew==
X-Received: by 2002:a62:bd19:0:b0:56e:a001:8cb0 with SMTP id
 a25-20020a62bd19000000b0056ea0018cb0mr19447236pff.60.1668538061122; 
 Tue, 15 Nov 2022 10:47:41 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 o38-20020a634e66000000b004639c772878sm8147241pgl.48.2022.11.15.10.47.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Nov 2022 10:47:40 -0800 (PST)
Date: Tue, 15 Nov 2022 10:47:37 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y3PeyV4KIjoBBYNV@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <Y2whaWo3SIOOMKOE@google.com> <Y2w98zPmtefJlNfa@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y2w98zPmtefJlNfa@google.com>
Cc: kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Nov 09, 2022 at 11:55:31PM +0000, Oliver Upton wrote:
> On Wed, Nov 09, 2022 at 09:53:45PM +0000, Sean Christopherson wrote:
> > On Mon, Nov 07, 2022, Oliver Upton wrote:
> > > Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> > > release the RCU read lock when traversing the page tables. Defer the
> > > freeing of table memory to an RCU callback. Indirect the calls into RCU
> > > and provide stubs for hypervisor code, as RCU is not available in such a
> > > context.
> > > 
> > > The RCU protection doesn't amount to much at the moment, as readers are
> > > already protected by the read-write lock (all walkers that free table
> > > memory take the write lock). Nonetheless, a subsequent change will
> > > futher relax the locking requirements around the stage-2 MMU, thereby
> > > depending on RCU.
> > 
> > Two somewhat off-topic questions (because I'm curious):
> 
> Worth asking!
> 
> >  1. Are there plans to enable "fast" page faults on ARM?  E.g. to fixup access
> >     faults (handle_access_fault()) and/or write-protection faults without acquiring
> >     mmu_lock?
> 
> I don't have any plans personally.
> 
> OTOH, adding support for read-side access faults is trivial, I just
> didn't give it much thought as most large-scale implementations have
> FEAT_HAFDBS (hardware access flag management).

WDYT of permission relaxation (write-protection faults) on the fast
path?

The benefits won't be as good as in x86 due to the required TLBI, but
may be worth it due to not dealing with the mmu lock and avoiding some
of the context save/restore.  Note that unlike x86, in ARM the TLB entry
related to a protection fault needs to be flushed.

> 
> >  2. If the answer to (1) is "yes!", what's the plan to protect the lockless walks
> >     for the RCU-less hypervisor code?
> 
> If/when we are worried about fault serialization in the lowvisor I was
> thinking something along the lines of disabling interrupts and using
> IPIs as barriers before freeing removed table memory, crudely giving the
> same protection as RCU.
> 
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
