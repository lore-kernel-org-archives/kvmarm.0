Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B704353376;
	Thu, 11 Sep 2025 16:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757607748; cv=none; b=eu8y61/vwxwb2m53amTJEZ0NXyJHMUv8qX0JITZeyxfwD/04qvAl0dJUf0A65QkfTevd9zp2ZSsRjZsAtMj8kzhWv80DbpdS3RtL41MwI2gx+k0gzRhAToENmTGkGGT9zYa9+DL5GKv4qVL2nUfnSzXIjk5RM41gnx8MHOMHO3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757607748; c=relaxed/simple;
	bh=8Id42XX2zqGQ6Zh1PELYGc9D6wQEYttKQHGpyDrfKxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZC91yh2AUvJmEUCeROYLtk9ZuSEZ6vwUUxGXqRoNgpx04P8uZosqVamHCWDNlu7/LDgnWCPTWn4Bvjq/U7S3FUqL17CaUVoysSs4dnaXmm6MbOmyIGoyXBENdnzdsluvBIb8TFLzHxUTxEoU5hTVyRs6164GkHuPni+V1yoN+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A51CC4CEF0;
	Thu, 11 Sep 2025 16:22:25 +0000 (UTC)
Date: Thu, 11 Sep 2025 17:22:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 0/6] support FEAT_LSUI and apply it on futex
 atomic ops
Message-ID: <aML3Ps1xeTCVCdTn@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <aMLmNnehYX6gqEIf@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMLmNnehYX6gqEIf@willie-the-truck>

On Thu, Sep 11, 2025 at 04:09:42PM +0100, Will Deacon wrote:
> On Sat, Aug 16, 2025 at 04:19:23PM +0100, Yeoreum Yun wrote:
> > Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> > previleged level to access to access user memory without clearing
> > PSTATE.PAN bit.
> > 
> > This patchset support FEAT_LSUI and applies in futex atomic operation
> > where can replace from ldxr/stlxr pair implmentation with clearing
> > PSTATE.PAN bit to correspondant load/store unprevileged atomic operation
> > without clearing PSTATE.PAN bit.
> > 
> > (Sorry, I've sent wrongly for patch version 7 and resend it.
> >  Again, sorry for mail-boom).
> 
> I tried to review this but I can't find any details about FEAT_LSUI in
> the latest Arm ARM. Where should I be looking for the architecture spec?

Unfortunately, it's just in the public xml at the moment. Hopefully
we'll get a release of the Arm ARM by the end of the year. Otherwise, in
the private 2024 arch spec. Not ideal though.

If you'd rather wait until in turns up in the public spec, fine by me.

-- 
Catalin
