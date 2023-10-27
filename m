Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110BBA5B
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 00:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DrEUuxvA"
Date: Fri, 27 Oct 2023 00:59:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698368352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AeRy8vuS6mrpGOBLOgfWIOKLb2ahrPwA4SS8/6tbWeg=;
	b=DrEUuxvAI5ctCub2sN1eN21Qzg72HY0TsBDPr1bqy3GTnsXoFfYI9bPzXhydi6npanWckZ
	2vdktmxqMmE7FJkllnjnVZ5su/xzOdTDPPDsGqMrVQWA7WX3N25/0Ze9lkOKW6hG2PcaBE
	nHl++HiTXgzE1rrnGHguiWBvGrujEB0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 3/5] KVM: selftests: Generate sysreg-defs.h and add to
 include path
Message-ID: <ZTsLWQZWtSnZFaVr@linux.dev>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-4-oliver.upton@linux.dev>
 <d625c6b75a7ec5508470517b6744afbb95e22657.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d625c6b75a7ec5508470517b6744afbb95e22657.camel@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT

Hi Nina,

Apologies, I missed this email in my inbox and happened to see it on
lore.

On Mon, Oct 23, 2023 at 03:53:59PM +0200, Nina Schoetterl-Glausch wrote:

[...]

> > +ifeq ($(ARCH),arm64)
> > +arm64_tools_dir := $(top_srcdir)/tools/arch/arm64/tools/
> > +GEN_HDRS := $(top_srcdir)/tools/arch/arm64/include/generated/
> > +CFLAGS += -I$(GEN_HDRS)
> > +
> > +prepare:
> > +	$(MAKE) -C $(arm64_tools_dir)
> > +else
> > +prepare:
> 
> This is a force target, all targets depending on this one will always have their recipe run,
> so we'll pretty much rebuild everything.
> Is this intentional?

No, I just wasn't thinking about what I was doing :)

I've sent out a fix for this, plan to have it resolved before sending
out the PR for 6.7.

[*] https://lore.kernel.org/kvmarm/20231027005439.3142015-3-oliver.upton@linux.dev/

-- 
Thanks,
Oliver
