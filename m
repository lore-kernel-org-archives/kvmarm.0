Received: from out-29.mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CA72C80
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 23:32:37 +0000 (UTC)
Date: Fri, 14 Jul 2023 23:32:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689377555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b0G9603as9HZxrqxCYf6z57wcqzewxrX/eX6lESvNIo=;
	b=Uj05WRQPlHNrzB64iI0KJKbYDtWDjjMW/i278PHAqfAv/SrflNnucBi46MguW3dQG3xQ5o
	Tc7R7V9m6s9A8rZBBP+BV007iCsGU9tfQ682FUDyANzBBBo+nW3uhAXi1lCp9Rd8NRbvsk
	LFoOSuJhUeVmSyFBHKP+522QpI5AW6k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, rananta@google.com
Subject: Re: [PATCH] KVM: arm64: Correctly handle RES0 bits
 PMEVTYPER<n>_EL0.evtCount
Message-ID: <ZLHbEJ8rPVwblk00@linux.dev>
References: <20230713221649.3889210-1-oliver.upton@linux.dev>
 <CAAeT=FxwcxagQ4a4s1Ew6dvN+yRGS+7tAkVjtfR8Shd-P_V5Og@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAeT=FxwcxagQ4a4s1Ew6dvN+yRGS+7tAkVjtfR8Shd-P_V5Og@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 14, 2023 at 06:46:39AM -0700, Reiji Watanabe wrote:
> On Thu, Jul 13, 2023 at 3:17 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > The PMU event ID varies from 10 to 16 bits, depending on the PMU
> > version. If the PMU only supports 10 bits of event ID, bits [15:10] of
> > the evtCount field behave as RES0.
> >
> > While the actual PMU emulation code gets this right (i.e. RES0 bits are
> > masked out when programming the perf event), the sysreg emulation writes
> > an unmasked value to the in-memory cpu context. The net effect is that
> > guest reads and writes of PMEVTYPER<n>_EL0 will see non-RES0 behavior in
> > the reserved bits of the field.
> >
> > As it so happens, kvm_pmu_set_counter_event_type() already writes a
> > masked value to the in-memory context that gets overwritten by
> > access_pmu_evtyper(). Fix the issue by removing the unnecessary (and
> > incorrect) register write in access_pmu_evtyper().
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks!

> FYI. Looking at their reset values, fortunately, the pseudo
> "unknown" reset values used by reset_pmevtyper() has the
> bits [16:11] cleared.
> I would think it's a bit fragile, but not a real problem.

Fragile indeed. I'd like to clean up the handling a bit more in the
future, because it makes no sense why we mask the value read from
__vcpu_sys_reg() for emulated reads.

-- 
Thanks,
Oliver
