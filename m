Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E8438229F
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 10:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772534197; cv=none; b=hsOHoyxg5n41w29UDTRyS3t0DcLBRkTdsoV6SLcM55d9a4RfRCuaYJT+s5xZi+mH5GgyjBLjAsYUBKZopgmqtE7RheYaod5yzQDK2U18CVumDXU9AtiEgK1QDsVFcvzqffRtIDGcrW8gNVDHva3G6eoE887Z/iiWqmh9eSzdbHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772534197; c=relaxed/simple;
	bh=2PVZzKC+ZKhsV8+zxy9s0WnOglOEC8wxxqShlTaCrRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jEU7BiM9YTfhQXJ3L6jifRqmlZ3+LUXKX+ib/VRCkClUZWl2JiiZztmjStwVJ/B+EqUCg4orf8AEfSrEiB8sJs3mKz+YJeVxsV0vPC8xzyzrA9GquTKD7C/NlKt0Ar/7oWmATOe7Y3y3TPUdrV380RueoE6z5tMvzZEbybG0wbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E3A8497;
	Tue,  3 Mar 2026 02:36:29 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 133DA3F7BD;
	Tue,  3 Mar 2026 02:36:34 -0800 (PST)
Date: Tue, 3 Mar 2026 10:36:32 +0000
From: Leo Yan <leo.yan@arm.com>
To: Will Deacon <will@kernel.org>
Cc: yabinc@google.com, James Clark <james.clark@linaro.org>,
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <20260303103632.GH1098637@e132581.arm.com>
References: <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <aZNec3B0Iou9PYGw@willie-the-truck>
 <20260217141917.GA136967@e132581.arm.com>
 <aZSAsC1YI5_lK3e0@willie-the-truck>
 <20260217190121.GB136967@e132581.arm.com>
 <aZcWC25GE2iUKsNt@willie-the-truck>
 <20260219185800.GD136967@e132581.arm.com>
 <20260225120956.GD4184494@e132581.arm.com>
 <aaHdcKGE94ze2fq9@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaHdcKGE94ze2fq9@willie-the-truck>

On Fri, Feb 27, 2026 at 06:07:44PM +0000, Will Deacon wrote:
> On Wed, Feb 25, 2026 at 12:09:56PM +0000, Leo Yan wrote:
> > [ + Yabin ]
> > 
> > Thanks for Suzuki's reminding, I should mention that Yabin reported
> > another lockup issue caused by missing CPU PM support in TRBE driver.
> > 
> > We have a patch series to fix the issue:
> > https://lore.kernel.org/linux-arm-kernel/20251119-arm_coresight_path_power_management_improvement-v5-16-f615a301ad0b@arm.com/
> 
> Two nits on that series:
> 
> 1. It seems a bit weird to me for the ETE driver to manage TRFCR but for
>    the TRBE driver to manage the other registers

TRFCR_ELx is introduced by FEAT_TRF, which is a separate feature from
TRBE, and it can be used for other sinks (like ETR).  I think this is
the main reason that it is implemented in ETE driver rather than TRBE
driver.

> 2. Are you sure you don't need to save/restore the TRBE state when
>    LIMITR.E is clear? Maybe the driver is fine with that, but I'm worried
>    that we could suspend in a half-programmed state and lose some of that
>    configuration.

If the TRBLIMITR_EL1.E bit is cleared during the CPU is idle, then the
next time the TRBE trace buffer is re-enabled, trbe_enable_hw() must be
called to reconfigure the TRBE registers (including TRBSR_EL1).

One concern is that after a CPU power cycle, some fields in the TRBE
registers may be in the following state:

  "On a cold reset, this field resets to an architecturally UNKNOWN value."

I will change to always save/restore TRBE state.  Thanks for
suggestions.

> > Besides your fix the translation regime issue, I'd also suggest applying
> > the CoreSight PM patch series to fix lockup caused by CPU idle.
> 
> Yes, we definitely need something like that in the android kernel trees.
> I've previously bodged a hack into the ETE PM notifiers, but if you have
> backports of your series to 6.12, 6.6 and 6.1 then we should merge them
> into Android. As it stands, I don't have a TRBE-capable device running
> mainline.

Let us first merge the series on the master :)

After that, we can consider backporting (I assume Yabin already has a
plan for this).  I'd be happy to help with backporting to v6.12.
However, I cannot commit to backporting to v6.6 or v6.1 at this stage,
as many dependencies are likely to be involved.

Thanks,
Leo
