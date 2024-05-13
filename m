Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCFF8286D
	for <kvmarm@lists.linux.dev>; Mon, 13 May 2024 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715635620; cv=none; b=UlbbwPa/1cOj5r1byd2gV1DTYCmgf3HKYd8cAcj2n7jOygnltlgtbkBxu/KXCXm8HBUi/j62wVAFi9nvuGfHRstoYZsOcvyJZj+DABSJevd0Tw6RDeSPwREm6VgmNRjXhGO7jeROePlElhq2rAJEZLeCquKorWjl+NGGAcNyccA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715635620; c=relaxed/simple;
	bh=rc5hMZJSGK5c1xFdPHd7Rb8V6zQm6y0iHDSXPea0qBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vn7AR95OTeKwq9bN2Di6r+WSuqy0kOehQDdz0Gi40MzC81uJm9gc77XoSidBqtUF6HQRmU5B5ntx/eSMlQb2QwPMqNG1erM9/dRD3hsagoUIDqPwhl80bfv0so6VQHBd17kzmE/jauGfILwwm7TP/6hJucWnyyx9MXz2EwW+6wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RP24kNmD; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RP24kNmD"
Date: Mon, 13 May 2024 21:26:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715635616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i7TDZt0L+IUvLZV757VcMzJBKk2TPSQV4UCOXzYOwuo=;
	b=RP24kNmDsiGLmdMUkB6uypxYB7086QfZt22D2thzkL+u0UKEh6f8+nAkC9EZAWg69xLW0T
	lZKthkvV5yUQpUVU7LetNpKw1i+mDLcIzQARiwiP5W3cTjqFYc9yfPXjg9B+ztOiX7i/4U
	XUTPizGuqgY13ZVTUrUtJWDy69pSKXc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Cornelia Huck <cohuck@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
Message-ID: <ZkKFmvZlFDzJ4Kka@linux.dev>
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
 <ZjKCgIyWqNKC6TUu@linux.dev>
 <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
 <ZjKRBcAML5T6cm4q@linux.dev>
 <ZjOl5hwU7yPXk8gs@shell.armlinux.org.uk>
 <ZjPDQSeQPE2wgVup@linux.dev>
 <87jzk4h5ir.fsf@redhat.com>
 <Zjuy40shK5a-yp95@linux.dev>
 <875xvlhfci.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875xvlhfci.fsf@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 10, 2024 at 05:11:09PM +0200, Cornelia Huck wrote:
> On Wed, May 08 2024, Oliver Upton <oliver.upton@linux.dev> wrote:
> > I'm willing to wager that the set of users who want to migrate state
> > from kernel N -> (N - 1) know the exact CPU definition they want to
> > expose to the guest, and in that case should be using a static set of
> > feature register values matching their intent.
> 
> I think the trouble starts when we introduce additional ranges of
> registers that can be controled via that interface -- old userspace will
> be able to figure out that there are more ranges available than what it
> is aware of, but will have no idea how to handle those additional ranges
> to get into a defined state (what is the actual range, for example?)

Even though the UAPI was designed around supporting multiple ranges, I
do not see this being an issue for quite some time. We already fully
describe the Feature ID register range from the architecture.

> >
> > Beyond the CPU architecture, KVM presents hypercall features to the VM
> > which userspace can _opt-out_ of on a per-feature basis using the
> > feature bitmap registers described in [2]. Like the feature ID
> > registers, we've preallocated a range of indices to be used for
> > hypercall bitmaps. So if an unexpected bitmap register appears on a new
> > kernel, userspace should write 0 to it to prevent new features from
> > silently creeping in.
> 
> Hm, the doc says: "The features for the registers that are untouched,
> probably because userspace isn’t aware of them, will be exposed as is to
> the guest." Seems to indicate that it is not too hard to get this wrong :)

Sure, but keep in mind the full range of possible Feature ID registers is
already known to userspace. Many of these register encodings are reserved,
RAZ to allow for future expansion of the architecture [*]. New registers
will come from one of these RAZ encodings.

If userspace wants to assert complete control over the CPU feature set
exposed to the VM it should use a pre-baked value for every register in
the range Op0=3, Op1=0, CRn=0, CRm={1-8}, Op2={0-8}.

[*] DDI0487J.a Table D18-2

> >
> > The canonical reason for this behavior, though, is that KVM/arm64
> > defaults to the maximum-possible feature set as discussed above.
> 
> /me contemplating "reverse" features, but too tired to think this
> through on a Friday afternoon.
> 

Reverse as in a negative / removed feature?

These tend to appear as negative ID register fields, to imply that the
feature set is less than what's provided for with a value of 0x0. KVM
probably couldn't start deprecating features in the default ID register
values but userspace could probe for features it can opt-out of using
the writable mask + trying to write -1 to a field.

DDI0487J.a D19.1.3 covers this.

-- 
Thanks,
Oliver
