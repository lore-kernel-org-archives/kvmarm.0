Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4DEB425
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 19:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E06EC43392;
	Thu, 19 Jan 2023 19:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674155368;
	bh=iqElF+5KvmM//jBrqlLXQndx5m+4yQtolDOFBeaA/wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jh3PlJZ2XOmkkoQ3OVuoYo3JF6T0PRCK+Fk4Obs3I7zpaHJLpXznnDuDin/T9IJix
	 Sc+7K3ZG6nU/6XDpoCZxfxsZH9tZkLmtOb5RT85uUnGjpBh/wHjwPGT1N/phVyzuIC
	 ROaM+o6JqoMcAaoVgwsnmlW4iHATXxGDvpJBOhcAZ8FTNG4xSzyH3Rslno6+MvGq8u
	 NHf+hYe93tgZVPIs0FDdAZqf7DIzRIEd9e2Q++qTmhnjLoWsB2dIuRJntvumGOej5v
	 /afTUvIK5WOfMWi+FJwsEJrm8W3oihsiTV/G6WW/JpxMG2GxhghPV+Q5Fp+3T6blwf
	 bzblWWGT6fMZw==
From: Will Deacon <will@kernel.org>
To: Rob Herring <robh@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Marc Zyngier <maz@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Namhyung Kim <namhyung@kernel.org>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	James Clark <james.clark@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v4 0/8] perf: Arm SPEv1.2 support
Date: Thu, 19 Jan 2023 19:08:42 +0000
Message-Id: <167415232681.3429847.16616826041230061721.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
References: <20220825-arm-spe-v8-7-v4-0-327f860daf28@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 09 Jan 2023 13:26:17 -0600, Rob Herring wrote:
> Peter, this series is blocked on an ack from you on patch 7. There was
> some discussion on validation of the 'config3' attr. The options where
> laid out by Mark here[0]. Please chime in on your preference.
> 
> Will, can you pick up patches 1-6 at least if there's no progress on
> 'config3'.
> 
> [...]

Applied first six driver changes to will (for-next/perf), thanks!

[1/8] perf: arm_spe: Use feature numbering for PMSEVFR_EL1 defines
      https://git.kernel.org/will/c/e080477a050c
[2/8] arm64: Drop SYS_ from SPE register defines
      https://git.kernel.org/will/c/c759ec850df8
[3/8] arm64/sysreg: Convert SPE registers to automatic generation
      https://git.kernel.org/will/c/956936041a56
[4/8] perf: arm_spe: Drop BIT() and use FIELD_GET/PREP accessors
      https://git.kernel.org/will/c/2d347ac23362
[5/8] perf: arm_spe: Use new PMSIDR_EL1 register enums
      https://git.kernel.org/will/c/05e4c88e2b5c
[6/8] perf: arm_spe: Support new SPEv1.2/v8.7 'not taken' event
      https://git.kernel.org/will/c/4998897b1e96

UAPI change needs feedback from perf core maintainers.

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
