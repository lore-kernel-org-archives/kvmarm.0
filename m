Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E86E2780E4
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 16:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741105550; cv=none; b=gLZftnlK0Y3i/Lx4UWIwVnEuBHGOuHnfw2uacVLB91DyH/ojo97/JLC4IodKCp9zdtVxVz/NfcLJnJP8aS5+FidNZrd/fQC4YZ/tTUk0AAZRpb1wn8OInV0iNqpQz3FXBB/yjWJRHG0B9OgBumPZ8y+W834lIIEVW4OFAVsfH6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741105550; c=relaxed/simple;
	bh=7joMoRPYn7I+O+FHoWsTud02cmpn2zlQxRxktM9D2Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8z+tUhLR0QxYpCwLsed9Qg9c2Ql+pJzcwVtXUspFRRVftRQNl2iiZ/5KgP9oKSeFHzl9IEqhOYTYIiTAIdGjm9kKtgu4KpahCmIbWXeKAsUaw/ZNGsBUW1NFzDdbXAQJFmr6T7Bmx7Qr4uq+xt+QWseuOPF8hojpnFrEwiKT+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A8CF497;
	Tue,  4 Mar 2025 08:26:01 -0800 (PST)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09DB23F5A1;
	Tue,  4 Mar 2025 08:25:44 -0800 (PST)
Date: Tue, 4 Mar 2025 16:25:38 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Rob Herring <robh@kernel.org>, Will Deacon <will@kernel.org>,
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
Message-ID: <Z8cpgsxG4RrDoTKR@J2N7QTR9R3.cambridge.arm.com>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <174080569248.3208873.17639032755999041028.b4-ty@kernel.org>
 <CAL_JsqLijFG1PFkqKk7hXzC=aj70OLQsXwC280QsCO=PnCVZYg@mail.gmail.com>
 <Z8bjEm_neWdMBNYv@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z8bjEm_neWdMBNYv@arm.com>

On Tue, Mar 04, 2025 at 11:25:06AM +0000, Catalin Marinas wrote:
> On Mon, Mar 03, 2025 at 10:44:21AM -0600, Rob Herring wrote:
> > On Sat, Mar 1, 2025 at 1:05 AM Will Deacon <will@kernel.org> wrote:
> > > On Tue, 18 Feb 2025 14:39:55 -0600, Rob Herring (Arm) wrote:
> > > > This series enables perf branch stack sampling support on arm64 via a
> > > > v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details
> > > > on BRBE can be found in the Arm ARM[1] chapter D18.
> > > >
> > > > I've picked up this series from Anshuman. v19 and v20 versions have been
> > > > reworked quite a bit by Mark and myself. The bulk of those changes are
> > > > in patch 11.
> > > >
> > > > [...]
> > >
> > > Applied cleanups to will (for-next/perf), thanks!
> > >
> > > [01/11] perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0() before enabling counters
> > >         https://git.kernel.org/will/c/04bd15c4cbc3
> > > [02/11] perf: arm_pmu: Don't disable counter in armpmu_add()
> > >         https://git.kernel.org/will/c/dcca27bc1ecc
> > > [03/11] perf: arm_pmuv3: Don't disable counter in armv8pmu_enable_event()
> > >         https://git.kernel.org/will/c/4b0567ad0be5
> > > [04/11] perf: arm_v7_pmu: Drop obvious comments for enabling/disabling counters and interrupts
> > >         https://git.kernel.org/will/c/7a5387748215
> > > [05/11] perf: arm_v7_pmu: Don't disable counter in (armv7|krait_|scorpion_)pmu_enable_event()
> > >         https://git.kernel.org/will/c/7bf1001e0d91
> > > [06/11] perf: apple_m1: Don't disable counter in m1_pmu_enable_event()
> > >         https://git.kernel.org/will/c/c2e793da59fc
> > > [07/11] perf: arm_pmu: Move PMUv3-specific data
> > >         https://git.kernel.org/will/c/dc4d58a752ea
> > 
> > I don't know if you looked at the thread on patch 11 and said "long
> > discussion, I'll assume a new version is coming. Next!" because that's
> > what I would do. In this case though, there's not any changes.
> 
> I do this as well ;). But I think Will is waiting for Mark R to look at
> the rest of the series.

Sorry for the delay there.

I'm happy with the structure of this; my only remaining concern is the
filtering logic, as it is surprisingly subtle, and when I was last
working on that it wasn't clear to me whether we could alwways filter
appropriately (or whether it'd be better to reject scheduling of events
with mismatched filters).

I'll try to page that in and properly attack that soon, but aside from
that concern the series as a whole looks good to me.

Thanks,
Mark.
