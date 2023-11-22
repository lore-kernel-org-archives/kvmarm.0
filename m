Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9421BDE3
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 21:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="elMacsvx"
Date: Wed, 22 Nov 2023 21:16:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700687793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FtkB3WRJGr4ha0DG1Li5z6m49TI+zCGBX8jzTT52wUM=;
	b=elMacsvx0WKSJxFo72l/UWLEb4w8/TeAcTUe2CUmEWi7K1LAhONjM2GGzEEfYewbjHJv9+
	atYD2Jb2ICDZAXcOOQcuE3MlLQsct2EK48gN81B3TUJLWjuP/J4BH4TNg7GDSRq4LKM9KC
	VuWzkuz8zWQo3SmtSQO8dEzjIQ8Mjz8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ian Rogers <irogers@google.com>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/2] perf build: Fixes for arm64 sysreg-defs build rules
Message-ID: <ZV5vrMmBplJjNPo6@linux.dev>
References: <20231121192956.919380-1-oliver.upton@linux.dev>
 <CAP-5=fU3MdtsayuvLja-_-Sc11+SivPXENMhztwPA6bMugdLSA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP-5=fU3MdtsayuvLja-_-Sc11+SivPXENMhztwPA6bMugdLSA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 22, 2023 at 12:36:12PM -0800, Ian Rogers wrote:
> On Tue, Nov 21, 2023 at 11:30 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Small series to address the issues Ian raised in [*]. Tested with
> > perf-targz-src-pkg and building arm64 KVM selftests.
> >
> > [*] https://lore.kernel.org/linux-perf-users/CAP-5=fXxiOJMVqaH1JPU_K6+1GhaEgVeR7YyN+F0r7qTE8DGEw@mail.gmail.com/
> >
> > Oliver Upton (2):
> >   tools perf: Add arm64 sysreg files to MANIFEST
> >   perf build: Ensure sysreg-defs Makefile respects output dir
> 
> Sorry for missing these, scripts/get_maintainer.pl will recommend
> linux-kernel@vger.kernel.org so this didn't show in my review pile due
> to my email filters.

Yeah, I'd been in the (meaningless) habit of dropping the LKML
firehose for KVM changes, though I see it actually has an L: entry
for perf. My bad.

> Tested-by: Ian Rogers <irogers@google.com>

Appreciated!

-- 
Thanks,
Oliver
