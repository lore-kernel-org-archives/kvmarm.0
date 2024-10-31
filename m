Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF6719ADA3
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 11:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730375096; cv=none; b=KFlh7E2VUkzW9tKYpwBgA8NtoguTauXLlRhQbB9XNlXbbVqw/kNRdQyUE+hSqWPUtrgFwD2gxzk8YtXGpOOAX5PnxcDyo/X/5jSRArnU9psl7RnxvDZswN2MVk7QQzPENnmFfzdchBO+38S/QvfZyIcTqFdl9LycsrdDIOtB+0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730375096; c=relaxed/simple;
	bh=EsKKhPVgqBCkOu5lJw+j/SMklbvLSyU5vomw6CsYijo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLz6NkxtAnfPSY2j1IAs9B5GfPc8E414cy/U73rt2XV33o8p4QTTmaz41JG6PaPH1qKX7d9WbIzMQw+lqYP15xe2OmgreRZYPao5OB2qQF5iGCaQLMhB91/iRM5cXkF0j/161asAE/oP5gFzhnweoc8P3ZhVkJgFSOXJskbhy6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92066C4CEDE;
	Thu, 31 Oct 2024 11:44:53 +0000 (UTC)
Date: Thu, 31 Oct 2024 11:44:51 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	anshuman.khandual@arm.com, gshan@redhat.com, james.morse@arm.com,
	shameerali.kolothum.thodi@huawei.com, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 3/7] arm64: cpufeature: discover CPU support for MPAM
Message-ID: <ZyNtsz5RNk6dU17x@arm.com>
References: <20241030160317.2528209-1-joey.gouly@arm.com>
 <20241030160317.2528209-4-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030160317.2528209-4-joey.gouly@arm.com>

On Wed, Oct 30, 2024 at 04:03:13PM +0000, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> ARMv8.4 adds support for 'Memory Partitioning And Monitoring' (MPAM)
> which describes an interface to cache and bandwidth controls wherever
> they appear in the system.
> 
> Add support to detect MPAM. Like SVE, MPAM has an extra id register that
> describes some more properties, including the virtualisation support,
> which is optional. Detect this separately so we can detect
> mismatched/insane systems, but still use MPAM on the host even if the
> virtualisation support is missing.
> 
> MPAM needs enabling at the highest implemented exception level, otherwise
> the register accesses trap. The 'enabled' flag is accessible to lower
> exception levels, but its in a register that traps when MPAM isn't enabled.
> The cpufeature 'matches' hook is extended to test this on one of the
> CPUs, so that firmware can emulate MPAM as disabled if it is reserved
> for use by secure world.
> 
> Secondary CPUs that appear late could trip cpufeature's 'lower safe'
> behaviour after the MPAM properties have been advertised to user-space.
> Add a verify call to ensure late secondaries match the existing CPUs.
> 
> (If you have a boot failure that bisects here its likely your CPUs
> advertise MPAM in the id registers, but firmware failed to either enable
> or MPAM, or emulate the trap as if it were disabled)
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
