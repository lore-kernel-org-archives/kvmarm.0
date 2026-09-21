Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7968648EC69
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993063; cv=none; b=JRQ3ncgNzz2Ts9G9lJ2tv5dkp9atRGfwXVgpTnO+qcWkv2LRqzCLHj4vHtODEbfqFu2ObCEhzVXpDYxqEW2SWA/qWLiZJwxxL8C0GO8HgW6Z5U5QpKuXpThRt4pHzHq9eA+KFTL0Q9HNazoDGSNKe+1lOuGaode4c/AjXyymp58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993063; c=relaxed/simple;
	bh=FiL7WiwJYKtgbYN0zFXCgciqh0a5CtLpGXjxvHa6q3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rxTtB6LcIur7dDZSu6JbYyX4FRv3JcFs2mP4Myh8QF8AjqP0Mfo+ycL+edUxmXyhJD/cm7kVEm2pG0iBGpuaMl1bFPLFonB5w+YAAF/iuGVV8rHRozk6fg68X81Q3TgrySw8OaZNUws/APi6AjTDct8Zc/IMi+1x/ySEFjcDU2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=F3axcvcX; arc=none smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="F3axcvcX"
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-939109f067fso399807185a.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 05:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789993060; x=1790597860; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w3UJ+jJG/fm0G4nquu0DTAR8wl/181muiJC8crp8lPM=;
        b=F3axcvcXRbnjF08VhpkmK2Ja8dHL29tefYepnNd7526GEOA2AXqqIa7WFCjM9fgFJy
         ZMtEcD4cf0S8knh7Z3Qg0sz6YmW6hbSsCWI4uzmKyqjK3ehohtHlM37Ghr1QiSEcoXLy
         /8mqAZYmTbrwgAU/o9as4po1HmevijaUXnD3t5BERdjDDYZvn0vrHCJmbLRZFskeEbbm
         cl826DZAABTe2lT95xvRSxWQm3QURHDTx0h2mvBJ3OUZ1xbE48PQT0ZhacezdN6NpxIG
         7FXyYW8mYx1GoNd1XfNciOGJyFKFYKMNoQFqNzt4uYHz65v43jh35dlTQHpAOcZEIut+
         Z2bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789993060; x=1790597860;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=w3UJ+jJG/fm0G4nquu0DTAR8wl/181muiJC8crp8lPM=;
        b=2IU3uDk2YTPtkIFoNdHjNFH+XmFVQtGkzBWEeP8yy2KEMzyMoX0SmApg0FhSnhJ41N
         Erxx5+UHwzVmJ1hHdhNU1SmObMe4TkRczZ1wX+T3/Iu2SAP9rGMS70qBH589X2mXbG3U
         BLNPAhwQsn+31VgYRDx9SZQDXvM+3xHhPYuWa69EwuAlxb3vIr+9PxTEnyDp3oWB+m1R
         B68rNH3O6x3UTRG7zf36BsqRFWduHuws385KtNrtTNPd8SJJUmY5l3EWP35ijkRraldm
         50R5dVertWSy/kTxuA/aakfdksnHDZF+qAa2QcRumMk3n6h5AbhsVvPSp4TMyHH+MyyO
         IgKg==
X-Forwarded-Encrypted: i=1; AKwUvBz13LRDtUqnCxSK9T7MZIjuemeR5On5AO0wSuItQiFd6L7eb3XP3Gk9/hdxuOk8LLGNrr3n/fQ=@lists.linux.dev
X-Gm-Message-State: AFuF++lmnL0H+ZKTFoFMKoI7IokKhSVilMTwZdrsiJ96aPPT4DVzt+qX
	PAl9BNTbux6Sf1o7E4YEXrDoXZkqoqCrz9Cp+Tk4eEgJ9HKLMIgKv6IL8rGMPEF/ESc=
X-Gm-Gg: AYBFou00gIUZ0T3TO1cY1S9bCLld4xdsQGtyL89aLRqT/8hDDBcbJ+RyV6XosM5930F
	w3JVF7DIhgMDC2L9CAwRlF42KSn29VRb74I3Puc2H1/wmzUzb8grK/wCyR5/bsD+aflW3cqLXuP
	OqujJyhx6as0ODLPDqYxSVAxK+flA8tzEVf2YTEJMWneKPKc2IHxRCelG3pTmT5cA0KFeHHM4sr
	rGaE1BOZdukZxWMOtnmcy4qqqEoAJb0MEfUXmMGGKvUGJz3sXcT2uK5CNVGRTxjZ0UmnXBl29KC
	8ga6aoe8D7K4KWQRnqdHwWFyAHe+5Tfa3Kjk59ErR+ntZgUHWSh1G1su1Az+q0QrNQDFLWMP/d4
	gP41GVtoFWbLllIBuoC1zISHVTu4L55elapo5bYapWyZcxKyyeVJkhbPQk7a7uN+6LZnkqJZiNp
	hIQL+dHLa/OWp+fncDFLLala5ARuDlIbkUR0tuTCZtaufOVv8waYtxNVvdyd64CHxrBZKi0HLpz
	sB+p6hn3yrJVPB46vXR9cnbypnhQUWN7N5dhNC0Iy0QS3nGbZFZKE4qbVIVAr1WWZI=
X-Received: by 2002:a05:620a:440d:b0:93b:e6d3:3149 with SMTP id af79cd13be357-93c15ec31camr28407885a.53.1789993060138;
        Mon, 21 Sep 2026 05:17:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93bedac21c7sm633945285a.22.2026.09.21.05.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:17:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x8cxn-00000006Foq-0Pwg;
	Mon, 21 Sep 2026 09:17:39 -0300
Date: Mon, 21 Sep 2026 09:17:39 -0300
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
Message-ID: <20260921121739.GM11599@ziepe.ca>
References: <aq1V3oeDdvXobt8J@arm.com>
 <97c30fce-9bda-4c61-b1b9-10297b89c8d9@amd.com>
 <20260918153642.GD11599@ziepe.ca>
 <d8123f21-d5ce-415b-a05a-392d97b8b57d@amd.com>
 <20260918165315.GF11599@ziepe.ca>
 <6115eaf7-21bc-49ce-8a74-08fd37a1e2c9@amd.com>
 <20260921115141.GJ11599@ziepe.ca>
 <45dd7a2f-8474-4388-b383-2dee3ee62206@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45dd7a2f-8474-4388-b383-2dee3ee62206@amd.com>

On Mon, Sep 21, 2026 at 02:05:50PM +0200, Christian König wrote:
> On 9/21/26 13:51, Jason Gunthorpe wrote:
> > On Mon, Sep 21, 2026 at 11:07:17AM +0200, Christian König wrote:
> >> On 9/18/26 18:53, Jason Gunthorpe wrote:
> >>> On Fri, Sep 18, 2026 at 05:39:55PM +0200, Christian König wrote:
> >>>
> >>>>> Arch code can figure out how to do it. If some ARM configs only give
> >>>>> order 4 folios or whatever then dmabuf heap doesn't care.
> >>>>
> >>>> The fundamental problem is that DMA allocations are highly
> >>>> architecture and device specific while Linux memory allocation APIs
> >>>> are generic.
> >>>
> >>> This isn't a dma allocation, this is a memory allocation.
> >>
> >> No, I mean this is a DMA-buf heaps allocation. It is a DMA
> >> allocation, we just don't know for which device.
> > 
> > So? How is it any different from the existing alloc pages?
> 
> That you need to specify that this is for DMA without encryption.

It is not for "DMA without encryption". It creates shared pages in a
CC guest which *every* guest device can DMA from.

> >> That userspace provides this cc_shared flag is a NO-GO to begin
> >> with.
> > 
> > What do you mean? We discussed this with the heap maintainers and we
> > all agreed this was a kind of heap just like any of the other kinds of
> > heaps that userspace can request.
> > 
> > It is *exactly* the "special allocation requirements" you are talking
> > about above.
> 
> I only see a fraction of the patch set (because no DMA-buf
> maintainer was CCed) and to me it looked like the cc_shared flag was
> added as an additional parameter to the allocation and not a
> separate heap created.

?

It was merged months ago, and you were CC'd:

https://lore.kernel.org/all/20260325192352.437608-1-jiri@resnulli.us/

It follows the design the dma heaps maintiners guided to create a new
named heap:

+	exp_info.name = "system_cc_shared";
+	exp_info.priv = &system_heap_cc_shared_priv;

Along side the normal heap:

 	exp_info.name = "system";

It is identical to "system" except the pages are "CC shared" meaning
the hypervisor and every DMA device can access them.

This series is just adjusting the rules around how
set_memory_decrypted() works. It isn't changing any uAPI or adding
anything new to dmabuf heaps.

Yes, it ends up as a flag in the internal code flow, that is just how
it got coded..

Jason
