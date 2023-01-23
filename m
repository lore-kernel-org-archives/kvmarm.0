Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507938829
	for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 23:42:02 +0000 (UTC)
Date: Mon, 23 Jan 2023 23:41:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674517320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ufEGUYBZo2g28O9xzm2kDLdhCGHd7hEr8U0o7tIo63I=;
	b=xvgu9pW7eZ98nlMTWWdC0SEsBOmsq4hqrQNaWfsmKGLsW5WMhpU80IlPLwHEmIFLE88xY/
	xpTfVmk2F0fuK6+TCbVoYlTwZVsNhPf7f1noMoEBkIQuqcnepmjTg4sho35o1TSromgcbz
	ipCbZzzE2fjHY5BZYOuwJ4ZvK+Qfne8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] KVM: selftests: aarch64: page_fault_test S1PTW
 related fixes
Message-ID: <Y88bRSisoRAML0M6@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110022432.330151-1-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 10, 2023 at 02:24:28AM +0000, Ricardo Koller wrote:
> Commit "KVM: arm64: Fix S1PTW handling on RO memslots" changed the way
> S1PTW faults were handled by KVM.

I understand that this commit wasn't in Linus' tree at the time you sent
these patches, could you please attribute it as:

  commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO memslots")

in v2?

--
Thanks,
Oliver
