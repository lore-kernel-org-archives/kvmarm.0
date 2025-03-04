Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9AF1FCCF7;
	Tue,  4 Mar 2025 11:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741087512; cv=none; b=V3VFPKfGHSIdmynlNWIweL3Wr14p61zj3GTbZFFfhV147VW0NihW0GpGDZH/O+8eqGmBE/R2KmA0iKtTzRuAiEcaXrRFCXVUYN4xH5WMR8qpxi04uBmPx9fUTxRbeqWDVJ2kH9R2CVhm0X0e+IBpoknRobM8r/4uwkLk9jhxsmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741087512; c=relaxed/simple;
	bh=Zj99QU+1T4AumhagELbWhW6sNQ5PMl7nw6neJbMlvJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FH9RUvN8i5acuUBXiB7QDn65x2rEmux87JzBfdC1t0e666GKW00UA3NUgft7yiAEdCpYXnGdL0QNxK9vZxAqhuLoVDHeK7CqyRwVdMDtCIcoOirBjkEADqdOR++8L0IC/b4Fu6KjPJ+YvM+wW34q5MujXyMdnfUGIJKADel3R8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30551C4CEE5;
	Tue,  4 Mar 2025 11:25:08 +0000 (UTC)
Date: Tue, 4 Mar 2025 11:25:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>, kernel-team@android.com,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v20 00/11] arm64/perf: Enable branch stack sampling
Message-ID: <Z8bjEm_neWdMBNYv@arm.com>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <174080569248.3208873.17639032755999041028.b4-ty@kernel.org>
 <CAL_JsqLijFG1PFkqKk7hXzC=aj70OLQsXwC280QsCO=PnCVZYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqLijFG1PFkqKk7hXzC=aj70OLQsXwC280QsCO=PnCVZYg@mail.gmail.com>

On Mon, Mar 03, 2025 at 10:44:21AM -0600, Rob Herring wrote:
> On Sat, Mar 1, 2025 at 1:05 AM Will Deacon <will@kernel.org> wrote:
> > On Tue, 18 Feb 2025 14:39:55 -0600, Rob Herring (Arm) wrote:
> > > This series enables perf branch stack sampling support on arm64 via a
> > > v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details
> > > on BRBE can be found in the Arm ARM[1] chapter D18.
> > >
> > > I've picked up this series from Anshuman. v19 and v20 versions have been
> > > reworked quite a bit by Mark and myself. The bulk of those changes are
> > > in patch 11.
> > >
> > > [...]
> >
> > Applied cleanups to will (for-next/perf), thanks!
> >
> > [01/11] perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0() before enabling counters
> >         https://git.kernel.org/will/c/04bd15c4cbc3
> > [02/11] perf: arm_pmu: Don't disable counter in armpmu_add()
> >         https://git.kernel.org/will/c/dcca27bc1ecc
> > [03/11] perf: arm_pmuv3: Don't disable counter in armv8pmu_enable_event()
> >         https://git.kernel.org/will/c/4b0567ad0be5
> > [04/11] perf: arm_v7_pmu: Drop obvious comments for enabling/disabling counters and interrupts
> >         https://git.kernel.org/will/c/7a5387748215
> > [05/11] perf: arm_v7_pmu: Don't disable counter in (armv7|krait_|scorpion_)pmu_enable_event()
> >         https://git.kernel.org/will/c/7bf1001e0d91
> > [06/11] perf: apple_m1: Don't disable counter in m1_pmu_enable_event()
> >         https://git.kernel.org/will/c/c2e793da59fc
> > [07/11] perf: arm_pmu: Move PMUv3-specific data
> >         https://git.kernel.org/will/c/dc4d58a752ea
> 
> I don't know if you looked at the thread on patch 11 and said "long
> discussion, I'll assume a new version is coming. Next!" because that's
> what I would do. In this case though, there's not any changes.

I do this as well ;). But I think Will is waiting for Mark R to look at
the rest of the series.

-- 
Catalin
