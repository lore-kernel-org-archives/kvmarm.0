Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1592A1C84BC
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897783; cv=none; b=dtLOirBXhEpczYbODCQy95aq+5mY497TRKoGS+AVIGjM4BqYssi0IkAFL48QBoz2thO5drsvlCQvUhhGONBA+Wo18njMsuYAx54TG7kICHiI4id+L4aclfFzwMDP072KoTGnZpGQAAHidkswK8/n6Yqqflb+z4TMjqU2/meTIEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897783; c=relaxed/simple;
	bh=9aWYw2Ah14kwgPI8Hk+rKnAnhntsKh/W3j7keCQLUYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Keqt83bLEwolcWU06Wv49pNYSGuS7Ba5fyjIYXPXPfp0FOYH1r02TUtBh4ILJwyCcFu30rmYr0y0gqHbgRUhWEOC/FRWhqrGutVe1UxzJyLw3656QLeLzxv06bII4f3uT4XTb5IkDCt3YvquiKMwRgffS7CxUiJhptFIeyY32vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tbfTl/0P; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tbfTl/0P"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55FB635B9;
	Wed, 27 May 2026 09:02:56 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABBAE3F905;
	Wed, 27 May 2026 09:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779897781; bh=9aWYw2Ah14kwgPI8Hk+rKnAnhntsKh/W3j7keCQLUYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tbfTl/0P2ORJqDUfhfOk1zBM+esZIjrLwpPceD1IU4vaDdWwVfKOeNJnc5B4v64Rd
	 FRZlkDPHlLisd+4DkhDCY7ed473Cbx+9HpFDTy5NcrPAtxkHXmwa6ShgxkOdHjeezs
	 7avziFmaS1z4C+x6vEs2SdBAIP9oAN4kHe5YLOnM=
Date: Wed, 27 May 2026 17:02:57 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 04/18] KVM: arm64: pkvm: Remove struct cpu_sve_state
Message-ID: <ahcVsVGPtOmF0nIC@J2N7QTR9R3.cambridge.arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-5-mark.rutland@arm.com>
 <9670cf97-b844-4029-b77e-25ade600e024@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9670cf97-b844-4029-b77e-25ade600e024@arm.com>

On Wed, May 27, 2026 at 12:58:47PM +0100, Vladimir Murzin wrote:
> On 5/21/26 14:25, Mark Rutland wrote:
> > -struct cpu_sve_state {
> > -	__u64 zcr_el1;
> > -
> > -	/*
> > -	 * Ordering is important since __sve_save_state/__sve_restore_state
> > -	 * relies on it.
> > -	 */
> > -	__u32 fpsr;
> > -	__u32 fpcr;
> > -
> > -	/* Must be SVE_VQ_BYTES (128 bit) aligned. */
> > -	__u8 sve_regs[];
> 
> 
> It seems that the requirement (driven by SVE ldr/str) is
> satisfied with the new sve_regs pointing to the start of the
> page.
> 
> I'm not sure whether we want to keep the comment (or perhaps
> enforce this with explicit checks) so that future refactoring
> doesn't lead to time spent debugging alignment faults...

AFAICT alignment has never been functionally necessary. The LDR (vector)
and STR (vector) instructions only mandate alignment when the relevant
SCTLR_ELx has SCTLR_ELx.A==1. For kernel and hyp code we configure
SCTLR_ELx.A==0, so there's no alignment requirement.

Per ARM DDI 0487 M.b, section C8.2.437 "LDR (vector)":

  The load is performed as contiguous byte accesses, with no endian
  conversion and no guarantee of single-copy atomicity larger than a
  byte. However, *if alignment is checked*, then the base register must be
  aligned to 16 bytes.

Per ARM DDI 0487 M.b, section C8.2.777 "STR (vector)":

  The store is performed as contiguous byte accesses, with no endian
  conversion and no guarantee of single-copy atomicity larger than a
  byte. However, *if alignment is checked*, then the base register must be
  aligned to 16 bytes.

... and in both cases the pseudocode shows that AlignmentEnforced()
depends on the value of SCTLR_ELx.A.

Given that, I don't think we need the comment.

[...]

> FWIW,
> 
> Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

Thanks!

Mark.
