Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662F1439F86;
	Wed, 30 Sep 2026 11:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790766186; cv=none; b=FmbyMKtU/N4GgtKceuk17PN/aVcN3CnN5sKr5s61b9FPoUIKcpCwxXAvj/Z98QQZtr7Nb+qRg8q/GDWVKwHTWCvZSU6GRthBLC47qgfM96mX5/n6xkjCgGcSrH2XbM1JvzdG+MMTMqbT/DhwqCaldcyKS/KCZ3EcCTzgSB4SCw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790766186; c=relaxed/simple;
	bh=d/ZqsJkhTu9Q1JG0R55H06EvsSQWPRW2DAbAsYcuplE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bN38NkxBav4Q94rjxJqZjtcuRPVL5Q3H7fOYNX46/xro/GJ/68MLCsgmfWW/nAcsaHQUUVhaNx/xc8MK90+bCeJ5OrB2yZuafYmv/j7D6/RjhOVQ86lq1K2KdqqtSSt6l3BMEWI1WF3RR3udbCurc48uQNptreb086mWlWdAAD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=et/efCJQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="et/efCJQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B8B2497;
	Wed, 30 Sep 2026 04:02:46 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D616F3F85F;
	Wed, 30 Sep 2026 04:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790766169; bh=d/ZqsJkhTu9Q1JG0R55H06EvsSQWPRW2DAbAsYcuplE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=et/efCJQXCQlPg6gHb8rQgmvT/x/p77iTa1oktgGtlWhzItbU2V/d5w0r8WE4M7M9
	 EyEL3JDBR1EcqKWnGd48RLTzbpJ8EN6o3pi2I6ntKTm+Hm+dm51eyXgikGAhBk+TuZ
	 gFmqABZdMfWVc19c+SkZBFNQDUvMm+jm01vlncqk=
Date: Wed, 30 Sep 2026 12:02:41 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v20 2/9] firmware: arm_rmm: Check for RMI support at init
Message-ID: <arzsUdIEVvafG-S5@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-3-suzuki.poulose@arm.com>
 <20260929222840.A0E821F000FF@smtp.kernel.org>
 <a2fa2bd1-6888-4ed5-9e2f-233eacb600a5@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2fa2bd1-6888-4ed5-9e2f-233eacb600a5@arm.com>

On Wed, Sep 30, 2026 at 09:18:48AM +0100, Suzuki K Poulose wrote:
> On 29/09/2026 23:28, sashiko-bot@kernel.org wrote:
> > > diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> > > new file mode 100644
> > > index 0000000000000..911489b636522
> > > --- /dev/null
> > > +++ b/include/linux/arm-rmi-cmds.h
> > [ ... ]
> > > +static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
> > > +{
> > > +	struct arm_smccc_1_2_regs args = *regs;
> > > +	long status;
> > > +	int i = 0;
> > > +
> > > +	while (i < RMM_BLOCKED_RETRY_COUNT) {
> > > +		arm_smccc_1_2_invoke(&args, regs);
> > > +
> > > +		status = RMI_RESULT_STATUS(regs->a0);
> > > +		if (status != RMI_BUSY && status != RMI_BLOCKED)
> > > +			break;
> > > +		if (status == RMI_BLOCKED)
> > > +			i++;
> > > +		cpu_relax();
> > > +	}
> > 
> > [Severity: High]
> > Does this sequence create an unbounded spin loop if the firmware continuously
> > returns RMI_BUSY?
> > 
> > If the status returned by arm_smccc_1_2_invoke() is RMI_BUSY, the loop
> > continues without incrementing the exit counter i. It issues cpu_relax()
> > but does not yield the CPU (e.g., via cond_resched()) or impose a timeout.
> > If the RMM firmware remains busy, this could cause the host kernel to lock
> > up indefinitely.
> 
> This is like "spinlock contention". RMM returns EBUSY when a resource is
> locked temporarily. We should be able to make progress, unlike the
> RMI_BLOCKED, which is blocking due to a long running operation.

I dug a bit into the RMI_BUSY description in the spec and it's not
always safe to spin forever. For RMI_{PDEV,VDEV}_COMMUNICATE, for
example, we need to return to the caller and retry later (for VDEV, the
spec suggests informing the realm). That's the TSM series, which doesn't
use the new API yet, but something to be aware of when it's updated.

We may need the spec to bound this spin anyway, or at least give an
indication that it's not forever, otherwise it affects latency,
especially in an RT kernel.

There's a generic RMI command return code table in B4.2 that lists
RMI_BUSY for an imp def reason for the command failing to make progress.
Does this apply to something like REC_ENTER? In the KVM series we call
that with IRQs masked.

We might need different APIs here: one for sleepable callers that does
cond_resched() (or backs off) while retrying, and one that returns
-EBUSY, e.g. for TSM, or for commands like REC_ENTER that we don't
expect to see RMI_BUSY and don't want to spin on.

-- 
Catalin
