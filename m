Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B20C364E84;
	Tue,  2 Jun 2026 17:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780422583; cv=none; b=CssIIQ0AvoMY/Xt7WC1xuPcdX42ogDcLzIIhciaGf85CvLbimc6lEmfQTPzY88DKPhrG81awO4vFsosLf4RWVDeNxrBSNKgwJg0xUJ00/7DnxC+VEhcqWlwn1U5ZUhTumOVoa7T1yUqzxe25QFemxRuZToCBt0hUe053HY+yTRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780422583; c=relaxed/simple;
	bh=I5i1xfO+gv8CrjMPywVeoHFCAe/X53UHBxVwURlaVN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KiVBZ/wji7EaOj81qMv9NS3Q+w/FT+4ZBZlRgAX6IYQ+VWzC0B3ftMprKcfDk1sdQZPiXVl+An0xW0IIP48omEAji3R3vRPyXKLpjJ9XuimZwpQfhI1Ywaysq93Wcb0QCd4B0F4PlSRzoW1sVq4uJRMN4B8EckCcSromAzz6TJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THcXnvnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THcXnvnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375831F00893;
	Tue,  2 Jun 2026 17:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780422582;
	bh=x3SSyL6XDPm0B1wSgJccpgK6c1F2MWcK3UMGOKWZ9yA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=THcXnvnh6bAvtnE2NpOON27TvODIIYnWcLsKAgn+KY/kcro/zOo3a/xoP0wb/Kvl6
	 g07daCyMzMxmmu5y+VgVYU6hAfhwdtpRtio6OXCL2dnEdrfZme0srbziRhsaRkjzIk
	 a7OuaqvL5FrPBrMlKPzTC9daOtEVWYcHrRjK5l9zZlPLbfWQZhzAiwLhaANRKtu03k
	 1g76msvXjZzSFueZUKcdX7zpvJdcSkDdA0NKhxtaPqRp+OrJeauRJe5uZXAe3MLjtK
	 R0bSNeUCFGmCslHSNglwula4bcpSmrtZZ1CqTjzU3QR4g3LExcIWlfeebEXL6EeIwW
	 qrzg/4Q/D1K1A==
Date: Tue, 2 Jun 2026 10:49:41 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM: arm64: FEAT_{S1POE,ATS1A} support fixes
Message-ID: <ah8Xtf7zvyTT5MJ6@kernel.org>
References: <20260602155430.2088142-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602155430.2088142-1-maz@kernel.org>

On Tue, Jun 02, 2026 at 04:54:26PM +0100, Marc Zyngier wrote:
> Whilst working on a slightly unrelated feature (FEAT_NV3), I found out
> that an L2 guest wouldn't boot if the host was exposed to FEAT_S1POE.
> 
> Upon investigation (and hours wasted in a SW model), it became
> apparent that while the AT S1E1A code was ready for action, it had
> never been fully plugged in (blame the usual suspect...).
> 
> This resulted in an extremely odd failure mode, with an L2 being
> unable to make forward progress, but KVM at L1 not taking the hint
> that something was really wrong. Additionally, an embarrassing typo
> was spotted in the CPTR_EL2 handling.
> 
> With this in, FEAT_S1POE no longer breaks our NV guests.
> 
> Marc Zyngier (3):
>   KVM: arm64: Key CPTR_EL2.E0POE propagation on FEAT_S1POE
>   KVM: arm64: Wire AT S1E1A in the system instruction handling table
>   arm64: cpufeature: Expose ID_AA64ISAR2_EL1.ATS1A to KVM

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

>  arch/arm64/kernel/cpufeature.c          | 1 +
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>  arch/arm64/kvm/sys_regs.c               | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> -- 
> 2.47.3
> 
