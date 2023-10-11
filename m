Received: from out-210.mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6517039946
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 18:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QsEW8oO5"
Date: Wed, 11 Oct 2023 18:05:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697047518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xRTgX+Dt/2jA3rPcRQK47Ac8WI7XuDHgVx6Sck8TIV4=;
	b=QsEW8oO59znRSH20Z881Su3EwC+j9t1fxQ/8bITL/6ii3NQdDjbGFM+T82lhR0HavTkHqX
	A4yjoj0FEpN7RZq+qlYv68ucpDOURHnpLcpTTMnuTNdNPsOsHkeeEesaSrF2r7TGZMEEXQ
	dLo9uawYW2yW7zaY2UGkQYfi3psRujo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	Jing Zhang <jingzhangos@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/5] tools headers arm64: Copy sysreg-defs generation
 from kernel source
Message-ID: <ZSbj16o2FYOTn9DL@linux.dev>
References: <20231010011023.2497088-1-oliver.upton@linux.dev>
 <20231010011023.2497088-2-oliver.upton@linux.dev>
 <871qe1m79u.wl-maz@kernel.org>
 <cef524b7-ecbc-44c4-a582-e39f495c53db@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cef524b7-ecbc-44c4-a582-e39f495c53db@sirena.org.uk>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 11, 2023 at 05:59:28PM +0100, Mark Brown wrote:
> On Wed, Oct 11, 2023 at 05:51:57PM +0100, Marc Zyngier wrote:
> > Oliver Upton <oliver.upton@linux.dev> wrote:
> 
> > > The system register definitions are now generated with a script over in
> > > the kernel sources. Pull a copy into tools in anticipation of updating
> > > dependent header files and add a common makefile for generating the
> > > header.
> 
> > Rather than a copy, which makes the maintenance pretty horrible, why
> > don't you just symlink it? Git is perfectly capable of storing them,
> > last time I checked.
> 
> Do we even need to symlink - as I suggested on the previous version can
> we not just reference the script and data file directly in the main
> kernel tree?  Like I said then there may be some use case for building
> the tools directory outside the kernel source that I'm not aware of but
> otherwise I'm not clear that the motivations for copying the actual
> headers for use in tools/ apply to these files.
> 
> I think the current approach is *fine* (hence my reviewed by) 
> given the amount of other copying but it would save a bit of work to not
> copy.

So long as we aren't going to do any further renames I don't have an
issue with this approach.

-- 
Thanks,
Oliver
