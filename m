Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19102566C3
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 10:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740393713; cv=none; b=ttlZ4KOCruE0jrh40PksTiMmUCSKxFv4AfItuKLusPinGocRrEqpYYqwm6Ul6SrOwm8Xmq0686sswUe1DnEE0EjA9rPNIO8//b2UzFa0YcPQ3YfTQpWk5PDPIPxIsuax7zJRAfaQeLJDb0DgUBCfD6oEesV2qW2yS4buyjBI0WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740393713; c=relaxed/simple;
	bh=3Y3ZOO9s+/mYUog6IBL0uyGuQRaI25SQd5ojDRezSZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/VDbFpbSjBjJNSoyW3eYf34BkmtXzOLB4+HI7VhLq0o+dS+OUeL/Pf6U0/4hT+tH1J9RxjGWPo1qcFCRbJAX9ZXXnojksiVPX7R55BPOZ6JXVSW19Zx+RDrRMPsx0Bc+Adk/BqXU7H3QFgzu7qvIi/mUlR0ucuQud3tMAGdWgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07D9D1FCD;
	Mon, 24 Feb 2025 02:42:07 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB8713F673;
	Mon, 24 Feb 2025 02:41:49 -0800 (PST)
Date: Mon, 24 Feb 2025 10:41:47 +0000
From: Leo Yan <leo.yan@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v20 10/11] KVM: arm64: nvhe: Disable branch generation in
 nVHE guests
Message-ID: <20250224104147.GD8144@e132581.arm.com>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <20250218-arm-brbe-v19-v20-10-4e9922fc2e8e@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218-arm-brbe-v19-v20-10-4e9922fc2e8e@kernel.org>

On Tue, Feb 18, 2025 at 02:40:05PM -0600, Rob Herring (Arm) wrote:
> 
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> While BRBE can record branches within guests, the host recording
> branches in guests is not supported by perf (though events are).
> Support for BRBE in guests will supported by providing direct access
> to BRBE within the guests. That is how x86 LBR works for guests.
> Therefore, BRBE needs to be disabled on guest entry and restored on
> exit.
> 
> For nVHE, this requires explicit handling for guests. Before
> entering a guest, save the BRBE state and disable the it. When
> returning to the host, restore the state.
> 
> For VHE, it is not necessary. We initialize
> BRBCR_EL1.{E1BRE,E0BRE}=={0,0} at boot time, and HCR_EL2.TGE==1 while
> running in the host. We configure BRBCR_EL2.{E2BRE,E0HBRE} to enable
> branch recording in the host. When entering the guest, we set
> HCR_EL2.TGE==0 which means BRBCR_EL1 is used instead of BRBCR_EL2.
> Consequently for VHE, BRBE recording is disabled at EL1 and EL0 when
> running a guest.
> 
> Should recording in guests (by the host) ever be desired, the perf ABI
> will need to be extended to distinguish guest addresses (struct
> perf_branch_entry.priv) for starters. BRBE records would also need to be
> invalidated on guest entry/exit as guest/host EL1 and EL0 records can't
> be distinguished.
> 
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Co-developed-by: Rob Herring (Arm) <robh@kernel.org>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>

Reviewed-by: Leo Yan <leo.yan@arm.com>
