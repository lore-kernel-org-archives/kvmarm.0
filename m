Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DB73D82
	for <kvmarm@lists.linux.dev>; Sat,  2 Dec 2023 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AYUcQBzG"
Date: Sat, 2 Dec 2023 13:34:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701552867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sjSntkPxJKsPUXxeDgx4XEqkbmarHuPvi1UWulVMFL4=;
	b=AYUcQBzGVOe7k6dvYMqaUbSndNrAVp+hg2NhhiNfvKUnyYRT2neP98F3TEPCtxKGHBFjfU
	NF8w8N9+b2kBWPvwjZz8ZqZz0qCq5j6DcZv3MgJdfyO8lBd9yp2nw9Jf3TV3l6w46bhn06
	c4HiIg0aoM+BmXBR+LYUj2JgdGk4utg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] perf build: Ensure sysreg-defs Makefile respects
 output dir
Message-ID: <ZWui3KxloT5tcIsJ@thinky-boi>
References: <20231121192956.919380-1-oliver.upton@linux.dev>
 <20231121192956.919380-3-oliver.upton@linux.dev>
 <c701bf6b-0ff0-44a0-9d1d-84e8515d077c@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c701bf6b-0ff0-44a0-9d1d-84e8515d077c@sirena.org.uk>
X-Migadu-Flow: FLOW_OUT

Hey Mark,

Thanks for the bug report. Apologies for the latency on my end, I've had
a mountain of non-upstream stuff to wade through.

On Wed, Nov 29, 2023 at 04:27:01PM +0000, Mark Brown wrote:
> On Tue, Nov 21, 2023 at 07:29:56PM +0000, Oliver Upton wrote:
> 
> > Currently the sysreg-defs are written out to the source tree
> > unconditionally, ignoring the specified output directory. Correct the
> > build rule to emit the header to the output directory. Opportunistically
> > reorganize the rules to avoid interleaving with the set of beauty make
> > rules.
> 
> This breaks some build configurations:
> 
> Running:
> 
> make --silent --keep-going --jobs=56 O=/home/broonie/.cache/tuxmake/builds/16/build ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 defconfig
> make --silent --keep-going --jobs=56 O=/home/broonie/.cache/tuxmake/builds/16/bu
> ild INSTALL_PATH=/home/broonie/.cache/tuxmake/builds/16/build/kselftest_install 
> ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 kselftest-install
> 
> gives:
> 
> make[4]: Leaving directory '/home/broonie/git/bisect/tools/testing/selftests/kex
> ec'
> make[4]: Entering directory '/home/broonie/git/bisect/tools/testing/selftests/kvm'
> Makefile:270: warning: overriding recipe for target '/home/broonie/.cache/tuxmake/builds/16/build/kselftest/kvm/get-reg-list'
> Makefile:265: warning: ignoring old recipe for target '/home/broonie/.cache/tuxmake/builds/16/build/kselftest/kvm/get-reg-list'
> make -C ../../../../tools/arch/arm64/tools/ O=../../../../tools
> make[5]: Entering directory '/home/broonie/git/bisect/tools/arch/arm64/tools'
> /home/broonie/git/bisect/tools/scripts/Makefile.include:4: *** O=../../../../tools does not exist.  Stop.

Looks like its because $(PWD) is tools/testing/selftests/ when building
from the top level makefile. I'll get a fix out in the next couple days
after I find my Make dunce cap :)

--
Thanks,
Oliver
