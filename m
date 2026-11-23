Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446045;
	b=RgSiCwUbA/3kz/9qEx2xw6z46c6xgDV3BtsRt057D2hM3AZ38MKenuYGj/5+2u3XkF/c
	 +jaB296A194YU5EZTo8y4eazmpQKgx6AzdyA4kO8eNe/nk99tkR1iqeP+9kzfjAtdoY1Z
	 du6zxJWQDTAjgSGxCCSVxNv7QgEg8quPY42UquMrhbWcCqJegHY3kHxDYUwiMlBBbfHe4
	 VQRRh3e5Xa+udPvdwWbGSDEJe7xUQqbOCyuh4AlObyurOABtHgXcjldvNYkWfLKCmZRGN
	 cspfqkjOX1gHBC1O1DUo2PP2ToSNqx6ZGBwOeaDeR/BpKqpGy2dqaWEKc/Mt0ddhwLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446045;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=8YXzoVkoKKTn5S6189qRHpEA8zSaXUAPSQ685ax1F0I=;
	b=kB2S/bnSdQXfVAg8IxSymEBN2OHzPSfc7C1usqCxMWcFEowbQdpvgGMqhy4EPqeZQi0Q
	 RoyJJDHA/Rd/SFLBKSv1S2PlKgcqW/5JIF0m7F07uASdRlgCOjx/+EFICzWO/vpjQa0Nr
	 SWaUg/AlR/9Q0vhnrjXL35XH0gmvZn83Fbv6uMqimoy58ZCqU94PrETu0ooXOzjC2qmnM
	 waRI8awV/nJ42RvPu7D/zD36F6+uSaPxyzjsv0Fdbs5sH1TJidU4lDp++nhxjeyvsdP40
	 9wmXnnUsRq9sYC3SB07b6jbmNWuWwbTFyN7H7dD7/Sqj9BNwCUGB5AJDR5QSvY2qrnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="Js/hN7BF";
	arc=none smtp.remote-ip=209.85.219.41
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF11606A6A5
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 15:00:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FF11606A6A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Js/hN7BF
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-9215934a14cso8603846d6.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 07:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795446044; x=1796050844; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YXzoVkoKKTn5S6189qRHpEA8zSaXUAPSQ685ax1F0I=;
        b=Js/hN7BFiz+V59LU3g3qClRYtgCYYRyqOBkW49G+CeYW1aEcatOFKpUqNmDa6nwoLO
         EEbZijW6BaZXx7xFQ+7bBLUFNphUSNLLEct5ENjAr5bCyRwBr03momZfim1ZfRs7R6og
         IuK9n0r/YinKfN0nFoXlYdgmv3JMxrqeV/+rOki5A6zQ16unhdz3qvXlQtHAnyXaCKAw
         m15ayg/ihxXKoYaonVGoEZTjRJMfkV25c4wJHR9yhGd4A7pVyaHJkb/UtBalcU5uuOxE
         BqeYptVjjfg+ensmZldQmRMXh2aVA2slv7fdKgNyHhoTrDbMjjhC7R6NhJfv1zKy/aIf
         S95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795446044; x=1796050844;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YXzoVkoKKTn5S6189qRHpEA8zSaXUAPSQ685ax1F0I=;
        b=Mz4xIiuwCxyhfUZycuB/v0QjbtfX3kk6KK7L+Sg9xBiLby/0E1EufLexzi1SxjTrlM
         RN1gJJSSZMV9D79rNtsCO0NNf9efnbd4uYnPx/Vh7H7fXLjt4Czvn2OvCSYlK2X0QlTK
         n94wieYzN+WBBB5D0kxDs2tTXsVsaHQK4PV1VwJASIjBjvjnrcopNJTs//KnafqkI/Cf
         Ct3/2eT1NP8BFfw5jLDDmcBdvEBVCPXGp3hPvAGOcHy9/Csx28po5qBmeUoia6g3lNrE
         MEmXxr6NhCZ34LQxKjI8p6BgwCxDVe+h5cKNfCMaVtrmtLgnySeFNaNkJgI/DKGv6poH
         vaiA==
X-Forwarded-Encrypted: i=1; AL+hErHcY4nkIdM/RYvBNm5FGJbeSPG3G8jDouI7L/Itm2kszkOBpLQPBpwsduKbxXEmSCOGG97WOic=@lists.linux.dev
X-Gm-Message-State: APuU4Z9r6tin2Ry5ZUOFCxQ6Fm2MGSVrRDqC5HSHaYLC/7v/0+z7Gxm1
	KJsK3af39zD8xVxUbdyYjjkXRfe++sv4C5R+4gCrHoY7GQusrNorUEl7ZUsnH3br4dM=
X-Gm-Gg: AZFdTZeMmej77vqyIJJZR46YF8F6aZSfkRPNtaNZ70GrhmxOyJIqvza/pXB1uKbs5Sx
	tEEUCCJHLzNEy+/7zPqWTt9WqPWyvFtAfzkN8TIcfh3nuIW1YOktfyQqwFim2A3cqb544g0eWbC
	2zrxLWhQhYDKlwXLkddYmUssJwa5154e1uUaR01Yu1NfyO4vBJ4IWBJUbA4J1zlDuciXh2BORug
	i/EGHI9DIH2edlRdd7m2fPECf9rU2cCNtwdI11SN7/FSO7ppd2Ury9bP5WEzr2O6GPf0nv6CEbD
	/hwgGel1BWONuhOTmp1nN+gGRgfyc2/Z/nf2jsEt0u+sssj6Ci/2Pq2FO/68/zu9sI3e+qa9QSP
	I0UIo29nNt6ygHmUW3PcuSsadXUUAlGMHDCivhHGa6Vhh5rix4MQRcV4BV1OFYn26lZoqsB/eth
	tRGr5tlQEmpRLI9rOnrQ2ZJsokUGG7hYm79lPm2bVszAGwdO+1gZnHe6p0tp6crzwVil3qAciyr
	NXvS2wfht4OjOr00PUKpFjdalntVjzgcGSgbg+Mx2Hg32OFY0T9ULgyGvbLH8z8Bmutqk62ya9y
	hhvyco/zuqIer7vKV28MN0YpuPfZJKaeoQrk5XjaGPMD9Vm7iTM/AyjcSVhbXP4FJ3G771A0yax
	dwHI=
X-Received: by 2002:a05:6214:4891:b0:921:27c2:3f89 with SMTP id 6a1803df08f44-92134a3715dmr207386236d6.17.1795446043629;
        Mon, 23 Nov 2026 07:00:43 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a16754sm107600476d6.39.2026.11.23.07.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:00:42 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVVX7-00000000rK9-14j4;
	Mon, 23 Nov 2026 11:00:41 -0400
Date: Mon, 23 Nov 2026 11:00:41 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <20261123150041.GB179082@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
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
In-Reply-To: <awQd81MwZqi55gf8@arm.com>

On Mon, Nov 23, 2026 at 11:05:23AM +0000, Catalin Marinas wrote:
> > -	/*
> > -	 * If set_memory_decrypted() fails then we don't know what state the
> > -	 * page is in, so we can't free it. Instead we leak it.
> > -	 * set_memory_decrypted() will already have WARNed.
> > -	 */
> > -	if (ret)
> > +	if (alloc_cc_shared_pages_node(node, gfp | gfp_flags_quirk,
> > +				       PAGE_SIZE << order, &mem))
> >  		return NULL;
> >  
> > -	return page;
> > +	return mem.page;
> 
> This part is mostly fine but I do wonder why not make this alloc
> function the same as buddy alloc_pages_node() - return a struct page
> pointer.

I'd argue we shouldn't even be returning struct page here, do many
places even use the struct page? What for?

Exposing struct page to places that just want a kernel addr means they
have to call page_address and we are back to the highmem weirdness.

> >  static void its_free_pages(void *addr, unsigned int order)
> >  {
> > -	/*
> > -	 * If the memory cannot be encrypted again then we must leak the pages.
> > -	 * set_memory_encrypted() will already have WARNed.
> > -	 */
> > -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
> > +	struct cc_shared_layout layout;
> > +	struct cc_shared_pages mem;
> > +
> > +	if (WARN_ON(cc_shared_calc_layout(PAGE_SIZE << order, &layout)))
> >  		return;
> > -	free_pages((unsigned long)addr, order);
> > +
> > +	mem.page = virt_to_page(addr);
> > +	mem.shared_size = layout.shared_size;
> > +	free_cc_shared_pages(&mem);
> >  }
> 
> Here it gets weird and I don't see why we can't have just a buddy-like
> interface. The kernel-doc for alloc says that shared_size must be
> retained for the corresponding free but without reading the source code,
> you can't tell that cc_shared_calc_layout() gives you the same
> shared_size populated by alloc. We have a similar pattern in dma-buf but
> using the compound page order.

This makes sense, we should not be passing size to a free function,
make a compount page/high order folio instead if the API is going to
be struct page based.

> We can get rid of layout and mem structures (or at least not as
> part of the API). Of course, this assumes that the shared granule size
> remains constant for a guest's lifetime but I don't think that's a
> problem.

It should be encoded in the struct page meta data, as the order.

> Was there a caller you had in mind that needs the common allocator to
> share less than the whole buddy block?

If we want this it definitely needs to be a void * based API not
struct page one though..

Jason
