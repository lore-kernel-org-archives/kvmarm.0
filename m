Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2A329ACD7
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 14:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969119; cv=none; b=Au/7zPzKSIgvbBMiWCVQCNEuliQ0EasvJNlKFq/EA2BkISvtCNFk5PKvwMwyyDQyaqgb3VetIRlusN9ZCJqJdXRL1hqPDs9mB7yUjKhe3C4UicxSECoG12y7/RPBlLH35+AY2r5d1pdTjSWb5B08eC6I1F331DRVfpsFRX2B2ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969119; c=relaxed/simple;
	bh=0OMbNmKBSAMlscTFPF8U3b40AirkRJymWHIakbWKdGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ODMJtF7Ydy5+9FkHvFzRCtvvkMSli+ulwJ1NJAKAZkyN6g+DqItOUlic66A+qc5ew7x+td726pW5sMbrmbN6y/x3Njoe+E03AUq7iIFNqu3iXVQp7k4UF+qfyzYvgifkYfZ5y1FryJ9D2Nptnheck/nhEjFKp7ZKXIQaxNojPnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Npv1PWvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Npv1PWvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B94C19422;
	Fri,  9 Jan 2026 14:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767969117;
	bh=0OMbNmKBSAMlscTFPF8U3b40AirkRJymWHIakbWKdGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Npv1PWvfKh73fHrLyHLRxaGOSwG4aeYUBagLOYcTsqMVVvsqN/eQO9e6gUFDjHyo4
	 Le0q+UQCNpbTW74gmYPLDxkzq++Ucm5XiSkIQXtdJpvEeyhgOO5eDVy2jG0X3vzN6j
	 mwC9JqfYUil61lR5544cNKDxLmYaaYrGLmW/E1JJb0fOqFF0rAGbFwPsIk8HwjnQTg
	 UObK6pyrDrCmA9HXo2bnSLnk9b3rH8Fnxr6v/U6zTzgY40r9YkqF0KohE6z7TmD2CE
	 10eYPRSP40aJYA7BjDdZ2Lqcy8aMI97bPuxiDj58yPpa9tWt3EOXG+AS9ggSCy6Gc6
	 APLJocfJ4THdw==
Date: Fri, 9 Jan 2026 14:31:51 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 02/30] KVM: arm64: Remove redundant 'pgt' pointer checks
 from MMU notifiers
Message-ID: <aWERVxw-57pzi6ko@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-3-will@kernel.org>
 <7g66xbfmfqf67qcowjuu725h3l33ecxhkffmlzxsjtbusk5eor@khlpkp7jdfzr>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7g66xbfmfqf67qcowjuu725h3l33ecxhkffmlzxsjtbusk5eor@khlpkp7jdfzr>

On Tue, Jan 06, 2026 at 02:32:12PM +0000, Quentin Perret wrote:
> On Monday 05 Jan 2026 at 15:49:10 (+0000), Will Deacon wrote:
> > The MMU notifiers are registered by kvm_init_mmu_notifier() only after
> > kvm_arch_init_vm() has returned successfully. Since the latter function
> > initialises the 'kvm->arch.mmu.pgt' pointer (and allocates the VM handle
> > when pKVM is enabled), the initialisation checks in the MMU notifiers
> > are not required.
> 
> It took me a while to remember, but I think these checks are needed for
> the free path rather than init. In particular, the doc for
> mmu_notifier_ops::release() (from which we free the pgt) says that it
> "can run concurrently with other mmu notifier" (see mmu_notifier.h), which
> is fun.
> 
> Had you considered that path? If so, probably worth expanding in the
> commit description why this is safe?


Urgh....

Let me get back to you on that :)

Will
