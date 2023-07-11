Received: from out-39.mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7087E5CBC
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 07:29:46 +0000 (UTC)
Date: Tue, 11 Jul 2023 00:29:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689060584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KXeKcvXumYOLy91RwjIkTnj7Az1V2eIAsLtAwgWtlF4=;
	b=t6ZeqM+bPvAqJ4RIl0stbsKPSemiMT0MH02ymjk+rsFc/k5Ri9BL3RakTMe4L5Rtrm+XrN
	ZPMzyho6nsKAeRiK+7uFIk9k91XJB0QxytkVTNtyKw0pSNFxff6V3cJXsXgE8KZ3aqZwQS
	2RDsLuMbGsXWK7WG4XVVa1bYfnKCjNA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Use 'generic' vCPU target across all
 uarches
Message-ID: <ZK0E5VoHimicxZv1@linux.dev>
References: <20230710193140.1706399-1-oliver.upton@linux.dev>
 <86ilaqx605.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ilaqx605.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 11, 2023 at 08:27:22AM +0100, Marc Zyngier wrote:
> On Mon, 10 Jul 2023 20:31:36 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > kvm_vcpu_init::target is quite useless at this point. We don't do any
> > uarch-specific emulation in the first place, and require userspace
> > select the 'generic' vCPU target on all but a few implementations.
> > 
> > Small series to (1) clean up usage of the target value in the kernel and
> > (2) switch to the 'generic' target on implementations that previously
> > had their own target values. The implementation-specific values are
> > still tolerated, though, to avoid UAPI breakage.
> > 
> > v1: https://lore.kernel.org/kvmarm/20230623194258.2648987-1-oliver.upton@linux.dev/
> > 
> > v1 -> v2:
> >  - Set the generic v8 target in the kvm_vcpu_init struct initializer
> >    (Marc)
> >  - Use the kvm_vcpu_initialized() helper (Zenghui)
> >  - Collect Zenghui's ack/reviews (Thanks!)
> > 
> > Oliver Upton (4):
> >   KVM: arm64: Delete pointless switch statement in kvm_reset_vcpu()
> >   KVM: arm64: Remove pointless check for changed init target
> >   KVM: arm64: Replace vCPU target with a configuration flag
> >   KVM: arm64: Always return generic v8 as the preferred target
> > 
> >  arch/arm64/include/asm/kvm_host.h |  6 +++---
> >  arch/arm64/kvm/arm.c              | 24 +++++++++++-------------
> >  arch/arm64/kvm/guest.c            | 15 ---------------
> >  arch/arm64/kvm/hyp/nvhe/switch.c  |  2 +-
> >  arch/arm64/kvm/reset.c            | 25 ++++++++++---------------
> >  5 files changed, 25 insertions(+), 47 deletions(-)
> > 
> > 
> > base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
> 
> Looks great to me. This is 6.6 material, right? If so, I'll earmark it
> as such.

Yup, I don't think there's any amount of BS I can say to make this look
like a fix :)

--
Thanks,
Oliver
