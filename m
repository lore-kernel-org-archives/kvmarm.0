Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81742DB79E
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 18:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771527486; cv=none; b=ApK0XB/xYyE92MKcsvDI5Jp25YvHdN3aNiz8/fJfMrTN5DwlQvYSKoQrqx/Y5c8i6P406ds3aI5aM2Bbt25nOhVJPKq+kiZwV89afUTkhTOIR/GZVwEIq2z/EuuR3g6os0BXXs5jYtSwYKae6poHd63/1sNPHVGlI31bZP/Vaxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771527486; c=relaxed/simple;
	bh=xz+lymeWIi6zBgpdESuR9sa1gO7cH8C16rtWQ9hj3Jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Va2OzoYtpo8QkJw7DoKCYZM4OmJuw764QhI4a6BTqpBmoId9pznTqIDObkJTN1xQryCqzDWDWXS4wfrnR7Lkj5ngaExB8wKz08d+cR0SMYnYrrEJKEdlfYG5wrAeZ83aCWzqBKfBoxTXN0tho8I3Le/c552SdSKXvkj6nJ1Ph5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF8C0339;
	Thu, 19 Feb 2026 10:57:56 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 82FAF3F62B;
	Thu, 19 Feb 2026 10:58:02 -0800 (PST)
Date: Thu, 19 Feb 2026 18:58:00 +0000
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
Message-ID: <20260219185800.GD136967@e132581.arm.com>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <aZNec3B0Iou9PYGw@willie-the-truck>
 <20260217141917.GA136967@e132581.arm.com>
 <aZSAsC1YI5_lK3e0@willie-the-truck>
 <20260217190121.GB136967@e132581.arm.com>
 <aZcWC25GE2iUKsNt@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZcWC25GE2iUKsNt@willie-the-truck>

On Thu, Feb 19, 2026 at 01:54:19PM +0000, Will Deacon wrote:

[...]

> > > > > In which case, the host->guest something hideous like:
> > > > > 
> > > > > 	isb();
> > > > > 	tsb_csync();	// Executes twice if ARM64_WORKAROUND_TSB_FLUSH_FAILURE!
> > > > > 	dsb(nsh);	// I missed this in my patch
> > > > > 	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
> > > > > 	if (2064142) {
> > > > > 		tsb_csync();
> > > > > 		dsb(nsh);
> > > > > 	}
> > > > > 	isb();
> > > > 
> > > > As I_QXJZX suggests, the section K10.5.10 "Context switching" gives
> > > > the flow.  I'd suggest the VM context switch is also aligned to the
> > > > description in S_VKHHY.
> > > 
> > > I honestly have a hard time believing the sequence in S_VKHHY as the DSB
> > > seems to be in the wrong place which means the TSB CSYNC can float. It
> > > also isn't aligned with what the EL1 driver does...
> > 
> > Sorry for confusion.  I am checking internally for the flow suggested
> > in S_VKHHY.

After internal review, we conclude that S_VKHHY is valid.  The intent of
S_VKHHY is to use the minimal number of barriers during a context switch.

Given the mentioned "DSB seems to be in the wrong place which means the
TSB CSYNC can float", this would be fine due to the two considerations:

1) As described in B2.6.8:

 | The following situations are synchronized using a TSB operation:
 |
 | * A direct write B to a System register is ordered after an indirect
 |   read or indirect write of the same register by atrace operation of
 |   a traced instruction A, if all of the following are true:
 |   - A is executed in program order before a Context synchronization event C.
 |   - C appears in program order before a TSB operation T.
 |   - B is executed in program order after T.

If trace operations indirectly read or write system registers, the TSB
ensures that these indirect accesses are complete before any direct
writes to the same register are performed in program order after the TSB.

So in S_VKHHY, we don't expect clearing TRCPRGCTLR.EN (step 4) and
clearing TRBLIMITR_EL1.E (step 5) to take effect prior to the TSB.

2) A DSB executed after the TSB ensures the data writes are complete,
then it is safe to read trace data from memory.  However, in the context
switch case, we don't need to read trace data, so a DSB for "publishing"
data is not required.

Based on these conclusions, let me summarize the flow:

  // Prohibit trace
  TRFCR_EL1 = 0;

  // No new program-flow trace
  isb();

  // Trace operation and trace unit are flushed
  tsb_csync();   // Executes twice if ARM64_WORKAROUND_TSB_FLUSH_FAILURE!

  // Disable trace unit
  TRCPRGCTLR.EN = 0b0

  // Disable trace buffer unit
  TRBLIMITR_EL1.E = 0b0

  if (2064142) {
    tsb_csync();
    dsb(nsh);
  }

  // Ensure trace disable takes effect and indirect writes are visible;
  // Ensure 2064142 is done before affected sysreg write.
  isb();

> > > > When switching from host to guest, we need to clear TRCPRGCTLR.EN to
> > > > zero.  As the doc states "ETE trace compression logic is stateful,
> > > > and disabling the ETE resets this compression state".
> > > > 
> > > > > and then the guest->host part is:
> > > > > 
> > > > > 	write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);
> > > > > 	isb();
> > > > > 	if (2038923)
> > > > > 		isb();
> > > > > 
> > > > > Does that look right to you?
> > > > 
> > > > S_PKLXF gives the flow for switching in.
> > > 
> > > Well, modulo errata, sure. I don't have access to the errata document so
> > > I was more interested in whether I got that right...
> > 
> > Please see the doc:
> > https://developer.arm.com/documentation/SDEN-1873351/1900/?lang=en
> 
> Aha, thank you, Leo!

You are welcome!

> I swear you used to be able to google the erratum number and get the doc,
> but that doesn't seem to be the case any more. In fact, if you type the
> erratum number into the search box on developer.arm.com it doesn't even
> work, so cheers for pointing me to the right place.

I also cannot search the doc via google, seems this is a known issue for
developer.arm.com when I checked this internally.  Thanks a lot for
reporting it.

The flow for guest->host might be easy one, anyway, I try to summary for
review:

  Restore TRFCR_EL1;

  // Ensure restored sysreg is visible
  isb();

  // Enable trace buffer
  TRBLIMITR_EL1.E = 0b1

  // Enable trace unit
  TRCPRGCTLR.EN = 0b1

  if (2038923)
     isb();

  // eret works as an extra context synchronization

Thanks,
Leo
