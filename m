Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00CC48A2B5
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 11:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789991505; cv=none; b=WzDADkJ571siT3VWVd+5co75OwNo5bPxLpKuvk7aze/NGIy++NaP9jXp0wRpR8+q5Li8CUXKKCwE8GSWLxsisMhDgWCzh7wbR67V0+apaxfq80QUBQtPOhrLf0mRaoD+1K2P8OsPhZsj6yp8UR98VFqn7/8m0px6npWUK+PrwOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789991505; c=relaxed/simple;
	bh=lCdYI1OE94lBSqy9wuRBi4LlczC1SIPVqcP7imtw+EE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MsgNsE0yF4XyYLxD4LqScSUBcp4wkdK3lDxhzrgILTqN8aGwDGOovLApMy6m6MuQVwKr12eXdg8oqp6AfivGMSKp4aVhTFmABwtwuYzqxtBXVZMAY9E8Aw83pneEpTuLdV0HDY5Hu2A5ZFAeJKrfqNYDuanr3DrPp+Fh/gr7SpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=FmgkHk5k; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="FmgkHk5k"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939109fafd6so245000585a.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 04:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789991503; x=1790596303; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bnn6zn+vbwMdJcdlyBW4k06r7mJ5WHfKBmVX1PCngjU=;
        b=FmgkHk5kdfaKMEDv+j4wMwVW+FF3ziK4rcFUCYQoGgRVuPCJJT67HsAjsfH9MSCvZb
         kjOWwM5vKNC5W3bOsYTzcCuPXf696RT21VCmPugDnRPr1KoGh2tXgx4vXQfa7ReU6Jv7
         4JFemntkRz92zgykjIQyczWX9NCvLEjKRjSq67T14jhExL3zUH4WzWlkFHU2VXwLT0l6
         M4pJA+CIFqiVXpw6pKedo0t1cOk11hCiyEPZEDSN6+4hkcAN4z6861c3Ql67OoRVBuV6
         c6TT8eYhECqFvFgN30IuB981gCJdZEROXnsMn1ErRrTbaqcEMOsWprB4nKF7SwIGkCvu
         a1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789991503; x=1790596303;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bnn6zn+vbwMdJcdlyBW4k06r7mJ5WHfKBmVX1PCngjU=;
        b=Ojyv1v38rTbVNMoPC6/2FdQQ8AQ2a6cR4Djtj0Sbx42VMsO3w6kVnuzn8P4cpvyfy/
         zXLPlZP+lnxf4gptZeZvJReUwPVKk/AiHDrN3aOiXdE3QdKI9jWUgW0cQ1bqrmXN5kFc
         oDUSBBkGq1JxwtJoilBvlChPjykK/6x6W0af3B+O6klGkQv0xAjw7QTEDTuf00tyIS0o
         lzBh4dmEfjWBRT5GgGxeEImE9ypEdHCnsfKqvHndw1AgwpdQhOrZi/jdA/3hAkilY2Kk
         soKLYvBn1skaHTdu0niwaf2SyscWHHyXRXedbHGCEzkVRbt2ZibkimgxfSOFy/b3gj0B
         rkCg==
X-Forwarded-Encrypted: i=1; AKwUvBxDkAJVhM8fZ/qg4Cn7Y6nO9vO5raTcaKvRpB+mBGXyO0laDGvllENjiggQ9YVMNXFNmGIurkg=@lists.linux.dev
X-Gm-Message-State: AFuF++lgMyNvllKqowceq+rK2nkky+tBPoxnuf5BjRquHC0kKZzXE8OY
	M1rgeA+n3EeCAeTDIjRCSd7kWIyfVzCl3bVAuU3OQlMhBk2Jb64CEzCyXEBHomrwPqo=
X-Gm-Gg: AYBFou0I97s+7sm0xKBJP9mU8H9NCUqkkz3Avezxu/RQBi3w1LsaGpWjSaIdWdgf6DK
	FQvJ90ThiNq0CX1CIvPTtCzaYZRLEo8e6TznQLNqlb55Xo6CfZ/JASY36Kitjwekerg/0eBgTxQ
	OLi5aZuObPImk1JMF0xUXY7xDVW24jMuNSHM1uat6LqJgozY6kMZW4/KTKiZ9OKpjRUqwrrvgp1
	14YeTZYY38Kqw7zSXkqefd0N6xA4GvKmNCnDu5ZCOjKJc0ELL4QbtM+HB2oA4L6KRjnmJ+BK9Qj
	9G9tJJVPueBMnOT5a9maHRXJXZl20j2sSXFv4BM3nxxTbfg7COw31NaMLDxwZhcYFxAXbVhWdeb
	HIu4E9jnNczo7SOcc+Y1k/Q5DQlFz45/M4/K6zsk2/jNTO4dNK74bauIfN0lh6OONlOHIRDwoua
	XW4UvEa+rGcLlw5ebHxWSaa0ZR49nuyhROrI2OoKVvtQAhlrpsbNkw/mFyOOYpEnX3reiAyH7MZ
	MCbiAli0GtbVEwChiKg7lFGRWsQ4+mTC1n/iCNpi3CdbXpkKbEqgtURDCc34vbmDTU=
X-Received: by 2002:a05:620a:2556:b0:93b:d79e:18f7 with SMTP id af79cd13be357-93c15e7ffcfmr18078085a.58.1789991502666;
        Mon, 21 Sep 2026 04:51:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260aa0f99sm65421876d6.38.2026.09.21.04.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 04:51:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x8cYf-00000006E0j-0Dl6;
	Mon, 21 Sep 2026 08:51:41 -0300
Date: Mon, 21 Sep 2026 08:51:41 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
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
Message-ID: <20260921115141.GJ11599@ziepe.ca>
References: <aq1V3oeDdvXobt8J@arm.com>
 <97c30fce-9bda-4c61-b1b9-10297b89c8d9@amd.com>
 <20260918153642.GD11599@ziepe.ca>
 <d8123f21-d5ce-415b-a05a-392d97b8b57d@amd.com>
 <20260918165315.GF11599@ziepe.ca>
 <6115eaf7-21bc-49ce-8a74-08fd37a1e2c9@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6115eaf7-21bc-49ce-8a74-08fd37a1e2c9@amd.com>

On Mon, Sep 21, 2026 at 11:07:17AM +0200, Christian König wrote:
> On 9/18/26 18:53, Jason Gunthorpe wrote:
> > On Fri, Sep 18, 2026 at 05:39:55PM +0200, Christian König wrote:
> > 
> >>> Arch code can figure out how to do it. If some ARM configs only give
> >>> order 4 folios or whatever then dmabuf heap doesn't care.
> >>
> >> The fundamental problem is that DMA allocations are highly
> >> architecture and device specific while Linux memory allocation APIs
> >> are generic.
> > 
> > This isn't a dma allocation, this is a memory allocation.
> 
> No, I mean this is a DMA-buf heaps allocation. It is a DMA
> allocation, we just don't know for which device.

So? How is it any different from the existing alloc pages?
 
> So ideally we should use resources which work for most devices in
> the system.

Which this does.

> If a device has special allocation requirements (CMA,
> restricted addressing etc...) we need a specialized DMA-buf heaps
> for it.

Those things don't really intersect with CC, but if they did their are
already heap names to request those, someone can add some shared
restricted CMA option if they need someday ?

> That userspace provides this cc_shared flag is a NO-GO to begin
> with.

What do you mean? We discussed this with the heap maintainers and we
all agreed this was a kind of heap just like any of the other kinds of
heaps that userspace can request.

It is *exactly* the "special allocation requirements" you are talking
about above.

Jason
