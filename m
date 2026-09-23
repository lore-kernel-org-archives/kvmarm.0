Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F88E2264DB;
	Wed, 23 Sep 2026 05:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790139965; cv=none; b=RD4HK96SbqSX+v5a8sm8sDpt/iDMpHrqXlvR3pVRf42xPnY+Hw1gAHXGw+9H4V8786ifL/WJ8DKtQlGVtkMkjP5db9vQJvzbZanAF/G1wkxL72POUMeJviBS7x/fVIU05XApHvRdA8J1pcTWmpOWcdk/XHsM4io0UbFqx52PMbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790139965; c=relaxed/simple;
	bh=aQo6QARKM7YACcOwS6dF6e3qFBVcNCrooJjp0JvFmXA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iBMMBH4pgDhnbiuQxJ+p/4mn7ambTrE0ColB+ssDSQJKQTxO5xK/H4ZFMaTdLap4gRtKWZtwjMZWJOsjN5KIk7bCSPHV7NF9/ri/cRWqUqmiF9GxsdF1bNewVL2DdMOnB51ss986Lotiw4nhbf5lk+VtSINqBdMvOW6BRqEXK2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4pTLW9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4pTLW9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C081F000FF;
	Wed, 23 Sep 2026 05:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790139952;
	bh=5Bt5dcvEtscZwbFsTWKayy1TU+NMdGF6W9YAquY9XwI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=m4pTLW9/ipMMEsohyLQEKqXjzHcwkN0abxqiFKnpytgFKVUrqceMZuAAbjlrBMffF
	 CdO1sqCGy/I+4fa+zUShWoTBNHwKuZyGA0wUgCZuN/1qgzhc19lMpVXwyE3kopIDPh
	 xsaF5GYCT9jld3YBh7sBjzHUGLsx/yj0S9EyAhn3oG6QwlUWCR4A3ADfsDf0GA8d70
	 LLyo/WDzrdcRjJT3saEv0417Vyorzdv9KtCxM/YNHdqRTmqIJwT5iDboIP2AvVAhAl
	 9BI9XEA2qlyxB1A/jRfmI8xO2B26EOiIXB5Dudw7TzaVJ3eh185kcBwpIEV1sD+FUg
	 BVMT6WrzF0mJg==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Christian K?nig <christian.koenig@amd.com>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"T.J. Mercier" <tjmercier@google.com>
Subject: Re: [PATCH v6 7/9] dma-buf: system_heap: Enforce shared-granule
 alignment for cc-shared buffers
In-Reply-To: <arKhCKdlqNQwZn8E@arm.com>
References: <20260918153642.GD11599@ziepe.ca>
 <d8123f21-d5ce-415b-a05a-392d97b8b57d@amd.com>
 <20260918165315.GF11599@ziepe.ca>
 <6115eaf7-21bc-49ce-8a74-08fd37a1e2c9@amd.com>
 <20260921115141.GJ11599@ziepe.ca>
 <45dd7a2f-8474-4388-b383-2dee3ee62206@amd.com>
 <20260921121739.GM11599@ziepe.ca>
 <cd2b32dc-5a80-4ef5-82bc-dd41ea96dc01@amd.com>
 <20260921123725.GN11599@ziepe.ca> <yq5a1pam4ocu.fsf@kernel.org>
 <arKhCKdlqNQwZn8E@arm.com>
Date: Wed, 23 Sep 2026 10:35:44 +0530
Message-ID: <yq5ald8s36c7.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Mon, Sep 21, 2026 at 08:56:41PM +0530, Aneesh Kumar K.V wrote:
>> Jason Gunthorpe <jgg@ziepe.ca> writes:
>> 
>> > On Mon, Sep 21, 2026 at 02:24:21PM +0200, Christian Knig wrote:
>> >
>> >> I also don't see where mem_cc_shared_granule_size is added?
>> >
>> > Patch 1:
>> >
>> > https://lore.kernel.org/all/20260904103452.1197239-2-aneesh.kumar@kernel.org/
>> >
>> > Aneesh, please be sure to use get_maintainers on series like this so
>> > everyone gets cc'd.
>> 
>> For v7, I included only the maintainer entries because the recipient
>> list was getting too long, but I added the mailing lists.
>
> I could not see Christian in the recipients of v7. Sometimes the list cc
> is enough but my inbox for example is already around 4000 new email, so
> easy to miss.
>

He is already on the Cc list for v7.

>
> Recommendation: add Cc: lines to each patch with the people that must
> ack your changes (the maintainers for those specific patches). You can
> then collate all the cc's from your patches, add them to the cover
> letter and use --cc-cover with git send-email.
>

I'll do this 

>
> Of course, the list can get large. You can then make a call with who to
> drop: colleagues you talk to regularly can be skipped for example, maybe
> reviewers if there are too many for a subsystem. I would not drop people
> that gave you feedback already on a previous version and not the
> maintainers you need acks from (you can drop them if they already acked
> your patches).
>

sure.

-aneesh
