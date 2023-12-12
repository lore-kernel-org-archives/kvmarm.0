Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BD115AF5
	for <kvmarm@lists.linux.dev>; Tue, 12 Dec 2023 07:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qJEWx6Sv"
Date: Tue, 12 Dec 2023 07:07:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702364828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q6Z44FDt8R0+dMpUCBszFPBqGtxSLmgo/e5SgiCoAWE=;
	b=qJEWx6Svn1TLMl93UN8HpWOwT9dNiYGbVb7BmhNJaYDipXXc60AYPXwXpBqLOuEGLlbFh1
	im9f3qo/p+rUM8wTyqZlxv5TA5hGU7h51Z2s8VZ1FkLE1ws0OjdVftzeDwNudlPWBVesQn
	HrxgnU4zh0E9CZa4Tev41qS/g5oB9oI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, linux-perf-users@vger.kernel.org,
	kvmarm@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Marc Zyngier <maz@kernel.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH 2/2] perf build: Ensure sysreg-defs Makefile respects
 output dir
Message-ID: <ZXgGlxh1iNX52pLU@linux.dev>
References: <20231121192956.919380-1-oliver.upton@linux.dev>
 <20231121192956.919380-3-oliver.upton@linux.dev>
 <c701bf6b-0ff0-44a0-9d1d-84e8515d077c@sirena.org.uk>
 <ZWui3KxloT5tcIsJ@thinky-boi>
 <80ff02a5-8355-437d-b844-3de9fe182518@sirena.org.uk>
 <bec12895-38d0-46d3-8031-53c55f88f3a7@sirena.org.uk>
 <CAM9d7cirVU1sGPKT9SfmjPpFKJ2PiZ-Md52bWB=Ormbkiwvgkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM9d7cirVU1sGPKT9SfmjPpFKJ2PiZ-Md52bWB=Ormbkiwvgkw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 11, 2023 at 02:47:48PM -0800, Namhyung Kim wrote:
> Hello Oliver,
> 
> On Mon, Dec 11, 2023 at 5:19 AM Mark Brown <broonie@kernel.org> wrote:
> >
> > On Wed, Dec 06, 2023 at 01:45:56PM +0000, Mark Brown wrote:
> > > On Sat, Dec 02, 2023 at 01:34:20PM -0800, Oliver Upton wrote:
> > > > Thanks for the bug report. Apologies for the latency on my end, I've had
> > > > a mountain of non-upstream stuff to wade through.
> > > > On Wed, Nov 29, 2023 at 04:27:01PM +0000, Mark Brown wrote:
> >
> > > > > This breaks some build configurations:
> >
> > > > > make[5]: Entering directory '/home/broonie/git/bisect/tools/arch/arm64/tools'
> > > > > /home/broonie/git/bisect/tools/scripts/Makefile.include:4: *** O=../../../../tools does not exist.  Stop.
> >
> > > > Looks like its because $(PWD) is tools/testing/selftests/ when building
> > > > from the top level makefile. I'll get a fix out in the next couple days
> > > > after I find my Make dunce cap :)
> >
> > > This issue is now in Linus' tree.
> >
> > Any news on this, the problem remains in -rc5?
> 
> Have you found some time to work on it?

Thanks for the double-nudge, just sent the fix out. I'll take it
through the kvmarm tree as it only affects KVM selftests at this point.

https://lore.kernel.org/kvmarm/20231212070431.145544-2-oliver.upton@linux.dev/

-- 
Thanks,
Oliver
