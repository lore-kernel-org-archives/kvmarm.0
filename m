Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F5D1548C;
	Tue,  8 Jul 2025 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751997793; cv=none; b=TCYrslMjcciy/tjl0sMFlbOCLOUUg8QBpmaNx2nJqSi6ySOEt9+r4I8n8JnjQ+Rn1DO3uwSpK4scse/Fd1spUSjLPdbdBaH7L2YF/D8f51ZkMAh/P2xFzdSPMFOFDLTqxx4Na3yW5XCJD8wRfp+Q+q2ZltYx1Tk6Sj7CZqkDGnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751997793; c=relaxed/simple;
	bh=VoEolaFTJNzpKG4M2/ParplG0VvzAYfss/xgoyqHWa0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=McpmJeS536i7oNyIRSqw74ox3Jn6NdTy6z7H9GVZfM7Gs9l65FVGsGwJ5VhEfurvLrJmvpEWhvJkAVWRjIMYD/y2CwwcndMwSxnvgWeA43IDTzSfWzcS3Aw8fELsh6Y6hhkI05YWycnzzHxot9t6fqRieDTCiC2DI+kn9sfqRnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tnX7/fT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tnX7/fT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53A8C4CEED;
	Tue,  8 Jul 2025 18:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751997792;
	bh=VoEolaFTJNzpKG4M2/ParplG0VvzAYfss/xgoyqHWa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnX7/fT629zWKB7jluJEr8dLn9RwRvK1aJHFo/IkmlA6aVqpfizgL7O6bZywJyLMi
	 9SykPdXaIGfB3CgTkDfn8za3yqKwowCGsz1fk6gol3kSRiC/ZLx4bL1kxFNtTVxyXn
	 /7c7WCEid61YOWxnhpeqjGbKIFPGs/TT5KxoIKFY6/nJrVoEou/21YnVK1B99IYufi
	 bjfseF6L/4FDvKB/tnj+4WfGgFVO4qOWzWO1iKG6hDImJnOAUm1qSnrk47UwDPS+C0
	 +5cRPunQW9Etyk+dXooY5gwddqOJnpS4bUesJfTLtxtOwqhLYGIhRfiCmAobgJy1DM
	 A1D1HAIe88iPg==
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v23 0/4] arm64/perf: Enable branch stack sampling
Date: Tue,  8 Jul 2025 19:02:59 +0100
Message-Id: <175198748936.383518.12260470313437607576.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250611-arm-brbe-v19-v23-0-e7775563036e@kernel.org>
References: <20250611-arm-brbe-v19-v23-0-e7775563036e@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 11 Jun 2025 13:01:10 -0500, Rob Herring (Arm) wrote:
> This series enables perf branch stack sampling support on arm64 via a
> v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details
> on BRBE can be found in the Arm ARM[1] chapter D18.
> 
> I've picked up this series from Anshuman. v19 and later versions have
> been reworked quite a bit by Mark and myself. The bulk of those changes
> are in patch 5.
> 
> [...]

Applied to will (for-next/perf), thanks!

[1/4] arm64/sysreg: Add BRBE registers and fields
      https://git.kernel.org/will/c/52e4a56ab8b8
[2/4] arm64: Handle BRBE booting requirements
      https://git.kernel.org/will/c/ae344bcb0d49
[3/4] KVM: arm64: nvhe: Disable branch generation in nVHE guests
      https://git.kernel.org/will/c/d7567e9b9ba5
[4/4] perf: arm_pmuv3: Add support for the Branch Record Buffer Extension (BRBE)
      https://git.kernel.org/will/c/58074a0fce66

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
