Received: from out-146.mta0.migadu.com (out-146.mta0.migadu.com [91.218.175.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FFA8BEC
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 17:26:33 +0000 (UTC)
Date: Tue, 24 Jan 2023 17:07:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674580027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VZdc+CjlDbqIwSaItHfVfQKULFa++Rc+n7xQkR7HMLI=;
	b=JBKMJvg5y+WwAbOGso2cySv6b9CEtpy6vf6AG7O3kM8tN/n/CCMbnWpJzNE/XQZJlYtHcF
	D19eOGLTvhe77B9SWzhOaQB4NDRxu0tY+LLzHiM60fDBWeEuu9amb4M/tB1XaORSGxjfCb
	vODsw5bUwrflwHM3JD63rN+8J+cwAUg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: Ben Gardon <bgardon@google.com>, pbonzini@redhat.com, maz@kernel.org,
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 2/9] KVM: arm64: Add helper for creating removed stage2
 subtrees
Message-ID: <Y9AQNk7Uh9h6r93N@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-3-ricarkol@google.com>
 <CANgfPd-KSX=NOhjyoAQRrLyHArQ=Sw3uMjmdh5J0yrogUN8mbg@mail.gmail.com>
 <Y9AI3FWEeIaw9kRN@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9AI3FWEeIaw9kRN@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 24, 2023 at 08:35:40AM -0800, Ricardo Koller wrote:
> On Mon, Jan 23, 2023 at 04:55:40PM -0800, Ben Gardon wrote:

[...]

> > > +/**
> > > + * kvm_pgtable_stage2_free_removed() - Create a removed stage-2 paging structure.
> > > + * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> > > + * @new:       Unlinked stage-2 paging structure to be created.
> > 
> > Oh, I see so the "removed" page table is actually a new page table
> > that has never been part of the paging structure. In that case I would
> > find it much more intuitive to call it "unlinked" or similar.
> >
> 
> Sounds good, I like "unlinked".
> 
> Oliver, are you OK if I rename free_removed() as well? just to keep them
> symmetric.

Fine by me, and sorry for the silly naming :)

--
Thanks,
Oliver
