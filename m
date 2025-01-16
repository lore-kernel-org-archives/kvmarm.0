Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBC022B8D2;
	Thu, 16 Jan 2025 15:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737041563; cv=none; b=qkZxiOW6bUVRwHOLNkLQu9ZqPUbPUJ4R4fWPNfPyrBw4K8l1uYDjH0V+vvmzx8gv1qRN+tvH0xHNjswWi6/PtVt76jlHAu0WnNh9ZJSuCs7/Ug6RyuJziO2EyMtv9KlsW0KUyabuGjd3g5ZKDxShPio3nPE4HxdrqE2BsI7ICdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737041563; c=relaxed/simple;
	bh=jF9zoBFJYwbcnwqBqK9Tijw0V2WTjLhw0+24Tc0rS1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTZQGprilSQh6LXDizq3JOy7xgVXCFrrOXilJTSGz1iRx3e9n1wIPH5ytfps2NaYpSRoFVPmlaJUWn3ExXDZCS3e6PDytq9gPGJMcbx25v01FbQ8t65be/Cp1Jn/SAxbUo9DEpAEK7hTSxv56Eh1ERDRHcb/fIt/u7Or9A4uWyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B50C4CED6;
	Thu, 16 Jan 2025 15:32:40 +0000 (UTC)
Date: Thu, 16 Jan 2025 15:32:38 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
Message-ID: <Z4kmlhnlpKjS_MII@arm.com>
References: <20241220072240.1003352-1-anshuman.khandual@arm.com>
 <20250102160402.GB3990035-robh@kernel.org>
 <Z30adHnQ7ZFaU9UR@arm.com>
 <CAL_JsqLLnh1o4L1=PpNt5brBwZZCgp7mOygByOYakchrzc29Ow@mail.gmail.com>
 <86wmf5wo8u.wl-maz@kernel.org>
 <CAL_JsqKKiEOj=a1k6U-bB0F6-ht7QokDnh3bspHupp-QG=haSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqKKiEOj=a1k6U-bB0F6-ht7QokDnh3bspHupp-QG=haSg@mail.gmail.com>

On Wed, Jan 08, 2025 at 07:47:16AM -0600, Rob Herring wrote:
> On Wed, Jan 8, 2025 at 5:15 AM Marc Zyngier <maz@kernel.org> wrote:
> > On Tue, 07 Jan 2025 22:13:47 +0000,
> > Rob Herring <robh@kernel.org> wrote:
> > > On Tue, Jan 7, 2025 at 6:13 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > But does KVM actually expose the feature to EL1 in ID_AA64DFR1_EL1 and
> > > > than traps it at EL2?
> > >
> > > As Marc pointed out KVM only advertises PMUv3.8. Regardless, guest
> > > accesses to these registers are trapped with or without this series.
> >
> > And most probably generates a nice splat in the kernel log, as nobody
> > updated KVM to handle *correctly* PMICNTR_EL0 traps, let alone deal
> > with the FGT2 registers.
> 
> Isn't that this series[1]? Should that have come first, I guess I know
> that *now*.
[...]
> [1] https://lore.kernel.org/all/20241210055311.780688-1-anshuman.khandual@arm.com/

It's not any clearer to me. Does this series depend on the 46-patch one?
Or, if we had the other, is this no longer needed? Or none of these,
they are independent.

-- 
Catalin
