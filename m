Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D0634D4CE
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 09:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791968597; cv=none; b=gSpYRVTqUemx2ubh9b+vIj3k1epB4RKtjCiwouR151W0Z3NkedrdED9dGHUppOPqXFPhcEPvOsRPb25gdPWiFXDJ9SJKdNfxEfunJ5CXC51DOUZRJIcyYvw9XvQd3NMTsUkaurJsB+kDioIA+uxkgli4u4W+hvrG9YHOH2tdoxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791968597; c=relaxed/simple;
	bh=7A05GsuFKMCSCusEHwAE+GYyrPrUSYy7spZfdDk0d+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nL6ZBCsZefNUqt+SZrGh5wH4jYl33XD+fjrO0gondX8WMjZhtk07Hu37v6pKeSkqqmlgROc7rXJ2WOEMSL1GkXOt/yKebKx7qVPBlcDAGhPAdCbrmqc8UYV3uuXPB6zo/pinuNuv0i6duQpuYS82mCsoDXgjzyKmdqGpDnwRvPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YoKyykGB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YoKyykGB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A34661596;
	Wed, 14 Oct 2026 02:03:04 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 334523F7B4;
	Wed, 14 Oct 2026 02:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791968587; bh=7A05GsuFKMCSCusEHwAE+GYyrPrUSYy7spZfdDk0d+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YoKyykGBv0d5ue1IA9pDqAIBz0IsC4ds1IPAVcDI3VyYRFIpLsbgh+PjOfqESJYLM
	 nKkMwtRvL8O0B3NL+W7trm/B/1/A1l/+YsTkw6Y3cm3AJ6d5wvTe7xoa967irdGd/t
	 ou+P9TNgOMpuhAmmkHefuL9+QewRyRRDClluU2po=
Date: Wed, 14 Oct 2026 10:03:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Walleij <linusw@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	Leonardo Bras <leo.bras@arm.com>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2] arm64: clear_page[s] using memset
Message-ID: <as9FRpnL7851aTVj@arm.com>
References: <20260916-aarch64-clear-pages-c-v2-1-0393769f7912@kernel.org>
 <aqq1sxdQNZ93oV9A@LeoBrasDK>
 <aqq7oZzutLP82WYB@LeoBrasDK>
 <arP619hd9Rx8Vlrx@arm.com>
 <ec298ee5-5080-494d-b735-7ba7bd20cdf0@arm.com>
 <as4sY3Eq-B_59lW9@arm.com>
 <CAD++jLmMoD_FPno2Q47WyWicpRaf8x46YREt0eyUzAXkOU5cFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD++jLmMoD_FPno2Q47WyWicpRaf8x46YREt0eyUzAXkOU5cFA@mail.gmail.com>

On Tue, Oct 13, 2026 at 06:28:54PM +0200, Linus Walleij wrote:
> On Tue, Oct 13, 2026 at 3:04 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > Trying to make sense of the above. So based on -next of 22nd of
> > September, the table means:
> >
> > vanilla         - next/master on that day (current clear_page())
> > patch           - memset()-based clear_page() patch (Linus's patch)
> > stnp            - vanilla clear_page() without DC ZVA
> > patch_stp       - memset()-based clear_page() patch without DC ZVA
> >
> > I assume the vanilla vs patch columns are just noise. Well, there's a
> > -1.17% regression (not flagged) on Ampere but what's the standard
> > deviation for this column? Similarly for the -1.15% on the AWS patch_stp
> > test (vs stnp in the same test, it's no worse).
> >
> > Vanilla vs stnp shows a regression on Ampere, however that's expected as
> > we no longer do the DC ZVA. Interestingly, the patch_stp result doesn't have
> > this regression, so I reckon DC ZVA behaves mostly in line with STP on
> > this hardware.
> >
> > Basically I was looking for the stnp vs patch_stp results. If I read it
> > correctly, there's no significant change going from non-temporal to
> > temporal stores (and a small improvement for Ampere). Assuming future
> > FEAT_MOPS will have similar behaviour, moving clear_page() to memset()
> > shouldn't cause any regressions. Before FEAT_MOPS, we'll use DC ZVA here
> > anyway.
> 
> That almost sounds like an Acked-by if Usama can confirm your
> assumptions above!

It's queued but we can revert it if it shows real regression.

-- 
Catalin
