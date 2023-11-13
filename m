Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B135C200BE
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AB9C433C7;
	Mon, 13 Nov 2023 13:27:29 +0000 (UTC)
Date: Mon, 13 Nov 2023 13:27:26 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Ard Biesheuvel <ardb@google.com>, Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kees Cook <keescook@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH v1 0/3] Update tlb invalidation routines for FEAT_LPA2
Message-ID: <ZVIkPm4uxbCNsOgh@arm.com>
References: <20231027115634.1432154-1-ryan.roberts@arm.com>
 <3800df70-73f2-44b7-a6ed-15ec0bd63f5f@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3800df70-73f2-44b7-a6ed-15ec0bd63f5f@arm.com>

On Mon, Nov 13, 2023 at 11:55:01AM +0000, Ryan Roberts wrote:
> On 27/10/2023 12:56, Ryan Roberts wrote:
> > As raised yesterday against Ard's LPA2 series [1], we need to address the TLBI
> > changes to properly support LPA2 before Ard's changes get merged. So far those
> > changes have been part of my KVM LPA2 series [2]. So this is an attempt to split
> > the TLBI changes to make them independent. The idea is that this series would go
> > in first, then Ard's and the rest of my series can race eachother and it doesn't
> > really matter who wins.
> > 
> > I've attempted to address all of Marc's feedback against the versions of these
> > patches posted at [2], including adding benchmark data (see patch 1). Although
> > if people are still nervous that this could regress non-lpa2 performance in some
> > cases, I could rework so that there are lpa2 and non-lpa2 variants of
> > __flush_tlb_range_op(), and the correct version is chosen at the higher level
> > (based on lpa2_is_enabled() / kvm_lpa2_is_enabled()).
> > 
> > It turns out that we won't be able to key LPA2 usage off the same static key for
> > both the kernel and kvm usage because the kernel usage additionally depends on
> > CONFIG_ARM64_LPA2 being enabled. So I've introduced 2 stub functions
> > (lpa2_is_enabled() and kvm_lpa2_is_enabled()) to advertise it. Ard already
> > defines and implements lpa2_is_enabled() in his series, so there will be a minor
> > conflict to resolve there. I plan to define kvm_lpa2_is_enabled() to be the
> > static key for kvm in my series. Marc, would you be happy with this approach?
> > 
> > Anyway, I wanted to put this out there as an RFC. If we are happy with it, then
> > I'll re-post on 6.7-rc1.
[...]
> I polite bump; I never heard back on this. I'm planning to post my LPA2/KVM
> series on top of v6.7-rc1 in the next day or 2.

I suspect that's what most maintainers wait for ;). Usually patches
posted just before or during the merging window get ignored, unless they
are urgent fixes.

> By default, these 3 patches will
> be the first 3 of the series. But if you have an issue with the approach it
> would be good to work out an alternative plan to avoid wasting effort preparing
> the series.

If these patches are needed for Ard's series (I think they do), they
could be posted together. But first we need to split Ard's series into
at least two: reworking the memory map together with moving (some of)
the init code to C and the actual LPA2 stage 1 support. We might even
through LPA2 stage 2 on top if we feel brave ;). We can queue them all
together but having separate series gives us an option to drop bits if
needed.

-- 
Catalin
