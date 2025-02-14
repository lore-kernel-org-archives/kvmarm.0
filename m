Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2C124503E
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 09:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739526926; cv=none; b=DCN7i+UMPt68rmwq/SVWs44jY40nLq+B/kZIcYFJQ1lNbcYbCfnhd5wBMeZYLVlURlt0yRUWaLtUCdosKyQzyDJlz9/DCiHLs+wWDY+t302SQpuckKiMavhn63eWQfyAiYOltySagRYdIGwABJxuBPgi9WGDYT40w0dh4aQiW30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739526926; c=relaxed/simple;
	bh=OLmOhFPQmOFsK0TNWHCEK+PAnV5VzbU646k1Y+lVG6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SY8s7yIgr3rosWdYoWLk+5aE+FjTaFpGjs0w1kqeukgKlBum3Y5S6YFb6WwRFYazwrS2gAP9Zsst1W6VUW1BEjJQ1/43RYY/BWpvIQjIWYqEWoco5kvRThs9xScVmMsQKAw/H//zqI4prwqAL8TWzFglREys/QISklJ0pFvee9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B95C113E;
	Fri, 14 Feb 2025 01:55:38 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43AEF3F6A8;
	Fri, 14 Feb 2025 01:55:17 -0800 (PST)
Date: Fri, 14 Feb 2025 09:55:12 +0000
From: Leo Yan <leo.yan@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v19 10/11] KVM: arm64: nvhe: Disable branch generation in
 nVHE guests
Message-ID: <20250214095512.GI235556@e132581.arm.com>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-10-1c1300802385@kernel.org>
 <20250213170316.GG235556@e132581.arm.com>
 <CAL_JsqLG4gu6c6=x_wG6XT0WaCC_ahH5eWHk3K9RcF0ZQrDR=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLG4gu6c6=x_wG6XT0WaCC_ahH5eWHk3K9RcF0ZQrDR=A@mail.gmail.com>

On Thu, Feb 13, 2025 at 05:16:45PM -0600, Rob Herring wrote:

[...]

> > > +static void __debug_save_brbe(u64 *brbcr_el1)
> > > +{
> > > +       *brbcr_el1 = 0;
> > > +
> > > +       /* Check if the BRBE is enabled */
> > > +       if (!(read_sysreg_el1(SYS_BRBCR) & (BRBCR_ELx_E0BRE | BRBCR_ELx_ExBRE)))
> > > +               return;
> > > +
> > > +       /*
> > > +        * Prohibit branch record generation while we are in guest.
> > > +        * Since access to BRBCR_EL1 is trapped, the guest can't
> > > +        * modify the filtering set by the host.
> > > +        */
> > > +       *brbcr_el1 = read_sysreg_el1(SYS_BRBCR);
> > > +       write_sysreg_el1(0, SYS_BRBCR);
> > > +}
> >
> > Should flush branch record and use isb() before exit host kernel?
> 
> I don't think so. The isb()'s in the other cases appear to be related
> to ordering WRT memory buffers. BRBE is just registers. I would assume
> that there's some barrier before we switch to the guest.

Given BRBCR is a system register, my understanding is the followd ISB
can ensure the writing BRBCR has finished and take effect.  As a result,
it is promised that the branch record has been stopped.

However, with isb() it is not necessarily to say the branch records have
been flushed to the buffer.  The purpose at here is just to stop record.
The BRBE driver will take care the flush issue when it reads records.

I agreed that it is likely barriers in the followed switch flow can assure
the writing BRBCR to take effect.  It might be good to add a comment for
easier maintenance.

> > I see inconsistence between the function above and BRBE's disable
> > function. Here it clears E0BRE / ExBRE bits for disabling BRBE, but the
> > BRBE driver sets the PAUSED bit in BRBFCR_EL1 for disabling BRBE.
> 
> Indeed. This works, but the enabled check won't work. I'm going to add
> clearing BRBCR to brbe_disable(), and this part will stay the same.

Seems to me, a right logic would be:

- In BRBE driver, the brbe_disable() function should clear E0BRE and
  ExBRE bits in BRBCR.  It can make sure the BRBE is totally disabled
  when a perf session is terminated.

- For a kvm context switching, it is good to use PAUSED bit.  If a host
  is branch record enabled, this is a light way for temporarily pause
  branch record for the switched VM.

Thanks,
Leo
