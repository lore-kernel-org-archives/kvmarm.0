Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A422853EE
	for <kvmarm@lists.linux.dev>; Mon, 25 May 2026 18:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779734220; cv=none; b=Q9qJiSPH3P7Y7/rmvt0iRRoqjrvilutchHuhhKQD5WH1ES2XejtSC3CQqjS2dnn9uDGKNAIlOA6R8Bry5JFtm6QtcIp7+Pmg6ckqkaGKh9cHqTqAkMlOp5ukpDIUQQvO1pqdBBubMbtgMuTPOGhhmY/OTceluQdbIdtnoGU0FZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779734220; c=relaxed/simple;
	bh=ODB6xGlrwcnKH1QF6A1ykosIkQ2EzhR13IqQJwbKqp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWFtGuHy3ma1rdayaUeKQrhRQ88xSegh69+XJhJXMFjxro/3S3b6JCPJHTw9dUljQpvaXBXGsExRUEH5K0ErkG9KqoU/zeC2mYNdoOdy8574N0Y33xkQPlx8BOiqm3XmNHgvY54knNPjQOzDQWkf3DiYg+Wq+hS2yOEt45IUuqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i+preeWi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i+preeWi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFB931762;
	Mon, 25 May 2026 11:36:52 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F36053F7D8;
	Mon, 25 May 2026 11:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779734217; bh=ODB6xGlrwcnKH1QF6A1ykosIkQ2EzhR13IqQJwbKqp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i+preeWitGIDjHGugeq97y0YaB17KXp9ePoo2igRjc9TlECLgPrdtJTu55RbnmYJN
	 HArcqH8mhQ8Bfz8B/KwtuRolhz2uxRv34ZXNMWEG/ytMfMrWr6apqsZXdf4FcdNYW1
	 xlUYs2+tyskkO6qGxI9c6uCJWOmyf72vGPTTDEr8=
Date: Mon, 25 May 2026 19:36:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Preserve all guest ZCR_EL2.LEN values
Message-ID: <ahSWwl-uCv4ZW-nE@J2N7QTR9R3>
References: <20260522-kvm-arm64-fix-zcr-len-nv-v1-1-ec254e9078cf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522-kvm-arm64-fix-zcr-len-nv-v1-1-ec254e9078cf@kernel.org>

On Fri, May 22, 2026 at 07:00:04PM +0100, Mark Brown wrote:
> Since b3d29a823099 ("KVM: arm64: nv: Handle ZCR_EL2 traps") when guests
> write to ZCR_EL2 we have clamped the value of ZCR_EL2.LEN to be at most
> that configuring the maximum guest VL. This is not the behaviour the
> architecture documents for ZCR_EL2.LEN, the expectation is that all bits
> will be read as written. Further, writing values larger than the largest
> available vector length is part of the documented procedure for enumerating
> the supported vector lengths so we expect to see this happen in practice.
> 
> The reasoning for the current behaviour is not specifically articulated, my
> best guess is that it is intended to ensure that the guest can not see an
> effective VL greater than the maximum that has been configured. This can
> instead be achieved by configuring ZCR_EL2 when loading guest state:
> 
>  - When running at EL0 or EL1 configure ZCR_EL2.LEN to the minimum of the
>    guest ZCR_EL2.LEN and vcpu_sve_max_vq(vcpu)-1.
>  - When running at EL2 configure the maximum VL for the guest in
>    ZCR_EL2.LEN like we do for non-nested guests and load the guest
>    ZCR_EL2 into ZCR_EL1.
> 
> This will ensure that the guest sees both the ZCR_EL2.LEN value which it
> wrote and the effective VL that resulting from the values it has configured
> in ZCR_ELx.LEN.
> 
> Currently all other bits in ZCR_EL2 are either RES0 or RAZ/WI, values
> written are sanitised based on this.
> 
> Fixes: b3d29a823099 ("KVM: arm64: nv: Handle ZCR_EL2 traps")
> Signed-off-by: Mark Brown <broonie@kernel.org>

For context, I mentioned this potential problem to Mark, and described
this possible solution at:

  https://lore.kernel.org/linux-arm-kernel/af4bWxiOogfPz_dp@J2N7QTR9R3/

I said:

  AFAICT, none of the values for the SMCR_ELx.LEN and ZCR_ELx.LEN fields
  are reserved or unallocated. Thus all the bits of those fields should
  be stateful, and a read should observe the last value written,
  regardless of the effective value of the field.

  [...]

  Either what we're doing is wrong, or the architcture requires a
  clarification to say that values corresponding to unimplmented vector
  lengths are reserved.

Have we sought feedback from architects? While I said "*or* the
architcture requires a clarification", I think it should be clarified
more explicitly either way given that the pattern is unusual.

Given this is particularly subtle, please keep me in the loop when
speaking with architects about this.

Mark.
