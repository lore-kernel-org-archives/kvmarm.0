Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121CF522D
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 23:10:43 +0000 (UTC)
Date: Fri, 27 Jan 2023 23:10:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674861041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZO3SgWOS/7Szzg9zC9NbHnkwsueuqHnRdzYR3FBmDcU=;
	b=xuNbVLxDbxsQ6PCYOaKt2KVwp9CaRXhbKze444e3b3t8P6hrfvVh/4KXMeFme7/dvYovSD
	H5oXA22EQHRiAJUem0LVY1Y8BraVMWXrkbKNsrXEK1Y0sPiLPEmiOp8Zslm2/cgtWdmSZF
	HDPR9hhnL2PrdYlbz2XoIt+Oz/mMX1Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/4] KVM: selftests: aarch64: page_fault_test S1PTW
 related fixes
Message-ID: <Y9RZ7lkKPeg8MnvE@google.com>
References: <20230127214353.245671-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127214353.245671-1-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 27, 2023 at 09:43:49PM +0000, Ricardo Koller wrote:

[...]

> Changes from v1:
> - added sha1's for commit "KVM: arm64: Fix S1PTW handling on RO
>   memslots" in all messages. (Oliver)
> - removed _with_af from RO macro. (Oliver)
> 
> Ricardo Koller (4):
>   KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
>   KVM: selftests: aarch64: Do not default to dirty PTE pages on all
>     S1PTWs
>   KVM: selftests: aarch64: Fix check of dirty log PT write
>   KVM: selftests: aarch64: Test read-only PT memory regions

These all LGTM, thanks for respinning. Tested these patches on an Altra
machine.

Marc, I leave it up to you if you want to grab these patches for /fixes,
otherwise I'll take them for 6.3. If you wind up applying these, for the
series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
