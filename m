Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB976136E16
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 12:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543542; cv=none; b=CcksoqA3krYbG8ZNU3hkvv7W1N0jlDCZuzJnoltsOMLUQBtc8Ri4sAIPBNHSTb3meJ571SHbCwxuXFtCuTMehsYblmjHL7lJxvZJp+oppmpvohgfb5+ObhdmWAO3mhBvZ/6aJkQgFE2ClrZJw9zXfav0Pmi5WO/q7jMnQZ0Wz00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543542; c=relaxed/simple;
	bh=UG+sWCgJdW5QMJRXuangEUOiQHJCcImOBJ7ALiw3A+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+SsATAqt07XYKtvWpdUA64fnrEEgjbCYRGvnzQq7ISO/29rcJo65p9tW9dJrNvZ9Vhe88oL4AkCYcl84Zpig7sPqQzwcUecDANSycw6cTJIwAEdWBwcotQxR/n6Lx53uUKRMMD64eID/cVbCz/uAHs5wROy1kcwhFMElTONfU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjG1DV51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjG1DV51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335FBC43394;
	Wed, 27 Mar 2024 12:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711543541;
	bh=UG+sWCgJdW5QMJRXuangEUOiQHJCcImOBJ7ALiw3A+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AjG1DV51cFLTNpfm3NxY8PrL9hGn+XQNXMMyZPfnyiBNfR9WvTZLb2pv8nrQq0sXQ
	 BQbBzJLW3SB4C5elH0EG9mzbKEj+046NQ9Rfeh6jS4e9shDpJEGm5OuC6NEAy7XfHK
	 aIh8+FPnvdsgth9RN4CobaidDaRMIQNESRT3iND/n9YbL80xdxpK2k5w7zNQPo2mZm
	 uTG1VIZhXdqROHyoDTU134Tm14XPqawybdeRI3nviUwilHQYzowP9AuD5NlBmykaYs
	 41CDToMAKZTB1NELr8Ha0LBI3dZbzsGtHcik2URxmc8Vw9qnJISPDIFWok056cV0LR
	 7RpApRFItLzFw==
Date: Wed, 27 Mar 2024 12:45:35 +0000
From: Will Deacon <will@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Use TLBI_TTL_UNKNOWN in
 __kvm_tlb_flush_vmid_range()
Message-ID: <20240327124535.GA11031@willie-the-truck>
References: <20240325185158.8565-1-will@kernel.org>
 <20240325185158.8565-4-will@kernel.org>
 <b3177895-5ed0-4f1a-bede-4d0c87935bbc@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3177895-5ed0-4f1a-bede-4d0c87935bbc@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 26, 2024 at 01:48:46PM +0000, Ryan Roberts wrote:
> On 25/03/2024 18:51, Will Deacon wrote:
> > Commit c910f2b65518 ("arm64/mm: Update tlb invalidation routines for
> > FEAT_LPA2") updated the __tlbi_level() macro to take the target level
> > as an argument, with TLBI_TTL_UNKNOWN (rather than 0) indicating that
> > the caller cannot provide level information. Unfortunately, the two
> > implementations of __kvm_tlb_flush_vmid_range() were not updated and so
> > now ask for an level 0 invalidation if FEAT_LPA2 is implemented.
> 
> Ouch, sorry about this! I remember rebasing my change onto the KVM tlbi range
> changes and having a few conflicts. Obviously I didn't do a good enough job of
> reviewing the result and missed this new user.

No problem, it's easily done. It's also not your fault, as we shouldn't have
been using the reserved encoding of 0 to mean "no hint" in the first place!

> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Fixes: c910f2b65518 ("arm64/mm: Update tlb invalidation routines for FEAT_LPA2")
> > Signed-off-by: Will Deacon <will@kernel.org>
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

Thanks.

Will
