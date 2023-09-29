Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F1917E1
	for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 05:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cpgFGTRKol3innmX8XmdcZJuEeuKQeErqp+5XpFli3I=; b=pZRSf9RRi7urYT84dyvRo1E07p
	9Wt1WF30w0rXzjfZTLieIVe3eFpqBtsTSu2Ql4OhtHcNUIjjKH3R9+ATJu2QE6Zp8IUTna84VyPEr
	hQtPKtDmMDuQU4fQaQB5Bc+D/DYGbivWVOwmEy5Fwv3EcsUEvZpVD+b6TYBTWvBFZWu1atoGH3oRs
	ZqTMCE7dia+WFUlkgaSHUz0lNhhegd+CqjXIIe/kOgkAWWz6mkzWaZpxsv2CFOH7zK81EA54Dn1ak
	Blwoaw6RYZPjBpOgXO1woiytJ5gHmw5mRjMi0ECOthIPx0Vi5nCdigGSd9UmsueyCS+a6YSS1w4Xo
	Pq/6/oPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qm5ua-007A1z-2i;
	Fri, 29 Sep 2023 05:19:36 +0000
Date: Thu, 28 Sep 2023 22:19:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Stevens <stevensd@chromium.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
Message-ID: <ZRZeaP7W5SuereMX@infradead.org>
References: <20230911021637.1941096-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911021637.1941096-1-stevensd@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 11, 2023 at 11:16:30AM +0900, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> that is backed by struct pages that aren't currently being refcounted
> (e.g. tail pages of non-compound higher order allocations) into the
> guest.
> 
> Our use case is virtio-gpu blob resources [1], which directly map host
> graphics buffers into the guest as "vram" for the virtio-gpu device.
> This feature currently does not work on systems using the amdgpu driver,
> as that driver allocates non-compound higher order pages via
> ttm_pool_alloc_page.
> 
> First, this series replaces the __gfn_to_pfn_memslot API with a more
> extensible __kvm_faultin_pfn API. The updated API rearranges
> __gfn_to_pfn_memslot's args into a struct and where possible packs the
> bool arguments into a FOLL_ flags argument. The refactoring changes do
> not change any behavior.

Instead of adding hacks to kvm you really should fix the driver / TTM
to not do weird memory allocations.

