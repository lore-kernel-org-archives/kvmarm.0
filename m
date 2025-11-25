Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4682C2264D3;
	Tue, 25 Nov 2025 18:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094797; cv=none; b=nL6yMpKn+wxAua9CPjdEGJDvt3kmgWxE7TPUECsHJ8kAEt/wny37hQ4qQeqajbj47zq4Uq1q7ubBrugHKZRWDJ/iKRMZHeaHBwX6f1bCs0aAkLXFCm3v/01o7SmYkiGTN5GkP6ojXswk/it4+ro9mwEVSMBCn7ysAuunIs20NUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094797; c=relaxed/simple;
	bh=JqVxqmKgveQ4mM7FHqLJrAlhvzcxt5uAmECWD1G3BDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNLuw+gqvELfdw2eTQ1CxO7jmBrOxO3BltwrVWD08iDPR5OLZYS6gMUm4YUvHL2Ijm0p2kj/WjQr24Bph1ji3bO/HE+5K8cz6xct5V3kkEbg77XT7aYrke04zEyUG6BA6pKMqD9TYhl2LnZAgYkr5WFZ9Q+GPt7514UHNOvCOV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FoYLN0TK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FoYLN0TK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFB1C4CEF1;
	Tue, 25 Nov 2025 18:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764094796;
	bh=JqVxqmKgveQ4mM7FHqLJrAlhvzcxt5uAmECWD1G3BDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FoYLN0TK91L60aqjWus5gtSj8eX812KlfpiKTBBu552TlhYlvZOO0koBhaQR7WI4q
	 IgeXNBmuQtlPIJ5EFRyJgJ6y4vNjXi+Po48mlfwrJh4xYdJxO5DhazCm3FYRwa48Rs
	 2/S2j3YinT37RDY3To0krQUcN2Gj+k4iu1bBuLgZ+rAgwuaSfrGD4Cdj8P5Tf/dsC5
	 y59zGnIbIN21a+aEn45awi9p+iZ/Xe7swJi5R4ldjdAemdSaklfqvB2INxYkygo7RQ
	 9wiWZ13YN7qEnYx0SmzG4259wjEe/EepLM3eghXZP4MCLmHMi8CVlIKCUk35wQ85q/
	 wIerVhSPQve8g==
Date: Tue, 25 Nov 2025 10:19:51 -0800
From: Namhyung Kim <namhyung@kernel.org>
To: James Clark <james.clark@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>, Leo Yan <leo.yan@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v10 0/5] perf: arm_spe: Armv8.8 SPE features
Message-ID: <aSXzR2Fp5N4-c0q5@google.com>
References: <20251111-james-perf-feat_spe_eft-v10-0-1e1b5bf2cd05@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251111-james-perf-feat_spe_eft-v10-0-1e1b5bf2cd05@linaro.org>

On Tue, Nov 11, 2025 at 11:37:54AM +0000, James Clark wrote:
> Support SPE_FEAT_FDS data source filtering.
> 
> ---
> Changes in v10:
> - Pick up Peter's ack
> - Slightly clarify commit message regarding the difference between the
>   data source filter and the data source
> - Link to v9: https://lore.kernel.org/r/20251029-james-perf-feat_spe_eft-v9-0-d22536b9cf94@linaro.org
> 
> Changes in v9:
> - Fix another typo in docs: s/data_src_filter/inv_data_src_filter/g
> - Drop already applied patches for other features. Only the data source
>   filtering patches remain.
> - Rebase on latest perf-tools-next
> - Link to v8: https://lore.kernel.org/r/20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org
> 
> Changes in v8:
> - Define __spe_vers_imp before it's used
> - "disable traps to PMSDSFR" -> "disable traps of PMSDSFR to EL2"
> - Link to v7: https://lore.kernel.org/r/20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org
> 
> Changes in v7:
> - Fix typo in docs: s/data_src_filter/inv_data_src_filter/g
> - Pickup trailers
> - Link to v6: https://lore.kernel.org/r/20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org
> 
> Changes in v6:
> - Rebase to resolve conflict with BRBE changes in el2_setup.h
> - Link to v5: https://lore.kernel.org/r/20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org
> 
> Changes in v5:
> - Forgot to pickup tags from v4
> - Forgot to drop test and review tags on v4 patches that were
>   significantly modified
> - Update commit message for data source filtering to mention inversion
> - Link to v4: https://lore.kernel.org/r/20250721-james-perf-feat_spe_eft-v4-0-0a527410f8fd@linaro.org
> 
> Changes in v4:
> - Rewrite "const u64 feat_spe_eft_bits" inline
> - Invert data source filter so that it's possible to exclude all data
>   sources without adding an additional 'enable filter' flag
> - Add a macro in el2_setup.h to check for an SPE version
> - Probe valid filter bits instead of hardcoding them
> - Take in Leo's commit to expose the filter bits as it depends on the
>   new filter probing
> - Link to v3: https://lore.kernel.org/r/20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org
> 
> Changes in v3:
> - Use PMSIDR_EL1_FDS instead of 1 << PMSIDR_EL1_FDS_SHIFT
> - Add VNCR offsets
> - Link to v2: https://lore.kernel.org/r/20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org
> 
> Changes in v2:
> - Fix detection of FEAT_SPE_FDS in el2_setup.h
> - Pickup Marc Z's sysreg change instead which matches the json
> - Restructure and expand docs changes
> - Link to v1: https://lore.kernel.org/r/20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org
> 
> ---
> James Clark (5):
>       perf: Add perf_event_attr::config4
>       perf: arm_spe: Add support for filtering on data source
>       tools headers UAPI: Sync linux/perf_event.h with the kernel sources
>       perf tools: Add support for perf_event_attr::config4
>       perf docs: arm-spe: Document new SPE filtering features

Applied the tools part to perf-tools-next, thanks!

Best regards,
Namhyung

