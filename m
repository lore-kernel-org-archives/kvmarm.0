Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C712136657B
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 18:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772215670; cv=none; b=K03O9h4WTGHsE3eEh3AzojOU+TrcBdo/kyr+L4pLAO4e0sC2sWbyBQUSyNGjWv+g0aiA7Ds7rWDCQH6MSsZcZ4FELet3fYUpevC8ajTzaprH0rlY+MVaKMdAe2nsw4Lq5a+mmqt7j5Shd+wi91ldgSdiQrH0lFlJDUdOPjngz6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772215670; c=relaxed/simple;
	bh=1JaPmS/NjlHcJLGjdFc4aDc/hp52cYihGMOI5f7LB8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fYhR0pKv6eMZL7UKDWr7MDMQqHcWSj+9Bxs5mjWTG0rVSxcy9ucuVk30vNsswRCjdpZmNb1+z6NljRH5ZQ8UG4USFd3mPuP5H/myNJLNOUPUreKDO6seZjJ8fcI1YQR1mLv06NGU8w5o4wAUYfq7RAWSlolW4EZoH+0LecYedok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WzsHFuy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WzsHFuy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE74C116C6;
	Fri, 27 Feb 2026 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772215670;
	bh=1JaPmS/NjlHcJLGjdFc4aDc/hp52cYihGMOI5f7LB8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WzsHFuy7pm+FNqHNSbLlMp8LoQC8o4Qo4GqEJGKmeQRt3Awa4nmDwygz2u4p20Gyp
	 mvsxs4hfjGHx7ga/TckwTLTS+qtG/ohlpTTOyX6PgulVPdcR8PvO3JkQosmO1UjxU0
	 LRlh5yDe9eZqjWqE0VZebK254zyuVbHyBYY7clnE2pp7nsF0YsMn8KTOt+yyQuBaao
	 dvQwauZSsB/EFOr6C2ctGC3XEq/Nlssj1smP8lSmH7KWPmUBFTfw1NmigKk6RP7o1w
	 s6Pc3r54DOJyubKNym8vYmC3/LhuyoT9VcKdchWoBeTXK0pAMzgwE1sYj/8qy9ahuK
	 9WNamjsEhcJog==
Date: Fri, 27 Feb 2026 18:07:44 +0000
From: Will Deacon <will@kernel.org>
To: Leo Yan <leo.yan@arm.com>
Cc: yabinc@google.com, James Clark <james.clark@linaro.org>,
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <aaHdcKGE94ze2fq9@willie-the-truck>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <aZNec3B0Iou9PYGw@willie-the-truck>
 <20260217141917.GA136967@e132581.arm.com>
 <aZSAsC1YI5_lK3e0@willie-the-truck>
 <20260217190121.GB136967@e132581.arm.com>
 <aZcWC25GE2iUKsNt@willie-the-truck>
 <20260219185800.GD136967@e132581.arm.com>
 <20260225120956.GD4184494@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225120956.GD4184494@e132581.arm.com>

On Wed, Feb 25, 2026 at 12:09:56PM +0000, Leo Yan wrote:
> [ + Yabin ]
> 
> Thanks for Suzuki's reminding, I should mention that Yabin reported
> another lockup issue caused by missing CPU PM support in TRBE driver.
> 
> We have a patch series to fix the issue:
> https://lore.kernel.org/linux-arm-kernel/20251119-arm_coresight_path_power_management_improvement-v5-16-f615a301ad0b@arm.com/

Two nits on that series:

1. It seems a bit weird to me for the ETE driver to manage TRFCR but for
   the TRBE driver to manage the other registers

2. Are you sure you don't need to save/restore the TRBE state when
   LIMITR.E is clear? Maybe the driver is fine with that, but I'm worried
   that we could suspend in a half-programmed state and lose some of that
   configuration.

> Besides your fix the translation regime issue, I'd also suggest applying
> the CoreSight PM patch series to fix lockup caused by CPU idle.

Yes, we definitely need something like that in the android kernel trees.
I've previously bodged a hack into the ETE PM notifiers, but if you have
backports of your series to 6.12, 6.6 and 6.1 then we should merge them
into Android. As it stands, I don't have a TRBE-capable device running
mainline.

Will
