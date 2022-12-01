Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED346FD7
	for <kvmarm@lists.linux.dev>; Thu,  1 Dec 2022 15:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCE1C433C1;
	Thu,  1 Dec 2022 15:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669909803;
	bh=LUT1bQztocCXvyDRR6quaBkfdm6TJC4VK3CcqENBpls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k0Z59nYHBrf584E9ogu8bxEUVrMHyFuQbzRH/g/hRi5fj+xjVT93zwZm2RbI4G2VA
	 tvoMPjvOv2YXsQd8/iPu8/T1ExoPhhxCDDNBOISmlRWgebFQ4ftKQtnkIWLxFtxhda
	 KYmycqreGvAfFEYwW98LiDTjAgO1CgwO6cXo69jdqYO/Fh8/nC16dL5NdosdKlHJh2
	 wHozbBGE1I+upsM6V32hFdxebJPPOhEeRL87+HHM0Ll4vMMsomliXoflBOWze60DMF
	 dmYtHRApxQCgNTDWJd+jdk2Wyaokq2PGxqIDjgNpvhzrzIkCVM7B2/PrsdU5/847/b
	 DKYFPCDnCP8gA==
Date: Thu, 1 Dec 2022 15:49:56 +0000
From: Will Deacon <will@kernel.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Quentin Perret <qperret@google.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Walbran <qwandor@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH 02/12] firmware: arm_ffa: Move comment before the field
 it is documenting
Message-ID: <20221201154956.GA28682@willie-the-truck>
References: <20221116170335.2341003-1-qperret@google.com>
 <20221116170335.2341003-3-qperret@google.com>
 <20221201115308.gciyfttnhvz2wcuz@bogus>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201115308.gciyfttnhvz2wcuz@bogus>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID: <20221201154956.mdGWfcYMzfv09eSr3N4PAwjFfiT9CnQ9K7svmb0dYMw@z>

On Thu, Dec 01, 2022 at 11:53:08AM +0000, Sudeep Holla wrote:
> On Wed, Nov 16, 2022 at 05:03:25PM +0000, Quentin Perret wrote:
> > From: Will Deacon <will@kernel.org>
> > 
> > This is consistent with the other comments in the struct.
> >
> Not sure how that happened :). Anyways,
> 
> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
> 
> I am yet to look at the other patches and I would like to have a setup
> to test it as well. So I will look at the other patches and test it later.
> The reason for reviewing the first 2 patches moving the code out of the
> driver is to check if they can be merged for v6.2 itself.
> 
> I may start pushing FF-A v1.1 changes for v6.3 and trying to avoid conflicts
> or cross tree dependencies. I know it is quite late for v6.2 but these changes
> are trivial and good to get it in for v6.2 if possible.
> 
> Will, thoughts ? If you agree, please take it via arm64 for v6.2. I don't
> have any FF-A changes for v6.2 ATM, so there should be not conflicts.

You're asking me to merge my own patches? Of course I can do that :D

Cheers,

Will
