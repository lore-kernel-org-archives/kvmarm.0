Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E07192
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 00:53:17 +0000 (UTC)
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
Message-ID: <Y3WF8YlvFm8NGYHd@google.com>
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117002350.2178351-3-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221117005305.HGgMTW-oTW--Pk_dRnv2npcNbECXRLQ2v7fEn2puVNc@z>

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
