Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2444166F0C;
	Thu, 19 Dec 2024 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734626735; cv=none; b=Wh2BmwNV53LDD0tXzG9yyA68Z7twddAe7xGrcm+i+6TgNSro7k0MSHdNNn0dC50Uk81LmLFusgB6g8x8UtMBsy0X+FBURsTsxSLyOfRmpxlXJc/IbH5oliZoShNQcXVTCQmum+DG4s4+2WK4RGUnzHqiTML8yxxZ24F1MA9vopQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734626735; c=relaxed/simple;
	bh=z93HmXnc81TA1fMKgPsmy/CfQOosGuiFqnEeu+NkhsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axYjmPrLed2iMPDUfX3mPDvF9XuoyTD+JY2zQ+INml78eIKQGpoG4kUvs1QmJ6/G/Pzoegf/75FkoDKWMBEEDI12VQmIuqlCJcp9N/5fnVGWnDJ5zzIvXIvPyA7OJsrT8QpOD9+ZOkToqP34SXV30SLnLuncyge35LEY4KWXCv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qLBqOUDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qLBqOUDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28886C4CECE;
	Thu, 19 Dec 2024 16:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734626734;
	bh=z93HmXnc81TA1fMKgPsmy/CfQOosGuiFqnEeu+NkhsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qLBqOUDXkpZyuXuhAV67RC04KxCF+3r857JtI2JP4+yF5ByMmECwcZAHpwVrkfwss
	 02T24N/GhJRALsDFYOWlkUu4knNSmtUzUNJSO0sIgq/fuoQ7fVz5HY/hq30mbLgzgx
	 Ewg41YcrCnbB8pecqakD83QnM8nJqjoNxXOBKF/BCzzjDVfpuc3ISyBk+OqCqFcGbh
	 puzDP+i3h8KI0FTDjIdZ/CQwsPbw8SVqnbJeNLWKovfviij1p9/IPn+xwPWnI/QkpI
	 syM7Qt6BLDWrRTMEsYcskdhfUaSjtElV7uFcRAV3NyYK83C8QmkLiJ0wpdrLU4smDv
	 /pitC3Q/mXCyw==
Date: Thu, 19 Dec 2024 16:45:28 +0000
From: Will Deacon <will@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	catalin.marinas@arm.com, corbet@lwn.net, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [RESEND RFC PATCH v1 2/5] arm64: Add BBM Level 2 cpu feature
Message-ID: <20241219164528.GH24724@willie-the-truck>
References: <20241211160218.41404-1-miko.lenczewski@arm.com>
 <20241211160218.41404-3-miko.lenczewski@arm.com>
 <87cyhxs3xq.wl-maz@kernel.org>
 <084c5ada-51af-4c1a-b50a-4401e62ddbd6@arm.com>
 <86ikrprn7w.wl-maz@kernel.org>
 <2b1cc228-a8d5-4383-ab25-abbbcccd2e2c@arm.com>
 <86h678sy00.wl-maz@kernel.org>
 <5c551e43-78e9-4336-ab16-b55c0d6c7f92@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c551e43-78e9-4336-ab16-b55c0d6c7f92@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Dec 12, 2024 at 04:03:52PM +0000, Ryan Roberts wrote:
> >>> If anything, this should absolutely check for FAR_EL1 and assert that
> >>> this is indeed caused by such change.
> >>
> >> I'm not really sure how we would check this reliably? Without patch 5, the
> >> problem is somewhat constrained; we could have as many changes in flight as
> >> there are CPUs so we could keep a list of all the {mm_struct, VA-range} that are
> >> being modified. But if patch 5 is confirmed to be architecturally sound, then
> >> there is no "terminating tlbi" so there is no bound on the set of {mm_struct,
> >> VA-range}'s that could legitimately cause a conflict abort.
> > 
> > I didn't mean to imply that we should identify the exact cause of the
> > abort. I was hoping to simply check that FAR_EL1 reports a userspace
> > VA. Why wouldn't that work?
> 
> Ahh gottya! Yes agreed, this sounds like the right approach.

Please, can we just not bother handling conflict aborts at all outside of
KVM? This is all dead code, it's complicated and it doesn't scale to the
in-kernel use-cases that others want. There's also not been any attempt
to add the pKVM support for handling host-side conflict aborts from what
I can tell.

For now, I would suggest limiting this series just to the KVM support
for handling a broken/malicious guest. If the contpte performance
improvements are worthwhile (I've asked for data), then let's add support
for the CPUs that handle the conflict in hardware (I believe this is far
more common than reporting the abort) so that the in-kernel users can
benefit whilst keeping the code manageable at the same time.

Will
