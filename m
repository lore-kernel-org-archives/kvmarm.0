Received: from out-58.mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDD28829
	for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 23:48:41 +0000 (UTC)
Date: Mon, 23 Jan 2023 23:43:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674517403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OG7fkTt+dHrFA+j7+xTuGl9iMFxjNdGfDAv/XjtHX18=;
	b=QQl1/rfeKwPmkglKgPppVjLdnuv2f6bkqoVpDJJuc/jRI5QecxOqlKr0QGnGsPUNJERnYi
	sbqH/FB2+bKK0karI2p5EykhyCBevtCrJ9M4UAgMTb6+BnqYurEYgcxFwXPO5Rv20qwv8o
	fD69S+2KSShdQP+AWlGsmsY9xbcZV9E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] KVM: selftests: aarch64: page_fault_test S1PTW
 related fixes
Message-ID: <Y88bl/+lqrUCVKEf@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <Y88bRSisoRAML0M6@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y88bRSisoRAML0M6@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 23, 2023 at 11:41:57PM +0000, Oliver Upton wrote:
> On Tue, Jan 10, 2023 at 02:24:28AM +0000, Ricardo Koller wrote:
> > Commit "KVM: arm64: Fix S1PTW handling on RO memslots" changed the way
> > S1PTW faults were handled by KVM.
> 
> I understand that this commit wasn't in Linus' tree at the time you sent
> these patches, could you please attribute it as:
> 
>   commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO memslots")
> 
> in v2?

Sorry, I was a bit terse. What I mean is to update all of the commit
messages to reflect the suggestion.

--
Thanks,
Oliver
