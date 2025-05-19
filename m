Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C806A26A1DA;
	Mon, 19 May 2025 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747663877; cv=none; b=WXBxSksG1RBQ02FixWaLCC9vFdwJyo2gqDAGt7MgUsUC0/DtbQRuvt8zA0qZenLa4Y9sCNgcQOpv5ZneFDosb72X0COtkrmavWe4JiVnHPzXCRPklg+n2xHuaLUZsnI7TAx2BSyDXiaYNoaZ3zYnjnvjnNsmdKB14rGjXRltmJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747663877; c=relaxed/simple;
	bh=e1ejy1mxpIjt2Bw3FSFixCpdrvKaPbVj5b42czyYzxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMpclgJrUM/4xXc+Es7QOv7z2OZbiyYR0/2bx1UhDVcgO2xVvT/NBhaYUTiw45Di+R9xwZJ7TN3kv/YjNhvGCB8prisMtVRz5iN5uX4sy/MKhN27n6YoG8FXjSKWJA3LiDzdKvGFIrmjLBEhO4UeXBLVjRc1TBmrLzc3Ord500Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuwiVYBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuwiVYBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA3BC4CEE4;
	Mon, 19 May 2025 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747663877;
	bh=e1ejy1mxpIjt2Bw3FSFixCpdrvKaPbVj5b42czyYzxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UuwiVYBOmT0r42eJ2BqI4kUGWbraux+H8fHr1YvAZeA9N9XwhGUYwmIXillv60Ih9
	 /kCS7UbncUQhT1kEgfPVltZdCiGO4EanQSEKr8vci8xkPu27AYe1tHnGn0g6pHiVRi
	 4N3l359n5U3jgumzYPeuR5rRhukDobMO2WzWpCRDMJUhT87QF8K7EJJe0lQ8kMu1X/
	 5eqDmq7Q0tRQuOm7M3bogWphHNV/480ddeGJLnGUXZifEC24lUKmPMAzMUn22R7wr7
	 IZ8UWdYDSsMQlvY/GZFu9phFXmpLAj7fz8By3/nS93KPzpNrJkpwxddkt66syizpKC
	 SfoWiaf3/nmPA==
Date: Mon, 19 May 2025 15:11:11 +0100
From: Will Deacon <will@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v21 3/4] KVM: arm64: nvhe: Disable branch generation in
 nVHE guests
Message-ID: <20250519141106.GC16991@willie-the-truck>
References: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
 <20250407-arm-brbe-v19-v21-3-ff187ff6c928@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407-arm-brbe-v19-v21-3-ff187ff6c928@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Apr 07, 2025 at 12:41:32PM -0500, Rob Herring (Arm) wrote:
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
> Tested-by: James Clark <james.clark@linaro.org>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> v20:
>  - Reword commit message about no guest recording.
>  - Add BRBE to __kvm_vcpu_run() synchronization comment
> 
> v19:
>  - Rework due to v6.14 debug flag changes
>  - Redo commit message
> ---
>  arch/arm64/include/asm/kvm_host.h  |  2 ++
>  arch/arm64/kvm/debug.c             |  4 ++++
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 32 ++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c   |  2 +-
>  4 files changed, 39 insertions(+), 1 deletion(-)

This one also needs reviewing from the KVM/arm64 side...

Will
