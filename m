Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230D267E7E
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 11:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706615857; cv=none; b=b4OeyRdcoHU5omYx0j6Mv9c/ZyIUlw4IG/ty3qj1hKfXb1GHaCPhiUdCoobzQ5zHWTgb/ZlpkaQLRkZ3rGOvMXcDn6LVxvj8/MTgscncH7fmm6TGpIeQpjdyXammrE44sXKVVnXes8y+vibAKiaxXip3MIoBQmxTq0oWTyElI0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706615857; c=relaxed/simple;
	bh=+PL92MEHrH3ZtLrABPR9HFjxEndX5qwgR9BUBrdekIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJXH0UhUidL5VqfXu1cqx8UJ33ckB9QVU3pysV1UTwR/7RSSbgRWXqRyCSq+jd2Cygi/BxDDhPkWhBJVtrtTCePspTEOEdk21d2ZKPBFbB/V5TXLwdC2f0Cebt54yU7Hf1MJsB3Oma37ZlzBB0HcDXsyGP4qKDjmaqZQwa9c1ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EDF3DA7;
	Tue, 30 Jan 2024 03:58:19 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 194363F762;
	Tue, 30 Jan 2024 03:57:29 -0800 (PST)
Date: Tue, 30 Jan 2024 11:57:23 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev,
	maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, arnd@arndb.de, akpm@linux-foundation.org,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	bristot@redhat.com, vschneid@redhat.com, mhiramat@kernel.org,
	rppt@kernel.org, hughd@google.com, pcc@google.com,
	steven.price@arm.com, vincenzo.frascino@arm.com, david@redhat.com,
	eugenis@google.com, kcc@google.com, hyesoo.yu@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v3 04/35] mm: page_alloc: Partially revert "mm:
 page_alloc: remove stale CMA guard code"
Message-ID: <ZbjkFujWTs9zqkeD@raptor>
References: <20240125164256.4147-1-alexandru.elisei@arm.com>
 <20240125164256.4147-5-alexandru.elisei@arm.com>
 <966a1a84-76dc-40da-bde2-251d2a81ee31@arm.com>
 <ZbeQBDwe8zc_pLDZ@raptor>
 <3983416f-b613-42c7-bb42-d3ab268ea1be@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3983416f-b613-42c7-bb42-d3ab268ea1be@arm.com>

Hi,

On Tue, Jan 30, 2024 at 10:04:02AM +0530, Anshuman Khandual wrote:
> 
> 
> On 1/29/24 17:16, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Mon, Jan 29, 2024 at 02:31:23PM +0530, Anshuman Khandual wrote:
> >>
> >>
> >> On 1/25/24 22:12, Alexandru Elisei wrote:
> >>> The patch f945116e4e19 ("mm: page_alloc: remove stale CMA guard code")
> >>> removed the CMA filter when allocating from the MIGRATE_MOVABLE pcp list
> >>> because CMA is always allowed when __GFP_MOVABLE is set.
> >>>
> >>> With the introduction of the arch_alloc_cma() function, the above is not
> >>> true anymore, so bring back the filter.
> >>
> >> This makes sense as arch_alloc_cma() now might prevent ALLOC_CMA being
> >> assigned to alloc_flags in gfp_to_alloc_flags_cma().
> > 
> > Can I add your Reviewed-by tag then?
> 
> I think all these changes need to be reviewed in their entirety
> even though some patches do look good on their own. For example
> this patch depends on whether [PATCH 03/35] is acceptable or not.
> 
> I would suggest separating out CMA patches which could be debated
> and merged regardless of this series.

Ah, I see, makes sense. Since basically all the core mm changes are there
to enable dynamic tag storage for arm64, I'll hold on until the series
stabilises before separating the core mm from the arm64 patches.

Thanks,
Alex
