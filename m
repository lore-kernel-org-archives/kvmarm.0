Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0AF36604A
	for <kvmarm@lists.linux.dev>; Thu,  2 Apr 2026 20:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775163436; cv=none; b=S9eT7mmgp94q6ruSEJCWiflpf/uP6FOUvjO/ED4TT3o/gT/qBQr5zaVoifvY2qYv8clOtJLeEGC2usl/R2dL2snSZqHJcpOCaQjvwpCWOg4VWR5HqMyvxTSLyY8KkHBEkQ+3RzxU/PFqw+X6Ea4SznX5ki+mpQ8NlSQAVL0pK90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775163436; c=relaxed/simple;
	bh=fZl342qtKB38he9YQmesSx4GGcj0I4dAAHkc0sOsHLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoZqhsl6cYaPTgxPpp9lJCJCvzfYnuJBDKCIw/2YQ8e4/nAZIaoB0Igq7i8MU9vQp+mzseD0TKBijpotV4ygdNw35lFJVq91sDGlVaci61N1RBb2zCOcwQz+PrzJNye4GexuiEcHSYBrt+5TfFOGxKwVByeccgwvTOz2haZQX2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bgvMaCiq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bgvMaCiq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C92B91692;
	Thu,  2 Apr 2026 13:57:06 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B2443F915;
	Thu,  2 Apr 2026 13:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775163432; bh=fZl342qtKB38he9YQmesSx4GGcj0I4dAAHkc0sOsHLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bgvMaCiqbCN/lyG0i3b+yh8LEvUAjeo/0QxdTvnIrbA0vhMYZXmCMfhjisiv9bNmA
	 MO8WXAvJZksdQYC0e5hWYXkzR36DtrFduME5GSvJOwUvXMXlHuF3fWBbhjG49Nrbhp
	 kD2ke6G1Y1wwHDSdgZG8aDR4PyNYPSqsdEMNHYSU=
Date: Thu, 2 Apr 2026 21:57:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Walleij <linusw@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] arm64: clear_page[s] using memset
Message-ID: <ac7YJPo4Np2zxxEp@arm.com>
References: <20260306-aarch64-clear-pages-c-v1-1-77c1bb0f1c21@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-aarch64-clear-pages-c-v1-1-77c1bb0f1c21@kernel.org>

On Fri, Mar 06, 2026 at 09:57:50AM +0100, Linus Walleij wrote:
> There is no need to try to second-guess the compiler when
> clearing memory. Just call memset() like everyone else.

Hmm, that "like everyone else" made me think - why not move this to
generic code and only the 1-2 platforms that need their own should
override it? Could we do the same with copy_page()?

Sorry, more work all of a sudden ;).

> Since memset() already has an architecture-local MOPS
> optimization, we do not need to do anything else to preserve
> the MOPS optimization.

The custom clear_page() had the (very small) advantage that it can skip
the length/alignment checks as they are always page-size.

> While at it, implement the shorthand for directly calling
> the new prototype clear_pages() for larger page chunks.
> 
> No performance regressions can be seen, the fastpath
> benchmarks differences are in the noise.

I assume the benchmarks ran on real hardware (had to ask, last time you
mentioned qemu ;)).

-- 
Catalin
