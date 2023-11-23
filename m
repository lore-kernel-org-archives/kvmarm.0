Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2ED3E485
	for <kvmarm@lists.linux.dev>; Thu, 23 Nov 2023 17:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76442C433C7;
	Thu, 23 Nov 2023 17:04:51 +0000 (UTC)
Date: Thu, 23 Nov 2023 17:04:48 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@google.com>,
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
Message-ID: <ZV-GMP8yCNz24PET@arm.com>
References: <20231027115634.1432154-1-ryan.roberts@arm.com>
 <3800df70-73f2-44b7-a6ed-15ec0bd63f5f@arm.com>
 <ZVIkPm4uxbCNsOgh@arm.com>
 <CAMj1kXG0MRkN2pH6XAonGUjeaLkQr5xoOtpEuGQk5yBdsOxh4g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG0MRkN2pH6XAonGUjeaLkQr5xoOtpEuGQk5yBdsOxh4g@mail.gmail.com>

On Thu, Nov 16, 2023 at 08:33:40AM +1000, Ard Biesheuvel wrote:
> On Mon, 13 Nov 2023 at 23:27, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > But first we need to split Ard's series into
> > at least two: reworking the memory map together with moving (some of)
> > the init code to C and the actual LPA2 stage 1 support. We might even
> > through LPA2 stage 2 on top if we feel brave ;). We can queue them all
> > together but having separate series gives us an option to drop bits if
> > needed.
> >
> 
> I have rebased the changes onto v6.7-rc1 and squashed or added some of
> the followup fixes:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=arm64-lpa2-v5
> 
> I am happy to carve this up any way you like. A natural split would be
> to include everything up to and including
> 
> arm64: mmu: Make __cpu_replace_ttbr1() out of line
> 
> and queue the rest later, but perhaps you prefer to start with a smaller subset?

This looks fine, just split this whole lot in two, the first one to
__cpu_replace_ttbr1().

-- 
Catalin
