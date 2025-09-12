Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C4030BBBD;
	Fri, 12 Sep 2025 16:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757694986; cv=none; b=cVURg06F4KCQhK7T3YLPYsjl2CksHzZqK1dQcj3JvdBWX0uQwR5o77dJBOKTakBrYDZYtgB202DANXWSY+ODg6/Rxpf+/WV08KlWleEknI+B2XH9vGPYkN7Tr0Uex6rkoog2deYN3WPrG/GVB/RjNkR4B/i7z1aVYULtdK2id3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757694986; c=relaxed/simple;
	bh=i+bYZ6TViQNkoDvTDAKCWvdZ5hLEM1EXikOYriAlkLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MF7Jip1j5PuV3stDoObAudN7b8Vi9XbULui2QytTxEEhyIOiA9oQHV/4IxSBwMo3UKjn1OdK0zk0iSrNKFsrWiXYroVhYAd+GLiCUjTsFGrg75OplM9PT+EsWCUzJMSqPsSfm/ZP4ik3G+OSukAYT3QOWLTmCP9TOXevwoFKxho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03545C4CEF1;
	Fri, 12 Sep 2025 16:36:22 +0000 (UTC)
Date: Fri, 12 Sep 2025 17:36:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Will Deacon <will@kernel.org>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 RESEND 5/6] arm64: futex: small optimisation for
 __llsc_futex_atomic_set()
Message-ID: <aMRMBEdro1YJ5RLW@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-6-yeoreum.yun@arm.com>
 <aMLqsez5y9R6FIdJ@willie-the-truck>
 <aML2fwGfeubY6HgA@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aML2fwGfeubY6HgA@e129823.arm.com>

On Thu, Sep 11, 2025 at 05:19:11PM +0100, Yeoreum Yun wrote:
> > > +static __always_inline int
> > > +__llsc_futex_atomic_set(int oparg, u32 __user *uaddr, int *oval)
[...]
> > Hmm, I'm really not sure this is worthwhile. I doubt the "optimisation"
> > actually does anything and adding a whole new block of asm just for the
> > SET case isn't much of an improvement on the maintainability side, either.
> 
> TBH, I had the same question, but I thought this code seems to modify
> freqenetly, I decide even a small optimisation -- reduce one instruction
> only.
> 
> But I don't have strong opinion for this patch.
> If it's not good for maintainability perspective,
> This patch can be dropped.

I'd drop it for now unless you can show some performance benefits
(unlikely).

-- 
Catalin
