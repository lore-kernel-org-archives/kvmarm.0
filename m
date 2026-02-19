Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFAC30BF70
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771509265; cv=none; b=JP0u+wKHyTm7IQa+KoGKz2uxtiVet4Bo+sNnXUHlzfm577q624IaKjRkfjPn4PaSYXBUu3XZQl0602AQt9Y4p6kAxhJiEJdofOtGBPCZ3zXas/coKzguQia9F8ovfr/dd0+XJ0uxF4jaqMOJx9yH7wkfGwI20IN7iVc96bh1Hvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771509265; c=relaxed/simple;
	bh=0QQ4xGrL6De/tHJfVXxAIlwtEBCu7b+nqFPL3Cqzz48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J7xSFuDKda9k9mhssehtF/5lkGUjZigMLnV8YKap40KvYOq7aF2Fx8KEmcjHwoagL8jDdlaMM6okxS6Zx6OL1iC9e8mXz5zHkJgW21s8gyvMvuuwIwogxo201yUFlUHGwSITE5cC2G3B+MnTdCPGjfAD6nwxt4lJn9WICCyYVYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jdCLTfXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jdCLTfXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284C1C4CEF7;
	Thu, 19 Feb 2026 13:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771509265;
	bh=0QQ4xGrL6De/tHJfVXxAIlwtEBCu7b+nqFPL3Cqzz48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jdCLTfXht8Wc/rrnBf+SlNxpDgCpjtZIxwlQ5GCjVdRW6kTQpEKp6xpQw3PXMGFj2
	 VeqLVVPk/ODP7SVlkgNoVtriLnqUkTuEeoJm7fpWQQ0jadxySqr3Qh8CR2YJxGXRL9
	 iT3tEstrZfY7yjgiOb4/0YfHykepPMi3dmfRnsQfPn6aM1fOzWEpWP9qKYiTgis2ag
	 2I6pl/KbuTMLOte5U5dxiM98YSJZ/16st3N6XV3Nae8oZdd0GtmH4HpOpbGk7380e1
	 NwWuY6kGLW9KWDcp60sW1wJ5qU2h/oREKFRxjFhS9Qglm9uSt5/+7DCsbOEQLHLX6U
	 2OyaIv8RWO5yQ==
Date: Thu, 19 Feb 2026 13:54:19 +0000
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
Message-ID: <aZcWC25GE2iUKsNt@willie-the-truck>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <aZNec3B0Iou9PYGw@willie-the-truck>
 <20260217141917.GA136967@e132581.arm.com>
 <aZSAsC1YI5_lK3e0@willie-the-truck>
 <20260217190121.GB136967@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217190121.GB136967@e132581.arm.com>

On Tue, Feb 17, 2026 at 07:01:21PM +0000, Leo Yan wrote:
> On Tue, Feb 17, 2026 at 02:52:32PM +0000, Will Deacon wrote:
> 
> [...]
> 
> > > > It also looks like we can't rely on the dsb(nsh) in the vcpu_run()
> > > > path if that needs to be before the write to TRBLIMITR_EL1.
> > > > 
> > > > In which case, the host->guest something hideous like:
> > > > 
> > > > 	isb();
> > > > 	tsb_csync();	// Executes twice if ARM64_WORKAROUND_TSB_FLUSH_FAILURE!
> > > > 	dsb(nsh);	// I missed this in my patch
> > > > 	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
> > > > 	if (2064142) {
> > > > 		tsb_csync();
> > > > 		dsb(nsh);
> > > > 	}
> > > > 	isb();
> > > 
> > > As I_QXJZX suggests, the section K10.5.10 "Context switching" gives
> > > the flow.  I'd suggest the VM context switch is also aligned to the
> > > description in S_VKHHY.
> > 
> > I honestly have a hard time believing the sequence in S_VKHHY as the DSB
> > seems to be in the wrong place which means the TSB CSYNC can float. It
> > also isn't aligned with what the EL1 driver does...
> 
> Sorry for confusion.  I am checking internally for the flow suggested
> in S_VKHHY.
> 
> > > When switching from host to guest, we need to clear TRCPRGCTLR.EN to
> > > zero.  As the doc states "ETE trace compression logic is stateful,
> > > and disabling the ETE resets this compression state".
> > > 
> > > > and then the guest->host part is:
> > > > 
> > > > 	write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);
> > > > 	isb();
> > > > 	if (2038923)
> > > > 		isb();
> > > > 
> > > > Does that look right to you?
> > > 
> > > S_PKLXF gives the flow for switching in.
> > 
> > Well, modulo errata, sure. I don't have access to the errata document so
> > I was more interested in whether I got that right...
> 
> Please see the doc:
> https://developer.arm.com/documentation/SDEN-1873351/1900/?lang=en

Aha, thank you, Leo!

I swear you used to be able to google the erratum number and get the doc,
but that doesn't seem to be the case any more. In fact, if you type the
erratum number into the search box on developer.arm.com it doesn't even
work, so cheers for pointing me to the right place.

Will
