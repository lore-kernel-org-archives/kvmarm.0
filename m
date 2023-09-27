Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9747486
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 07:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gzx1Riy2SNbH00ZPIy3Y2EnyY6eVRPh0uiliDJl5Qjs=; b=uiSb48lUDNyOghhLX7P6ZIVHJE
	9Pqv2ZKM/3sGCF9u39EODtvfQatxrwMVJ6qmSAN/Z9LszxzTu9sTC2Fv9MXEqzh2jpyR4t+5t0J6e
	C9TDR6jjnMPiEpfda87jnOCFcWYJb/u4WC/6nAGkNDEXg1A789dIuZKC7nZKO22RMJV2x+x4tk8Sw
	dTiaMMgKRA+rM4DvMILzrCYJd+35hfpYY3RScEcuh1uo35RSQFDeqLO8avKljaXQAdV5k5eiENZ7X
	m7Y/jsrmieD5mZpyEU70Va/qbrh0thdyBWWNUHDbxY9rwozF7hCis5ceySXseA1fBNQlrGqRUn39a
	tuOiYrBg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qlOX6-00CNmh-A6; Wed, 27 Sep 2023 07:00:28 +0000
Date: Wed, 27 Sep 2023 08:00:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
	will@kernel.org
Subject: Re: [PATCH v1 1/2] KVM: arm64: Do not transfer page refcount for THP
 adjustment
Message-ID: <ZRPTDJwcImUTHbm+@casper.infradead.org>
References: <20230926181932.1650692-1-vdonnefort@google.com>
 <20230926181932.1650692-2-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926181932.1650692-2-vdonnefort@google.com>

On Tue, Sep 26, 2023 at 07:19:31PM +0100, Vincent Donnefort wrote:
> With folios, GUP affects a refcount common to all pages forming the THP.
> There is therefore no need to move the refcount from the tail to the
> head page. Under the hood it decrements and increments
> the same counter.

FYI, this isn't new to folios.  get_page() has _always_ operated on the
head page of a compound page.  Here's how it worked in 2.6.12-rc2:

+static inline void get_page(struct page *page)
+{
+       if (unlikely(PageCompound(page)))
+               page = (struct page *)page->private;
+       atomic_inc(&page->_count);
+}

I can't be bothered to switch over to the linux-fullhistory tree and
show how it evolved, because i think this sufficiently makes the point --
you can backport this patch as far as you like.

Folios just make it obvious that this is what's going on.  And that's a
good thing!  Making the MM less inscrutable is a win for everybody.
