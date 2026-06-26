Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCD51A3160;
	Fri, 26 Jun 2026 10:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782471344; cv=none; b=KNKlZJjMV9fgxo1pHCHjUwOMhzThrb27BsezrhEhokiPKlushIXJPLBkNmajCbXIOy7DGsk6wz6il0imGgP1FNJ8aFXQ4leIDLcuJQPGWpe0YWURfV1WsoCubi6j6wZ/Ul4lsp6CiFN8zvce3oa+l+BeqfRPT23fEsdtQTfy864=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782471344; c=relaxed/simple;
	bh=WYkIcxyEZ03XvveCQgcQNurXYIgwRdu1XKvIge5swXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxjR1+0gtxJIdqvAc5dPHIiWimKu9h9pAo5sMiZ6QM5UjoRGdbBOPYK66AksEtL+QzMCx8gR2NEGy7uKdodEUCw2z3Ok7IYsfQk+k0SlayzmTPlfuAZyQFTOO6fIJ5LGES5n17DHe2wDXtU+tN/zQcj1ks6TkppSLWJGWqlkGco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfyLggfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfyLggfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890841F000E9;
	Fri, 26 Jun 2026 10:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782471343;
	bh=ONCcGd6ZlJNr1bN8d4F4ClrTccrd587NfTSM5w0oxJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GfyLggfPWAdZWacvjfH8rboMlo1IOYnUIXJA0CoLhVw8dMs6+XPDJsUya1SuQadkN
	 rd4VbdIu6cux/zcXSwlNQ6ILwpmJBcPGtlFQKQdqlKMTOni2smREFTzZePYyAiWv0U
	 zrUOa7PsjZxVkqKV51z0na/Tok1fOawfiKmtwwDsWfZyzT5L5ZOy2zYdK/qDrLZCBm
	 pxz+qqpHJaTnNLd6pfYFGYFNssuvOGECgtAErECjFZA9ZAoKhwnBHqZfcYZB42GL7m
	 AX9T5VE1Dhi49gAsNLyfcMU0D6JQIF2ufuw1Gx/aBrAZKROWmGQjcqr87As5g1GehW
	 EWktfONzWNYvQ==
Date: Fri, 26 Jun 2026 11:55:36 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v6 7/7] KVM: arm64: Enforce strict SBZ checks in the FF-A
 proxy
Message-ID: <aj5aqMyLGWw1IMAJ@willie-the-truck>
References: <20260626074545.433234-1-sebastianene@google.com>
 <20260626074545.433234-8-sebastianene@google.com>
 <aj5CMsyQ25xuxISV@willie-the-truck>
 <aj5FZBO7FJ4r219O@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aj5FZBO7FJ4r219O@google.com>

On Fri, Jun 26, 2026 at 09:24:52AM +0000, Sebastian Ene wrote:
> On Fri, Jun 26, 2026 at 10:11:14AM +0100, Will Deacon wrote:
> > On Fri, Jun 26, 2026 at 07:45:45AM +0000, Sebastian Ene wrote:
> > > Introduce a helper method ffa_check_unused_args_sbz to enforce strict
> > > arguments checking when the hypervisor acts as a relayer between the
> > > host and Trustzone.
> > > 
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 96 ++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 95 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > index 712811e89435..bd50ddc5b61c 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > @@ -74,6 +74,21 @@ static u32 hyp_ffa_version;
> > >  static bool has_version_negotiated;
> > >  static hyp_spinlock_t version_lock;
> > >  
> > > +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> > > +{
> > > +	DECLARE_REG(u32, func_id, ctxt, 0);
> > > +	int reg, end_reg = 7;
> > > +
> > > +	if (FFA_MINOR_VERSION(hyp_ffa_version) >= 2)
> > > +		end_reg = ARM_SMCCC_IS_64(func_id) ? 17 : 7;
> > 
> > This looks like an accident waiting to happen if we don't check the major
> > number as well.
> > 
> > I think you should just check:
> > 
> > 	if (hyp_ffa_version >= FFA_VERSION_1_2)
> > 
> > instead.
> > 
> > You should also add a comment.
> 
> We restrict hyp_ffa_version major to 1.0 here
> https://elixir.bootlin.com/linux/v7.1.1/source/arch/arm64/kvm/hyp/nvhe/ffa.c#L962
> but since this is an easy fix I will include it.

Thanks, Seb. I'm just certain that if/when we update that check, we'll
forget to update this bit at the same time (I know I would!). So doing
it now is the simplest thing.

With that change:

Acked-by: Will Deacon <will@kernel.org>

Will
