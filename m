Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CDE12B94;
	Thu, 27 Nov 2025 06:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764225832; cv=none; b=JnmAYTjOYJW5kb73qRgZX7KKsDz6MlAqBiHguG53eGu5F589qwT6d+QifQvHcuS0QPMqPagCUwg8eqZLeZQK2a9KRzMDYDFwHfwX4DNMS0yhZsEPgm+/DIwh87W2nlLZzelcVZ3wOyinXjTRqYaH4XdyZ8Yci2gfkLgx+zBU9gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764225832; c=relaxed/simple;
	bh=nJ1AksxvkgzgI5yArHPx9UP569L+VBn2SNhrNoTyxVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVtYjgc8Lkcr6f/sWWTT4VuvkYD+NsHCN3SoM0jO3blob0VMHPtDZbChdm0Usnwr6BhEzJ8QmvcsWP5OT4g61TQOvb68GPZcCiRAGCacMK2dLxkZOwCWETOLiIOUgoPla7DyQ7aDWzEgSuCFsiz9ZGZU/6+Gd9FcRKAosSyhz4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qySN6j7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qySN6j7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51061C4CEF8;
	Thu, 27 Nov 2025 06:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764225832;
	bh=nJ1AksxvkgzgI5yArHPx9UP569L+VBn2SNhrNoTyxVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qySN6j7BCWXiirX2iH/LbdQY7BIP5AOhi3DKO0XaIffn/BuecmPdQ0LTgTFiENeFq
	 9/JJxc9Jl7VZeJ63qj2hlNfnBm5PhhX/HHaRvyB0KdZy8os65NiC+CFYvCtCgsTKIY
	 /+POJMGyTBi1RHY6gjObEjdi9euL37hb6FfgOpuMtQFY41tZ+0SSM4e3Hzrb9KPV9C
	 of1CkzsjphU4N8MgwcJvIp9MSwdLZ7bw+f0D7Wh1EicNNTdrlmShRqOZcWwdRJG8w4
	 pPE2jVZA2R+3bqktm0J+WtRqITdWnWaNfk3WJcZy1VsRI/Nv/43GLz11YavGKBAt/a
	 7aKiQgm9c1kfA==
Date: Wed, 26 Nov 2025 22:43:51 -0800
From: Oliver Upton <oupton@kernel.org>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v2 4/5] KVM: arm64: Report optional ID register traps
 with a 0x18 syndrome
Message-ID: <aSfzJxBfdI17pyPD@kernel.org>
References: <20251126155951.1146317-1-maz@kernel.org>
 <20251126155951.1146317-5-maz@kernel.org>
 <dk6bwi72nwfty6qpbh2eaeubznqt74gjffas2rclrrwjn5tr6j@mjitrla3p3d7>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dk6bwi72nwfty6qpbh2eaeubznqt74gjffas2rclrrwjn5tr6j@mjitrla3p3d7>

On Thu, Nov 27, 2025 at 02:07:08PM +0800, Yao Yuan wrote:
> On Wed, Nov 26, 2025 at 03:59:50PM +0800, Marc Zyngier wrote:
> > With FEAT_IDST, unimplemented system registers in the feature ID space
> > must be reported using EC=0x18 at the closest handling EL, rather than
> > with an UNDEF.
> >
> > Most of these system registers are always implemented thanks to their
> > dependency on FEAT_AA64, except for a set of (currently) three registers:
> > GMID_EL1 (depending on MTE2), CCSIDR2_EL1 (depending on FEAT_CCIDX),
> > and SMIDR_EL1 (depending on SME).
> >
> > For these three registers, report their trap as EC=0x18 if they
> > end-up trapping into KVM and that FEAT_IDST is not implemented in the
> > guest. Otherwise, just make them UNDEF.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 2ca6862e935b5..7705f703e7c6d 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -82,6 +82,16 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
> >  			"sys_reg write to read-only register");
> >  }
> >
> > +static bool idst_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> > +			const struct sys_reg_desc *r)
> > +{
> > +	if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, 0x0))
> 
> Hi Marc,
> 
> Minor: maybe beter readability if use NI instead of 0x0, just like
> things in feat_nv2() below, but depends on you.

+1, using the ESR value as an identifier in the sysreg tables is just
terrible. This reads like a literal.

Thanks,
Oliver
