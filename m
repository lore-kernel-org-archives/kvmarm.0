Received: from out-46.mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308A0BA32
	for <kvmarm@lists.linux.dev>; Fri, 24 Feb 2023 21:42:55 +0000 (UTC)
Date: Fri, 24 Feb 2023 21:42:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1677274973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WmSQFrDiHOhPNR+S34Fx8sranVsqnTdjDl048iCZQWc=;
	b=Ey6v7axCvWWDPveM9+7PWfKV6yHQhB0E5/5wgQXKpj6xIfgmY4WHtT1IUljq6W/mP2VSj/
	iq/PZFzAnMpG+cCu9RiJ0a/hGSFqY2QwctDAGhy85sJuFT/Wkg8HCj4hMk9JvjY6WkpOBM
	pOJxqP8c0QBf3c8/jHJo28KqKcTUmHk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [RFC PATCH v2 5/6] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Message-ID: <Y/kvWNH2sIySgudd@linux.dev>
References: <20230211013759.3556016-1-oliver.upton@linux.dev>
 <20230211013759.3556016-6-oliver.upton@linux.dev>
 <b10d117a-3d3d-c273-9885-3bfecfa8304d@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b10d117a-3d3d-c273-9885-3bfecfa8304d@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi James,

On Fri, Feb 24, 2023 at 03:12:33PM +0000, James Morse wrote:
> On 11/02/2023 01:37, Oliver Upton wrote:
> > +static void kvm_prepare_hypercall_exit(struct kvm_vcpu *vcpu, u32 func_id, bool smc)
> > +{
> > +	struct kvm_run *run = vcpu->run;
> > +
> > +	run->exit_reason = KVM_EXIT_HYPERCALL;
> 
> > +	run->hypercall.nr = func_id;
> 
> This is a bit weird. The func_id is the x0 value, so it would more naturally live in
> run->hypercall.args[0].
> 
> User-space also needs the SMC/HVC immediate value, as that is only available in the ESR.
> It makes more sense to put the immediate value here.

Completely buy that userspace has no way of getting at the immediate.
But why do we need to expose it in the first place?

The UAPI here has been constructed around SMCCC, so the immediate should
be zero across the board. Sure, SMCCC says that nonzero values can be
used by the hypervisor, but in that case the register interface needn't
follow SMCCC (i.e. what if the function ID is in x7 for some silly
reason).

Curious if there's a use case you had in mind I haven't thought of.

> > +	if (smc)
> > +		run->hypercall.flags = KVM_HYPERCALL_EXIT_SMC;

Drive by self-review (be warned!): flags needs explicit zeroing,
otherwise this flag will remain up for a subsequent HVC.

-- 
Thanks,
Oliver
