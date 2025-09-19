Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8BF313D77;
	Fri, 19 Sep 2025 14:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758291784; cv=none; b=CQ/Wnp5jGgfJjnQ+wPb58SKRF7fOoggg43f5Ck1kavAERtzSgnVUoy12+TMpDS9RgGTKGgc4M6pKgikvRtCqbEj9r0xCmbwMdB3WvVF2PW8J61bCDHJIEMaFMMRnyn/3FEHaNGDsbDr3TPLElV08MaJj+nsJBOWSFAGUswwElZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758291784; c=relaxed/simple;
	bh=MfwfWkTjerbB+d0i0G5HNE7kmzRVIYGXEQB1Ikndv9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XLLI1LeFuvJEWwhMaOKfim1dt6PRyah/UhcF2sdwzGs4arzoY/rrb+usr3nJyck6YbjOmdbbnOp9NoGbQnUNAyFX5UCch0LHZnJdRtO/upqIkYAq9E6etujuYO/jpyTCmRz+dEYmA082PEbRkVZxj+CpvYM80sPL/ybsvdmWfxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ix+5Ng0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ix+5Ng0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5554C4CEF0;
	Fri, 19 Sep 2025 14:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758291783;
	bh=MfwfWkTjerbB+d0i0G5HNE7kmzRVIYGXEQB1Ikndv9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ix+5Ng0c5FySNsg5NyTGgDyZXSKOJoVks2r1a3pdh4TAmjDqenF/d02gxLt54YdXx
	 ZQRhNpdGL26W7TlRy/7uNemM3pYEgibOnzl6bQu4FZ3rVEiKbEmngfKVPWAHYLM+Oh
	 qlyonPjHkdOxhtyJybFwOeK4NmvzisXgHcRTYfyZbdUXUtnkn0TNN8Gws7MY6JdYP3
	 ITsyHzAYKOcfyf4N9NTQxAyyQSM3CN9dLUkb4h+icuMYUlBzScChPaVA/9U94itbK3
	 ey9jB1yIFk/I1R6hJ7bKg6s7Q2tc1CYNv0sKk/0IadPKpH7mmpZcf9ZmKjx+MEipKL
	 7xOxyNA/aeODg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzc0r-00000007noh-0mIt;
	Fri, 19 Sep 2025 14:23:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Leo Yan <leo.yan@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Clark <james.clark@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: (subset) [PATCH v8 07/12] KVM: arm64: Add trap configs for PMSDSFR_EL1
Date: Fri, 19 Sep 2025 15:22:57 +0100
Message-ID: <175829175713.1763751.2418893976885655605.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250901-james-perf-feat_spe_eft-v8-7-2e2738f24559@linaro.org>
References: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org> <20250901-james-perf-feat_spe_eft-v8-7-2e2738f24559@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, corbet@lwn.net, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, leo.yan@arm.com, anshuman.khandual@arm.com, james.clark@linaro.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 01 Sep 2025 13:40:36 +0100, James Clark wrote:
> SPE data source filtering (SPE_FEAT_FDS) adds a new register
> PMSDSFR_EL1, add the trap configs for it. PMSNEVFR_EL1 was also missing
> its VNCR offset so add it along with PMSDSFR_EL1.
> 
> 

Applied to next, thanks!

[07/12] KVM: arm64: Add trap configs for PMSDSFR_EL1
        commit: 557c82a4480719f64cf6530b5090001e9d908904

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


