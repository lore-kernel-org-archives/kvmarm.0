Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525676;
	b=i61ds7Wqu8N2YXIMEiPWAW27/OnFB4chuenUUH5jXTulkyVvZGRT/l0V27ryRgHK2hpq
	 wlKO4RMUWgHKZTkWZPxcy5/vSx/eRcq+95GSdoXXajrYEq4WWFXDnF0vfe7UtNh2CGvX2
	 HDAxGSGH8tkGRpsypakVeD8ax6MJOzIR0hpmg6oZQRc7fEwxizb0BlhqMYOznJnB7fHPG
	 I6QLUFjcCCsD2BXuj9ZqTlsyzhcEGc40zOU6MJMXq8GoBuorb4wGUTbCe/oNkU2kRLS45
	 4u5thU06XqNC4IiXb9a7L9lkOn3yk5N8QVGbD9ZFqE/lEP8/EOMeYzef55FY7qCXX4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525676;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=2Jqv6h2U/zwufJIWy6q7C5BzrR7eGEBWyzupif8ezko=;
	b=q3PwVCKZooEZGXEWA+6yjmTeT89oCY/ZneVqq3+OUvYMlzEAyjZ1c4zx8qeO4eokHINO
	 wD7ppHZntK6BIcPJLx92Gs/MN4JSMEdvY2ULrzGXmCTkzHaThtKN2V9wRxTc1gYzv/KQg
	 rc9gMpG5vqBVPvaHnesPHdtl5KPdNgca25Ky/crUSeWlIq8ZZy30ZQciBzJj7SgyTtQ/W
	 UIgkc+Pos+R6iljsUvJSHtA7Ii1PD3Z5t9HM8pBfkS87kHHaGHpQeQQO1gW+uReeNIhzI
	 4cl4WZUGRWMAc16oo+jCcg4Fb7U6cfzS5E8wcdm4lxyf0wKuPan/hi1U4oXOSYR0BPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=CJZp6cV7;
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A11606A322
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 13:07:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44A11606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=CJZp6cV7
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9496473b511so535204985a.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 05:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795525675; x=1796130475; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2Jqv6h2U/zwufJIWy6q7C5BzrR7eGEBWyzupif8ezko=;
        b=CJZp6cV77fzkUCXvgeGyc7n9vOvZov1aNWjYfoQB8lqfjpe7VVz2pKyasHC0M9bSo3
         qvoro/45R0bYQRTdO2OhOwP8IqZDTveCj+W0rKGqVuCBz/BgVUCJlNyD58G1GcYb3njP
         MhERoQBSZF9WEeWN1BrNcXyxnT9a2V9qA6Tztu/pOhGSXK2qaxtPyM7+o3gi7IQ5m8Vl
         zl9+/Rui9jQl3P++qkZI/CGbAH51e/eughhaB/kN3C/3tgk7TbjbUX+50M64WuaFgcYP
         wX9YibH8TLZgk0DjcQxRjLhIWJBK9Dfla9PQfVx96fqCzu0PbTcLTtuv2r94I2lv8Uf7
         UBLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795525675; x=1796130475;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2Jqv6h2U/zwufJIWy6q7C5BzrR7eGEBWyzupif8ezko=;
        b=S0rLRx6CUpBY5FpWbnLnLCsS3B7B9OAot2NoRqnzFFPFUrzha5hFfWcyh43W0ik9ci
         IUL1U72Y39SDMkSSCdeoi/Fu66W8tD13j4AuUo9/yJm6uU9gXJFSlrogwkzOs2tniNrp
         siGnMGocaKu5gqDELsQ8Z0LgY8eaZ+TCLwjQzVwbzYpjpBLMpNY1i8Hg7Rv6nAhk1qKq
         tI+IuNoPVPpYFF2wo3zMKmsA/R+JPecN+DSEtGLcOfoCCgFYphvmZKFIbmqAqDvn+pBR
         4osbLUK1SLB+3XpWEwmyx9NHywFIsMZ9EvWfj9W5YfseLrP3ONcXpAVMEdjqzN0jfq7E
         kJSQ==
X-Forwarded-Encrypted: i=1; AL+hErFaHQt1XW0JJj5MS+gkiMHx2gc20vOmV8/bPLCd9KabWBmSxx7M1OA0C0phrGvKikQ1X8i0s0I=@lists.linux.dev
X-Gm-Message-State: APuU4Z+nI2kWO5dErztWtXsTzU5iejx14SqLlDi63OetYOvWnyI25mPe
	WREWtum1b2L2mou+W99sA3HNECmhX6/iYXb9lkpqx6ZtLcdulm61NFHAM5CeaQnfLsY=
X-Gm-Gg: AZFdTZeGlE0kj/4RlYaegFvK6s1RD0gECRUQpRlHqiVCmqI4tr+EhLGOcFmH03+Ic79
	FMvQMM+vVZ1bNpm6WlZCIHSMOO4gtoDqFqAIdN3zJyNwUhP1dU97oC0uXlsvSA8jQOCjR3FIFGN
	Jd5roPEZmgpj6S1z5BibFdiy42jVRYMaIn6OGQdL5GTjoba9ibtKm9TFF9WeouWs+2zsWy4s+tW
	GXREMMatqVDnIv5urwCbpjOfdh8abYFc0BInBqz2Et44/Hqji9az6ZJhQKkvlA+ZxO2ws5N6lfM
	sc068gLBlefVWr8EVpVLkNkg7TxP67Zmm2poc6hw6B8w1WrfVueADXkBjeLgbySrlOAsveVLAP5
	iPc4UbKIvzPEdh5tf8wOOOFvHx7BJo57RU0BT46iwUIG8dFSNuBwO1+ddgWEp73x4UIGtei3SDA
	k0Ic/8bdpevMM3FUzM9giFVXkjMYFLc1F3LOJ/EPHEc9BuIA9vnlXBN/tiJ3zXrLQb/XFHxRBoQ
	tQYAqec60I2G89Tlr2tqZ90Ymijn53Tw3WQ/BxYmYVIvXOvM4JBIE8/9feocCXfRiPw037b+Ro3
	RAokCw==
X-Received: by 2002:a05:620a:2705:b0:949:8ee5:6faa with SMTP id af79cd13be357-949ba818db4mr2224332285a.4.1795525675010;
        Tue, 24 Nov 2026 05:07:55 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb4219c4sm1034879485a.41.2026.11.24.05.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:07:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqFV-00000000OKe-3ac5;
	Tue, 24 Nov 2026 09:07:53 -0400
Date: Tue, 24 Nov 2026 09:07:53 -0400
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
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <20261124130753.GD9566@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <20261123150041.GB179082@ziepe.ca>
 <awSGBdS1AiFhJzZV@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awSGBdS1AiFhJzZV@arm.com>

On Mon, Nov 23, 2026 at 06:29:25PM +0000, Catalin Marinas wrote:

> > Exposing struct page to places that just want a kernel addr means they
> > have to call page_address and we are back to the highmem weirdness.
> 
> dma-buf system heap needs struct page for scatterlist, so we need the
> virt_to_page() conversion if we return a VA.

Yeah, but if that is a one off I'd give it is own API..

> > > Was there a caller you had in mind that needs the common allocator to
> > > share less than the whole buddy block?
> > 
> > If we want this it definitely needs to be a void * based API not
> > struct page one though..
> 
> For whole-block sharing, either a VA or a folio works for me. If the
> allocator takes an order, the requested size and the sharing granule are
> both powers of two. Rounding up to the granule already gives a valid
> buddy block size, so there’s no need for a separate shared_size.

But you still will need the allocator to use the struct page metadata
for its own tracking information, so it shouldn't be exposed to the
caller..

Jason
