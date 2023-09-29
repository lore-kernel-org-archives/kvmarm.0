Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C81611737
	for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 13:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dt3+Gee4n493ylM7Lgh9enoYPiATPdmVGjPO0i2DNIE=; b=C6o0SgZNP6MRBvncMimIbIodtV
	5Rnzbls/ZT/6AuiSZIpKQgmOw4PF3HnVYJ17nLBrIJgDXgJNNvSwh3FDPKtz2TBHyClWyvhD5JHXs
	Zv7CfOjfy94rZ37sSAfXzFAmIHqzxFZyR5gw7iR3T44Ue5Hvi12JZffFlafj+dNBJmnfspIpT3aI+
	5Vvcg1ZJQqpxVtNUDGwnv0paIkRUNPwCfKCJqZPqPA1Mxau1Ox8HR39pbhbRac89vI0FMXiDpWBgR
	VJ/JLyxDyYHsBZ3GMR9iUos4Byrm0akBJeIJxBba20q0zH7IDwiyMvm05keNEnfxBVHnTKQ3ggdBq
	VjEzOZXw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qmDDT-008uCI-EX; Fri, 29 Sep 2023 13:07:35 +0000
Date: Fri, 29 Sep 2023 14:07:35 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gavin Shan <gshan@redhat.com>
Cc: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
	oliver.upton@linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
	will@kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: Use folio for THP adjustment
Message-ID: <ZRbMF1Ik+GOuTk7s@casper.infradead.org>
References: <20230928173205.2826598-1-vdonnefort@google.com>
 <20230928173205.2826598-3-vdonnefort@google.com>
 <a226023e-4651-05d6-30eb-e3f3595dd98b@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a226023e-4651-05d6-30eb-e3f3595dd98b@redhat.com>

On Fri, Sep 29, 2023 at 05:24:00PM +1000, Gavin Shan wrote:
> > +		size_t sz = folio_size(pfn_folio(pfn));
> 
> Is it possible that a tail page is returned from __gfn_to_pfn_memslot()? folio_size()
> doesn't work for a tail page because order 0 is returned for tail pages. It seems it's

pfn_folio() can't return a tail page.  That's the point of folios; they
aren't tail pages.  They're either a head page or an order-0 page.
