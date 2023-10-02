Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE7F10F3
	for <kvmarm@lists.linux.dev>; Mon,  2 Oct 2023 06:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=InW3sf1bK5Wc2jmOSnsvmSrnjzk2Pzj04pfxMdYCcWw=; b=KeC8/ODHqVRyPLLWTzKg4B/RiX
	fPBt0w/lD4S8/QIqpD+hkjWXG/ZRlw2awKa7EeCDakGqfaUYsRpXLfLIdnX5ZdhHACB5v+HSFdHhy
	6SU/hpjWN+8azZT5kEBsea/MFxaP6zhO5asfb3UYYjJOIASgSWpozEbgmEg69rOgtS/MtbcK6hwY8
	9zXkZzVH3S1k4EE42GznSO6OYLokbZGqWmuEyYIJ/hhSAXHXxRhW+/ITDrnSwQ2JZk6zvwl8r09q/
	x42JUrQIjBGe7n/CXpq9oUwMZyaxAf93dytavaeVE5nDl7wbV8TVh7N39BOluX0nUYe8bEVnl2rGi
	q4KhlGZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qnCN4-00C1Xw-0I;
	Mon, 02 Oct 2023 06:25:34 +0000
Date: Sun, 1 Oct 2023 23:25:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	David Stevens <stevensd@chromium.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
Message-ID: <ZRpiXsm7X6BFAU/y@infradead.org>
References: <20230911021637.1941096-1-stevensd@google.com>
 <ZRZeaP7W5SuereMX@infradead.org>
 <ZRb2CljPvHlUErwM@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRb2CljPvHlUErwM@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 29, 2023 at 09:06:34AM -0700, Sean Christopherson wrote:
> KVM needs to be aware of non-refcounted struct page memory no matter what; see
> CVE-2021-22543 and, commit f8be156be163 ("KVM: do not allow mapping valid but
> non-reference-counted pages").  I don't think it makes any sense whatsoever to
> remove that code and assume every driver in existence will do the right thing.

Agreed.

> 
> With the cleanups done, playing nice with non-refcounted paged instead of outright
> rejecting them is a wash in terms of lines of code, complexity, and ongoing
> maintenance cost.

I tend to strongly disagree with that, though.  We can't just let these
non-refcounted pages spread everywhere and instead need to fix their
usage.
