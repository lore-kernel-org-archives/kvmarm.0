Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61780625
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 19:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771354887; cv=none; b=o9xm9Mg/hTOfPjso8eSpqdCNkyZRvmEgU7mwfFY2NUr0Xa+JjTs939k3bgpDNlVB9IT0Af511ZjLBJM66D9Qwl+xtCrqvExB2pX3KdbhURvW5xjtsnBvGfekY1YsIV2drTVyH1MNoeQVkGF7FLk8BLXUZIO8CXwWcnNk5OxedPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771354887; c=relaxed/simple;
	bh=jgyTTPoi6xU47w5Rk2SRqhFj8b5Pz6dO5Kixn0fITtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIGAgveX7e2XRASjWqUYtqBXEX+skr8RQUvKJErRxwjHdipRfm74zVSGIiEZgG5TLGbDy1dZOI+aDnqSaFpPioSo3O4uWisCky9ITXu+D4XDEgkH/wtSZN7umi2bhwcuUElm/N/lqbr1+L+Bgx45H+AjRaEO4nKNFWSbRanK/bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 253821477;
	Tue, 17 Feb 2026 11:01:18 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F29513F7F5;
	Tue, 17 Feb 2026 11:01:23 -0800 (PST)
Date: Tue, 17 Feb 2026 19:01:21 +0000
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
Message-ID: <20260217190121.GB136967@e132581.arm.com>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <aZNec3B0Iou9PYGw@willie-the-truck>
 <20260217141917.GA136967@e132581.arm.com>
 <aZSAsC1YI5_lK3e0@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZSAsC1YI5_lK3e0@willie-the-truck>

On Tue, Feb 17, 2026 at 02:52:32PM +0000, Will Deacon wrote:

[...]

> > > It also looks like we can't rely on the dsb(nsh) in the vcpu_run()
> > > path if that needs to be before the write to TRBLIMITR_EL1.
> > > 
> > > In which case, the host->guest something hideous like:
> > > 
> > > 	isb();
> > > 	tsb_csync();	// Executes twice if ARM64_WORKAROUND_TSB_FLUSH_FAILURE!
> > > 	dsb(nsh);	// I missed this in my patch
> > > 	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
> > > 	if (2064142) {
> > > 		tsb_csync();
> > > 		dsb(nsh);
> > > 	}
> > > 	isb();
> > 
> > As I_QXJZX suggests, the section K10.5.10 "Context switching" gives
> > the flow.  I'd suggest the VM context switch is also aligned to the
> > description in S_VKHHY.
> 
> I honestly have a hard time believing the sequence in S_VKHHY as the DSB
> seems to be in the wrong place which means the TSB CSYNC can float. It
> also isn't aligned with what the EL1 driver does...

Sorry for confusion.  I am checking internally for the flow suggested
in S_VKHHY.

> > When switching from host to guest, we need to clear TRCPRGCTLR.EN to
> > zero.  As the doc states "ETE trace compression logic is stateful,
> > and disabling the ETE resets this compression state".
> > 
> > > and then the guest->host part is:
> > > 
> > > 	write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);
> > > 	isb();
> > > 	if (2038923)
> > > 		isb();
> > > 
> > > Does that look right to you?
> > 
> > S_PKLXF gives the flow for switching in.
> 
> Well, modulo errata, sure. I don't have access to the errata document so
> I was more interested in whether I got that right...

Please see the doc:
https://developer.arm.com/documentation/SDEN-1873351/1900/?lang=en

Thanks,
Leo
