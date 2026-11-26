Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795715067;
	b=Tdobd1wj/nae/MhoQ3fMnRRv2i5DD97Bz3096Xk2P4ogDyA4e1Vilnid5gT+E1Dykyn9
	 m89/qID/tB/rxWsWXsLw1eZeCXq8qApxODRi5TtDzy/DZa7e3Pf9oG5B05NwK4dW8C5Rn
	 yUMgMfTsQggj5DQvCPfeNx3cH299q+y8MJtz2bUQDJGi0hVaLoZ2elFeiiS8etZ9PGM93
	 8rnGh7sKN8QSfdRbqJSHrcezBn/RAz4WJRn0MwJ/9BZrJLM/V4aFDWEIFNM/1PZTVor7g
	 yAWjezHLOv6s65LBA6MB6eSC6AWdTkXDkkwJ2c85CMJe9LMjk25hJrpmZYcDxK35BhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795715067;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=gEkkIJ/qWNi7EAZD7yoHdkh/exPFsNxJMByksA50ASQ=;
	b=lSRPIhAYrCSd4PUVORnvJZY9Ybi5U6R7n92OH9uHGcAAOQ1YMn3jdPmdIoXlxBVDWTat
	 Vikz1EaD+ycK6HFl8kFTj5me5z6qDYSyrJSe9gHuSdQG1asYiAk+Jrkp0VY9wqNWNSYws
	 ceU1SxqSCg+3aVvg+L5403xZd+t23sH5/jTBB8Tt0WnvBeNRzF11lYe1pR+8XNtS5/+hJ
	 HK7khl0uGThozXKasNviwxG1Xw/m/oEEvX8gVEIKE8TUEkjutWBlUjzJDhlORBuBdAgiV
	 1BL6usd5an5/Xi+71WCFW9WDowCd+8kLWoy7E7yMH+HQtsbAN3kapwkj3Oplmh4Yetw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XnpcqNbd;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FFB9606A31E
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 17:44:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FFB9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XnpcqNbd
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C17C81BA8;
	Thu, 26 Nov 2026 09:44:23 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 59D023F632;
	Thu, 26 Nov 2026 09:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795715066; bh=RzMr+wOsn54fTvspSwDwUm0XU8ZkeIMlrzEzuHt/TKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnpcqNbdXi7qBGNhlwyJSNvZiM42NfttpEr2uGsSpYDVHIPmPjQnZn1aL6jWBSuUK
	 5WIE5RDd6KV366KhQvq4C7+5Iihf+pvD0/zEfcuqchaBOGU+jDlYvM/73/E7//layt
	 akZ1+xaZ6B+OHd55xEg8PYa0Ja2aKBO99M9j/05g=
From: Leonardo Bras <leo.bras@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	rkeilty@meta.com,
	atish.patra@linux.dev,
	dgreid@meta.com
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
Date: Thu, 26 Nov 2026 17:44:20 +0000
Message-ID: <awhv9JeCtZxH3Y5x@LeoBrasDK>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <awhpQIWN3msQ2ruf@gremlin>
References: <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev> <awcoCklLOKeuXPhh@LeoBrasDK> <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev> <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq> <awhODYKXnsBi_s_B@LeoBrasDK> <klnyvfxwhpw73wo55y5aq3qliglnf7xkfkmfj6cgzje7z3n2fq@aqjxshyjnldu> <awhWYdZVkESY9eJs@LeoBrasDK> <awhfXrdkHkY-riN3@gremlin> <awhnFrt1GmrTlQZ9@LeoBrasDK> <awhpQIWN3msQ2ruf@gremlin>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 26, 2026 at 05:18:00PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Thu, Nov 26, 2026 at 05:07:21PM +0000, Leonardo Bras wrote:
> > On Thu, Nov 26, 2026 at 04:45:35PM +0000, Lorenzo Stoakes (ARM) wrote:
> > > The question is would going from 40 to 3 slow things down?
> > >
> > > At 40 you do 40 __get_free_page() calls on topup for the _first_ fault that hits
> > > it, which adds latency to a random s2 fault (not great).
> > >
> > > (If the fault doesn't in fact use a page table, this is only done once until a
> > > page table is next needed).
> > >
> > > And then as 37 page tables are mapped, those ones don't get allocations at 38
> > > you go again...
> > >
> > > With 3 in the cache you allocate up to 3 for each fault.
> > >
> > > So in both cases you allocate the same amount of pages but in the 40 case it's
> > > all bunched up on one s2 fault with a jump in latency, in the 3 case it's spread
> > > out.
> > >
> > > I'd say 3 is therefore the better choice.
> > >
> > > Also, as mentioned elsewhere, you end up leaking pages once the S2 page tables
> > > are setup until the vCPU is destroyed, as nothing clears down the cache
> > > AFAICT. With 40 that's way more than with 3.
> > >
> > > --
> > > Cheers, Lorenzo
> >
> > Hi Lorenzo,
> >
> > When I mention cache locality above, I mean the cpu cache. Running the same
> > routine 40 times in a row can be faster since all instructions are already
> > cached, and most of the data acessed by it could be local as well.
> >
> > If you run it more often, it could be that something else used the
> > cachelines and the cpu has to fetch them again from lower level caches or
> > memory.
> >
> > That being said, that's the only reason batch allocating 40 would be faster
> > than 4 in the long run. For capacity=4, the number of
> > mmu_memory_cache_alloc_obj() calls can be even smaller than capacity=40,
> > since we don't leave unused pages in the kvm_mmu_memory_cache.
> 
> Ah right I see what you mean, true that would be warmer, but I suspect that'd be
> lost in the noise vs. zeroing each page anyway, and additionally you can argue
> that, if you just zeroed a page before the walk uses it, there's locality
> advantages on that vs. batched too.

Ah, you are right! I was ignoring the zeroing for some reason.

> 
> But again I'd be very surprised if there was any impact on that either way,
> really.

Fully agree

> 
> In any case it seems we agree that a smaller capacity is the way to go :)
> 

Awesome! Thanks!
Leo
