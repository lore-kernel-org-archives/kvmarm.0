Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1DD3909BC
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 17:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772559601; cv=none; b=ARnc+1Vgmn5pJ2vPr5PM//Si2usNgl4K2QNNPCIf809I7D2zLkk/AXbav+97pmYvRnQGDx3rOIgojLjKZOcvJSFaRBzlWhAdVPMofUC1tV6qXyNxzotFiMdpV6TSaWjJUZRGXBONJVvxpgd0w0xJLsDuoT0db2gSJj0+630nWdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772559601; c=relaxed/simple;
	bh=Cf9CYVRsQPMid2WPlYVIndl2JUJO0YuATPUzbT1zsfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0b2CXdfMoLNcpaxyENQOqJo/EcUHnbTAFHqwWsqPD1GS+3UUA25Y2m88MeAqGdSXgLUil8ou6XQmLIXaF2bPRye022pPqEBZFSB8xrCGrRYNsZmz3WllnduMlnp3S8Iv+xq9frVQ8MxlndBFBj3D9j1JqV9XFUA8ViAy60dIH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B85C339;
	Tue,  3 Mar 2026 09:39:52 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EB383F73B;
	Tue,  3 Mar 2026 09:39:58 -0800 (PST)
Date: Tue, 3 Mar 2026 17:39:56 +0000
From: Leo Yan <leo.yan@arm.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Yabin Cui <yabinc@google.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Disable TRBE Trace Buffer Unit when
 running in guest context
Message-ID: <20260303173956.GI1098637@e132581.arm.com>
References: <20260227212136.7660-1-will@kernel.org>
 <20260227212136.7660-2-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227212136.7660-2-will@kernel.org>

On Fri, Feb 27, 2026 at 09:21:33PM +0000, Will Deacon wrote:
> The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
> generation in guest context when self-hosted TRBE is in use by the host.
> 
> Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
> TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
> per R_YCHKJ the Trace Buffer Unit will still be enabled if
> TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
> Trace Buffer Unit can perform address translation for the "owning
> exception level" even when it is out of context.
> 
> Consequently, we can end up in a state where TRBE performs speculative
> page-table walks for a host VA/IPA in guest/hypervisor context depending
> on the value of MDCR_EL2.E2TB, which changes over world-switch. The
> potential result appears to be a heady mixture of SErrors, data
> corruption and hardware lockups.
> 
> Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
> draining the buffer, restoring the register on return to the host. This
> unfortunately means we need to tackle CPU errata #2064142 and #2038923
> which add additional synchronisation requirements around manipulations
> of the limit register. Hopefully this doesn't need to be fast.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
> Signed-off-by: Will Deacon <will@kernel.org>

I tested this on my Orion6 board in nVHE mode (kvm-arm.mode=nvhe).

I launched a VM with several threads running sleep 0.1 in a loop inside
the VM shell.  Then, I collected TRBE trace data on the host side:

  $ perf record -e cs_etm// -a -- sleep 100
  [ perf record: Woken up 74 times to write data ]
  Warning:
  Processed 4798137 events and lost 4 chunks!

  Check IO/CPU overload!

  Warning:
  Processed 9608 samples and lost 100.00%!

  Failed to open /proc/schedstat
  [ perf record: Captured and wrote 42401.333 MB perf.data ]

Tested-by: Leo Yan <leo.yan@arm.com>
