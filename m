Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965192D7805;
	Mon, 24 Nov 2025 19:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764011928; cv=none; b=mmK++MCMRQoeFvQn0LnpdckRDVbbQcdCeXjdJzUgzkpBO0lNZIRftgrzJbBlJ54tsSuD1/cK3VSpH7C3zXl2iwq2gHCzPX1xVWTJ+WDfmdICAOoiKxdmOc/bDzl7+BVhkwhKMERANTfBcXvz70Vv4/0+Mm5LLSMel8G7eKMxqXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764011928; c=relaxed/simple;
	bh=rDkSwbW4xoasbdAG1a25incEAfgJNunRzcR8e9Kx9qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jmvAX3wMEwR/GwQK2fwuvJq6bBMWeR5/zfDNRLJFXSRmRru7J8ChS6VPb8C2XbJuGeM35USsvpuWul2EH30736uuSKaYnjHcLk12IfB5bF3X1HAvOKXL3eTVmYo/dPDK30gEmiurHlM2YMRD8OShj5JfUwdf4VEIX99giGXIFmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7Vox0ti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7Vox0ti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD7AC4CEF1;
	Mon, 24 Nov 2025 19:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764011928;
	bh=rDkSwbW4xoasbdAG1a25incEAfgJNunRzcR8e9Kx9qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7Vox0tiC6aEBy+NvJaadSN3/y2+MnSeI16LLh4WWU7Wt1gcm7dngn98Eidpbh+Zi
	 uiiuASO0fqEp+TXKWvf0/zEp9FV1oGU+xaNcZpFi7aTPesnk81dS6cBEoRFZz6gotJ
	 0XG1DpTk1Y9N1fjuK1rCaYdIxKvwLfw2bNAkA/22FbzwPXFISHtAO5ky794Fp8f5Pn
	 ikwAnf3fH6xzB/d29obYib/CuWsaz3JJpw8MhGpEHoPo8LXM48dX5S3uFQkfMeuUVV
	 pXHjDz2toelygeC/7FhZnqgn/omotVps3GjsGPCkppJ+Z3SDoDzdpgv02dQxBQwaWh
	 S7uz3yF4CeFmQ==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
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
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v10 0/5] perf: arm_spe: Armv8.8 SPE features
Date: Mon, 24 Nov 2025 19:18:31 +0000
Message-Id: <176399995950.525942.8372760882667197136.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251111-james-perf-feat_spe_eft-v10-0-1e1b5bf2cd05@linaro.org>
References: <20251111-james-perf-feat_spe_eft-v10-0-1e1b5bf2cd05@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 11 Nov 2025 11:37:54 +0000, James Clark wrote:
> Support SPE_FEAT_FDS data source filtering.
> 

Applied kernel changes to will (for-next/perf), thanks!

[1/5] perf: Add perf_event_attr::config4
      https://git.kernel.org/will/c/cbbfba4847b8
[2/5] perf: arm_spe: Add support for filtering on data source
      https://git.kernel.org/will/c/e6a27290d800

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
