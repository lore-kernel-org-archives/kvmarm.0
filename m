Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258F5221FCB
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 16:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748535924; cv=none; b=uV2lXwL+b62o0Q4SXpIVfmKfIH4Yt18fVBdM4kyqHBuSHmyEpOgPyO6JFeXs3jZqPkxPlIfjxBv8Aqq9RfDoLFMFMsLIDWVN6Zto7k3hUdQ15itbjWahOfQ3h5gQFfMfzYS/bbfvWJAE4zM61PPk+B628cf3258u21oNFWWcZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748535924; c=relaxed/simple;
	bh=YyLoKZsWKbWRvLPGsT8AtP4lKJfTA3IbeNNRo7uXUY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NI6dXJDgKq2tNP4/d/YcM6UhjrkiAflgahEb6cKADKf/SFkHnFb8IYvFT+8Lbky6crvVpYY/flJDpht5b+RQ7MZ/V3F1OdDgrimNRwQZiz8zRk4F3MUlPtLNPRq5/lLeQJcoBMMb2nOGyyfp4xE4lefGxeO1a6ORwxSCQ1HViGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED9E2176A;
	Thu, 29 May 2025 09:25:04 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85B843F673;
	Thu, 29 May 2025 09:25:18 -0700 (PDT)
Date: Thu, 29 May 2025 17:25:13 +0100
From: Dave Martin <Dave.Martin@arm.com>
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
	Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v22 2/5] arm64: el2_setup.h: Make __init_el2_fgt labels
 consistent, again
Message-ID: <aDiBuC2JjAUNDq29@e133380.arm.com>
References: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
 <20250520-arm-brbe-v19-v22-2-c1ddde38e7f8@kernel.org>
 <aC9NhvYzajduVm7y@e133380.arm.com>
 <CAL_JsqKWY7rRGTbHXTmm4RC9F8fqrs133=75XFkVdm91bLHfaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqKWY7rRGTbHXTmm4RC9F8fqrs133=75XFkVdm91bLHfaw@mail.gmail.com>

Hi,

On Thu, May 22, 2025 at 12:20:35PM -0500, Rob Herring wrote:
> On Thu, May 22, 2025 at 11:15 AM Dave Martin <Dave.Martin@arm.com> wrote:
> >
> > On Tue, May 20, 2025 at 05:27:37PM -0500, Rob Herring (Arm) wrote:
> > > From: Anshuman Khandual <anshuman.khandual@arm.com>
> > >
> > > Commit 5b39db6037e7 ("arm64: el2_setup.h: Rename some labels to be more
> > > diff-friendly") reworked the labels in __init_el2_fgt to say what's
> > > skipped rather than what the target location is. The exception was
> > > "set_fgt_" which is where registers are written. In reviewing the BRBE
> > > additions, Will suggested "set_debug_fgt_" where HDFGxTR_EL2 are
> > > written. Doing that would partially revert commit 5b39db6037e7 undoing
> > > the goal of minimizing additions here, but it would follow the
> > > convention for labels where registers are written.
> > >
> > > So let's do both. Branches that skip something go to a "skip" label and
> > > places that set registers have a "set" label. This results in some
> > > double labels, but it makes things entirely consistent.
> > >
> > > While we're here, the SME skip label was incorrectly named, so fix it.
> > >
> > > Reported-by: Will Deacon <will@kernel.org>
> > > Cc: Dave Martin <Dave.Martin@arm.com>
> > > Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> > > ---
> > > This one can be applied even if the rest of the series is not.
> > >
> > > v22:
> > >  - New patch
> > > ---
> > >  arch/arm64/include/asm/el2_setup.h | 10 +++++++---
> > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> > > index ebceaae3c749..30f57b0334a3 100644
> > > --- a/arch/arm64/include/asm/el2_setup.h
> > > +++ b/arch/arm64/include/asm/el2_setup.h
> > > @@ -204,19 +204,21 @@
> > >       orr     x0, x0, #(1 << 62)
> > >
> > >  .Lskip_spe_fgt_\@:
> > > +
> > > +.Lset_debug_fgt_\@:
> >
> > Dangling label?  There doesn't seem to be any branch to it in this
> > series, unless I've missed something.
> 
> I tried to explain that in the commit message. To have both what you
> wanted and what Will suggested, you end up with 2 labels in between
> the last skip and setting registers.

Hmm, I wasn't trying to advocate for adding dead labels in anticipation
of their use, just to avoid labels whose names conflict with an
anticipated future use.

I guess this is harmless, but I may look at this again as and when...

Cheers
---Dave
