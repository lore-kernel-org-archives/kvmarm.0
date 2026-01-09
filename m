Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1059C1FF7C8
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767980883; cv=none; b=oaMiYZ6BKMt+UuuqDxIrBqrk32wRQXJm01jKdE6NsW/gFQMbuXiDkckRkH7KGDLr/ycVRI/orEMcH/HaCs4SeMHKa1rSF1cDDUu+jnwqHimwSlbEBuZPzY6vCnAZYrz294MNjT+5c0rlSrXrFtXozZDslCY0GuIct4fNGC1hMoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767980883; c=relaxed/simple;
	bh=3QWiObunfis5djNAZb+wYVWjctgr/CRj7eFG13KqXOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZwyCEjuZCPJxtzs/vKf8NoppjzbU+d8fn/Ckd/7QXjdwybabkJ+++8C1oWzmIrX7kVMDuvobi0+dhu/kUH7ffGYZVvYKL/++cQAckGETrn01btO4BcIkvfzzD1HeHIYq6K3NoAAESKR3XE17TbQJCYhTrv9K4aw4ey3kNZPlxwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fOe29o4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fOe29o4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338CCC4CEF1;
	Fri,  9 Jan 2026 17:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767980882;
	bh=3QWiObunfis5djNAZb+wYVWjctgr/CRj7eFG13KqXOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fOe29o4myh9rammqInR8XR907tp2YDqfTVO0BMC2z+tLY1hPrk5Yf0UQVMkt/PWDn
	 sHYR/PYrw1n2J+3XqK74pSWke2E1J9iIY8Lrp2NsVroVYE2yJ/0m41EmMYZ4TToQIU
	 kW96DoZMpyo5kHyQYFvE/r6RjJ0hCKPBCDT/03WXoiiZqzlBmDa9O7uMa1aSelA7VS
	 9R4AtC6J4zXMFv8XcN6sbRGMpM1azZeG5xJryHYpTScU+WsH63ZhlEC+NWxW0s3NpE
	 Q4KRhwYT02Yuuxh4XhywQplK59m9sOKBGBKMBNqammRn+h8/YtJ2GgrCDAoM4jBLXQ
	 dTTgR/dephUVw==
Date: Fri, 9 Jan 2026 17:47:56 +0000
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
Subject: Re: [PATCH 20/30] KVM: arm64: Introduce hypercall to force reclaim
 of a protected page
Message-ID: <aWE_TGDm_makBPhi@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-21-will@kernel.org>
 <avfs64mpioh4ckdo3gokndinpjdrgfzz2pjhkyyh65v6spuai3@nz4zih4rbv6m>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avfs64mpioh4ckdo3gokndinpjdrgfzz2pjhkyyh65v6spuai3@nz4zih4rbv6m>

On Tue, Jan 06, 2026 at 03:44:06PM +0000, Quentin Perret wrote:
> > +static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
> > +				       u64 *gfn)
> > +{
> > +	pkvm_handle_t handle;
> > +	u64 meta;
> > +
> > +	if (kvm_pte_valid(pte))
> > +		return -EINVAL;
> 
> Nit:
> 
> I can't think of any cases where we'd end up returning -EINVAL here that
> isn't indicative of a major problem (e.g taking a stage-2 perm fault we
> don't expect) given that we've extensively checked the state of the page
> already. Upgrade to WARN()? It's fatal, but the system is unlikely to
> make much more progress if we return cleanly anyways, so we might as
> well make it obvious where things went wrong.

Good spot. We already confirmed the NOPAGE state, so a WARN() if the pte
is valid makes perfect sense to me.

Will
