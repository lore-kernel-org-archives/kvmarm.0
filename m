Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1268B3FD13E
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 15:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779981032; cv=none; b=gvnofhHLXYrixJWKUi9vwuyoliLBqzO5VXiT2dUM5YNmfXeZCcSGs12h6bRRH4crr4xa6kmXQ9LKHNrYr6ads+fidVhdLcBa4Ngwpv2nIUVMwub7HhnzAthOQNG3yDAZgKxi/8PpDRqxvLH586j4Ex1PYhoVhIAhBGwS/kfz9i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779981032; c=relaxed/simple;
	bh=I6lBJNyqotuQp6rRRZ0DpHnxzL/Qyi1Z2gNSf4pkFPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQ9Y7zBrsQusy54Tx7EvOyWnxI0xsItojmtcH8TDFDgypz4AUx1oBa4p9c0dBQRNU7cDpmt7q1jDIKTwnjOpOP23kV1ZZ9IeJeY6m8X1rm8O7t4oPlG7JEqdxgFUehMfqdkt0E9O9LfLmx38biomKLBJJMa7i0ZvXHOawYL5gQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ub4ntYZw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ub4ntYZw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC6F522EE;
	Thu, 28 May 2026 08:09:25 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BBF03F632;
	Thu, 28 May 2026 08:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779980970; bh=I6lBJNyqotuQp6rRRZ0DpHnxzL/Qyi1Z2gNSf4pkFPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ub4ntYZwE7WBLfQcTQ4BZLAwd/jljkpHU7iuVrrqMxvTJIByM42USzhhbWXA7tf9T
	 5yRmFr61MZJ14HzbE4pMMyDNlfsZYPneK2r5TBYc0RmPRhHG2ZRv18falAOL3DKLpb
	 j4cWYvDMfaEugWj0wG0sIcqYhReA9+R7D2c3e2DQ=
Date: Thu, 28 May 2026 16:09:27 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
	maz@kernel.org, oupton@kernel.org, tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 04/18] KVM: arm64: pkvm: Remove struct cpu_sve_state
Message-ID: <ahhapwyfE7WrBCby@J2N7QTR9R3.cambridge.arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-5-mark.rutland@arm.com>
 <9670cf97-b844-4029-b77e-25ade600e024@arm.com>
 <ahcVsVGPtOmF0nIC@J2N7QTR9R3.cambridge.arm.com>
 <4e15c17e-06c0-414f-ae9d-210c70d1757f@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e15c17e-06c0-414f-ae9d-210c70d1757f@arm.com>

On Wed, May 27, 2026 at 05:11:26PM +0100, Vladimir Murzin wrote:
> On 5/27/26 17:02, Mark Rutland wrote:
> > On Wed, May 27, 2026 at 12:58:47PM +0100, Vladimir Murzin wrote:
> >> On 5/21/26 14:25, Mark Rutland wrote:
> >>> -struct cpu_sve_state {
> >>> -	__u64 zcr_el1;
> >>> -
> >>> -	/*
> >>> -	 * Ordering is important since __sve_save_state/__sve_restore_state
> >>> -	 * relies on it.
> >>> -	 */
> >>> -	__u32 fpsr;
> >>> -	__u32 fpcr;
> >>> -
> >>> -	/* Must be SVE_VQ_BYTES (128 bit) aligned. */
> >>> -	__u8 sve_regs[];
> >>
> >> It seems that the requirement (driven by SVE ldr/str) is
> >> satisfied with the new sve_regs pointing to the start of the
> >> page.
> >>
> >> I'm not sure whether we want to keep the comment (or perhaps
> >> enforce this with explicit checks) so that future refactoring
> >> doesn't lead to time spent debugging alignment faults...
> > AFAICT alignment has never been functionally necessary. The LDR (vector)
> > and STR (vector) instructions only mandate alignment when the relevant
> > SCTLR_ELx has SCTLR_ELx.A==1. For kernel and hyp code we configure
> > SCTLR_ELx.A==0, so there's no alignment requirement.
> > 
> > Per ARM DDI 0487 M.b, section C8.2.437 "LDR (vector)":
> > 
> >   The load is performed as contiguous byte accesses, with no endian
> >   conversion and no guarantee of single-copy atomicity larger than a
> >   byte. However, *if alignment is checked*, then the base register must be
> >   aligned to 16 bytes.
> > 
> > Per ARM DDI 0487 M.b, section C8.2.777 "STR (vector)":
> > 
> >   The store is performed as contiguous byte accesses, with no endian
> >   conversion and no guarantee of single-copy atomicity larger than a
> >   byte. However, *if alignment is checked*, then the base register must be
> >   aligned to 16 bytes.
> > 
> > ... and in both cases the pseudocode shows that AlignmentEnforced()
> > depends on the value of SCTLR_ELx.A.
> > 
> > Given that, I don't think we need the comment.
> > 
> 
> Thanks for explanation! Maybe worth mentioning in commit message that it never was
> a requirement? 

I've added the following to the commi message:

  I've dropped the comment regarding buffer alignment as AFAICT this was
  never necessary. The LDR/STR (vector) instructions only require this
  alignment when SCTLR_ELx.A==1, which is not the case for the kernel or
  hyp code. Nothing else depends on the alignment.

Mark.
