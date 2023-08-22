Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582E39444
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 10:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9B1C433C8;
	Tue, 22 Aug 2023 10:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692698404;
	bh=rtcBe0wMcJ7bn+plsUh8+W8tuYW9yWrtHpjLRSfJ4P8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l8l9ZzCqdiFjkBKc00jp4AYVVM6IfvA6GT30hGvXdLxQZm6NirBsR5A+xTYPllwXy
	 r253VNLCqH6/LRQmFXIzvgXv6YIXTyUB0veT1Ug/HLR3/CWs1ss7kPhvf8GvCBqRCm
	 PDR55yrCpXi3sC/rJUbfXtx/LJI546LN2ONXFKZevw+niKK/MRd972bswqqm/ptXGq
	 vP3kUUVSZWlOiJ00KDBn5C3pJTGphpWgxx8TpM7jicp0kGqTwvhhj9KefrlxPVXxeV
	 rp1+y+pWX5T5SY01nS80NL3FlfeMydf6rwPcFM5Sz1sC8jfwWaNWv2uMyXnscCCsN6
	 fKNJZJwluwTpA==
Date: Tue, 22 Aug 2023 10:59:59 +0100
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huang Shijie <shijie@os.amperecomputing.com>,
	Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH v2] KVM: arm64: pmu: Resync EL0 state on counter rotation
Message-ID: <20230822095959.GB20667@willie-the-truck>
References: <20230820090108.177817-1-maz@kernel.org>
 <ZORaPAzHpFn_-aRP@FVFF77S0Q05N>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZORaPAzHpFn_-aRP@FVFF77S0Q05N>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Aug 22, 2023 at 07:48:28AM +0100, Mark Rutland wrote:
> On Sun, Aug 20, 2023 at 10:01:08AM +0100, Marc Zyngier wrote:
> > Huang Shijie reports that, when profiling a guest from the host
> > with a number of events that exceeds the number of available
> > counters, the reported counts are wildly inaccurate. Without
> > the counter oversubscription, the reported counts are correct.
> > 
> > Their investigation indicates that upon counter rotation (which
> > takes place on the back of a timer interrupt), we fail to
> > re-apply the guest EL0 enabling, leading to the counting of host
> > events instead of guest events.
> > 
> > In order to solve this, add yet another hook between the host PMU
> > driver and KVM, re-applying the guest EL0 configuration if the
> > right conditions apply (the host is VHE, we are in interrupt
> > context, and we interrupted a running vcpu). This triggers a new
> > vcpu request which will apply the correct configuration on guest
> > reentry.
> > 
> > With this, we have the correct counts, even when the counters are
> > oversubscribed.
> > 
> > Reported-by: Huang Shijie <shijie@os.amperecomputing.com>
> > Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> > Tested_by: Huang Shijie <shijie@os.amperecomputing.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Cc: Leo Yan <leo.yan@linaro.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Link: https://lore.kernel.org/r/20230809013953.7692-1-shijie@os.amperecomputing.com
> 
> This looks sane to me so:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
> It doesn't look like we have any PMU patches queued that would conflict, so if
> Will's happy I reckon this should go through the KVM/arm64 tree.

Fine by me!

Will
