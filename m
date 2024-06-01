Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7008C153BFD
	for <kvmarm@lists.linux.dev>; Sat,  1 Jun 2024 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717261063; cv=none; b=UFlUspXt+hoY1+q2fqSXOd9veJAjW45RrYV70Bbr/3wGWejz4+94PAVloFx1RKA0VeIg2k9+W/qFKBEsEdVx2d++ZSAIrJZVYMtuSc0Pq3xaaESAsTNlRcZKk2mnZDdI2frUP2Cb9+ADk39aGUqj5UJM5Ut8/joG2EU1LBRjFIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717261063; c=relaxed/simple;
	bh=wVotdO9j7tE4AWW7SQJUOkpiSWjoHozRLSzU4NvGP0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uE51XvmjDWtu04StMSiEY6hVoG4g3U7Xy6qmRx8/iPRYu+HN6IZYuD14w4upd1DBzbllGsMegYbYAX+ruWYEjN1chMYTOihIHv6kNbMiH+qmI1zN+LCNHuME98yOXJ85pMGcBdJXaH3wvgEioNewYDH2IsMHBz2DbKHwkLYQGeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LH4oHneY; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LH4oHneY"
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717261059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eu63+ui3NCNu/cbwzFZGKRgGHoolaynM1Ff68oWiYRs=;
	b=LH4oHneYCEKESsjPUtWSAEG6b6cW49IqWf/sdyIQXyJ5cXUSHuNCVOCJ4CfFKB2qKsRSCx
	etXHC+W4DQ90aQ8iL4O75p5dvTrgo31uwVu3Iv6C9WjR9ZJN3a7Vb2leugU2k+xLutKRw6
	fJL0kYbBCEITF12vafrBWJ326x5zaoA=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
Date: Sat, 1 Jun 2024 09:57:31 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 00/11] KVM: arm64: nv: FPSIMD/SVE support
Message-ID: <ZltS-7c4cSBdMqfh@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
 <87jzj92c5q.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jzj92c5q.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 01, 2024 at 11:24:49AM +0100, Marc Zyngier wrote:
> On Sat, 01 Jun 2024 00:13:47 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Hey!
> > 
> > I've decided to start messing around with nested and have SVE support
> > working for a nested guest. For the sake of landing a semi-complete
> > feature upstream, I've also picked up the FPSIMD patches from the NV
> > series Marc is carrying.
> > 
> > The most annoying part about this series (IMO) is that ZCR_EL2 traps
> > behave differently from what needs to be virtualized for the guest when
> > HCR_EL2.NV = 1, as it takes a sysreg trap (EC = 0x18) instead of an SVE
> > trap (EC = 0x19). So, we need to synthesize the ESR value when
> > reflecting back into the guest hypervisor.
> 
> That's unfortunately not a unique case. The ERETAx emulation already
> requires us to synthesise the ESR on PAC check failure, and I'm afraid
> ZCR_EL2 might not be the last case.
> 
> In general, we'll see this problem for any instruction or sysreg that
> can generate multiple exception classes.

Right, I didn't have a good feel yet for whether or not we could add
some generalized infrastructure for 'remapping' ESR values for the guest
hypervisor. Of course, not needed for this, but cooking up an ISS is
likely to require a bit of manual intervention.

> > Otherwise, some care is required to slap the guest hypervisor's ZCR_EL2
> > into the right place depending on whether or not the vCPU is in a hyp
> > context, since it affects the hyp's usage of SVE in addition to the VM.
> > 
> > There's more work to be done for honoring the L1's CPTR traps, as this
> > series only focuses on getting SVE and FPSIMD traps right. We'll get
> > there one day.
> 
> I have patches for that in my NV series, which would take the place of
> patches 9 and 10 in your series (or supplement them, depending on how
> we want to slice this).

That'd be great, I just wanted to post something focused on FP/SVE to
start but...

> > 
> > I tested this using a mix of the fpsimd-test and sve-test selftests
> > running at L0, L1, and L2 concurrently on Neoverse V2.
> 
> Thanks a lot for tackling this. It'd be good to put together a series
> that has the EL2 sysreg save/restore patches as a prefix of this, plus
> the CPTR_EL2 changes. That way, we'd have something that can be merged
> as a consistent set.

I'd be happy to stitch together something like this to round out the
feature. I deliberately left out the handling of vEL2 registers because
of the CPACR_EL1 v. CPTR_EL2 mess, but we may as well sort that out.

Did you want to post your CPTR bits when you have a chance?

-- 
Thanks,
Oliver
