Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69FCDC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 08:14:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C60A74B8C1;
	Wed, 16 Nov 2022 03:14:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id re7Oi9YS9hrk; Wed, 16 Nov 2022 03:14:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A384C4B8CC;
	Wed, 16 Nov 2022 03:14:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59AE64B88B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 03:14:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0vhXsf-a4z6G for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 03:14:24 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BAF94B867
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 03:14:24 -0500 (EST)
Date: Wed, 16 Nov 2022 08:14:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668586463;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SmFKdEdkwEAGGvbba+Uew4TFmYCA4I8/v/XU6v8w0iw=;
 b=EiQC3QrF9TRB/NYfKenXrf+k5M2yFh3QICvTBjAHp2S2AgBjJTR7+0EESbrJW9MZnTM2ku
 HalxstlcPjFrhMFiUG6PeC1w/Rn21yzoE6U8m4RxGK2nKHc8gl9WjePXjwLsyGfzBN/HBd
 WcAO9UckNtb5AMRTHW2N9kDIujgjrjQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Don't acquire RCU read lock for exclusive
 table walks
Message-ID: <Y3Sb20U9rCIuOU3L@google.com>
References: <20221115225502.2240227-1-oliver.upton@linux.dev>
 <868rkbppdq.wl-maz@kernel.org> <Y3SQ3wogsVUEu1Qe@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3SQ3wogsVUEu1Qe@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org,
 Marek Szyprowski <m.szyprowski@samsung.com>
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

On Wed, Nov 16, 2022 at 07:27:27AM +0000, Oliver Upton wrote:
> On Wed, Nov 16, 2022 at 03:08:49AM +0000, Marc Zyngier wrote:
> > I'm not crazy about this sort of parameters. I think it would make a
> > lot more sense to pass a pointer to the walker structure and do the
> > flag check inside the helper.
> > 
> > That way, we avoid extra churn if/when we need extra state or
> > bookkeeping around the walk.
> 
> Sure, let's go that way instead. v3 on the way lol :)

Well, going this route is going to require hoisting around a few things.

I'd very much prefer to keep the RCU indirection ifdeffery all in one
place, but I'll need to haul it all after the definitions of kvm_pgtable_walker
and kvm_pgtable_walk_flags but before the definition of kvm_pgtable
(as it needs kvm_pteref_t).

I'm not too bothered by it, but not quite as small of a bandaid this
time around.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
