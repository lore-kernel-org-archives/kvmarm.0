Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0989363C5F;
	Sun, 17 May 2026 11:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779018870; cv=none; b=eGB4xqkfeac2fH7SFAxRQUOSsFh7dc8UH2FrCp+vC9J/FKmLdiiFqNmTRu+ReCtDtZqyH0k6sKpGo3cEI0/j099HTD4QnItVUgB0xWHwMkUvTYDABStnpxCzRxL9Aqv7rVu9RdsFQ/sVS4eYhUyYZaG2eUxgKXeIMHe7RG7OGjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779018870; c=relaxed/simple;
	bh=P8AgS1njGxxr/Ox8tq35zw6ddy631qvcarL4nhR23wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyUCCLOrSrcjUdPJNiVKN7XkqiHicGTw81jxOqyTmJL2ykbMTZo4J8nmunUfRbvNTjtLzm0dfMqshnvikLNWBUwK7usKRTQ3fhjUD26Mp4UmJiOnR6Ydvj/ShbrPjWhoiOQsDUR/HouT4M8HbM8Ys7l/gKO3Tn6b+CsS6FhE8Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s1joLOQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s1joLOQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556B5C2BCB0;
	Sun, 17 May 2026 11:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779018869;
	bh=P8AgS1njGxxr/Ox8tq35zw6ddy631qvcarL4nhR23wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s1joLOQi00MKR4caEv929tNlCHGVw+g7Q9s8M1AuWlTw4wWM/kni3FIGeufk6nHVZ
	 75I7F3xdVJlN5lQtD71e7Bkw+qZmbHKJBUfIxSfy87jmReTcod5TkRKjk/86hNJbVL
	 gQ/8i+IM7L4BQG0ICaLqatixQnREIkFUawA+dF38bADp7OPdX7VzDE14s6USfGjY2J
	 KmY+1kxAKdHqP5fx7H/tRjObhfwmbEeDHSF9dXceKBV2enCBsLKeoDelZKHTC2EMv3
	 G/KcL0PvTb/f7MrHhqgyJfg/5gRElwQcMmSIsNQFCWNPsBnLKWy6o76UmqK6mawz3N
	 NuTlWrJcL8X+Q==
Date: Sun, 17 May 2026 12:54:26 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH 0/4] firmware: arm_ffa: Move core init to platform driver
 probe
Message-ID: <20260517-rare-horse-of-radiance-17eea2@sudeepholla>
References: <20260508-b4-ffa_plat_dev-v1-0-c5a30f8cf7b8@kernel.org>
 <177901775932.3835515.4484747964630642694.b4-ty@b4>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177901775932.3835515.4484747964630642694.b4-ty@b4>

On Sun, May 17, 2026 at 12:36:45PM +0100, Sudeep Holla wrote:
> On Fri, 08 May 2026 18:54:14 +0100, Sudeep Holla wrote:
> > This series moves the Arm FF-A core initialisation into the driver model by
> > converting the core bring-up path to a platform driver probe/remove flow.
> > 
> > The first patch reverts the earlier rootfs_initcall change. That initcall
> > ordering workaround is not a proper solution and potentially conflicts with
> > pKVM FF-A proxy requirement.
> > 
> > [...]
> 
> Applied to sudeep.holla/linux (for-next/ffa/updates), thanks!
> 
> [1/4] Revert "firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall"
>       https://git.kernel.org/sudeep.holla/c/1b4c1c4d75a8
> [2/4] firmware: arm_ffa: Register core as a platform driver
>       https://git.kernel.org/sudeep.holla/c/d10175dd517a
> [3/4] firmware: arm_ffa: Set the core device as FF-A device parent
>       https://git.kernel.org/sudeep.holla/c/8bdff2dda405
> [4/4] firmware: arm_ffa: Defer probe until pKVM is initialized
>       https://git.kernel.org/sudeep.holla/c/216d4772b411

These are incorrect and fixed in later email, this was accidental send.
Please ignore.

-- 
Regards,
Sudeep
