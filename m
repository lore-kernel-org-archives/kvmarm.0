Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E192435502F
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771339958; cv=none; b=Ypo86VVUYaCv9+7YxFOmM9T98LIF0BOgZvuUAHxWsW+xReCS014jRS/JqAG1yhAzjjwzDi59q1AMbBDHCVvUabCHdYexO13u3p05QaYlQncnogff/TZHVLmdJzqC4c4qri7IwnCgGGZ/l+k2zeyZEoUaML4XK3yZoxXMKhGpoo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771339958; c=relaxed/simple;
	bh=ZP+KYsRvEF5ApvHchr0EfNzRlljIbjaP/4zVMzS25Ww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PCc0LBQZsW1VEZtRi6am+P6x+Kepg0bxpw6Y/jry37V6BBhgxA2ZoQVGLIP/60o7VvQkrxdokqHumPLDLAPeyFlQKxAIpeFaoDSJwH2yQSipirSgrcw1nEiz5sp3q/B6G05IRC8LLbuAOJZuOI6CAtFUiCccahU1eUuS7P0YsRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TkPendG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkPendG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE844C4CEF7;
	Tue, 17 Feb 2026 14:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771339957;
	bh=ZP+KYsRvEF5ApvHchr0EfNzRlljIbjaP/4zVMzS25Ww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TkPendG5QIVTlKIjhshbQ6Num6+ZT5R8+Qw5Ka++bkV64I31aTaROkwCPDr2ILI1c
	 6jqwN7HEdnfzrsH8pJttPEOa8SHqGv5xJMJilihNi9rWEIyyL8AbSFj40h3BM2x4DV
	 YTKFkhFTPL/kbtYeSLpIvEQWQkJTy+XsSBHOkFDYrNt+XNkdxC9QmjzgEUTegNnuWo
	 FyX3qNDOVcEjsl+uP2AK7+tfKDdZHDs1a0nbW3xeW5d7k0KnN/Jads5dUu4K0q8shH
	 j+OekI6HtJUQ3rNsQG/GPKjAv2pnRlq5A8TMGxHAPfXaiCsGC+3MNsX/4i1kf8gpOC
	 DO6pu6kv8NnNQ==
Date: Tue, 17 Feb 2026 14:52:32 +0000
From: Will Deacon <will@kernel.org>
To: Leo Yan <leo.yan@arm.com>
Cc: James Clark <james.clark@linaro.org>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <aZSAsC1YI5_lK3e0@willie-the-truck>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <aZNec3B0Iou9PYGw@willie-the-truck>
 <20260217141917.GA136967@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217141917.GA136967@e132581.arm.com>

On Tue, Feb 17, 2026 at 02:19:17PM +0000, Leo Yan wrote:
> On Mon, Feb 16, 2026 at 06:14:11PM +0000, Will Deacon wrote:
> 
> [...]
> 
> > > The TRBE driver might do an extra drain here as a workaround. Hard to tell
> > > if it's actually required in this case (seems like probably not) but it
> > > might be worth doing it anyway to avoid hitting the issue. Especially if we
> > > add guest support later where some of the affected registers might start
> > > being used. See:
> > > 
> > >     if (trbe_needs_drain_after_disable(cpudata))
> > >         trbe_drain_buffer();
> > 
> > Oh great, this thing sucks even more than I realised!
> > 
> > But thanks for pointing that out... this is presumably erratum #2064142,
> > but we probably need to look at #2038923 as well :/
> > 
> > I can't find any public documentation for the problems, but based on the
> > kconfig text then I think we care about #2064142 so that the TRBE
> > register writes when restoring the host context are effective and we
> > care about #2038923 to avoid corrupting trace when re-enabling for the
> > host.
> 
> Seems to me, this is correct.
> 
> > It also looks like we can't rely on the dsb(nsh) in the vcpu_run()
> > path if that needs to be before the write to TRBLIMITR_EL1.
> > 
> > In which case, the host->guest something hideous like:
> > 
> > 	isb();
> > 	tsb_csync();	// Executes twice if ARM64_WORKAROUND_TSB_FLUSH_FAILURE!
> > 	dsb(nsh);	// I missed this in my patch
> > 	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
> > 	if (2064142) {
> > 		tsb_csync();
> > 		dsb(nsh);
> > 	}
> > 	isb();
> 
> As I_QXJZX suggests, the section K10.5.10 "Context switching" gives
> the flow.  I'd suggest the VM context switch is also aligned to the
> description in S_VKHHY.

I honestly have a hard time believing the sequence in S_VKHHY as the DSB
seems to be in the wrong place which means the TSB CSYNC can float. It
also isn't aligned with what the EL1 driver does...

> When switching from host to guest, we need to clear TRCPRGCTLR.EN to
> zero.  As the doc states "ETE trace compression logic is stateful,
> and disabling the ETE resets this compression state".
> 
> > and then the guest->host part is:
> > 
> > 	write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);
> > 	isb();
> > 	if (2038923)
> > 		isb();
> > 
> > Does that look right to you?
> 
> S_PKLXF gives the flow for switching in.

Well, modulo errata, sure. I don't have access to the errata document so
I was more interested in whether I got that right...

Will
