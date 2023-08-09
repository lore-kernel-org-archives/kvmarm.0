Received: from out-75.mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569BD63B5
	for <kvmarm@lists.linux.dev>; Wed,  9 Aug 2023 09:10:42 +0000 (UTC)
Date: Wed, 9 Aug 2023 09:10:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1691572240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mvmzvKOGcM7VTd90ZNc4xMJrUWrhIk71OKZHdX1ecXM=;
	b=qrezTWI5AElJZqV9qQGcT9+Kg1Sv+qGaGp0ABG0ROC2hAq8H45AlVEdjXZmLHcWdvrAN3v
	UzgLZj9d3z52lNjfEviNP8FCivMcqGZikDTWDs5h5Ill5r0bZfDRxCFUdB+utjW4CZS/M9
	zYb9t9t6JFETPi3apcQaXR40eklcy1Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Huang Shijie <shijie@os.amperecomputing.com>, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
	peterz@infradead.org, ingo@redhat.com, acme@kernel.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, namhyung@kernel.org, irogers@google.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org, patches@amperecomputing.com,
	zwang@amperecomputing.com
Subject: Re: [PATCH] perf/core: fix the bug in the event multiplexing
Message-ID: <ZNNYCQjsi30APZQ+@linux.dev>
References: <20230809013953.7692-1-shijie@os.amperecomputing.com>
 <864jl8ha8y.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864jl8ha8y.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 09, 2023 at 09:48:29AM +0100, Marc Zyngier wrote:

[...]

> Another question is how the same thing is handled on x86? Maybe they
> don't suffer from this problem thanks to specific architectural
> features, but it'd be good to find out, as this may guide the
> implementation in a different way.

I'm pretty sure the bug here is arm64 specific. x86 (at least on intel)
fetches the guest PMU context from the perf driver w/ irqs disabled
immediately before entering the guest (see atomic_switch_perf_msrs()).

-- 
Thanks,
Oliver
