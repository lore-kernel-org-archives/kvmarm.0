Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7633D25BC;
	Mon, 18 May 2026 07:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779088969; cv=none; b=b+lF/Cx/JLsbMtRvilcKf4BR5Nnz7/caCjM/U+c8IDmPvzw2w1drzlz7d6h1WU0xAgXLeBWQ54mtkfRDPYafUZ85sadLO8r/LIbqtXvsrbAhkgriGckwOCZ5GYWbsDKux6p9QuiWbdz7zlJ/WYpBCG5mevjC/M3uOWjRf4Wnb0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779088969; c=relaxed/simple;
	bh=Z1TZfPHrDTb3oUBwxbXx/41cJWGTkTmFko8g9704EBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WA9H2u6mw2Dlx5BMPH7EtGnrVsz67sXRHGUVEG5qy2CzVwR8fB1i89QISNbpxWmbGVZcCwYmpgYFoG8FehsLOY563UaFC58KMJaxQr6WXZOD5yXjsib8ClB8hAtW+qg8ZF3Ng/LajuuC5YJTDw+rvWP3uivGsGUfc3bGlctI+bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1KHRrlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1KHRrlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A97CC2BCB7;
	Mon, 18 May 2026 07:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779088968;
	bh=Z1TZfPHrDTb3oUBwxbXx/41cJWGTkTmFko8g9704EBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K1KHRrlrcm2vGcAvcFUJ/5hZ0ZeT4kWLeTXE0SbhmH+mDiq5l3SN03XaEMlJmdRV/
	 y2jX8w8kMeFzZs+D+4eMLi1A8hgra49FQT4qOoJ7sI1g9szvBmVC/p03fUgbDhhXEv
	 X3HLRkwLPCSo3MafhnHbv3xCZc323igQCktjCNVFvfIhhxTUvZncrwUc43mv896FpU
	 nGT+LDT5FucTLTx/8dLXE843qrQlHvjQD3g4cGVDlgUefeBkGSN7TerqMHYfF795uS
	 2N9cWZeG7n6IkNFuAHqKXA0WGbHy+H4vu/tdg+YnQs0DHHyY9eusXtNiXCLccp1jDO
	 l74jenB7UEcXQ==
Date: Mon, 18 May 2026 00:22:47 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: arm64: Introduce S2 walker SKIP return
 options
Message-ID: <agq-RyKhBy4CIThm@kernel.org>
References: <20260515195904.2466381-1-leo.bras@arm.com>
 <20260515195904.2466381-2-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515195904.2466381-2-leo.bras@arm.com>

Hi Leo,

Thanks for having a look at this.

On Fri, May 15, 2026 at 08:59:02PM +0100, Leonardo Bras wrote:
> Introduce S2 walker return values:
> - SKIP_CHILDREN: skip walking the children of the current node
> - SKIP_SIBLINGS: skip waling the siblings of the current node
> 
> Also, modify __kvm_pgtable_visit() to fulfil the hing on above return
> values. Current walkers should not be impacted

I'd rather see something based around new walk flags than introducing an
entirely new mechanic around return values.

e.g. you could split the LEAF flag into separate flags for blocks v.
pages:

	KVM_PGTABLE_WALK_PAGE,
	KVM_PGTABLE_WALK_BLOCK,
	KVM_PGTABLE_WALK_LEAF	= KVM_PGTABLE_WALK_PAGE |
				  KVM_PGTABLE_WALK_BLOCK,

and then let __kvm_pgtable_visit() decide how to steer the walk. You may
need some special handling to get the address arithmetic right when
skipping over a table of page descriptors.

Thanks,
Oliver
