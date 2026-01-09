Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BC2224AED
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 15:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971083; cv=none; b=rIlj/o0+HfHW9iARWnbQhLYx1jjYrVVkWNWDd2FTJnKzYWIQSGG3BF7rpcWRgO0P44eAUEBlXxq0HsXLdyTheV+4RdjeJ6+d+mufsBmZE2gBr7DVSSBi5/cN6QTfmvMD6NHE5XKATPpl7yqoNnPvZk71nqoW7lrlMiXytFhER9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971083; c=relaxed/simple;
	bh=NTHAIMWKRvVNaDIczbnhudQH1H83cIjU7GlMUz7sbuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GPP71wnxjK5HC6qf/slUoWW0MPIW14rKO+FB2wWD4eYt6t0t9Q/40WS2Ajti44vUMA/IFo5NXqOv0kVWv6Fy7v8dhoVOjGD1GarHlqxF2hfq3d52sC1Njqw6LFzta49hEBQjbz3NZZz0OW5t/Jq/TD4056xeoUWQwEUteYRAgsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=liTmXKJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="liTmXKJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FEEC4CEF1;
	Fri,  9 Jan 2026 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767971083;
	bh=NTHAIMWKRvVNaDIczbnhudQH1H83cIjU7GlMUz7sbuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=liTmXKJVPrwDDFTZUTUMLnfd24HIt/o1WhFrQeXzwFuApirgG5AR2hzQMsl2FzTgI
	 X48nu0klTOa+twXjM8t+ZVUDpZVYN65rPmTG1IPYTOFa0w6mHkgLHmXZqFCVIlvZJz
	 NZ1hQWNUT4dKDLiCSjXf9n+fvJ2LGtsKUUJa6GT/aYmzs7xILNrAOSNXErn04KveXe
	 +Bf3OtRUZsmlz7rmFSvpUZhfJZdOv8vfvy90m96XnDP6P0XodEUr38WzSS6bR+X63U
	 UK3KXhYxO5f91bQOoZYaCgTlK9aErSPQ63dNSK+FiKXqjBUpc3pKBHJLKAv90ZgPqy
	 Y0ggRJn8LVMmw==
Date: Fri, 9 Jan 2026 15:04:37 +0000
From: Will Deacon <will@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 27/30] KVM: arm64: Add some initial documentation for pKVM
Message-ID: <aWEZBWWX6EpZd33S@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-28-will@kernel.org>
 <aV0xaa8MpsmxMMkL@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV0xaa8MpsmxMMkL@google.com>

On Tue, Jan 06, 2026 at 03:59:37PM +0000, Vincent Donnefort wrote:
> On Mon, Jan 05, 2026 at 03:49:35PM +0000, Will Deacon wrote:
> > +CPU memory isolation
> > +--------------------
> > +
> > +Status: Isolation of anonymous memory and metadata pages.
> > +
> > +Metadata pages (e.g. page-table pages and '``struct kvm_vcpu``' pages)
> > +are donated from the host to the hypervisor during pVM creation and
> > +are consequently unmapped from the stage-2 identity map until the pVM is
> > +destroyed.
> > +
> > +Similarly to regular KVM, pages are lazily mapped into the guest in
> > +response to stage-2 page faults handled by the host. However, when
> > +running a pVM, these pages are first pinned and then unmapped from the
> > +stage-2 identity map as part of the donation procedure. This gives rise
> > +to some user-visible differences when compared to non-protected VMs,
> > +largely due to the lack of MMU notifiers:
> > +
> > +* Memslots cannot be moved or deleted once the pVM has started running.
> > +* Read-only memslots and dirty logging are not supported.
> > +* With the exception of swap, file-backed pages cannot be mapped into a
> > +  pVM.
> > +* Donated pages are accounted against ``RLIMIT_MLOCK`` and so the VMM
> > +  must have a sufficient resource limit or be granted ``CAP_IPC_LOCK``.
> 
> Perhaps worth to add that there's no runtime reclaim either so the accounting
> will only grow until the VM is destroyed?

Good idea, I'll extend this to cover that. We just need to remember to
remove it when we add support for the relinquish hypercall.

Cheers,

Will
