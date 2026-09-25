Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4A841DE11
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790335213; cv=none; b=WSilv81CcXWtqnbJnU5Gz9SMVwbLCA4hEnoKXj8aMr4fIoLOfv+hAdwdsYrbYkW77GOFG0azIb1/WW4nS38OhZXYjeWGsMV0ZOeH6602oyqnZUnKbt45bnVjiPDqC7Q5VZszQWN/jooBBPxlsh70aU9V0SBu13XVs+4Y6gtxg64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790335213; c=relaxed/simple;
	bh=cgOS7jP9kkfe78fXsHlB/+DFmonmC9ccQeudAwE3tGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=KXl4QqG9pycRSUMQIX7Ye5q6EYRVEXXJnqxp3dhWWGMO0lnSfBLerzQGTMROq0+dUTJAxP3oK8lJRUXCj6SQJVK1wvAQWNEt6r+/pbjd50FCVZT0y0F4Kjz6HWD7Q/kmKx7GuzpgRhodaZ2RPI669Q9PpzwYs9eCuguOXhBDeKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L6HIF27N; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L6HIF27N"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A909169C;
	Fri, 25 Sep 2026 04:20:07 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CBA53F86F;
	Fri, 25 Sep 2026 04:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790335210; bh=cgOS7jP9kkfe78fXsHlB/+DFmonmC9ccQeudAwE3tGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6HIF27NoYm7OotT8apQjAVWaqKCL4v4Ct/EwmKNf2m0L75EIyUZAkvrWG98JLUNS
	 merBvN0DcDhAKGlAD4DH1EcIgKBjC8pD6R19hGpd1NaSQvznP+GG1GmKWUOKJBce30
	 eV+r+qLPm9YRDNM0XCtqi0Vgum51KF/rcjgsHcNw=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 11/22] KVM: arm64: Use a struct for stage-1 walk context
Date: Fri, 25 Sep 2026 12:20:07 +0100
Message-ID: <arZY5g9EJRW3Vh5k@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arQ1OiEQjAtWwiDy@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-12-oupton@kernel.org> <arQGa54nNYBokQ8F@LeoBrasDK> <arQ1OiEQjAtWwiDy@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 23, 2026 at 01:23:22PM -0700, Oliver Upton wrote:
> On Wed, Sep 23, 2026 at 06:03:39PM +0100, Leonardo Bras wrote:
> > > @@ -482,15 +490,15 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> > >  	while (1) {
> > >  		u64 index;
> > >  
> > > -		va_bottom = (3 - level) * stride + wi->pgshift;
> > > +		va_bottom = (3 - ws.level) * stride + wi->pgshift;
> > >  		index = (va & GENMASK_ULL(va_top, va_bottom)) >> (va_bottom - 3);
> > >  
> > > -		ipa = baddr | index;
> > > +		ws.desc_ipa = ws.desc_pa = baddr | index;
> > >  
> > >  		if (wi->s2) {
> > >  			struct kvm_walk_access s2_access = {
> > >  				.type	= WALK_ACCESS_S1PTW,
> > > -				.ia	= ipa,
> > > +				.ia	= ws.desc_ipa,
> > 
> > I only see desc_ipa being used here, and at this point, desc_ipa is the 
> > same as desc_pa, and we are copying it's value to this new struct.
> 
> This distinction is intentional, we overloaded @ipa to mean either the
> IPA of the descriptor or the PA of the descriptor depending on the
> presence of a stage-2 && where we are in the PTW.
> 
> I'm happy to burn another 8 bytes if it means the code is legible and
> more easily debuggable with something like bpftrace.

Oh, ok, I see the point now.

Thanks!
Leo
