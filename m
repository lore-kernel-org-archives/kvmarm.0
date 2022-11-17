Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE33C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 00:53:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 180924B82F;
	Wed, 16 Nov 2022 19:53:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2q4ZH4tTOViN; Wed, 16 Nov 2022 19:53:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF2134B7F8;
	Wed, 16 Nov 2022 19:53:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9044B7E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 19:53:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u8ZvYLA6fAs2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 19:53:16 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 670FB4B7E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 19:53:16 -0500 (EST)
Date: Thu, 17 Nov 2022 00:53:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668646395;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=9w7G+RKrt6/0HCKLnjPutAV/rlAGAe32flfBEfmtnv8=;
 b=b829zptC3O+9DM0djao1VXWtUd9yQZCLJ0iTnicGDk6kS0jfrCkKFVos4k5N+1z3/+BWrA
 k+imAyUjuM1YCw7shdK4v9BdLNUew96BAc+lw/OE/Wt3G3K8UXmvbi26TtxB+z1h0qXI0F
 MH99Vwj6tHqavnVM9+gO2jNkoZprpcI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
Message-ID: <Y3WF8YlvFm8NGYHd@google.com>
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-3-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221117002350.2178351-3-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Nov 17, 2022 at 12:23:50AM +0000, Sean Christopherson wrote:
> Automatically disable single-step when the guest reaches the end of the
> verified section instead of using an explicit ucall() to ask userspace to
> disable single-step.  An upcoming change to implement a pool-based scheme
> for ucall() will add an atomic operation (bit test and set) in the guest
> ucall code, and if the compiler generate "old school" atomics, e.g.

Off topic, but I didn't ask when we were discussing this issue. What is
the atomic used for in the pool-based ucall implementation?

>   40e57c:       c85f7c20        ldxr    x0, [x1]
>   40e580:       aa100011        orr     x17, x0, x16
>   40e584:       c80ffc31        stlxr   w15, x17, [x1]
>   40e588:       35ffffaf        cbnz    w15, 40e57c <__aarch64_ldset8_sync+0x1c>
> 
> the guest will hang as the local exclusive monitor is reset by eret,
> i.e. the stlxr will always fail due to the VM-Exit for the debug
> exception.

... due to the debug exception taken to EL2.

What's a VM-Exit anyways? ;-)

> Link: https://lore.kernel.org/all/20221006003409.649993-8-seanjc@google.com
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

With the commit message nit:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
