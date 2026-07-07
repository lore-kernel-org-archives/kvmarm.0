Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486E23D648A;
	Tue,  7 Jul 2026 22:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783463323; cv=none; b=XHFMsXASaPVrw8lCE5kiGohMm0xEh76q774uHXTs+eldKkL5ToQgJT0k0AwZUJgBetM9RAmiUtElKfnk+FdZf8V6mQVeHzaJSChgTdwqkjvx/Mb6iEEtilTjdvn8N0THQIF9NsnPLq5NKXKxgVRXU3+5/RqFHiq0x5SNMXiGrDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783463323; c=relaxed/simple;
	bh=xGDYk6xDOKByKK05UQxie3eir73pAUq12CctMIuRkOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ffmOt6T9n58e7g+l84wMMzzhUZZfIYcNfQEA1xjxWSvy9haT2H9jw1FDpEDZS4EQJdrpEfZvdvH5EZta5zG/MdYiLVNYAiV8DqZP9Gm3ELKkR18NkNtIeb0VIsA/utzUjpuPvQFileCS6zi8L4TCE1Xrk2Fj6gonoNrfdxBoQ5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOBVJ4rD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOBVJ4rD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC171F000E9;
	Tue,  7 Jul 2026 22:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783463321;
	bh=gRwsNtR9CmtI1lg+FRZhNFP3aUE1T9mC+krBoHEi9x4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FOBVJ4rD5rTTQo3ydEtA3gAO9+lIGI/CrNJ8ssAZ4DAYgwFZpMeoTFKCV+sJUEuae
	 7VC5wJWuZ8EgPLQfZzDm3hsFwOzJ8GaZw2t+XEGov7LfPlSe+HL+8/iYeQtjJ3G5UF
	 WDdG6dFwpxpBhr0i+IhPPtJRFSDOmz6C/LG+zOeA4im1A8BgNLOjeiYsK64Dv0QnHd
	 cdeaWbicwd1r9Ua/g/c4bLWDvHNgWjKX2VB7e9xd4sM1fZBlXqUTlxLs67iJImtLZu
	 zC/fXH/oT8idmoroS8l7xYg8cfuP+AtXx4KDFhWDOdm81Sg0CKjHW++PKrsa7xZhTp
	 pjx7Fw2TwUmyQ==
Date: Tue, 7 Jul 2026 15:28:40 -0700
From: Oliver Upton <oupton@kernel.org>
To: Congkai Tan <congkai@amazon.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Haris Okanovic <harisokn@amazon.com>,
	Geoff Blake <blakgeof@amazon.com>,
	Stanislav Spassov <stanspas@amazon.de>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
Message-ID: <ak19mPPWcupFwfuE@kernel.org>
References: <20260702190421.420992-1-congkai@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702190421.420992-1-congkai@amazon.com>

Hi Congkai,

Thanks for respinning.

On Thu, Jul 02, 2026 at 07:04:18PM +0000, Congkai Tan wrote:
> Today when the perf tool runs in a guest on cores with PMUv3p4, it fails
> to parse the default metrics with "Failure to read '#slots'", since perf
> can only read 0 from sysfs caps/slots, which is backed by PMMIR_EL1.SLOTS
> that KVM traps as RAZ/WI.
> 
> Taking into account backward compatibility and heterogeneous systems, the
> exposure of PMMIR_EL1.SLOTS is gated behind a new vCPU feature flag:
> 
> - Patch 1 adds the new flag KVM_ARM_VCPU_PMU_V3_STRICT. When set, KVM does
>   not create a default PMU during vCPU init, and the VMM must select one
>   explicitly via KVM_ARM_VCPU_PMU_V3_SET_PMU before the first KVM_RUN.
> - Patch 2 exposes PMMIR_EL1.SLOTS of the selected PMU under the flag, and
>   adds userspace get/set for PMMIR_EL1 so that SLOTS can be reset to 0
>   for backward compatibility.
> - Patch 3 stops masking STALL_SLOT* in PMCEID1 under the flag.

I think the series is starting to shape up. Few more things to address:

 - Didn't mention it in v1, but writes to PMCR_EL0.N should be ignored
   when V3_STRICT is set. We now have a vCPU attribute for configuring
   event counters and the register-based thing is just broken :)

 - The vCPU feature flag needs a corresponding KVM_CAP so userspace can
   detect it

 - In terms of patch ordering, the vCPU flag / KVM_CAP exposure should
   come last after all the behavior changes are implemented (and
   flag-guarded)

 - Move enforcement of a non-NULL arm_pmu to kvm_arm_pmu_v3_init() since
   userspace must call KVM_ARM_VCPU_PMU_V3_INIT before KVM_RUN

 - Prevent the PMU event filter from being configured until a hardware
   PMU has been selected

I've addressed all of this locally and pushed to my tree [*]. Untested,
as always :) Would you be able to give it a spin?

Also, do you have VMM patches for using the new feature flag?

[*]: https://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git/log/?h=kvm-arm64/pmu-7.3

Thanks,
Oliver
