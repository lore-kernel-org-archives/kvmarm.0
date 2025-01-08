Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613F91A239D;
	Wed,  8 Jan 2025 12:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736339927; cv=none; b=X0x0DX3TY/7+QBNDytpX39FfSe7HPQ9DVI415L5uwiP0FsduDqEPbQuVPJskuHI4fhxrwQSBeUFGswKKhPYN/G6DkKlFf1S5b8M3TC6/hD6P64aeLUV8VT2tIUD5WYHEIi0SdKOzdSDgyG6NspbZ4AtLmFdTm4WFlKcAhHKlNQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736339927; c=relaxed/simple;
	bh=mLAJdLoN9h4bkCdI7kmcjMyVeLTRBumWzuPyPWQzzzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=deFOCmcl/buaTWScdMPHCCsRGe72d+J/ShL/k+MKJUu1jEBpkKLXl2JMylybpSf1JW5bR/+tmgMez1pyvkMNIG8StayIbfESwXZMA2wajAkvvVKk7aBmCB2qT4QOdTFfEh6vP3u6Qkj9pdzz5xKVyw+mBx4ZJiSjNEX//DTc//g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+q5fQME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+q5fQME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B92C4CEDD;
	Wed,  8 Jan 2025 12:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736339927;
	bh=mLAJdLoN9h4bkCdI7kmcjMyVeLTRBumWzuPyPWQzzzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D+q5fQMEttwesjS6DPxWd36hXgQfNbcbwiCG2Cc5GxhrVmZDUSmUZ7m3JpH/JOOAs
	 aGtPiyBe4aApMhwoLLa4UBYPebjDyp9yYSuWx/mYzXLkjpMbj90mG3WOoTSJDAvXZG
	 12BhvMLHaaw322KIQgkXJnsRv+OvGoNbM7gmP47V0WHJHYzxMu1MXw9i3T4XEDWwfU
	 L1kiC2gHNlMdTjlfZmUjI4fLjvZASbNSIzHriiBEmIcA9S0w9IYF5ORU8LY46T5a6K
	 6OeVSOikbOHj4f6SMinowzBvNiyJggZ7PhLKfY17X8pZicWugb3fZaKWXjI6J0l7vF
	 sOFUTydIveYvA==
Date: Wed, 8 Jan 2025 12:38:41 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] KVM: arm64: Support FEAT_PMUv3 on Apple hardware
Message-ID: <20250108123840.GA9197@willie-the-truck>
References: <20241217212048.3709204-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217212048.3709204-1-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Oliver,

On Tue, Dec 17, 2024 at 01:20:30PM -0800, Oliver Upton wrote:
> One of the interesting features of some Apple M* parts is an IMPDEF trap
> that routes EL1/EL0 accesses of the PMUv3 registers to EL2. This allows
> a hypervisor to emulate an architectural PMUv3 on top of the IMPDEF PMU
> hardware present in the CPU.
> 
> And if you squint, this _might_ look like a CPU erratum :-)
> 
> This series takes advantage of these IMPDEF traps to provide PMUv3 to
> KVM guests. As a starting point, only expose the fixed CPU cycle counter
> and no event counters. Conveniently, this is enough to get Windows
> running as a KVM guest on Apple hardware.
> 
> I've tried to keep the deviation to a minimum by refactoring some of the
> flows used for PMUv3, e.g. computing PMCEID from the arm_pmu bitmap
> instead of reading hardware directly.

What's your plan for this series? I started looking at it and I can take
the first four apple_m1 patches if you like?

Will
