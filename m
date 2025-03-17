Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E198202971
	for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 21:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742246778; cv=none; b=Vh6h+V193JtxxwWSGTUFtqSVoaD2U8L/kyYTspvXBLSjH9CfjXwcbv4r+74GgR5j9B3wBrD7gE1LDHPtucZWlF+OiVPrsprS7gqyojadhomUiXDluV4nI+gUuW7H0zZXulCqQU4foV9UqA1JXbEA/PXUNTE9Ee2SUKBJWG5Zlus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742246778; c=relaxed/simple;
	bh=e14NawIhXbX+rpgKdFPfVEzD7XfiMfMMeC3WCU8SXTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GM0eFsa4ZxcdDhIhR5hN7vgwvalwB8qPsKu+vVNo0r+mMmfAll1+uLkQGRKG4mIsoPY82PP/ZdLgJnYn5hPJApDAGLwltADhQFZjGsylq8SVVhK+sZIKdvGip0Tgvp+M+ReIk62ARqPWfLBxqFTIvFUThOBspwGWOupBo3JVzis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMvaMsnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMvaMsnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153D3C4CEEF;
	Mon, 17 Mar 2025 21:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742246777;
	bh=e14NawIhXbX+rpgKdFPfVEzD7XfiMfMMeC3WCU8SXTU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JMvaMsnbPJ8uauQ8F3z8KXAnLMkpC+5wZSCYWXdVAbffN+VMLD7kcQ+QymC8RNkBG
	 LWAtAglEZTtV0IfmJevbJRpwp5DltHIZTT9jYUO30DpV3dltp36ITMp4mA2gAIoDbK
	 aFPTLhS220mZteiM69TPYxS0EXxAnngA315K/HuWjOSYtpK6tELUkhT8PsC3dX7qdW
	 Sp4LIUF2EYoOGSo/uvoGPvjB0BD1fcQ1sLlesKrGii7uNBoG6M/agH9NmaPL59/aZW
	 qPj7efURhvh7DzI7O0Cmp/JJA87UrXUQ+GNsxCUv6Quv4PsDyU9RthOs/WqwTpAP7v
	 VNE6rrqAz4uOw==
Date: Mon, 17 Mar 2025 21:26:12 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>, joey.gouly@arm.com,
	kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] arm64: mitigate CVE-2024-7881 in the absence of
 firmware mitigation
Message-ID: <20250317212611.GA12724@willie-the-truck>
References: <20250128155428.210645-1-mark.rutland@arm.com>
 <174197730164.734861.6726211221092480832.b4-ty@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174197730164.734861.6726211221092480832.b4-ty@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Mar 14, 2025 at 06:37:25PM +0000, Catalin Marinas wrote:
> On Tue, 28 Jan 2025 15:54:24 +0000, Mark Rutland wrote:
> > On some CPUs from Arm Ltd, it is possible for unprivileged code to cause
> > a hardware prefetcher to form an address using the contents of a memory
> > location which is accessible by privileged accesses in the active
> > translation regime, potentially leaking the contents of this memory
> > location via a side channel. This has been assigned CVE-2024-7881:
> > 
> >   https://developer.arm.com/Arm%20Security%20Center/Arm%20CPU%20Vulnerability%20CVE-2024-7881
> > 
> > [...]
> 
> Applied to arm64 (for-next/leaky-prefetcher), thanks!
> 
> There hasn't been much review (thanks Oliver for looking at the KVM
> bits) and there's some implied work that can go on top of this series.
> But the patches looked fine to me, so I queued them. Mark or others,
> please shout if you'd like them dropped, they are on a branch.

I'm really not comfortable with this series and would prefer to see it
dropped while we continue the discussion, especially as it's causing
minor conflicts with the KVM/arm64 tree in -next.

The series is pitched a bit like an erratum workaround, but the overall
problem that a memory-dependent prefetcher can bypass permission checks
is fairly general and, even if nobody else gets this wrong, I doubt that
it's the last time Arm will mess it up. So, while the EL3 mitigation may
be Arm-specific, I don't think the rest of it really is. That's
especially true given the sorry state of spectre mitigations on
third-party derivatives of Arm designs, such as the Qualcomm Kryo parts,
and the fact that we provide userspace with a mechanism today for
querying the state of those mitigations via sysfs.

The immediate question, then, is whether this broken behaviour is
prohibited by CSV3. The text in the latest Arm ARM just refers to
"Data loaded under speculation", so it's not entirely clear whether that
applies to a prefetcher. If it *does*, then I can see the argument for
treating this like an erratum, but then we should zap CSV3 and treat
these parts as being affected by meltdown. On the other hand, if CSV3
is not intended to cover these prefetchers, then we probably need to
add a new "CVE-2024-7881" entry to /sys/devices/system/cpu/vulnerabilities.

As it stands with this patch series, userspace has no way to know about
the problem. kpti gets silently enabled in dmesg:

  | CPU features: detected: Kernel page table isolation (KPTI)

but the contents of the vulnerabilities directory is pretty misleading:

  gather_data_sampling: Not affected
  ghostwrite: Not affected
  itlb_multihit: Not affected
  l1tf: Not affected
  mds: Not affected
  meltdown: Not affected
  mmio_stale_data: Not affected
  reg_file_data_sampling: Not affected
  retbleed: Not affected
  spec_rstack_overflow: Not affected
  spec_store_bypass: Mitigation: Speculative Store Bypass disabled via prctl
  spectre_v1: Mitigation: __user pointer sanitization
  spectre_v2: Mitigation: CSV2, BHB
  srbds: Not affected
  tsx_async_abort: Not affected

The meltdown entry doesn't even mention that KPTI has been enabled.

If we decide to go with a new entry for this, then we also need to
change the default behaviour along the lines of Doug's Spectre-BHB
changes queued on for-next/spectre-bhb-assume-vulnerable so that we
assume vulnerable if we don't know better. To do otherwise will result
in false assurances to userspace on derivative and third-party
implementations.

To be clear: I'm not at all against mitigating this problem and
advertising the status of that mitigation. I *am* against quietly
handling it like a CPU erratum whilst simultaneously telling userspace
that meltdown is not a problem regardless of the mitigation state.

Will
