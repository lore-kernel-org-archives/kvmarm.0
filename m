Received: from out-205.mta0.migadu.com (out-205.mta0.migadu.com [91.218.175.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F2C1C29F
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 06:30:46 +0000 (UTC)
Date: Wed, 27 Sep 2023 06:30:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695796244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OcHQMUs7S3hEb2hCa9u3IStXK67tQ8ZYrh/J/yyNvkI=;
	b=Bzfo+qfXvK46D68vbx/KAsiucToKdFvwToS8WnNmrBCzGQvsQEYZzvyFNGBV5d/sgs3QWr
	r8oU/5cg+zIq1Ys5Kzw3nAYODCQKUj8nx8Q4uOBC46VzTlOGCwnSviPDBmXD4HrUG8Brnw
	kKSJgeJ+9ww4rBOtb+79O3mqT/ZqeDQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
	will@kernel.org, willy@infradead.org
Subject: Re: [PATCH v1 0/2] KVM: arm64: Use folio for THP support
Message-ID: <ZRPMEFvQ-bt4rPDQ@linux.dev>
References: <20230926181932.1650692-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926181932.1650692-1-vdonnefort@google.com>
X-Migadu-Flow: FLOW_OUT

Vincent,

On Tue, Sep 26, 2023 at 07:19:30PM +0100, Vincent Donnefort wrote:
> With the introduction of folios for transparent huge pages [1], we
> can rely on this support to identify if a page is backed by a huge one,
> saving a page table walk.

Better yet, this gets rid of a particular walk that has had some rather
hairy bugs in the past :)

> [1] https://lkml.kernel.org/r/20220504182857.4013401-3-willy@infradead.org

nit: for the sake of posterity, it might be good to stick a reference to
commit cb196ee1ef39 ("mm/huge_memory: convert do_huge_pmd_anonymous_page()
to use vma_alloc_folio()") in the changelogs.

-- 
Thanks,
Oliver
