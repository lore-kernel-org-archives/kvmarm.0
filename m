Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E287C24C076
	for <kvmarm@lists.linux.dev>; Wed,  8 Oct 2025 12:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759927246; cv=none; b=OyoB11xuDwlT+uA1vhtQExbvhphwBzxOnel5J9f2yfaYcdK4DsnfmFomOZnAWQMil+DfgwoTzDEBMVxQPlMw+gq63HqgcFqoBbrelzW1nPzIdHC2HekUE8rh4OmD3ut1WLF5HPdfnwzUpxy/Ldx+hhZnBqaLZ6lmAUora8XgbTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759927246; c=relaxed/simple;
	bh=xnw1k6sqpWoaqzrDSju1NOU1Ov2L4Pj8El+q2fMBNT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPQXHytsgUSkzuPkXO8V1fAJFv2fIYJOQF4THB9H/cnIrZbvcr2gAoXEdNBzMxXtak//hrQ5ekYsvdVKUAvMMlkxLtY1okddfM48MzZEafHNp1gIZ43T8bDrMA/cC1+i5F55gt7HTBS2kr/sqC078dW37S49HKcvWOd52KYATb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11AC022FC;
	Wed,  8 Oct 2025 05:40:35 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CEA73F738;
	Wed,  8 Oct 2025 05:40:42 -0700 (PDT)
Date: Wed, 8 Oct 2025 13:40:40 +0100
From: Leo Yan <leo.yan@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Oliver Upton <oliver.upton@linux.dev>, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, alexandru.elisei@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Check cpu_has_spe() before initializing
 PMSCR_EL1 in VHE
Message-ID: <20251008124040.GC77665@e132581.arm.com>
References: <20251007182356.2813920-1-mukesh.ojha@oss.qualcomm.com>
 <aOVckTSJET5ORY1n@linux.dev>
 <861pndzn4w.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861pndzn4w.wl-maz@kernel.org>

On Wed, Oct 08, 2025 at 11:46:55AM +0100, Marc Zyngier wrote:

[...]

> > > Lets guard the change with cpu_has_spe() check so that it only affects
> > > the cpu which has SPE feature supported.
> > 
> > This could benefit from being spelled out a bit more. In both cases we
> > check for the presence of FEAT_SPE, however I believe the issue you
> > observe is EL3 hasn't delegated ownership of the Profiling Buffer to
> > Non-secure nor does it reinject an UNDEF in response to the sysreg trap.
> > 
> > I agree that the change is correct but the rationale needs to be clear.
> 
> To me, this smells a lot more like some sort of papering over a
> firmware bug. Why isn't SPE available the first place?

TF-a grants permission to non-secure world [1], only access from secure
world or realm will trap to EL3.

So yes, it would be good to check if any issue in firmware.

Thanks,
Leo

[1] https://git.trustedfirmware.org/plugins/gitiles/TF-A/trusted-firmware-a.git/+/refs/heads/master/lib/extensions/spe/spe.c#52
