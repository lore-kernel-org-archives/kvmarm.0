Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A043E0758
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779985697; cv=none; b=pjIAurUWFFbIql5eShlWWme1uYB9hlKRwhGIJ5Fp16Fa7iI0OFfqCJZ3sVg3h3wn/lrRrAjTXNXoqhHAIeXi8Lq2MvvWulrXysmy5YE7IszY2gqDUmKS6Y3blkF6WScNjHFCpfjq6HlLtuqqzC1l8KHj8d2jAcG37qisfach2q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779985697; c=relaxed/simple;
	bh=iphaj6GccxEteXGGchJc08ghkb3mc42SVzdR+A0PEhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgdFJQhuKPqkqtxIXLhWKjVon2DSYKYKGuyjUZYqeG0o4FTv4+tpOvUuRAmYqXEwtwlM4pe+ZB+0dEqy9kE2iHK3xVaRpkl2L4N86KAIN29yV4/3UmpRciU2gGrpgVgGejLpkqT9UKrieEmjOYNuOCeXOlb8af11vdnx9GxRPos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tj9tf664; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tj9tf664"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E09322EE;
	Thu, 28 May 2026 09:28:11 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFA7F3F905;
	Thu, 28 May 2026 09:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779985696; bh=iphaj6GccxEteXGGchJc08ghkb3mc42SVzdR+A0PEhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tj9tf664E9YbMlgJX4QuhVr0Z1S+i7bwqbiFSmvZj/sySTM7HUrF21KPItVEscAtb
	 fgE1P6nDereiN4tnqWyBRI8bR8wp47Sae/nXggVm1GjW6RfRBdNliQcBREkYGTOgxU
	 Cr4tYmFAECdAklgcYdSNmeO0leAPALvk+6jGl41w=
Date: Thu, 28 May 2026 17:28:12 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 00/18] arm64+KVM: FPSIMD/SVE/SME cleanups
Message-ID: <ahhtHCB-ZZrot25A@J2N7QTR9R3.cambridge.arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <9f95f8df-8c28-4c8c-b13e-87bc366f43a8@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f95f8df-8c28-4c8c-b13e-87bc366f43a8@arm.com>

On Thu, May 28, 2026 at 02:21:52PM +0100, Vladimir Murzin wrote:
> On 5/21/26 14:25, Mark Rutland wrote:

> > Mark Rutland (18):
> >   KVM: arm64: Don't include <asm/fpsimdmacros.h>
> >   KVM: arm64: Don't override FFR save/restore argument
> >   KVM: arm64: pkvm: Save host FPMR in host cpu context
> >   KVM: arm64: pkvm: Remove struct cpu_sve_state
> >   arm64: fpsimd: Fold sve_init_regs() into do_sve_acc()
> >   arm64: fpsimd: Remove sve_set_vq() and sme_set_vq()
> 
> This may be out of scope for the series, but I noticed that
> write_vl() and sve_cond_update_zcr_vq() might similarly benefit
> from using sysreg_clear_set_s()

Ah, yes. I failed to spot that, but I agree it'd be nice to do similar
there. Thanks for calling that out!

As Marc and Will wanted to queue this ASAP, I'll send v2 without that,
but I'll take a look at doing that atop.

Mark.
