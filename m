Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C659D2F50
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 19:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740513505; cv=none; b=cpNE5Y+vgqb/YOVvmQCUFNIrHGxTaAKI/a1Wz42L0Br7iotb1Od1MwygkF5yGfWk58TaH/fkOjCbDU3+bzc7jEw/DfP3iymu8y6KmkijbMErcBtwo+GK9+YADcEWhPYeQURn1MySzcTtC/fpSfVItReajT9BO4eQG9yKBdjaMTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740513505; c=relaxed/simple;
	bh=TauguYtmPWqQDsCynGgZIXK+z1cbbQZwXFdW9dEVRF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLSn1UgxhDAmvSoRTjAHpgFQAxC1D25bsHHptqi2GroKSw2IFdScxXs/B9GhJMRUK6K3TK9HSaO+2eJJEP9jQswwl7/IdgHNK+Z3z4qX8SnMapSC7yqH0lZE0K9FFAD14ODPUsaVZJtvfUf1PFY/LrsvDZApOsqgDvAzCDPP3OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 427E6152B;
	Tue, 25 Feb 2025 11:58:39 -0800 (PST)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD9303F6A8;
	Tue, 25 Feb 2025 11:58:20 -0800 (PST)
Date: Tue, 25 Feb 2025 19:58:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Leo Yan <leo.yan@arm.com>
Cc: Rob Herring <robh@kernel.org>, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v20 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Message-ID: <Z74g2vUT9-KtlIvo@J2N7QTR9R3.cambridge.arm.com>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <20250218-arm-brbe-v19-v20-11-4e9922fc2e8e@kernel.org>
 <20250224122507.GE8144@e132581.arm.com>
 <CAL_Jsq+0fZ2uasgAam7qGTdCeDBQxXeyL-J1_suyxy6GE_ERTg@mail.gmail.com>
 <20250224140317.GF8144@e132581.arm.com>
 <Z7yY19UtSnND5KTl@J2N7QTR9R3.cambridge.arm.com>
 <20250224180301.GI8144@e132581.arm.com>
 <Z72xMLsd37I6X_5-@J2N7QTR9R3>
 <20250225174803.GB1821331@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225174803.GB1821331@e132581.arm.com>

On Tue, Feb 25, 2025 at 05:48:03PM +0000, Leo Yan wrote:
> On Tue, Feb 25, 2025 at 12:01:52PM +0000, Mark Rutland wrote:
> 
> [...]
> 
> > > > Critically, the brbe_enable() function merges the filters of all
> > > > *active* events which have been installed into hardware. It does not
> > > > track all events which can be rotated, and the resulting filter is not
> > > > the same -- it can change as a result of rotation.
> > > 
> > > In a perf session has multiple events, and events have different branch
> > > filters, seems to me, a simple way is to return error for this case.
> > 
> > FWIW, I'd generally prefer to do that since it avoids a number of
> > horrible edge-cases and gets rid of the need to do SW filtering, which
> > falls somewhere between "tricky" and "not entirely possible". However,
> > that's not what LBR and others do, which is why we went with filter
> > merging.
> > 
> > If folk on the tools side are happy with the kernel rejecting
> > conflicting events, then I'd be more than happy to do that. What I don't
> > want is that we start off with that approach and people immediately
> > start to complain that the BRBE driver rejects events that the LBR
> > driver accepts.
> > 
> > See the last time this came up.
> 
> Thanks for the shared links.  Based on the info, let's say we can have two
> cases:
> 
>   Case 1: set different branch filters in a single perf session:
> 
>     perf record -e armv8_pmuv3_0/r03,branch_type=any_call/u \
>                 -e armv8_pmuv3_0/r04,branch_type=any_ret/k ...
> 
>   Case 2: set different branch filters in multiple perf sessions:
> 
>     perf record -e armv8_pmuv3_0/r03,branch_type=any_call/u ...
> 
>     perf record -e armv8_pmuv3_0/r04,branch_type=any_ret/k ...
> 
> In my previous reply, I was suggesting that we should reject the case 1.

Do you mean that the kernel should reject that, or that userspace should
reject that.

As mentioned earlier, I am ok with the idea that we reject *scheduling*
events with mismatched filters, as we do for other resource conflicts.
That would necessarily mean rejecting *groups* of events with
inconsistent filters at open time.

However, I do not think that we should reject indepenent events which
happen to have mismatched filters, regardless of whether they're opened
by the same "session".

> IMO, it is not quite useful to configure different filters for events in
> the same session, especially if this leads complexity in the driver due
> to the hardware limitation.

I generally agree, but IIRC userspace does this today.

> For case 2, when create a new session, if the perf tool can read out the
> current branch filter setting (e.g. via sysfs node) and give suggestion
> what branch filter is compabile with existed sessions, seems to me, this
> is a feasible solution.  My understanding this is a rare case, and a
> clear guidance for users would be sufficient if this happens.  (Maybe
> we can give recommendation for how to use BRBE in the perf doc).

No. We are not going to expose *dynamic* information about the PMU
hardware via sysfs. This is not as simple as you make it out to be.
At any point in time there can be an arbitrary number of events open,
and some arbitrary subset currently scheduled.

I agree that ideally this should be rare, though, and hence either of
the two options I have suggested thus far should handle that acceptably.

> To be clear, an important factor is the trace modes with modifier 'u'
> (user) and 'k' (kernel) should be supported for different events and for
> different sessions.  In a mixed cases (some events are userspace only
> and some are kernel only), the BRBE driver needs to filter out branch
> records for specific mode when taking a sample.

I hate to repeat myself, but the driver has *no concept whatsoever* of a
"session". It only knows:

* Which events are currently active in hardware.

* Which events have been grouped together.

* Which events have been opened for a given task or CPU context.

... and *NONE* of those correspond directly to a "session" managed by
the userspace perf tool.

> > > If we can unify branch filter within a perf session, would this be
> > > much easier for handling?
> > 
> > Do you mean if the perf tool ensured that all events in a given session
> > had the same filter? From the kernel's PoV there's no such thing as a
> > "perf session", and I'm not sure whether you're suggesting doing that in
> > userspace or withing the kernel.
> 
> My understanding is this would be not difficult to do such kind checking
> in the tool.  E.g., the perf tool can iterate every event and check the
> branch filter and detect incompabile issue.

Cool, sounds like we could do that then!

> > Doing that in the perf tool would certianly make a stronger argument for
> > the kernel taking the "reject conflicting branch filters" option.
> > 
> > Doing that within the kernel isn't really possible.
> 
> As said above, if the BRBE driver can provide a knob in sysfs to indicate
> what is the current branch filter in the existed sessions, this would be
> helpful for the tool to do the checking and remind users.

Sorry, as above, that is not going to happen. It is not practical and
will cause many other problems.

> I haven't done any experiments for this. If you think this is the way
> to move forward, I might do a prototype and get back to you to ensure we
> don't run into any unexpected issues.

What specifically are you proposing to prototype?

Mark.
