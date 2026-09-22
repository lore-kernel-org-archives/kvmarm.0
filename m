Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0C9560AB3;
	Tue, 22 Sep 2026 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091535; cv=none; b=I/5rooG+k+anP9y48gEkvPe7evc6rFaEUAz4proYhEzl89WqAZsEtgEjN6tQ57W27a5hApqFyt+rl/HyoYNlHWRizRCx172TenU/kuJY+YegUcXaNRra27O2gD2STlpTFHnZwLDWbh1oPxTpaw6jRN/fee1mJCdrndqHBC2HyYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091535; c=relaxed/simple;
	bh=HrFOMvILt8mde757UBXQoH0Qn6la3KXBni8ZkY+U82c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nnw50HEHfAjx+LhSePYPt7o2VRAtP5S1AKvfErIqsqgS7zqmtUw+Bsc7lZkYnwP3/Xpo9jk72VMHtmPjGPgwKFCGkoJsh5WNkV8ViRJ8mDHgFaPDDkygW9yt+34IyKQWO33E27RnnvfXC9mkNgGxmpgf8bTfWgeZ+DXv8+mHhRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EZWMOlc5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EZWMOlc5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4593B1576;
	Tue, 22 Sep 2026 08:38:49 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF1F93F86F;
	Tue, 22 Sep 2026 08:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790091532; bh=HrFOMvILt8mde757UBXQoH0Qn6la3KXBni8ZkY+U82c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EZWMOlc5+LWH03p20wnXsaCTXtx5uUx9RUpYepDAs94yOCNGJPmdDx36nIjjwvZs6
	 iMGwFCxikjdKaJkxfkNuNc3It9gHlRkUGYU1nvAO2Ci6mpHOlooi8wVjjNJxUcHxUn
	 CkoYeED0HQDySx4myZIdTQKCzbTkNWK2QN1FxjnQ=
Date: Tue, 22 Sep 2026 16:38:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"T.J. Mercier" <tjmercier@google.com>
Subject: Re: [PATCH v6 7/9] dma-buf: system_heap: Enforce shared-granule
 alignment for cc-shared buffers
Message-ID: <arKhCKdlqNQwZn8E@arm.com>
References: <20260918153642.GD11599@ziepe.ca>
 <d8123f21-d5ce-415b-a05a-392d97b8b57d@amd.com>
 <20260918165315.GF11599@ziepe.ca>
 <6115eaf7-21bc-49ce-8a74-08fd37a1e2c9@amd.com>
 <20260921115141.GJ11599@ziepe.ca>
 <45dd7a2f-8474-4388-b383-2dee3ee62206@amd.com>
 <20260921121739.GM11599@ziepe.ca>
 <cd2b32dc-5a80-4ef5-82bc-dd41ea96dc01@amd.com>
 <20260921123725.GN11599@ziepe.ca>
 <yq5a1pam4ocu.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5a1pam4ocu.fsf@kernel.org>

On Mon, Sep 21, 2026 at 08:56:41PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Mon, Sep 21, 2026 at 02:24:21PM +0200, Christian König wrote:
> >
> >> I also don't see where mem_cc_shared_granule_size is added?
> >
> > Patch 1:
> >
> > https://lore.kernel.org/all/20260904103452.1197239-2-aneesh.kumar@kernel.org/
> >
> > Aneesh, please be sure to use get_maintainers on series like this so
> > everyone gets cc'd.
> 
> For v7, I included only the maintainer entries because the recipient
> list was getting too long, but I added the mailing lists.

I could not see Christian in the recipients of v7. Sometimes the list cc
is enough but my inbox for example is already around 4000 new email, so
easy to miss.

Recommendation: add Cc: lines to each patch with the people that must
ack your changes (the maintainers for those specific patches). You can
then collate all the cc's from your patches, add them to the cover
letter and use --cc-cover with git send-email.

Of course, the list can get large. You can then make a call with who to
drop: colleagues you talk to regularly can be skipped for example, maybe
reviewers if there are too many for a subsystem. I would not drop people
that gave you feedback already on a previous version and not the
maintainers you need acks from (you can drop them if they already acked
your patches).

-- 
Catalin
