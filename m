Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0721C28E7
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 12:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0853DC433EF;
	Tue,  7 Feb 2023 12:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675773778;
	bh=JVybZG/af25FtT5MIn8vwGANiFyx3YmRZsIluskfyi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V5/W1xnxs1ZmPu/CLYT6v+6ppZS1ZtONnX/OGJjnqE4/ATQoY0qPJbGFg7Duc7WWa
	 ZriJFVwo95o/jKuBCYdlQt+NMWPyjjUanDvOMTktIZQnf1AMQwQb0Uy7z4DxG3YzmV
	 PdVFpHQFo3yAhpHwE65VfOZ1Eq86VVGFdAQ8dBSjjL3VIbEns1jlxEloRZiyJyLoOY
	 ESZl8hXM3PTViqlwBKSS6uL/iWdFWh1BuSXDLaTp9oqUqs97+1cqqVsrkHXV9Yd80s
	 IKyGKdyWwitqfIes/7M7H9sbwfdN7PUJDI5q4/CsJWhWnExFtsGEN+zvX5NXW0BS+Z
	 Kb8lxOzKop6Iw==
Date: Tue, 7 Feb 2023 12:42:51 +0000
From: Will Deacon <will@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Rob Herring <robh@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, Mark Brown <broonie@kernel.org>,
	linux-kernel@vger.kernel.org, James Clark <james.clark@arm.com>,
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/8] perf: Arm SPEv1.2 support
Message-ID: <20230207124250.GA12385@willie-the-truck>
References: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
 <167577072188.364892.17496441030141801452.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167577072188.364892.17496441030141801452.b4-ty@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Feb 07, 2023 at 12:39:43PM +0000, Will Deacon wrote:
> On Mon, 09 Jan 2023 13:26:17 -0600, Rob Herring wrote:
> > Peter, this series is blocked on an ack from you on patch 7. There was
> > some discussion on validation of the 'config3' attr. The options where
> > laid out by Mark here[0]. Please chime in on your preference.
> > 
> > Will, can you pick up patches 1-6 at least if there's no progress on
> > 'config3'.
> > 
> > [...]
> 
> Applied to will (for-next/perf), thanks!
> 
> [1/8] perf: arm_spe: Use feature numbering for PMSEVFR_EL1 defines
>       (no commit info)
> [2/8] arm64: Drop SYS_ from SPE register defines
>       (no commit info)
> [3/8] arm64/sysreg: Convert SPE registers to automatic generation
>       (no commit info)
> [4/8] perf: arm_spe: Drop BIT() and use FIELD_GET/PREP accessors
>       (no commit info)
> [5/8] perf: arm_spe: Use new PMSIDR_EL1 register enums
>       (no commit info)
> [6/8] perf: arm_spe: Support new SPEv1.2/v8.7 'not taken' event
>       (no commit info)
> [7/8] perf: Add perf_event_attr::config3
>       https://git.kernel.org/will/c/09519ec3b19e
> [8/8] perf: arm_spe: Add support for SPEv1.2 inverted event filtering
>       https://git.kernel.org/will/c/8d9190f00a97

I should've trimmed this, but just in case of confusion: I'd already picked
up 1-6 prior to Peter's ack on the UAPI change. So now the whole series
should be in tomorrow's -next with any luck.

Thanks!

Will
