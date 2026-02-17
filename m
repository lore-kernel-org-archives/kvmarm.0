Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506E03164B5
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 14:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771337962; cv=none; b=aAQG0x52PcvlbAUzw/G9UENF1o7fBns8oRcsP6QmxMHE6Ox+lkr75lkXxDwu3nM2WkKXkX6ZjOvUPrU4i7i63jHtnTt+Z6ueYjZkk+cpHxzF3pzU8ixHlAIYwe8vbNSWiWO0L7tjd2yVsGnh9cw4HHuanNT/HquiLyAwzJuvl20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771337962; c=relaxed/simple;
	bh=7LihERVTnFJ+dv5oGAXFWMw43T52hHSt0uXf0a8f6os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRYoNwmf6eDccFG5zqpMIdcs3Jqc7EQW+o7phpgpB6mdIiAFRWVAlORzU0U8G/sIT2taS14swwbefzVmce8pB1PNqDAIDjKaxJsMzTlFM8ZMNIQOVuDRxiKlx8UtToq505ThjOtm1IBkK9aknnNPSyRdb2IOp3N098jBmxrmaHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AAC21477;
	Tue, 17 Feb 2026 06:19:14 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E6E73F62B;
	Tue, 17 Feb 2026 06:19:19 -0800 (PST)
Date: Tue, 17 Feb 2026 14:19:17 +0000
From: Leo Yan <leo.yan@arm.com>
To: Will Deacon <will@kernel.org>
Cc: James Clark <james.clark@linaro.org>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <20260217141917.GA136967@e132581.arm.com>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <aZNec3B0Iou9PYGw@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZNec3B0Iou9PYGw@willie-the-truck>

On Mon, Feb 16, 2026 at 06:14:11PM +0000, Will Deacon wrote:

[...]

> > The TRBE driver might do an extra drain here as a workaround. Hard to tell
> > if it's actually required in this case (seems like probably not) but it
> > might be worth doing it anyway to avoid hitting the issue. Especially if we
> > add guest support later where some of the affected registers might start
> > being used. See:
> > 
> >     if (trbe_needs_drain_after_disable(cpudata))
> >         trbe_drain_buffer();
> 
> Oh great, this thing sucks even more than I realised!
> 
> But thanks for pointing that out... this is presumably erratum #2064142,
> but we probably need to look at #2038923 as well :/
> 
> I can't find any public documentation for the problems, but based on the
> kconfig text then I think we care about #2064142 so that the TRBE
> register writes when restoring the host context are effective and we
> care about #2038923 to avoid corrupting trace when re-enabling for the
> host.

Seems to me, this is correct.

> It also looks like we can't rely on the dsb(nsh) in the vcpu_run()
> path if that needs to be before the write to TRBLIMITR_EL1.
> 
> In which case, the host->guest something hideous like:
> 
> 	isb();
> 	tsb_csync();	// Executes twice if ARM64_WORKAROUND_TSB_FLUSH_FAILURE!
> 	dsb(nsh);	// I missed this in my patch
> 	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
> 	if (2064142) {
> 		tsb_csync();
> 		dsb(nsh);
> 	}
> 	isb();

As I_QXJZX suggests, the section K10.5.10 "Context switching" gives
the flow.  I'd suggest the VM context switch is also aligned to the
description in S_VKHHY.

When switching from host to guest, we need to clear TRCPRGCTLR.EN to
zero.  As the doc states "ETE trace compression logic is stateful,
and disabling the ETE resets this compression state".

> and then the guest->host part is:
> 
> 	write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);
> 	isb();
> 	if (2038923)
> 		isb();
> 
> Does that look right to you?

S_PKLXF gives the flow for switching in.

Thanks,
Leo
