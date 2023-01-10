Received: from out-41.mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A1515A7
	for <kvmarm@lists.linux.dev>; Tue, 10 Jan 2023 02:09:49 +0000 (UTC)
Date: Tue, 10 Jan 2023 01:46:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673315206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SSeiwC3s3cJoXlLV8jS7SBzzL1+BanzZceIbNoX9d3k=;
	b=H1u4fUJdXGGjVE1x4tl17b3T09Yzmb9uqfxFo7mXxELZBVaxhxxEwXLFdSJKWRfKPh43l/
	0oUr2pQectj9J2sz4fQdhlLTTCo99pdqv6t1FDHSJa37L/th0vJVMyBwxmm+o05zpaNbEm
	VKVtmOVySzREnwin81U4TRlwqdYZdb0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 2/7] KVM: arm64: PMU: Use reset_pmu_reg() for
 PMUSERENR_EL0 and PMCCFILTR_EL0
Message-ID: <Y7zDgdmURNztXseL@google.com>
References: <20221230035928.3423990-1-reijiw@google.com>
 <20221230035928.3423990-3-reijiw@google.com>
 <Y7sVx8sv2BYiMihZ@thinky-boi>
 <CAAeT=Fxnkn++j6MObaAhHwb4nTf-g9XGOgzr0NYpA5K6hicFkg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fxnkn++j6MObaAhHwb4nTf-g9XGOgzr0NYpA5K6hicFkg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 09, 2023 at 05:17:59PM -0800, Reiji Watanabe wrote:
> On Sun, Jan 8, 2023 at 11:13 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Thu, Dec 29, 2022 at 07:59:23PM -0800, Reiji Watanabe wrote:
> > > The default reset function for PMU registers (reset_pmu_reg())
> > > now simply clears a specified register. Use that function for
> > > PMUSERENR_EL0 and PMCCFILTR_EL0, since those registers should
> > > simply be cleared on vCPU reset.
> >
> > AFAICT, the fields in both these registers have UNKNOWN reset values. Of
> > course, 0 is an entirely valid reset value but the architectural
> > behavior should be mentioned in the commit message.
> 
> Uh, yeah, the commit message was misleading.
> The fields in both these registers have UNKNOWN reset values.
> The ones for 32bit registers (PMUSERENR and PMCCFILTR) have zero reset
> values though.

Gosh, that silly (but highly relevant) detail escaped me.

> I will update the commit message to mention those explicitly.

Thanks!

--
Best,
Oliver
