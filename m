Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793629037;
	b=pgKkGnGLyVVGCXLIgtf9niYMcxzF1/Rw+FUZBq9xCk6oOTZXy9Qy16/L99CJBaM7cxtC
	 a2C3QwB88LH3KHHLR12eIOO9596r8n4TUxMhSBZ7VBRdH/vzlwjksRJxVfGBRsmWewSZQ
	 dT4T938vLuCE0e11ejtsJNCt1xNfW1FxPWaMEyGa/k6VqAs+i+zz417I3SBbCco6cTEtx
	 /bupGdf+E49pmKo3heaH0xg6MdSVuO4mnG30KC87KX0UXX1EhUIgJD6ZuKTSQWgxcGwyS
	 zwb+iZ0rcETWyGLbgwXB1pma8GELNRWsVZoGBkHwJQFDO4Bf5AlmNwOk3dKbgXCDKog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793629037;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GK/zYkbxN3VzWhtqC7xjmL7luflOc6FLP0sVUxCWVtk=;
	b=0sOF4/TW3y3aiGX9whfQrVv0veQclfR/BVbsszb7KNf8u0kiopho4LRBBt1L9NW5qT8W
	 w9Xm9BW8w0QeoVHGv/IZF7Ri1c84045Q0hTo2J81mydYqxvUnWurny+2A5ffFUPx6aOgI
	 E/SPgpCte3/vbeemrhXaGkYQCGCcZx8oCTbBzwlCIEv6e3BM3oAuTXmm46a4TzucIMrO6
	 qp5kEJtco48z2gvNFdcZ/yBSNDdaBiKSntSO+G4aXxhYMBc0B4N8ZeA4elkYjGItSuOnj
	 2L19Wb0nrof7wZwxofNJ9VHylFrS2LNkaARjMfpBwfFHNyEuksQQ9XwS55cAh77PJcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QYF5wnRL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA974606A33B
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QYF5wnRL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BEF1F00A16;
	Mon,  2 Nov 2026 14:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629036;
	bh=GK/zYkbxN3VzWhtqC7xjmL7luflOc6FLP0sVUxCWVtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QYF5wnRLn3/Kjp+T10uY3n4JfNN1Eu67yKdslXUOeWH2xWJflEuXY19aJmVA2tOXu
	 OEX25YRIFH/swIxrowWUdW05nA4tjobSWn4yu0prjH90eBZVn4qsX9q+GVNNkQVVOp
	 Dt8gVb23xnnaiS1rcPy6BiWy4+htQA/MHh/Ukgok722SNyIGbnHBjUuBaXq/d5jqsI
	 BH+AJMyuzVFFOUA0HWO4hLvPE9vionC6e+SpCKUDi/IoQlft65q+hZlTWX9Iy6r8uL
	 2+Lx3qgNiAvEe+r0yB3oDqpfPyAm38jZs8tLyPdXIEKp2lr0T+Z7T6Yv5W7P9GW6L8
	 Cb1CQ+ngDXKEA==
Date: Mon, 2 Nov 2026 14:17:10 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Don't livelock when AT can't resolve a fault
 IPA
Message-ID: <auibZqSgrijjigWM@willie-the-truck>
References: <20261102094748.2638468-2-ardb+git@google.com>
 <auiXMN5td-2QlDkd@willie-the-truck>
 <86fqxj2ulm.wl-maz@kernel.org>
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
In-Reply-To: <86fqxj2ulm.wl-maz@kernel.org>

On Mon, Nov 02, 2026 at 02:09:25PM +0000, Marc Zyngier wrote:
> On Mon, 02 Nov 2026 13:59:12 +0000,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Mon, Nov 02, 2026 at 10:47:49AM +0100, Ard Biesheuvel wrote:
> > > From: Ard Biesheuvel <ardb@kernel.org>
> 
> [...]
> 
> > > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > index e0c55644224c..4ba61b71d511 100644
> > > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > @@ -843,8 +843,21 @@ static inline bool kvm_hyp_handle_cp15_32(struct kvm_vcpu *vcpu, u64 *exit_code)
> > >  static inline bool kvm_hyp_handle_memory_fault(struct kvm_vcpu *vcpu,
> > >  					       u64 *exit_code)
> > >  {
> > > -	if (!__populate_fault_info(vcpu))
> > > +	if (!__populate_fault_info(vcpu)) {
> > 
> > Presumably we need a barrier (DSB?) here, to ensure that the TLBI happens
> > after the AT instruction?
> >
> > > +		/*
> > > +		 * The AT couldn't resolve the IPA, typically because its
> > > +		 * stage-1 walk took a stage-2 fault, such as an Access flag
> > > +		 * fault on an aged page-table page. If the guest still has a
> > > +		 * cached translation for the VA, it won't take that fault
> > > +		 * itself, and would replay the same permission fault forever.
> > > +		 * Drop this VMID's TLB entries on this CPU, so that the replay
> > > +		 * walks the page tables and faults with a valid HPFAR_EL2.
> > > +		 */
> > > +		__tlbi(vmalls12e1);
> > 
> > Can we get away with an ALLE1 here, or do we really need to blow away the
> > whole lot?
> 
> ALLE1 blows EL1 translations for all VMIDs, while VMALLS12E1 is
> localised to this VMID. Feels like the latter is the least invasive
> option.
> 
> Alternatively, VMALLE1 or even VAE1 should be enough to get rid of the
> S1 TLB.

Ah, sorry, VMALLE1 is what I meant to ask about. I basically haven't
understood the need to invalidate the stage-2.

Will
