Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246503;
	b=csQoIoVSvDbYcPFDg+BYS/pzb+EOIYLn5utryAD2N39/vY5CvxKALGgs+Iwv5PkKrGhj
	 C/RmFJU3OhjpohAmZxn1QGMTh4gwNUyhmkxz8ac+xJQzjqnJ8Qbuxqym3YAnJL265zALU
	 yhxQx8X0mw4sb6KemtHCe+wArjb0nHQ0EtC/Hh2hrDZvvmzKTkC4rQtUzKMewYeXdgX30
	 uky/XMuJKj1fN7KaX3caGLSPbMOfOR9Rwlx3y2Jdvd9aC6Brnrc6TMFcteIGCcProVTD0
	 iCarkpIGS/bAcqY/QkPXq4G34EZTS48XScwo5giDqg2ph9pUemgE1K/J9kE7mVzwp8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246503;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=opx0VG9ecb1ZAvHS08KhX3RT0ToGX6Lfi28+6VjF+Kg=;
	b=f9hzk56q7aB8Hl4J6dN3h4+WmduJW5sx+Z3PQKe2h3j+4jdnVkGhvH+I9F4BYGFMGriM
	 M7UE/wsY+xkhZNgh+4X8O0ap44dUgeUHT2IsjippBVIZtJwyFXnAzGxNykpyE1ejXIfz3
	 GZolxnos0+L9iHUfUzmwdHxaogjxAgyytiXH05cxen8uaWEHGKxMnw4vz3nTToARbdpLs
	 2t7BkC1T4WT5waaDLQmqJP25NsfvEYQgEJv4V2vLUy3i6Pm3ZqcXGmJpffOdBQcGv7oGM
	 vLX7CJgiflO67CTD3PMEiMEoMhPC6yEhcLGmDNqKrYE4r6KGQz6sg8REKa6xUzTxQLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dpYHniFr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCE4606A331
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 17:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dpYHniFr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D051F008A1;
	Mon,  9 Nov 2026 17:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794246502;
	bh=opx0VG9ecb1ZAvHS08KhX3RT0ToGX6Lfi28+6VjF+Kg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dpYHniFr4QwHpwlKkUIahbulQxX1W6IMTbHvc7WaxYYpW3Oxz5iP+DCWfLAxLL593
	 +grbnALbaJHJ2jvN8kOiRvaPUCMVh9g29VIVfrn1enS1y1sf2bX3P6b/B2bTi7FZIn
	 RVFOeX1L3uQQnsME6IfHX46ognxM7rhLmHrZglWWjpCjGi0TmNMkJxQyo9XHFi0UmX
	 C1t8rYa3F6YvA2RCW3uZqNxA5jAsWeR6cEfbTJggJsSbz+7pUb9uOsjmnRhSpHqlRY
	 wMtIviObvIbZYluhTLlSeaM3DdnAVeuiYPK5p/omhWlmqzGGwKRrWi/Imsx1cEtHtA
	 bwQSW4Bh9EKFQ==
Date: Mon, 9 Nov 2026 09:48:21 -0800
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH 6/8] KVM: arm64: Add sys_reg_descs for remaining MTE CMO
 instructions
Message-ID: <avIHZW07QmWnl4m9@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org>
 <20261104192124.3932743-7-oupton@kernel.org>
 <avICtPQtRH108ILM@LeoBrasDK>
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
In-Reply-To: <avICtPQtRH108ILM@LeoBrasDK>

On Mon, Nov 09, 2026 at 05:28:20PM +0000, Leonardo Bras wrote:
> On Wed, Nov 04, 2026 at 11:21:22AM -0800, Oliver Upton wrote:
> > Filtering unsupported cache maintenance instructions from a guest relies
> > on either having a suitable FGU bit for the feature or a descriptor with
> > a visibility() hook.
> > 
> > MTE CMO instructions can be trapped by HCR_EL2.TPCP and lack a suitable
> > FGU. Add descriptors for the CMO instructions that UNDEF if MTE isn't
> > implemented for the VM.
> > 
> 
> I think I get the idea of using MTE_CMO_INSN(): having the visibility test 
> for MTE defined in the previous patch, which makes sense with the above 
> commit message: if !mte -> hidden, then on access it injects undefined.
> 
> Please help me understand the other way: if we have mte, then it calls the 
> 'access' callback, which is bad_cmo_trap(), which also inject undefined. 
> What is the goal here?

This is consistent with how we handle other unexpected traps, such as
registers that redirect into the VNCR. If we take a trap for one of
these instructions then either we UNDEF it early in triage or redirect
the trap to the L1 hypervisor.

Under no circumstance do we expect to handle the trap locally, i.e.
reach the ->access() function.

Thanks,
Oliver
 
> 
> > Signed-off-by: Oliver Upton <oupton@kernel.org>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index b45635471344..7f7a197a9ad6 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -4295,6 +4295,12 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  		.access = (access_fn),					\
> >  	}
> >  
> > +static bool bad_cmo_trap(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> > +			 const struct sys_reg_desc *r)
> > +{
> > +	return bad_trap(vcpu, p, r, "MTE CMO trap");
> > +}
> > +
> >  #define MTE_CMO_INSN(insn, access_fn)					\
> >  	{								\
> >  		SYS_DESC(SYS_##insn),					\
> > @@ -4304,7 +4310,9 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  
> >  static struct sys_reg_desc sys_insn_descs[] = {
> >  	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
> > +	MTE_CMO_INSN(DC_IGVAC, bad_cmo_trap),
> >  	MTE_CMO_INSN(DC_IGSW, access_dcsw),
> > +	MTE_CMO_INSN(DC_IGDVAC, bad_cmo_trap),
> >  	MTE_CMO_INSN(DC_IGDSW, access_dcsw),
> >  
> >  	SYS_INSN(AT_S1E1R, handle_at_s1e01),
> > @@ -4321,6 +4329,7 @@ static struct sys_reg_desc sys_insn_descs[] = {
> >  	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
> >  	MTE_CMO_INSN(DC_CIGSW, access_dcsw),
> >  	MTE_CMO_INSN(DC_CIGDSW, access_dcsw),
> > +	MTE_CMO_INSN(DC_CIGDVAPS, bad_cmo_trap),
> >  
> >  	SYS_INSN(TLBI_VMALLE1OS, handle_tlbi_el1),
> >  	SYS_INSN(TLBI_VAE1OS, handle_tlbi_el1),
> > @@ -4394,6 +4403,15 @@ static struct sys_reg_desc sys_insn_descs[] = {
> >  	SYS_INSN(TLBI_VALE1NXS, handle_tlbi_el1),
> >  	SYS_INSN(TLBI_VAALE1NXS, handle_tlbi_el1),
> >  
> > +	MTE_CMO_INSN(DC_CGVAC, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CGDVAC, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CGVAP, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CGDVAP, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CGVADP, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CGDVADP, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CIGVAC, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CIGDVAC, bad_cmo_trap),
> > +
> >  	SYS_INSN(AT_S1E2R, handle_at_s1e2),
> >  	SYS_INSN(AT_S1E2W, handle_at_s1e2),
> >  	SYS_INSN(AT_S12E1R, handle_at_s12),
> > -- 
> > 2.47.3
> > 
