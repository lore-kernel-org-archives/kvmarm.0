Received: from out-210.mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7597E4
	for <kvmarm@lists.linux.dev>; Thu,  2 Feb 2023 22:37:24 +0000 (UTC)
Date: Thu, 2 Feb 2023 21:43:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675374204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CSatUKlofPpoSzIl9dT2eRi4DDMQKaT6+ka1t3N+r50=;
	b=sf7cHe/auIaA7GR/KSirtwe9R7SbM76R69q5oHSPeOdDfa7LBkLMvEXVnYbfVD78OQ7YTS
	jLGbwq8bsmE88UDA8B7UPG+xJEaj1GHaO1PmM6h0Yp0ARvyNlRMHI0r0dJxh/tOruisN92
	eHvo8I3pT1CgL6xLpe6oc4N4fj/BevA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kernel-team@android.com
Subject: Re: [PATCH 0/4] KVM: arm64: Fix CPU resume/on with pKVM
Message-ID: <Y9wucriA2S/mN1pq@google.com>
References: <20230201103755.1398086-1-qperret@google.com>
 <86bkmd1ly4.wl-maz@kernel.org>
 <Y9qZ5XoXW1XQ70eE@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9qZ5XoXW1XQ70eE@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 01, 2023 at 04:57:09PM +0000, Quentin Perret wrote:
> On Wednesday 01 Feb 2023 at 14:48:03 (+0000), Marc Zyngier wrote:
> > How do you want to deal with the backports? None of the patches have a
> > Cc: stable, and only the last one has a Fixes: tag, but cannot be
> > applied standalone.
> 
> Right, I wasn't sure what was best -- the first patches aren't really
> fixing anything per se but yeah, we kinda need them...
> 
> Happy to re-post a version with the same 'Fixes:' tag on all patches and
> 'Cc: stable' everywhere if that makes things easier. Wdyt?

I'd like to get these patches cooking in -next so I'll probably just
take what you've posted.

-- 
Thanks,
Oliver
