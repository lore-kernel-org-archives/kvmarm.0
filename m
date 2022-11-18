Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284AF28E1
	for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 16:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F026C433D6;
	Fri, 18 Nov 2022 16:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668790234;
	bh=2SvZU2ZbmXvIOHrpSjoDJyk8GuB3PC2eqavTqAih/c4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PDCyFX1t2lbX2Y+JbxJspQJxL5IivL9nB6T9T8jDuj1ADFyeQ6AhYtrm7AMXDTrR9
	 3A4jPSXrHBkSeATkubSjiphuP/ZAmTP4Bdu2u/gBp/NdFMaNEjisc9WUIy1/y74jHG
	 dOARPW4nFoH7nbO80T8fpwi4qxBngjNaKyW50XgZMmTTdqDjH6VQQnl/9qmNyK0gy5
	 Qa62UpjpBwrCiNE4cv2lHgSut3CLX3Ox4hvHWnz2gEi2Q7A/QqhMK0ytZ1NzsQbBtA
	 3d8r/tBKMo563L/+EBD+upeTVN/Xy+jXaNnw90FnSFpaTbsu6jGPV93yC25scr1K6u
	 UMyclmg+Rj8yA==
Date: Fri, 18 Nov 2022 16:50:26 +0000
From: Will Deacon <will@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	James Clark <james.clark@arm.com>, Mark Brown <broonie@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v3 0/8] perf: Arm SPEv1.2 support
Message-ID: <20221118165025.GB4872@willie-the-truck>
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
 <CAL_Jsq+WOjoPW0FDSa=B9-aCMwXC3tc5HUqokoVkKUucKgqanQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+WOjoPW0FDSa=B9-aCMwXC3tc5HUqokoVkKUucKgqanQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID: <20221118165026.4xx-hUpLWHOvFwFafh6RRo7VrqNBeeI1jaHP6Ju9MlI@z>

On Thu, Nov 17, 2022 at 08:43:17AM -0600, Rob Herring wrote:
> On Fri, Nov 4, 2022 at 10:55 AM Rob Herring <robh@kernel.org> wrote:
> >
> > This series adds support for Arm SPEv1.2 which is part of the
> > Armv8.7/Armv9.2 architecture. There's 2 new features that affect the
> > kernel: a new event filter bit, branch 'not taken', and an inverted
> > event filter register.
> >
> > Since this support adds new registers and fields, first the SPE register
> > defines are converted to automatic generation.
> >
> > Note that the 'config3' addition in sysfs format files causes SPE to
> > break. A stable fix e552b7be12ed ("perf: Skip and warn on unknown format
> > 'configN' attrs") landed in v6.1-rc1.
> >
> > The perf tool side changes are available here[1].
> >
> > Tested on FVP.
> >
> > [1] https://lore.kernel.org/all/20220914-arm-perf-tool-spe1-2-v2-v4-0-83c098e6212e@kernel.org/
> >
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> > Changes in v3:
> > - Add some more missing SPE register fields and use Enums for some
> >   fields
> > - Use the new PMSIDR_EL1 register Enum defines in the SPE driver
> > - Link to v2: https://lore.kernel.org/r/20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org
> >
> > Changes in v2:
> > - Convert the SPE register defines to automatic generation
> > - Fixed access to SYS_PMSNEVFR_EL1 when not present
> > - Rebase on v6.1-rc1
> > - Link to v1: https://lore.kernel.org/r/20220825-arm-spe-v8-7-v1-0-c75b8d92e692@kernel.org
> >
> > ---
> > Rob Herring (8):
> >       perf: arm_spe: Use feature numbering for PMSEVFR_EL1 defines
> >       arm64: Drop SYS_ from SPE register defines
> >       arm64/sysreg: Convert SPE registers to automatic generation
> >       perf: arm_spe: Drop BIT() and use FIELD_GET/PREP accessors
> >       perf: arm_spe: Use new PMSIDR_EL1 register enums
> >       perf: arm_spe: Support new SPEv1.2/v8.7 'not taken' event
> >       perf: Add perf_event_attr::config3
> >       perf: arm_spe: Add support for SPEv1.2 inverted event filtering
> >
> >  arch/arm64/include/asm/el2_setup.h |   6 +-
> >  arch/arm64/include/asm/sysreg.h    |  99 +++--------------------
> >  arch/arm64/kvm/debug.c             |   2 +-
> >  arch/arm64/kvm/hyp/nvhe/debug-sr.c |   2 +-
> >  arch/arm64/tools/sysreg            | 139 +++++++++++++++++++++++++++++++++
> >  drivers/perf/arm_spe_pmu.c         | 156 ++++++++++++++++++++++++-------------
> >  include/uapi/linux/perf_event.h    |   3 +
> >  7 files changed, 257 insertions(+), 150 deletions(-)
> 
> Will, any comments on this series?

Looks fine to me. Happy to queue it once the uapi change has been acked.

Will
