Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9F52367D7
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 09:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760088973; cv=none; b=DvmvkpG42dFw0xXBKyRomNZDxsQJSOtJ6y+cXUKI0TOBqynZY5r/keXG0MdhSS/FFh5ZS1zbUrfL2Wz3drzAsq61odvmG7af+m/VFTJpCfOIBQoeJR+/mMY9KL9wjx7SDyizc63wDG9eQ0MMLNYxrAP5LksM56yE+/j2VRoIrZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760088973; c=relaxed/simple;
	bh=DZmLp7oCNNsiQ4JHVx+qEByTqktU3gfT/F8tnerBTAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/4mcAkSeD8nVGT7bWe+UKlRMXrHE/8/9PLpKDzjDSJhyjxpvzCCkkuzgV81gB1aX9WjV0RfKjZVYJO3WacBB0mZeX2EowWR+nDkIzJY0dxXDOjDe+abXr12yl+J+wvaQ+HwLyhELE36jlU88B9ACqkn5ZhMdDdmyBYk3S4Na/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAB241595;
	Fri, 10 Oct 2025 02:36:02 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E03CE3F738;
	Fri, 10 Oct 2025 02:36:08 -0700 (PDT)
Date: Fri, 10 Oct 2025 10:36:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jan Kotas <jank@cadence.com>
Subject: Re: [PATCH] arm64: Revamp HCR_EL2.E2H RES1 detection
Message-ID: <aOjTg3he873VqEgY@J2N7QTR9R3>
References: <20251009121239.29370-1-maz@kernel.org>
 <aOgpesxEKsnbKGs3@linux.dev>
 <86ldljxgad.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ldljxgad.wl-maz@kernel.org>

On Fri, Oct 10, 2025 at 10:22:18AM +0100, Marc Zyngier wrote:
> On Thu, 09 Oct 2025 22:30:34 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Hey,
> > 
> > On Thu, Oct 09, 2025 at 01:12:39PM +0100, Marc Zyngier wrote:
> > > We currently have two ways to identify CPUs that only implement FEAT_VHE
> > > and not FEAT_E2H0:
> > > 
> > > - either they advertise it via ID_AA64MMFR4_EL1.E2H0,
> > > - or the HCR_EL2.E2H bit is RAO/WI
> > > 
> > > However, there is a third category of "cpus" that fall between these
> > > two cases: on CPUs that do not implement FEAT_FGT, it is IMPDEF whether
> > > an access to ID_AA64MMFR4_EL1 can trap to EL2 when the register value
> > > is zero.
> > > 
> > > A consequence of this is that on systems such as Neoverse V2, a NV
> > > guest cannot reliably detect that it is in a VHE-only configuration
> > > (E2H is writable, and ID_AA64MMFR0_EL1 is 0), despite the hypervisor's
> > > best effort to repaint the id register.
> > > 
> > > Replace the RAO/WI test by a sequence that makes use of the VHE
> > > register remnapping between EL1 and EL2 to detect this situation,
> > > and work out whether we get the VHE behaviour even after having
> > > set HCR_EL2.E2H to 0.
> > > 
> > > This solves the NV problem, and provides a more reliable acid test
> > > for CPUs that do not completely follow the letter of the architecture
> > > while providing a RES1 behaviour for HCR_EL2.E2H.
> > > 
> > > Suggested-by: Marc Rutland <mark.rutland@arm.com>
> > 		^~~~
> > 
> > Thank you *Mark* for the suggestion here, neat trick :)
> 
> Too many Mar[ck]s. I'm struggling! ;-)

Time to file a deed poll. ;)

> > I'd be in favor of this patch being sent to stable, happy to handle the
> > backports if you don't have the time for it. VMs mysteriously dying
> > isn't a very good experience on NV and I'd like to not scare folks away.
> 
> I think Mark (yes, him!) had a plan to backport some of the !FEAT_E2H0
> patches back to earlier kernels. I'll let him comment on that.

Yep; I had a (delayed) plan to backport:

  https://lore.kernel.org/linux-arm-kernel/20250227180526.1204723-1-mark.rutland@arm.com/ 

... to v6.12, as folk are trying to run stable/android v6.12 kernels on
models and HW with the RES1 behaviour, and IIRC we didn't try to handle
this at all back in v6.6 (so no need to backport that far). I was
expecting to backport this patch at the same time.

If someone else has the time to do the backport, I'm more than happy to
leave it to them! Otherwise, I was planning to wait for this patch to
land in mainline before starting that.

Mark.
