Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9071C128369;
	Wed, 10 Jul 2024 12:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720614988; cv=none; b=TabFeX7vFH8ZEN8niyy5oqqRcKMSrM6dJ+rwFL0F1p1pRw/YnkrZX4Igdi9TK0BT8O6Rv4XM1M2WRQ9sarfOYYKMeCwTddRJj7jwpiaYNmNhyyELI+XCvkex4kGvREg4e2tLfiN7CZz5/8EulL3X97slVwxyEHn4YVuX/7aqtTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720614988; c=relaxed/simple;
	bh=Y4Al+y2W175lU4nuPuJc7qg78aq+qmDqDJ0XFPiR0qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLwJ5BE7Ijwr3s72HxcIbigUtTwj2MsHZA4595/57mX+If5qiqxi6fUq0shgAqRvxdBojcMCk0wlZBWDcW7tkWI3YbXnLvWVtHhztUukPHyu5Unv6mCw8Gf/k+hOC0HgwbgELegMw79K1ORptv7KoGL42Ei/jB89cWjIobe1VGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXFxNTcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXFxNTcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AFEC32781;
	Wed, 10 Jul 2024 12:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720614988;
	bh=Y4Al+y2W175lU4nuPuJc7qg78aq+qmDqDJ0XFPiR0qg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PXFxNTczHjo8Pn6CMsxF5GxaFs9FIwMXtAf9rKkX5vEHvZMdgBDUy5SpN1ZW/kgil
	 ZCZkCPmDFjBmxoJbx35WGsbyBW2zAFTy31a5aVBxKdA69vvx1FbDgTdgoapZXIgmS6
	 bIDWvflWRo0Boa/8X/b/VqvEw7K0nnLCsjDe1EnMQ4JPF5GcdlhlKpscNgrwXsGxdn
	 0fBI6Qe7mh++WOIB/T7uGFKiaS9/bNGcw9vnCTpaXQZIeQ2uGSOBFlH6/gI5CrMBN+
	 uIeU5MV1K69500Mia8cyCigJNxEKOZFc6tpprU4tz45iFABhgEv0jU6/xxlIQVnYGO
	 VS3IdlNlBb8mQ==
Date: Wed, 10 Jul 2024 13:36:20 +0100
From: Will Deacon <will@kernel.org>
To: Russell King <linux@armlinux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Clark <james.clark@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Cc: kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 00/12] arm64: Add support for Armv9.4 PMU fixed
 instruction counter
Message-ID: <20240710123620.GA14423@willie-the-truck>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
 <172001203729.3396033.17013529444643308853.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172001203729.3396033.17013529444643308853.b4-ty@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Jul 03, 2024 at 03:38:44PM +0100, Will Deacon wrote:
> On Wed, 26 Jun 2024 16:32:24 -0600, Rob Herring (Arm) wrote:
> > This series adds support for the optional fixed instruction counter
> > added in Armv9.4 PMU. Most of the series is a refactoring to remove the
> > index to counter number conversion which dates back to the Armv7 PMU
> > driver. Removing it is necessary in order to support more than 32
> > counters without a bunch of conditional code further complicating the
> > conversion.
> > 
> > [...]
> 
> Applied to will (for-next/perf), thanks!
> 
> [01/12] perf: arm_pmuv3: Avoid assigning fixed cycle counter with threshold
>         https://git.kernel.org/will/c/81e15ca3e523
> [02/12] perf: arm_pmuv3: Drop unnecessary IS_ENABLED(CONFIG_ARM64) check
>         https://git.kernel.org/will/c/598c1a2d9f4b
> [03/12] perf/arm: Move 32-bit PMU drivers to drivers/perf/
>         https://git.kernel.org/will/c/8d75537bebfa
> [04/12] perf: arm_v6/7_pmu: Drop non-DT probe support
>         https://git.kernel.org/will/c/12f051c987dc
> [05/12] perf: arm_pmuv3: Include asm/arm_pmuv3.h from linux/perf/arm_pmuv3.h
>         https://git.kernel.org/will/c/d688ffa26942

I've had an off-list report that this series causes a kernel crash under
KVM unit tests (panic in write_pmevtypern()).

Given that I don't have enough information to repro/debug and Catalin is
tagging the arm64 branch for 6.11 today, I've dropped patches 6-12 for
now. Please can you send a fixed version after the merge window?

Cheers,

Will
