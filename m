Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5D2341666
	for <kvmarm@lists.linux.dev>; Wed, 20 Aug 2025 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755702725; cv=none; b=L4G1a5VFec+111C0Bbb2ejE5jpR6p/w6clQYam0/Y+ug9XPyOI+9yZW4/6bWY2/zqwU9/dqWYww/p5TU1VgNRO697GyN20MDUXFk/oR2HGY7Mg5z4kS+1scTe172PaDepN3hiVOjA+iOyrHoLcD4oQK0OnRg1ZeuBgEZUShbiL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755702725; c=relaxed/simple;
	bh=bKySXmogrdywUpuJaQEVkaR1IVoL1YNv1ljg9g1gKVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MwESkoY0P4Oz/nI/zsXLcWkm7tOknn+ND63atfRJY3GwpD+3B/CBiRWv9yoRImu5qIOzwP8yvsUf0S9Ri9fEtVNG0fV55cJvP5w39PfD7MojaVDvEFb3WTuObUDlrYtVfS8sDmv6mrSMj2Z7plwayPXX7g9SHKDp39wVfq9Nc3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C892F1D31;
	Wed, 20 Aug 2025 08:11:55 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AC2E3F738;
	Wed, 20 Aug 2025 08:12:00 -0700 (PDT)
Date: Wed, 20 Aug 2025 16:11:57 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	oliver.upton@linux.dev, anshuman.khandual@arm.com, robh@kernel.org,
	james.morse@arm.com, mark.rutland@arm.com, joey.gouly@arm.com,
	ahmed.genidi@arm.com, kevin.brodsky@arm.com,
	scott@os.amperecomputing.com, mbenes@suse.cz,
	james.clark@linaro.org, frederic@kernel.org, rafael@kernel.org,
	pavel@kernel.org, ryan.roberts@arm.com, suzuki.poulose@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 0/5] initialize SCTRL2_ELx
Message-ID: <aKXlvcqM90197MiJ@e133380.arm.com>
References: <20250813120118.3953541-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250813120118.3953541-1-yeoreum.yun@arm.com>

Hi,

On Wed, Aug 13, 2025 at 01:01:13PM +0100, Yeoreum Yun wrote:
> This series introduces initial support for the SCTLR2_ELx registers in Linux.
> The feature is optional starting from ARMv8.8/ARMv9.3,
> and becomes mandatory from ARMv8.9/ARMv9.4.
> 
> Currently, Linux has no strict need to modify SCTLR2_ELx—
> at least assuming that firmware initializes
> these registers to reasonable defaults.
> 
> However, several upcoming architectural features will require configuring
> control bits in these registers.
> Notable examples include FEAT_PAuth_LR and FEAT_CPA2.

This looks OK overall to me, apart from some confusion between
SCTLR_ELx and SCTLR2_ELx in patch 2 (see my comments there).

This code will need to be tested somehow.  Do you have any thoughts on
this?  Hacking the bootwrapper, KVM and/or kvmtool may provide a way of
checking what happens when the kernel is entered with "wrong" initial
values in relevant bits (HRCX_EL2.SCTLR2En, SCTLR2_EL{1,2}).


Regarding the patch history:

> Patch History
> ==============
> from v2 to v3:
>   - rewrite commit messages.
>   - fix missing SCTLR2_EL2 synchonization at boot.
>   - https://lore.kernel.org/all/20250811163340.1561893-1-yeoreum.yun@arm.com/
> 
> from v1 to v2:
>   - rebase to v6.17-rc1
>   - https://lore.kernel.org/all/20250804121724.3681531-1-yeoreum.yun@arm.com/

Going forwards, can you try to make sure that significant changes to
the series are all mentioned here?

I didn't have time to look at v2, and in the meantime half of the
series disappeared and a chunk of code was moved from one patch to
another.  I saves reviewers some time and effort if they do not have to
dig through previous review conversations in order to understand what
changed between versions of a series.

(No need to mention every trivial change, though.)

Cheers
---Dave
