Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC629DB61
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 14:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969758; cv=none; b=jkSb9K5Qz2ewIH4ZkRlV9A9hBwQ/qaYb45wT4+MEdlG74G03q2bX//VCwLF4n54gsUQLLgTfMTf4BMfGOf4Eo8w/Q31efzf+vhQsj3dI7t3htZ6uDCHDlkTtXFhgJPf/k+6qsAas5+NAZWG7vh6HF1QZdgA1/+BA1ntzjQehjg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969758; c=relaxed/simple;
	bh=ClROQ0gaEPQ7jAf/7FfNWpec3iiBudGU0X0l3IuBIoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dbOvf/njeVP6hQZd4kFcRPFVxcboXv/Ib2vAAG0AijJv6tmVqCSw9DOq7/+ifL4mB5comWmDsvk92ZDbB1glEhbePuc1eGZlnLqvCbNB6PEnSL5UVTVQBTCd+XMgDN7N+JqD3flXU5k0dEB0vyDC7c1cJL+ccDwzcEVlGXpIzTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HE/uwa1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HE/uwa1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D03C19423;
	Fri,  9 Jan 2026 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767969757;
	bh=ClROQ0gaEPQ7jAf/7FfNWpec3iiBudGU0X0l3IuBIoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HE/uwa1KnKTTQBeM6mLfhhcIKnW8WpRelvtdLuzWiAnvOd7O0rI6G46vl7JY0/IgQ
	 dhPmyYtNDldXU3F3Jx+uIm5E+vpQceAlUgMK5Ymi9cHONnLOpEv8ZgLwyJS5ZmIq05
	 qIzzsxxUVmgNr8VwCO3EVGNpd/iaBtVoS81C0gTQeGd+drerkq4SajpFfEbJx7SlW2
	 Tn3ocOBFMVCmiPoC4ctUO2NeBdkqqkn0t5zyWAruZEVlpqr5ByFVj84bQ6+A5TkIuY
	 p+Z4VaHuWb//xpdld6EcqsPRK0ec3By3LFj6etG+9ANJC/YrZG0a6mAhSP0gJRrWU2
	 XnBtmokIXyVbg==
Date: Fri, 9 Jan 2026 14:42:32 +0000
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 19/30] KVM: arm64: Annotate guest donations with handle
 and gfn in host stage-2
Message-ID: <aWET2EGnFKZCK2Ni@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-20-will@kernel.org>
 <CA+EHjTzNcTOR5sZpBTUXUP++yqOZEvmfs=S3wqBTG-YT=hxoKQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzNcTOR5sZpBTUXUP++yqOZEvmfs=S3wqBTG-YT=hxoKQ@mail.gmail.com>

On Tue, Jan 06, 2026 at 04:01:28PM +0000, Fuad Tabba wrote:
> On Mon, 5 Jan 2026 at 15:50, Will Deacon <will@kernel.org> wrote:
> >
> > Handling host kernel faults arising from accesses to donated guest
> > memory will require an rmap-like mechanism to identify the guest mapping
> > of the faulting page.
> >
> > Extend the page donation logic to encode the guest handle and gfn
> > alongside the owner information in the host stage-2 pte.
> >
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 7d1844e2888d..1a341337b272 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -1063,6 +1063,19 @@ static void hyp_poison_page(phys_addr_t phys)
> >         hyp_fixmap_unmap();
> >  }
> >
> > +#define KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK GENMASK(15, 0)
> > +#define KVM_HOST_INVALID_PTE_GUEST_GFN_MASK    GENMASK(56, 16)
> > +static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
> > +{
> > +       pkvm_handle_t handle = vm->kvm.arch.pkvm.handle;
> > +
> > +       WARN_ON(!FIELD_FIT(KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK, handle));
> 
> Instead of (or in addition to) this check, should we also have a
> compile time check to ensure that the handle fits? We have
> KVM_MAX_PVMS and HANDLE_OFFSET, albeit HANDLE_OFFSET, so we can
> calculate whether it fits.

The problem there is that HANDLE_OFFSET is hidden inside of pkvm.c and I
really didn't want to expose that in a header as we might as well just
remove it at that point and allocate from 0.

Maybe we could make pkvm_handle_t a u16 instead and I could assert that
at compile type?

Will
