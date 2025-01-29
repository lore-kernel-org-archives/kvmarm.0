Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4704418F2DD;
	Wed, 29 Jan 2025 18:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738173790; cv=none; b=QaiDOPW24WJTnGrMgxVzrb4WFNlExc98ddknoZLCbSSX6xzu23A6nnuuMiU8NeBM29yyxyqbXVUbbdLZ1gJMLcrPz+RfHcckRSektMNr4aVdiBqroM3sy1m/HIyWZRcjnt3hFynYJHz2nfQwTznqqSgUIvGc5xPl0t33pasCle8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738173790; c=relaxed/simple;
	bh=Qe/SoOU9qTRy3XGlqsp4aCT1VN6ykWQ0c1bYiG7F840=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBsZ0JkWHLEct5MBUaw2mqrkqB96MAO2/KDfCCR/PKqnHzaZLRy0g8ZdEOEsfLrUL5XMxfHnhEnlrden8i5N6wSFLeoOAqXwFuFdJVXdcNLvSJ/xAnTRfUaIa8d1CvcAd1sclfv1LNFGjuqwdqEmwdm/yLfzKo5HaTDzZHe4IiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88272C4CED1;
	Wed, 29 Jan 2025 18:03:07 +0000 (UTC)
Date: Wed, 29 Jan 2025 18:03:05 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Rob Herring <robh@kernel.org>, Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
Message-ID: <Z5ptWRqZVI8grz6e@arm.com>
References: <20241220072240.1003352-1-anshuman.khandual@arm.com>
 <20250102160402.GB3990035-robh@kernel.org>
 <Z30adHnQ7ZFaU9UR@arm.com>
 <CAL_JsqLLnh1o4L1=PpNt5brBwZZCgp7mOygByOYakchrzc29Ow@mail.gmail.com>
 <86wmf5wo8u.wl-maz@kernel.org>
 <CAL_JsqKKiEOj=a1k6U-bB0F6-ht7QokDnh3bspHupp-QG=haSg@mail.gmail.com>
 <Z4kmlhnlpKjS_MII@arm.com>
 <CAL_JsqK1k7fG=yDZSbTbV63yRP5U9=GpuAiv=NWZJWdppUtRwA@mail.gmail.com>
 <7f5c68c7-8036-4d18-950f-80e55ac8ea11@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7f5c68c7-8036-4d18-950f-80e55ac8ea11@arm.com>

On Tue, Jan 28, 2025 at 02:41:17PM +0530, Anshuman Khandual wrote:
> On 1/18/25 03:37, Rob Herring wrote:
> > On Thu, Jan 16, 2025 at 9:32 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> >>
> >> On Wed, Jan 08, 2025 at 07:47:16AM -0600, Rob Herring wrote:
> >>> On Wed, Jan 8, 2025 at 5:15 AM Marc Zyngier <maz@kernel.org> wrote:
> >>>> On Tue, 07 Jan 2025 22:13:47 +0000,
> >>>> Rob Herring <robh@kernel.org> wrote:
> >>>>> On Tue, Jan 7, 2025 at 6:13 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> >>>>>> But does KVM actually expose the feature to EL1 in ID_AA64DFR1_EL1 and
> >>>>>> than traps it at EL2?
> >>>>>
> >>>>> As Marc pointed out KVM only advertises PMUv3.8. Regardless, guest
> >>>>> accesses to these registers are trapped with or without this series.
> >>>>
> >>>> And most probably generates a nice splat in the kernel log, as nobody
> >>>> updated KVM to handle *correctly* PMICNTR_EL0 traps, let alone deal
> >>>> with the FGT2 registers.
> >>>
> >>> Isn't that this series[1]? Should that have come first, I guess I know
> >>> that *now*.
> >> [...]
> >>> [1] https://lore.kernel.org/all/20241210055311.780688-1-anshuman.khandual@arm.com/
> >>
> >> It's not any clearer to me. Does this series depend on the 46-patch one?
> >> Or, if we had the other, is this no longer needed? Or none of these,
> >> they are independent.
> > 
> > They are independent. I think ideally we'd want everything landing at
> > the same time, but we're past ideal at this point. Without this
> > series, if someone uses PMU on v8.9 and firmware enabled FGT2, then
> > the kernel will crash. Without the above series, KVM will have
> > warnings in the kernel log, but otherwise function.
> 
> Right, they are independent. Just that Rob had observed this PMU v3.8 boot
> requirement while reviewing the HW breakpoint series earlier. I should just
> respin this series after the upcoming v6.14-rc1 release is out ?

They may apply cleanly but please do rebase and repost at -rc1. Thanks.

-- 
Catalin
