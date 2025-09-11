Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2375A34575B;
	Thu, 11 Sep 2025 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757603389; cv=none; b=Rt7ISzBWGQvDj5VDpTfnS5wM0O4nyhGlg5XCmO9na/gRqcg0kkWuG1MA6VQVBmKNSZN39I3tR2+fXQ1k7SFLmUfjOxwGi7aciMy4ZPg2tuSk1mRyo0yQVsUZUKI8xUIQX7/H6VTGhs93SkZlvB6c1jalGnguBshiUTluZqM/oJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757603389; c=relaxed/simple;
	bh=gBDmezCMu/2OkI3KT860YnQjdQW9Blm0iG3vh7MOde0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l36CZBZjK0CzON75VG3Sj87KyVmFWVLC6DCAnF2ayTm/t/gAgfkkMURXyQ0IN7PoRkqpTnOcJivpF83o8oGn012NsVhukvVb7sYs17q/861eKBhU0IuKjRWNQ7FAIyY5vkYjWfCoMD1yEY2yoMgsN9qw5JN8A2igvlzjTIhty7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fwul0kJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fwul0kJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F2FC4CEF5;
	Thu, 11 Sep 2025 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757603388;
	bh=gBDmezCMu/2OkI3KT860YnQjdQW9Blm0iG3vh7MOde0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fwul0kJi6q74mGU5Dqukf5JEmtODC2NkyMLIdTjXljA7qbeJj6mIM5DM6y2vBfH4d
	 suNiil4MVNnU/HJN42xo2+eNpsSS0tKlwA8yGJgwTex6OH2OHz4lZxT4ZDNFVu7hjW
	 YgRRChvuX573cN4nRIHtJsu67KZqy/UdGDAHkpWkyFJ/WwQngxIsnO2QyujxjSvd1l
	 EkXWCIL8O5IclKEzb8fUUAd2nJd9V40X/OiEqeKElYtHqbZa+hYCvB2ajZj5tgZv7j
	 j+/bMVLheV9VFI6ItJ96j1idNA4g8c3DEbf+UGyC52SycLwaMJXMfCbZGRwFo+OpUa
	 BuquWy/GxJYzg==
Date: Thu, 11 Sep 2025 16:09:42 +0100
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 0/6] support FEAT_LSUI and apply it on futex
 atomic ops
Message-ID: <aMLmNnehYX6gqEIf@willie-the-truck>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816151929.197589-1-yeoreum.yun@arm.com>

On Sat, Aug 16, 2025 at 04:19:23PM +0100, Yeoreum Yun wrote:
> Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> previleged level to access to access user memory without clearing
> PSTATE.PAN bit.
> 
> This patchset support FEAT_LSUI and applies in futex atomic operation
> where can replace from ldxr/stlxr pair implmentation with clearing
> PSTATE.PAN bit to correspondant load/store unprevileged atomic operation
> without clearing PSTATE.PAN bit.
> 
> (Sorry, I've sent wrongly for patch version 7 and resend it.
>  Again, sorry for mail-boom).

I tried to review this but I can't find any details about FEAT_LSUI in
the latest Arm ARM. Where should I be looking for the architecture spec?

Will
