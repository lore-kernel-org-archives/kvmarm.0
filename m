Received: from out-220.mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25755653
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 06:04:06 +0000 (UTC)
Date: Wed, 6 Sep 2023 06:03:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1693980244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sz1dEz51amxgl8u4MbjhfSRIzo+wFIPdJiGVXiPN2oc=;
	b=EJ5wecrMHeWERHJYByFrVHm6ApeXu0QDMUV8Vyw/HszWIrBM7WApWu25d5lv5Pf8Faj24E
	ClTt/toFuAW9prJz9vlPUmsu4JEsdV9RXKcExO3d2fQJgx/uvTAArm9d/KqmCAeyppT2BK
	ahN0cWfPM/4lxez1Pd3dBNCogpd97fU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: Marc Zyngier <maz@kernel.org>, KVM <kvm@vger.kernel.org>,
	KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v9 05/11] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
Message-ID: <ZPgWT6SfUHqPOjpg@linux.dev>
References: <20230821212243.491660-1-jingzhangos@google.com>
 <20230821212243.491660-6-jingzhangos@google.com>
 <878ra3pndw.wl-maz@kernel.org>
 <CAAdAUti8qSf0PVnWkp4Jua-te6i0cjQKJm=8dt5vWqT0Q6w4iQ@mail.gmail.com>
 <86a5uef55n.wl-maz@kernel.org>
 <CAAdAUtiNeVrPxThddhFPNNWjyf1hebYkXugdfV2K8LNnT0yaQg@mail.gmail.com>
 <CAAdAUtj386UcK+BBJDf+_00yYd1cbiQigSdAbssaJBmb+v32ng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdAUtj386UcK+BBJDf+_00yYd1cbiQigSdAbssaJBmb+v32ng@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 05, 2023 at 07:13:35PM -0700, Jing Zhang wrote:

[...]

> > > > I removed sanity checks across multiple fields after the discussion
> > > > here: https://lore.kernel.org/all/ZKRC80hb4hXwW8WK@thinky-boi/
> > > > I might have misunderstood the discussion. I thought we'd let VMM do
> > > > more complete sanity checks.
> > >
> > > The problem is that you don't even have a statement about how this is
> > > supposed to be handled. What are the rules? How can the VMM author
> > > *know*?
> > >
> > > That's my real issue with this series: at no point do we state when an
> > > ID register can be written, what are the rules that must be followed,
> > > where is the split in responsibility between KVM and the VMM, and what
> > > is the expected behaviour when the VMM exposes something that is
> > > completely outlandish to the guest (such as the M-profile debug).
> > >
> > > Do you see the issue? We can always fix the code. But once we've
> > > exposed that to userspace, there is no going back. And I really want
> > > everybody's buy-in on that front, including the VMM people.
> >
> > Understood.
> > Looks like it would be less complicated to have KVM do all the sanity
> > checks to determine if a feature field is configured correctly.
> > The determination can be done by following rules:
> > 1. Architecture constraints from ARM ARM.
> > 2. KVM constraints. (Those features not exposed by KVM should be read-only)
> > 3. VCPU features. (The write mask needs to be determined on-the-fly)
> 
> Does this sound good to you to have all sanity checks in KVM?

I would rather we not implement exhaustive checks in KVM, because we
*will* get them wrong. I don't believe Marc is asking for exhaustive
sanity checks in KVM either, just that we prevent userspace from
selecting features we will _never_ emulate (like the MProfDbg example).
You need very clear documentation for the usage pattern and what the
VMM's responsibilities are (like obeying the ARM ARM).

While we're here, I'll subject the both of you to one of the ongoing
thoughts I've had with the whole configurable CPU model UAPI. Ideally
we should get to the point where all emulation and trap configuration is
solely determined from the ID register values of the VM.

I'm a bit worried that this mixes poorly with userspace system register
accesses, though. As implemented, nothing stops userspce from
interleaving ID register writes with other system registers that might
be conditional on a particular CPU feature. For example, disabling the
PMU via DFR0 and then writing to the PMCs. Sure, this could be hacked
around by making PMCs visible to userspace only when the ID register
hides the feature, but we may be painting ourselves in a corner w.r.t.
the addition of new features.

One way out would be to make the ID registers immutable after
the first system register write outside of the ID register range.
Changes under the hood wouldn't be too terrible; AFAICT it involves
hoisting error checking into kvm_vcpu_init_check_features() and
deferring kvm_vcpu_reset() to the point the ID regs are immutable.

I somewhat like the clear order of operations, and it _shouldn't_ break
existing VMMs since they just save/restore the KVM values verbatim. Of
course, this requires some very clear documentation for VMMs that want
to adopt the new UAPI.

-- 
Thanks,
Oliver
