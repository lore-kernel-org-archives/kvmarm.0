Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B333C35AC30;
	Mon, 18 May 2026 11:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779104900; cv=none; b=bqtSfZKdyMndJFKLy+SrNBinY1sh9mgcxwLKW03mWmchbbqU1bQEc3U5qvTsQV6b+k82xHq2UuGHOhN44inlmiKAPYQLPnljMf0VCgerFKoXrYgCsTRNHhn/Y8rzyuXsMjlND8EeobjdTPVStYKRNkqACRa07yNo24ShRY3VuHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779104900; c=relaxed/simple;
	bh=VRcM7Qc+D4r2luvR4QREcqRb2v0i889DhGbh7+0QUY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iweTkJ2R3hnz+uznZupgb6zfCJPcJzYeLt6ijSuzOLqc3iDnT7gV9eQEcfzlImxPIsVLmLX6UZk+VKZs3fwuhO8fbdMJcpsYbznQweaZRLetsMCGm7u6/nDmGblI3D1EQ6nXfrtqzWJCpF+eev6eUM8qgab4jrWTYhWMAO6fz1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oI4Y4AY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oI4Y4AY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0786C2BCB7;
	Mon, 18 May 2026 11:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779104900;
	bh=VRcM7Qc+D4r2luvR4QREcqRb2v0i889DhGbh7+0QUY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oI4Y4AY+cT4ul8OicdswWN5X17hE/Y7F0AFGYJM/Q0g2k2pwVIOftlu0WYI17ITU5
	 OfQ5ykccsma/bQph0outRyNX+oFrPwwrK6ommbHx6PJAN/sUOeyr7fJQvQWIp6gEdW
	 WeCrN+tUKoVSOfSbm5gLGTl9Hjhd9MJzYypHTRuLep9YOD5Jfy3KOt8NX9pxIIYwxd
	 lEy2tnWnR+BKIg3N3OzQFs8af2uZJx8yce4NV7gclNhijnccO9NqDI33LbTLhBT1gb
	 sn/y0NxvUHv9viVbluH74pkf+yGPybOAX5Nqt4LzaeCnWWndiaPRE+r+Dcnb2uFn1O
	 I31xaI+YBMYyA==
Date: Mon, 18 May 2026 12:48:15 +0100
From: Will Deacon <will@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>, maz@kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v7 0/6] arm64: Nested virtualization support
Message-ID: <agr8f9iPNySizL9l@willie-the-truck>
References: <20260323164717.2571585-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323164717.2571585-1-andre.przywara@arm.com>

Hi Andre,

On Mon, Mar 23, 2026 at 05:47:11PM +0100, Andre Przywara wrote:
> This is v7 of the nested virt support series, correcting a previously
> reported, but unfixed issue with endianess. Other than that just
> rebased. Changelog below.
> ========================================================

This looks good to me, thanks. Unfortunately, it conflicts slightly with
some of the other changes that I just picked up. Please can you rebase
and resend so I can apply this on top?

Cheers,

Will
