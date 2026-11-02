Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648995;
	b=JiRQPMJl35O5+lXAhQW2SabJytUpTHdxXuB+NycDqvKxAlKAksPb0uK6K3/v3YGOdYZz
	 P0pT8BXPrfW+Gi/l/tyWNG5cQcHYwbPIQYWMP9eMR3qc/vnZnqkJdqNYovUpU2qSo+i3S
	 hGrVkNWFBF8X7P/tN5BfkKUbvfHLQg9dHudxHV2k2VI4aK7LZIlYPrz53mmGv8aOTimMV
	 pssYr3ApGhrj7VbqEHS9a3M/EH5eZVl5H5Bc7OeQ5Su8TkEzuz2Z0hWZFvxC2wAXApui/
	 JGVY2Vb0CFO2+0y/D7DfxyWN24F9pUpp5OvdbGPPlqNimjAyFZJUVTb87y2zXPi+Hzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648995;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=y06JvPs8K+3h5iGkCmJ6Hn2gbcqjc1hia4SrPtzPFhY=;
	b=mptXSPhAuoSBapTLi3TXAligvk09VDBtp0i/E5Bi6uNDEywiz+aFMDE1br2oAkEXWlrm
	 55TAEOt5WXj96DRMYaELNCHqrJyBg/RmkeHqob3i+zPMX4/GQK1AiNjI6H9YHhbtHF0Oq
	 SBJ83UZJOjVb2VXikmxQGDnBffkFKlzwjVohKIXnJogPxRMT62D5TZNFlRc8uAP3NoE9P
	 jhUnV3jj9lqREwz9IHgIbGBPeeDFyVl8ptScIai2EBOn1U5x5ECEH5dAJU+9wxSEGnr76
	 q6jkIf7wHlRJUIa/EdIaPCJVsFoRgbMn4QhVBGN8MB4k5TjH48fpwLF8PgVTSh1fbyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nAarvwLp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2B2606A324
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nAarvwLp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5C51F00A16;
	Mon,  2 Nov 2026 19:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793648994;
	bh=y06JvPs8K+3h5iGkCmJ6Hn2gbcqjc1hia4SrPtzPFhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nAarvwLpYqOyKZJYyxaqtSICy5gsKVolKpwF6Y0yB5CsJo9Xi2bSPJTkaTXcxlEy3
	 36xfnr73lYyD41sdeHrN43xEQJtgt492KonUTFj22H+pbTJkvyzxfrFWtzRO1c09kS
	 PVEdredJwhGNq0GeXJVGRqr1Y1f1YuPApkKcF1A+KS7seW5No3bSaWm6mfCLQN7x9Z
	 vNV68TpU/ijsN+dc2MpUXNke39HcNbU8xllJFOHETrvaXUU11a7IteeUxMaclewCst
	 LQtUHU50v4RadXAfOCdrLXKWll2Dw+8Ywu6CK3JJXLLHlEdBeFL0Td2MfRy3EI9V0h
	 j7OlkeJym2/zQ==
Date: Mon, 2 Nov 2026 19:49:49 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Ard Biesheuvel <ardb+git@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Don't livelock when AT can't resolve a fault
 IPA
Message-ID: <aujpXU0ZAb8yCO3G@willie-the-truck>
References: <20261102094748.2638468-2-ardb+git@google.com>
 <auiXMN5td-2QlDkd@willie-the-truck>
 <CA+EHjTxVPyY70Dm+BiwgQQNwx1cJpEKvJBJGZWPCKLx2M8X2FA@mail.gmail.com>
 <86bj872n1b.wl-maz@kernel.org>
 <08db10ef-c3d8-44b8-9d80-e7505400bf12@app.fastmail.com>
 <86a4nr2i0k.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a4nr2i0k.wl-maz@kernel.org>

On Mon, Nov 02, 2026 at 06:41:15PM +0000, Marc Zyngier wrote:
> On Mon, 02 Nov 2026 18:23:09 +0000,
> "Ard Biesheuvel" <ardb@kernel.org> wrote:
> > My experiments seem to indicate that on this uarch, the AT instruction
> > does not hit in the TLB, and so it can fail on AF==0 for an IPA that
> > is covered by a S2-only TLB entry (with AF==1 and XN==1 due to lazy exec).
> > 
> > So after the VAAE1, the S1 walk happily produces the same translation
> > we just invalidated, without taking a S1PTW fault, and the guest faults
> > again on the I-fetch that took us to hyp the first time around.
> 
> Ah, I think I see what can happen, even without split TLBs.
> 
> If you have a S2 walk cache that skips the descriptor where AF=0, then
> the TLB refill just succeeds, and the cycle repeats. OK, I'm now
> convinced we need S2 invalidation as well even in the VA->PA case. We
> needed it for NV anyway, but hey...
> 
> Hopefully this doesn't happen too often.

Ard's observation in the commit message that kvm_mmu_notifier_clear_young()
doesn't do any TLB invalidation is also an interesting aspect to this, I
think. In that case, I don't think you need a particularly imaginative
TLB implementation: you just have AT always walking the S1 page-tables
in memory and seeing AF=0 at stage-2 when accessing a page-table page
whereas the MMU itself always hits in its (S2) TLB when doing the S1 walk.

For stage-1, we don't elide the TLBI quite like that -- instead, we elide
the trailing DSB (see __ptep_clear_flush_young() and the comment there).

Will
