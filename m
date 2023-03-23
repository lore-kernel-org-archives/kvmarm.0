Received: from out-21.mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7168F4A
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 20:45:58 +0000 (UTC)
Date: Thu, 23 Mar 2023 20:45:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679604355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eTQwABadeBKFNTm3EY/dRBPaZ0090mrkCE25izbSHEU=;
	b=VcU0bSkyWGTiQb7KhH5J5lh1GvLpmUATCcj/R5fbst10j92GpuP6M0uWq3j9KzsiHSrWCh
	GtkTeR/A2LFHPCXaDtOb00o1KsKxHV1aMGj9gSTH/8n5BbMKYITRTd1iKpC5y9UQQo8MzF
	4JDvhTSd1tzlPwS1B2NvrW89fQVrHW0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jeremy Linton <jeremy.linton@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: Avoid lock inversion when setting the
 VM register width
Message-ID: <ZBy6f1XoO1b4zts1@linux.dev>
References: <20230316211412.2651555-1-oliver.upton@linux.dev>
 <20230316211412.2651555-3-oliver.upton@linux.dev>
 <5b355d9f-0191-2631-9745-5ed2d10af0e1@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b355d9f-0191-2631-9745-5ed2d10af0e1@arm.com>
X-Migadu-Flow: FLOW_OUT

Jeremy,

On Thu, Mar 23, 2023 at 03:09:54PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 3/16/23 16:14, Oliver Upton wrote:
> > kvm->lock must be taken outside of the vcpu->mutex. Of course, the
> > locking documentation for KVM makes this abundantly clear. Nonetheless,
> > the locking order in KVM/arm64 has been wrong for quite a while; we
> > acquire the kvm->lock while holding the vcpu->mutex all over the shop.
> > 
> > All was seemingly fine until commit 42a90008f890 ("KVM: Ensure lockdep
> > knows about kvm->lock vs. vcpu->mutex ordering rule") caught us with our
> > pants down, leading to lockdep barfing:
> 
> Thanks for looking at this! It had a bit of fuzz applying to -rc3, did I
> miss a required patch?
> 
> This patch makes the lockdep warnings I was seeing go away but I'm seeing
> similar lockdep problem while running the kvm kselftests. In particular I
> think it was "selftests: kvm: debug-exceptions" which threw the warning.

Hmm, that's odd. IIRC the only test that exploded for me w/o the commit
below was arch_timer.

> So, i'm not sure its completely fixed. I ran the previous one a couple weeks
> back before you respun it, and IIRC didn't see any errors.

Thanks for taking this for a spin! This series depends on commit 47053904e182
("KVM: arm64: timers: Convert per-vcpu virtual offset to a global value")
which is only present in kvmarm/fixes at the moment. I had sent out a PR for
this last week but Paolo has yet to pull.

With both Marc's patch and this series I'm unable to reproduce lockdep
warnings w/ selftests or kvmtool. If it isn't too much trouble can you
give kvmarm/fixes plus this series a whirl and see if everything is
addressed?

Otherwise you may have stumbled into some more crud we'll need to
address :)

-- 
Thanks,
Oliver
